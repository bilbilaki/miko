// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'creator.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CreatorAdapter extends TypeAdapter<Creator> {
  @override
  final typeId = 129;

  @override
  Creator read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Creator(
      id: (fields[0] as num).toInt(),
      name: fields[1] as String,
      creditId: fields[2] as String?,
      gender: (fields[3] as num?)?.toInt(),
      profilePath: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Creator obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.creditId)
      ..writeByte(3)
      ..write(obj.gender)
      ..writeByte(4)
      ..write(obj.profilePath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreatorAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Creator _$CreatorFromJson(Map<String, dynamic> json) => _Creator(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  creditId: json['credit_id'] as String?,
  gender: (json['gender'] as num?)?.toInt(),
  profilePath: json['profile_path'] as String?,
);

Map<String, dynamic> _$CreatorToJson(_Creator instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'credit_id': instance.creditId,
  'gender': instance.gender,
  'profile_path': instance.profilePath,
};
