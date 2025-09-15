import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'super_tool_result.dart';

class ResultWriter {
  final Directory baseDir;
  final bool directoryTree;

  ResultWriter(this.baseDir, {this.directoryTree = false});

  Future<void> ensureBase() async {
    if (!await baseDir.exists()) {
      await baseDir.create(recursive: true);
    }
  }

  Future<File> writeHitsCsv(
    SuperToolResult res, {
    String name = 'hits.csv',
  }) async {
    await ensureBase();
    final rows = <List<dynamic>>[
      ['url', 'quality', 'series', 'episode'],
    ];
    for (final h in res.hits) {
      rows.add([h.url, h.quality ?? '', h.series ?? '', h.episode ?? '']);
    }
    final csv = const ListToCsvConverter().convert(rows);
    final f = File('${baseDir.path}/$name');
    await f.writeAsString(csv);
    return f;
  }

  Future<File> writePostsCsv(
    SuperToolResult res, {
    String name = 'posts.csv',
  }) async {
    await ensureBase();
    final rows = <List<dynamic>>[
      ['url', 'title', 'poster', 'overview', 'meta_json'],
    ];
    for (final p in res.posts) {
      rows.add([p.url, p.title, p.poster, p.overview, jsonEncode(p.meta)]);
    }
    final csv = const ListToCsvConverter().convert(rows);
    final f = File('${baseDir.path}/$name');
    await f.writeAsString(csv);
    return f;
  }

  Future<File> writeSummaryJson(
    SuperToolResult res, {
    String name = 'summary.json',
  }) async {
    await ensureBase();
    final f = File('${baseDir.path}/$name');
    final payload = {
      'strategyUsed': res.strategyUsed,
      'summary': res.summary,
      'counts': {'hits': res.hits.length, 'posts': res.posts.length},
      'assets': res.assetsByType ?? {},
    };
    await f.writeAsString(const JsonEncoder.withIndent('  ').convert(payload));
    return f;
  }

  Future<void> writeDirectoryTree(SuperToolResult res) async {
    if (!directoryTree) return;
    await ensureBase();
    // Example: group hits into dirs by series/episode or filetype
    final hitsDir = Directory('${baseDir.path}/hits');
    await hitsDir.create(recursive: true);
    for (final h in res.hits) {
      final dirName = (h.series ?? 'misc').replaceAll(
        RegExp(r'[^\w\-. ]'),
        '_',
      );
      final d = Directory('${hitsDir.path}/$dirName');
      await d.create(recursive: true);
      final leaf = File(
        '${d.path}/${(h.episode ?? 'file').replaceAll(RegExp(r'[^\w\-. ]'), '_')}.txt',
      );
      await leaf.writeAsString(
        h.url + (h.quality != null ? ' | ${h.quality}' : ''),
      );
    }
    final postsDir = Directory('${baseDir.path}/posts');
    await postsDir.create(recursive: true);
    for (final p in res.posts) {
      final dirName = (p.title.isEmpty ? 'untitled' : p.title).replaceAll(
        RegExp(r'[^\w\-. ]'),
        '_',
      );
      final d = Directory('${postsDir.path}/$dirName');
      await d.create(recursive: true);
      await File('${d.path}/meta.json').writeAsString(
        jsonEncode({
          'url': p.url,
          'title': p.title,
          'poster': p.poster,
          'overview': p.overview,
          'meta': p.meta,
        }),
      );
    }
  }
}
