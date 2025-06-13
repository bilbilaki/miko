import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path/path.dart' as p; // Import the path package
/// A provider for managing and interacting with a user-selected external directory.
/// - Stores path with SharedPreferences
/// - Lists folders and movies in the directory
/// - Can set, edit, and refresh the path
/// - Allows creation of new folders, and saving files to the directory
/// - Notifies listeners on any change
/// - Designed for slider/image cache integration
class LocalProvider extends ChangeNotifier {
  static const _kExternalPathKey = 'external_directory_path';

  String? _externalPath;

  String? _currentPath; // Track the path currently listing
  List<Directory> _folders = [];
  List<File> _movies = [];

  String? get externalPath => _externalPath;

  List<Directory> get folders => List.unmodifiable(_folders);
  List<File> get movies => List.unmodifiable(_movies);

  /// The directory being currently listed (for subfolder navigation)
  String? get currentPath => _currentPath ?? _externalPath;


  final Map<String, Uint8List> _thumbnailCache = {};


  // ... (keep your existing loadPath, setPath, refresh, isMovieFile methods)
  

  /// Universal thumbnail generator that works on mobile and desktop.
  Future<Uint8List?> getThumbnail(String videoPath) async {
    if (_thumbnailCache.containsKey(videoPath)) {
      return _thumbnailCache[videoPath];
    }

    Uint8List? thumbnailData;

    try {
      if (Platform.isAndroid || Platform.isIOS) {
        // Use the plugin for mobile platforms
        thumbnailData = await VideoThumbnail.thumbnailData(
          video: videoPath,
          imageFormat: ImageFormat.JPEG,
          maxWidth: 200,
          quality: 50,
        );
      } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        // Use FFmpeg for desktop platforms
        thumbnailData = await _generateDesktopThumbnail(videoPath);
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error generating thumbnail for $videoPath: $e");
      }
    }

    if (thumbnailData != null) {
      _thumbnailCache[videoPath] = thumbnailData;
    }

    return thumbnailData;
  }

  /// Generates a thumbnail on Desktop using an external FFmpeg command.
  ///
  /// IMPORTANT: This requires the user to have FFmpeg installed and
  /// available in their system's PATH.
  Future<Uint8List?> _generateDesktopThumbnail(String videoPath) async {
    // Check if ffmpeg command exists first to avoid errors.
    // On Windows, 'where' is the equivalent of 'which' on Linux/macOS.
    final command = Platform.isWindows ? 'where' : 'which';
    final ffmpegCheck = await Process.run(command, ['ffmpeg']);

    if (ffmpegCheck.exitCode != 0) {
      if (kDebugMode) {
        print(
            "FFmpeg not found. Please install it and add it to your system's PATH.");
      }
      return null; // FFmpeg is not available
    }

    // Create a temporary path for the output thumbnail
    final tempDir = await Directory.systemTemp.createTemp('miko_thumbs');
    final thumbPath = p.join(tempDir.path, '${p.basename(videoPath)}.jpg');

    // The FFmpeg command:
    // -i: input file
    // -vframes 1: output only one frame
    // -an: disable audio
    // -ss 00:00:01: seek to the 1-second mark (avoids black frames at the start)
    // -y: overwrite output file if it exists
    final result = await Process.run('ffmpeg', [
      '-i',
      videoPath,
      '-vframes',
      '1',
      '-an',
      '-ss',
      '00:00:01',
      '-y',
      thumbPath,
    ]);

    if (result.exitCode == 0) {
      final file = File(thumbPath);
      if (await file.exists()) {
        final bytes = await file.readAsBytes();
        await tempDir.delete(recursive: true); // Clean up temp files
        return bytes;
      }
    } else {
      if (kDebugMode) {
        print(
            "FFmpeg failed with exit code ${result.exitCode}: ${result.stderr}");
      }
    }

    await tempDir.delete(recursive: true); // Clean up on failure too
    return null;
  }

  /// Load the stored path from SharedPreferences; call in init.
  Future<void> loadPath() async {
    final prefs = await SharedPreferences.getInstance();
    _externalPath = prefs.getString(_kExternalPathKey);
    await _refreshList(_externalPath);
    notifyListeners();
  }

  /// Set or edit the storage path and refresh contents.
  Future<void> setPath(String newPath) async {
    final prefs = await SharedPreferences.getInstance();
    _externalPath = newPath;
    await prefs.setString(_kExternalPathKey, newPath);
    await _refreshList(newPath);
    notifyListeners();
  }

  /// Remove the saved path.
  Future<void> clearPath() async {
    /// Public method to check if a file is a valid movie file.
    bool isMovieFile(File file) => isMovieFile(file);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kExternalPathKey);
    _externalPath = null;
    _folders = [];
    _movies = [];
    notifyListeners();
  }

  /// Scan directory and update folder/movie lists.
  Future<void> _refreshList(String? folder) async {
    _folders = [];
    _movies = [];

    // Determine the path to load: if not provided, use root (_externalPath)
    String? dirPath = folder ?? _externalPath;
    if (dirPath == null) return;

    _currentPath = dirPath;

    final dir = Directory(dirPath);
    if (await dir.exists()) {
      final entries = dir.listSync();
      _folders = entries.whereType<Directory>().toList();
      _movies = entries.whereType<File>().where(isMovieFile).toList();
    }
  }

  /// True if file extension is a common movie type.
  bool isMovieFile(File file) {
    final ext = file.path.split('.').last.toLowerCase();
    const videoExts = {'mp4', 'avi', 'mkv', 'mov', 'webm', 'flv'};
    return videoExts.contains(ext);
  }

  /// Manually refresh folder/movie list and notify listeners.
  Future<void> refresh(folder) async {
    await _refreshList(folder);
    notifyListeners();
  }

  /// Create a new folder under the current path.
  Future<bool> createFolder(String name) async {
    if (_externalPath == null) return false;
    final newDir = Directory('$_externalPath/$name');
    if (await newDir.exists()) return false;
    await newDir.create(recursive: true);
    await refresh(_externalPath);
    return true;
  }

  /// Save a file to the external directory.
  Future<bool> saveFile(File file, {String? filename}) async {
    if (_externalPath == null) return false;
    final name = filename ?? file.uri.pathSegments.last;
    final dest = File('$_externalPath/$name');
    if (await dest.exists()) return false;
    await file.copy(dest.path);
    await refresh(_externalPath);
    return true;
  }

  /// Stub: cache images/previews (for slider), to be implemented as needed.
  /// Example: Integrate with image_cache_service.dart
  Future<void> cachePreviewImages() async {
    // TODO: Implement image cache logic here
  }
}
