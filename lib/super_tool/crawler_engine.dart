import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:flutter/material.dart';
import 'package:miko/models/data_safer.dart';

import 'super_tool_result.dart';
import 'session_manager.dart';

typedef ProgressCb =
    void Function({
      required int visited,
      required int queued,
      required int hits,
    });

class CrawlerEngine {
  final DataPlaceConfig cfg;

  CrawlerEngine(this.cfg);

  // control flags
  final _stop = ValueNotifier<bool>(false);
  final _paused = ValueNotifier<bool>(false);

  void requestStop() => _stop.value = true;
  void setPaused(bool v) => _paused.value = v;

  Future<SuperToolResult> runConcurrent({
    CrawlerSessionState? resumeState,
    ProgressCb? onProgress,
    void Function(String log)? onLog,
  }) async {
    final start = DateTime.now();
    final io = HttpClient()..connectionTimeout = const Duration(seconds: 20);
    final visited = resumeState?.visited ?? <String>{};
    final queue = <String>[];
    final hits = <CrawlHit>[];
    if (resumeState == null) {
      queue.addAll(cfg.baseUrls);
    } else {
      queue.addAll(resumeState.queue);
      for (final h in resumeState.hits) {
        hits.add(
          CrawlHit(
            url: h['url']?.toString() ?? '',
            quality: h['quality']?.toString(),
            series: h['series']?.toString(),
            episode: h['episode']?.toString(),
          ),
        );
      }
    }

    final basePaths = cfg.baseUrls;

    bool isIncluded(String url) {
      if (cfg.includeConfig.listIncludedPath.isNotEmpty &&
          !cfg.includeConfig.listIncludedPath.any((p) => url.contains(p)))
        return false;
      if (cfg.includeConfig.listIncludedRegex.isNotEmpty &&
          !cfg.includeConfig.listIncludedRegex.any(
            (r) => RegExp(r).hasMatch(url),
          ))
        return false;
      if (cfg.includeConfig.listIncludedKeyWord.isNotEmpty &&
          !cfg.includeConfig.listIncludedKeyWord.any(
            (k) => url.toLowerCase().contains(k.toLowerCase()),
          ))
        return false;
      return true;
    }

    bool isExcluded(String url) {
      if (cfg.excludeConfig.listExcludedPath.any((p) => url.contains(p)))
        return true;
      if (cfg.excludeConfig.listExcludedRegex.any(
        (r) => RegExp(r).hasMatch(url),
      ))
        return true;
      if (cfg.excludeConfig.listExcludedKeyWord.any(
        (k) => url.toLowerCase().contains(k.toLowerCase()),
      ))
        return true;
      return false;
    }

    bool matchesExt(String url) {
      if (cfg.extOfFileYouNeed.isEmpty) return true;
      final lower = url.toLowerCase().split('?').first;
      return cfg.extOfFileYouNeed.any((e) => lower.endsWith(e.toLowerCase()));
    }

    String abs(String base, String maybe) {
      try {
        final bu = Uri.parse(base);
        final u = Uri.parse(maybe);
        if (u.hasScheme) return u.toString();
        return bu.resolveUri(u).toString();
      } catch (_) {
        return maybe;
      }
    }

    Future<String?> fetch(String url) async {
      try {
        final req = await io.getUrl(Uri.parse(url));
        req.headers.set('user-agent', 'Mozilla/5.0 (Flutter SuperTool)');
        req.headers.set(
          'accept',
          'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
        );
        final resp = await req.close();
        if (resp.statusCode >= 200 && resp.statusCode < 300) {
          return await utf8.decoder.bind(resp).join();
        }
      } catch (e) {
        onLog?.call('Fetch error: $e');
      }
      return null;
    }

    final queueLock = Object();
    final hitsLock = Object();

    Future<void> worker(int id) async {
      while (!_stop.value) {
        // pause gate
        while (_paused.value && !_stop.value) {
          await Future.delayed(const Duration(milliseconds: 150));
        }
        String? url;
        // pop from queue
        // ignore: literal_only_boolean_expressions
        if (true) {
          // atomic section
          if (queue.isEmpty) break;
          url = queue.removeAt(0);
          if (visited.contains(url)) {
            // continue to next
            if (queue.isEmpty) break;
            continue;
          }
          visited.add(url);
        }

        if (url == null) break;
        final html = await fetch(url);
        if (html == null) {
          onProgress?.call(
            visited: visited.length,
            queued: queue.length,
            hits: hits.length,
          );
          continue;
        }

        final bs = BeautifulSoup(html);
        // anchors
        for (final a in bs.findAll('a', attrs: {'href': true})) {
          final href = a['href']?.toString() ?? '';
          if (href.isEmpty) continue;
          final full = abs(url, href);

          if (basePaths.isNotEmpty &&
              !basePaths.any((p) => full.startsWith(p))) {
            continue;
          }
          if (isExcluded(full) || !isIncluded(full)) continue;

          final p = Uri.tryParse(full);
          final path = p?.path ?? '';
          final isDir = path.endsWith('/');

          if (isDir) {
            // enqueue
            if (!visited.contains(full)) {
              // synchronized add
              queue.add(full);
            }
          } else {
            if (matchesExt(full)) {
              final lower = full.toLowerCase();
              String? q;
              if (RegExp(r'1080p').hasMatch(lower))
                q = '1080p';
              else if (RegExp(r'720p').hasMatch(lower))
                q = '720p';
              else if (RegExp(r'540p').hasMatch(lower))
                q = '540p';
              else if (RegExp(r'480p').hasMatch(lower))
                q = '480p';
              String? ep;
              final m1 = RegExp(
                r's(\d+)e(\d+)',
                caseSensitive: false,
              ).firstMatch(lower);
              if (m1 != null) {
                ep =
                    'S${int.parse(m1.group(1)!).toString().padLeft(2, '0')}E${int.parse(m1.group(2)!).toString().padLeft(2, '0')}';
              }
              // add hit
              // ignore: literal_only_boolean_expressions
              if (true) {
                hits.add(CrawlHit(url: full, quality: q, episode: ep));
              }
            }
          }
        }

        onProgress?.call(
          visited: visited.length,
          queued: queue.length,
          hits: hits.length,
        );

        if (cfg.deley > 0) {
          await Future.delayed(
            Duration(milliseconds: (cfg.deley * 1000).toInt()),
          );
        }

        // safety cap
        if (!cfg.unStop && visited.length > cfg.worker * 10000) {
          onLog?.call('Safety stop: too many pages visited.');
          break;
        }
      }
    }

    // spawn pool
    final poolSize = cfg.worker.clamp(1, 64);
    final futures = <Future<void>>[];
    for (var i = 0; i < poolSize; i++) {
      futures.add(worker(i));
    }
    await Future.wait(futures);

    io.close(force: true);
    final end = DateTime.now();

    return SuperToolResult(
      strategyUsed: 'webPath(concurrent)',
      hits: hits,
      posts: const [],
      summary: {
        'visited': visited.length,
        'hits': hits.length,
        'durationMs': end.difference(start).inMilliseconds,
      },
      assetsByType: const {},
    );
  }
}
