import 'dart:async';
import 'dart:collection';
import 'dart:convert'; // Added for JSON encoding/decoding
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:csv/csv.dart';
import 'package:miko/screens/http.dart';
import 'package:miko/screens/http_rest.dart';
import 'package:miko/screens/tmdb_datails_process.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// --- Session Management Data Model ---
class CrawlSession {
  final int? id;
  final String sessionName;
  final DateTime savedAt;
  final String rootUrls;
  final String baseName;
  final String selectedExtension;
  final int processAsSeries; // 1 for true, 0 for false
  final String crawlQueueJson;
  final String visitedUrlsJson;
  final String foundUrlsJson;

  CrawlSession({
    this.id,
    required this.sessionName,
    required this.savedAt,
    required this.rootUrls,
    required this.baseName,
    required this.selectedExtension,
    required this.processAsSeries,
    required this.crawlQueueJson,
    required this.visitedUrlsJson,
    required this.foundUrlsJson,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sessionName': sessionName,
      'savedAt': savedAt.toIso8601String(),
      'rootUrls': rootUrls,
      'baseName': baseName,
      'selectedExtension': selectedExtension,
      'processAsSeries': processAsSeries,
      'crawlQueueJson': crawlQueueJson,
      'visitedUrlsJson': visitedUrlsJson,
      'foundUrlsJson': foundUrlsJson,
    };
  }

  factory CrawlSession.fromMap(Map<String, dynamic> map) {
    return CrawlSession(
      id: map['id'],
      sessionName: map['sessionName'],
      savedAt: DateTime.parse(map['savedAt']),
      rootUrls: map['rootUrls'],
      baseName: map['baseName'],
      selectedExtension: map['selectedExtension'],
      processAsSeries: map['processAsSeries'],
      crawlQueueJson: map['crawlQueueJson'],
      visitedUrlsJson: map['visitedUrlsJson'],
      foundUrlsJson: map['foundUrlsJson'],
    );
  }
}

// --- Session Database Helper ---
class SessionDatabase {
  static final SessionDatabase instance = SessionDatabase._init();
  static Database? _database;
  SessionDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('sessions.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const intType = 'INTEGER NOT NULL';

    await db.execute('''
CREATE TABLE sessions (
  id $idType,
  sessionName $textType,
  savedAt $textType,
  rootUrls $textType,
  baseName $textType,
  selectedExtension $textType,
  processAsSeries $intType,
  crawlQueueJson $textType,
  visitedUrlsJson $textType,
  foundUrlsJson $textType
)
''');
  }

  Future<CrawlSession> create(CrawlSession session) async {
    final db = await instance.database;
    final id = await db.insert('sessions', session.toMap());
    return CrawlSession(
        id: id,
        sessionName: session.sessionName,
        savedAt: session.savedAt,
        rootUrls: session.rootUrls,
        baseName: session.baseName,
        selectedExtension: session.selectedExtension,
        processAsSeries: session.processAsSeries,
        crawlQueueJson: session.crawlQueueJson,
        visitedUrlsJson: session.visitedUrlsJson,
        foundUrlsJson: session.foundUrlsJson);
  }

  Future<List<CrawlSession>> readAllSessions() async {
    final db = await instance.database;
    final result = await db.query('sessions', orderBy: 'savedAt DESC');
    return result.map((json) => CrawlSession.fromMap(json)).toList();
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete('sessions', where: 'id = ?', whereArgs: [id]);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}

class CrawlerHomePage3 extends StatefulWidget {
  const CrawlerHomePage3({super.key});

  @override
  State<CrawlerHomePage3> createState() => _CrawlerHomePage3State();
}

class _CrawlerHomePage3State extends State<CrawlerHomePage3> {
  // Constants
  static const int maxDepth = 10;

  // State variables
  final _urlController = TextEditingController();
  final _fileNameController = TextEditingController();
  String _selectedExtension = ".mkv";
  bool _createZip = false;
  bool _processAsSeries = false;

