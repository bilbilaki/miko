import 'package:freezed_annotation/freezed_annotation.dart';

part 'fs_folder_children.freezed.dart';
part 'fs_folder_children.g.dart';

/// Light-weight child reference for folders.
/// This allows lazy loading of full entries.
@freezed
class FolderChildRef with _$FolderChildRef {
  const factory FolderChildRef({
    required String id,
    required String name,
    required bool isFolder,
  }) = _FolderChildRef;

  factory FolderChildRef.fromJson(Map<String, dynamic> json) =>
      _$FolderChildRefFromJson(json);
}

/// Data specific to folders.
@freezed
class FsFolderData with _$FsFolderData {
  const factory FsFolderData({
    /// IDs of children in this folder, for quick navigation.
    @Default(<FolderChildRef>[]) List<FolderChildRef> children,

    /// If true, children list might be incomplete until fully scanned.
    @Default(false) bool isPartial,
  }) = _FsFolderData;

  factory FsFolderData.fromJson(Map<String, dynamic> json) =>
      _$FsFolderDataFromJson(json);
}