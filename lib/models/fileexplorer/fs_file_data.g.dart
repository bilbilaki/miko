// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fs_file_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LocalStorageLocationImpl _$$LocalStorageLocationImplFromJson(
  Map<String, dynamic> json,
) => _$LocalStorageLocationImpl(
  localPath: json['localPath'] as String,
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$$LocalStorageLocationImplToJson(
  _$LocalStorageLocationImpl instance,
) => <String, dynamic>{
  'localPath': instance.localPath,
  'runtimeType': instance.$type,
};

_$RemoteStorageLocationImpl _$$RemoteStorageLocationImplFromJson(
  Map<String, dynamic> json,
) => _$RemoteStorageLocationImpl(
  uri: json['uri'] as String,
  backend: json['backend'] as String?,
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$$RemoteStorageLocationImplToJson(
  _$RemoteStorageLocationImpl instance,
) => <String, dynamic>{
  'uri': instance.uri,
  'backend': instance.backend,
  'runtimeType': instance.$type,
};

_$FileConversionCapabilityImpl _$$FileConversionCapabilityImplFromJson(
  Map<String, dynamic> json,
) => _$FileConversionCapabilityImpl(
  targetKind: $enumDecode(_$FileKindEnumMap, json['targetKind']),
  targetExtensions:
      (json['targetExtensions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  description: json['description'] as String?,
  defaultParams:
      json['defaultParams'] as Map<String, dynamic>? ??
      const <String, dynamic>{},
);

Map<String, dynamic> _$$FileConversionCapabilityImplToJson(
  _$FileConversionCapabilityImpl instance,
) => <String, dynamic>{
  'targetKind': _$FileKindEnumMap[instance.targetKind]!,
  'targetExtensions': instance.targetExtensions,
  'description': instance.description,
  'defaultParams': instance.defaultParams,
};

const _$FileKindEnumMap = {
  FileKind.unknown: 'unknown',
  FileKind.folder: 'folder',
  FileKind.image: 'image',
  FileKind.audio: 'audio',
  FileKind.video: 'video',
  FileKind.document: 'document',
  FileKind.archive: 'archive',
  FileKind.binary: 'binary',
  FileKind.code: 'code',
  FileKind.script: 'script',
  FileKind.markdown: 'markdown',
  FileKind.database: 'database',
  FileKind.json: 'json',
  FileKind.csv: 'csv',
  FileKind.certificate: 'certificate',
  FileKind.apk: 'apk',
  FileKind.iso: 'iso',
  FileKind.link: 'link',
  FileKind.aiRequest: 'aiRequest',
  FileKind.aiResult: 'aiResult',
};

_$ImageMetaImpl _$$ImageMetaImplFromJson(Map<String, dynamic> json) =>
    _$ImageMetaImpl(
      width: (json['width'] as num?)?.toInt(),
      height: (json['height'] as num?)?.toInt(),
      colorSpace: json['colorSpace'] as String?,
      dpi: (json['dpi'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$ImageMetaImplToJson(_$ImageMetaImpl instance) =>
    <String, dynamic>{
      'width': instance.width,
      'height': instance.height,
      'colorSpace': instance.colorSpace,
      'dpi': instance.dpi,
    };

_$AudioMetaImpl _$$AudioMetaImplFromJson(Map<String, dynamic> json) =>
    _$AudioMetaImpl(
      durationSeconds: (json['durationSeconds'] as num?)?.toDouble(),
      bitrateKbps: (json['bitrateKbps'] as num?)?.toInt(),
      sampleRateHz: (json['sampleRateHz'] as num?)?.toInt(),
      channels: (json['channels'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$AudioMetaImplToJson(_$AudioMetaImpl instance) =>
    <String, dynamic>{
      'durationSeconds': instance.durationSeconds,
      'bitrateKbps': instance.bitrateKbps,
      'sampleRateHz': instance.sampleRateHz,
      'channels': instance.channels,
    };

_$VideoMetaImpl _$$VideoMetaImplFromJson(Map<String, dynamic> json) =>
    _$VideoMetaImpl(
      durationSeconds: (json['durationSeconds'] as num?)?.toDouble(),
      width: (json['width'] as num?)?.toInt(),
      height: (json['height'] as num?)?.toInt(),
      fps: (json['fps'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$VideoMetaImplToJson(_$VideoMetaImpl instance) =>
    <String, dynamic>{
      'durationSeconds': instance.durationSeconds,
      'width': instance.width,
      'height': instance.height,
      'fps': instance.fps,
    };

_$DocumentMetaImpl _$$DocumentMetaImplFromJson(Map<String, dynamic> json) =>
    _$DocumentMetaImpl(
      pageCount: (json['pageCount'] as num?)?.toInt(),
      language: json['language'] as String?,
      searchableText: json['searchableText'] as bool?,
    );

Map<String, dynamic> _$$DocumentMetaImplToJson(_$DocumentMetaImpl instance) =>
    <String, dynamic>{
      'pageCount': instance.pageCount,
      'language': instance.language,
      'searchableText': instance.searchableText,
    };

_$AiMetaImpl _$$AiMetaImplFromJson(Map<String, dynamic> json) => _$AiMetaImpl(
  toolName: json['toolName'] as String?,
  requestId: json['requestId'] as String?,
  sourceEntryId: json['sourceEntryId'] as String?,
  modelName: json['modelName'] as String?,
  providerName: json['providerName'] as String?,
);

Map<String, dynamic> _$$AiMetaImplToJson(_$AiMetaImpl instance) =>
    <String, dynamic>{
      'toolName': instance.toolName,
      'requestId': instance.requestId,
      'sourceEntryId': instance.sourceEntryId,
      'modelName': instance.modelName,
      'providerName': instance.providerName,
    };

_$FileTypeMetaImageImpl _$$FileTypeMetaImageImplFromJson(
  Map<String, dynamic> json,
) => _$FileTypeMetaImageImpl(
  ImageMeta.fromJson(json['image'] as Map<String, dynamic>),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$$FileTypeMetaImageImplToJson(
  _$FileTypeMetaImageImpl instance,
) => <String, dynamic>{'image': instance.image, 'runtimeType': instance.$type};

_$FileTypeMetaAudioImpl _$$FileTypeMetaAudioImplFromJson(
  Map<String, dynamic> json,
) => _$FileTypeMetaAudioImpl(
  AudioMeta.fromJson(json['audio'] as Map<String, dynamic>),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$$FileTypeMetaAudioImplToJson(
  _$FileTypeMetaAudioImpl instance,
) => <String, dynamic>{'audio': instance.audio, 'runtimeType': instance.$type};

_$FileTypeMetaVideoImpl _$$FileTypeMetaVideoImplFromJson(
  Map<String, dynamic> json,
) => _$FileTypeMetaVideoImpl(
  VideoMeta.fromJson(json['video'] as Map<String, dynamic>),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$$FileTypeMetaVideoImplToJson(
  _$FileTypeMetaVideoImpl instance,
) => <String, dynamic>{'video': instance.video, 'runtimeType': instance.$type};

_$FileTypeMetaDocumentImpl _$$FileTypeMetaDocumentImplFromJson(
  Map<String, dynamic> json,
) => _$FileTypeMetaDocumentImpl(
  DocumentMeta.fromJson(json['document'] as Map<String, dynamic>),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$$FileTypeMetaDocumentImplToJson(
  _$FileTypeMetaDocumentImpl instance,
) => <String, dynamic>{
  'document': instance.document,
  'runtimeType': instance.$type,
};

_$FileTypeMetaAiImpl _$$FileTypeMetaAiImplFromJson(Map<String, dynamic> json) =>
    _$FileTypeMetaAiImpl(
      AiMeta.fromJson(json['ai'] as Map<String, dynamic>),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$FileTypeMetaAiImplToJson(
  _$FileTypeMetaAiImpl instance,
) => <String, dynamic>{'ai': instance.ai, 'runtimeType': instance.$type};

_$FileTypeMetaUnknownImpl _$$FileTypeMetaUnknownImplFromJson(
  Map<String, dynamic> json,
) => _$FileTypeMetaUnknownImpl(
  json['data'] as Map<String, dynamic>,
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$$FileTypeMetaUnknownImplToJson(
  _$FileTypeMetaUnknownImpl instance,
) => <String, dynamic>{'data': instance.data, 'runtimeType': instance.$type};

_$FsFileDataImpl _$$FsFileDataImplFromJson(
  Map<String, dynamic> json,
) => _$FsFileDataImpl(
  location: StorageLocation.fromJson(json['location'] as Map<String, dynamic>),
  mime: json['mime'] as String?,
  typeMeta: json['typeMeta'] == null
      ? null
      : FileTypeMeta.fromJson(json['typeMeta'] as Map<String, dynamic>),
  isContentAvailable: json['isContentAvailable'] as bool? ?? true,
  convertibleTo:
      (json['convertibleTo'] as List<dynamic>?)
          ?.map(
            (e) => FileConversionCapability.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const <FileConversionCapability>[],
);

Map<String, dynamic> _$$FsFileDataImplToJson(_$FsFileDataImpl instance) =>
    <String, dynamic>{
      'location': instance.location,
      'mime': instance.mime,
      'typeMeta': instance.typeMeta,
      'isContentAvailable': instance.isContentAvailable,
      'convertibleTo': instance.convertibleTo,
    };
