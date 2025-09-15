import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:dart_web_scraper/dart_web_scraper.dart';
import 'package:squadron/squadron.dart';
import 'scrape_service.activator.g.dart';

part 'scrape_service.worker.g.dart';

@SquadronService(baseUrl: '~/workers', targetPlatform: TargetPlatform.vm | TargetPlatform.web)
base class ScrapeService {
  @SquadronMethod()
  FutureOr<String> ping() => 'ok';

  // Fetch HTML using dart:io, optionally via SOCKS5 (reliable across platforms).
  @SquadronMethod()
  Future<String> fetchHtmlIo(String url, {String? socksHost, int? socksPort,String? userAgent, Map<String, String>? headers}) async {
    final io = HttpClient();
    try {
      if (socksHost != null && socksHost.isNotEmpty) {
        // You can pass through proxy by attaching socks_proxy at caller side to this client if needed
        // Keeping plain client here for worker portability; headers mimic browser.
      }
      io.connectionTimeout = const Duration(seconds: 20);
      final req = await io.getUrl(Uri.parse(url));
      final h = {
        'user-agent': userAgent??headers?['user-agent'] ??
            'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120 Safari/537.36',
        'accept': headers?['accept'] ??
            'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
        ...?headers,
      };
      h.forEach((k, v) => req.headers.set(k, v));
      final resp = await req.close();
      if (resp.statusCode < 200 || resp.statusCode >= 300) {
        throw Exception('HTTP ${resp.statusCode} for $url');
      }
      final body = await utf8.decoder.bind(resp).join();
      return body;
    } finally {
      io.close(force: true);
    }
  }

  // Extract links & assets quickly (anchors, images, videos, audio, documents)
  @SquadronMethod()
  Future<Map<String, List<String>>> extractLinksAndAssets(String html, String baseUrl) async {
    final bs = BeautifulSoup(html);
    String abs(String? href) {
      if (href == null || href.trim().isEmpty) return '';
      try {
        final u = Uri.parse(href.trim());
        if (u.hasScheme) return u.toString();
        final b = Uri.parse(baseUrl);
        return b.resolveUri(u).toString();
      } catch (_) {
        return href.trim();
      }
    }

    final result = <String, Set<String>>{
      'anchors': {},
      'images': {},
      'videos': {},
      'audio': {},
      'documents': {},
    };

    for (final a in bs.findAll('a', attrs: {'href': true})) {
      final href = abs(a['href']?.toString());
      if (href.isEmpty) continue;
      result['anchors']!.add(href);
      final low = href.toLowerCase();
      if (low.endsWith('.pdf') ||
          low.endsWith('.doc') ||
          low.endsWith('.docx') ||
          low.endsWith('.csv') ||
          low.endsWith('.xlsx') ||
          low.endsWith('.zip') ||
          low.endsWith('.rar') ||
          low.endsWith('.7z') ||
          low.endsWith('.txt') ||
          low.endsWith('.xml') ||
          low.endsWith('.json')) {
        result['documents']!.add(href);
      }
      if (low.endsWith('.mp4') ||
          low.endsWith('.webm') ||
          low.endsWith('.mov') ||
          low.endsWith('.avi') ||
          low.endsWith('.wmv')) {
        result['videos']!.add(href);
      }
      if (low.endsWith('.mp3') ||
          low.endsWith('.wav') ||
          low.endsWith('.flac') ||
          low.endsWith('.aac')) {
        result['audio']!.add(href);
      }
    }

    for (final img in bs.findAll('img')) {
      final src = img['src']?.toString() ??
          img['data-src']?.toString() ??
          img['data-lazy-src']?.toString();
      final u = abs(src);
      if (u.isNotEmpty) result['images']!.add(u);
    }

    for (final v in bs.findAll('video')) {
      final src = v['src']?.toString();
      final u = abs(src);
      if (u.isNotEmpty) result['videos']!.add(u);
      for (final s in v.findAll('source')) {
        final su = abs(s['src']?.toString());
        if (su.isNotEmpty) result['videos']!.add(su);
      }
    }
    for (final a in bs.findAll('audio')) {
      final src = a['src']?.toString();
      final u = abs(src);
      if (u.isNotEmpty) result['audio']!.add(u);
      for (final s in a.findAll('source')) {
        final su = abs(s['src']?.toString());
        if (su.isNotEmpty) result['audio']!.add(su);
      }
    }

    return result.map((k, v) => MapEntry(k, v.toList()));
  }
  @SquadronMethod()
  Future<List<String>> bs4Query(
    String html, {
    String selector = 'a',
    bool text = false,
  }) async {
    final bs = BeautifulSoup(html);
    // bs.find('', selector: css)
    final root = bs.find('', selector: selector);
    if (root == null) return [];
    final results = <String>[];
    if (text) {
      results.add(root.text);
      for (final el in root.findAll('*')) {
        results.add(el.text);
      }
    } else {
      results.add(root.toString());
      for (final el in root.findAll('*')) {
        results.add(el.toString());
      }
    }
    return results;
  }


  // Extract "posts" using heuristics or CSS selectors, with meta and tags
  @SquadronMethod()
  Future<List<Map<String, Object?>>> extractPosts(
    String html,
    String baseUrl, {
    List<String> cssSelectors = const [
      'article.post2',
      'article.w-grid-item',
      'article',
      '.multiple-link-wrapper',
      '.home-rows-videos-div'
    ],
  }) async {
    final bs = BeautifulSoup(html);
    String abs(String? href) {
      if (href == null || href.trim().isEmpty) return '';
      try {
        final u = Uri.parse(href.trim());
        if (u.hasScheme) return u.toString();
        final b = Uri.parse(baseUrl);
        return b.resolveUri(u).toString();
      } catch (_) {
        return href.trim();
      }
    }

    final posts = <Map<String, Object?>>[];
    final seen = <String>{};

    Iterable<Bs4Element> selectAll() sync* {
      for (final sel in cssSelectors) {
        final found = bs.findAll('', selector: sel);
        for (final e in found) yield e;
      }
    }

    for (final el in selectAll()) {
      try {
        final a = el.find('a', attrs: {'href': true});
        final href = abs(a?['href']?.toString());
        if (href.isEmpty) continue;
        if (seen.contains(href)) continue;

        String title = '';
        final h = el.find('h1') ?? el.find('h2') ?? el.find('h3');
        if (h != null) {
          title = h.text.trim();
        }
        if (title.isEmpty && a != null) {
          title = a.text.trim();
        }
        String poster = '';
        final img = el.find('img');
        if (img != null) {
          poster = abs(img['src']?.toString() ??
              img['data-src']?.toString() ??
              img['data-lazy-src']?.toString());
        }
        String desc = '';
        final p = el.find('p');
        if (p != null) desc = p.text.trim();

        final meta = <String, Object?>{};
        for (final m in el.findAll('meta')) {
          final name = m['name']?.toString() ?? m['property']?.toString();
          final content = m['content']?.toString();
          if (name != null && content != null) meta[name] = content;
        }

        posts.add({
          'title': title,
          'url': href,
          'poster': poster,
          'overview': desc,
          'meta': meta,
        });
        seen.add(href);
      } catch (_) {
        // ignore malformed item
      }
    }

    // Fallback: scan anchors if none found
    if (posts.isEmpty) {
      for (final a in bs.findAll('a', attrs: {'href': true})) {
        final href = abs(a['href']?.toString());
        if (href.isEmpty || seen.contains(href)) continue;
        final t = a.text.trim();
        posts.add({
          'title': t,
          'url': href,
          'poster': '',
          'overview': '',
          'meta': const {},
        });
        seen.add(href);
      }
    }

    return posts;
  }

  // Run dart_web_scraper with JSON config for advanced scenarios
  @SquadronMethod()
  Future<Map<String, Object>> runWebScraper({
    required String url,
    required Map<String, Object> scraperConfigJson,
    Map<String, String>? overrideHeaders,
    String? userAgent,
  }) async {
    final config = ScraperConfig.fromJson(scraperConfigJson.toString());
    final scraper = WebScraper();
    final result = await scraper.scrape(
      url: Uri.parse(url),
      scraperConfig: config,
      overrideHeaders: {
        if (userAgent != null && userAgent.isNotEmpty) 'User-Agent': userAgent,
        ...?overrideHeaders,
      },
    );
    return result;
  }
}