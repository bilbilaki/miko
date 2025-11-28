import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import '../../providers/zip_explorer_provider.dart';
import '../../providers/local_provider.dart';

class ZipOperationDialogs {
  /// Show dialog to compress a folder to zip
  static Future<void> showCompressFolderDialog(
    BuildContext context,
    String folderPath,
    LocalProvider provider,
    ZipExplorerProvider zipProvider,
    Function(String) showSnackBar,
  ) async {
    final folderName = p.basename(folderPath);
    final defaultZipName = '$folderName.zip';
    final defaultZipPath = p.join(p.dirname(folderPath), defaultZipName);
    
    final TextEditingController controller = TextEditingController(
      text: defaultZipPath,
    );
    
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Compress to ZIP'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Folder: $folderName'),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Output ZIP path',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              icon: const Icon(Icons.folder_open),
              label: const Text('Browse'),
              onPressed: () async {
                final result = await FilePicker.platform.saveFile(
                  dialogTitle: 'Save ZIP file',
                  fileName: defaultZipName,
                  type: FileType.custom,
                  allowedExtensions: ['zip'],
                );
                if (result != null) {
                  controller.text = result;
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Compress'),
          ),
        ],
      ),
    );
    
    if (confirmed == true) {
      final outputPath = controller.text;
      if (outputPath.isEmpty) {
        showSnackBar('Please specify an output path');
        return;
      }
      
      showSnackBar('Compressing folder to ZIP...');
      
      // Show progress dialog
      if (!context.mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return PopScope(
            canPop: false,
            child: AlertDialog(
              title: const Text('Compressing...'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text('Creating ${p.basename(outputPath)}'),
                  const SizedBox(height: 8),
                  const Text(
                    'This may take a while for large folders',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        },
      );
      
      final success = await zipProvider.createZipFromFolder(
        folderPath: folderPath,
        outputZipPath: outputPath,
      );
      
      // Close progress dialog
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      
      if (success) {
        showSnackBar('Successfully created ZIP: ${p.basename(outputPath)}');
        await provider.refresh(provider.currentPath);
      } else {
        showSnackBar('Failed to create ZIP file');
      }
    }
  }
  
  /// Show dialog to extract entire zip
  static Future<void> showExtractZipDialog(
    BuildContext context,
    String zipPath,
    LocalProvider provider,
    ZipExplorerProvider zipProvider,
    Function(String) showSnackBar,
  ) async {
    final zipName = p.basenameWithoutExtension(zipPath);
    final defaultExtractPath = p.join(p.dirname(zipPath), zipName);
    
    final TextEditingController controller = TextEditingController(
      text: defaultExtractPath,
    );
    
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Extract ZIP'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ZIP: ${p.basename(zipPath)}'),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Extract to folder',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              icon: const Icon(Icons.folder_open),
              label: const Text('Browse'),
              onPressed: () async {
                final selectedDirectory = await FilePicker.platform.getDirectoryPath();
                if (selectedDirectory != null) {
                  controller.text = selectedDirectory;
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Extract'),
          ),
        ],
      ),
    );
    
    if (confirmed == true) {
      final outputPath = controller.text;
      if (outputPath.isEmpty) {
        showSnackBar('Please specify an output folder');
        return;
      }
      
      // Enter zip mode to perform extraction
      await zipProvider.enterZipMode(zipPath);
      
      showSnackBar('Extracting ZIP...');
      
      final success = await zipProvider.extractZipToFolder(
        outputFolderPath: outputPath,
      );
      
      zipProvider.exitZipMode();
      
      if (success) {
        showSnackBar('Successfully extracted to: ${p.basename(outputPath)}');
        await provider.refresh(provider.currentPath);
      } else {
        showSnackBar('Failed to extract ZIP file');
      }
    }
  }
  
  /// Show dialog to add files to zip
  static Future<void> showAddToZipDialog(
    BuildContext context,
    String zipPath,
    ZipExplorerProvider zipProvider,
    Function(String) showSnackBar,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Files to ZIP'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ZIP: ${p.basename(zipPath)}'),
            const SizedBox(height: 16),
            const Text('Select files or folders to add to the ZIP archive.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.file_open),
            label: const Text('Select Files'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
    
    if (confirmed == true) {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.any,
      );
      
      if (result != null && result.files.isNotEmpty) {
        final filePaths = result.files
            .where((file) => file.path != null)
            .map((file) => file.path!)
            .toList();
        
        if (filePaths.isEmpty) {
          showSnackBar('No valid files selected');
          return;
        }
        
        showSnackBar('Adding ${filePaths.length} file(s) to ZIP...');
        
        final targetPath = zipProvider.currentPathInZip ?? '';
        final success = await zipProvider.addFilesToZip(
          sourcePaths: filePaths,
          targetPathInZip: targetPath,
        );
        
        if (success) {
          showSnackBar('Successfully added files to ZIP');
          await zipProvider.refresh();
        } else {
          showSnackBar('Failed to add files to ZIP');
        }
      }
    }
  }
  
  /// Show dialog to extract selected files from zip
  static Future<void> showExtractSelectedDialog(
    BuildContext context,
    List<String> entryPaths,
    ZipExplorerProvider zipProvider,
    LocalProvider provider,
    Function(String) showSnackBar,
  ) async {
    final TextEditingController controller = TextEditingController(
      text: provider.currentPath,
    );
    
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Extract Files'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Extracting ${entryPaths.length} item(s)'),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Extract to folder',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              icon: const Icon(Icons.folder_open),
              label: const Text('Browse'),
              onPressed: () async {
                final selectedDirectory = await FilePicker.platform.getDirectoryPath();
                if (selectedDirectory != null) {
                  controller.text = selectedDirectory;
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Extract'),
          ),
        ],
      ),
    );
    
    if (confirmed == true) {
      final outputPath = controller.text;
      if (outputPath.isEmpty) {
        showSnackBar('Please specify an output folder');
        return;
      }
      
      showSnackBar('Extracting files...');
      
      final success = await zipProvider.extractFromZip(
        sourcePaths: entryPaths,
        destinationPath: outputPath,
      );
      
      if (success) {
        showSnackBar('Successfully extracted ${entryPaths.length} item(s)');
      } else {
        showSnackBar('Failed to extract files');
      }
    }
  }
  
  /// Show progress indicator for zip operations
  static void showProgressDialog(
    BuildContext context,
    String title,
    ZipExplorerProvider zipProvider,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            StreamBuilder(
              stream: Stream.periodic(const Duration(milliseconds: 500)),
              builder: (context, snapshot) {
                final progress = zipProvider.operationProgress;
                if (progress.isEmpty) {
                  return const Text('Processing...');
                }
                
                final latestProgress = progress.values.last;
                return Column(
                  children: [
                    LinearProgressIndicator(value: latestProgress),
                    const SizedBox(height: 8),
                    Text('${(latestProgress * 100).toStringAsFixed(0)}%'),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
