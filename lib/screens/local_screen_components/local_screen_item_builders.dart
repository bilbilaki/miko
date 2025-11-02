import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import '../../providers/local_provider.dart';

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
            Expanded(
              flex: 3,
              child: buildThumbnailOrIcon(file, provider),
            ),
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

    return FutureBuilder<Uint8List?>(
      future: provider.getThumbnail(file.path),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(strokeWidth: 2.0),
          );
        }
        if (snapshot.hasData && snapshot.data != null) {
          return Image.memory(
            snapshot.data!,
            fit: BoxFit.cover,
            gaplessPlayback: true,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[100],
                child: Center(
                  child: Icon(defaultIcon, color: iconColor, size: 48),
                ),
              );
            },
          );
        }
        return Container(
          color: Colors.grey[100],
          child: Center(child: Icon(defaultIcon, color: iconColor, size: 48)),
        );
      },
    );
  }
}
