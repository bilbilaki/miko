// import 'dart:convert';
// import 'dart:io';
// import 'dart:typed_data';
// import 'package:csv/csv.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:miko/providers/loca_provider.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:sqflite_common/sqflite.dart';
// import 'package:xml/xml.dart' as xml;
// import 'package:html/parser.dart' show parse;
// import 'package:uri/uri.dart';
// import 'package:path/path.dart' as p;
// import 'package:web_scraper/web_scraper.dart';

// class WebCrawlerPage extends StatefulWidget {
//   const WebCrawlerPage({super.key});

//   @override
//   _WebCrawlerPageState createState() => _WebCrawlerPageState();
// }

// class _WebCrawlerPageState extends State<WebCrawlerPage> {
//   final TextEditingController _baseNameController = TextEditingController();
//   final TextEditingController _urlController = TextEditingController();
//   final TextEditingController _attr = TextEditingController();
//   final TextEditingController _sell = TextEditingController();

//   final TextEditingController _title = TextEditingController();
//   final TextEditingController _elem = TextEditingController();

//   bool _ignoreErrors = false;
//   bool _haltOnError = true;
//   bool _createZip = false;
//   String _selectedExtension = '.mp3';
//   String _selectedOutputFormat = '.json';
//   bool _isProcessing = false;
//   String _statusMessage = '';
//   static const _kExternalPathKey = 'external_directory_path';
//   List<String> _logs = [];

//   String? _externalPath;

//   String? _currentPath; // Track the path currently listing
//   List<Directory> _folders = [];
//   List<File> _movies = [];

//   String? get externalPath => _externalPath;

//   List<Directory> get folders => List.unmodifiable(_folders);
//   List<File> get movies => List.unmodifiable(_movies);

//   /// The directory being currently listed (for subfolder navigation)
//   String? get currentPath => _currentPath ?? _externalPath;
//   final List<String> extensions = [
//     '.mp3',
//     '.mp4',
//     '.mkv',
//     '.avi',
//     '.mov',
//     '.srt',
//     '.ass',
//     '.vtt',
//     '.webm',
//     '.pdf',
//     '.doc',
//     '.docx',
//     '.flac',
//     '.exe',
//     '.txt',
//     '...'
//   ];
//   final List<String> outputFormats = [
//     '.json',
//     '.csv',
//     '.xml',
//     '.db',
//     '.sql',
//     '.txt'
//   ];
//   final int maxDepth = 10;
//   final Set<String> mediaExtensions = {'.mp4', '.mkv', '.mp3', '.srt'};
//   List<String> indexedFiles = [];
//   bool interrupted = false;
//   bool page = false;
//   var productNames = <Map<String, dynamic>>[];
//   WebScraper webScraper = WebScraper();

//   @override
//   void initState() {
//     super.initState();
//   }
//     void loadsWebpageRoute(rute) async {
//       page = await webScraper.loadWebPage(rute);
//       assert(page == true);
//     }

//     void loadsFullURL(url) async {
//       assert(await WebScraper().loadFullURL(url) == true);
//     }

//     bool getsPageContentAndLoadsFromString() {
//       final pageContent = webScraper.getPageContent();
//       return(pageContent.isNotEmpty);
//     }

//     void elapsedTime() {
//       var timeElapsed = webScraper.timeElaspsed;
//       debugPrint('Elapsed Time(in Milliseconds): ' + timeElapsed.toString());
//       assert(timeElapsed != null);
//     }

//     void getElementTitle(element) {
//       var names = webScraper.getElementTitle(element);
//       assert(names.isNotEmpty);
//     }

//     void getElementAttribute(attr, title) {
//       var names = webScraper.getElementAttribute(attr, title);
//       assert(names.isNotEmpty);
//     }

//     void getElementsBySelector(sel, attrsel) async {
//       productNames = webScraper.getElement(
//         sel,
//         attrsel,
//       );
//     }

//     void fetchingAllScripts() {
//       var scripts = webScraper.getAllScripts();
//       debugPrint('List of all script tags: ');
//       debugPrint(scripts.toString());
//       assert(scripts != null);
//     }

