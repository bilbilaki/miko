import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:csv/csv.dart';
import 'package:miko/screens/dataset_manager_screen.dart';
import 'package:miko/screens/scrap_page.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as p;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:miko/providers/csv_detail_process_provider.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart'; // Added import

class UpdateBia2AnimeResources extends StatefulWidget {
  const UpdateBia2AnimeResources({super.key});

  @override
  State<UpdateBia2AnimeResources> createState() =>
      _UpdateBia2AnimeResourcesState();
}

class _UpdateBia2AnimeResourcesState extends State<UpdateBia2AnimeResources> {
  // Constants
  // NEW: Concurrency control
  static const int maxConcurrentRequests = 10;

  // State variables
  final _urlController = TextEditingController(text: 'https://bia2anime.us');
  final _fileNameController = TextEditingController();
  String _selectedExtension = ".mkv";
  bool _createZip = false;
  final bool _processAsSeries = true;
  bool _saveToApp = false;
  String _targetProvider = 'Anime'; // 'Anime' or 'TV'

  // Crawler control state
  bool _isProcessing = false;
  bool _isCancelled = false;
  bool _isPaused = false;
  int _activeWorkers = 0; // NEW: Concurrency control

  // For progress saving
  final Set<String> _foundUrls = {};
  final List<String> _logMessages = [];
  final Queue<CrawlItem> _crawlQueue = Queue<CrawlItem>();
  final Set<String> _visitedUrls = {};
  List<String> _basePaths = [];
  final Map<String, Map<String, dynamic>> pivotData = {};

  @override
  void initState() {
    super.initState();
  }

  void _log(String message) {
    if (!mounted) return;
    setState(() {
      _logMessages.insert(0, message);
    });
    print(message);
  }

  Future<void> _requestStoragePermission() async {
    if (Platform.isAndroid || Platform.isIOS) {
      if (!await Permission.storage.isGranted) {
        await Permission.storage.request();
      }
    }
  }

  Future<void> _startProcessing() async {
    if (_fileNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in the Base Name.')),
      );
      return;
    }
    await _requestStoragePermission();

    setState(() {
      _isProcessing = true;
      _isCancelled = false;
      _isPaused = false;
      _activeWorkers = 0;
      _foundUrls.clear();
      _logMessages.clear();
      _crawlQueue.clear();
      _visitedUrls.clear();
      _basePaths.clear();
      pivotData.clear();
    });

    _log(
      "🚀 Starting processing with up to $maxConcurrentRequests concurrent workers.",
    );

    final List<String> rootUrls = ['https://bia2anime.us'];

    _basePaths = List.from(rootUrls);

    for (var url in rootUrls) {
      _crawlQueue.add(CrawlItem(url, 0));
      _visitedUrls.add(url);
    }

    _log(
      _processAsSeries
          ? "🎬 Processing as TV Series."
          : "🎥 Processing as Movies.",
    );

    await _crawlLoop(); // Start the concurrent loop

    // This block runs after the crawl loop is completely finished
    if (_isCancelled) {
      _log("🛑 Process cancelled by user.");
    } else if (!_isPaused) {
      _log("✅ Crawl finished. Found ${pivotData.length} total episodes.");
      if (pivotData.isNotEmpty) {
        _log("💾 Processing and saving results...");
        await _saveSeriesResults(_fileNameController.text);
      }
    }

