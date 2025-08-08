// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'series_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SeriesImpl _$$SeriesImplFromJson(Map<String, dynamic> json) => _$SeriesImpl(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      status: json['status'] as String? ?? '',
      releaseDate: json['release_date'] == null
          ? null
          : DateTime.parse(json['release_date'] as String),
      runtime: (json['runtime'] as num?)?.toInt(),
      overview: json['overview'] as String? ?? '',
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      voteCount: (json['vote_count'] as num?)?.toInt() ?? 0,
      genres:
          json['genres'] == null ? const [] : genresFromJson(json['genres']),
      keywords: json['keywords'] == null
          ? const []
          : keywordsFromJson(json['keywords']),
      originalName: json['original_name'] as String? ?? '',
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      popularity: (json['popularity'] as num?)?.toDouble() ?? 0.0,
      originalLanguage: json['original_language'] as String? ?? '',
      type: json['type'] as String? ?? '',
      episodesNumber: (json['episodes_number'] as num?)?.toInt(),
      seasonsNumber: (json['seasons_number'] as num?)?.toInt(),
      homepage: json['homepage'] as String?,
      cast: json['cast'] == null ? const [] : castFromJson(json['cast']),
      crew: json['crew'] == null ? const [] : crewFromJson(json['crew']),
      videos:
          json['videos'] == null ? const [] : videosFromJson(json['videos']),
    );

Map<String, dynamic> _$$SeriesImplToJson(_$SeriesImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'status': instance.status,
      'release_date': instance.releaseDate?.toIso8601String(),
      'runtime': instance.runtime,
      'overview': instance.overview,
      'vote_average': instance.voteAverage,
      'vote_count': instance.voteCount,
      'genres': genresToJson(instance.genres),
      'keywords': keywordsToJson(instance.keywords),
      'original_name': instance.originalName,
      'poster_path': instance.posterPath,
      'backdrop_path': instance.backdropPath,
      'popularity': instance.popularity,
      'original_language': instance.originalLanguage,
      'type': instance.type,
      'episodes_number': instance.episodesNumber,
      'seasons_number': instance.seasonsNumber,
      'homepage': instance.homepage,
      'cast': castToJson(instance.cast),
      'crew': crewToJson(instance.crew),
      'videos': videosToJson(instance.videos),
    };
