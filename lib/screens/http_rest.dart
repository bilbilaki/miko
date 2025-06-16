import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HttpClientPage extends StatefulWidget {
  const HttpClientPage({super.key});

  @override
  _HttpClientPageState createState() => _HttpClientPageState();
}

class _HttpClientPageState extends State<HttpClientPage> {
  // Controllers for various input fields
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  final TextEditingController _envController = TextEditingController();
  final List<TextEditingController> _headerKeyControllers = [];
  final List<TextEditingController> _headerValueControllers = [];
  final List<TextEditingController> _paramKeyControllers = [];
  final List<TextEditingController> _paramValueControllers = [];

  // Dropdown and state variables
  String _selectedMethod = 'GET';
  String _selectedBodyType = 'None';
  int _loopCount = 1;
  String _response = '';
  final List<String> _logs = [];
  File? _selectedFile;
  bool _isLoading = false;
  Map<String, String> _environment = {};
  static const _kExternalPathKey = 'external_directory_path';

  String? _externalPath;

  String? _currentPath; // Track the path currently listing
  List<Directory> _folders = [];
  List<File> _movies = [];

  String? get externalPath => _externalPath;

  List<Directory> get folders => List.unmodifiable(_folders);
  List<File> get movies => List.unmodifiable(_movies);

  /// The directory being currently listed (for subfolder navigation)
  String? get currentPath => _currentPath ?? _externalPath;

  final Map<String, Uint8List> _thumbnailCache = {};

  // ... (keep your existing loadPath, setPath, refresh, isMovieFile methods)

  // HTTP Methods and Body Types
  final List<String> methods = ['GET', 'POST', 'PUT', 'DELETE', 'PATCH'];
  final List<String> bodyTypes = ['None', 'JSON', 'Multipart', 'Raw'];

  @override
  void initState() {
    super.initState();
    _loadEnvironment();
    _addHeaderRow();
    _addParamRow();
  }

  // Load environment variables from SharedPreferences
  Future<void> _loadEnvironment() async {
    final prefs = await SharedPreferences.getInstance();
    final envString = prefs.getString('environment') ?? '{}';
    setState(() {
      _environment = Map<String, String>.from(jsonDecode(envString));
    });
  }

  // Save environment variables
  Future<void> _saveEnvironment(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    _environment[key] = value;
    await prefs.setString('environment', jsonEncode(_environment));
    setState(() {});
  }

  // Add a new header row
  void _addHeaderRow() {
    setState(() {
      _headerKeyControllers.add(TextEditingController());
      _headerValueControllers.add(TextEditingController());
    });
  }

  // Add a new parameter row
  void _addParamRow() {
    setState(() {
      _paramKeyControllers.add(TextEditingController());
      _paramValueControllers.add(TextEditingController());
    });
  }

