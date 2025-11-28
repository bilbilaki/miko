import 'dart:io';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;

import '../models/fileexplorer/fs_entry.dart';
import '../models/fileexplorer/fs_entry_union.dart';
import '../models/fileexplorer/fs_file_data.dart';
import '../models/fileexplorer/fs_folder_children.dart';

abstract class FsRepository {
Future<FsEntry?> getEntry(String id);
Future<FsEntry?> getEntryByPath(String path);
Future<FsFile> copyFile({
required String sourceFileId,
required String targetFolderId,
String? newName,
bool overwrite = false,
});
}

/// Cancellation token for aborting async operations
abstract class CancellationToken {
bool get isCancelled;
void throwIfCancelled();
}
/// Concrete implementation of FsRepository for local filesystem operations.
/// 
/// Bridges between raw dart:io File/Directory objects and the domain model
/// (FsEntry) by converting filesystem entities into typed domain models.
class LocalFsRepository implements FsRepository {
  /// Retrieves an FsEntry for the given path.
  /// 
  /// Returns null if the path does not exist or is inaccessible.
  /// Automatically determines whether the path is a file or folder.
  @override
  Future<FsEntry?> getEntry(String path) async {
    try {
      final type = await FileSystemEntity.type(path);
      
      if (type == FileSystemEntityType.notFound) {
        return null;
      }

      if (type == FileSystemEntityType.directory) {
        return _createFolderEntry(Directory(path));
      } else {
        return _createFileEntry(File(path));
      }
    } catch (e) {
      return null;
    }
  }

  /// Alias for getEntry - retrieves entry by its path (which is its ID).
  @override
  Future<FsEntry?> getEntryByPath(String path) => getEntry(path);

  /// Lists all entries (files and folders) in a directory.
  /// 
  /// Returns an empty list if the directory doesn't exist or can't be read.
  /// Does not recursively list subdirectories.
  Future<List<FsEntry>> listContents(String dirPath) async {
    try {
      final dir = Directory(dirPath);
      if (!await dir.exists()) return [];

      final entities = await dir.list().toList();
      final results = <FsEntry>[];

      for (var entity in entities) {
        try {
          if (entity is File) {
            final entry = await _createFileEntry(entity);
            results.add(entry);
          } else if (entity is Directory) {
            final entry = _createFolderEntry(entity);
            results.add(entry);
          }
        } catch (e) {
          // Skip entries that fail to convert (permission issues, etc.)
          continue;
        }
      }
      return results;
    } catch (e) {
      return [];
    }
  }

