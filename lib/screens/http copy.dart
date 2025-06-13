// import 'dart:convert';
// import 'dart:io';
// import 'dart:typed_data';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:path_provider/path_provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class HttpClientPage extends StatefulWidget {
//   const HttpClientPage({super.key});

//   @override
//   _HttpClientPageState createState() => _HttpClientPageState();
// }

// class _HttpClientPageState extends State<HttpClientPage> {
//   // Controllers for various input fields
//   final TextEditingController _urlController = TextEditingController();
//   final TextEditingController _bodyController = TextEditingController();
//   final TextEditingController _envController = TextEditingController();
//   final List<TextEditingController> _headerKeyControllers = [];
//   final List<TextEditingController> _headerValueControllers = [];
//   final List<TextEditingController> _paramKeyControllers = [];
//   final List<TextEditingController> _paramValueControllers = [];

//   // Dropdown and state variables
//   String _selectedMethod = 'GET';
//   String _selectedBodyType = 'None';
//   int _loopCount = 1;
//   String _response = '';
//   List<String> _logs = [];
//   File? _selectedFile;
//   bool _isLoading = false;
//   Map<String, String> _environment = {};
//   static const _kExternalPathKey = 'external_directory_path';

//   String? _externalPath;

//   String? _currentPath; // Track the path currently listing
//   List<Directory> _folders = [];
//   List<File> _movies = [];

//   String? get externalPath => _externalPath;

//   List<Directory> get folders => List.unmodifiable(_folders);
//   List<File> get movies => List.unmodifiable(_movies);

//   /// The directory being currently listed (for subfolder navigation)
//   String? get currentPath => _currentPath ?? _externalPath;

//   final Map<String, Uint8List> _thumbnailCache = {};

//   // ... (keep your existing loadPath, setPath, refresh, isMovieFile methods)

//   // HTTP Methods and Body Types
//   final List<String> methods = ['GET', 'POST', 'PUT', 'DELETE', 'PATCH'];
//   final List<String> bodyTypes = ['None', 'JSON', 'Multipart', 'Raw'];

//   @override
//   void initState() {
//     super.initState();
//     _loadEnvironment();
//     _addHeaderRow();
//     _addParamRow();
//   }

//   // Load environment variables from SharedPreferences
//   Future<void> _loadEnvironment() async {
//     final prefs = await SharedPreferences.getInstance();
//     final envString = prefs.getString('environment') ?? '{}';
//     setState(() {
//       _environment = Map<String, String>.from(jsonDecode(envString));
//     });
//   }

//   // Save environment variables
//   Future<void> _saveEnvironment(String key, String value) async {
//     final prefs = await SharedPreferences.getInstance();
//     _environment[key] = value;
//     await prefs.setString('environment', jsonEncode(_environment));
//     setState(() {});
//   }

//   // Add a new header row
//   void _addHeaderRow() {
//     setState(() {
//       _headerKeyControllers.add(TextEditingController());
//       _headerValueControllers.add(TextEditingController());
//     });
//   }

//   // Add a new parameter row
//   void _addParamRow() {
//     setState(() {
//       _paramKeyControllers.add(TextEditingController());
//       _paramValueControllers.add(TextEditingController());
//     });
//   }

//   // Pick file for multipart request
//   Future<void> _pickFile() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles();
//     if (result != null) {
//       setState(() {
//         _selectedFile = File(result.files.single.path!);
//       });
//     }
//   }

//   // Send HTTP request
//   Future<void> _sendRequest() async {
//     setState(() {
//       _isLoading = true;
//       _response = '';
//     });

//     String url = _urlController.text;
//     Map<String, String> headers = {};
//     for (int i = 0; i < _headerKeyControllers.length; i++) {
//       if (_headerKeyControllers[i].text.isNotEmpty) {
//         headers[_headerKeyControllers[i].text] =
//             _headerValueControllers[i].text;
//       }
//     }

//     Uri uri = Uri.parse(url);
//     Map<String, String> queryParams = {};
//     for (int i = 0; i < _paramKeyControllers.length; i++) {
//       if (_paramKeyControllers[i].text.isNotEmpty) {
//         queryParams[_paramKeyControllers[i].text] =
//             _paramValueControllers[i].text;
//       }
//     }
//     uri = uri.replace(queryParameters: queryParams);