//     void fetchingScriptVariables() {
//       var variables = webScraper.getScriptVariables(['j.async']);
//       debugPrint('List of all variable occurences: ');
//       debugPrint(variables.toString());
//       assert(variables != null);
//     }

//     // Call the void functions here if needed
//     // loadsWebpageRoute();
//     // loadsFullURL();
//     // getsPageContentAndLoadsFromString();
//     // elapsedTime();
//     // getElementTitle();
//     // getElementAttribute();
//     // getElementsBySelector();
//     // fetchingAllScripts();
//     // fetchingScriptVariables();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Web Crawler Application'),
//         actions: [
//           PopupMenuButton<String>(
//             onSelected: (value) {
//               if (value == 'Exit') {
//                 Navigator.pop(context);
//               }
//             },
//             itemBuilder: (context) => [
//               const PopupMenuItem(value: 'Exit', child: Text('Exit')),
//             ],
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Base Name for Saving
//               const Text('Base Name for Saving:'),
//               TextField(
//                 controller: _baseNameController,
//                 decoration: const InputDecoration(
//                     hintText: 'Enter base name for saving'),
//               ),
//               const SizedBox(height: 16),

//               // Starting URL
//               const Text('Starting URL:'),
//               TextField(
//                 controller: _urlController,
//                 decoration: const InputDecoration(
//                     hintText: 'Enter starting URL for processing'),
//               ),
//               const SizedBox(height: 16),
//               TextField(
//                 controller: _attr,
//                 decoration: const InputDecoration(hintText: 'attr'),
//               ),
//               const SizedBox(height: 16),

//               // Starting URL
//               const Text('Starting URL:'),
//               TextField(
//                 controller: _sell,
//                 decoration: const InputDecoration(hintText: 'sell'),
//               ),
//               const SizedBox(height: 16),
//               TextField(
//                 controller: _title,
//                 decoration: const InputDecoration(hintText: 'title'),
//               ),
//               const SizedBox(height: 16),

//               // Starting URL
//               const Text('Starting URL:'),
//               TextField(
//                 controller: _elem,
//                 decoration: const InputDecoration(hintText: 'elem'),
//               ),
//               const SizedBox(height: 16),

//               // Error Handling
//               const Text('Error Handling:'),
//               CheckboxListTile(
//                 title: const Text('Ignore errors and continue'),
//                 value: _ignoreErrors,
//                 onChanged: (value) => setState(() => _ignoreErrors = value!),
//               ),
//               CheckboxListTile(
//                 title: const Text('Pause on error and ask for continuation'),
//                 value: _haltOnError,
//                 onChanged: (value) => setState(() => _haltOnError = value!),
//               ),
//               const SizedBox(height: 16),

//               // Select Extensions to Search
//               const Text('Select Extensions to Search:'),
//               DropdownButton<String>(
//                 value: _selectedExtension,
//                 onChanged: (value) =>
//                     setState(() => _selectedExtension = value!),
//                 items: extensions
//                     .map(
//                         (ext) => DropdownMenuItem(value: ext, child: Text(ext)))
//                     .toList(),
//               ),
//               const SizedBox(height: 16),

//               // Select Output Formats
//               const Text('Select Output Formats:'),
//               DropdownButton<String>(
//                 value: _selectedOutputFormat,
//                 onChanged: (value) =>
//                     setState(() => _selectedOutputFormat = value!),
//                 items: outputFormats
//                     .map((format) =>
//                         DropdownMenuItem(value: format, child: Text(format)))
//                     .toList(),
//               ),
//               const SizedBox(height: 16),

//               // Create Folder and Zip File
//               CheckboxListTile(
//                 title: const Text('Create folder and zip file'),
//                 value: _createZip,
//                 onChanged: (value) => setState(() => _createZip = value!),
//               ),
//               const SizedBox(height: 16),

//               // Start Processing Button
//               ElevatedButton(
//                 onPressed: _isProcessing ? null : _startProcessing,
//                 child: _isProcessing
//                     ? const CircularProgressIndicator()
//                     : const Text('Start Processing'),
//               ),
//               const SizedBox(height: 16),

