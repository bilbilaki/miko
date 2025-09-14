// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tv_genre.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TvGenreAdapter extends TypeAdapter<TvGenre> {
  @override
  final typeId = 127;

  @override
  TvGenre read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TvGenre(id: (fields[0] as num).toInt(), name: fields[1] as String);
  }

  @override
  void write(BinaryWriter writer, TvGenre obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TvGenreAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TvGenre _$TvGenreFromJson(Map<String, dynamic> json) =>
    _TvGenre(id: (json['id'] as num).toInt(), name: json['name'] as String);

Map<String, dynamic> _$TvGenreToJson(_TvGenre instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
};