  // Crawler control state
  bool _isProcessing = false;
  bool _isCancelled = false;
  bool _isPaused = false;

  // For progress saving
  final Set<String> _foundUrls = {};
  final List<String> _logMessages = [];
  final Queue<CrawlItem> _crawlQueue = Queue<CrawlItem>();
  final Set<String> _visitedUrls = {};
  List<String> _basePaths = []; // For scope control

  // Lock to prevent multiple _crawlStep calls running simultaneously
  bool _isCrawlStepRunning = false;

  @override
  void initState() {
    super.initState();
    if (Platform.isWindows || Platform.isLinux) {
      sqfliteFfiInit();
    }
    databaseFactory = databaseFactoryFfi;
  }

  // --- Logging function ---
  void _log(String message) {
    if (!mounted) return;
    setState(() {
      _logMessages.insert(0, message);
    });
    // ignore: avoid_print
    print(message); // Also print to console for debugging
  }

  // Request storage permission (for mobile)
  Future<void> _requestStoragePermission() async {
    if (Platform.isAndroid || Platform.isIOS) {
      if (!await Permission.storage.isGranted) {
        await Permission.storage.request();
      }
    }
  }

  String _extractFileName(String url) {
    final uri = Uri.parse(url);
    String lastSegment =
        uri.pathSegments.isNotEmpty ? uri.pathSegments.last : '';
    if (lastSegment.isEmpty) return 'file';

    String filenameWithoutExtension = p.basenameWithoutExtension(lastSegment);
    return filenameWithoutExtension;
  }

  Future<void> _startProcessing() async {
    if (_urlController.text.isEmpty || _fileNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please fill in both URL(s) and Base Name.')),
      );
      return;
    }
    await _requestStoragePermission();

    setState(() {
      _isProcessing = true;
      _isCancelled = false;
      _isPaused = false;
      _foundUrls.clear();
      _logMessages.clear();
      _crawlQueue.clear();
      _visitedUrls.clear();
      _basePaths.clear();
    });

    _log("🚀 Starting processing.");

    final List<String> rootUrls = _urlController.text
        .split('\n')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    // CHANGE: Store base paths for scope control
    _basePaths = List.from(rootUrls);

    for (var url in rootUrls) {
      _crawlQueue.add(CrawlItem(url, 0));
      _visitedUrls.add(url);
    }

    _log(_processAsSeries
        ? "🎬 Processing as TV Series."
        : "🎥 Processing as Movies.");

    await _crawlLoop();

    if (_isCancelled) {
      _log("🛑 Process cancelled by user.");
    } else if (!_isPaused) {
      _log("✅ Crawl finished. Found ${_foundUrls.length} total files.");
      if (_foundUrls.isNotEmpty) {
        _log("💾 Processing and saving results...");
        if (_processAsSeries) {
          await _saveSeriesResults(_fileNameController.text);
        } else {
          await _saveMovieResults(_fileNameController.text);
        }
      }
    }

