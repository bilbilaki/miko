// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fs_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EntryAccessImpl _$$EntryAccessImplFromJson(Map<String, dynamic> json) =>
    _$EntryAccessImpl(
      readable: json['readable'] as bool? ?? false,
      writable: json['writable'] as bool? ?? false,
      executable: json['executable'] as bool? ?? false,
      ownerUserId: json['ownerUserId'] as String?,
      ownerGroupId: json['ownerGroupId'] as String?,
    );

Map<String, dynamic> _$$EntryAccessImplToJson(_$EntryAccessImpl instance) =>
    <String, dynamic>{
      'readable': instance.readable,
      'writable': instance.writable,
      'executable': instance.executable,
      'ownerUserId': instance.ownerUserId,
      'ownerGroupId': instance.ownerGroupId,
    };

_$EntryTimestampsImpl _$$EntryTimestampsImplFromJson(
  Map<String, dynamic> json,
) => _$EntryTimestampsImpl(
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
  accessedAt: json['accessedAt'] == null
      ? null
      : DateTime.parse(json['accessedAt'] as String),
);

Map<String, dynamic> _$$EntryTimestampsImplToJson(
  _$EntryTimestampsImpl instance,
) => <String, dynamic>{
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
  'accessedAt': instance.accessedAt?.toIso8601String(),
};

_$EntryMetaImpl _$$EntryMetaImplFromJson(Map<String, dynamic> json) =>
    _$EntryMetaImpl(
      displayName: json['displayName'] as String?,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const <String>[],
      custom:
          json['custom'] as Map<String, dynamic>? ?? const <String, dynamic>{},
    );

Map<String, dynamic> _$$EntryMetaImplToJson(_$EntryMetaImpl instance) =>
    <String, dynamic>{
      'displayName': instance.displayName,
      'tags': instance.tags,
      'custom': instance.custom,
    };

_$FsEntryBaseImpl _$$FsEntryBaseImplFromJson(Map<String, dynamic> json) =>
    _$FsEntryBaseImpl(
      id: json['id'] as String,
      path: json['path'] as String,
      name: json['name'] as String,
      kind: $enumDecode(_$FileKindEnumMap, json['kind']),
      extension: json['extension'] as String?,
      sizeBytes: (json['sizeBytes'] as num?)?.toInt(),
      status:
          $enumDecodeNullable(_$EntryStatusEnumMap, json['status']) ??
          EntryStatus.normal,
      access: json['access'] == null
          ? null
          : EntryAccess.fromJson(json['access'] as Map<String, dynamic>),
      timestamps: json['timestamps'] == null
          ? null
          : EntryTimestamps.fromJson(
              json['timestamps'] as Map<String, dynamic>,
            ),
      meta: json['meta'] == null
          ? null
          : EntryMeta.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$FsEntryBaseImplToJson(_$FsEntryBaseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'path': instance.path,
      'name': instance.name,
      'kind': _$FileKindEnumMap[instance.kind]!,
      'extension': instance.extension,
      'sizeBytes': instance.sizeBytes,
      'status': _$EntryStatusEnumMap[instance.status]!,
      'access': instance.access,
      'timestamps': instance.timestamps,
      'meta': instance.meta,
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

const _$EntryStatusEnumMap = {
  EntryStatus.normal: 'normal',
  EntryStatus.deleted: 'deleted',
  EntryStatus.hidden: 'hidden',
  EntryStatus.locked: 'locked',
  EntryStatus.error: 'error',
};