  // Pick file for multipart request
  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  // Send HTTP request
  Future<void> _sendRequest() async {
    setState(() {
      _isLoading = true;
      _response = '';
    });

    String url = _urlController.text;
    Map<String, String> headers = {};
    for (int i = 0; i < _headerKeyControllers.length; i++) {
      if (_headerKeyControllers[i].text.isNotEmpty) {
        headers[_headerKeyControllers[i].text] =
            _headerValueControllers[i].text;
      }
    }

    Uri uri = Uri.parse(url);
    Map<String, String> queryParams = {};
    for (int i = 0; i < _paramKeyControllers.length; i++) {
      if (_paramKeyControllers[i].text.isNotEmpty) {
        queryParams[_paramKeyControllers[i].text] =
            _paramValueControllers[i].text;
      }
    }
    uri = uri.replace(queryParameters: queryParams);

    try {
      for (int i = 0; i < _loopCount; i++) {
        http.Response? response;
        if (_selectedMethod == 'GET') {
          response = await http.get(uri, headers: headers);
        } else if (_selectedMethod == 'POST') {
          if (_selectedBodyType == 'JSON') {
            response = await http.post(uri,
                headers: headers, body: _bodyController.text);
          } else if (_selectedBodyType == 'Multipart' &&
              _selectedFile != null) {
            var request = http.MultipartRequest('POST', uri);
            request.headers.addAll(headers);
            request.files.add(
                await http.MultipartFile.fromPath('file', _selectedFile!.path));
            var streamedResponse = await request.send();
            response = await http.Response.fromStream(streamedResponse);
          } else {
            response = await http.post(uri,
                headers: headers, body: _bodyController.text);
          }
        } else if (_selectedMethod == 'PUT') {
          if (_selectedBodyType == 'JSON') {
            response = await http.put(uri,
                headers: headers, body: _bodyController.text);
          } else if (_selectedBodyType == 'Multipart' &&
              _selectedFile != null) {
            var request = http.MultipartRequest('PUT', uri);
            request.headers.addAll(headers);
            request.files.add(
                await http.MultipartFile.fromPath('file', _selectedFile!.path));
            var streamedResponse = await request.send();
            response = await http.Response.fromStream(streamedResponse);
          } else {
            response = await http.put(uri,
                headers: headers, body: _bodyController.text);
          }
        } else if (_selectedMethod == 'PATCH') {
          if (_selectedBodyType == 'JSON') {
            response = await http.patch(uri,
                headers: headers, body: _bodyController.text);
          } else if (_selectedBodyType == 'Multipart' &&
              _selectedFile != null) {
            var request = http.MultipartRequest('PATCH', uri);
            request.headers.addAll(headers);
            request.files.add(
                await http.MultipartFile.fromPath('file', _selectedFile!.path));
            var streamedResponse = await request.send();
            response = await http.Response.fromStream(streamedResponse);
          } else {
            response = await http.patch(uri,
                headers: headers, body: _bodyController.text);
          }
        } else if (_selectedMethod == 'DELETE') {
          if (_selectedBodyType == 'JSON') {
            response = await http.delete(uri,
                headers: headers, body: _bodyController.text);
          } else if (_selectedBodyType == 'Multipart' &&
              _selectedFile != null) {
            var request = http.MultipartRequest('DELETE', uri);
            request.headers.addAll(headers);
            request.files.add(
                await http.MultipartFile.fromPath('file', _selectedFile!.path));
            var streamedResponse = await request.send();
            response = await http.Response.fromStream(streamedResponse);
          } else {
            response = await http.delete(uri,
                headers: headers, body: _bodyController.text);
          }
        } // Add similar blocks for PUT, DELETE, PATCH

        setState(() {
          _response = response!.body;
          _logs.add(
              'Attempt ${i + 1}: $_selectedMethod $url - Status: ${response.statusCode}');
          if (response.headers['content-type']
                  ?.contains('application/octet-stream') ==
              true) {
            _saveFileToStorage(response.bodyBytes, 'downloaded_file');
          }
        });
      }
    } catch (e) {
      setState(() {
        _response = 'Error: $e';
        _logs.add('Error: $e');
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshList(String? folder) async {
    _folders = [];
    _movies = [];
    Future<void> setPath(String newPath) async {
      final prefs = await SharedPreferences.getInstance();
      _externalPath = newPath;
      await prefs.setString(_kExternalPathKey, newPath);
      await _refreshList(newPath);
   
   String? dirPath = folder ?? _externalPath;
    if (dirPath == null) return;

    _currentPath = dirPath;

    final dir = Directory(dirPath);
    if (await dir.exists()) {
      final entries = dir.listSync();
      _folders = entries.whereType<Directory>().toList();
    }
  }
    
  }

  // Save downloaded file to storage
  Future<void> _saveFileToStorage(List<int> bytes, String fileName) async {
    final directory = await getExternalStorageDirectory();
    final file = File('${directory!.path}/$fileName');
    await file.writeAsBytes(bytes);
    setState(() {
      _logs.add('File saved to: ${file.path}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HTTP Client (Postman-like)'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // URL and Method
              Row(
                children: [
                  DropdownButton<String>(
                    value: _selectedMethod,
                    onChanged: (value) =>
                        setState(() => _selectedMethod = value!),
                    items: methods
                        .map((method) => DropdownMenuItem(
                            value: method, child: Text(method)))
                        .toList(),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _urlController,
                      decoration: const InputDecoration(labelText: 'URL'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _sendRequest,
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Send'),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Environment Variables
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _envController,
                      decoration:
                          const InputDecoration(labelText: 'Env Key=Value'),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      final parts = _envController.text.split('=');
                      if (parts.length == 2) {
                        _saveEnvironment(parts[0], parts[1]);
                        _envController.clear();
                      }
                    },
                    icon: const Icon(Icons.save),
                  ),
                ],
              ),
              Text('Environment: $_environment'),
              const SizedBox(height: 20),

              // Headers
              const Text('Headers',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ...List.generate(
                  _headerKeyControllers.length,
                  (index) => Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _headerKeyControllers[index],
                              decoration:
                                  const InputDecoration(labelText: 'Key'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _headerValueControllers[index],
                              decoration:
                                  const InputDecoration(labelText: 'Value'),
                            ),
                          ),
                        ],
                      )),
              ElevatedButton(
                onPressed: _addHeaderRow,
                child: const Text('Add Header'),
              ),
              const SizedBox(height: 20),

              // Query Parameters
              const Text('Query Params',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ...List.generate(
                  _paramKeyControllers.length,
                  (index) => Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _paramKeyControllers[index],
                              decoration:
                                  const InputDecoration(labelText: 'Key'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _paramValueControllers[index],
                              decoration:
                                  const InputDecoration(labelText: 'Value'),
                            ),
                          ),
                        ],
                      )),
              ElevatedButton(
                onPressed: _addParamRow,
                child: const Text('Add Param'),
              ),
              const SizedBox(height: 20),

              // Body Type and Content
              DropdownButton<String>(
                value: _selectedBodyType,
                onChanged: (value) =>
                    setState(() => _selectedBodyType = value!),
                items: bodyTypes
                    .map((type) =>
                        DropdownMenuItem(value: type, child: Text(type)))
                    .toList(),
              ),
              if (_selectedBodyType == 'Multipart')
                ElevatedButton(
                  onPressed: _pickFile,
                  child: Text(_selectedFile == null
                      ? 'Select File'
                      : 'File: ${_selectedFile!.path}'),
                ),
              if (_selectedBodyType != 'None' &&
                  _selectedBodyType != 'Multipart')
                TextField(
                  controller: _bodyController,
                  maxLines: 5,
                  decoration: const InputDecoration(labelText: 'Body'),
                ),
              const SizedBox(height: 20),

              // Loop Configuration
              Row(
                children: [
                  const Text('Loop Count:'),
                  const SizedBox(width: 10),
                  DropdownButton<int>(
                    value: _loopCount,
                    onChanged: (value) => setState(() => _loopCount = value!),
                    items: List.generate(
                        10,
                        (index) => DropdownMenuItem(
                            value: index + 1, child: Text('${index + 1}'))),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Response
              const Text('Response',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Container(
                height: 200,
                padding: const EdgeInsets.all(8.0),
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.grey)),
                child: SingleChildScrollView(child: Text(_response)),
              ),
              const SizedBox(height: 20),

              // Logs
              const Text('Logs',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Container(
                height: 150,
                padding: const EdgeInsets.all(8.0),
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.grey)),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _logs.map((log) => Text(log)).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}