    if (mounted) {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  Future<void> _crawlLoop() async {
    while (_crawlQueue.isNotEmpty) {
      if (_isCancelled || _isPaused) {
        break;
      }
      await _crawlStep();
      await Future.delayed(const Duration(milliseconds: 50));
    }
  }

  Future<void> _crawlStep() async {
    if (_isCrawlStepRunning) return;
    _isCrawlStepRunning = true;

    if (_crawlQueue.isEmpty) {
      _isCrawlStepRunning = false;
      return;
    }
    final CrawlItem item = _crawlQueue.removeFirst();

    if (item.depth > maxDepth) {
      _log("Max depth reached at ${item.url}");
      _isCrawlStepRunning = false;
      return;
    }

    _log(" ${'  ' * item.depth}🔎 Crawling: ${item.url}");

    try {
      final uri = Uri.parse(item.url);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        BeautifulSoup bs = BeautifulSoup(response.body);
        List<Bs4Element> links = bs.findAll('a', attrs: {'href': true});

        for (var link in links) {
          if (_isCancelled || _isPaused) break;
          String href = link['href']!;
          if (href == './') continue;

          Uri fullUrl = uri.resolve(href);
          final fullUrlString = fullUrl.toString();

          // CHANGE: Enforce crawling scope. Do not go outside the base paths.
          if (!_basePaths.any((base) => fullUrlString.startsWith(base))) {
            continue; // Skip URL if it's not within the defined scope
          }

          if (_visitedUrls.contains(fullUrlString)) {
            continue;
          }

          final String pathPart = fullUrl.path;

          if (pathPart.endsWith('/')) {
            _crawlQueue.add(CrawlItem(fullUrlString, item.depth + 1));
            _visitedUrls.add(fullUrlString);
          } else {
            final String ext = p.extension(pathPart).toLowerCase();
            if (ext == _selectedExtension.toLowerCase()) {
              if (_isValidFileName(p.basename(pathPart), _selectedExtension)) {
                _log(
                    " ${'  ' * (item.depth + 1)}✔️ Found: $fullUrlString");
                _foundUrls.add(fullUrlString);
                _visitedUrls.add(fullUrlString);
              } else {
                _log(
                    " ${'  ' * (item.depth + 1)}↪️ Ignored invalid filename: $fullUrlString");
              }
            }
          }
        }
      } else {
        _log(
            " ${'  ' * item.depth}⚠️ Failed to fetch ${item.url} (Status: ${response.statusCode})");
      }
    } catch (e) {
      _log(" ${'  ' * item.depth}🔥 Error crawling ${item.url}: $e");
    }

    _isCrawlStepRunning = false;
  }

  bool _isValidFileName(String filename, String extension) {
    if (!filename.toLowerCase().endsWith(extension.toLowerCase())) {
      return false;
    }
    final nameWithoutExt =
        filename.substring(0, filename.length - extension.length);
    if (nameWithoutExt.contains('.test') ||
        nameWithoutExt.contains('.temp') ||
        nameWithoutExt.contains('.part')) {
      return false;
    }
    return true;
  }

  void _cancelProcessing() {
    _log("User requested cancellation.");
    setState(() {
      _isCancelled = true;
      _isPaused = false;
    });
  }

  // CHANGE: Pause now auto-saves the session
  void _pauseProcessing() async {
    _log("User paused the process.");
    setState(() {
      _isPaused = true;
    });
    await _saveSession(isAutoSave: true);
  }