//               // Status Message
//               Text(_statusMessage,
//                   style: const TextStyle(
//                       fontSize: 16, fontWeight: FontWeight.bold)),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> _startProcessing() async {
//     final baseName = _baseNameController.text;
//     final baseUrl = _urlController.text;
//     final attr = _attr.text;
//     final sell = _sell.text;

//     final title = _title.text;
//     final elem = _elem.text;

//     if (baseUrl.isEmpty) {
//       setState(() {
//         _statusMessage = 'Please enter a starting URL.';
//       });
//       return;
//     }

//     setState(() {
//       _isProcessing = true;
//       _statusMessage =
//           'Starting processing with:\nBase Name: $baseName\nURL: $baseUrl';
//       indexedFiles.clear();
//       interrupted = false;
//     });

//     await _crawlDirectory(baseUrl);
//     if (!interrupted) {
//       await _saveResults(baseName);
//     }

//     setState(() {
//       _isProcessing = false;
//     });
//   }

//   Future<void> _crawlDirectory(String url, {int depth = 200}) async {
//     if (depth > maxDepth || interrupted) {
//       return;
//     }

//     try {
//       final response = await http.get(Uri.parse(url));
//       if (response.statusCode != 200) {
//         setState(() {
//           _statusMessage = '⛔ Error fetching: $url';
//         });
//         if (_haltOnError && !_ignoreErrors) {
//           interrupted = true;
//         }
//         return;
//       }
//       final crap = loadsFullURL(url);
//       final document = parse(response.body);

//       final links = document
//           .querySelectorAll('a[href]')
//           .map((e) => e.attributes['href'])
//           .toList();

//       for (var link in links) {
//         if (link == '../' || link == './') continue;
//         final fullUrl = Uri.parse(url).resolve(link!).toString();
//         final parsed = Uri.parse(fullUrl);
//         final path = parsed.path.toLowerCase();

//         if (mediaExtensions.any((ext) => path.endsWith(ext))) {
//           setState(() {
//             indexedFiles.add(fullUrl);
//             _statusMessage = 'Found: $fullUrl';
//           });
//         } else if (path.endsWith('/') && !interrupted) {
//           await _crawlDirectory(fullUrl, depth: depth + 1);
//         }
//       }
//     } catch (e) {
//       setState(() {
//         _statusMessage = '⚠️ Network error while processing $url: $e';
//       });
//       if (_haltOnError && !_ignoreErrors) {
//         interrupted = true;
//       }
//     }
//   }

//   Future<String?> _promptPathSelection() async {
//     return FilePicker.platform.getDirectoryPath();
//     // if (selected != null) {
//     //   // When a new path is set, always reset the view to the root
//     //   setState(() {
//     //     _externalPath != null;
//     //   });
//     //   await setPath(selected);
//     // }
//     // return selected;
//   }

//   Future<void> loadPath() async {
//     final prefs = await SharedPreferences.getInstance();
//     _externalPath = prefs.getString(_kExternalPathKey);
//     await _refreshList(_externalPath);
//   }

//   /// Set or edit the storage path and refresh contents.
//   Future<void> setPath(String newPath) async {
//     final prefs = await SharedPreferences.getInstance();
//     _externalPath = newPath;
//     await prefs.setString(_kExternalPathKey, newPath);
//     await _refreshList(newPath);
//   }

//   Future<void> _refreshList(String? folder) async {
//     _folders = [];
//     _movies = [];
//     Future<void> setPath(String newPath) async {
//       final prefs = await SharedPreferences.getInstance();
//       _externalPath = newPath;
//       await prefs.setString(_kExternalPathKey, newPath);
//       await _refreshList(newPath);

//       String? dirPath = folder ?? _externalPath;
//       if (dirPath == null) return;

//       _currentPath = dirPath;

//       final dir = Directory(dirPath);
//       if (await dir.exists()) {
//         final entries = dir.listSync();
//         _folders = entries.whereType<Directory>().toList();
//       }
//     }
//   }

