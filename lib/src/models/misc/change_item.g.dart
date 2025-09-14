// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'change_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChangeItemAdapter extends TypeAdapter<ChangeItem> {
  @override
  final typeId = 152;

  @override
  ChangeItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChangeItem(
      id: (fields[0] as num).toInt(),
      adult: fields[1] as bool?,
      mediaType: fields[2] as String?,
      description: fields[3] as String?,
      originalTitle: fields[4] as String?,
      originalName: fields[5] as String?,
      title: fields[6] as String?,
      name: fields[7] as String?,
      profilePath: fields[8] as String?,
      changeType: fields[9] as String?,
      changes: (fields[10] as List?)?.cast<Object?>(),
    );
  }

  @override
  void write(BinaryWriter writer, ChangeItem obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.adult)
      ..writeByte(2)
      ..write(obj.mediaType)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.originalTitle)
      ..writeByte(5)
      ..write(obj.originalName)
      ..writeByte(6)
      ..write(obj.title)
      ..writeByte(7)
      ..write(obj.name)
      ..writeByte(8)
      ..write(obj.profilePath)
      ..writeByte(9)
      ..write(obj.changeType)
      ..writeByte(10)
      ..write(obj.changes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChangeItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChangeItem _$ChangeItemFromJson(Map<String, dynamic> json) => _ChangeItem(
  id: (json['id'] as num).toInt(),
  adult: json['adult'] as bool?,
  mediaType: json['mediaType'] as String?,
  description: json['description'] as String?,
  originalTitle: json['original_title'] as String?,
  originalName: json['original_name'] as String?,
  title: json['title'] as String?,
  name: json['name'] as String?,
  profilePath: json['profile_path'] as String?,
  changeType: json['change_type'] as String?,
  changes: json['changes'] as List<dynamic>?,
);

Map<String, dynamic> _$ChangeItemToJson(_ChangeItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'adult': instance.adult,
      'mediaType': instance.mediaType,
      'description': instance.description,
      'original_title': instance.originalTitle,
      'original_name': instance.originalName,
      'title': instance.title,
      'name': instance.name,
      'profile_path': instance.profilePath,
      'change_type': instance.changeType,
      'changes': instance.changes,
    };
