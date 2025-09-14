// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alternative_titles.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AlternativeTitleAdapter extends TypeAdapter<AlternativeTitle> {
  @override
  final typeId = 113;

  @override
  AlternativeTitle read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AlternativeTitle(
      id: (fields[0] as num).toInt(),
      iso31661: fields[1] as String,
      title: fields[2] as String,
      type: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, AlternativeTitle obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.iso31661)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AlternativeTitleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AlternativeTitlesResponseAdapter
    extends TypeAdapter<AlternativeTitlesResponse> {
  @override
  final typeId = 114;

  @override
  AlternativeTitlesResponse read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AlternativeTitlesResponse(
      id: (fields[0] as num).toInt(),
      titles: (fields[1] as List).cast<AlternativeTitle>(),
    );
  }

  @override
  void write(BinaryWriter writer, AlternativeTitlesResponse obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.titles);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AlternativeTitlesResponseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AlternativeTitle _$AlternativeTitleFromJson(Map<String, dynamic> json) =>
    _AlternativeTitle(
      id: (json['id'] as num).toInt(),
      iso31661: json['iso_3166_1'] as String,
      title: json['title'] as String,
      type: json['type'] as String?,
    );

Map<String, dynamic> _$AlternativeTitleToJson(_AlternativeTitle instance) =>
    <String, dynamic>{
      'id': instance.id,
      'iso_3166_1': instance.iso31661,
      'title': instance.title,
      'type': instance.type,
    };

_AlternativeTitlesResponse _$AlternativeTitlesResponseFromJson(
  Map<String, dynamic> json,
) => _AlternativeTitlesResponse(
  id: (json['id'] as num).toInt(),
  titles: (json['titles'] as List<dynamic>)
      .map((e) => AlternativeTitle.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$AlternativeTitlesResponseToJson(
  _AlternativeTitlesResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'titles': instance.titles.map((e) => e.toJson()).toList(),
};
