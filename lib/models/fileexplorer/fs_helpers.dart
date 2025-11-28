
import 'fs_entry.dart';
import 'fs_entry_union.dart';


extension FsEntryExtension on FsEntry {
  /// Returns true if this entry is a file
  bool get isFile => this is FsFile;
  
  /// Returns true if this entry is a folder
  bool get isFolder => this is FsFolder;
  
  /// Get unique identifier - uses path as ID for local filesystem
  String get id {
    return map(
      file: (f) => f.base.path,
      folder: (d) => d.base.path,
    );
  }
  
  /// Get full filesystem path
  String get path {
    return map(
      file: (f) => f.base.path,
      folder: (d) => d.base.path,
    );
  }
  
  /// Get entry name (filename or folder name)
  String get name {
    return map(
      file: (f) => f.base.name,
      folder: (d) => d.base.name,
    );
  }
  
  /// Get file kind (image, video, audio, document, etc.)
  FileKind get kind {
    return map(
      file: (f) => f.base.kind,
      folder: (d) => d.base.kind,
    );
  }
  
  /// Get file size in bytes (0 for folders)
  int get sizeBytes {
    return map(
      file: (f) => f.base.sizeBytes??1,
      folder: (_) => 0,
    );
  }
  
  /// Get MIME type (empty string for folders)
  String get mimeType {
    return map(
      file: (f) => f.data.mime??'unknown',
      folder: (_) => '',
    );
  }
}