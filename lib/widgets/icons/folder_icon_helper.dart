import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

/// Helper class for rendering custom folder icons
/// Replace the placeholder Icon widgets with your SVG implementations
class FolderIconHelper {
  /// Returns an icon widget for a given folder type
  /// You can replace this with flutter_svg: SvgPicture.asset() when ready
  static Widget getIcon(String folderName, {double size = 18}) {
    final type = _getFolderType(folderName);
    return _getIconWidget(type, size);
  }

  /// Determine folder type based on name
  static FolderType _getFolderType(String folderName) {
    final name = folderName.toLowerCase();
    
    if (name.contains('music') || name.contains('audio')) {
      return FolderType.music;
    } else if (name.contains('picture') || name.contains('image') || 
               name.contains('photo')) {
      return FolderType.images;
    } else if (name.contains('video') || name.contains('movie')) {
      return FolderType.videos;
    } else if (name.contains('document') || name.contains('doc')) {
      return FolderType.documents;
    } else if (name.contains('download')) {
      return FolderType.downloads;
    } else if (name.contains('desktop')) {
      return FolderType.desktop;
    } else if (name.contains('work') || name.contains('project')) {
      return FolderType.work;
    } else {
      return FolderType.generic;
    }
  }

  /// Get icon widget based on folder type
  static Widget _getIconWidget(FolderType type, double size) {
    String assetPath;
    IconData fallbackIcon;
    Color fallbackColor;

    switch (type) {
      case FolderType.music:
        assetPath = 'assets/icons/folder_music.svg';
        fallbackIcon = Icons.music_note;
        fallbackColor = Colors.purple;
        break;
      case FolderType.images:
        assetPath = 'assets/icons/folder_images.svg';
        fallbackIcon = Icons.image;
        fallbackColor = Colors.blue;
        break;
      case FolderType.videos:
        assetPath = 'assets/icons/folder_videos.svg';
        fallbackIcon = Icons.video_library;
        fallbackColor = Colors.red;
        break;
      case FolderType.documents:
        assetPath = 'assets/icons/folder_documents.svg';
        fallbackIcon = Icons.description;
        fallbackColor = Colors.orange;
        break;
      case FolderType.downloads:
        assetPath = 'assets/icons/folder_downloads.svg';
        fallbackIcon = Icons.download;
        fallbackColor = Colors.green;
        break;
      case FolderType.desktop:
        assetPath = 'assets/icons/folder_desktop.svg';
        fallbackIcon = Icons.computer;
        fallbackColor = Colors.teal;
        break;
      case FolderType.work:
        assetPath = 'assets/icons/folder_work.svg';
        fallbackIcon = Icons.work;
        fallbackColor = Colors.indigo;
        break;
      case FolderType.generic:
        assetPath = 'assets/icons/folder_generic.svg';
        fallbackIcon = Icons.folder;
        fallbackColor = Colors.amber;
        break;
    }

    // Try to load SVG with error handling
    // Note: SVG files contain embedded PNG images which may not render properly
    // Using errorBuilder to show Material Icons if SVG fails to load
    return SvgPicture.asset(
      assetPath,
      width: size,
      height: size,
      placeholderBuilder: (context) => Icon(
        fallbackIcon,
        size: size,
        color: fallbackColor,
      ),
      // Show fallback icon if SVG fails to load
      // ignore: deprecated_member_use
      errorBuilder: (context, error, stackTrace) => Icon(
        fallbackIcon,
        size: size,
        color: fallbackColor,
      ),
      fit: BoxFit.contain,
    );
  }

  /// Get color for folder type (useful for other UI elements)
  static Color getColor(String folderName) {
    final type = _getFolderType(folderName);
    switch (type) {
      case FolderType.music:
        return Colors.purple;
      case FolderType.images:
        return Colors.blue;
      case FolderType.videos:
        return Colors.red;
      case FolderType.documents:
        return Colors.orange;
      case FolderType.downloads:
        return Colors.green;
      case FolderType.desktop:
        return Colors.teal;
      case FolderType.work:
        return Colors.indigo;
      case FolderType.generic:
        return Colors.amber;
    }
  }
}

/// Enum for folder types
enum FolderType {
  music,
  images,
  videos,
  documents,
  downloads,
  desktop,
  work,
  generic,
}

/// Extension to get SVG asset path (for when you're ready to use SVGs)
extension FolderTypeExtension on FolderType {
  String get svgAssetPath {
    switch (this) {
      case FolderType.music:
        return 'assets/icons/folder_music.svg';
      case FolderType.images:
        return 'assets/icons/folder_images.svg';
      case FolderType.videos:
        return 'assets/icons/folder_videos.svg';
      case FolderType.documents:
        return 'assets/icons/folder_documents.svg';
      case FolderType.downloads:
        return 'assets/icons/folder_downloads.svg';
      case FolderType.desktop:
        return 'assets/icons/folder_desktop.svg';
      case FolderType.work:
        return 'assets/icons/folder_work.svg';
      case FolderType.generic:
        return 'assets/icons/folder_generic.svg';
    }
  }
}
