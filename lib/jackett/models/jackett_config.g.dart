// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jackett_config.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class JackettConfigAdapter extends TypeAdapter<JackettConfig> {
  @override
  final int typeId = 0;

  @override
  JackettConfig read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return JackettConfig(
      name: fields[0] as String,
      url: fields[1] as String,
      apiKey: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, JackettConfig obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.url)
      ..writeByte(2)
      ..write(obj.apiKey);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JackettConfigAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
