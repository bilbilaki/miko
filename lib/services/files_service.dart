import 'dart:io';

import 'package:flutter/material.dart';

import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

class FileUtils {
  static Future<String?> pickImageAndConvertToBase64() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final bytes = await image.readAsBytes();
      return 'data:image/${image.name.split('.').last};base64,${base64Encode(bytes)}'; // Add data URI prefix
    }
    return null;
  }

  static Future<Map<String, String>?> pickAudioAndConvertToBase64() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.audio);
    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      final bytes = await file.readAsBytes();
      final String format = result.files.single.extension ?? 'wav'; // Default to wav if no extension
      return {
        'data': base64Encode(bytes),
        'format': format,
      };
    }
    return null;
  }
}
class FileService {
  Future<File?> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'txt',
        'csv',
        'json',
        'log',
        'md',
        'yaml',
        'xml',
        'html'
      ], // Add more as needed
    );

    if (result != null && result.files.single.path != null) {
      return File(result.files.single.path!);
    }
    return null;
  }

  Future<String> readFileContent(File file) async {
    try {
      return await file.readAsString();
    } catch (e) {
      print('Error reading file: $e');
      return '';
    }
  }

  Future<File?> saveFile(String fileName, String content) async {
    try {
      // Get the application documents directory
      final String directory = (await getApplicationDocumentsDirectory()).path;
      final String filePath = p.join(directory, fileName);
      final File file = File(filePath);

      // Ensure the directory exists. If not, create it.
      if (!await Directory(directory).exists()) {
        await Directory(directory).create(recursive: true);
      }

      await file.writeAsString(content);
      print('File saved to: $filePath');
      return file;
    } catch (e) {
      print('Error saving file: $e');
      return null;
    }
  }

  // For platform-specific saving to user-chosen directory, you'd likely use
  // packages like `path_provider` to get external storage directories
  // and then potentially `permission_handler` to request write access,
  // or use a package like `file_saver` for a more abstract way to save.
  // Example with file_saver:
  /*
  Future<bool> saveFileToUserDirectory(String fileName, String content) async {
    try {
      await FileSaver.instance.saveFile(fileName: fileName, bytes: utf8.encode(content), mimeType: MimeType.TEXT);
      return true;
    } catch (e) {
      print('Error saving file to user directory: $e');
      return false;
    }
  }
  */
}
class FilesService {
// ···
  Future<String> get localPath async {
    debugPrint("try to get path ...");
    final directory = await getApplicationDocumentsDirectory();
    debugPrint('file path$directory is founded');
    return directory.path;
  }

 Future<List<File>> get listLocalFile async {
    debugPrint("try to get File ...");
    final path = await localPath;
    final directory = Directory(path);
    final files = await directory
        .list()
        .where((entity) => entity is File)
        .cast<File>()
        .toList();
    return files;
  }
Future<File> get localFile async {
    final path = await localPath;
    return File('$path/counter.txt');
  }

  Future<File?> getFileByName(String fileName) async {
    final path = await localPath;
    final file = File('$path/$fileName');
    if (await file.exists()) {
      return file;
    }
    return null; // File not found
  }

  Future<File> write( content, fileName) async {
    final file = await getFileByName(fileName);

    // Write the file
    return file!.writeAsString('$content');
  }
Future<String> read( fileName) async {
    try {
      final file = await getFileByName(fileName);

      // Read the file
      final contents = await file!.readAsString();

      return (contents);
    } catch (e) {
      // If encountering an error, return 0
      return 'erroe to reading file or not exist';
    }
  }

Future<Directory> getAppSaveDirectory() async {
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    // Desktop platforms: use application support or documents directory
    return await getApplicationSupportDirectory();
  } else {
    // Mobile platforms: use internal app directory
    return await getApplicationDocumentsDirectory();
  }
}
}
