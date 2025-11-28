// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fs_entry_union.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FsFileImpl _$$FsFileImplFromJson(Map<String, dynamic> json) => _$FsFileImpl(
  base: FsEntryBase.fromJson(json['base'] as Map<String, dynamic>),
  data: FsFileData.fromJson(json['data'] as Map<String, dynamic>),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$$FsFileImplToJson(_$FsFileImpl instance) =>
    <String, dynamic>{
      'base': instance.base,
      'data': instance.data,
      'runtimeType': instance.$type,
    };

_$FsFolderImpl _$$FsFolderImplFromJson(Map<String, dynamic> json) =>
    _$FsFolderImpl(
      base: FsEntryBase.fromJson(json['base'] as Map<String, dynamic>),
      data: FsFolderData.fromJson(json['data'] as Map<String, dynamic>),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$FsFolderImplToJson(_$FsFolderImpl instance) =>
    <String, dynamic>{
      'base': instance.base,
      'data': instance.data,
      'runtimeType': instance.$type,
    };
