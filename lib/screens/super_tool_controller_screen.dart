import 'dart:convert';

import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:miko/functions/data_storage.dart';
import 'package:miko/models/data_safer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/scrape_service.dart';
import '../super_tool/crawler_engine.dart';
import '../super_tool/session_manager.dart';
import '../super_tool/append_utils.dart';
import 'data_place_config_screen.dart';

class SuperToolControllerScreen extends StatefulWidget {
  const SuperToolControllerScreen({super.key});

  @override
  State<SuperToolControllerScreen> createState() =>
      _SuperToolControllerScreenState();
}

class _SuperToolControllerScreenState extends State<SuperToolControllerScreen> {
  late DataPlaceConfig cfg;
  final _logs = <String>[];
  bool _running = false;
  bool _paused = false;
  int _visited = 0, _queued = 0, _hits = 0;
  String? _lastError;
  String _selectedTemplate = '';
  String _sessionName = '';
  String _appendDatasetId = '';
  BackendKind _appendBackend = BackendKind.jsonFile;
  bool _appendEnabled = false;

  // WebScraper JSON
  final _scraperJsonCtrl = TextEditingController();
  final _previewUrlCtrl = TextEditingController();

  // stores
  late TabularDataStore _storeJson;
  late TabularDataStore _storeSqlite;
  late TabularDataStore _storeCsv;
  late TabularDataStore _storePrefs;

  // worker & engine
  final _scraperWorker = ScrapeServiceWorker();
  CrawlerEngine? _crawler;
  CrawlerSessionState? _resumeState;

  @override
  void initState() {
    super.initState();
    cfg = _defaultConfig();
    _storeJson = JsonFileTabularDataStore();
    _storeSqlite = SqfliteTabularDataStore();
    _storeCsv = CsvFileTabularDataStore();
    _storePrefs = SharedPrefsTabularDataStore();
  _loadTemplateLast();
  _loadConfigFromPrefs(); // NEW: load last saved config from config page
  }

  @override
  void dispose() {
    _scraperWorker.stop();
    _scraperJsonCtrl.dispose();
    _previewUrlCtrl.dispose();
    super.dispose();
  }

  DataPlaceConfig _defaultConfig() => DataPlaceConfig(
    false,
    false,
    false,
    true,
    [],
    0.2,
    ErrorAndFailedHandel.ignoreAndKeepGoing,
    const [],
    ExcludeConfig(null, [], [], [], [], []),
    ['.mp4', '.mkv', '.srt'],
    IncludeConfig(null, [], [], [], [], []),
    true,
    false,
    false,
    2,
    '',
    0,
    ScenarioOfDataplacing.findAWay,
    false,
    8,
    false,
    true,
  );

  // NEW: load config that DataPlaceConfigScreen saves under 'data_place_config'
  Future<void> _loadConfigFromPrefs() async {
    try {
      final sp = await SharedPreferences.getInstance();
      final s = sp.getString('data_place_config');
      if (s != null && s.isNotEmpty) {
        setState(() {
          cfg = DataPlaceConfigJson.fromJson(jsonDecode(s));
        });
        _log('Loaded config from prefs (${cfg.baseUrls.length} base URL(s)).');
      }
    } catch (e) {
      _log('Failed to load config: $e');
    }
  }

  // NEW: sanitize URL (add https:// if missing)
  String _normalizeUrl(String u) {
    final s = u.trim();
    if (s.isEmpty) return s;
    if (s.startsWith('http://') || s.startsWith('https://')) return s;
    return 'https://$s';
  }

  // NEW: return a safe URL to use in preview/tests (first base url or typed)
  String _getTestUrl() {
    final raw = _previewUrlCtrl.text.trim().isNotEmpty
        ? _previewUrlCtrl.text.trim()
        : (cfg.baseUrls.isNotEmpty ? cfg.baseUrls.first : '');
    return _normalizeUrl(raw);
  }

  void _log(String m) {
    setState(() => _logs.insert(0, m));
  }

  Future<void> _saveTemplate() async {
    final sp = await SharedPreferences.getInstance();
    final name = await _prompt(context, 'Template name');
    if (name == null || name.trim().isEmpty) return;
    await sp.setString('tpl:$name', jsonEncode(cfg.toJson()));
    await sp.setString('tpl:_last', name);
    setState(() => _selectedTemplate = name);
    _snack('Template saved: $name');
  }

  Future<void> _loadTemplate() async {
    final sp = await SharedPreferences.getInstance();
    final keys =
        sp
            .getKeys()
            .where((k) => k.startsWith('tpl:') && k != 'tpl:_last')
            .toList()
          ..sort();
    if (keys.isEmpty) {
      _snack('No templates saved.');
      return;
    }
    final name = await _pickOne(
      context,
      'Pick template',
      keys.map((k) => k.substring(4)).toList(),
    );
    if (name == null) return;
    final raw = sp.getString('tpl:$name');
    if (raw == null) return;
    setState(() {
      cfg = DataPlaceConfigJson.fromJson(jsonDecode(raw));
      _selectedTemplate = name;
    });
    await sp.setString('tpl:_last', name);
    _snack('Loaded template: $name');
  }

