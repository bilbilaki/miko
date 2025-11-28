import 'package:freezed_annotation/freezed_annotation.dart';

import 'fs_entry.dart';
import 'fs_file_data.dart';
import 'fs_folder_children.dart';

part 'fs_entry_union.freezed.dart';
part 'fs_entry_union.g.dart';

/// Abstract type for anything in the filesystem: file or folder.
@freezed
class FsEntry with _$FsEntry {
  const FsEntry._(); // common helpers

  const factory FsEntry.file({
    required FsEntryBase base,
    required FsFileData data,
  }) = FsFile;

  const factory FsEntry.folder({
    required FsEntryBase base,
    required FsFolderData data,
  }) = FsFolder;

  factory FsEntry.fromJson(Map<String, dynamic> json) =>
      _$FsEntryFromJson(json);

  /// Convenience getters
  String get id => base.id;
  String get path => base.path;
  String get name => base.name;
  FileKind get kind => base.kind;
  String? get extension => base.extension;
  int? get sizeBytes => base.sizeBytes;
  EntryStatus get status => base.status;
  
  /// Check if this entry is a file
  bool get isFile => this is FsFile;
  
  /// Check if this entry is a folder
  bool get isFolder => this is FsFolder;
}