    if (mounted) {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  // --- NEW: Concurrent Crawl Loop ---
  Future<void> _crawlLoop() async {
    while ((_crawlQueue.isNotEmpty || _activeWorkers > 0) && !_isCancelled) {
      if (_isPaused) {
        await Future.delayed(const Duration(milliseconds: 100));
        continue;
      }

      if (_crawlQueue.isNotEmpty && _activeWorkers < maxConcurrentRequests) {
        _activeWorkers++;
        final item = _crawlQueue.removeFirst();

        _crawlStep(item).then((_) {
          if (mounted) {
            setState(() {
              _activeWorkers--;
            });
          }
        });
      }

      await Future.delayed(const Duration(milliseconds: 30));
    }
  }

  Future<void> _crawlStep(CrawlItem item) async {
    if (_isCancelled) return;

    _log("🔎 Crawling: ${item.url} (depth: ${item.depth})");

    try {
      final uri = Uri.parse(item.url);
      final response = await http.get(uri).timeout(const Duration(seconds: 20));

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 301 ||
          response.statusCode == 303) {
        BeautifulSoup bs = BeautifulSoup(response.body);

        if (item.depth == 0) {
          // Process page for articles and pagination
          if (item.url == 'https://bia2anime.us') {
            // Find last page
            var pagination = bs.find('div', class_: 'pagination');
            int maxPage = 1;
            if (pagination != null) {
              var links = pagination.findAll('a');
              for (var link in links) {
                String href = link['href'] ?? '';
                RegExp reg = RegExp(r'/page/(\d+)');
                var match = reg.firstMatch(href);
                if (match != null) {
                  int p = int.parse(match.group(1)!);
                  if (p > maxPage) maxPage = p;
                }
              }
              _log("Found $maxPage pages.");
              for (int p = 2; p <= maxPage; p++) {
                String pageUrl = 'https://bia2anime.us/page/$p';
                if (!_visitedUrls.contains(pageUrl)) {
                  _crawlQueue.add(CrawlItem(pageUrl, 0));
                  _visitedUrls.add(pageUrl);
                }
              }
            }
          }

          // Find articles
          List<Bs4Element> articles = bs.findAll('article', class_: 'post2');
          for (var article in articles) {
            var a = article.find('h2')?.find('a');
            if (a != null) {
              String postUrl = a['href'] ?? '';
              if (postUrl.isNotEmpty && !_visitedUrls.contains(postUrl)) {
                _crawlQueue.add(CrawlItem(postUrl, 1));
                _visitedUrls.add(postUrl);
              }
            }
          }
        } else if (item.depth == 1) {
          // Process post page for downloads
          String seriesName = _extractSeriesNameFromPage(bs);
          var content = bs
              .find('div', class_: 'content')
              ?.find('div', class_: 'post2');
          if (content != null) {
            var accordion = content.find('div', class_: 'accordion');
            if (accordion != null) {
              var items = accordion.findAll('div', class_: 'accordion-item');
              for (var accItem in items) {
                String season = _parseSeason(
                  accItem.find('h4')?.find('button')?.text ?? '',
                );
                var body = accItem.find('div', class_: 'accordion-body');
                if (body != null) {
                  var episodes = body.findAll('div', class_: 'download_item');
                  for (var ep in episodes) {
                    String episode = _parseEpisode(
                      ep.find('div', class_: 'serial-dl-info')?.text ?? '',
                    );
                    Map<String, String> qualities = {};
                    String subUrl = '';
                    var buttons = ep.findAll('a', class_: 'button');
                    for (var btn in buttons) {
                      String href = btn['href'] ?? '';
                      String text = btn.text.trim();
                      if (text.contains('1080p')) {
                        qualities['1080p'] = href;
                      } else if (text.contains('720p'))
                        qualities['720p'] = href;
                      else if (text.contains('540p'))
                        qualities['540p'] = href;
                      else if (text.contains('480p'))
                        qualities['480p'] = href;
                      else if (text.contains('زیرنویس'))
                        subUrl = href;
                    }
                    String key = '${seriesName}_$season$episode';
                    pivotData.putIfAbsent(
                      key,
                      () => {
                        'Series': seriesName,
                        'Episode': '$season$episode',
                      },
                    );
                    pivotData[key]!.addAll(qualities);
                    if (subUrl.isNotEmpty) pivotData[key]!['Subtitle'] = subUrl;
                  }
                }
              }
            }
          }
        }
      } else {
        _log("⚠️ Failed to fetch ${item.url} (Status: ${response.statusCode})");
      }
    } catch (e) {
      _log("🔥 Error crawling ${item.url}: $e");
    }
  }

