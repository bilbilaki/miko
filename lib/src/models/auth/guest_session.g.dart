// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guest_session.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GuestSessionAdapter extends TypeAdapter<GuestSession> {
  @override
  final typeId = 145;

  @override
  GuestSession read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GuestSession(
      success: fields[0] as bool,
      guestSessionId: fields[1] as String,
      expiresAt: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, GuestSession obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.success)
      ..writeByte(1)
      ..write(obj.guestSessionId)
      ..writeByte(2)
      ..write(obj.expiresAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GuestSessionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GuestSession _$GuestSessionFromJson(Map<String, dynamic> json) =>
    _GuestSession(
      success: json['success'] as bool,
      guestSessionId: json['guest_session_id'] as String,
      expiresAt: json['expires_at'] as String,
    );

Map<String, dynamic> _$GuestSessionToJson(_GuestSession instance) =>
    <String, dynamic>{
      'success': instance.success,
      'guest_session_id': instance.guestSessionId,
      'expires_at': instance.expiresAt,
    };
