import 'dart:io';
import 'package:file_magic_number/file_magic_number.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import '../../models/fileexplorer/fs_entry.dart';
import '../../models/fileexplorer/fs_entry_union.dart';
import '../../providers/local_provider.dart';
import 'lazy_thumbnail_widget.dart';

class LocalScreenItemBuilders {
  /// Builds a folder tile for grid view
  static Widget buildFolderTile(
    Directory folder,
    Function() onTap,
    Function() onLongPress,
  ) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.folder, color: Colors.amber, size: 80),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(
              p.basename(folder.path),
              style: const TextStyle(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  /// Generic file tile that displays a thumbnail/icon and filename
  static Widget buildFileTile(
    File file,
    LocalProvider provider,
    Function() onTap,
    Function() onLongPress,
  ) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(flex: 3, child: buildThumbnailOrIcon(file, provider)),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  p.basename(file.path),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget buildFolderTileFromEntry(
    FsEntry entry,
    VoidCallback onTap,
    VoidCallback onLongPress,
  ) {
    final folderName = entry.name;
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.folder, color: Colors.amber, size: 80),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(
              folderName,
              style: const TextStyle(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // File tile from FsEntry
  static Widget buildFileTileFromEntry(
    FsEntry entry,
    LocalProvider provider,
    VoidCallback onTap,
    VoidCallback onLongPress,
  ) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: _buildThumbnailOrIconFromEntry(entry, provider),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  entry.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildThumbnailOrIconFromEntry(
    FsEntry entry,
    LocalProvider provider,
  ) {
    // Use FileKind instead of provider.isX(file)
    IconData defaultIcon;
    Color iconColor;

    switch (entry.kind) {
      case FileKind.video:
        defaultIcon = Icons.movie;
        iconColor = Colors.red.shade400;
        break;
      case FileKind.image:
        defaultIcon = Icons.image;
        iconColor = Colors.blue.shade400;
        break;
      case FileKind.audio:
        defaultIcon = Icons.audio_file;
        iconColor = Colors.green.shade400;
        break;
      case FileKind.document:
      case FileKind.markdown:
      case FileKind.json:
      case FileKind.csv:
        defaultIcon = Icons.description;
        iconColor = Colors.grey.shade600;
        break;
      case FileKind.archive:
        defaultIcon = Icons.archive;
        iconColor = const Color.fromARGB(255, 233, 145, 63);
        break;
      case FileKind.unknown:
        defaultIcon = Icons.device_unknown_outlined;
        iconColor = const Color.fromARGB(255, 167, 212, 62);
        break;
      default:
        defaultIcon = Icons.insert_drive_file;
        iconColor = Colors.grey;
    }

    // Decide if we try thumbnails (same logic as before but using kind)
    final canGetThumbnail = {
      FileKind.video,
      FileKind.image,
      FileKind.audio,
      FileKind.document,
      FileKind.markdown,
      FileKind.json,
      FileKind.csv,
    }.contains(entry.kind);

    if (!canGetThumbnail) {
      return Container(
        color: Colors.grey[100],
        child: Center(child: Icon(defaultIcon, color: iconColor, size: 48)),
      );
    }

    // Use lazy loading widget to only load thumbnails when visible
    return CachedLazyThumbnail(
      key: ValueKey(entry.path),
      filePath: entry.path,
      provider: provider,
      defaultIcon: defaultIcon,
      iconColor: iconColor,
    );
  }

  /// Builds a folder list item for list view
  static Widget buildFolderListItem(
    Directory folder,
    Function() onTap,
    Function() onLongPress,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: ListTile(
        leading: const Icon(Icons.folder, color: Colors.amber, size: 40),
        title: Text(p.basename(folder.path)),
        subtitle: Text(
          "Modified: ${folder.statSync().modified.toLocal().toString().split('.')[0]}",
        ),
        onTap: onTap,
        onLongPress: onLongPress,
      ),
    );
  }

  /// Generic file list item
  static Widget buildFileListItem(
    File file,
    LocalProvider provider,
    Function() onTap,
    Function() onLongPress,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: ListTile(
        leading: SizedBox(
          width: 80,
          height: 50,
          child: buildThumbnailOrIcon(file, provider),
        ),
        title: Text(
          p.basename(file.path),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          "${(file.statSync().size / (1024 * 1024)).toStringAsFixed(2)} MB",
        ),
        onTap: onTap,
        onLongPress: onLongPress,
      ),
    );
  }

  /// Map of FileMagicNumberType to FileKind for type detection
  static final Map<FileMagicNumberType, FileKind> magicNumberToFileKind = {
    // Archives
    FileMagicNumberType.zip: FileKind.archive,
    FileMagicNumberType.rar: FileKind.archive,
    FileMagicNumberType.sevenZ: FileKind.archive,
    FileMagicNumberType.tar: FileKind.archive,
    // Images
    FileMagicNumberType.png: FileKind.image,
    FileMagicNumberType.jpg: FileKind.image,
    FileMagicNumberType.gif: FileKind.image,
    FileMagicNumberType.bmp: FileKind.image,
    FileMagicNumberType.tiff: FileKind.image,
    FileMagicNumberType.heic: FileKind.image,
    FileMagicNumberType.webp: FileKind.image,
    // Videos
    FileMagicNumberType.mp4: FileKind.video,
    FileMagicNumberType.avi: FileKind.video,
    // Audio
    FileMagicNumberType.mp3: FileKind.audio,
    FileMagicNumberType.wav: FileKind.audio,
    // Documents
    FileMagicNumberType.pdf: FileKind.document,
    FileMagicNumberType.sqlite: FileKind.document,
  };

  /// Detects FileKind from file magic number as a fallback for unknown files
  static Future<FileKind> detectFileKindFromMagicNumber(String filePath) async {
    try {
      final FileMagicNumberType fileType =
          await FileMagicNumber.detectFileTypeFromPathOrBlob(filePath);

      // Try to find the file kind from the magic number map
      final detectedKind = magicNumberToFileKind[fileType];
      if (detectedKind != null) {
        if (kDebugMode) {
          print(
            'Detected file kind from magic number: $detectedKind for $fileType',
          );
        }
        return detectedKind;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error detecting file type from magic number: $e');
      }
    }

    // Fallback to unknown if detection fails
    return FileKind.unknown;
  }

  /// Determines if a thumbnail should be generated or a default icon should be displayed
  static Widget buildThumbnailOrIcon(File file, LocalProvider provider) {
    IconData defaultIcon;
    Color iconColor;

    if (provider.isMovieFile(file)) {
      defaultIcon = Icons.movie;
      iconColor = Colors.red.shade400;
    } else if (provider.isImageFile(file)) {
      defaultIcon = Icons.image;
      iconColor = Colors.blue.shade400;
    } else if (provider.isAudioFile(file)) {
      defaultIcon = Icons.audio_file;
      iconColor = Colors.green.shade400;
    } else if (provider.isTextFile(file)) {
      defaultIcon = Icons.description;
      iconColor = Colors.grey.shade600;
    } else if (provider.isUnknownFile(file)) {
      // For unknown files, use FutureBuilder to detect type via magic number
      return _buildUnknownFileThumbnailWithDetection(file, provider);
    } else {
      defaultIcon = Icons.insert_drive_file;
      iconColor = Colors.grey;
    }

    bool canGetThumbnail =
        provider.isMovieFile(file) ||
        provider.isImageFile(file) ||
        provider.isAudioFile(file) ||
        provider.isTextFile(file);

    if (!canGetThumbnail) {
      return Container(
        color: Colors.grey[100],
        child: Center(child: Icon(defaultIcon, color: iconColor, size: 48)),
      );
    }

    // Use lazy loading widget to only load thumbnails when visible
    return CachedLazyThumbnail(
      key: ValueKey(file.path),
      filePath: file.path,
      provider: provider,
      defaultIcon: defaultIcon,
      iconColor: iconColor,
    );
  }

  /// Builds thumbnail or icon for unknown files by detecting via magic number
  static Widget _buildUnknownFileThumbnailWithDetection(
    File file,
    LocalProvider provider,
  ) {
    return FutureBuilder<FileKind>(
      future: detectFileKindFromMagicNumber(file.path),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            color: Colors.grey[100],
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 2.0),
            ),
          );
        }

        final detectedKind = snapshot.data ?? FileKind.unknown;

        // Get icon and color based on detected kind
        IconData icon;
        Color color;

        switch (detectedKind) {
          case FileKind.archive:
            icon = Icons.archive;
            color = const Color.fromARGB(255, 233, 145, 63);
            break;
          case FileKind.image:
            icon = Icons.image;
            color = Colors.blue.shade400;
            break;
          case FileKind.video:
            icon = Icons.movie;
            color = Colors.red.shade400;
            break;
          case FileKind.audio:
            icon = Icons.audio_file;
            color = Colors.green.shade400;
            break;
          case FileKind.document:
          case FileKind.markdown:
          case FileKind.json:
          case FileKind.csv:
            icon = Icons.description;
            color = Colors.grey.shade600;
            break;
          case FileKind.unknown:
          default:
            icon = Icons.device_unknown_outlined;
            color = const Color.fromARGB(255, 167, 212, 62);
        }

        // Try to get thumbnail if the detected kind supports it
        final supportsThumbnail = {
          FileKind.image,
          FileKind.video,
          FileKind.audio,
          FileKind.document,
          FileKind.markdown,
          FileKind.json,
          FileKind.csv,
        }.contains(detectedKind);

        if (supportsThumbnail) {
          // Use lazy loading widget for detected file types
          return CachedLazyThumbnail(
            key: ValueKey(file.path),
            filePath: file.path,
            provider: provider,
            defaultIcon: icon,
            iconColor: color,
          );
        }

        // No thumbnail support, just show icon
        return Container(
          color: Colors.grey[100],
          child: Center(child: Icon(icon, color: color, size: 48)),
        );
      },
    );
  }
}
