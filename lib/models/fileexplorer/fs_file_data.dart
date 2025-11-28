import 'package:freezed_annotation/freezed_annotation.dart';

import 'fs_entry.dart';

part 'fs_file_data.freezed.dart';
part 'fs_file_data.g.dart';

/// Information about how a file is stored (local path, remote URL, etc.)
@freezed
class StorageLocation with _$StorageLocation {
  const factory StorageLocation.local({
    /// Absolute local path.
    required String localPath,
  }) = LocalStorageLocation;

  const factory StorageLocation.remote({
    /// URL or remote key.
    required String uri,
    /// Optional storage backend type (ftp, http, s3, etc.)
    String? backend,
  }) = RemoteStorageLocation;

  factory StorageLocation.fromJson(Map<String, dynamic> json) =>
      _$StorageLocationFromJson(json);
}

/// Describes how a file can be converted to other types.
@freezed
class FileConversionCapability with _$FileConversionCapability {
  const factory FileConversionCapability({
    /// Target kind (e.g., image -> archive, text -> markdown).
    required FileKind targetKind,

    /// Target extension(s), e.g., ["jpg", "webp"].
    @Default(<String>[]) List<String> targetExtensions,

    /// Optional description for UI.
    String? description,

    /// Additional fixed parameters for a default conversion.
    @Default(<String, dynamic>{}) Map<String, dynamic> defaultParams,
  }) = _FileConversionCapability;

  factory FileConversionCapability.fromJson(Map<String, dynamic> json) =>
      _$FileConversionCapabilityFromJson(json);
}

/// Typed metadata for specific file categories.
/// You can extend these as needed.
@freezed
class ImageMeta with _$ImageMeta {
  const factory ImageMeta({
    int? width,
    int? height,
    String? colorSpace,
    int? dpi,
  }) = _ImageMeta;

  factory ImageMeta.fromJson(Map<String, dynamic> json) =>
      _$ImageMetaFromJson(json);
}

@freezed
class AudioMeta with _$AudioMeta {
  const factory AudioMeta({
    double? durationSeconds,
    int? bitrateKbps,
    int? sampleRateHz,
    int? channels,
  }) = _AudioMeta;

  factory AudioMeta.fromJson(Map<String, dynamic> json) =>
      _$AudioMetaFromJson(json);
}

@freezed
class VideoMeta with _$VideoMeta {
  const factory VideoMeta({
    double? durationSeconds,
    int? width,
    int? height,
    double? fps,
  }) = _VideoMeta;

  factory VideoMeta.fromJson(Map<String, dynamic> json) =>
      _$VideoMetaFromJson(json);
}

@freezed
class DocumentMeta with _$DocumentMeta {
  const factory DocumentMeta({
    int? pageCount,
    String? language,
    bool? searchableText,
  }) = _DocumentMeta;

  factory DocumentMeta.fromJson(Map<String, dynamic> json) =>
      _$DocumentMetaFromJson(json);
}

/// AI-related file metadata (e.g., your `aitools` inputs/outputs).
@freezed
class AiMeta with _$AiMeta {
  const factory AiMeta({
    /// Which AI tool produced or consumes this file.
    String? toolName, // e.g. "text_generation", "translate", etc.

    /// ID of the request that produced this file (if result).
    String? requestId,

    /// ID of related source file, if any.
    String? sourceEntryId,

    /// Model/provider info.
    String? modelName,
    String? providerName,
  }) = _AiMeta;

  factory AiMeta.fromJson(Map<String, dynamic> json) =>
      _$AiMetaFromJson(json);
}

/// Polymorphic metadata container for concrete file types.
@freezed
class FileTypeMeta with _$FileTypeMeta {
  const factory FileTypeMeta.image(ImageMeta image) = FileTypeMetaImage;
  const factory FileTypeMeta.audio(AudioMeta audio) = FileTypeMetaAudio;
  const factory FileTypeMeta.video(VideoMeta video) = FileTypeMetaVideo;
  const factory FileTypeMeta.document(DocumentMeta document) =
      FileTypeMetaDocument;
  const factory FileTypeMeta.ai(AiMeta ai) = FileTypeMetaAi;
  const factory FileTypeMeta.unknown(Map<String, dynamic> data) =
      FileTypeMetaUnknown;

  factory FileTypeMeta.fromJson(Map<String, dynamic> json) =>
      _$FileTypeMetaFromJson(json);
}

/// The data specific to files.
@freezed
class FsFileData with _$FsFileData {
  const factory FsFileData({
    /// How the file is stored.
    required StorageLocation location,

    /// Low-level mime type, e.g. `image/png`, `text/markdown`.
    String? mime,

    /// Optional typed metadata for the specific content.
    FileTypeMeta? typeMeta,

    /// Whether content is fully available (vs. stub).
    @Default(true) bool isContentAvailable,

    /// Which conversions this file supports.
    @Default(<FileConversionCapability>[])
    List<FileConversionCapability> convertibleTo,
  }) = _FsFileData;

  factory FsFileData.fromJson(Map<String, dynamic> json) =>
      _$FsFileDataFromJson(json);
}