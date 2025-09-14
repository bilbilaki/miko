// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'keyword.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MovieKeywordAdapter extends TypeAdapter<MovieKeyword> {
  @override
  final typeId = 104;

  @override
  MovieKeyword read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MovieKeyword(
      id: (fields[0] as num).toInt(),
      name: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MovieKeyword obj) {
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
      other is MovieKeywordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MovieKeywordsResponseAdapter extends TypeAdapter<MovieKeywordsResponse> {
  @override
  final typeId = 105;

  @override
  MovieKeywordsResponse read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MovieKeywordsResponse(
      id: (fields[0] as num).toInt(),
      keywords: (fields[1] as List).cast<MovieKeyword>(),
    );
  }

  @override
  void write(BinaryWriter writer, MovieKeywordsResponse obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.keywords);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovieKeywordsResponseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MovieKeyword _$MovieKeywordFromJson(Map<String, dynamic> json) =>
    _MovieKeyword(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$MovieKeywordToJson(_MovieKeyword instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};

_MovieKeywordsResponse _$MovieKeywordsResponseFromJson(
  Map<String, dynamic> json,
) => _MovieKeywordsResponse(
  id: (json['id'] as num).toInt(),
  keywords: (json['keywords'] as List<dynamic>)
      .map((e) => MovieKeyword.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$MovieKeywordsResponseToJson(
  _MovieKeywordsResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'keywords': instance.keywords.map((e) => e.toJson()).toList(),
};
