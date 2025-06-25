import 'dart:io';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart'; // Add share_plus package to pubspec

class ExportService {
  static Future<void> exportCsv(List<List<dynamic>> data, String defaultFileName) async {
    final csv = const ListToCsvConverter().convert(data);
    
    try {
      String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Save CSV File',
        fileName: defaultFileName,
      );
      
      if (outputFile != null) {
        final file = File(outputFile);
        await file.writeAsString(csv);
        return;
      }
    } catch (e) {
      // Fall back to temporary file and sharing if save dialog fails
      await _shareAsCsv(csv, defaultFileName);
    }
  }
  
  static Future<void> _shareAsCsv(String csvContent, String fileName) async {
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/$fileName');
    await file.writeAsString(csvContent);
    
    await Share.shareXFiles(
  [XFile(file.path)],
  text: 'Exported CSV data',
);
  }
}