  Future<void> _loadTemplateLast() async {
    final sp = await SharedPreferences.getInstance();
    final last = sp.getString('tpl:_last');
    if (last != null) {
      final raw = sp.getString('tpl:$last');
      if (raw != null) {
        setState(() {
          cfg = DataPlaceConfigJson.fromJson(jsonDecode(raw));
          _selectedTemplate = last;
        });
      }
    }
  }
  Future<String?> _pickOne(
    BuildContext context,
    String title,
    List<String> items,
  ) async {
    return await showDialog<String>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text(title),
        children: [
          for (final it in items)
            SimpleDialogOption(
              onPressed: () => Navigator.pop(ctx, it),
              child: Text(it),
            ),
        ],
      ),
    );
  }

  Future<void> _start() async {
    if (cfg.baseUrls.isEmpty) {
      _snack('Add at least one Base URL in config.');
      return;
    }
    // use sanitized copy of baseUrls
    cfg.baseUrls = cfg.baseUrls.map(_normalizeUrl).toList();
    setState(() {
      _running = true;
      _paused = false;
      _visited = 0;
      _queued = 0;
      _hits = 0;
      _lastError = null;
      _logs.clear();
    });

    try {
      // Strategy: if webPage first -> use scraper for posts; but main request is for crawler concurrency; we implement both
      if (cfg.strategy == ScenarioOfDataplacing.webPage ||
          cfg.strategy == ScenarioOfDataplacing.findAWay) {
        _log('Scraper step started...');
        for (final url in cfg.baseUrls) {
          final html = await _scraperWorker.fetchHtmlIo(url, headers: {
            'user-agent':
                'Mozilla/5.0 (Flutter SuperTool) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122 Safari/537.36',
          });
          final posts = await _scraperWorker.extractPosts(
            html,
            url,
            cssSelectors:
                cfg.includeConfig.htmlConfigYouNeedIncluded?.listCssPaths ??
                const [],
          );
          _log('Scraper found posts: ${posts.length} at $url');
        }
      }

      _log('Crawler step started (concurrency=${cfg.worker})...');
      _crawler = CrawlerEngine(cfg);
      final res = await _crawler!.runConcurrent(
        resumeState: _resumeState,
        onProgress: ({required visited, required queued, required hits}) {
          setState(() {
            _visited = visited;
            _queued = queued;
            _hits = hits;
          });
        },
        onLog: (m) => _log(m),
      );

      _log('Done. Hits=${res.hits.length}, visited=$_visited');

      // Save result into chosen backend
      final td = res.toTabularForHits();
      final name = 'SuperTool-Hits-${DateTime.now().toIso8601String()}';
      TabularDataStore store;
      switch (_appendBackend) {
        case BackendKind.sqflite:
          store = _storeSqlite;
          break;
        case BackendKind.jsonFile:
          store = _storeJson;
          break;
        case BackendKind.csvFile:
          store = _storeCsv;
          break;
        case BackendKind.sharedPrefs:
          store = _storePrefs;
          break;
      }

      if (_appendEnabled && _appendDatasetId.trim().isNotEmpty) {
        await TabularDataAppend.appendToDataset(
          store: store,
          datasetId: _appendDatasetId.trim(),
          nameIfNew: name,
          newData: td,
        );
        _snack(
          'Appended to dataset ${_appendDatasetId.trim()} (${store.backendId}).',
        );
      } else {
        final id = await store.save(td, name: name);
        _snack('Saved dataset id=$id (${store.backendId}).');
      }
    } catch (e) {
      setState(() => _lastError = e.toString());
      _log('Error: $e');
    } finally {
      setState(() {
        _running = false;
        _paused = false;
      });
    }
  }

  void _pause() {
    if (_crawler == null) return;
    _crawler!.setPaused(true);
    setState(() => _paused = true);
    _log('Paused.');
  }

  void _resume() {
    if (_crawler == null) return;
    _crawler!.setPaused(false);
    setState(() => _paused = false);
    _log('Resumed.');
  }

  void _stop() {
    if (_crawler == null) return;
    _crawler!.requestStop();
    _log('Stop requested...');
  }

  Future<void> _saveSession() async {
    final name = await _prompt(context, 'Session name');
    if (name == null || name.trim().isEmpty) return;
    // we save minimal state: since engine encapsulates state, we require queue/visited/hits snapshot.
    // For demo, store only baseUrls + counters; resume loads stored session object provided externally.
    final state = CrawlerSessionState(
      visited: {}, // snapshot not available here; keeping minimal
      queue: cfg.baseUrls, // restart points
      hits: const [],
    );
    await SessionManager.save(name, state);
    _sessionName = name;
    _snack('Session saved as $name');
  }

  Future<void> _loadSession() async {
    final names = await SessionManager.listSessions();
    if (names.isEmpty) {
      _snack('No sessions.');
      return;
    }
    final name = await _pickOne(context, 'Pick session', names);
    if (name == null) return;
    final s = await SessionManager.load(name);
    if (s == null) {
      _snack('Failed to load session.');
      return;
    }
    setState(() {
      _resumeState = s;
      _sessionName = name;
    });
    _snack('Session loaded: $name');
  }

  Future<void> _testWebScraperJson() async {
    final url = _getTestUrl();
    if (url.isEmpty) {
      _snack('Provide a URL to test.');
      return;
    }
    try {
      final cfgJson = (_scraperJsonCtrl.text.trim().isEmpty)
          ? jsonDecode(_defaultScraperConfig) as Map<String, Object>
          : jsonDecode(_scraperJsonCtrl.text) as Map<String, Object>;
      final res = await _scraperWorker.runWebScraper(
        url: url,
        scraperConfigJson: cfgJson,
      );
      _log('WebScraper OK keys: ${res.keys.join(', ')}');
      _snack('WebScraper executed. See logs.');
    } catch (e) {
      _log('WebScraper error: $e');
      _snack('WebScraper error.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final canStart = !_running;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Super Tool Controller'),
        actions: [
          IconButton(
            tooltip: 'Create/Edit Config',
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const DataPlaceConfigScreen(),
                ),
              );
            },
            icon: const Icon(Icons.settings),
          ),
          IconButton(
            tooltip: 'Save template',
            onPressed: _saveTemplate,
            icon: const Icon(Icons.save),
          ),
          IconButton(
            tooltip: 'Load template',
            onPressed: _loadTemplate,
            icon: const Icon(Icons.folder_open),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildStatusBar(),
          const Divider(height: 1),
          Expanded(
            child: Row(
              children: [
                Flexible(flex: 2, child: _buildControls(canStart)),
                const VerticalDivider(width: 1),
                Flexible(flex: 3, child: _buildLogsAndDebug()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBar() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Template: ${_selectedTemplate.isEmpty ? '(none)' : _selectedTemplate}',
                ),
                if (_lastError != null)
                  Text(
                    'Error: $_lastError',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Visited: $_visited • Queue: $_queued • Hits: $_hits'),
              SizedBox(
                width: 220,
                child: LinearProgressIndicator(
                  value: _queued == 0
                      ? null
                      : (_visited / (_visited + _queued))
                            .clamp(0, 1)
                            .toDouble(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildControls(bool canStart) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: canStart ? _start : null,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Start'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton.tonalIcon(
                  onPressed: _running && !_paused ? _pause : null,
                  icon: const Icon(Icons.pause),
                  label: const Text('Pause'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: FilledButton.tonalIcon(
                  onPressed: _running && _paused ? _resume : null,
                  icon: const Icon(Icons.play_circle),
                  label: const Text('Resume'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton.tonalIcon(
                  onPressed: _running ? _stop : null,
                  icon: const Icon(Icons.stop),
                  label: const Text('Stop'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _saveSession,
                  icon: const Icon(Icons.save_as),
                  label: const Text('Save session'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _loadSession,
                  icon: const Icon(Icons.restore),
                  label: const Text('Load session'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            value: _appendEnabled,
            onChanged: (v) => setState(() => _appendEnabled = v),
            title: const Text('Append results to existing dataset'),
          ),
          if (_appendEnabled) ...[
            DropdownButtonFormField<BackendKind>(
              value: _appendBackend,
              decoration: const InputDecoration(labelText: 'Backend'),
              items: const [
                DropdownMenuItem(
                  value: BackendKind.jsonFile,
                  child: Text('JSON files'),
                ),
                DropdownMenuItem(
                  value: BackendKind.sqflite,
                  child: Text('SQLite (sqflite)'),
                ),
                DropdownMenuItem(
                  value: BackendKind.csvFile,
                  child: Text('CSV files'),
                ),
                DropdownMenuItem(
                  value: BackendKind.sharedPrefs,
                  child: Text('SharedPreferences'),
                ),
              ],
              onChanged: (v) =>
                  setState(() => _appendBackend = v ?? _appendBackend),
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Dataset ID to append',
              ),
              onChanged: (v) => _appendDatasetId = v,
            ),
          ],
          const SizedBox(height: 16),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'WebScraper Test (ScraperConfig JSON)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _previewUrlCtrl,
            decoration: const InputDecoration(
              labelText: 'Test URL (optional; uses first Base URL if empty)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _scraperJsonCtrl,
            maxLines: 6,
            decoration: const InputDecoration(
              labelText: 'ScraperConfig JSON',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _testWebScraperJson,
                  icon: const Icon(Icons.science),
                  label: const Text('Run WebScraper'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLogsAndDebug() {
    final previewUrl = _getTestUrl();
    return Column(
      children: [
        ListTile(
          dense: true,
          title: const Text('AnyLinkPreview (debug)'),
          subtitle: Text(
            previewUrl.isEmpty ? 'Set a URL to preview' : previewUrl,
          ),
        ),
        SizedBox(
          height: 160,
          child: Card(
            clipBehavior: Clip.antiAlias,
            margin: const EdgeInsets.symmetric(horizontal: 12),
            child: previewUrl.isEmpty
                ? const Center(child: Text('No URL'))
                : AnyLinkPreview(
                    link: previewUrl, // must be http/https
                    displayDirection: UIDirection.uiDirectionHorizontal,
                    showMultimedia: true,
                    bodyMaxLines: 3,
                    cache: const Duration(hours: 1),
                    errorBody: 'Preview failed',
                    errorTitle: 'Error',
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.surfaceVariant,
                  ),
          ),
        ),
        const Divider(),
        const ListTile(dense: true, title: Text('Logs')),
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            padding: const EdgeInsets.all(8),
            color: Colors.black.withOpacity(0.06),
            child: ListView.builder(
              reverse: true,
              itemCount: _logs.length,
              itemBuilder: (_, i) => Text(_logs[i]),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _snack(String m) async {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));
  }

  Future<String?> _prompt(BuildContext context, String title) async {
    final c = TextEditingController();
    return await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: c,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        actions: [
          IconButton(
            tooltip: 'Create/Edit Config',
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const DataPlaceConfigScreen(),
                ),
              );
              // reload after returning
              await _loadConfigFromPrefs();
            },
            icon: const Icon(Icons.settings),
          )]));}
  // NEW: minimal default WebScraper config
  static const _defaultScraperConfig = '''
{
  "parsers": [
    {
      "id": "items",
      "parents": ["_root"],
      "type": "element",
      "selectors": [".quote", "article", "a"],
      "multiple": true
    },
    {
      "id": "title",
      "parents": ["items"],
      "type": "text",
      "selectors": ["span.text", "h1", "h2", "a"]
    }
  ]
}
''';

}


// Got it. You want a Flutter app (no Selenium) that runs your non-Selenium scrapers locally, with a control screen and live logs. I’ll provide an MVP covering:
// - Collect Pages (pagination finder)
// - File crawler (similar to FlutterCrawler: movies/series with .mkv, pivot + CSV)
// - Log console UI and saving results to device storage

// Quick questions (answer briefly and I’ll adapt):
// 1) Target platforms? Android only, or also Windows/macOS?
// 2) First features to include beyond these two: Bia2Anime episode sorter or TMDB importer?
// 3) Is offline/local only OK (no server)? The code below is offline.

// How to run
// - Create a Flutter project, replace/add files below.
// - Run: flutter pub get, then flutter run.
// - CSV files are saved in app documents directory (path shown in logs).

// pubspec.yaml
// ```yaml
// name: scraper_flutter
// description: Offline scrapers (no Selenium), with control screen and log console.
// publish_to: "none"
// environment:
//   sdk: ">=3.3.0 <4.0.0"

// dependencies:
//   flutter:
//     sdk: flutter
//   http: ^1.2.0
//   html: ^0.15.4
//   csv: ^5.0.2
//   path_provider: ^2.1.3
//   collection: ^1.18.0

// dev_dependencies:
//   flutter_test:
//     sdk: flutter

// flutter:
//   uses-material-design: true
// ```

// lib/main.dart
// ```dart
// import 'package:flutter/material.dart';
// import 'screens/task_console_screen.dart';

// void main() {
//   runApp(const ScraperApp());
// }

// class ScraperApp extends StatelessWidget {
//   const ScraperApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Scraper Console',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
//         useMaterial3: true,
//       ),
//       home: const TaskConsoleScreen(),
//     );
//   }
// }
// ```

// lib/models/log_entry.dart
// ```dart
// class LogEntry {
//   final DateTime ts;
//   final String message;
//   LogEntry(this.message) : ts = DateTime.now();

//   @override
//   String toString() => "[${ts.toIso8601String()}] $message";
// }

// class LogController {
//   final List<LogEntry> _entries = [];
//   void clear() => _entries.clear();
//   void add(String msg) => _entries.add(LogEntry(msg));
//   List<LogEntry> get entries => List.unmodifiable(_entries);
// }
// ```

// lib/utils/url_utils.dart
// ```dart
// import 'dart:core';

// Uri? tryParseUri(String s) {
//   try {
//     return Uri.parse(s);
//   } catch (_) {
//     return null;
//   }
// }

// String joinUrl(String base, String href) {
//   try {
//     final baseUri = Uri.parse(base);
//     final resolved = baseUri.resolve(href.trim());
//     return resolved.toString();
//   } catch (_) {
//     return href.trim();
//   }
// }

// bool sameDomain(String a, String b) {
//   try {
//     final ua = Uri.parse(a);
//     final ub = Uri.parse(b);
//     return ua.host == ub.host;
//   } catch (_) {
//     return false;
//   }
// }

// int? extractPageNumber(String u) {
//   try {
//     final m1 = RegExp(r'/page[/-](\d+)', caseSensitive: false).firstMatch(u);
//     if (m1 != null) return int.parse(m1.group(1)!);
//     final m2 = RegExp(r'[?&](?:page|p)=(\d+)', caseSensitive: false).firstMatch(u);
//     if (m2 != null) return int.parse(m2.group(1)!);
//     final m3 = RegExp(r'/p/(\d+)', caseSensitive: false).firstMatch(u);
//     if (m3 != null) return int.parse(m3.group(1)!);
//   } catch (_) {}
//   return null;
// }
// ```

// lib/utils/csv_utils.dart
// ```dart
// import 'dart:io';
// import 'package:csv/csv.dart';

// Future<File> writeCsv(String fullPath, List<List<dynamic>> rows) async {
//   final file = File(fullPath);
//   await file.create(recursive: true);
//   final content = const ListToCsvConverter().convert(rows);
//   return file.writeAsString(content);
// }
// ```

// lib/services/collect_pages_service.dart
// ```dart
// import 'package:http/http.dart' as http;
// import 'package:html/parser.dart' as hp;
// import 'package:html/dom.dart';
// import '../models/log_entry.dart';
// import '../utils/url_utils.dart';

// class CollectPagesService {
//   final LogController log;
//   CollectPagesService(this.log);

//   // Find candidates for next pages
//   List<String> _extractPaginationCandidates(Document doc, String baseUrl) {
//     final out = <String>{};

//     // <link rel="next">
//     final linkNext = doc.querySelector('link[rel~="next"]');
//     if (linkNext != null) {
//       final href = linkNext.attributes['href'];
//       if (href != null) out.add(joinUrl(baseUrl, href));
//     }

//     // anchors with rel="next"
//     for (final a in doc.querySelectorAll('a[rel~="next"]')) {
//       final href = a.attributes['href'];
//       if (href != null) out.add(joinUrl(baseUrl, href));
//     }

//     // By text or class/id hints
//     final textKeys = <String>['next', 'older', 'more', 'load more', '»', '›'];
//     final hrefRegex = RegExp(
//       r'(?:page[=/\-]\d+|/page/\d+|\?page=\d+|&page=\d+|/p/\d+|/page-\d+|[\?&]p=\d+)',
//       caseSensitive: false,
//     );

//     for (final a in doc.querySelectorAll('a[href]')) {
//       final txt = (a.text.trim().toLowerCase());
//       final cls = ((a.attributes['class'] ?? '') + ' ' + (a.attributes['id'] ?? '')).toLowerCase();
//       final href = a.attributes['href']!;
//       if (textKeys.any((k) => txt.contains(k)) ||
//           RegExp(r'pager|pagination|page-numbers|nav-links|next').hasMatch(cls) ||
//           hrefRegex.hasMatch(href)) {
//         out.add(joinUrl(baseUrl, href));
//       }
//     }
//     return out.toList();
//   }

//   Future<List<String>> collect({
//     required String startUrl,
//     int maxPages = 100,
//     int timeoutSec = 15,
//     bool sameDomainOnly = true,
//     int maxDepth = 50,
//     int startFromPageNum = 1,
//     String userAgent = 'Mozilla/5.0 (compatible; PaginationCollector/1.0)',
//   }) async {
//     final headers = {'User-Agent': userAgent};
//     final visited = <String>{};
//     final found = <String>[];
//     final queue = <String>[startUrl];

//     var tries = 0;
//     while (queue.isNotEmpty && found.length < maxPages && tries < maxDepth) {
//       final current = queue.removeAt(0).trim();
//       if (current.isEmpty || visited.contains(current)) continue;
//       visited.add(current);
//       tries++;

//       log.add("GET $current");
//       http.Response resp;
//       try {
//         resp = await http
//             .get(Uri.parse(current), headers: headers)
//             .timeout(Duration(seconds: timeoutSec));
//         if (resp.statusCode < 200 || resp.statusCode >= 300) {
//           log.add("Skip ${resp.statusCode} $current");
//           continue;
//         }
//       } catch (e) {
//         log.add("Error fetching $current -> $e");
//         continue;
//       }

//       if (!found.contains(current)) found.add(current);

//       final doc = hp.parse(resp.body);
//       final candidates = _extractPaginationCandidates(doc, current);

//       // Numeric synthesis fallback
//       final normalized = <String>[];
//       if (candidates.isEmpty) {
//         final links = doc.querySelectorAll('a[href]').map((e) => joinUrl(current, e.attributes['href']!)).toList();
//         final numMap = <int, String>{};
//         for (final l in links) {
//           if (sameDomainOnly && !sameDomain(startUrl, l)) continue;
//           final pn = extractPageNumber(l);
//           if (pn != null) numMap[pn] = l;
//         }
//         if (numMap.isNotEmpty) {
//           final keys = numMap.keys.toList()..sort();
//           final minK = keys.first;
//           final maxK = keys.last;
//           final startK = startFromPageNum > 0 ? startFromPageNum : (minK > 0 ? minK : 1);
//           for (var p = startK; p <= maxK; p++) {
//             if (numMap.containsKey(p)) {
//               normalized.add(numMap[p]!);
//             } else {
//               // synthesize by replacing first number in an example
//               final example = numMap[keys.first]!;
//               final repl = example.replaceFirst(RegExp(r'\d+'), p.toString());
//               normalized.add(repl);
//             }
//           }
//         }
//       } else {
//         normalized.addAll(candidates.where((c) {
//           if (sameDomainOnly && !sameDomain(startUrl, c)) return false;
//           return true;
//         }));
//       }

//       for (final n in normalized) {
//         if (!visited.contains(n) && !queue.contains(n) && !found.contains(n)) {
//           queue.add(n);
//         }
//       }
//     }

//     final uniq = <String>[];
//     final seen = <String>{};
//     for (final p in found) {
//       if (!seen.contains(p)) {
//         seen.add(p);
//         uniq.add(p);
//       }
//     }
//     log.add("Done. Found ${uniq.length} pages.");
//     return uniq;
//   }
// }
// ```

// lib/services/fluttermethod_crawler.dart
// ```dart
// import 'dart:async';
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'package:html/parser.dart' as hp;
// import 'package:html/dom.dart';
// import 'package:path_provider/path_provider.dart';
// import '../models/log_entry.dart';
// import '../utils/url_utils.dart';
// import '../utils/csv_utils.dart';

// class CrawlItem {
//   final String url;
//   final int depth;
//   CrawlItem(this.url, this.depth);
// }

// class FlutterCrawlerService {
//   final LogController log;
//   FlutterCrawlerService(this.log);

//   final _found = <String>{};
//   final _visited = <String>{};

//   static bool _isValidFilename(String filename, String ext) {
//     if (!filename.toLowerCase().endsWith(ext.toLowerCase())) return false;
//     final name = filename.substring(0, filename.length - ext.length);
//     for (final tok in ['.test', '.temp', '?=', '.=', '/?=', './_?', '.part']) {
//       if (name.contains(tok)) return false;
//     }
//     return true;
//   }

//   static String? _extractQuality(String url) {
//     final m = RegExp(r'(1080p|720p|540p|480p|Dubbed)', caseSensitive: false).firstMatch(url);
//     return m?.group(1);
//     }

//   static String? _extractSeason(String url) {
//     final m = RegExp(r'/S(\d+)/', caseSensitive: false).firstMatch(url);
//     if (m != null) {
//       try {
//         final n = int.parse(m.group(1)!);
//         return 'S${n.toString().padLeft(2, '0')}';
//       } catch (_) {}
//     }
//     return null;
//   }

//   static String? _extractEpisode(String url) {
//     final filename = url.split('/').last;
//     RegExpMatch? m;
//     m = RegExp(r'S\d+E(\d+)', caseSensitive: false).firstMatch(filename);
//     if (m != null) return 'E${int.parse(m.group(1)!).toString().padLeft(2, '0')}';
//     m = RegExp(r'Ep(?:isode)?\.?(\d+)', caseSensitive: false).firstMatch(filename);
//     if (m != null) return 'E${int.parse(m.group(1)!).toString().padLeft(2, '0')}';
//     m = RegExp(r'(?<!\d)(?<!p)[._-](\d{2,3})[._-]').firstMatch(filename);
//     if (m != null) return 'E${int.parse(m.group(1)!).toString().padLeft(2, '0')}';
//     m = RegExp(r'\.(\d{2,3})\.').firstMatch(filename);
//     if (m != null && !RegExp(r'\d+p', caseSensitive: false).hasMatch(m.group(0)!)) {
//       return 'E${int.parse(m.group(1)!).toString().padLeft(2, '0')}';
//     }
//     return null;
//   }

//   static String? _extractSeriesName(String url, String episodeId) {
//     final filename = Uri.decodeComponent(url.split('/').last);
//     final seasonToken = episodeId.contains('E') ? episodeId.split('E').first : episodeId;
//     final idx = filename.indexOf(seasonToken);
//     if (idx != -1) {
//       return filename.substring(0, idx).replaceAll('.', ' ').trim();
//     }
//     return null;
//   }

//   Future<Map<String, dynamic>> crawl({
//     required List<String> startUrls,
//     List<String>? basePaths,
//     String baseName = 'results',
//     String selectedExtension = '.mkv',
//     bool processAsSeries = false,
//     int maxDepth = 1000,
//     int maxConcurrent = 8,
//     int timeoutSec = 20,
//     String userAgent = 'Mozilla/5.0',
//   }) async {
//     _found.clear();
//     _visited.clear();

//     final queue = <CrawlItem>[];
//     final sem = _Semaphore(maxConcurrent);
//     final client = http.Client();
//     final headers = {'User-Agent': userAgent};
//     final bases = (basePaths == null || basePaths.isEmpty) ? startUrls : basePaths;

//     for (final s in startUrls) {
//       queue.add(CrawlItem(s.trim(), 0));
//       _visited.add(s.trim());
//     }

//     Future<void> processItem(CrawlItem it) async {
//       if (it.depth > maxDepth) {
//         log.add("Max depth at ${it.url}");
//         return;
//       }
//       log.add("Crawling (${it.depth}): ${it.url}");
//       http.Response resp;
//       try {
//         await sem.acquire();
//         try {
//           resp = await client
//               .get(Uri.parse(it.url), headers: headers)
//               .timeout(Duration(seconds: timeoutSec));
//         } finally {
//           sem.release();
//         }
//       } catch (e) {
//         log.add("Failed ${it.url} -> $e");
//         return;
//       }
//       if (resp.statusCode < 200 || resp.statusCode >= 300) {
//         log.add("HTTP ${resp.statusCode} ${it.url}");
//         return;
//       }
//       final doc = hp.parse(resp.body);

//       for (final a in doc.querySelectorAll('a[href]')) {
//         final href = a.attributes['href']!.trim();
//         if (href == './') continue;
//         final full = joinUrl(it.url, href).trim();
//         if (!bases.any((bp) => full.startsWith(bp))) continue;

//         if (_visited.contains(full)) continue;
//         _visited.add(full);

//         final p = Uri.parse(full);
//         final path = p.path;
//         if (path.endsWith('/')) {
//           queue.add(CrawlItem(full, it.depth + 1));
//         } else {
//           final ext = path.split('.').lastOrNull != null ? ".${path.split('.').last}" : '';
//           if (ext.toLowerCase() == selectedExtension.toLowerCase()) {
//             final filename = path.split('/').last;
//             if (_isValidFilename(filename, selectedExtension)) {
//               _found.add(full);
//               log.add("Found: $full");
//             } else {
//               log.add("Ignored invalid: $full");
//             }
//           }
//         }
//       }
//     }

//     while (queue.isNotEmpty) {
//       // Run a small batch to respect concurrency
//       final tasks = <Future>[];
//       while (tasks.length < maxConcurrent && queue.isNotEmpty) {
//         tasks.add(processItem(queue.removeAt(0)));
//       }
//       await Future.wait(tasks);
//     }
//     client.close();

//     // Save
//     final dir = await getApplicationDocumentsDirectory();
//     final outDir = Directory("${dir.path}/scraper_outputs");
//     if (!await outDir.exists()) await outDir.create(recursive: true);

//     final saved = <String>[];
//     if (processAsSeries) {
//       final pivot = _pivotSeries(_found);
//       final rows = <List<dynamic>>[
//         ['Series', 'Episode', '1080p', '720p', '540p', '480p', 'Dubbed']
//       ];
//       final keys = pivot.keys.toList()..sort();
//       for (final k in keys) {
//         final e = pivot[k]!;
//         rows.add([
//           e['Series'] ?? '',
//           e['Episode'] ?? '',
//           e['1080p'] ?? '',
//           e['720p'] ?? '',
//           e['540p'] ?? '',
//           e['480p'] ?? '',
//           e['Dubbed'] ?? '',
//         ]);
//       }
//       final file = await writeCsv("${outDir.path}/$baseName.csv", rows);
//       saved.add(file.path);
//     } else {
//       final movieMap = _groupMovies(_found);
//       final rows = <List<dynamic>>[
//         ['Name', 'URL']
//       ];
//       for (final entry in movieMap.entries) {
//         rows.add([entry.key, entry.value.join(',')]);
//       }
//       final file = await writeCsv("${outDir.path}/$baseName.csv", rows);
//       saved.add(file.path);
//     }

//     return {
//       'foundCount': _found.length,
//       'visitedCount': _visited.length,
//       'csvFiles': saved,
//       'outputDir': outDir.path,
//     };
//   }

//   Map<String, List<String>> _groupMovies(Set<String> urls) {
//     final map = <String, List<String>>{};
//     final yearTail = RegExp(r'\.\d{4}$');
//     for (final u in urls) {
//       final path = Uri.parse(u).path;
//       var filename = path.split('/').last;
//       if (filename.contains('.')) {
//         filename = filename.substring(0, filename.lastIndexOf('.'));
//       }
//       var cleaned = filename.replaceAll(yearTail, '').replaceAll('.', ' ').trim();
//       map.putIfAbsent(cleaned, () => []);
//       map[cleaned]!.add(u);
//     }
//     return map;
//   }

//   Map<String, Map<String, String>> _pivotSeries(Set<String> urls) {
//     final pivot = <String, Map<String, String>>{};
//     for (final u in urls) {
//       final q = _extractQuality(u) ?? 'unknown';
//       final s = _extractSeason(u);
//       final e = _extractEpisode(u);
//       if (s != null && e != null) {
//         final epId = '$s$e';
//         final seriesName = _extractSeriesName(u, epId) ?? 'Series';
//         final key = '${seriesName}_$epId';
//         pivot.putIfAbsent(key, () => {'Series': seriesName, 'Episode': epId});
//         pivot[key]![q] = u;
//       }
//     }
//     return pivot;
//   }
// }

// class _Semaphore {
//   int _count;
//   final List<Completer<void>> _waiters = [];
//   _Semaphore(this._count);

//   Future<void> acquire() {
//     if (_count > 0) {
//       _count--;
//       return Future.value();
//     }
//     final c = Completer<void>();
//     _waiters.add(c);
//     return c.future;
//   }

//   void release() {
//     if (_waiters.isNotEmpty) {
//       final c = _waiters.removeAt(0);
//       c.complete();
//     } else {
//       _count++;
//     }
//   }
// }
// ```

// lib/widgets/log_console.dart
// ```dart
// import 'package:flutter/material.dart';
// import '../models/log_entry.dart';

// class LogConsole extends StatefulWidget {
//   final LogController controller;
//   const LogConsole({super.key, required this.controller});

//   @override
//   State<LogConsole> createState() => _LogConsoleState();
// }

// class _LogConsoleState extends State<LogConsole> {
//   final _scroll = ScrollController();

//   void _scrollToBottom() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (_scroll.hasClients) {
//         _scroll.jumpTo(_scroll.position.maxScrollExtent);
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     _scrollToBottom();
//     final entries = widget.controller.entries;
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.black,
//         border: Border.all(color: Colors.grey.shade700),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: ListView.builder(
//         controller: _scroll,
//         padding: const EdgeInsets.all(8),
//         itemCount: entries.length,
//         itemBuilder: (_, i) {
//           return Text(
//             entries[i].toString(),
//             style: const TextStyle(
//               fontFamily: 'monospace',
//               color: Colors.greenAccent,
//               fontSize: 12,
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
// ```

// lib/screens/task_console_screen.dart
// ```dart
// import 'package:flutter/material.dart';
// import '../models/log_entry.dart';
// import '../services/collect_pages_service.dart';
// import '../services/fluttermethod_crawler.dart';

// class TaskConsoleScreen extends StatefulWidget {
//   const TaskConsoleScreen({super.key});

//   @override
//   State<TaskConsoleScreen> createState() => _TaskConsoleScreenState();
// }

// class _TaskConsoleScreenState extends State<TaskConsoleScreen> with SingleTickerProviderStateMixin {
//   late final TabController _tab;
//   final _log = LogController();

//   // Collect Pages form
//   final _cpUrl = TextEditingController(text: 'https://example.com/blog/');
//   final _cpMaxPages = TextEditingController(text: '50');
//   final _cpTimeout = TextEditingController(text: '15');
//   final _cpMaxDepth = TextEditingController(text: '50');
//   bool _cpSameDomain = true;

//   // Crawler form
//   final _crUrls = TextEditingController(text: 'https://example.com/videos/');
//   final _crBaseName = TextEditingController(text: 'results');
//   final _crExt = TextEditingController(text: '.mkv');
//   bool _crSeries = true;
//   final _crDepth = TextEditingController(text: '100');
//   final _crConc = TextEditingController(text: '8');
//   final _crTimeout = TextEditingController(text: '20');

//   bool _busy = false;

//   @override
//   void initState() {
//     super.initState();
//     _tab = TabController(length: 2, vsync: this);
//   }

//   @override
//   void dispose() {
//     _tab.dispose();
//     _cpUrl.dispose();
//     _cpMaxPages.dispose();
//     _cpTimeout.dispose();
//     _cpMaxDepth.dispose();
//     _crUrls.dispose();
//     _crBaseName.dispose();
//     _crExt.dispose();
//     _crDepth.dispose();
//     _crConc.dispose();
//     _crTimeout.dispose();
//     super.dispose();
//   }

//   Future<void> _runCollectPages() async {
//     setState(() => _busy = true);
//     _log.clear();
//     final svc = CollectPagesService(_log);
//     try {
//       final pages = await svc.collect(
//         startUrl: _cpUrl.text.trim(),
//         maxPages: int.tryParse(_cpMaxPages.text.trim()) ?? 50,
//         timeoutSec: int.tryParse(_cpTimeout.text.trim()) ?? 15,
//         sameDomainOnly: _cpSameDomain,
//         maxDepth: int.tryParse(_cpMaxDepth.text.trim()) ?? 50,
//       );
//       _log.add("Pages (${pages.length}):");
//       for (final p in pages) {
//         _log.add(p);
//       }
//     } catch (e) {
//       _log.add("Error: $e");
//     } finally {
//       setState(() => _busy = false);
//     }
//   }

//   Future<void> _runCrawler() async {
//     setState(() => _busy = true);
//     _log.clear();
//     final svc = FlutterCrawlerService(_log);
//     try {
//       final urls = _crUrls.text
//           .split(RegExp(r'[\r\n]+'))
//           .map((e) => e.trim())
//           .where((e) => e.isNotEmpty)
//           .toList();
//       final res = await svc.crawl(
//         startUrls: urls,
//         basePaths: urls,
//         baseName: _crBaseName.text.trim().isEmpty ? 'results' : _crBaseName.text.trim(),
//         selectedExtension: _crExt.text.trim().isEmpty ? '.mkv' : _crExt.text.trim(),
//         processAsSeries: _crSeries,
//         maxDepth: int.tryParse(_crDepth.text.trim()) ?? 100,
//         maxConcurrent: int.tryParse(_crConc.text.trim()) ?? 8,
//         timeoutSec: int.tryParse(_crTimeout.text.trim()) ?? 20,
//       );
//       _log.add("Visited: ${res['visitedCount']} | Found: ${res['foundCount']}");
//       final List files = res['csvFiles'] as List? ?? [];
//       for (final f in files) {
//         _log.add("Saved CSV -> $f");
//       }
//       _log.add("Output dir: ${res['outputDir']}");
//     } catch (e) {
//       _log.add("Error: $e");
//     } finally {
//       setState(() => _busy = false);
//     }
//   }

//   Widget _sectionTitle(String t) => Padding(
//         padding: const EdgeInsets.symmetric(vertical: 8),
//         child: Text(t, style: const TextStyle(fontWeight: FontWeight.bold)),
//       );

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Scraper Console (No Selenium)'),
//         bottom: TabBar(
//           controller: _tab,
//           tabs: const [
//             Tab(icon: Icon(Icons.pages), text: 'Collect Pages'),
//             Tab(icon: Icon(Icons.storage), text: 'Crawler'),
//           ],
//         ),
//       ),
//       body: AbsorbPointer(
//         absorbing: _busy,
//         child: Stack(
//           children: [
//             TabBarView(
//               controller: _tab,
//               children: [
//                 // Collect Pages
//                 Padding(
//                   padding: const EdgeInsets.all(12),
//                   child: Column(
//                     children: [
//                       _sectionTitle('Inputs'),
//                       TextField(decoration: const InputDecoration(labelText: 'Start URL'), controller: _cpUrl),
//                       Row(
//                         children: [
//                           Flexible(child: TextField(decoration: const InputDecoration(labelText: 'Max Pages'), controller: _cpMaxPages, keyboardType: TextInputType.number)),
//                           const SizedBox(width: 8),
//                           Flexible(child: TextField(decoration: const InputDecoration(labelText: 'Timeout (sec)'), controller: _cpTimeout, keyboardType: TextInputType.number)),
//                           const SizedBox(width: 8),
//                           Flexible(child: TextField(decoration: const InputDecoration(labelText: 'Max Depth'), controller: _cpMaxDepth, keyboardType: TextInputType.number)),
//                         ],
//                       ),
//                       SwitchListTile(
//                         title: const Text('Same domain only'),
//                         value: _cpSameDomain,
//                         onChanged: (v) => setState(() => _cpSameDomain = v),
//                       ),
//                       const SizedBox(height: 8),
//                       Row(
//                         children: [
//                           ElevatedButton.icon(
//                             onPressed: _runCollectPages,
//                             icon: const Icon(Icons.play_arrow),
//                             label: const Text('Run'),
//                           ),
//                           const SizedBox(width: 12),
//                           if (_busy) const CircularProgressIndicator(),
//                         ],
//                       ),
//                       const SizedBox(height: 8),
//                       _sectionTitle('Logs'),
//                       Expanded(child: LogConsole(controller: _log)),
//                     ],
//                   ),
//                 ),
//                 // Crawler
//                 Padding(
//                   padding: const EdgeInsets.all(12),
//                   child: Column(
//                     children: [
//                       _sectionTitle('Inputs'),
//                       TextField(
//                         controller: _crUrls,
//                         maxLines: 4,
//                         decoration: const InputDecoration(
//                           labelText: 'Start URLs (one per line)',
//                           alignLabelWithHint: true,
//                         ),
//                       ),
//                       Row(
//                         children: [
//                           Flexible(child: TextField(decoration: const InputDecoration(labelText: 'Base Name'), controller: _crBaseName)),
//                           const SizedBox(width: 8),
//                           SizedBox(
//                             width: 120,
//                             child: TextField(decoration: const InputDecoration(labelText: 'Ext'), controller: _crExt),
//                           ),
//                         ],
//                       ),
//                       Row(
//                         children: [
//                           Flexible(child: TextField(decoration: const InputDecoration(labelText: 'Max Depth'), controller: _crDepth, keyboardType: TextInputType.number)),
//                           const SizedBox(width: 8),
//                           Flexible(child: TextField(decoration: const InputDecoration(labelText: 'Max Concurrent'), controller: _crConc, keyboardType: TextInputType.number)),
//                           const SizedBox(width: 8),
//                           Flexible(child: TextField(decoration: const InputDecoration(labelText: 'Timeout (sec)'), controller: _crTimeout, keyboardType: TextInputType.number)),
//                         ],
//                       ),
//                       SwitchListTile(
//                         title: const Text('Process as series (pivot by episode and quality)'),
//                         value: _crSeries,
//                         onChanged: (v) => setState(() => _crSeries = v),
//                       ),
//                       const SizedBox(height: 8),
//                       Row(
//                         children: [
//                           ElevatedButton.icon(
//                             onPressed: _runCrawler,
//                             icon: const Icon(Icons.play_arrow),
//                             label: const Text('Run'),
//                           ),
//                           const SizedBox(width: 12),
//                           if (_busy) const CircularProgressIndicator(),
//                         ],
//                       ),
//                       const SizedBox(height: 8),
//                       _sectionTitle('Logs'),
//                       Expanded(child: LogConsole(controller: _log)),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// ```

// Notes and next steps
// - This excludes Selenium by design. It runs HTTP fetch + HTML parsing locally.
// - Ready to extend: I can add “Bia2Anime episode sorter” and a simple “TMDB importer” tab (using TMDB REST API) with the same log console pattern.
// - If you confirm target platforms and priorities, I’ll add those screens and services next.