  /// Helper: Convert a dart:io File to FsEntry.file
  /// 
  /// Extracts metadata including:
  /// - MIME type via lookupMimeType
  /// - File size and timestamps
  /// - FileKind based on extension/MIME type
  Future<FsEntry> _createFileEntry(File file) async {
    try {
      final stat = await file.stat();
      final name = p.basename(file.path);
      final extension = _getExtension(file.path);
      final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';

      // Determine FileKind based on extension and MIME type
      final kind = _determineFileKind(extension, mimeType);

      return FsEntry.file(
        base: FsEntryBase.create(
          path: file.path,
          name: name,
          kind: kind,
          extension: extension,
          sizeBytes: stat.size,
          timestamps: EntryTimestamps(
            createdAt: stat.changed,
            updatedAt: stat.modified,
            accessedAt: stat.accessed,
          ),
        ),
        data: FsFileData(
          location: StorageLocation.local(localPath: file.path),
          mime: mimeType,
          typeMeta: _createTypeMeta(kind, mimeType, file.path),
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Helper: Convert a dart:io Directory to FsEntry.folder
  /// 
  /// Creates a folder entry without loading children (marked as partial).
  /// Use listContents() separately to get children.
  FsEntry _createFolderEntry(Directory dir) {
    final name = p.basename(dir.path);
    return FsEntry.folder(
      base: FsEntryBase.create(
        path: dir.path,
        name: name,
        kind: FileKind.folder,
      ),
      data: const FsFolderData(children: [], isPartial: true),
    );
  }

  /// Determines FileKind based on file extension and MIME type.
  /// 
  /// Follows the logic from LocalProvider's file type detection methods.
  FileKind _determineFileKind(String ext, String mime) {
    // Check MIME type first (more reliable)
    if (mime.startsWith('image/')) return FileKind.image;
    if (mime.startsWith('video/')) return FileKind.video;
    if (mime.startsWith('audio/')) return FileKind.audio;
    if (mime.startsWith('text/') || mime.contains('json') || mime.contains('xml')) {
      return FileKind.document;
    }

    // Fall back to extension-based detection
    final lowerExt = ext.toLowerCase();
    
    // Video extensions
    if (_videoExtensions.contains(lowerExt)) return FileKind.video;
    
    // Audio extensions
    if (_audioExtensions.contains(lowerExt)) return FileKind.audio;
    
    // Image extensions
    if (_imageExtensions.contains(lowerExt)) return FileKind.image;
    
    // Archive extensions
    if (_archiveExtensions.contains(lowerExt)) return FileKind.archive;
    
    // APK files
    if (lowerExt == '.apk') return FileKind.apk;
    
    // Code extensions
    if (_codeExtensions.contains(lowerExt)) return FileKind.code;
    
    // Document extensions
    if (_documentExtensions.contains(lowerExt)) return FileKind.document;
    
    // JSON files
    if (lowerExt == '.json') return FileKind.json;
    
    // CSV files
    if (lowerExt == '.csv') return FileKind.csv;
    
    // Markdown files
    if (lowerExt == '.md') return FileKind.markdown;
    
    // Default
    return FileKind.unknown;
  }

  /// Creates optional TypeMeta based on FileKind.
  /// 
  /// For images, videos, and audio, this could be extended to extract
  /// actual metadata. For now, returns null (metadata can be lazy-loaded).
  FileTypeMeta? _createTypeMeta(FileKind kind, String mime, String filePath) {
    // TODO: Implement lazy metadata extraction for images, videos, audio
    // For now, return null to avoid blocking on expensive operations
    return null;
  }

  /// Extracts the file extension (with leading dot) from a path.
  String _getExtension(String filePath) {
    final ext = p.extension(filePath);
    return ext.isNotEmpty ? ext : '';
  }

  /// Implements FsRepository.copyFile
  /// 
  /// Copies a file from source to target folder, handling conflicts
  /// based on the provided policy.
  @override
  Future<FsFile> copyFile({
    required String sourceFileId,
    required String targetFolderId,
    String? newName,
    bool overwrite = false,
  }) async {
    final sourceFile = File(sourceFileId);
    final targetDir = Directory(targetFolderId);

    if (!await sourceFile.exists()) {
      throw FileSystemException('Source file not found', sourceFileId);
    }

    if (!await targetDir.exists()) {
      throw FileSystemException('Target directory not found', targetFolderId);
    }

    final targetFileName = newName ?? p.basename(sourceFileId);
    final targetPath = p.join(targetFolderId, targetFileName);

    if (!overwrite && await File(targetPath).exists()) {
      throw FileSystemException('Target file already exists', targetPath);
    }

    final copiedFile = await sourceFile.copy(targetPath);
    final entry = await _createFileEntry(copiedFile);

    if (entry is! FsFile) {
      throw StateError('Failed to create FsFile entry from copied file');
    }

    return entry;
  }

  // Extension sets for file type detection
  static const _videoExtensions = {
    '.mp4', '.avi', '.mkv', '.mov', '.webm', '.flv', '.wmv', '.m4v', '.ts', '.mts'
  };

  static const _audioExtensions = {
    '.mp3', '.m4a', '.flac', '.wav', '.aac', '.ogg', '.wma', '.aiff', '.alac'
  };

  static const _imageExtensions = {
    '.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp', '.ico', '.svg', '.tiff', '.raw'
  };

  static const _archiveExtensions = {
    '.zip', '.rar', '.7z', '.tar', '.gz', '.bz2', '.xz', '.iso'
  };

  static const _codeExtensions = {
    '.dart', '.java', '.py', '.js', '.ts', '.c', '.cpp', '.h', '.hpp', '.cs',
    '.go', '.rs', '.swift', '.kt', '.php', '.rb', '.sh', '.bash'
  };

  static const _documentExtensions = {
    '.txt', '.md', '.pdf', '.docx', '.xlsx', '.pptx', '.odt', '.rtf', '.html',
    '.htm', '.xml', '.yaml', '.yml', '.log'
  };
}
