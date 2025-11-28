import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'fs_entry.freezed.dart';
part 'fs_entry.g.dart';

const _uuid = Uuid();

/// Classification of file content at a high level.
/// Use this to route handling (editor/viewer/converter).
enum FileKind {
  unknown,
  folder,
  image,
  audio,
  video,
  document,
  archive,
  binary,
  code,
  script,
  markdown,
  database,
  json,
  csv,
  certificate,
  apk,
  iso,
  link,
  aiRequest,
  aiResult,
  // Add more kinds as needed
}

/// Generic status flags for entries.
enum EntryStatus {
  normal,
  deleted,
  hidden,
  locked,
  error,
}

/// Permissions/ownership (simplified, you can expand).
@freezed
class EntryAccess with _$EntryAccess {
  const factory EntryAccess({
    @Default(false) bool readable,
    @Default(false) bool writable,
    @Default(false) bool executable,
    String? ownerUserId,
    String? ownerGroupId,
  }) = _EntryAccess;

  factory EntryAccess.fromJson(Map<String, dynamic> json) =>
      _$EntryAccessFromJson(json);
}

/// Timestamps associated with an entry.
@freezed
class EntryTimestamps with _$EntryTimestamps {
  const factory EntryTimestamps({
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? accessedAt,
  }) = _EntryTimestamps;

  factory EntryTimestamps.fromJson(Map<String, dynamic> json) =>
      _$EntryTimestampsFromJson(json);
}

/// Generic metadata shared by all items.
@freezed
class EntryMeta with _$EntryMeta {
  const factory EntryMeta({
    /// Display name (may differ from actual filesystem name).
    String? displayName,

    /// Freeform tags (e.g., "favorite", "important", AI labels).
    @Default(<String>[]) List<String> tags,

    /// Arbitrary KV store for future extensions (safe forward compatibility).
    @Default(<String, dynamic>{}) Map<String, dynamic> custom,
  }) = _EntryMeta;

  factory EntryMeta.fromJson(Map<String, dynamic> json) =>
      _$EntryMetaFromJson(json);
}

/// Common fields for *all* filesystem entries (files + folders).
@freezed
class FsEntryBase with _$FsEntryBase {
  const factory FsEntryBase({
    /// Stable, global unique ID (never changes).
    required String id,

    /// The path in the virtual filesystem, e.g. `/home/user/file.txt`.
    required String path,

    /// Pure name without path, e.g. `file.txt`.
    required String name,

    /// Human-readable kind, e.g. "image", "audio", "folder".
    required FileKind kind,

    /// File extension WITHOUT the dot (`txt`, `png`, etc.). For folders, `null`.
    String? extension,

    /// Approximate size in bytes (for folders can be sum or null).
    int? sizeBytes,

    /// Status (normal, deleted, locked, etc.).
    @Default(EntryStatus.normal) EntryStatus status,

    /// Access rights & ownership.
    EntryAccess? access,

    /// Timestamps.
    EntryTimestamps? timestamps,

    /// Generic metadata.
    EntryMeta? meta,
  }) = _FsEntryBase;

  factory FsEntryBase.fromJson(Map<String, dynamic> json) =>
      _$FsEntryBaseFromJson(json);

  factory FsEntryBase.create({
    required String path,
    required String name,
    required FileKind kind,
    String? extension,
    int? sizeBytes,
    EntryStatus status = EntryStatus.normal,
    EntryAccess? access,
    EntryTimestamps? timestamps,
    EntryMeta? meta,
  }) {
    return FsEntryBase(
      id: _uuid.v4(),
      path: path,
      name: name,
      kind: kind,
      extension: extension,
      sizeBytes: sizeBytes,
      status: status,
      access: access,
      timestamps: timestamps,
      meta: meta,
    );
  }
}