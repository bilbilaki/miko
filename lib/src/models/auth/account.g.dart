// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AccountDetailsAdapter extends TypeAdapter<AccountDetails> {
  @override
  final typeId = 147;

  @override
  AccountDetails read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AccountDetails(
      id: (fields[0] as num).toInt(),
      name: fields[1] as String?,
      username: fields[2] as String,
      includeAdult: fields[3] as bool?,
      iso6391: fields[4] as String?,
      iso31661: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, AccountDetails obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.username)
      ..writeByte(3)
      ..write(obj.includeAdult)
      ..writeByte(4)
      ..write(obj.iso6391)
      ..writeByte(5)
      ..write(obj.iso31661);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccountDetailsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AccountDetails _$AccountDetailsFromJson(Map<String, dynamic> json) =>
    _AccountDetails(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String?,
      username: json['username'] as String,
      includeAdult: json['include_adult'] as bool?,
      iso6391: json['iso_639_1'] as String?,
      iso31661: json['iso_3166_1'] as String?,
    );

Map<String, dynamic> _$AccountDetailsToJson(_AccountDetails instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'username': instance.username,
      'include_adult': instance.includeAdult,
      'iso_639_1': instance.iso6391,
      'iso_3166_1': instance.iso31661,
    };