  String _extractSeriesNameFromPage(BeautifulSoup bs) {
    var title = bs.find('title')?.text ?? '';
    return title.split(' - ').first.trim();
  }

  String _parseSeason(String text) {
    RegExp reg = RegExp(r'فصل\s+(\w+)');
    var match = reg.firstMatch(text);
    if (match != null) {
      String numStr = match.group(1)!;
      int num = _persianToInt(numStr);
      return 'S${num.toString().padLeft(2, '0')}';
    }
    return 'S01';
  }

  String _parseEpisode(String text) {
    RegExp reg = RegExp(r'قسمت\s+(\d+)');
    var match = reg.firstMatch(text);
    if (match != null) {
      return 'E${int.parse(match.group(1)!).toString().padLeft(2, '0')}';
    }
    return 'E01';
  }

  int _persianToInt(String persian) {
    const Map<String, int> map = {
      'اول': 1,
      'دوم': 2,
      'سوم': 3,
      'چهارم': 4,
      'پنجم': 5,
      'ششم': 6,
      'هفتم': 7,
      'هشتم': 8,
      'نهم': 9,
      'دهم': 10,
    };
    return map[persian] ?? 1;
  }

  void _cancelProcessing() {
    _log("User requested cancellation.");
    setState(() {
      _isCancelled = true;
      _isPaused = false;
    });
  }

  void _pauseProcessing() async {
    _log("User paused the process. Finishing active requests...");
    setState(() {
      _isPaused = true;
    });
    // Let's give it a moment for active workers to potentially finish before saving.
    await Future.delayed(const Duration(seconds: 1));
    await _saveSession(isAutoSave: true);
  }

