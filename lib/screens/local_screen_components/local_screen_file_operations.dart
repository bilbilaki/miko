import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:swipe_image_gallery/swipe_image_gallery.dart';
import '../../models/fileexplorer/fs_entry_union.dart';
import '../../providers/local_provider.dart';
import '../../providers/zip_explorer_provider.dart';
import '../video_player_wplaylist_screen.dart';
import 'code_editor_dialog.dart';
import 'local_screen_dialogs.dart';
import 'zip_operation_dialogs.dart';

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


    showDialog(
      context: context,
      builder: (context) {
        return  CodeEditorDialog(
         filePath: documentFile.path, initialContent: initialContent, onSave: (String newContent)async { 
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
         onSaveAs: (String newContent)async  {                final String? newFileName = await LocalScreenDialogs.showInputDialog(
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
                    newContent,
                  );
                  if (success) {
                    showSnackBar('File saved as $newFileName successfully.');
                    Navigator.of(context).pop();
                  } else {
                    showSnackBar('Failed to save file as $newFileName.');
                  }
                }
         });
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

  /// Browse a zip file and enter zip exploration mode
  static Future<void> browseZipFile(
    BuildContext context,
    File zipFile,
    ZipExplorerProvider zipProvider,
    Function(String) showSnackBar,
  ) async {
    showSnackBar('Opening ZIP file...');
    
    final success = await zipProvider.enterZipMode(zipFile.path);
    
    if (success) {
      showSnackBar('ZIP file opened: ${p.basename(zipFile.path)}');
      // Note: Navigation to ZipExplorerView would be handled by the calling screen
    } else {
      showSnackBar('Failed to open ZIP file');
    }
  }

  /// Edit a file from within a zip archive
  static Future<void> editFileInZip(
    BuildContext context,
    String filePath,
    ZipExplorerProvider zipProvider,
    Function(String) showSnackBar,
  ) async {
              LocalProvider provider = LocalProvider();

    showSnackBar('Loading file from ZIP...');
    
    final content = await zipProvider.readFileFromZip(filePath);
    
    if (content == null) {
      showSnackBar('Failed to read file from ZIP');
      return;
    }

    await showDialog(
      context: context,
      builder: (context) => CodeEditorDialog(
        filePath: filePath,
        initialContent: content,
        onSave: (newContent) async {
          showSnackBar('Saving file to ZIP...');
          final success = await zipProvider.writeFileToZip(filePath, newContent);
          if (success) {
            showSnackBar('File saved to ZIP successfully');
          } else {
            showSnackBar('Failed to save file to ZIP');
          }
        }, onSaveAs: (String newContent )async {     final String? newFileName = await LocalScreenDialogs.showInputDialog(
                  context,
                  'Save As',
                  'Enter new file name (e.g., my_document.txt):',
                  p.basename(filePath),
                );
                if (newFileName != null && newFileName.isNotEmpty) {
                  final String newFilePath = p.join(
                    p.dirname(filePath),
                    newFileName,
                  );
                  final bool success = await provider.saveDocumentContentAs(
                    newFilePath,
                    newContent,
                  );
                  if (success) {
                    showSnackBar('File saved as $newFileName successfully.');
                    Navigator.of(context).pop();
                  } else {
                    showSnackBar('Failed to save file as $newFileName.');
                  }
                } },
      ),
    );
  }

  /// Handle extracting selected files from zip
  static Future<void> extractSelectedFromZip(
    BuildContext context,
    List<String> entryPaths,
    ZipExplorerProvider zipProvider,
    LocalProvider localProvider,
    Function(String) showSnackBar,
  ) async {
    await ZipOperationDialogs.showExtractSelectedDialog(
      context,
      entryPaths,
      zipProvider,
      localProvider,
      showSnackBar,
    );
  }

  /// Handle deleting entries from zip
  static Future<void> deleteFromZip(
    BuildContext context,
    List<String> entryPaths,
    ZipExplorerProvider zipProvider,
    Function(String) showSnackBar,
  ) async {
    final confirmed = await LocalScreenDialogs.showConfirmationDialog(
      context,
      'Delete from ZIP',
      'Are you sure you want to delete ${entryPaths.length} item(s) from the ZIP archive?',
    );
    
    if (confirmed == true) {
      showSnackBar('Deleting from ZIP...');
      
      final success = await zipProvider.removeFromZip(entryPaths);
      
      if (success) {
        showSnackBar('Successfully deleted ${entryPaths.length} item(s)');
      } else {
        showSnackBar('Failed to delete items from ZIP');
      }
    }
  }

  /// Handle renaming an entry in zip
  static Future<void> renameInZip(
    BuildContext context,
    String entryPath,
    ZipExplorerProvider zipProvider,
    Function(String) showSnackBar,
  ) async {
    final oldName = p.basename(entryPath);
    final String? newName = await LocalScreenDialogs.showInputDialog(
      context,
      'Rename Entry',
      'Enter new name for "$oldName":',
      oldName,
    );
    
    if (newName != null && newName.isNotEmpty && newName != oldName) {
      final newPath = p.join(p.dirname(entryPath), newName);
      
      showSnackBar('Renaming in ZIP...');
      
      final success = await zipProvider.renameInZip(entryPath, newPath);
      
      if (success) {
        showSnackBar('Entry renamed to "$newName"');
      } else {
        showSnackBar('Failed to rename entry');
      }
    }
  }

  // --- NAVIGATION LOGIC ---
static Future<void> handleEntryTap(
  BuildContext context,
  FsEntry entry,
  LocalProvider provider,
  Function(String) showSnackBar,
) async {
  final file = File(entry.path);
  // Reuse existing logic
  return handleFileTap(context, file, provider, showSnackBar);
}
static Future<void> renameEntry(
  BuildContext context,
  FsEntry entry,
  LocalProvider provider,
  Function(String) showSnackBar,
) async {
  final file = File(entry.path);
  return renameFile(context, file, provider, showSnackBar);
}

static Future<void> deleteEntry(
  BuildContext context,
  FsEntry entry,
  LocalProvider provider,
  Function(String) showSnackBar,
) async {
  final file = File(entry.path);
  return deleteFile(context, file, provider, showSnackBar);
}

static Future<void> copyEntry(
  BuildContext context,
  FsEntry entry,
  LocalProvider provider,
  String? currentFolderPath,
  Function(String) showSnackBar,
) async {
  final file = File(entry.path);
  return copyFile(context, file, provider, currentFolderPath, showSnackBar);
}

static Future<void> moveEntry(
  BuildContext context,
  FsEntry entry,
  LocalProvider provider,
  String? currentFolderPath,
  Function(String) showSnackBar,
) async {
  final file = File(entry.path);
  return moveFile(context, file, provider, currentFolderPath, showSnackBar);
}

// For opening/editing document content:
static Future<void> showEntryDocumentDialog(
  BuildContext context,
  FsEntry entry,
  LocalProvider provider,
  Function(String) showSnackBar,
) async {
  final file = File(entry.path);
  return showDocumentContentDialog(context, file, provider, showSnackBar);
}
  /// Displays a dialog for batch renaming files in the current directory

}