import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

import '../../models/fileexplorer/fs_entry.dart';
import '../../models/fileexplorer/fs_entry_union.dart';
import '../../providers/local_provider.dart';
import '../../providers/zip_explorer_provider.dart';
import 'local_screen_context_menus.dart';
import 'local_screen_file_operations.dart';
import 'local_screen_models.dart';

/// A screen component that displays the contents of a ZIP file
class ZipExplorerView extends StatelessWidget {
  final ZipExplorerProvider zipProvider;
  final LocalProvider localProvider;
  final Function(String) showSnackBar;
  final ViewMode viewMode;
  final double gridCrossAxisCount;

  const ZipExplorerView({
    super.key,
    required this.zipProvider,
    required this.localProvider,
    required this.showSnackBar,
    this.viewMode = ViewMode.grid,
    this.gridCrossAxisCount = 3.0,
  });

  @override
  Widget build(BuildContext context) {
    if (!zipProvider.isInZipMode || zipProvider.currentZipPath == null) {
      return const Center(
        child: Text('Not in ZIP exploration mode'),
      );
    }

    final entries = zipProvider.zipEntries;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(_getCurrentPathTitle()),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _handleBackPress(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add files to ZIP',
            onPressed: () => _handleAddFiles(context),
          ),
          IconButton(
            icon: const Icon(Icons.unarchive),
            tooltip: 'Extract all',
            onPressed: () => _handleExtractAll(context),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            tooltip: 'Close ZIP',
            onPressed: () => _handleClose(context),
          ),
        ],
      ),
      body: entries.isEmpty
          ? const Center(child: Text('Empty ZIP or folder'))
          : _buildEntriesList(context, entries),
    );
  }

  String _getCurrentPathTitle() {
    final zipName = p.basename(zipProvider.currentZipPath!);
    final currentPath = zipProvider.currentPathInZip;
    
    if (currentPath == null || currentPath.isEmpty) {
      return zipName;
    }
    
    return '${p.basename(currentPath)} (in $zipName)';
  }

  Widget _buildEntriesList(BuildContext context, List<FsEntry> entries) {
    if (viewMode == ViewMode.list) {
      return ListView.builder(
        itemCount: entries.length,
        itemBuilder: (context, index) {
          return _buildEntryTile(context, entries[index]);
        },
      );
    } else {
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: gridCrossAxisCount.toInt(),
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.8,
        ),
        padding: const EdgeInsets.all(8),
        itemCount: entries.length,
        itemBuilder: (context, index) {
          return _buildEntryCard(context, entries[index]);
        },
      );
    }
  }

  Widget _buildEntryTile(BuildContext context, FsEntry entry) {
    final kind = entry.kind;
    IconData icon;
    String subtitle;

    if (entry.isFolder) {
      icon = Icons.folder;
      subtitle = 'Folder';
    } else {
      switch (kind) {
        case FileKind.image:
          icon = Icons.image;
          break;
        case FileKind.video:
          icon = Icons.movie;
          break;
        case FileKind.audio:
          icon = Icons.audiotrack;
          break;
        case FileKind.document:
        case FileKind.markdown:
        case FileKind.json:
        case FileKind.csv:
          icon = Icons.description;
          break;
        default:
          icon = Icons.insert_drive_file;
      }
      final size = entry.sizeBytes;
      subtitle = size != null ? _formatSize(size) : kind.toString().split('.').last;
    }

    return ListTile(
      leading: Icon(icon, size: 40),
      title: Text(entry.name),
      subtitle: Text(subtitle),
      onTap: () => handleEntryTap(context, entry),
      onLongPress: () => showEntryContextMenu(context, entry),
    );
  }

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
  Widget _buildEntryCard(BuildContext context, FsEntry entry) {
    final kind = entry.kind;
    IconData icon;
    Color color;

    if (entry.isFolder) {
      icon = Icons.folder;
      color = Colors.amber;
    } else {
      switch (kind) {
        case FileKind.image:
          icon = Icons.image;
          color = Colors.green;
          break;
        case FileKind.video:
          icon = Icons.movie;
          color = Colors.purple;
          break;
        case FileKind.audio:
          icon = Icons.audiotrack;
          color = Colors.orange;
          break;
        case FileKind.document:
        case FileKind.markdown:
        case FileKind.json:
        case FileKind.csv:
          icon = Icons.description;
          color = Colors.blue;
          break;
        default:
          icon = Icons.insert_drive_file;
          color = Colors.grey;
      }
    }

    return Card(
      child: InkWell(
        onTap: () => handleEntryTap(context, entry),
        onLongPress: () => showEntryContextMenu(context, entry),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                entry.name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
  void handleEntryTap(BuildContext context, FsEntry entry) {
    if (entry.isFolder) {
      zipProvider.navigateIntoZipFolder(entry.path);
    } else if (entry.kind == FileKind.document ||
        entry.kind == FileKind.markdown ||
        entry.kind == FileKind.json ||
        entry.kind == FileKind.csv) {
      LocalScreenFileOperations.editFileInZip(
        context,
        entry.path,
        zipProvider,
        showSnackBar,
      );
    } else {
      showSnackBar('Preview not available for this file type');
    }
  }
  void showEntryContextMenu(BuildContext context, FsEntry entry) {
    final isDirectory = entry.isFolder;
    final entryPath = entry.path;
    
    LocalScreenContextMenus.showZipEntryContextMenu(
      context,
      entryPath,
      isDirectory,
      (path) => _handleExtractEntry(context, path),
      (path) => _handleDeleteEntry(context, path),
      (path) => LocalScreenFileOperations.renameInZip(
        context,
        path,
        zipProvider,
        showSnackBar,
      ),
      !isDirectory
          ? (path) => LocalScreenFileOperations.editFileInZip(
                context,
                path,
                zipProvider,
                showSnackBar,
              )
          : null,
    );
  }
  String _getEntryPath(FsEntry entry) => entry.path;
  void _handleBackPress(BuildContext context) {
    zipProvider.navigateUpInZip();
  }

  void _handleClose(BuildContext context) {
    zipProvider.exitZipMode();
    Navigator.of(context).pop();
  }

  void _handleAddFiles(BuildContext context) {
    // This would be handled by ZipOperationDialogs
    showSnackBar('Add files functionality not yet implemented');
  }

  void _handleExtractAll(BuildContext context) {
    LocalScreenFileOperations.extractSelectedFromZip(
      context,
      zipProvider.zipEntries.map((e) => _getEntryPath(e)).toList(),
      zipProvider,
      localProvider,
      showSnackBar,
    );
  }

  void _handleExtractEntry(BuildContext context, String entryPath) {
    LocalScreenFileOperations.extractSelectedFromZip(
      context,
      [entryPath],
      zipProvider,
      localProvider,
      showSnackBar,
    );
  }

  void _handleDeleteEntry(BuildContext context, String entryPath) {
    LocalScreenFileOperations.deleteFromZip(
      context,
      [entryPath],
      zipProvider,
      showSnackBar,
    );
  }
}
