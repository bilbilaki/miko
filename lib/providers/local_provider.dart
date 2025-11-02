import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path/path.dart' as p;

import 'package:pool/pool.dart'; // FIX: Import the pool package

/// A provider for managing and interacting with a user-selected external directory.
/// - Stores path with SharedPreferences
/// - Lists folders and movies in the directory
/// - Can set, edit, and refresh the path
/// - Allows creation of new folders, and saving files to the directory
/// - Notifies listeners on any change
/// - Designed for slider/image cache integration
class LocalProvider extends ChangeNotifier {
  static const _kExternalPathKey = 'external_directory_path';
  static const _kThumbnailCacheMapKey =
      'thumbnail_cache_map'; // New key for thumbnail paths map

  String? _basePath;
  bool isSmb=false;
  String? _currentPath; // Track the path currently listing
  List<Directory> _folders = [];
  List<File> _movies = [];
  List<File> _audios = [];
  List<File> _documents = []; // New list for documents/text files
  List<File> _images = []; // New list for image files

  String? get externalPath => _basePath;
  bool? get _isSmb => isSmb; 
  List<Directory> get folders => List.unmodifiable(_folders);
  List<File> get movies => List.unmodifiable(_movies);
  List<File> get audios => List.unmodifiable(_audios);
  List<File> get documents =>
      List.unmodifiable(_documents); // Getter for documents
  List<File> get images => List.unmodifiable(_images); // Getter for images

  /// The directory being currently listed (for subfolder navigation)
  String? get currentPath => _currentPath ?? _basePath;

  // In-memory cache for thumbnails (Uint8List)
  final Map<String, Uint8List> _thumbnailCache = {};
  // Persistent map for videoPath -> cachedThumbnailFilePath
  late SharedPreferences _prefs; // Initialized in _initPrefsAndCacheDir
  Map<String, String> _persistedThumbnailPaths = {};
  String?
  _thumbnailCacheDirPath; // Path to the app's dedicated thumbnail cache directory

  bool _ffmpegChecked = false; // Flag to check ffmpeg existence only once

  // FIX: Create a Pool to limit concurrent video thumbnail generation.
  // The number (e.g., 3) is the maximum number of simultaneous jobs.
  // Adjust this value based on testing for your target devices.
  final Pool _videoThumbnailPool = Pool(3);

  // Constructor to ensure prefs and cache dir are initialized early
  LocalProvider() {
    _initPrefsAndCacheDir();
  }

  /// Initializes SharedPreferences and sets up the persistent thumbnail cache directory.
  Future<void> _initPrefsAndCacheDir() async {
    _prefs = await SharedPreferences.getInstance();
    // Load persisted thumbnail paths map from SharedPreferences
    final cachedMapJson = _prefs.getString(_kThumbnailCacheMapKey);
    if (cachedMapJson != null) {
      try {
        _persistedThumbnailPaths = Map<String, String>.from(
          jsonDecode(cachedMapJson),
        );
      } catch (e) {
        if (kDebugMode) print("Error decoding persisted thumbnail map: $e");
        _persistedThumbnailPaths = {}; // Clear on error or corrupt data
      }
    }

    // Get application support directory for persistent thumbnail cache
    try {
      final appSupportDir = await getApplicationSupportDirectory();
      _thumbnailCacheDirPath = p.join(
        appSupportDir.path,
        'miko_thumbnails_cache',
      );
      final dir = Directory(_thumbnailCacheDirPath!);
      if (!await dir.exists()) {
        await dir.create(
          recursive: true,
        ); // Create directory and any necessary parent directories
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error getting app support directory for thumbnails: $e");
      }
      _thumbnailCacheDirPath = null; // Fallback if directory can't be created
    }
  }

