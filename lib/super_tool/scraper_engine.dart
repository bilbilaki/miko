import 'dart:async';

import 'package:miko/models/data_safer.dart';

import '../services/scrape_service.dart';
import 'super_tool_result.dart';

class ScraperEngine {
  final DataPlaceConfig cfg;
  final ScrapeServiceWorker pool;

  ScraperEngine(this.cfg) : pool = ScrapeServiceWorker();

  Future<SuperToolResult> run() async {
    final start = DateTime.now();
    final posts = <PostItem>[];
    final assetsMerged = <String, List<String>>{};
    final css =
        cfg.includeConfig.htmlConfigYouNeedIncluded?.listCssPaths ?? const [];
    final ids =
        cfg.includeConfig.htmlConfigYouNeedIncluded?.listIds ?? const [];
    final classes =
        cfg.includeConfig.htmlConfigYouNeedIncluded?.listClass ?? const [];
    final tags =
        cfg.includeConfig.htmlConfigYouNeedIncluded?.listTags ?? const [];

    List<String> buildSelectors() {
      final sels = <String>[];
      sels.addAll(css);
      sels.addAll(ids.map((e) => '#$e'));
      sels.addAll(classes.map((e) => '.$e'));
      sels.addAll(tags);
      if (sels.isEmpty) {
        // default heuristics
        sels.addAll([
          'article.post2',
          'article',
          '.multiple-link-wrapper',
          '.home-rows-videos-div',
        ]);
      }
      return sels;
    }

    final selectors = buildSelectors();

    for (final url in cfg.baseUrls) {
      try {
        final html = await pool.fetchHtmlIo(url);
        // extract posts
        final p = await pool.extractPosts(html, url, cssSelectors: selectors);
        for (final m in p) {
          posts.add(
            PostItem(
              url: (m['url'] as String?) ?? '',
              title: (m['title'] as String?) ?? '',
              poster: (m['poster'] as String?) ?? '',
              overview: (m['overview'] as String?) ?? '',
              meta: Map<String, dynamic>.from((m['meta'] as Map?) ?? const {}),
            ),
          );
        }
        // assets
        final a = await pool.extractLinksAndAssets(html, url);
        a.forEach((k, v) {
          assetsMerged.putIfAbsent(k, () => <String>[]).addAll(v);
        });
        if (!cfg.unStop) break; // process first URL unless unStop
      } catch (_) {
        // ignore URL errors
      }
      if (cfg.deley > 0) {
        await Future.delayed(
          Duration(milliseconds: (cfg.deley * 1000).toInt()),
        );
      }
    }

    final end = DateTime.now();
    return SuperToolResult(
      strategyUsed: 'webPage',
      posts: posts,
      hits: const [],
      summary: {
        'posts': posts.length,
        'durationMs': end.difference(start).inMilliseconds,
      },
      assetsByType: assetsMerged,
    );
  }

  void dispose() {
    pool.stop();
  }
}
