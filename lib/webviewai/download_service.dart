import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:open_filex/open_filex.dart';

class DownloadService {
  Future<void> downloadFile(String url, String filename, BuildContext context) async {
    try {
      // Request storage permission
      var status = await Permission.storage.request();
      if (status.isDenied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Storage permission denied. Cannot download file.')),
        );
        return;
      }
      if (status.isPermanentlyDenied) {
        openAppSettings(); // Open app settings for manual permission grant
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Storage permission permanently denied. Please enable it in settings.')),
        );
        return;
      }

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final directory = await getExternalStorageDirectory();
        if (directory == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not get external storage directory.')),
          );
          return;
        }
        final filePath = '${directory.path}/$filename';
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Downloaded $filename to ${directory.path}'),
            action: SnackBarAction(
              label: 'Open',
              onPressed: () async {
                await OpenFilex.open(filePath);
              },
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to download file: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error downloading file: $e')),
      );
    }
  }
}