//   // Save downloaded file to storage
//   Future<void> _saveFileToStorage(List<int> bytes, String fileName) async {
//     final directory = await getExternalStorageDirectory();
//     final file = File('${directory!.path}/$fileName');
//     await file.writeAsBytes(bytes);
//     setState(() {
//       _logs.add('File saved to: ${file.path}');
//     });
//   }

//   Future<void> _saveResults(String baseName) async {
//     if (indexedFiles.isEmpty) {
//       setState(() {
//         _statusMessage = 'No files found to save.';
//       });
//       return;
//     }

//     final externalPath = await _promptPathSelection();
//     final basePath = externalPath!;

//     // Save as JSON
//     final jsonFilePath = '$basePath/$baseName.json';
//     await File(jsonFilePath)
//         .writeAsString(jsonEncode(indexedFiles), flush: true);

//     // Save as CSV
//     final csvFilePath = '$basePath/$baseName.csv';
//     List<List<dynamic>> csvData = [
//       ['File Name', 'URL'],
//       ...indexedFiles
//           .asMap()
//           .entries
//           .map((entry) => ['$baseName${entry.key + 1}', entry.value])
//     ];
//     String csv = const ListToCsvConverter().convert(csvData);
//     await File(csvFilePath).writeAsString(csv, flush: true);

//     // Save as XML
//     final xmlFilePath = '$basePath/$baseName.xml';
//     final builder = xml.XmlBuilder();
//     builder.element('MediaFiles', nest: () {
//       for (var url in indexedFiles) {
//         builder.element('File', nest: () {
//           builder.element('URL', nest: () => builder.text(url));
//         });
//       }
//     });
//     await File(xmlFilePath).writeAsString(
//         builder.buildDocument().toXmlString(pretty: true),
//         flush: true);

//     // Save to SQLite DB
//     final dbPath = '$basePath/$baseName.db';
//     final db =
//         await openDatabase(dbPath, version: 1, onCreate: (db, version) async {
//       await db.execute('''
//         CREATE TABLE IF NOT EXISTS media (
//           id INTEGER PRIMARY KEY AUTOINCREMENT,
//           file_name TEXT,
//           url TEXT
//         )
//       ''');
//     });
//     for (int i = 0; i < indexedFiles.length; i++) {
//       await db.insert('media', {
//         'file_name': '$baseName${i + 1}',
//         'url': indexedFiles[i],
//       });
//     }
//     await db.close();

//     setState(() {
//       _statusMessage =
//           'Collected ${indexedFiles.length} URLs.\nFiles saved successfully at $basePath';
//     });
//   }
// }
// import 'dart:async';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../main.dart' as we;

// class WebV extends StatefulWidget {
//   const WebV({super.key});

//   @override
//   State<WebV> createState() => _WebVState();
// }

// class _WebVState extends State<WebV> {}
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:xml/xml.dart' as xml;
import 'package:archive/archive_io.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite_common/sqflite.dart';

// --- Global Settings (equivalent to Python script's top-level variables) ---
const int maxDepth = 10; // Maximum crawl depth

class CrawlerHomePage extends StatefulWidget {
  const CrawlerHomePage({super.key});

  @override
  State<CrawlerHomePage> createState() => _CrawlerHomePageState();
}

class _CrawlerHomePageState extends State<CrawlerHomePage> {
  // --- State Variables (equivalent to Python GUI class members) ---
  final _urlController = TextEditingController();
  final _fileNameController = TextEditingController();

  final List<String> _availableExtensions = [
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
  ];
  String _selectedExtension = ".mp4";

  final List<String> _outputFormats = [".json", ".csv", ".xml", ".db", ".txt"];
  String _selectedOutputFormat = ".json";

  bool _createZip = false;
  bool _isCrawling = false;
  bool _isCancelled = false;
  final List<String> _foundUrls = [];
  final List<String> _logMessages = [];

  // --- Logic Methods (converted from Python functions) ---

  void _log(String message) {
    // A helper to update the UI with log messages
    setState(() {
      _logMessages.insert(0, message);
    });
  }