  /// Universal thumbnail generator that works on mobile and desktop.
  /// It now uses a persistent disk cache and a SharedPreferences map for lookup.
  Future<Uint8List?> getThumbnail(String mediaPath) async {
    // 1. Check in-memory cache first for immediate access
    if (_thumbnailCache.containsKey(mediaPath)) {
      return _thumbnailCache[mediaPath];
    }

    // 2. Check persistent disk cache mapping
    if (_persistedThumbnailPaths.containsKey(mediaPath)) {
      final cachedThumbPath = _persistedThumbnailPaths[mediaPath];
      if (cachedThumbPath != null && await File(cachedThumbPath).exists()) {
        try {
          final bytes = await File(cachedThumbPath).readAsBytes();
          _thumbnailCache[mediaPath] =
              bytes; // Add to in-memory cache for future quick access
          return bytes;
        } catch (e) {
          if (kDebugMode) {
            print("Error reading cached thumbnail file $cachedThumbPath: $e");
          }
          // If corrupted or unreadable, remove mapping and attempt to regenerate
          _persistedThumbnailPaths.remove(mediaPath);
          await _savePersistedThumbnailPaths();
        }
      } else {
        // If the file mapped in Shared Prefs doesn't exist anymore, remove the mapping
        _persistedThumbnailPaths.remove(mediaPath);
        await _savePersistedThumbnailPaths();
      }
    }

    // 3. Generate thumbnail if not found in any cache
    Uint8List? thumbnailData;

    try {
      if (isMovieFile(File(mediaPath))) {
        // FIX: Use the pool to limit concurrent video thumbnail jobs
        thumbnailData = await _videoThumbnailPool.withResource(() async {
          if (Platform.isAndroid || Platform.isIOS) {
            return await VideoThumbnail.thumbnailData(
              video: mediaPath,
              imageFormat: ImageFormat.JPEG,
              maxWidth: 500,
              quality: 95,
            );
          } else if (Platform.isWindows ||
              Platform.isLinux ||
              Platform.isMacOS) {
            return await _getDesktopVideoThumbnail(mediaPath);
          }
          return null;
        });
      } else if (isImageFile(File(mediaPath))) {
        // Image thumbnail/preview
        thumbnailData = await File(mediaPath).readAsBytes();
        // For better performance, consider resizing large images here using
        // a package like `image` or `flutter_image_compress`.
      } else if (isAudioFile(File(mediaPath))) {
        // FIX: Correctly generate and use the thumbnail for audio files.
      } else if (isTextFile(File(mediaPath))) {
        // FIX: Correctly generate and use the thumbnail for document/text files.
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error generating thumbnail for $mediaPath: $e");
      }
      return null;
    }

    // 4. If thumbnail successfully generated, save it to persistent disk cache and update maps
    // FIX: Changed || to && for correct logic. We need both data AND a path to save.
    if (thumbnailData != null && _thumbnailCacheDirPath != null) {
      final fileName = '${base64Url.encode(utf8.encode(mediaPath))}.jpg';
      final generatedThumbFilePath = p.join(_thumbnailCacheDirPath!, fileName);
      try {
        await File(generatedThumbFilePath).writeAsBytes(thumbnailData);
        _persistedThumbnailPaths[mediaPath] = generatedThumbFilePath;
        await _savePersistedThumbnailPaths(); // Persist the mapping
      } catch (e) {
        if (kDebugMode) {
          print("Error saving thumbnail to disk $generatedThumbFilePath: $e");
        }
      }
    }

    if (thumbnailData != null) {
      _thumbnailCache[mediaPath] =
          thumbnailData; // Add to in-memory cache for this session
    }

    return thumbnailData;
  }

  /// Saves the current map of persisted thumbnail paths to SharedPreferences.
  Future<void> _savePersistedThumbnailPaths() async {
    try {
      final jsonString = jsonEncode(_persistedThumbnailPaths);
      await _prefs.setString(_kThumbnailCacheMapKey, jsonString);
    } catch (e) {
      if (kDebugMode) {
        print("Error saving persisted thumbnail map to SharedPreferences: $e");
      }
    }
  }

  /// Clears the persistent thumbnail cache (files and SharedPreferences entries) and in-memory cache.
  Future<bool> clearAllThumbnailsCache() async {
    try {
      if (_thumbnailCacheDirPath != null) {
        final cacheDir = Directory(_thumbnailCacheDirPath!);
        if (await cacheDir.exists()) {
          await cacheDir.delete(
            recursive: true,
          ); // Delete all files and subdirectories
          // Recreate the directory for future use
          await cacheDir.create(recursive: true);
        }
      }
      _persistedThumbnailPaths.clear(); // Clear the map in memory
      _thumbnailCache.clear(); // Clear the in-memory cache
      await _savePersistedThumbnailPaths(); // Save empty map to SharedPreferences
      if (kDebugMode) print("Thumbnail cache cleared successfully.");
      return true;
    } catch (e) {
      if (kDebugMode) print("Error clearing thumbnail cache: $e");
      return false;
    }
  }

