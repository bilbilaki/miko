import 'dart:io';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:miko/models/csv_process/detail_tmdb.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tmdb_api/tmdb_api.dart';

class ProcessingProvider extends ChangeNotifier {
  // State variables
  String _apiKey = "607e40af5bb66576f6fd7252d5529e24"; // User can override
  List<String> _seriesToProcess = [];
  final List<MediaData> _results = [];
  final Set<String> _processedNames = {}; // Replaces the log file

  String _statusMessage = 'Ready. Select a CSV file to begin.';
  double _progress = 0.0;
  bool _isProcessing = false;
  String _inputFileName = '';

  // Getters for UI
  String get apiKey => _apiKey;
  String get statusMessage => _statusMessage;
  double get progress => _progress;
  bool get isProcessing => _isProcessing;
  List<MediaData> get results => _results;
  int get totalToProcess => _seriesToProcess.length;
  int get processedCount => _processedNames.length;
  String get inputFileName => _inputFileName;

  void setApiKey(String key) {
    if (key.isNotEmpty) {
      _apiKey = key;
      notifyListeners();
    }
  }

  Future<void> selectInputFile() async {
    if (_isProcessing) return;

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null) {
      try {
        _statusMessage = 'Reading file...';
        notifyListeners();

        final file = File(result.files.single.path!);
        _inputFileName = result.files.single.name;
        final fileContent = await file.readAsString();

        // Using the csv package to parse
        final List<List<dynamic>> rowsAsListOfValues =
            const CsvToListConverter().convert(fileContent);

        if (rowsAsListOfValues.isEmpty) {
          _statusMessage = 'Error: CSV file is empty.';
          notifyListeners();
          return;
        }

        // Assuming the series names are in the first column ('filename')
        _seriesToProcess = rowsAsListOfValues
            .skip(1) // Skip header row
            .map((row) => row[0].toString().trim())
            .where((name) => name.isNotEmpty)
            .toSet() // Get unique names
            .toList();

        // Reset state for new file
        _results.clear();
        _processedNames.clear();
        _progress = 0.0;

        _statusMessage =
            '${_seriesToProcess.length} unique series loaded. Ready to process.';
        notifyListeners();
      } catch (e) {
        _statusMessage = 'Error reading CSV file: $e';
        _inputFileName = '';
        notifyListeners();
      }
    } else {
      _statusMessage = 'File selection cancelled.';
      _inputFileName = '';
      notifyListeners();
    }
  }

  Future<void> startProcessing() async {
    if (_seriesToProcess.isEmpty || _isProcessing) {
      return;
    }
    if (_apiKey.isEmpty) {
      return;
    }

    _isProcessing = true;
    _statusMessage = 'Initializing...';
    _progress = 0.0;
    notifyListeners();

    final tmdb = TMDB(ApiKeys(_apiKey, 'apiReadAccessTokenv4'),
        logConfig: const ConfigLogger(showLogs: false));

    for (int i = 0; i < _seriesToProcess.length; i++) {
      final seriesName = _seriesToProcess[i];

      if (_processedNames.contains(seriesName)) continue;

      _statusMessage = 'Processing (${i + 1}/$totalToProcess): $seriesName';
      notifyListeners();

      try {
        // Logic from Python: search TV, then Movie
        var searchResult = await tmdb.v3.search.queryTvShows(seriesName);
        String mediaType = 'tv';

        if (searchResult['results'].isEmpty) {
          searchResult = await tmdb.v3.search.queryMovies(seriesName);
          mediaType = 'movie';
        }

        if (searchResult['results'].isNotEmpty) {
          final firstResult = searchResult['results'][0];
          final int id = firstResult['id'];

          // Fetch details with appended responses
          final Map details = mediaType == 'tv'
              ? await tmdb.v3.tv
                  .getDetails(id, appendToResponse: 'credits,videos,keywords')
              : await tmdb.v3.movies
                  .getDetails(id, appendToResponse: 'credits,videos,keywords');

          final mediaData = MediaData.fromTmdb(details, seriesName, mediaType);
          _results.add(mediaData);
        } else {
          // Log that nothing was found, but still mark as processed
          print("No TMDB result for: $seriesName");
        }
      } catch (e) {
        print('Error fetching data for $seriesName: $e');
        // Optionally add an error log or result state
      } finally {
        _processedNames.add(seriesName);
        _progress = _processedNames.length / totalToProcess;
        notifyListeners();
        // API Delay
        await Future.delayed(const Duration(milliseconds: 50));
      }
    }

    _isProcessing = false;
    _statusMessage = 'Processing complete! ${_results.length} items found.';
    notifyListeners();
  }

  Future<void> _requestStoragePermission() async {
    if (Platform.isAndroid || Platform.isIOS) {
      if (!await Permission.storage.isGranted) {
        await Permission.storage.request();
      }
    }
  }
Future<void> exportToCsv() async {
    await _requestStoragePermission();
    final String? dirPath = await FilePicker.platform.getDirectoryPath();
    if (dirPath == null) {
      return;
    }

    final csvFilePath = p.join(
        dirPath, 'tmdb_output_${DateTime.now().millisecondsSinceEpoch}.csv');
    List<List<String>> csvData = [
      MediaData.getCsvHeaders(),
      ..._results.map((item) => item.toCsvRow())
    ];

    String csv = const ListToCsvConverter().convert(csvData);
    await File(csvFilePath).writeAsString(csv);

    // Optionally show a toast here
  }
  

