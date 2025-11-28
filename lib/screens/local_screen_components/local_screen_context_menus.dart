import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import '../../models/fileexplorer/fs_entry_union.dart';
import '../../providers/local_provider.dart';

class LocalScreenContextMenus {
  /// Displays a bottom sheet context menu for a specific file
  static void showFileContextMenu(
    BuildContext context,
    File file,
    LocalProvider provider,
    Function(File) onRename,
    Function(File) onCopy,
    Function(File) onMove,
    Function(File) onDelete,
    Function(File)? onEditContent,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text(
                  p.basename(file.path),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(file.path),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Rename'),
                onTap: () {
                  Navigator.pop(context);
                  onRename(file);
                },
              ),
              ListTile(
                leading: const Icon(Icons.copy),
                title: const Text('Copy'),
                onTap: () {
                  Navigator.pop(context);
                  onCopy(file);
                },
              ),
              ListTile(
                leading: const Icon(Icons.drive_file_move),
                title: const Text('Move'),
                onTap: () {
                  Navigator.pop(context);
                  onMove(file);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Delete'),
                onTap: () {
                  Navigator.pop(context);
                  onDelete(file);
                },
              ),
              if (provider.isTextFile(file) && onEditContent != null)
                ListTile(
                  leading: const Icon(Icons.document_scanner),
                  title: const Text('Edit Content'),
                  onTap: () {
                    Navigator.pop(context);
                    onEditContent(file);
                  },
                ),
            ],
          ),
        );
      },
    );
  }

// File menu for FsEntry
static void showFileContextMenuForEntry(
  BuildContext context,
  FsEntry entry,
  LocalProvider provider,
  Function(FsEntry) onRename,
  Function(FsEntry) onCopy,
  Function(FsEntry) onMove,
  Function(FsEntry) onDelete,
  Function(FsEntry)? onEditContent,
) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text(
                entry.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(entry.path),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Rename'),
              onTap: () {
                Navigator.pop(context);
                onRename(entry);
              },
            ),
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text('Copy'),
              onTap: () {
                Navigator.pop(context);
                onCopy(entry);
              },
            ),
            ListTile(
              leading: const Icon(Icons.drive_file_move),
              title: const Text('Move'),
              onTap: () {
                Navigator.pop(context);
                onMove(entry);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete'),
              onTap: () {
                Navigator.pop(context);
                onDelete(entry);
              },
            ),
            if (provider.isTextFile(File(entry.path)) && onEditContent != null)
              ListTile(
                leading: const Icon(Icons.document_scanner),
                title: const Text('Edit Content'),
                onTap: () {
                  Navigator.pop(context);
                  onEditContent(entry);
                },
              ),
          ],
        ),
      );
    },
  );
}
  /// Displays a bottom sheet context menu for a specific folder
  static void showFolderContextMenu(
    BuildContext context,
    Directory folder,
    LocalProvider provider,
    Function(Directory) onRename,
    Function(Directory) onCopy,
    Function(Directory) onMove,
    Function(Directory) onDelete,
    Function(Directory) onCreateNew,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text(
                  p.basename(folder.path),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(folder.path),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Rename'),
                onTap: () {
                  Navigator.pop(context);
                  onRename(folder);
                },
              ),
              ListTile(
                leading: const Icon(Icons.copy),
                title: const Text('Copy'),
                onTap: () {
                  Navigator.pop(context);
                  onCopy(folder);
                },
              ),
              ListTile(
                leading: const Icon(Icons.drive_file_move),
                title: const Text('Move'),
                onTap: () {
                  Navigator.pop(context);
                  onMove(folder);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Delete'),
                onTap: () {
                  Navigator.pop(context);
                  onDelete(folder);
                },
              ),
              ListTile(
                leading: const Icon(Icons.create_new_folder),
                title: const Text('Create New Folder Here'),
                onTap: () {
                  Navigator.pop(context);
                  onCreateNew(folder);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// Displays a bottom sheet context menu for ZIP entries
  static void showZipEntryContextMenu(
    BuildContext context,
    String entryPath,
    bool isDirectory,
    Function(String) onExtract,
    Function(String) onDelete,
    Function(String) onRename,
    Function(String)? onEdit,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text(
                  p.basename(entryPath),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  isDirectory ? 'Folder' : 'File',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.unarchive),
                title: const Text('Extract'),
                onTap: () {
                  Navigator.pop(context);
                  onExtract(entryPath);
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Rename'),
                onTap: () {
                  Navigator.pop(context);
                  onRename(entryPath);
                },
              ),
              if (!isDirectory && onEdit != null)
                ListTile(
                  leading: const Icon(Icons.document_scanner),
                  title: const Text('Edit Content'),
                  onTap: () {
                    Navigator.pop(context);
                    onEdit(entryPath);
                  },
                ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Delete'),
                onTap: () {
                  Navigator.pop(context);
                  onDelete(entryPath);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