//     try {
//       for (int i = 0; i < _loopCount; i++) {
//         http.Response? response;
//         if (_selectedMethod == 'GET') {
//           response = await http.get(uri, headers: headers);
//         } else if (_selectedMethod == 'POST') {
//           if (_selectedBodyType == 'JSON') {
//             response = await http.post(uri,
//                 headers: headers, body: _bodyController.text);
//           } else if (_selectedBodyType == 'Multipart' &&
//               _selectedFile != null) {
//             var request = http.MultipartRequest('POST', uri);
//             request.headers.addAll(headers);
//             request.files.add(
//                 await http.MultipartFile.fromPath('file', _selectedFile!.path));
//             var streamedResponse = await request.send();
//             response = await http.Response.fromStream(streamedResponse);
//           } else {
//             response = await http.post(uri,
//                 headers: headers, body: _bodyController.text);
//           }
//         } // Add similar blocks for PUT, DELETE, PATCH

//         setState(() {
//           _response = response!.body;
//           _logs.add(
//               'Attempt ${i + 1}: ${_selectedMethod} $url - Status: ${response.statusCode}');
//           if (response.headers['content-type']
//                   ?.contains('application/octet-stream') ==
//               true) {
//             _saveFileToStorage(response.bodyBytes, 'downloaded_file');
//           }
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _response = 'Error: $e';
//         _logs.add('Error: $e');
//       });
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   Future<void> _refreshList(String? folder) async {
//     _folders = [];
//     _movies = [];
//     Future<void> setPath(String newPath) async {
//       final prefs = await SharedPreferences.getInstance();
//       _externalPath = newPath;
//       await prefs.setString(_kExternalPathKey, newPath);
//       await _refreshList(newPath);
   
//    String? dirPath = folder ?? _externalPath;
//     if (dirPath == null) return;

//     _currentPath = dirPath;

//     final dir = Directory(dirPath);
//     if (await dir.exists()) {
//       final entries = dir.listSync();
//       _folders = entries.whereType<Directory>().toList();
//     }
//   }
    
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

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('HTTP Client (Postman-like)'),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // URL and Method
//               Row(
//                 children: [
//                   DropdownButton<String>(
//                     value: _selectedMethod,
//                     onChanged: (value) =>
//                         setState(() => _selectedMethod = value!),
//                     items: methods
//                         .map((method) => DropdownMenuItem(
//                             value: method, child: Text(method)))
//                         .toList(),
//                   ),
//                   const SizedBox(width: 10),
//                   Expanded(
//                     child: TextField(
//                       controller: _urlController,
//                       decoration: const InputDecoration(labelText: 'URL'),
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   ElevatedButton(
//                     onPressed: _isLoading ? null : _sendRequest,
//                     child: _isLoading
//                         ? const CircularProgressIndicator()
//                         : const Text('Send'),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),

//               // Environment Variables
//               Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: _envController,
//                       decoration:
//                           const InputDecoration(labelText: 'Env Key=Value'),
//                     ),
//                   ),
//                   IconButton(
//                     onPressed: () {
//                       final parts = _envController.text.split('=');
//                       if (parts.length == 2) {
//                         _saveEnvironment(parts[0], parts[1]);
//                         _envController.clear();
//                       }
//                     },
//                     icon: const Icon(Icons.save),
//                   ),
//                 ],
//               ),
//               Text('Environment: $_environment'),
//               const SizedBox(height: 20),

//               // Headers
//               const Text('Headers',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//               ...List.generate(
//                   _headerKeyControllers.length,
//                   (index) => Row(
//                         children: [
//                           Expanded(
//                             child: TextField(
//                               controller: _headerKeyControllers[index],
//                               decoration:
//                                   const InputDecoration(labelText: 'Key'),
//                             ),
//                           ),
//                           const SizedBox(width: 10),
//                           Expanded(
//                             child: TextField(
//                               controller: _headerValueControllers[index],
//                               decoration:
//                                   const InputDecoration(labelText: 'Value'),
//                             ),
//                           ),
//                         ],
//                       )),
//               ElevatedButton(
//                 onPressed: _addHeaderRow,
//                 child: const Text('Add Header'),
//               ),
//               const SizedBox(height: 20),

//               // Query Parameters
//               const Text('Query Params',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//               ...List.generate(
//                   _paramKeyControllers.length,
//                   (index) => Row(
//                         children: [
//                           Expanded(
//                             child: TextField(
//                               controller: _paramKeyControllers[index],
//                               decoration:
//                                   const InputDecoration(labelText: 'Key'),
//                             ),
//                           ),
//                           const SizedBox(width: 10),
//                           Expanded(
//                             child: TextField(
//                               controller: _paramValueControllers[index],
//                               decoration:
//                                   const InputDecoration(labelText: 'Value'),
//                             ),
//                           ),
//                         ],
//                       )),
//               ElevatedButton(
//                 onPressed: _addParamRow,
//                 child: const Text('Add Param'),
//               ),
//               const SizedBox(height: 20),

//               // Body Type and Content
//               DropdownButton<String>(
//                 value: _selectedBodyType,
//                 onChanged: (value) =>
//                     setState(() => _selectedBodyType = value!),
//                 items: bodyTypes
//                     .map((type) =>
//                         DropdownMenuItem(value: type, child: Text(type)))
//                     .toList(),
//               ),
//               if (_selectedBodyType == 'Multipart')
//                 ElevatedButton(
//                   onPressed: _pickFile,
//                   child: Text(_selectedFile == null
//                       ? 'Select File'
//                       : 'File: ${_selectedFile!.path}'),
//                 ),
//               if (_selectedBodyType != 'None' &&
//                   _selectedBodyType != 'Multipart')
//                 TextField(
//                   controller: _bodyController,
//                   maxLines: 5,
//                   decoration: const InputDecoration(labelText: 'Body'),
//                 ),
//               const SizedBox(height: 20),

//               // Loop Configuration
//               Row(
//                 children: [
//                   const Text('Loop Count:'),
//                   const SizedBox(width: 10),
//                   DropdownButton<int>(
//                     value: _loopCount,
//                     onChanged: (value) => setState(() => _loopCount = value!),
//                     items: List.generate(
//                         10,
//                         (index) => DropdownMenuItem(
//                             value: index + 1, child: Text('${index + 1}'))),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),

//               // Response
//               const Text('Response',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//               Container(
//                 height: 200,
//                 padding: const EdgeInsets.all(8.0),
//                 decoration:
//                     BoxDecoration(border: Border.all(color: Colors.grey)),
//                 child: SingleChildScrollView(child: Text(_response)),
//               ),
//               const SizedBox(height: 20),

//               // Logs
//               const Text('Logs',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//               Container(
//                 height: 150,
//                 padding: const EdgeInsets.all(8.0),
//                 decoration:
//                     BoxDecoration(border: Border.all(color: Colors.grey)),
//                 child: SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: _logs.map((log) => Text(log)).toList(),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:csv/csv.dart';
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
        const SnackBar(content: Text('Please fill in both URL(s) and Base Name.')),
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
    _log(_processAsSeries ? "🎬 Processing as TV Series." : "🎥 Processing as Movies.");

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
        _log("  " * depth + "⚠️ Failed to fetch $url (Status: ${response.statusCode})");
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
    final nameRegex = RegExp(r'\.\d{4}$'); // Matches .YYYY at the end of a string

    for (final url in _foundUrls) {
      final uri = Uri.parse(url);
      final segments = uri.pathSegments;
      if (segments.length > 2) {
        // Heuristic: The movie name is often the second to last path segment.
        // e.g., /movies/.../The.Movie.Name.2023/The.Movie.Name.2023.1080p.mkv
        String potentialName = segments[segments.length - 2];
        // Clean the name: remove year and replace dots with spaces
        String cleanedName = potentialName.replaceAll(nameRegex, '').replaceAll('.', ' ');
        
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
    List<List<dynamic>> rows = [['Name', 'URL']];
    movieMap.forEach((name, data) {
      rows.add([name, data.urls.join(',')]);
    });
    await File(csvFilePath).writeAsString(const ListToCsvConverter().convert(rows));
    _log("   - Saved $csvFilePath");

    // SQLite DB
    final dbFilePath = '$dirPath/$baseName.db';
    Database database = await openDatabase(dbFilePath, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE Movies (id INTEGER PRIMARY KEY, name TEXT, urls TEXT)');
    });
    for (final movie in movieMap.values) {
      await database.insert('Movies', {'name': movie.name, 'urls': movie.urls.join(',')});
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
    for(final url in _foundUrls) {
      final quality = _extractQuality(url) ?? 'unknown';
      final season = _extractSeason(url);
      final episodeNum = _extractEpisodeNumber(url);
      
      if (season != null && episodeNum != null) {
        final episodeId = "$season$episodeNum";
        // Heuristic for series name: part of the filename before the season/episode marker
        String seriesName = _extractSeriesName(url, episodeId) ?? baseName;

        final pivotKey = "${seriesName}_$episodeId";
        
        pivotData.putIfAbsent(pivotKey, () => {'Series': seriesName, 'Episode': episodeId});
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
    final headers = ['Series', 'Episode', '1080p', '720p', '540p', '480p', 'Dubbed'];
    List<List<dynamic>> rows = [headers];

    // Convert the pivot map to a list of rows
    final sortedKeys = pivotData.keys.toList()..sort();
    for (final key in sortedKeys) {
        final episodeData = pivotData[key]!;
        rows.add(headers.map((h) => episodeData[h] ?? '').toList());
    }

    // Save to CSV
    final csvFilePath = '$dirPath/$baseName.csv';
    await File(csvFilePath).writeAsString(const ListToCsvConverter().convert(rows));
    _log("   - Saved $csvFilePath");

    _showSuccessDialog(pivotData.length, "episodes", dirPath);
  }

  // --- Series Data Extraction Helpers (Ported from Python) ---
  String? _extractQuality(String url) {
    final match = RegExp(r'(1080p|720p|540p|480p|Dubbed)', caseSensitive: false).firstMatch(url);
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
    if (match != null) return 'E${int.parse(match.group(1)!).toString().padLeft(2, '0')}';

    match = RegExp(r'Ep(?:isode)?\.?(\d+)', caseSensitive: false).firstMatch(filename);
    if (match != null) return 'E${int.parse(match.group(1)!).toString().padLeft(2, '0')}';

    match = RegExp(r'(?<!\d)(?<!p)[._-](\d{2,3})[._-]').firstMatch(filename);
    if (match != null) return 'E${int.parse(match.group(1)!).toString().padLeft(2, '0')}';

    match = RegExp(r'\.(\d{2,3})\.').firstMatch(filename);
    if (match != null && !_isQualityString(match.group(0)!)) {
      return 'E${int.parse(match.group(1)!).toString().padLeft(2, '0')}';
    }
    
    return null;
  }

  String? _extractSeriesName(String url, String episodeId) {
    final filename = Uri.decodeComponent(url.split('/').last);
    final stopIndex = filename.indexOf(episodeId.split('E')[0]); // Find where 'S01' starts
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

      if (outputPath == null) {
        _log("... Task cancelled. No output file selected.");
        return;
      }
      
      // 4. Save the new CSV
      final newCsv = const ListToCsvConverter().convert(csvTable);
      await File(outputPath).writeAsString(newCsv);
      _log("... ✅ Successfully processed and saved to: $outputPath");
      
      _showSimpleDialog("Success", "The CSV file has been processed and saved successfully.");

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
        content: Text('Successfully processed and saved $count $itemType.\nFiles saved in: $path'),
        actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('OK'))],
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
        actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('OK'))],
      ),
    );
  }

  // --- UI Build Methods ---
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Now we have two tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Web Crawler & Processor'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.cloud_download), text: 'Crawler'),
              Tab(icon: Icon(Icons.build), text: 'Tools'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildCrawlerTab(),
            _buildToolsTab(),
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
            decoration: const InputDecoration(labelText: 'Base Name for Saving'),
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
            items: [    ".mp4",
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
    ".txt"].map((String value) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
            }).toList(),
            onChanged: _isProcessing ? null : (v) => setState(() => _selectedExtension = v!),
          ),
          const SizedBox(height: 16),
          CheckboxListTile(
            title: const Text('Process as TV Series (Pivot Data)'),
            value: _processAsSeries,
            onChanged: _isProcessing ? null : (v) => setState(() => _processAsSeries = v!),
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
          ),
          CheckboxListTile(
            title: const Text('Create a Zip file'),
            value: _createZip,
            onChanged: _isProcessing ? null : (v) => setState(() => _createZip = v!),
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
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
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
          Text("Post-Processing Tools", style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 20),
          ListTile(
            leading: const Icon(Icons.cleaning_services),
            title: const Text("Fix & Clean CSV File"),
            subtitle: const Text("Removes '_PartX' from the first column of a selected CSV file."),
            trailing: ElevatedButton(
              onPressed: _isProcessing ? null : _runFixAndCleanTask,
              child: const Text("Run Task"),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _urlController.dispose();
    _fileNameController.dispose();
    super.dispose();
  }
}