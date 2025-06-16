import 'dart:io';

import 'package:flutter/material.dart';

import 'package:path_provider/path_provider.dart';

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