  Future<void> _resumeProcessing() async {
    if (!_isPaused) return;
    _log("User resumed the process.");
    setState(() {
      _isPaused = false;
    });
    // The main crawl loop will automatically pick up and start spawning workers again.
    await _crawlLoop();

    if (!_isCancelled && !_isPaused) {
      _log(
        "✅ Crawl finished after resume. Found ${pivotData.length} total episodes.",
      );
      if (pivotData.isNotEmpty) {
        _log("💾 Processing and saving results...");
        await _saveSeriesResults(_fileNameController.text);
      }
    }

    if (mounted) {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  // --- Session Management Logic (Unchanged) ---
  Future<void> _saveSession({bool isAutoSave = false}) async {
    final sessionName = isAutoSave
        ? "AUTOSAVE: ${_fileNameController.text}"
        : _fileNameController.text;
    if (sessionName.trim().isEmpty) {
      _log("⚠️ Cannot save session: Base Name is empty.");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please provide a Base Name to save.")),
      );
      return;
    }

    setState(() {
      _crawlQueue.clear();

      _visitedUrls.clear();

      _foundUrls.clear();

      _isProcessing = true;
      _isPaused = true;
      _isCancelled = false;
      _activeWorkers = 0;
      _logMessages.clear();
      _log("✅ Session loaded. Found ${_foundUrls.length} files so far.");
      _log("   Queue has ${_crawlQueue.length} URLs remaining.");
      _log("   Press 'Resume' to continue.");
    });
  }

  // --- Saving Results ---
  // MODIFIED: Added fallback logic
  Future<void> _saveSeriesResults(String baseName) async {
    _log("... Found ${pivotData.length} unique episodes. Saving files.");

    final headers = [
      'Series',
      'Episode',
      '1080p',
      '720p',
      '540p',
      '480p',
      'Dubbed',
    ];
    List<List<dynamic>> rows = [headers];

    final sortedKeys = pivotData.keys.toList()..sort();
    for (final key in sortedKeys) {
      final episodeData = pivotData[key]!;
      rows.add(headers.map((h) => episodeData[h] ?? '').toList());
    }

    // --- Save to App Storage ---
    if (_saveToApp) {
      try {
        final dir = await getApplicationDocumentsDirectory();
        final filename = _targetProvider == 'Anime'
            ? 'local_anime_series_link.csv'
            : 'local_tv_series_link.csv';
        final file = File('${dir.path}/$filename');

        if (await file.exists()) {
          // Append mode: Skip header row
          final dataRows = rows.skip(1).toList();
          if (dataRows.isNotEmpty) {
            final csvToAppend = const ListToCsvConverter().convert(dataRows);
            await file.writeAsString('\n$csvToAppend', mode: FileMode.append);
            _log("✅ Appended to App Storage: $filename");
          }
        } else {
          // Create mode: Use all rows (including header)
          final csvData = const ListToCsvConverter().convert(rows);
          await file.writeAsString(csvData);
          _log("✅ Saved to App Storage: $filename");
        }
      } catch (e) {
        _log("❌ Error saving to App Storage: $e");
      }
    }
    // ---------------------------

    final String? dirPath = await FilePicker.platform.getDirectoryPath();
    if (dirPath == null) {
      _log("❌ Save cancelled. No directory selected.");
      return;
    }
    _log("📂 Saving files to: $dirPath");

    final csvFilePath = p.join(dirPath, '$baseName.csv');
    await File(
      csvFilePath,
    ).writeAsString(const ListToCsvConverter().convert(rows));
    _log(" - Saved $csvFilePath");

    _showSuccessDialog(pivotData.length, "episodes", dirPath);
  }

  // --- NEW: Fallback save function ---
  // --- Dialogs (Unchanged) ---
  void _showSuccessDialog(int count, String itemType, String path) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Success'),
          content: Text(
            'Successfully processed and saved $count $itemType.\nFiles saved in: $path',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
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
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // --- UI Build (Unchanged from previous version) ---
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Web Crawler & Processor'),
          // actions: [
          //   _buildSessionMenu(),
          // ],
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.cloud_download), text: 'Crawler'),
              Tab(icon: Icon(Icons.build), text: 'Tools'),
              //   Tab(icon: Icon(Icons.api_outlined), text: 'REST Client'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildCrawlerTab(),
            _buildToolsTab(),
            //    _buildRestTab(),
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
            decoration: const InputDecoration(
              labelText: 'Base Name for Saving',
            ),
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
          DropdownButtonFormField<String>(
            value: _selectedExtension,
            decoration: const InputDecoration(labelText: 'File Extension'),
            items:
                [
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
                  ".txt",
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
            onChanged: _isProcessing
                ? null
                : (v) => setState(() => _selectedExtension = v!),
          ),
          const SizedBox(height: 16),
          CheckboxListTile(
            title: const Text('Process as TV Series (Pivot Data)'),
            value: _processAsSeries,
            onChanged: null,
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
          ),
          CheckboxListTile(
            title: const Text('Create a Zip file'),
            value: _createZip,
            onChanged: _isProcessing
                ? null
                : (v) => setState(() => _createZip = v!),
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
          ),
          CheckboxListTile(
            title: const Text('Save to App Internal Storage (Merge)'),
            value: _saveToApp,
            onChanged: _isProcessing
                ? null
                : (v) => setState(() => _saveToApp = v!),
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
          ),
          if (_saveToApp)
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Row(
                children: [
                  const Text("Target: "),
                  DropdownButton<String>(
                    value: _targetProvider,
                    items: ['Anime', 'TV'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: _isProcessing
                        ? null
                        : (v) => setState(() => _targetProvider = v!),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 24),
          if (_isProcessing) ...[
            LinearProgressIndicator(
              // Show determinate progress for workers if possible
              value: (_crawlQueue.isNotEmpty || _activeWorkers > 0)
                  ? null
                  : 1.0,
            ),
            const SizedBox(height: 8),
            Text(
              "Queue: ${_crawlQueue.length} | Active Workers: $_activeWorkers / $maxConcurrentRequests",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.pause),
                  label: const Text('Pause'),
                  onPressed: _isPaused ? null : _pauseProcessing,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Resume'),
                  onPressed: _isPaused ? _resumeProcessing : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                ),
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
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          const SizedBox(height: 24),
          const Text('Logs', style: TextStyle(fontWeight: FontWeight.bold)),
          const Divider(),
          Container(
            height: 200,
            padding: const EdgeInsets.all(8.0),
            color: Colors.black.withValues(alpha: 0.2),
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
          Text(
            "Post-Processing Tools",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 20),
          ListTile(
            leading: const Icon(Icons.cleaning_services),
            title: const Text("Fix & Clean CSV File"),
            subtitle: const Text(
              "Removes '_PartX' from the first column of a selected CSV file.",
            ),
            trailing: ElevatedButton(
              onPressed: _isProcessing ? null : _runFixAndCleanTask,
              child: const Text("Run Task"),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.perm_contact_calendar_sharp),
            title: const Text("Data Import from Tmdb"),
            subtitle: const Text(
              "Import Data for Each series from TMDB with selected CSV file.",
            ),
            trailing: ElevatedButton(
              onPressed: () => _navigateTo(context, TmdbDatailsProcess(), true),
              child: const Text("Open page"),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.rowing),
            title: const Text("Database Exploring Page"),
            subtitle: const Text("Import and Explore and save Database to app"),
            trailing: ElevatedButton(
              onPressed: () => _navigateTo(context, DataExplorerScreen(), true),
              child: const Text("Open page"),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.manage_accounts),
            title: const Text("Dataset Manager"),
            subtitle: const Text(
              "Managing imported Data from Database to App.",
            ),
            trailing: ElevatedButton(
              onPressed: () =>
                  _navigateTo(context, DatasetManagerScreen(), true),
              child: const Text("Open page"),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.perm_contact_calendar_sharp),
            title: const Text("Un Finished Scraping page"),
            subtitle: const Text("Is under baking ..."),
            trailing: ElevatedButton(
              onPressed: () => _navigateTo(context, ScraperPage(), true),
              child: const Text("Open page"),
            ),
          ),
          // ListTile(
          //   leading: const Icon(Icons.perm_contact_calendar_sharp),
          //   title: const Text("Super Tool page"),
          //   subtitle: const Text("Super Tool is in testing ..."),
          //   trailing: ElevatedButton(
          //     onPressed: () =>
          //         _navigateTo(context, SuperToolControllerScreen(), true),
          //     child: const Text("Open page"),
          //   ),
          // ),
        ],
      ),
    );
  }

  void _navigateTo(BuildContext context, Widget screen, bool isMobileLayout) {
    if (isMobileLayout) Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  Future<void> _runFixAndCleanTask() async {
    _log("🔧 Starting 'Fix & Clean' task...");
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
        "Success",
        "The CSV file has been processed and saved successfully.",
      );
    } catch (e) {
      _log("... ❌ Error during 'Fix & Clean' task: $e");
      _showSimpleDialog("Error", "An error occurred: $e");
    }
  }