  Future<void> _requestStoragePermission() async {
    // On mobile, we need to ask for permission to save files
    if (Platform.isAndroid || Platform.isIOS) {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }
    }
  }

  Future<void> _startProcessing() async {
    if (_urlController.text.isEmpty || _fileNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in both URL and Base Name.')),
      );
      return;
    }

    await _requestStoragePermission();

    setState(() {
      _isCrawling = true;
      _isCancelled = false;
      _foundUrls.clear();
      _logMessages.clear();
    });

    _log("🚀 Starting crawl at: ${_urlController.text}");

    try {
      await _crawlDirectory(_urlController.text, 0);

      if (_isCancelled) {
        _log("🛑 Crawl cancelled by user.");
      } else {
        _log("✅ Crawl finished. Found ${_foundUrls.length} files.");
        if (_foundUrls.isNotEmpty) {
          await _saveResults(_fileNameController.text);
        }
      }
    } catch (e) {
      _log("❌ An unexpected error occurred: $e");
    }

    setState(() {
      _isCrawling = false;
    });
  }

  void _cancelProcessing() {
    setState(() {
      _isCancelled = true;
    });
  }

  /// Recursively crawls a directory URL.
  /// This is the Dart version of `crawl_directory`.
  Future<void> _crawlDirectory(String url, int depth) async {
    if (depth > maxDepth || _isCancelled) return;

    _log("  " * depth + "🔎 Crawling: $url");

    try {
      final uri = Uri.parse(url);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        // Use the beautiful_soup_dart package to parse the HTML
        BeautifulSoup bs = BeautifulSoup(response.body);
        List<Bs4Element> links = bs.findAll('a', attrs: {'href': true});

        for (var link in links) {
          if (_isCancelled) return;

          String href = link['href']!;
          // Skip parent directory links
          if (href == '../' || href == './') continue;

          // Resolve the relative URL to a full URL
          Uri fullUrl = uri.resolve(href);

          // Check if the link ends with the desired extension or is a directory
          if (fullUrl.path.endsWith(_selectedExtension)) {
            _log("  " * (depth + 1) + "✔️ Found: ${fullUrl.toString()}");
            setState(() {
              _foundUrls.add(fullUrl.toString());
            });
          } else if (fullUrl.path.endsWith('/')) {
            // It's a directory, so we crawl it recursively
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

  /// Saves the collected URLs to the selected format.
  /// This is the Dart version of `save_results`.
  Future<void> _saveResults(String baseName) async {
    _log("💾 Saving results with base name: $baseName");

    // Get a directory where we can save files
    final dir = await FilePicker.platform.getDirectoryPath();
    await getApplicationDocumentsDirectory();
    if (dir == null) {
      _log("❌ Could not find a writable directory.");
      return;
    }

    final String path = dir;
    _log("📂 Saving files to: $path");

    List<String> createdFilePaths = [];

    // JSON
    if (_selectedOutputFormat == '.json' || _createZip) {
      final filePath = '$path/$baseName.json';
      final file = File(filePath);
      await file.writeAsString(jsonEncode(_foundUrls));
      createdFilePaths.add(filePath);
      _log("   - Saved $filePath");
    }

    // CSV
    if (_selectedOutputFormat == '.csv' || _createZip) {
      final filePath = '$path/$baseName.csv';
      List<List<dynamic>> rows = [
        ['URL']
      ];
      rows.addAll(_foundUrls.map((url) => [url]).toList());
      String csv = const ListToCsvConverter().convert(rows);
      final file = File(filePath);
      await file.writeAsString(csv);
      createdFilePaths.add(filePath);
      _log("   - Saved $filePath");
    }

    // TXT
    if (_selectedOutputFormat == '.txt' || _createZip) {
      final filePath = '$path/$baseName.txt';
      final file = File(filePath);
      await file.writeAsString(_foundUrls.join('\n'));
      createdFilePaths.add(filePath);
      _log("   - Saved $filePath");
    }

    // XML
    if (_selectedOutputFormat == '.xml' || _createZip) {
      final filePath = '$path/$baseName.xml';
      final builder = xml.XmlBuilder();
      builder.processing('xml', 'version="1.0"');
      builder.element('MediaFiles', nest: () {
        for (var url in _foundUrls) {
          builder.element('File', nest: () {
            builder.element('URL', nest: url);
          });
        }
      });
      final file = File(filePath);
      await file
          .writeAsString(builder.buildDocument().toXmlString(pretty: true));
      createdFilePaths.add(filePath);
      _log("   - Saved $filePath");
    }

    // SQLite DB
    if (_selectedOutputFormat == '.db' || _createZip) {
      final filePath = '$path/$baseName.db';
      Database database = await openDatabase(filePath, version: 1,
          onCreate: (Database db, int version) async {
        await db
            .execute('CREATE TABLE Media (id INTEGER PRIMARY KEY, url TEXT)');
      });
      for (var url in _foundUrls) {
        await database.insert('Media', {'url': url});
      }
      await database.close();
      createdFilePaths.add(filePath);
      _log("   - Saved $filePath");
    }

    // Create Zip file if requested
    if (_createZip) {
      final zipFilePath = '$path/$baseName.zip';
      var encoder = ZipFileEncoder();
      encoder.create(zipFilePath);
      for (var filePath in createdFilePaths) {
        await encoder.addFile(File(filePath));
      }
      encoder.close();
      _log("📦 Created zip file: $zipFilePath");
    }

    // Show a confirmation dialog
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Success'),
          content:
              Text('Successfully saved ${_foundUrls.length} URLs to $path.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  // --- UI Build Method (replaces PyQt5 UI setup) ---
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: _buildCrawlerTab(),
    );
  }

  Widget _buildCrawlerTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // --- Input Fields ---
          TextField(
            controller: _fileNameController,
            decoration: const InputDecoration(
              labelText: 'Base Name for Saving',
              hintText: 'e.g., my_collection',
              border: OutlineInputBorder(),
            ),
            enabled: !_isCrawling,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _urlController,
            decoration: const InputDecoration(
              labelText: 'Starting URL',
              hintText: 'http://example.com/files/',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.url,
            enabled: !_isCrawling,
          ),
          const SizedBox(height: 24),

          // --- Dropdown Selections ---
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedExtension,
                  decoration: const InputDecoration(
                    labelText: 'File Extension',
                    border: OutlineInputBorder(),
                  ),
                  items: _availableExtensions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: _isCrawling
                      ? null
                      : (newValue) {
                          setState(() {
                            _selectedExtension = newValue!;
                          });
                        },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedOutputFormat,
                  decoration: const InputDecoration(
                    labelText: 'Output Format',
                    border: OutlineInputBorder(),
                  ),
                  items: _outputFormats.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value.toUpperCase()),
                    );
                  }).toList(),
                  onChanged: _isCrawling
                      ? null
                      : (newValue) {
                          setState(() {
                            _selectedOutputFormat = newValue!;
                          });
                        },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // --- Checkbox ---
          CheckboxListTile(
            title: const Text('Create a Zip file with all formats'),
            value: _createZip,
            onChanged: _isCrawling
                ? null
                : (bool? value) {
                    setState(() {
                      _createZip = value ?? false;
                    });
                  },
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
          ),
          const SizedBox(height: 24),

          // --- Action Buttons & Progress Indicator ---
          if (_isCrawling)
            Column(
              children: [
                const LinearProgressIndicator(),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  icon: const Icon(Icons.cancel),
                  label: const Text('Cancel Crawl'),
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
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          const SizedBox(height: 24),

          // --- Log Output Area ---
          const Text('Logs', style: TextStyle(fontWeight: FontWeight.bold)),
          const Divider(),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8.0),
              color: Colors.black.withOpacity(0.2),
              child: ListView.builder(
                reverse: true,
                itemCount: _logMessages.length,
                itemBuilder: (context, index) {
                  return Text(_logMessages[index]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed.
    _urlController.dispose();
    _fileNameController.dispose();
    super.dispose();
  }
}
