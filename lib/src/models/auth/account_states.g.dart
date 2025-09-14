// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_states.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AccountStatesAdapter extends TypeAdapter<AccountStates> {
  @override
  final typeId = 148;

  @override
  AccountStates read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AccountStates(
      id: (fields[0] as num).toInt(),
      favorite: fields[1] as bool,
      watchlist: fields[2] as bool,
      rated: fields[3] as Object?,
      mediaType: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, AccountStates obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.favorite)
      ..writeByte(2)
      ..write(obj.watchlist)
      ..writeByte(3)
      ..write(obj.rated)
      ..writeByte(4)
      ..write(obj.mediaType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccountStatesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AccountStates _$AccountStatesFromJson(Map<String, dynamic> json) =>
    _AccountStates(
      id: (json['id'] as num).toInt(),
      favorite: json['favorite'] as bool,
      watchlist: json['watchlist'] as bool,
      rated: json['rated'],
      mediaType: json['media_type'] as String?,
    );

Map<String, dynamic> _$AccountStatesToJson(_AccountStates instance) =>
    <String, dynamic>{
      'id': instance.id,
      'favorite': instance.favorite,
      'watchlist': instance.watchlist,
      'rated': instance.rated,
      'media_type': instance.mediaType,
    };
