// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_details.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MovieListItemDetailAdapter extends TypeAdapter<MovieListItemDetail> {
  @override
  final typeId = 125;

  @override
  MovieListItemDetail read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MovieListItemDetail(
      id: (fields[0] as num).toInt(),
      title: fields[1] as String,
      posterPath: fields[2] as String?,
      backdropPath: fields[3] as String?,
      mediaType: fields[4] as String?,
      releaseDate: fields[5] as String?,
      originalTitle: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MovieListItemDetail obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.posterPath)
      ..writeByte(3)
      ..write(obj.backdropPath)
      ..writeByte(4)
      ..write(obj.mediaType)
      ..writeByte(5)
      ..write(obj.releaseDate)
      ..writeByte(6)
      ..write(obj.originalTitle);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovieListItemDetailAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MovieListDetailsAdapter extends TypeAdapter<MovieListDetails> {
  @override
  final typeId = 126;

  @override
  MovieListDetails read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MovieListDetails(
      createdBy: fields[0] as String,
      description: fields[1] as String,
      favoriteCount: (fields[2] as num).toInt(),
      id: (fields[3] as num).toInt(),
      iso6391: fields[4] as String,
      itemCount: fields[5] as String,
      name: fields[6] as String,
      items: (fields[7] as List).cast<MovieListItemDetail>(),
    );
  }

  @override
  void write(BinaryWriter writer, MovieListDetails obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.createdBy)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.favoriteCount)
      ..writeByte(3)
      ..write(obj.id)
      ..writeByte(4)
      ..write(obj.iso6391)
      ..writeByte(5)
      ..write(obj.itemCount)
      ..writeByte(6)
      ..write(obj.name)
      ..writeByte(7)
      ..write(obj.items);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovieListDetailsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MovieListItemDetail _$MovieListItemDetailFromJson(Map<String, dynamic> json) =>
    _MovieListItemDetail(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      mediaType: json['media_type'] as String?,
      releaseDate: json['release_date'] as String?,
      originalTitle: json['original_title'] as String?,
    );

Map<String, dynamic> _$MovieListItemDetailToJson(
  _MovieListItemDetail instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'poster_path': instance.posterPath,
  'backdrop_path': instance.backdropPath,
  'media_type': instance.mediaType,
  'release_date': instance.releaseDate,
  'original_title': instance.originalTitle,
};

_MovieListDetails _$MovieListDetailsFromJson(Map<String, dynamic> json) =>
    _MovieListDetails(
      createdBy: json['createdBy'] as String,
      description: json['description'] as String,
      favoriteCount: (json['favoriteCount'] as num).toInt(),
      id: (json['id'] as num).toInt(),
      iso6391: json['iso6391'] as String,
      itemCount: json['itemCount'] as String,
      name: json['name'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => MovieListItemDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MovieListDetailsToJson(_MovieListDetails instance) =>
    <String, dynamic>{
      'createdBy': instance.createdBy,
      'description': instance.description,
      'favoriteCount': instance.favoriteCount,
      'id': instance.id,
      'iso6391': instance.iso6391,
      'itemCount': instance.itemCount,
      'name': instance.name,
      'items': instance.items.map((e) => e.toJson()).toList(),
    };
