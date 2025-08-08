import 'dart:io';
import 'package:path_provider/path_provider.dart';

abstract class LocalFileService {
  Future<String> readFromFile(String path);
  Future<void> writeToFile(String path, String content);
  Future<bool> fileExists(String path);
  Future<String> getAppDirectory(); // Helper to get base directory
}

class LocalFileServiceImpl implements LocalFileService {
  
  Future<Directory> _getBaseDirectory() async {
    // Use getApplicationDocumentsDirectory for cross-platform compatibility
    return await getApplicationDocumentsDirectory();
  }

  @override
  Future<String> getAppDirectory() async {
    return (await _getBaseDirectory()).path;
  }

  // Helper to construct full path
  Future<String> _getFullPath(String path) async {
    final baseDir = await _getBaseDirectory();
    // Ensure path is relative to baseDir to avoid absolute path issues
    return '${baseDir.path}/$path';
  }

  @override
  Future<String> readFromFile(String path) async {
    final fullPath = await _getFullPath(path);
    final file = File(fullPath);
    if (await file.exists()) {
      return await file.readAsString();
    }
    throw FileSystemException('File not found', fullPath);
  }

  @override
  Future<void> writeToFile(String path, String content) async {
    final fullPath = await _getFullPath(path);
    final file = File(fullPath);
    // Create parent directories if they don't exist
    await file.create(recursive: true);
    await file.writeAsString(content);
  }

  @override
  Future<bool> fileExists(String path) async {
    final fullPath = await _getFullPath(path);
    final file = File(fullPath);
    return await file.exists();
  }
}