// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fs_folder_children.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FolderChildRefImpl _$$FolderChildRefImplFromJson(Map<String, dynamic> json) =>
    _$FolderChildRefImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      isFolder: json['isFolder'] as bool,
    );

Map<String, dynamic> _$$FolderChildRefImplToJson(
  _$FolderChildRefImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'isFolder': instance.isFolder,
};

_$FsFolderDataImpl _$$FsFolderDataImplFromJson(Map<String, dynamic> json) =>
    _$FsFolderDataImpl(
      children:
          (json['children'] as List<dynamic>?)
              ?.map((e) => FolderChildRef.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <FolderChildRef>[],
      isPartial: json['isPartial'] as bool? ?? false,
    );

Map<String, dynamic> _$$FsFolderDataImplToJson(_$FsFolderDataImpl instance) =>
    <String, dynamic>{
      'children': instance.children,
      'isPartial': instance.isPartial,
    };
