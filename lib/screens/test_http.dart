import 'dart:async';
import 'dart:collection';
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

enum ProcessingMode { movies, series }

// Data model for Movie
class MovieData {
  String name;
  List<String> urls = [];

  MovieData(this.name);
}

class CrawlerHomePage2 extends StatefulWidget {
  const CrawlerHomePage2({super.key});

  @override
  State<CrawlerHomePage2> createState() => _CrawlerHomePage2State();
}

class _CrawlerHomePage2State extends State<CrawlerHomePage2> {
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
  final Set<String> _foundUrls = {}; // Using Set to avoid duplicates
  final List<String> _logMessages = [];

  // Queue of URLs pending crawl
  final Queue<CrawlItem> _crawlQueue = Queue<CrawlItem>();

  // To avoid loops, keep track of visited URLs
  final Set<String> _visitedUrls = {};

  // Lock to prevent multiple _crawlStep calls running simultaneously
  bool _isCrawlStepRunning = false;

  // Used to save crawl progress in a file (optional persistence)

  @override
  void initState() {
    super.initState();
    // Init sqflite for desktop
    sqfliteFfiInit();
  }

  // --- Logging function ---
  void _log(String message) {
    if (!mounted) return;
    setState(() {
      _logMessages.insert(0, message);
    });
  }

  // Request storage permission (for mobile)
  Future<void> _requestStoragePermission() async {
    if (Platform.isAndroid || Platform.isIOS) {
      if (!await Permission.storage.isGranted) {
        await Permission.storage.request();
      }
    }
  }

  // Extract file name (without extension) from URL path
  String _extractFileName(String url) {
    final uri = Uri.parse(url);
    String lastSegment =
        uri.pathSegments.isNotEmpty ? uri.pathSegments.last : '';
    if (lastSegment.isEmpty) return 'file';

    String filenameWithoutExtension = p.basenameWithoutExtension(lastSegment);
    return filenameWithoutExtension;
  }

  // Starts processing (for URLs input)
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
    });

    _log("🚀 Starting processing.");

    final List<String> rootUrls = _urlController.text
        .split('\n')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    // Seed queue with starting URLs at depth 0
    for (var url in rootUrls) {
      _crawlQueue.add(CrawlItem(url, 0));
      _visitedUrls.add(url);
    }

    _log(_processAsSeries
        ? "🎬 Processing as TV Series."
        : "🎥 Processing as Movies.");

    // Start the crawl loop
    // Use a periodic timer or manual async loop to allow pause/resume
    await _crawlLoop();

    // After crawl finished or cancelled
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
    } else {
      _log("⏸️ Crawl paused by user. Progress saved.");
    }

    setState(() {
      _isProcessing = false;
    });
  }

  // Crawl loop: runs until queue empty or cancelled or paused
  Future<void> _crawlLoop() async {
    while (_crawlQueue.isNotEmpty) {
      if (_isCancelled || _isPaused) {
        break;
      }
      await _crawlStep();
      // A small delay to update UI and give responsiveness
      await Future.delayed(const Duration(milliseconds: 50));
    }
  }

  // Single crawl step: dequeue one item and process it
  Future<void> _crawlStep() async {
    if (_isCrawlStepRunning) return;
    _isCrawlStepRunning = true;

    if (_crawlQueue.isEmpty) {
      _isCrawlStepRunning = false;
      return;
    }
    final CrawlItem item = _crawlQueue.removeFirst();

    // Check depth limit
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
          if (href == '../' || href == './') continue;

          // Resolve relative URL
          Uri fullUrl = uri.resolve(href);

          // Avoid re-visiting
          if (_visitedUrls.contains(fullUrl.toString())) {
            // Skip duplicates to prevent loops
            continue;
          }

          // Check if it's a directory or file
          final String pathPart = fullUrl.path;

          if (pathPart.endsWith('/')) {
            // Directory detected, enqueue for crawling (increment depth)
            _crawlQueue.add(CrawlItem(fullUrl.toString(), item.depth + 1));
            _visitedUrls.add(fullUrl.toString());
          } else {
            // File found, check extension strictly
            final String ext = p.extension(pathPart).toLowerCase();

            if (ext == _selectedExtension.toLowerCase()) {
              // Additional check: skip unwanted files like '.test.mp4'
              if (_isValidFileName(p.basename(pathPart), _selectedExtension)) {
                _log(
                    " ${'  ' * (item.depth + 1)}✔️ Found: ${fullUrl.toString()}");
                _foundUrls.add(fullUrl.toString());
                _visitedUrls.add(fullUrl.toString());

                // Periodically save progress if needed here
                // Example: await _saveProgress();
              } else {
                // Skip this weird file
                _log(
                    " ${'  ' * (item.depth + 1)}↪️ Ignored invalid filename: ${fullUrl.toString()}");
              }
            } else {
              // Not target file extension, but might still be a dir if ends with '/'
              // ignore
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

  // Helper to validate filename (skip 'test' or multiple dot extensions beyond permitted)
  bool _isValidFileName(String filename, String extension) {
    // Only allow file that ends exactly with extension, no extra suffixes like .test.mp4
    if (!filename.toLowerCase().endsWith(extension.toLowerCase())) {
      return false;
    }

    // To prevent files like 'movie.test.mp4', we allow only 1 dot extensions or clean filenames
    // count dots before extension
    final nameWithoutExt =
        filename.substring(0, filename.length - extension.length);
    if (nameWithoutExt.contains('.test') ||
        nameWithoutExt.contains('.temp') ||
        nameWithoutExt.contains('.part')) {
      return false;
    }

    return true;
  }

  // Cancel processing
  void _cancelProcessing() {
    _log("User requested cancellation.");
    setState(() {
      _isCancelled = true;
      _isPaused = false;
    });
  }

  // Pause processing
  void _pauseProcessing() {
    _log("User paused the process.");
    setState(() {
      _isPaused = true;
    });
  }

  // Resume processing
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

    setState(() {
      _isProcessing = false;
    });
  }

  // Saving function for movie results
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

  // Saving function for TV series results
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

  // Series helpers unchanged
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

  // Show success dialogs
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

  // UI Build including pause/resume buttons
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Web Crawler & Processor'),
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
          Row(
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.pause),
                label: const Text('Pause'),
                onPressed: _isPaused ? null : _pauseProcessing,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                icon: const Icon(Icons.play_arrow),
                label: const Text('Resume'),
                onPressed: _isPaused ? _resumeProcessing : null,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              ),
              const SizedBox(width: 12),
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
            child: const Text("Open page"),
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
      //padding: const EdgeInsets.all(16.0),
      child: HttpClientPage(),
    );
  }

  Widget _buildSimpleCrewler() {
    return const SizedBox(
      //padding: const EdgeInsets.all(16.0),
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

      final newCsv = const ListToCsvConverter().convert(csvTable);
      await File(outputPath!).writeAsString(newCsv);
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
    super.dispose();
  }
}

// Crawl Item class to hold url and current depth
class CrawlItem {
  final String url;
  final int depth;

  CrawlItem(this.url, this.depth);
}
