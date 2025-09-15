import 'dart:io';

import 'package:miko/functions/data_storage.dart';
import 'package:miko/models/data_safer.dart';

import 'crawler_engine.dart';
import 'scraper_engine.dart';
import 'super_tool_result.dart';
import 'result_writer.dart';

class SuperToolRunner {
  final DataPlaceConfig cfg;
  final TabularDataStore? store; // optional persistence
  final String datasetNamePrefix;
  final bool writeToDisk;
  final bool buildDirTree;
  final Directory? outDir;

  SuperToolRunner({
    required this.cfg,
    this.store,
    this.datasetNamePrefix = 'SuperTool',
    this.writeToDisk = false,
    this.buildDirTree = false,
    this.outDir,
  });

  Future<SuperToolResult> run() async {
    SuperToolResult? res;

    if (cfg.strategy == ScenarioOfDataplacing.webPage) {
      res = await ScraperEngine(cfg).run();
      if ((res.posts.isEmpty && cfg.unStop == false) &&
          (cfg.strategy == ScenarioOfDataplacing.findAWay ||
              cfg.strategy == ScenarioOfDataplacing.useAI)) {
        // fallback to webPath
        res = await CrawlerEngine(cfg).runConcurrent();
        res = SuperToolResult(
          strategyUsed: 'fallback(webPath)',
          hits: res.hits,
          posts: const [],
          summary: res.summary,
          assetsByType: res.assetsByType,
        );
      }
    } else if (cfg.strategy == ScenarioOfDataplacing.webPath) {
      res = await CrawlerEngine(cfg).runConcurrent();
      if ((res.hits.isEmpty && cfg.unStop == false) &&
          (cfg.strategy == ScenarioOfDataplacing.findAWay ||
              cfg.strategy == ScenarioOfDataplacing.useAI)) {
        // fallback to webPage
        res = await ScraperEngine(cfg).run();
        res = SuperToolResult(
          strategyUsed: 'fallback(webPage)',
          hits: const [],
          posts: res.posts,
          summary: res.summary,
          assetsByType: res.assetsByType,
        );
      }
    } else {
      // findAWay: try scraper then crawler
      final s = await ScraperEngine(cfg).run();
      if (s.posts.isNotEmpty) {
        res = s;
      } else {
        res = await CrawlerEngine(cfg).runConcurrent();
        res = SuperToolResult(
          strategyUsed: 'fallback(webPath)',
          hits: res.hits,
          posts: const [],
          summary: res.summary,
          assetsByType: res.assetsByType,
        );
      }
    }

    // Persist if asked
    if (store != null) {
      if (res.hits.isNotEmpty) {
        final td = res.toTabularForHits();
        await store!.save(
          td,
          name: '$datasetNamePrefix-Hits-${DateTime.now().toIso8601String()}',
        );
      }
      if (res.posts.isNotEmpty) {
        final td = res.toTabularForPosts();
        await store!.save(
          td,
          name: '$datasetNamePrefix-Posts-${DateTime.now().toIso8601String()}',
        );
      }
    }

    // Write files if requested
    if (writeToDisk) {
      final dir =
          outDir ??
          Directory(
            '${Directory.current.path}/supertool_${DateTime.now().millisecondsSinceEpoch}',
          );
      final writer = ResultWriter(dir, directoryTree: buildDirTree);
      await writer.writeSummaryJson(res);
      if (res.hits.isNotEmpty) await writer.writeHitsCsv(res);
      if (res.posts.isNotEmpty) await writer.writePostsCsv(res);
      await writer.writeDirectoryTree(res);
    }

    return res;
  }
}
