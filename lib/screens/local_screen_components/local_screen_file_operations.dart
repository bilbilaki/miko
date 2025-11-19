import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:swipe_image_gallery/swipe_image_gallery.dart';
import '../../providers/local_provider.dart';
import '../video_player_wplaylist_screen.dart';
import 'local_screen_dialogs.dart';

class LocalScreenFileOperations {
  /// Handles file tap actions based on file type
  static Future<void> handleFileTap(
    BuildContext context,
    File file,
    LocalProvider provider,
    Function(String) showSnackBar,
  ) async {
    try {
      if (provider.isMovieFile(file)) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => VideoPlayerScreen(
              videoName: file.path,
              source: 'local',
              videoUrl: file.path,
            ),
          ),
        );
      } else if (provider.isImageFile(file)) {
        showImageDialog(context, file, null);
      } else if (provider.isAudioFile(file)) {
        final String filePath = file.path;
        final String ext = p.extension(filePath).toLowerCase();
        if (!['.mp3', '.wav', '.aac', '.flac', '.ogg'].contains(ext)) {
          showSnackBar('Unsupported audio format: $ext');
          return;
        }
      } else if (provider.isTextFile(file)) {
        await showDocumentContentDialog(context, file, provider, showSnackBar);
      } else {
        showSnackBar('No specific handler for this file type.');
      }
    } catch (e) {
      showSnackBar('Could not open file: ${p.basename(file.path)} - $e');
      if (kDebugMode) print('Error opening file: $e');
    }
  }

  /// Show image in a dialog
  static void showImageDialog(
    BuildContext context,
    File imageFile,
    String? currentFolderPath,
  ) {
    SwipeImageGallery(
      context: context,
      children: [
        Image.file(imageFile, fit: BoxFit.contain),
      ],
    ).show();
  }

  /// Process and parse content of documents to view/edit
  static Future<void> showDocumentContentDialog(
    BuildContext context,
    File documentFile,
    LocalProvider provider,
    Function(String) showSnackBar,
  ) async {
    String? initialContent = await provider.getDocumentContent(
      documentFile.path,
    );

    if (initialContent == null) {
      showSnackBar(
        'Failed to read document content. It might be a binary or unsupported file type.',
      );
      return;
    }

    TextEditingController contentController = TextEditingController(
      text: initialContent,
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit: ${p.basename(documentFile.path)}'),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.6,
            child: TextField(
              controller: contentController,
              maxLines: null,
              expands: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Document content',
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final String newContent = contentController.text;
                final bool success = await provider.saveDocumentContent(
                  documentFile.path,
                  newContent,
                );
                if (success) {
                  showSnackBar('File saved successfully.');
                  Navigator.of(context).pop();
                } else {
                  showSnackBar('Failed to save file.');
                }
              },
              child: const Text('Save'),
            ),
            ElevatedButton(
              onPressed: () async {
                final String? newFileName = await LocalScreenDialogs.showInputDialog(
                  context,
                  'Save As',
                  'Enter new file name (e.g., my_document.txt):',
                  p.basename(documentFile.path),
                );
                if (newFileName != null && newFileName.isNotEmpty) {
                  final String newFilePath = p.join(
                    p.dirname(documentFile.path),
                    newFileName,
                  );
                  final bool success = await provider.saveDocumentContentAs(
                    newFilePath,
                    contentController.text,
                  );
                  if (success) {
                    showSnackBar('File saved as $newFileName successfully.');
                    Navigator.of(context).pop();
                  } else {
                    showSnackBar('Failed to save file as $newFileName.');
                  }
                }
              },
              child: const Text('Save As'),
            ),
          ],
        );
      },
    );
  }

  /// Handles renaming a single file with user input
  static Future<void> renameFile(
    BuildContext context,
    File file,
    LocalProvider provider,
    Function(String) showSnackBar,
  ) async {
    final oldName = p.basename(file.path);
    final String? newName = await LocalScreenDialogs.showInputDialog(
      context,
      'Rename File',
      'Enter new name for "$oldName":',
      oldName,
    );
    if (newName != null && newName.isNotEmpty && newName != oldName) {
      final bool success = await provider.renameFile(file.path, newName);
      if (success) {
        showSnackBar('File renamed to "$newName"');
      } else {
        showSnackBar('Failed to rename file.');
      }
    }
  }

  /// Handles deleting a single file after confirmation
  static Future<void> deleteFile(
    BuildContext context,
    File file,
    LocalProvider provider,
    Function(String) showSnackBar,
  ) async {
    final confirmed = await LocalScreenDialogs.showConfirmationDialog(
      context,
      'Delete File',
      'Are you sure you want to delete "${p.basename(file.path)}"? This cannot be undone.',
    );
    if (confirmed == true) {
      final bool success = await provider.deleteFile(file.path);
      if (success) {
        showSnackBar('File deleted successfully.');
      } else {
        showSnackBar('Failed to delete file.');
      }
    }
  }

  /// Handles copying a file to a new location selected by the user
  static Future<void> copyFile(
    BuildContext context,
    File file,
    LocalProvider provider,
    String? currentFolderPath,
    Function(String) showSnackBar,
  ) async {
    final String? destinationPath = await LocalScreenDialogs.showPathSelectionDialog(
      context,
      'Copy "${p.basename(file.path)}" to',
      currentFolderPath,
    );
    if (destinationPath != null) {
      final newFilePath = p.join(destinationPath, p.basename(file.path));
      if (await File(newFilePath).exists()) {
        final overwriteConfirmed = await LocalScreenDialogs.showConfirmationDialog(
          context,
          'File Exists',
          'A file with the same name already exists in the destination. Overwrite?',
        );
        if (overwriteConfirmed != true) {
          showSnackBar('Copy cancelled: File already exists.');
          return;
        }
        await File(newFilePath).delete();
      }

      final bool success = await provider.copyFile(file.path, newFilePath);
      if (success) {
        showSnackBar('File copied successfully.');
      } else {
        showSnackBar('Failed to copy file.');
      }
    }
  }

  /// Handles moving a file to a new location selected by the user
  static Future<void> moveFile(
    BuildContext context,
    File file,
    LocalProvider provider,
    String? currentFolderPath,
    Function(String) showSnackBar,
  ) async {
    final String? destinationPath = await LocalScreenDialogs.showPathSelectionDialog(
      context,
      'Move "${p.basename(file.path)}" to',
      currentFolderPath,
    );
    if (destinationPath != null) {
      final newFilePath = p.join(destinationPath, p.basename(file.path));
      if (await File(newFilePath).exists()) {
        final overwriteConfirmed = await LocalScreenDialogs.showConfirmationDialog(
          context,
          'File Exists',
          'A file with the same name already exists in the destination. Overwrite?',
        );
        if (overwriteConfirmed != true) {
          showSnackBar('Move cancelled: File already exists.');
          return;
        }
        await File(newFilePath).delete();
      }
      final bool success = await provider.moveFile(file.path, newFilePath);
      if (success) {
        showSnackBar('File moved successfully.');
      } else {
        showSnackBar('Failed to move file.');
      }
    }
  }

  /// Handles renaming a folder with user input
  static Future<void> renameFolder(
    BuildContext context,
    Directory folder,
    LocalProvider provider,
    Function(String) showSnackBar,
  ) async {
    final oldName = p.basename(folder.path);
    final String? newName = await LocalScreenDialogs.showInputDialog(
      context,
      'Rename Folder',
      'Enter new name for "$oldName":',
      oldName,
    );
    if (newName != null && newName.isNotEmpty && newName != oldName) {
      final newPath = p.join(p.dirname(folder.path), newName);
      final bool success = await provider.moveDirectory(folder.path, newPath);
      if (success) {
        showSnackBar('Folder renamed to "$newName"');
      } else {
        showSnackBar('Failed to rename folder.');
      }
    }
  }

  /// Handles deleting a folder after confirmation
  static Future<void> deleteFolder(
    BuildContext context,
    Directory folder,
    LocalProvider provider,
    String? currentFolderPath,
    Function(String) showSnackBar,
    Function() goUp,
  ) async {
    final confirmed = await LocalScreenDialogs.showConfirmationDialog(
      context,
      'Delete Folder',
      'Are you sure you want to delete folder "${p.basename(folder.path)}"? All its contents will be lost. This cannot be undone.',
    );
    if (confirmed == true) {
      final bool success = await provider.deleteFolder(folder.path);
      if (success) {
        showSnackBar('Folder deleted successfully.');
        if (p.equals(
          folder.path,
          currentFolderPath ?? provider.externalPath!,
        )) {
          goUp();
        }
      } else {
        showSnackBar('Failed to delete folder.');
      }
    }
  }

  /// Handles copying a folder to a new location selected by the user
  static Future<void> copyFolder(
    BuildContext context,
    Directory folder,
    LocalProvider provider,
    String? currentFolderPath,
    Function(String) showSnackBar,
  ) async {
    final String? destinationPath = await LocalScreenDialogs.showPathSelectionDialog(
      context,
      'Copy folder "${p.basename(folder.path)}" to',
      currentFolderPath,
    );
    if (destinationPath != null) {
      final newDirPath = p.join(destinationPath, p.basename(folder.path));
      if (await Directory(newDirPath).exists()) {
        final overwriteConfirmed = await LocalScreenDialogs.showConfirmationDialog(
          context,
          'Folder Exists',
          'A folder with the same name already exists in the destination. Overwrite (merge/replace contents)?',
        );
        if (overwriteConfirmed != true) {
          showSnackBar('Copy cancelled: Folder already exists.');
          return;
        }
        await Directory(newDirPath).delete(recursive: true);
      }
      final bool success = await provider.copyDirectory(
        folder.path,
        newDirPath,
      );
      if (success) {
        showSnackBar('Folder copied successfully.');
      } else {
        showSnackBar('Failed to copy folder.');
      }
    }
  }

  /// Handles moving a folder to a new location selected by the user
  static Future<void> moveFolder(
    BuildContext context,
    Directory folder,
    LocalProvider provider,
    String? currentFolderPath,
    Function(String) showSnackBar,
    Function() goUp,
  ) async {
    final String? destinationPath = await LocalScreenDialogs.showPathSelectionDialog(
      context,
      'Move folder "${p.basename(folder.path)}" to',
      currentFolderPath,
    );
    if (destinationPath != null) {
      final newDirPath = p.join(destinationPath, p.basename(folder.path));
      if (await Directory(newDirPath).exists()) {
        final overwriteConfirmed = await LocalScreenDialogs.showConfirmationDialog(
          context,
          'Folder Exists',
          'A folder with the same name already exists in the destination. Overwrite (merge/replace contents)?',
        );
        if (overwriteConfirmed != true) {
          showSnackBar('Move cancelled: Folder already exists.');
          return;
        }
        await Directory(newDirPath).delete(recursive: true);
      }
      final bool success = await provider.moveDirectory(
        folder.path,
        newDirPath,
      );
      if (success) {
        showSnackBar('Folder moved successfully.');
        if (p.equals(
          folder.path,
          currentFolderPath ?? provider.externalPath!,
        )) {
          goUp();
        }
      } else {
        showSnackBar('Failed to move folder.');
      }
    }
  }

  /// Handles creating a new folder in the specified parent folder
  static Future<void> createNewFolder(
    BuildContext context,
    Directory parentFolder,
    LocalProvider provider,
    Function(String) showSnackBar,
  ) async {
    final String? folderName = await LocalScreenDialogs.showInputDialog(
      context,
      'Create New Folder',
      'Enter new folder name (e.g., New folder):',
    );
    if (folderName != null && folderName.isNotEmpty) {
      final String fullNewFolderPath = p.join(parentFolder.path, folderName);
      final bool success = await provider.createFolder(fullNewFolderPath);
      if (success) {
        showSnackBar('Folder "$folderName" created.');
      } else {
        showSnackBar(
          'Failed to create folder. It might already exist or permissions are an issue.',
        );
      }
    }
  }

  /// Displays a dialog for batch renaming files in the current directory
  static Future<void> showBatchRenameDialog(
    BuildContext context,
    LocalProvider provider,
    String? currentFolderPath,
    Function(String) showSnackBar,
  ) async {
    await LocalScreenDialogs.showBatchRenameDialog(
      context,
      (prefix, postfix) async {
        final String targetPath = currentFolderPath ?? provider.externalPath!;
        if (targetPath.isEmpty) {
          showSnackBar('No directory selected for batch rename.');
          return;
        }

        final bool? confirmed = await LocalScreenDialogs.showConfirmationDialog(
          context,
          'Confirm Batch Rename',
          'Are you sure you want to batch rename all files in \n"$targetPath"?\nThis action cannot be easily undone.',
        );

        if (confirmed == true) {
          final bool success = await provider.renameFilesInPath(
            targetPath,
            prefix: prefix,
            postfix: postfix,
          );
          if (success) {
            showSnackBar('Batch rename completed.');
          } else {
            showSnackBar('Batch rename failed.');
          }
        }
      },
    );
  }
}
