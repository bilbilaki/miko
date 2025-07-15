import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:csv/csv.dart';
import 'package:miko/screens/http.dart';
import 'package:miko/screens/http_rest.dart';
import 'package:permission_handler/permission_handler.dart';

// Use sqflite_common_ffi for desktop support
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// Enum to manage the current processing mode
enum ProcessingMode { movies, series }

// --- Data Models for structured data ---
class MovieData {
  String name;
  List<String> urls = [];
  MovieData(this.name);
}

// --- Global Settings ---
const int maxDepth = 10;

class CrawlerHomePage1 extends StatefulWidget {
  const CrawlerHomePage1({super.key});

  @override
  State<CrawlerHomePage1> createState() => _CrawlerHomePage1State();
}

class _CrawlerHomePage1State extends State<CrawlerHomePage1> {
  // --- State Variables ---
  final _urlController = TextEditingController();
  final _fileNameController = TextEditingController();
  String _selectedExtension = ".mkv";
  bool _createZip = false;
  bool _processAsSeries = false; // New checkbox state
  bool _isProcessing = false;
  bool _isCancelled = false;
  final List<String> _foundUrls = [];
  final List<String> _logMessages = [];

  // --- Helper Functions ---
  void _log(String message) {
    if (!mounted) return;
    setState(() {
      _logMessages.insert(0, message);
    });
  }

  Future<void> _requestStoragePermission() async {
    if (Platform.isAndroid || Platform.isIOS) {
      if (!await Permission.storage.isGranted) {
        await Permission.storage.request();
      }
    }
  }

