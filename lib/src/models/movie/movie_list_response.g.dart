// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_list_response.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MovieListResponseAdapter extends TypeAdapter<MovieListResponse> {
  @override
  final typeId = 100;

  @override
  MovieListResponse read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MovieListResponse(
      page: (fields[0] as num).toInt(),
      results: (fields[1] as List).cast<MovieListItem>(),
      totalResults: (fields[2] as num).toInt(),
      totalPages: (fields[3] as num).toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, MovieListResponse obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.page)
      ..writeByte(1)
      ..write(obj.results)
      ..writeByte(2)
      ..write(obj.totalResults)
      ..writeByte(3)
      ..write(obj.totalPages);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovieListResponseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MovieListItemAdapter extends TypeAdapter<MovieListItem> {
  @override
  final typeId = 101;

  @override
  MovieListItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MovieListItem(
      id: (fields[0] as num).toInt(),
      title: fields[1] as String,
      originalTitle: fields[2] as String?,
      overview: fields[3] as String?,
      posterPath: fields[4] as String?,
      backdropPath: fields[5] as String?,
      releaseDate: fields[6] as String?,
      voteAverage: (fields[7] as num?)?.toDouble(),
      voteCount: (fields[8] as num?)?.toInt(),
      popularity: (fields[9] as num?)?.toDouble(),
      adult: fields[10] as bool?,
      genreIds: (fields[11] as List?)?.cast<int>(),
      video: fields[12] as bool?,
      originalLanguage: fields[13] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MovieListItem obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.originalTitle)
      ..writeByte(3)
      ..write(obj.overview)
      ..writeByte(4)
      ..write(obj.posterPath)
      ..writeByte(5)
      ..write(obj.backdropPath)
      ..writeByte(6)
      ..write(obj.releaseDate)
      ..writeByte(7)
      ..write(obj.voteAverage)
      ..writeByte(8)
      ..write(obj.voteCount)
      ..writeByte(9)
      ..write(obj.popularity)
      ..writeByte(10)
      ..write(obj.adult)
      ..writeByte(11)
      ..write(obj.genreIds)
      ..writeByte(12)
      ..write(obj.video)
      ..writeByte(13)
      ..write(obj.originalLanguage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovieListItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MovieListResponse _$MovieListResponseFromJson(Map<String, dynamic> json) =>
    _MovieListResponse(
      page: (json['page'] as num).toInt(),
      results: (json['results'] as List<dynamic>)
          .map((e) => MovieListItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalResults: (json['total_results'] as num).toInt(),
      totalPages: (json['total_pages'] as num).toInt(),
    );

Map<String, dynamic> _$MovieListResponseToJson(_MovieListResponse instance) =>
    <String, dynamic>{
      'page': instance.page,
      'results': instance.results.map((e) => e.toJson()).toList(),
      'total_results': instance.totalResults,
      'total_pages': instance.totalPages,
    };

_MovieListItem _$MovieListItemFromJson(Map<String, dynamic> json) =>
    _MovieListItem(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      originalTitle: json['original_title'] as String?,
      overview: json['overview'] as String?,
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      releaseDate: json['release_date'] as String?,
      voteAverage: (json['vote_average'] as num?)?.toDouble(),
      voteCount: (json['vote_count'] as num?)?.toInt(),
      popularity: (json['popularity'] as num?)?.toDouble(),
      adult: json['adult'] as bool?,
      genreIds: (json['genre_ids'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      video: json['video'] as bool?,
      originalLanguage: json['original_language'] as String?,
    );

Map<String, dynamic> _$MovieListItemToJson(_MovieListItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'original_title': instance.originalTitle,
      'overview': instance.overview,
      'poster_path': instance.posterPath,
      'backdrop_path': instance.backdropPath,
      'release_date': instance.releaseDate,
      'vote_average': instance.voteAverage,
      'vote_count': instance.voteCount,
      'popularity': instance.popularity,
      'adult': instance.adult,
      'genre_ids': instance.genreIds,
      'video': instance.video,
      'original_language': instance.originalLanguage,
    };