// Helper to get public downloads directory
  Future<Directory?> getDownloadsDirectory() async {
    if (Platform.isAndroid) {
      // This is the standard Downloads directory on Android
      final downloadsPath = '/storage/emulated/0/Download';
      final dir = Directory(downloadsPath);
      if (await dir.exists()) {
        return dir;
      }
      return await getExternalStorageDirectory();
    } else if (Platform.isIOS) {
      return await getApplicationDocumentsDirectory();
    }
    return null; // For other platforms
  }
}
// lib/text_tool_provider.dart



// Enums to manage UI state clearly
enum ReplaceMode { standard, pattern }
enum PatternPlacement { start, end }

class TextToolProvider extends ChangeNotifier {
  // File Handling State
  File? pickedFile;
  List<String> fileLines = [];
  List<String> previewLines = [];
  int _linesToShow = 50; // Initial number of lines to preview
  final int _linesIncrement = 50; // How many lines to add on "Load More"

  // Find and Replace State
  final findController = TextEditingController();
  final replaceController = TextEditingController();
  bool isCaseSensitive = false;
  bool isRegex = false;

  // Replacement Mode State
  ReplaceMode replaceMode = ReplaceMode.standard;

  // Pattern Generator State
  PatternPlacement patternPlacement = PatternPlacement.start;
  String patternPadding = 'None'; // e.g., '0', '00', '000'
  final patternSeparatorController = TextEditingController();

  // Processing State
  bool isProcessing = false;

  // --- GETTERS ---
  bool get hasFile => pickedFile != null;

  // --- UI METHODS ---

  void setCaseSensitive(bool value) {
    isCaseSensitive = value;
    notifyListeners();
  }

  void setRegex(bool value) {
    isRegex = value;
    notifyListeners();
  }
  
  void setReplaceMode(ReplaceMode mode) {
    replaceMode = mode;
    notifyListeners();
  }

  void setPatternPlacement(PatternPlacement placement) {
    patternPlacement = placement;
    notifyListeners();
  }

  void setPatternPadding(String padding) {
    patternPadding = padding;
    notifyListeners();
  }

  // --- FILE HANDLING METHODS ---

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['txt', 'csv', 'json', 'log', 'md'],
    );

    if (result != null) {
      pickedFile = File(result.files.single.path!);
      fileLines = await pickedFile!.readAsLines();
      _linesToShow = 50; // Reset preview
      _updatePreview();
    }
  }

  void loadMore() {
    if (previewLines.length < fileLines.length) {
      _linesToShow += _linesIncrement;
      _updatePreview();
    }
  }

  void _updatePreview() {
    if (fileLines.length <= _linesToShow) {
      previewLines = List.from(fileLines);
    } else {
      previewLines = fileLines.sublist(0, _linesToShow);
    }
    notifyListeners();
  }

  // --- CORE PROCESSING METHOD ---

  Future<String?> processAndSaveFile() async {
    if (pickedFile == null || findController.text.isEmpty) {
      return "Error: Please select a file and enter text to find.";
    }

    isProcessing = true;
    notifyListeners();

    try {
      // 1. Get Save Path
      String? outputDir = await FilePicker.platform.getDirectoryPath();
      final originalFileName = pickedFile!.path.split(Platform.pathSeparator).last;
      final newFileName = 'processed_$originalFileName';
      final savePath = '$outputDir${Platform.pathSeparator}$newFileName';

      // 2. Prepare RegExp
      String findPattern = findController.text;
      if (!isRegex) {
        findPattern = RegExp.escape(findPattern);
      }
      
      // The user can enter '*' for an easy wildcard, which we convert to '.*?' for regex
      findPattern = findPattern.replaceAll('*', '(.*?)');

      final regex = RegExp(
        findPattern,
        caseSensitive: isCaseSensitive,
        multiLine: false, // Process line by line
      );

      // 3. Process Content
      final buffer = StringBuffer();
      int matchCounter = 1; // For pattern generator

      for (final line in fileLines) {
        String processedLine;

        if (replaceMode == ReplaceMode.standard) {
          processedLine = line.replaceAll(regex, replaceController.text);
        } else { // Pattern Mode
          processedLine = line.replaceAllMapped(regex, (match) {
            String numberString = matchCounter.toString();
            if (patternPadding != 'None') {
              numberString = numberString.padLeft(patternPadding.length + 1, '0');
            }

            final separator = patternSeparatorController.text;
            // The user types 'n' in the replace field to signify the number's position
            String replacement = replaceController.text.replaceAll('n', '$separator$numberString$separator');
            
            // Handle regex capture groups ($1, $2) if present
            for (int i = 1; i <= match.groupCount; i++) {
                replacement = replacement.replaceAll('\$$i', match.group(i) ?? '');
            }

            matchCounter++;
            return replacement;
          });
        }
        buffer.writeln(processedLine);
      }
      
      // 4. Save to New File
      final outputFile = File(savePath);
      await outputFile.writeAsString(buffer.toString());

      isProcessing = false;
      notifyListeners();
      return "File successfully processed and saved to:\n$savePath";

    } catch (e) {
      isProcessing = false;
      notifyListeners();
      return "An error occurred during processing: $e";
    }
  }

  @override
  void dispose() {
    findController.dispose();
    replaceController.dispose();
    patternSeparatorController.dispose();
    super.dispose();
  }
}