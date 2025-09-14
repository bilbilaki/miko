// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MovieVideoAdapter extends TypeAdapter<MovieVideo> {
  @override
  final typeId = 106;

  @override
  MovieVideo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MovieVideo(
      id: fields[0] as String,
      iso6391: fields[1] as String?,
      iso31661: fields[2] as String?,
      key: fields[3] as String,
      name: fields[4] as String,
      site: fields[5] as String,
      size: (fields[6] as num?)?.toInt(),
      type: fields[7] as String,
      official: fields[8] as bool?,
      publishedAt: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MovieVideo obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.iso6391)
      ..writeByte(2)
      ..write(obj.iso31661)
      ..writeByte(3)
      ..write(obj.key)
      ..writeByte(4)
      ..write(obj.name)
      ..writeByte(5)
      ..write(obj.site)
      ..writeByte(6)
      ..write(obj.size)
      ..writeByte(7)
      ..write(obj.type)
      ..writeByte(8)
      ..write(obj.official)
      ..writeByte(9)
      ..write(obj.publishedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovieVideoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MovieVideosResponseAdapter extends TypeAdapter<MovieVideosResponse> {
  @override
  final typeId = 107;

  @override
  MovieVideosResponse read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MovieVideosResponse(
      id: (fields[0] as num).toInt(),
      results: (fields[1] as List).cast<MovieVideo>(),
    );
  }

  @override
  void write(BinaryWriter writer, MovieVideosResponse obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.results);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovieVideosResponseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MovieVideo _$MovieVideoFromJson(Map<String, dynamic> json) => _MovieVideo(
  id: json['id'] as String,
  iso6391: json['iso_639_1'] as String?,
  iso31661: json['iso_3166_1'] as String?,
  key: json['key'] as String,
  name: json['name'] as String,
  site: json['site'] as String,
  size: (json['size'] as num?)?.toInt(),
  type: json['type'] as String,
  official: json['official'] as bool?,
  publishedAt: json['published_at'] as String?,
);

Map<String, dynamic> _$MovieVideoToJson(_MovieVideo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'iso_639_1': instance.iso6391,
      'iso_3166_1': instance.iso31661,
      'key': instance.key,
      'name': instance.name,
      'site': instance.site,
      'size': instance.size,
      'type': instance.type,
      'official': instance.official,
      'published_at': instance.publishedAt,
    };

_MovieVideosResponse _$MovieVideosResponseFromJson(Map<String, dynamic> json) =>
    _MovieVideosResponse(
      id: (json['id'] as num).toInt(),
      results: (json['results'] as List<dynamic>)
          .map((e) => MovieVideo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MovieVideosResponseToJson(
  _MovieVideosResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'results': instance.results.map((e) => e.toJson()).toList(),
};