  Future<void> _resumeProcessing() async {
    if (!_isPaused) return;
    _log("User resumed the process.");
    setState(() {
      _isPaused = false;
    });
    await _crawlLoop();

    if (!_isCancelled && !_isPaused) {
      _log(
          "✅ Crawl finished after resume. Found ${_foundUrls.length} total files.");
      if (_foundUrls.isNotEmpty) {
        _log("💾 Processing and saving results...");
        if (_processAsSeries) {
          await _saveSeriesResults(_fileNameController.text);
        } else {
          await _saveMovieResults(_fileNameController.text);
        }
      }
    }

    if (mounted) {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  // --- NEW: Session Management Logic ---
  Future<void> _saveSession({bool isAutoSave = false}) async {
    final sessionName = isAutoSave
        ? "AUTOSAVE: ${_fileNameController.text}"
        : _fileNameController.text;
    if (sessionName.trim().isEmpty) {
      _log("⚠️ Cannot save session: Base Name is empty.");
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please provide a Base Name to save.")));
      return;
    }

    _log("💾 Saving session: $sessionName...");
    final session = CrawlSession(
      sessionName: sessionName,
      savedAt: DateTime.now(),
      rootUrls: _urlController.text,
      baseName: _fileNameController.text,
      selectedExtension: _selectedExtension,
      processAsSeries: _processAsSeries ? 1 : 0,
      crawlQueueJson:
          jsonEncode(_crawlQueue.map((item) => item.toJson()).toList()),
      visitedUrlsJson: jsonEncode(_visitedUrls.toList()),
      foundUrlsJson: jsonEncode(_foundUrls.toList()),
    );

    await SessionDatabase.instance.create(session);
    _log("✅ Session '$sessionName' saved successfully.");
    if (mounted) {
      setState(() {}); // Refresh UI to show new session in menu
    }
  }

  Future<void> _loadSession(CrawlSession session) async {
    _log("🔄 Loading session: ${session.sessionName}...");
    _urlController.text = session.rootUrls;
    _fileNameController.text = session.baseName;

    // Deserialize and load state
    final queueList = jsonDecode(session.crawlQueueJson) as List;
    final visitedList = jsonDecode(session.visitedUrlsJson) as List;
    final foundList = jsonDecode(session.foundUrlsJson) as List;

    setState(() {
      _selectedExtension = session.selectedExtension;
      _processAsSeries = session.processAsSeries == 1;

      _crawlQueue.clear();
      _crawlQueue
          .addAll(queueList.map((item) => CrawlItem.fromJson(item)).toList());

      _visitedUrls.clear();
      _visitedUrls.addAll(List<String>.from(visitedList));

      _foundUrls.clear();
      _foundUrls.addAll(List<String>.from(foundList));

      _basePaths = session.rootUrls
          .split('\n')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();

      _isProcessing = true;
      _isPaused = true;
      _isCancelled = false;
      _logMessages.clear();
      _log("✅ Session loaded. Found ${_foundUrls.length} files so far.");
      _log("   Queue has ${_crawlQueue.length} URLs remaining.");
      _log("   Press 'Resume' to continue.");
    });
  }

  Future<void> _deleteSession(int id) async {
    _log("Deleting session...");
    await SessionDatabase.instance.delete(id);
    _log("Session deleted.");
    if (mounted) {
      setState(() {}); // Refresh UI
    }
  }

  // --- Saving Results (Unchanged) ---
  Future<void> _saveMovieResults(String baseName) async {
    _log("... Grouping found URLs by movie name.");

    final Map<String, MovieData> movieMap = {};
    final nameRegex = RegExp(r'\.\d{4}$'); // Matches .YYYY at end of string

    for (final url in _foundUrls) {
      final filenameWithoutExt = _extractFileName(url);
      // Clean the name: remove year and replace dots with spaces
      String cleanedName =
          filenameWithoutExt.replaceAll(nameRegex, '').replaceAll('.', ' ');

      movieMap.putIfAbsent(cleanedName, () => MovieData(cleanedName));
      movieMap[cleanedName]!.urls.add(url);
    }

    _log("... Found ${movieMap.length} unique movies. Saving files.");

    final String? dirPath = await FilePicker.platform.getDirectoryPath();
    if (dirPath == null) {
      _log("❌ Save cancelled. No directory selected.");
      return;
    }
    _log("📂 Saving files to: $dirPath");

    // Save CSV
    final csvFilePath = p.join(dirPath, '$baseName.csv');
    List<List<dynamic>> rows = [
      ['Name', 'URL']
    ];
    movieMap.forEach((name, data) {
      rows.add([name, data.urls.join(',')]);
    });
    await File(csvFilePath)
        .writeAsString(const ListToCsvConverter().convert(rows));
    _log(" - Saved $csvFilePath");

    // Save SQLite DB
    final dbFilePath = p.join(dirPath, '$baseName.db');
    Database database = await openDatabase(dbFilePath, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE Movies (id INTEGER PRIMARY KEY, name TEXT, urls TEXT)');
    });

    for (final movie in movieMap.values) {
      await database
          .insert('Movies', {'name': movie.name, 'urls': movie.urls.join(',')});
    }
    await database.close();

    _log(" - Saved $dbFilePath");

    _showSuccessDialog(movieMap.length, "movies", dirPath);
  }

  Future<void> _saveSeriesResults(String baseName) async {
    _log("... Pivoting data for series.");

    final Map<String, Map<String, dynamic>> pivotData = {};

    for (final url in _foundUrls) {
      final quality = _extractQuality(url) ?? 'unknown';
      final season = _extractSeason(url);
      final episodeNum = _extractEpisodeNumber(url);

      if (season != null && episodeNum != null) {
        final episodeId = "$season$episodeNum";
        String seriesName = _extractSeriesName(url, episodeId) ?? baseName;
        final pivotKey = "${seriesName}_$episodeId";

        pivotData.putIfAbsent(
            pivotKey, () => {'Series': seriesName, 'Episode': episodeId});
        pivotData[pivotKey]![quality] = url;
      }
    }

    _log("... Found ${pivotData.length} unique episodes. Saving files.");

    final String? dirPath = await FilePicker.platform.getDirectoryPath();
    if (dirPath == null) {
      _log("❌ Save cancelled. No directory selected.");
      return;
    }
    _log("📂 Saving files to: $dirPath");

    final headers = [
      'Series',
      'Episode',
      '1080p',
      '720p',
      '540p',
      '480p',
      'Dubbed'
    ];
    List<List<dynamic>> rows = [headers];

    final sortedKeys = pivotData.keys.toList()..sort();
    for (final key in sortedKeys) {
      final episodeData = pivotData[key]!;
      rows.add(headers.map((h) => episodeData[h] ?? '').toList());
    }

    final csvFilePath = p.join(dirPath, '$baseName.csv');
    await File(csvFilePath)
        .writeAsString(const ListToCsvConverter().convert(rows));
    _log(" - Saved $csvFilePath");

    _showSuccessDialog(pivotData.length, "episodes", dirPath);
  }

  // --- Series Helpers (Unchanged) ---
  String? _extractQuality(String url) {
    final match = RegExp(r'(1080p|720p|540p|480p|Dubbed)', caseSensitive: false)
        .firstMatch(url);
    return match?.group(1);
  }

  String? _extractSeason(String url) {
    final match = RegExp(r'/S(\d+)/', caseSensitive: false).firstMatch(url);
    if (match != null) {
      return 'S${int.parse(match.group(1)!).toString().padLeft(2, '0')}';
    }
    return null;
  }

  String? _extractEpisodeNumber(String url) {
    final filename = url.split('/').last;
    RegExpMatch? match;

    match = RegExp(r'S\d+E(\d+)', caseSensitive: false).firstMatch(filename);
    if (match != null) {
      return 'E${int.parse(match.group(1)!).toString().padLeft(2, '0')}';
    }

    match = RegExp(r'Ep(?:isode)?\.?(\d+)', caseSensitive: false)
        .firstMatch(filename);
    if (match != null) {
      return 'E${int.parse(match.group(1)!).toString().padLeft(2, '0')}';
    }

    match = RegExp(r'(?<!\d)(?<!p)[._-](\d{2,3})[._-]').firstMatch(filename);
    if (match != null) {
      return 'E${int.parse(match.group(1)!).toString().padLeft(2, '0')}';
    }

    match = RegExp(r'\.(\d{2,3})\.').firstMatch(filename);
    if (match != null && !_isQualityString(match.group(0)!)) {
      return 'E${int.parse(match.group(1)!).toString().padLeft(2, '0')}';
    }

    return null;
  }

  String? _extractSeriesName(String url, String episodeId) {
    final filename = Uri.decodeComponent(url.split('/').last);
    final stopIndex = filename.indexOf(episodeId.split('E')[0]);
    if (stopIndex != -1) {
      return filename.substring(0, stopIndex).replaceAll('.', ' ').trim();
    }
    return null;
  }

  bool _isQualityString(String text) => RegExp(r'\d+p').hasMatch(text);

  // --- Dialogs (Unchanged) ---
  void _showSuccessDialog(int count, String itemType, String path) {
    if (!mounted) return;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Success'),
            content: Text(
                'Successfully processed and saved $count $itemType.\nFiles saved in: $path'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'))
            ],
          );
        });
  }

  void _showSimpleDialog(String title, String content) {
    if (!mounted) return;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'))
            ],
          );
        });
  }

  // --- UI Build ---
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Web Crawler & Processor'),
          // NEW: AppBar actions for session management
          actions: [
            _buildSessionMenu(),
          ],
          bottom: const TabBar(tabs: [
            Tab(icon: Icon(Icons.cloud_download), text: 'Crawler'),
            Tab(icon: Icon(Icons.build), text: 'Tools'),
            Tab(icon: Icon(Icons.api_outlined), text: 'REST Client'),
            Tab(
                icon: Icon(Icons.self_improvement_outlined),
                text: 'Simple Crawler'),
          ]),
        ),
        body: TabBarView(
          children: [
            _buildCrawlerTab(),
            _buildToolsTab(),
            _buildRestTab(),
            _buildSimpleCrewler(),
          ],
        ),
      ),
    );
  }

  // NEW: Popup menu for loading/deleting sessions
  Widget _buildSessionMenu() {
    return FutureBuilder<List<CrawlSession>>(
      future: SessionDatabase.instance.readAllSessions(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return IconButton(
            icon: const Icon(Icons.history),
            tooltip: "No saved sessions",
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("No saved sessions found.")),
              );
            },
          );
        }

        final sessions = snapshot.data!;
        return PopupMenuButton<CrawlSession>(
          icon: const Icon(Icons.history),
          tooltip: "Load Session",
          onSelected: (session) => _loadSession(session),
          itemBuilder: (context) => sessions.map((session) {
            return PopupMenuItem<CrawlSession>(
              value: session,
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(session.sessionName,
                    overflow: TextOverflow.ellipsis),
                subtitle: Text(
                    session.savedAt.toLocal().toString().substring(0, 16)),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the menu
                    _deleteSession(session.id!);
                  },
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildCrawlerTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        TextField(
          controller: _fileNameController,
          decoration: const InputDecoration(labelText: 'Base Name for Saving'),
          enabled: !_isProcessing,
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _urlController,
          decoration: const InputDecoration(
              labelText: 'Starting URL(s) - One per line',
              alignLabelWithHint: true),
          keyboardType: TextInputType.multiline,
          maxLines: 5,
          minLines: 1,
          enabled: !_isProcessing,
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: _selectedExtension,
          decoration: const InputDecoration(labelText: 'File Extension'),
          items: [
            ".mp4",
            ".mkv",
            ".mp3",
            ".srt",
            ".avi",
            ".mov",
            ".ass",
            ".vtt",
            ".webm",
            ".pdf",
            ".doc",
            ".docx",
            ".flac",
            ".exe",
            ".txt"
          ].map((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
          onChanged: _isProcessing
              ? null
              : (v) => setState(() => _selectedExtension = v!),
        ),
        const SizedBox(height: 16),
        CheckboxListTile(
          title: const Text('Process as TV Series (Pivot Data)'),
          value: _processAsSeries,
          onChanged: _isProcessing
              ? null
              : (v) => setState(() => _processAsSeries = v!),
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
        ),
        CheckboxListTile(
          title: const Text('Create a Zip file'),
          value: _createZip,
          onChanged:
              _isProcessing ? null : (v) => setState(() => _createZip = v!),
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
        ),
        const SizedBox(height: 24),

        // Buttons shown based on state
        if (_isProcessing) ...[
          const LinearProgressIndicator(),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.pause),
                label: const Text('Pause'),
                onPressed: _isPaused ? null : _pauseProcessing,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.play_arrow),
                label: const Text('Resume'),
                onPressed: _isPaused ? _resumeProcessing : null,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              ),
              // NEW: Save Session Button
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('Save'),
                onPressed: () => _saveSession(),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.cancel),
                label: const Text('Cancel'),
                onPressed: _cancelProcessing,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              ),
            ],
          ),
        ] else
          ElevatedButton.icon(
            icon: const Icon(Icons.play_arrow),
            label: const Text('Start Processing'),
            onPressed: _startProcessing,
            style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16)),
          ),

        const SizedBox(height: 24),
        const Text('Logs', style: TextStyle(fontWeight: FontWeight.bold)),
        const Divider(),
        Container(
          height: 200,
          padding: const EdgeInsets.all(8.0),
          color: Colors.black.withOpacity(0.2),
          child: ListView.builder(
            reverse: true,
            itemCount: _logMessages.length,
            itemBuilder: (context, index) => Text(_logMessages[index]),
          ),
        )
      ]),
    );
  }

  Widget _buildToolsTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text("Post-Processing Tools",
            style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 20),
        ListTile(
          leading: const Icon(Icons.cleaning_services),
          title: const Text("Fix & Clean CSV File"),
          subtitle: const Text(
              "Removes '_PartX' from the first column of a selected CSV file."),
          trailing: ElevatedButton(
            onPressed: _isProcessing ? null : _runFixAndCleanTask,
            child: const Text("Run Task"),
          ),
        ),
            ListTile(
          leading: const Icon(Icons.perm_contact_calendar_sharp),
          title: const Text("Data Import from Tmdb"),
          subtitle: const Text(
              "Import Data for Each series from TMDB with selected CSV file."),
          trailing: ElevatedButton(
            onPressed: () => _navigateTo(context, TmdbDatailsProcess(), true),
            child: const Text("Open Page"),
          ),
        ),
        
      ]),
    );
  }

  void _navigateTo(BuildContext context, Widget screen, bool isMobileLayout) {
    if (isMobileLayout) Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }
  Widget _buildRestTab() {
    return const SizedBox(
      child: HttpClientPage(),
    );
  }

  Widget _buildSimpleCrewler() {
    return const SizedBox(
      child: CrawlerHomePage(),
    );
  }

  Future<void> _runFixAndCleanTask() async {
    _log("🔧 Starting 'Fix & Clean' task...");
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['csv']);

    if (result == null || result.files.single.path == null) {
      _log("... Task cancelled. No input file selected.");
      return;
    }
    final inputPath = result.files.single.path!;
    _log("... Selected input file: $inputPath");

    try {
      final rawCsv = await File(inputPath).readAsString();
      List<List<dynamic>> csvTable = const CsvToListConverter().convert(rawCsv);

      if (csvTable.isEmpty) {
        _log("... Error: CSV file is empty.");
        return;
      }

      final partRegex = RegExp(r'_[Pp]art\d+$');
      for (int i = 1; i < csvTable.length; i++) {
        if (csvTable[i].isNotEmpty) {
          csvTable[i][0] = csvTable[i][0].toString().replaceAll(partRegex, '');
        }
      }

      String? outputPath = await FilePicker.platform.saveFile(
        dialogTitle: 'Please select an output file:',
        fileName: '${_fileNameController.text}_fixed.csv',
      );

      if (outputPath == null) {
        _log("... Task cancelled. No output file selected.");
        return;
      }

      final newCsv = const ListToCsvConverter().convert(csvTable);
      await File(outputPath).writeAsString(newCsv);
      _log("... ✅ Successfully processed and saved to: $outputPath");

      _showSimpleDialog(
          "Success", "The CSV file has been processed and saved successfully.");
    } catch (e) {
      _log("... ❌ Error during 'Fix & Clean' task: $e");
      _showSimpleDialog("Error", "An error occurred: $e");
    }
  }

  @override
  void dispose() {
    _urlController.dispose();
    _fileNameController.dispose();
    SessionDatabase.instance.close(); // Close the database connection
    super.dispose();
  }
}

// CHANGE: CrawlItem is now serializable
class CrawlItem {
  final String url;
  final int depth;

  CrawlItem(this.url, this.depth);

  Map<String, dynamic> toJson() => {'url': url, 'depth': depth};

  factory CrawlItem.fromJson(Map<String, dynamic> json) {
    return CrawlItem(json['url'] as String, json['depth'] as int);
  }
}

// Data model for Movie (Unchanged)
class MovieData {
  String name;
  List<String> urls = [];

  MovieData(this.name);
}