  // --- Core Processing Logic ---
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
      _foundUrls.clear();
      _logMessages.clear();
    });

    final List<String> urlsToCrawl = _urlController.text
        .split('\n')
        .where((line) => line.trim().isNotEmpty)
        .toList();

    _log("🚀 Starting processing for ${urlsToCrawl.length} base URL(s).");
    _log(_processAsSeries
        ? "🎬 Processing as TV Series."
        : "🎥 Processing as Movies.");

    try {
      for (final url in urlsToCrawl) {
        if (_isCancelled) break;
        await _crawlDirectory(url, 0);
      }

      if (_isCancelled) {
        _log("🛑 Process cancelled by user.");
      } else {
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
    } catch (e, s) {
      _log("❌ An unexpected error occurred: $e\n$s");
    }

    setState(() {
      _isProcessing = false;
    });
  }

  void _cancelProcessing() {
    setState(() {
      _isCancelled = true;
    });
  }

  Future<void> _crawlDirectory(String url, int depth) async {
    if (depth > maxDepth || _isCancelled) return;
    _log("  " * depth + "🔎 Crawling: $url");

    try {
      final uri = Uri.parse(url);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        BeautifulSoup bs = BeautifulSoup(response.body);
        List<Bs4Element> links = bs.findAll('a', attrs: {'href': true});

        for (var link in links) {
          if (_isCancelled) return;
          String href = link['href']!;
          if (href == '../' || href == './') continue;

          Uri fullUrl = uri.resolve(href);
          if (fullUrl.path.endsWith(_selectedExtension)) {
            _log("  " * (depth + 1) + "✔️ Found: ${fullUrl.toString()}");
            if (!mounted) return;
            setState(() {
              _foundUrls.add(fullUrl.toString());
            });
          } else if (fullUrl.path.endsWith('/')) {
            await _crawlDirectory(fullUrl.toString(), depth + 1);
          }
        }
      } else {
        _log("  " * depth +
            "⚠️ Failed to fetch $url (Status: ${response.statusCode})");
      }
    } catch (e) {
      _log("  " * depth + "🔥 Error crawling $url: $e");
    }
  }

  // --- Movie-Specific Saving Logic ---
  Future<void> _saveMovieResults(String baseName) async {
    _log("... Grouping found URLs by movie name.");
    // Group URLs by extracted movie name
    final Map<String, MovieData> movieMap = {};
    final nameRegex =
        RegExp(r'\.\d{4}$'); // Matches .YYYY at the end of a string

    for (final url in _foundUrls) {
      final uri = Uri.parse(url);
      final segments = uri.pathSegments;
      if (segments.length > 2) {
        // Heuristic: The movie name is often the second to last path segment.
        // e.g., /movies/.../The.Movie.Name.2023/The.Movie.Name.2023.1080p.mkv
        String potentialName = segments[segments.length - 2];
        // Clean the name: remove year and replace dots with spaces
        String cleanedName =
            potentialName.replaceAll(nameRegex, '').replaceAll('.', ' ');

        movieMap.putIfAbsent(cleanedName, () => MovieData(cleanedName));
        movieMap[cleanedName]!.urls.add(url);
      }
    }

    _log("... Found ${movieMap.length} unique movies. Saving files.");

    final String? dirPath = await FilePicker.platform.getDirectoryPath();
    if (dirPath == null) {
      _log("❌ Save cancelled. No directory selected.");
      return;
    }
    _log("📂 Saving files to: $dirPath");

    // CSV
    final csvFilePath = '$dirPath/$baseName.csv';
    List<List<dynamic>> rows = [
      ['Name', 'URL']
    ];
    movieMap.forEach((name, data) {
      rows.add([name, data.urls.join(',')]);
    });
    await File(csvFilePath)
        .writeAsString(const ListToCsvConverter().convert(rows));
    _log("   - Saved $csvFilePath");

    // SQLite DB
    final dbFilePath = '$dirPath/$baseName.db';
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
    _log("   - Saved $dbFilePath");

    _showSuccessDialog(movieMap.length, "movies", dirPath);
  }

  // --- Series-Specific Saving Logic (Pivot Table) ---
  Future<void> _saveSeriesResults(String baseName) async {
    _log("... Pivoting data for series.");

    // This map will hold the pivoted data. Key: "SeriesName_Episode", Value: Map<Quality, URL>
    final Map<String, Map<String, dynamic>> pivotData = {};

    // This is the equivalent of the pandas pivot_table logic
    for (final url in _foundUrls) {
      final quality = _extractQuality(url) ?? 'unknown';
      final season = _extractSeason(url);
      final episodeNum = _extractEpisodeNumber(url);

      if (season != null && episodeNum != null) {
        final episodeId = "$season$episodeNum";
        // Heuristic for series name: part of the filename before the season/episode marker
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

    // Define headers for the output file
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

    // Convert the pivot map to a list of rows
    final sortedKeys = pivotData.keys.toList()..sort();
    for (final key in sortedKeys) {
      final episodeData = pivotData[key]!;
      rows.add(headers.map((h) => episodeData[h] ?? '').toList());
    }

    // Save to CSV
    final csvFilePath = '$dirPath/$baseName.csv';
    await File(csvFilePath)
        .writeAsString(const ListToCsvConverter().convert(rows));
    _log("   - Saved $csvFilePath");

    _showSuccessDialog(pivotData.length, "episodes", dirPath);
  }

  // --- Series Data Extraction Helpers (Ported from Python) ---
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
    final stopIndex =
        filename.indexOf(episodeId.split('E')[0]); // Find where 'S01' starts
    if (stopIndex != -1) {
      return filename.substring(0, stopIndex).replaceAll('.', ' ').trim();
    }
    return null;
  }

  bool _isQualityString(String text) => RegExp(r'\d+p').hasMatch(text);

  // --- Post-Processing "Fix & Clean" Task ---
  Future<void> _runFixAndCleanTask() async {
    _log("🔧 Starting 'Fix & Clean' task...");
    // 1. Pick input file
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result == null || result.files.single.path == null) {
      _log("... Task cancelled. No input file selected.");
      return;
    }
    final inputPath = result.files.single.path!;
    _log("... Selected input file: $inputPath");

    // 2. Read and process the CSV
    try {
      final rawCsv = await File(inputPath).readAsString();
      List<List<dynamic>> csvTable = const CsvToListConverter().convert(rawCsv);

      if (csvTable.isEmpty) {
        _log("... Error: CSV file is empty.");
        return;
      }

      final partRegex = RegExp(r'_[Pp]art\d+$');
      // Process all rows except the header
      for (int i = 1; i < csvTable.length; i++) {
        if (csvTable[i].isNotEmpty) {
          csvTable[i][0] = csvTable[i][0].toString().replaceAll(partRegex, '');
        }
      }

      // 3. Pick output file location
      String? outputPath = await FilePicker.platform.saveFile(
        dialogTitle: 'Please select an output file:',
        fileName: '${_fileNameController.text}_fixed.csv',
      );

      // 4. Save the new CSV
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

  // --- UI Dialogs ---
  void _showSuccessDialog(int count, String itemType, String path) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Success'),
        content: Text(
            'Successfully processed and saved $count $itemType.\nFiles saved in: $path'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'))
        ],
      ),
    );
  }

  void _showSimpleDialog(String title, String content) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'))
        ],
      ),
    );
  }

  // --- UI Build Methods ---
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // Now we have two tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Web Crawler & Processor'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.cloud_download), text: 'Crawler'),
              Tab(icon: Icon(Icons.build), text: 'Tools'),
              Tab(icon: Icon(Icons.api_outlined), text: 'REST Client'),
              Tab(
                  icon: Icon(Icons.self_improvement_outlined),
                  text: 'Simple Crawler'),
            ],
          ),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _fileNameController,
            decoration:
                const InputDecoration(labelText: 'Base Name for Saving'),
            enabled: !_isProcessing,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _urlController,
            decoration: const InputDecoration(
              labelText: 'Starting URL(s) - One per line',
              alignLabelWithHint: true,
            ),
            keyboardType: TextInputType.multiline,
            maxLines: 5,
            minLines: 1,
            enabled: !_isProcessing,
          ),
          const SizedBox(height: 16),
          // Dropdown for extension
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
          if (_isProcessing)
            Column(
              children: [
                const LinearProgressIndicator(),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  icon: const Icon(Icons.cancel),
                  label: const Text('Cancel Process'),
                  onPressed: _cancelProcessing,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ],
            )
          else
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
          ),
        ],
      ),
    );
  }

  Widget _buildToolsTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
        ],
      ),
    );
  }

  Widget _buildRestTab() {
    return SizedBox(
      //padding: const EdgeInsets.all(16.0),
      child: HttpClientPage(),
    );
  }

  Widget _buildSimpleCrewler() {
    return SizedBox(
      //padding: const EdgeInsets.all(16.0),
      child: CrawlerHomePage(),
    );
  }

  @override
  void dispose() {
    _urlController.dispose();
    _fileNameController.dispose();
    super.dispose();
  }
}
