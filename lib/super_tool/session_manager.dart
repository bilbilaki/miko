import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class CrawlerSessionState {
  final Set<String> visited;
  final List<String> queue;
  final List<Map<String, dynamic>> hits; // {url, quality, series, episode}

  CrawlerSessionState({
    required this.visited,
    required this.queue,
    required this.hits,
  });

  Map<String, dynamic> toJson() => {
    'visited': visited.toList(),
    'queue': queue,
    'hits': hits,
  };

  static CrawlerSessionState fromJson(Map<String, dynamic> m) =>
      CrawlerSessionState(
        visited: {
          ...((m['visited'] as List?)?.map((e) => e.toString()) ?? const []),
        },
        queue:
            ((m['queue'] as List?)?.map((e) => e.toString()).toList() ??
            const []),
        hits:
            ((m['hits'] as List?)
                ?.map((e) => Map<String, dynamic>.from(e))
                .toList() ??
            const []),
      );
}

class SessionManager {
  static Future<Directory> _dir() async {
    final docs = await getApplicationDocumentsDirectory();
    final d = Directory(p.join(docs.path, 'super_tool', 'sessions'));
    if (!await d.exists()) await d.create(recursive: true);
    return d;
  }

  static Future<File> _file(String name) async {
    final d = await _dir();
    return File(p.join(d.path, '$name.json'));
  }

  static Future<void> save(String name, CrawlerSessionState state) async {
    final f = await _file(name);
    await f.writeAsString(
      const JsonEncoder.withIndent('  ').convert(state.toJson()),
    );
  }

  static Future<CrawlerSessionState?> load(String name) async {
    final f = await _file(name);
    if (!await f.exists()) return null;
    final s = await f.readAsString();
    return CrawlerSessionState.fromJson(jsonDecode(s));
  }

  static Future<List<String>> listSessions() async {
    final d = await _dir();
    final files = d
        .listSync()
        .whereType<File>()
        .where((f) => f.path.endsWith('.json'))
        .toList();
    files.sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));
    return files.map((f) => p.basenameWithoutExtension(f.path)).toList();
  }

  static Future<void> delete(String name) async {
    final f = await _file(name);
    if (await f.exists()) await f.delete();
  }
}