  /// Generates a thumbnail on Desktop using an external FFmpeg command.
  /// Checks FFmpeg's existence once per app run.
  Future<Uint8List?> _getDesktopVideoThumbnail(String videoPath) async {
    if (!_ffmpegChecked) {
      // Check if ffmpeg command exists only once to avoid repeated system calls
      final command = Platform.isWindows ? 'where' : 'which';
      try {
        final ffmpegCheck = await Process.run(command, ['ffmpeg']);
        if (ffmpegCheck.exitCode != 0) {
          if (kDebugMode) {
            print(
              "FFmpeg not found. Please install it and add it to your system's PATH.",
            );
          }
          _ffmpegChecked = true; // Mark as checked, but ffmpeg not found.
          return null;
        }
      } catch (e) {
        if (kDebugMode) print("Error running FFmpeg check command: $e");
        _ffmpegChecked =
            true; // Mark as checked, an error occurred during check.
        return null;
      }
      _ffmpegChecked = true; // FFmpeg found (or check completed successfully).
    }

    final tempDir = await getTemporaryDirectory();
    final tempThumbOutput = p.join(
      tempDir.path,
      '${p.basenameWithoutExtension(videoPath)}_temp_thumb.jpg',
    );

    final result = await Process.run('ffmpeg', [
      '-i',
      videoPath,
      '-vframes',
      '1',
      '-an',
      '-ss',
      '00:00:08',
      '-y', // FIX: Use -y to overwrite temporary file instead of -n
      tempThumbOutput,
    ]);

    if (result.exitCode == 0) {
      final file = File(tempThumbOutput);
      if (await file.exists()) {
        final bytes = await file.readAsBytes();
        await file.delete(); // Clean up this temporary file after reading bytes
        return bytes;
      }
    } else {
      if (kDebugMode) {
        print(
          "FFmpeg failed with exit code ${result.exitCode}: ${result.stderr}",
        );
      }
    }

    final tempFile = File(tempThumbOutput);
    if (await tempFile.exists()) {
      await tempFile.delete();
    }
    return null;
  }

  // ... (The rest of your code remains the same as it was already correct)
  // --- PASTE THE REST OF YOUR CLASS FROM loadPath() ONWARDS HERE ---
  /// Load the stored path from SharedPreferences; call in init or app startup.
  Future<void> loadPath() async {
    await _initPrefsAndCacheDir(); // Ensure prefs and cache dir are ready
    _basePath = _prefs.getString(_kExternalPathKey);
    await _refreshList(_basePath);
    notifyListeners();
  }

  /// Set or edit the storage path and refresh contents.
  Future<void> setPath(String newPath) async {
    await _initPrefsAndCacheDir(); // Ensure prefs and cache dir are ready
    _basePath = newPath;
    await _prefs.setString(_kExternalPathKey, newPath);
    await _refreshList(newPath);
    notifyListeners();
  }

  // Add this method to your LocalProvider class
  Future andprims() async {
    if (Platform.isAndroid) {
      var status = await Permission.manageExternalStorage.status;
      if (!status.isGranted) {
        // This will open the system settings page for your app.
        // The user needs to manually grant the permission.
        await Permission.manageExternalStorage.request();
      }
      // After the user returns from settings, check the status again.
      return await Permission.manageExternalStorage.status.isGranted;
    }
    return true;
  }

