import 'dart:io';
import 'package:path/path.dart' as p;
import '../../models/fileexplorer/fs_entry_union.dart';

// Enums for managing UI states
enum ViewMode { grid, list }

enum SortMode { name, date, type }

// A helper class to unify File and Directory for sorting and display purposes
class GridItem {
  final FileSystemEntity? entity;
  final FsEntry? fsEntry;

  GridItem(this.entity) : fsEntry = null;
  GridItem.fromFsEntry(this.fsEntry) : entity = null;
  FsEntry? get entry => fsEntry;

  bool get isFile =>
      (entity is File) || (fsEntry != null && fsEntry!.isFile);
  bool get isFolder => 
    entity is Directory || (fsEntry != null && fsEntry!.isFolder);

  String get name {
    if (entity != null) return p.basename(entity!.path);
    return fsEntry?.name ?? 'Unknown';
  }

  String get path {
    if (entity != null) return entity!.path;
    return fsEntry?.path ?? '';
  }

  FileSystemEntity? get fileSystemEntity => entity;
  bool get isLegacy => entity != null;
  bool get isDomainModel => fsEntry != null;
}
