// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MovieImageAdapter extends TypeAdapter<MovieImage> {
  @override
  final typeId = 108;

  @override
  MovieImage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MovieImage(
      filePath: fields[0] as String,
      width: (fields[1] as num).toInt(),
      height: (fields[2] as num).toInt(),
      iso6391: fields[3] as String?,
      aspectRatio: (fields[4] as num).toDouble(),
      voteAverage: (fields[5] as num?)?.toDouble(),
      voteCount: (fields[6] as num?)?.toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, MovieImage obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.filePath)
      ..writeByte(1)
      ..write(obj.width)
      ..writeByte(2)
      ..write(obj.height)
      ..writeByte(3)
      ..write(obj.iso6391)
      ..writeByte(4)
      ..write(obj.aspectRatio)
      ..writeByte(5)
      ..write(obj.voteAverage)
      ..writeByte(6)
      ..write(obj.voteCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovieImageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MovieImagesResponseAdapter extends TypeAdapter<MovieImagesResponse> {
  @override
  final typeId = 109;

  @override
  MovieImagesResponse read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MovieImagesResponse(
      id: (fields[0] as num).toInt(),
      backdrops: (fields[1] as List).cast<MovieImage>(),
      posters: (fields[2] as List).cast<MovieImage>(),
    );
  }

  @override
  void write(BinaryWriter writer, MovieImagesResponse obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.backdrops)
      ..writeByte(2)
      ..write(obj.posters);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovieImagesResponseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MovieImage _$MovieImageFromJson(Map<String, dynamic> json) => _MovieImage(
  filePath: json['file_path'] as String,
  width: (json['width'] as num).toInt(),
  height: (json['height'] as num).toInt(),
  iso6391: json['iso_639_1'] as String?,
  aspectRatio: (json['aspect_ratio'] as num).toDouble(),
  voteAverage: (json['vote_average'] as num?)?.toDouble(),
  voteCount: (json['vote_count'] as num?)?.toInt(),
);

Map<String, dynamic> _$MovieImageToJson(_MovieImage instance) =>
    <String, dynamic>{
      'file_path': instance.filePath,
      'width': instance.width,
      'height': instance.height,
      'iso_639_1': instance.iso6391,
      'aspect_ratio': instance.aspectRatio,
      'vote_average': instance.voteAverage,
      'vote_count': instance.voteCount,
    };

_MovieImagesResponse _$MovieImagesResponseFromJson(Map<String, dynamic> json) =>
    _MovieImagesResponse(
      id: (json['id'] as num).toInt(),
      backdrops: (json['backdrops'] as List<dynamic>)
          .map((e) => MovieImage.fromJson(e as Map<String, dynamic>))
          .toList(),
      posters: (json['posters'] as List<dynamic>)
          .map((e) => MovieImage.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MovieImagesResponseToJson(
  _MovieImagesResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'backdrops': instance.backdrops.map((e) => e.toJson()).toList(),
  'posters': instance.posters.map((e) => e.toJson()).toList(),
};