  @override
  void dispose() {
    _urlController.dispose();
    _fileNameController.dispose();
    // SessionDatabase.instance.close();
    super.dispose();
  }
}

class CrawlItem {
  final String url;
  final int depth;

  CrawlItem(this.url, this.depth);

  Map<String, dynamic> toJson() => {'url': url, 'depth': depth};

  factory CrawlItem.fromJson(Map<String, dynamic> json) {
    return CrawlItem(json['url'] as String, json['depth'] as int);
  }
}

class TmdbDatailsProcess extends StatelessWidget {
  const TmdbDatailsProcess({super.key});

  @override
  Widget build(BuildContext context) {
    // Controller for the API key text field
    final apiKeyController = TextEditingController(
      text: context.read<ProcessingProvider>().apiKey,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Python Script to Flutter'),
        backgroundColor: Colors.blue.shade800,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildConfigSection(context, apiKeyController),
            const SizedBox(height: 20),
            _buildActionSection(context),
            const SizedBox(height: 20),
            _buildProgressSection(context),
            const Divider(height: 30),
            const Text(
              'Results',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(child: _buildResultsList()),
          ],
        ),
      ),
    );
  }

  Widget _buildConfigSection(
    BuildContext context,
    TextEditingController controller,
  ) {
    return TextField(
      controller: controller,
      obscureText: true,
      decoration: const InputDecoration(
        labelText: 'TMDB API Key',
        border: OutlineInputBorder(),
        hintText: 'Enter your v3 auth key',
      ),
      onChanged: (value) => context.read<ProcessingProvider>().setApiKey(value),
    );
  }

  Widget _buildActionSection(BuildContext context) {
    return Consumer<ProcessingProvider>(
      builder: (context, provider, child) {
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.file_open),
                    label: const Text('Select CSV'),
                    onPressed: provider.isProcessing
                        ? null
                        : () => provider.selectInputFile(),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.download),
                    label: const Text('Export CSV'),
                    onPressed: provider.isProcessing || provider.results.isEmpty
                        ? null
                        : () => provider.exportToCsv(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.save_alt),
                    label: const Text('Save to App (Anime)'),
                    onPressed: provider.isProcessing || provider.results.isEmpty
                        ? null
                        : () => provider.saveToAppStorage('Anime'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.save_alt),
                    label: const Text('Save to App (TV)'),
                    onPressed: provider.isProcessing || provider.results.isEmpty
                        ? null
                        : () => provider.saveToAppStorage('TV'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            ElevatedButton.icon(
              icon: const Icon(Icons.play_arrow),
              label: const Text('Start Processing'),
              onPressed: provider.isProcessing || provider.totalToProcess == 0
                  ? null
                  : () => provider.startProcessing(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 45),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildProgressSection(BuildContext context) {
    return Consumer<ProcessingProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              provider.statusMessage,
              style: const TextStyle(fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            if (provider.isProcessing)
              LinearProgressIndicator(value: provider.progress)
            else if (provider.inputFileName.isNotEmpty)
              Text(
                "File: ${provider.inputFileName}",
                style: TextStyle(color: Colors.grey.shade600),
              ),
          ],
        );
      },
    );
  }

  Widget _buildResultsList() {
    return Consumer<ProcessingProvider>(
      builder: (context, provider, child) {
        if (provider.results.isEmpty && !provider.isProcessing) {
          return const Center(child: Text('No results to display.'));
        }
        return ListView.builder(
          itemCount: provider.results.length,
          itemBuilder: (context, index) {
            final item =
                provider.results[provider.results.length -
                    1 -
                    index]; // Show latest first
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: ListTile(
                leading: item.posterPath.isNotEmpty
                    ? CachedNetworkImage(
                        filterQuality: FilterQuality.high,
                        imageUrl:
                            'https://db.inosuke.sbs/t/p/w200${item.posterPath}',
                        placeholder: (context, url) => const SizedBox(
                          width: 50,
                          height: 75,
                          child: Center(child: CircularProgressIndicator()),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.movie, size: 40),
                        width: 50,
                        fit: BoxFit.cover,
                      )
                    : const SizedBox(
                        width: 50,
                        height: 75,
                        child: Icon(Icons.movie, size: 40),
                      ),
                title: Text(item.seriesName),
                subtitle: Text(
                  '${item.type} • ${item.status} • ★ ${item.voteAverage}',
                ),
                isThreeLine: true,
              ),
            );
          },
        );
      },
    );
  }
}