  /// Checks if a path is stored; if not, sets a default OS-specific home directory.
  Future<void> setDefaultPathIfNoneSet() async {
    // Only run if no path has ever been set by the user
    if (_basePath == null) {
      Directory? defaultDir;
      try {
        if (Platform.isAndroid) {
          final what = await andprims();
          if (what == true) {
            // On Android, this is /storage/emulated/0
            defaultDir = Directory("/storage/0/emulated/");
          }
        } else if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
          // On Desktop, this is the user's home folder
          defaultDir = await getExternalStorageDirectory();
        }
      } catch (e) {
        if (kDebugMode) {
          print("Error getting default directory: $e");
        }
      }

      if (defaultDir != null) {
        // Use your existing setPath method to initialize the app state
        await setPath(defaultDir.path);
      }
    }
  }

  /// Remove the saved path.
  Future<void> clearPath() async {
    await _initPrefsAndCacheDir();
    await _prefs.remove(_kExternalPathKey);
    _basePath = null;
    _folders = [];
    _movies = [];
    _audios = [];
    _documents = [];
    _images = [];
    notifyListeners();
  }

  /// Scan directory and update folder/file lists.
  Future<void> _refreshList(String? folder) async {
    _folders = [];
    _movies = [];
    _audios = [];
    _images = [];
    _documents = []; // Clear previous lists

    // Determine the path to load: if not provided, use root (_basePath)
    String? dirPath = folder ?? _basePath;
    if (dirPath == null) return;

    _currentPath = dirPath;

    final dir = Directory(dirPath);
    if (await dir.exists()) {
      try {
        final entries = dir.listSync();
        _folders = entries.whereType<Directory>().toList();

        // Categorize files based on their type
        final allFiles = entries.whereType<File>().toList();
        for (var file in allFiles) {
          if (isMovieFile(file)) {
            _movies.add(file);
          } else if (isAudioFile(file)) {
            _audios.add(file);
          } else if (isImageFile(file)) {
            _images.add(file);
          } else if (isTextFile(file)) {
            _documents.add(file); // Include general text/document files
          }
        }
      } catch (e) {
        if (kDebugMode) print("Error listing directory $dirPath: $e");
      }
    }
  }

  /// True if file extension is a common movie type.
  bool isMovieFile(File file) {
    final ext = p.extension(file.path).toLowerCase();
    const videoExts = {'.mp4', '.avi', '.mkv', '.mov', '.webm', '.flv', '.wmv'};
    return videoExts.contains(ext);
  }

  /// True if file extension is a common audio type.
  bool isAudioFile(File file) {
    final ext = p.extension(file.path).toLowerCase();
    const audioExts = {
      '.mp3',
      '.m4a',
      '.flac',
      '.wav',
      '.aac',
      '.ogg',
      '.wma',
      '.aiff',
    };
    return audioExts.contains(ext);
  }

  /// True if file extension is a common image type.
  bool isImageFile(File file) {
    final ext = p.extension(file.path).toLowerCase();
    const imageExts = {
      '.jpg',
      '.jpeg',
      '.png',
      '.gif',
      '.bmp',
      '.webp',
      '.ico',
      '.svg',
    };
    return imageExts.contains(ext);
  }

  /// True if file extension suggests it's a text-based or common document file.
  /// (Doesn't guarantee parseability for complex binary formats like .docx, .pdf)
  bool isTextFile(File file) {
    final ext = p.extension(file.path).toLowerCase();
    // Common text file extensions. Expand as needed.
    const textExts = {
      '.txt', '.md', '.json', '.xml', '.yaml', '.yml', '.csv', '.log',
      '.html', '.htm', '.css', '.js', '.dart', '.java', '.py', '.c', '.cpp',
      '.h', '.hpp',
      // Document types (true parsing requires external libraries)
      '.pdf', '.docx', '.xlsx', '.pptx', '.odt', '.rtf',
    };
    // Exclude if it's already identified as a specific multimedia type
    if (isMovieFile(file) || isAudioFile(file) || isImageFile(file)) {
      return false;
    }
    return textExts.contains(ext);
  }

  /// Manually refresh folder/file list and notify listeners.
  /// `folder` parameter allows refreshing a specific subfolder,
  /// otherwise it refreshes the current path.
  Future<void> refresh(String? folder) async {
    await _refreshList(folder ?? _currentPath);
    notifyListeners();
  }

  /// Create a new folder under the current path.
  Future<bool> createFolder(String name) async {
    if (_isSmb==true){
      
    }
    if (_currentPath == null) return false;
    final newDir = Directory(p.join(_currentPath!, name));
    if (await newDir.exists()) {
      return false; // Prevent recreating existing folder
    }
    try {
      await newDir.create(recursive: true);
      await refresh(_currentPath);
      return true;
    } catch (e) {
      if (kDebugMode) print("Error creating folder $name: $e");
      return false;
    }
  }

  /// Delete a folder by its full path. Automatically refreshes the parent directory.
  Future<bool> deleteFolder(String folderPath) async {
    final dirToDelete = Directory(folderPath);
    if (!await dirToDelete.exists()) {
      if (kDebugMode) print("Folder not found: $folderPath");
      return false;
    }
    try {
      await dirToDelete.delete(
        recursive: true,
      ); // Delete folder and all its contents
      await refresh(p.dirname(folderPath)); // Refresh the parent directory
      return true;
    } catch (e) {
      if (kDebugMode) print("Error deleting folder $folderPath: $e");
      return false;
    }
  }

  /// Save a file to the external directory or current path.
  /// `filename` is optional, defaults to the source file's name.
  Future<bool> saveFile(File sourceFile, {String? filename}) async {
    if (_currentPath == null) return false;
    final name = filename ?? p.basename(sourceFile.path);
    final dest = File(p.join(_currentPath!, name));
    if (await dest.exists()) return false; // Prevent overwriting by default
    try {
      await sourceFile.copy(dest.path);
      await refresh(_currentPath);
      return true;
    } catch (e) {
      if (kDebugMode) {
        print("Error saving file ${sourceFile.path} to ${dest.path}: $e");
      }
      return false;
    }
  }

  // --- Start of New Tasks Implementation ---

  /// 1. Rename a single file.
  /// `oldFilePath`: The full path to the file to be renamed.
  /// `newFileName`: The new name for the file (e.g., 'new_video.mp4').
  Future<bool> renameFile(String oldFilePath, String newFileName) async {
    try {
      final oldFile = File(oldFilePath);
      if (!await oldFile.exists()) {
        if (kDebugMode) print("File not found: $oldFilePath");
        return false;
      }
      // Construct the new path in the same directory as the old file
      final newFilePath = p.join(p.dirname(oldFilePath), newFileName);
      final newFile = File(newFilePath);
      // Prevent renaming if a file with the new name already exists and it's not the same file
      if (await newFile.exists() && oldFilePath != newFilePath) {
        if (kDebugMode) {
          print("File with new name already exists: $newFilePath");
        }
        return false;
      }

      await oldFile.rename(newFilePath);
      await refresh(
        p.dirname(oldFilePath),
      ); // Refresh the directory where the file was renamed
      return true;
    } catch (e) {
      if (kDebugMode) {
        print("Error renaming file $oldFilePath to $newFileName: $e");
      }
      return false;
    }
  }

  /// 2. Rename files in a given path based on prefix, postfix, and index.
  /// `directoryPath`: The path containing the files to be renamed.
  /// `prefix`: Optional prefix for the new file names (can be null).
  /// `postfix`: Optional postfix for the new file names (can be null).
  /// New filename format: `$prefix$indexoffilesnumber$postfix.$extenstion_of_files`
  Future<bool> renameFilesInPath(
    String directoryPath, {
    String? prefix,
    String? postfix,
  }) async {
    final targetDir = Directory(directoryPath);
    if (!await targetDir.exists()) {
      if (kDebugMode) print("Directory not found: $directoryPath");
      return false;
    }

    try {
      final files = await targetDir.list().toList();
      files.sort(
        (a, b) => p.basename(a.path).compareTo(p.basename(b.path)),
      ); // Sort for consistent indexing

      for (int i = 0; i < files.length; i++) {
        final file = files[i];
        final ext = p.extension(file.path); // Get original extension
        final newFileName =
            '${prefix ?? ''}${i + 1}${postfix ?? ''}$ext'; // index starts from 1
        final newFilePath = p.join(directoryPath, newFileName);

        // Only rename if the new path is different from the old path
        // and if a file with the new name does not already exist at the target.
        if (file.path != newFilePath) {
          if (await File(newFilePath).exists()) {
            if (kDebugMode) {
              print(
                "Skipping rename for ${file.path}: target file $newFilePath already exists.",
              );
            }
            continue; // Skip this file to prevent accidental overwrite
          }
          await file.rename(newFilePath);
        }
      }
      await refresh(directoryPath); // Refresh the directory to reflect changes
      return true;
    } catch (e) {
      if (kDebugMode) print("Error renaming files in path $directoryPath: $e");
      return false;
    }
  }

  /// 3. Delete a file.
  /// `filePath`: The full path to the file to be deleted.
  Future<bool> deleteFile(String filePath) async {
    try {
      final fileToDelete = File(filePath);
      if (!await fileToDelete.exists()) {
        if (kDebugMode) print("File not found: $filePath");
        return false;
      }
      await fileToDelete.delete();
      await refresh(
        p.dirname(filePath),
      ); // Refresh the directory where the file was deleted
      return true;
    } catch (e) {
      if (kDebugMode) print("Error deleting file $filePath: $e");
      return false;
    }
  }

  /// 4. Copy a file.
  /// `sourceFilePath`: The full path of the file to copy.
  /// `destinationFilePath`: The full path including the new filename for the copied file.
  Future<bool> copyFile(
    String sourceFilePath,
    String destinationFilePath,
  ) async {
    try {
      final sourceFile = File(sourceFilePath);
      if (!await sourceFile.exists()) {
        if (kDebugMode) print("Source file not found: $sourceFilePath");
        return false;
      }
      //   final destinationFile = File(destinationFilePath);
      // Create destination directory if it doesn't exist
      final destDir = Directory(p.dirname(destinationFilePath));
      if (!await destDir.exists()) {
        await destDir.create(recursive: true);
      }
      await sourceFile.copy(destinationFilePath);
      await refresh(
        p.dirname(destinationFilePath),
      ); // Refresh both origin and destination if they are different current path, otherwise just current. Simplification here: refresh destination.
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(
          "Error copying file from $sourceFilePath to $destinationFilePath: $e",
        );
      }
      return false;
    }
  }

  /// 4. Copy a directory recursively.
  /// `sourceDirPath`: The full path of the directory to copy.
  /// `destinationDirPath`: The full path where the directory should be copied to.
  Future<bool> copyDirectory(
    String sourceDirPath,
    String destinationDirPath,
  ) async {
    final sourceDir = Directory(sourceDirPath);
    if (!await sourceDir.exists()) {
      if (kDebugMode) print("Source directory not found: $sourceDirPath");
      return false;
    }

    final destinationDir = Directory(destinationDirPath);
    try {
      if (!await destinationDir.exists()) {
        await destinationDir.create(recursive: true);
      }

      await for (var entity in sourceDir.list(recursive: false)) {
        final newPath = p.join(destinationDirPath, p.basename(entity.path));
        if (entity is File) {
          await entity.copy(newPath);
        } else if (entity is Directory) {
          await copyDirectory(
            entity.path,
            newPath,
          ); // Recursive call for subdirectories
        }
      }
      await refresh(
        p.dirname(destinationDirPath),
      ); // Refresh the parent of the new directory
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(
          "Error copying directory from $sourceDirPath to $destinationDirPath: $e",
        );
      }
      return false;
    }
  }

  /// 5. Move a file.
  /// `sourceFilePath`: The full path of the file to move.
  /// `destinationFilePath`: The full path including the new filename for the moved file.
  Future<bool> moveFile(
    String sourceFilePath,
    String destinationFilePath,
  ) async {
    try {
      final sourceFile = File(sourceFilePath);
      if (!await sourceFile.exists()) {
        if (kDebugMode) print("Source file not found: $sourceFilePath");
        return false;
      }

      //   final destinationFile = File(destinationFilePath);
      // Create destination directory if it doesn't exist
      final destDir = Directory(p.dirname(destinationFilePath));
      if (!await destDir.exists()) {
        await destDir.create(recursive: true);
      }

      await sourceFile.rename(
        destinationFilePath,
      ); // File.rename can move across directories if on the same file system.
      await refresh(p.dirname(sourceFilePath)); // Refresh original folder
      if (p.dirname(sourceFilePath) != p.dirname(destinationFilePath)) {
        await refresh(
          p.dirname(destinationFilePath),
        ); // Refresh destination folder if different
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(
          "Error moving file from $sourceFilePath to $destinationFilePath: $e",
        );
      }
      // Fallback for cross-volume move if rename fails (e.g., `FileSystemException` with EXDEV error).
      // This is generally more expensive as it involves copying all data.
      if (e is FileSystemException && (e.osError?.errorCode == 18)) {
        // macOS/Linux EXDEV, Windows might have a different code for cross-drive.
        if (kDebugMode) {
          print(
            "File rename failed (potential cross-volume move). Attempting copy+delete.",
          );
        }
        if (await copyFile(sourceFilePath, destinationFilePath)) {
          return await deleteFile(
            sourceFilePath,
          ); // If copy succeeds, delete original
        }
      }
      return false;
    }
  }

  /// 5. Move a directory.
  /// `sourceDirPath`: The full path of the directory to move.
  /// `destinationDirPath`: The full path where the directory should be moved to.
  Future<bool> moveDirectory(
    String sourceDirPath,
    String destinationDirPath,
  ) async {
    try {
      final sourceDir = Directory(sourceDirPath);
      if (!await sourceDir.exists()) {
        if (kDebugMode) print("Source directory not found: $sourceDirPath");
        return false;
      }

      //   final destinationDir = Directory(destinationDirPath);
      // Create parent directory for destination if it doesn't exist
      final destParentDir = Directory(p.dirname(destinationDirPath));
      if (!await destParentDir.exists()) {
        await destParentDir.create(recursive: true);
      }

      await sourceDir.rename(destinationDirPath); // Directory.rename moves it
      await refresh(p.dirname(sourceDirPath)); // Refresh original folder
      if (p.dirname(sourceDirPath) != p.dirname(destinationDirPath)) {
        await refresh(
          p.dirname(destinationDirPath),
        ); // Refresh destination folder if different
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(
          "Error moving directory from $sourceDirPath to $destinationDirPath: $e",
        );
      }
      // Fallback for cross-volume move if rename fails.
      if (e is FileSystemException && (e.osError?.errorCode == 18)) {
        if (kDebugMode) {
          print(
            "Directory rename failed (potential cross-volume move). Attempting copy+delete.",
          );
        }
        if (await copyDirectory(sourceDirPath, destinationDirPath)) {
          return await deleteFolder(
            sourceDirPath,
          ); // If copy succeeds, delete original recursively
        }
      }
      return false;
    }
  }

  /// 8. Get content of a text-based file.
  /// For binary document types (e.g., PDF, DOCX), this will likely return garbled text or throw errors.
  /// It's intended for plain text files.
  Future<String?> getDocumentContent(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        if (kDebugMode) print("File not found: $filePath");
        return null;
      }
      if (isTextFile(file)) {
        // Only attempt to read as string if it's considered a text type
        return await file.readAsString(encoding: utf8); // Read as UTF-8 string
      } else {
        if (kDebugMode) {
          print(
            "Cannot read content of $filePath: Not identified as a plain text document.",
          );
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) print("Error reading content of file $filePath: $e");
      return null;
    }
  }

  /// 8. Save content to an existing text-based file.
  Future<bool> saveDocumentContent(String filePath, String content) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        if (kDebugMode) print("File not found, cannot save content: $filePath");
        return false;
      }
      await file.writeAsString(content, encoding: utf8);
      await refresh(
        p.dirname(filePath),
      ); // Refresh directory to update file timestamps/size
      return true;
    } catch (e) {
      if (kDebugMode) print("Error saving content to file $filePath: $e");
      return false;
    }
  }

  /// 8. Save content to a new file (Save As functionality).
  /// `newFilePath`: The full path for the new file, including the filename.
  Future<bool> saveDocumentContentAs(String newFilePath, String content) async {
    try {
      final newFile = File(newFilePath);
      // Create parent directory if it doesn't exist
      final newDir = Directory(p.dirname(newFilePath));
      if (!await newDir.exists()) {
        await newDir.create(recursive: true);
      }
      await newFile.writeAsString(content, encoding: utf8);
      await refresh(
        p.dirname(newFilePath),
      ); // Refresh directory for the newly created file
      return true;
    } catch (e) {
      if (kDebugMode) {
        print("Error saving content as new file $newFilePath: $e");
      }
      return false;
    }
  }
}
