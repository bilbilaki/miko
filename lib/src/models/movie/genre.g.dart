// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'genre.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MovieGenreAdapter extends TypeAdapter<MovieGenre> {
  @override
  final typeId = 102;

  @override
  MovieGenre read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MovieGenre(
      id: (fields[0] as num).toInt(),
      name: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MovieGenre obj) {
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
      other is MovieGenreAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class GenreListResponseAdapter extends TypeAdapter<GenreListResponse> {
  @override
  final typeId = 103;

  @override
  GenreListResponse read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GenreListResponse(genres: (fields[0] as List).cast<MovieGenre>());
  }

  @override
  void write(BinaryWriter writer, GenreListResponse obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.genres);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GenreListResponseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MovieGenre _$MovieGenreFromJson(Map<String, dynamic> json) =>
    _MovieGenre(id: (json['id'] as num).toInt(), name: json['name'] as String);

Map<String, dynamic> _$MovieGenreToJson(_MovieGenre instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};

_GenreListResponse _$GenreListResponseFromJson(Map<String, dynamic> json) =>
    _GenreListResponse(
      genres: (json['genres'] as List<dynamic>)
          .map((e) => MovieGenre.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GenreListResponseToJson(_GenreListResponse instance) =>
    <String, dynamic>{
      'genres': instance.genres.map((e) => e.toJson()).toList(),
    };
