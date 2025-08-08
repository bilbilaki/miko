// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movies_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MovieImpl _$$MovieImplFromJson(Map<String, dynamic> json) => _$MovieImpl(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      voteCount: (json['vote_count'] as num?)?.toInt() ?? 0,
      status: json['status'] as String? ?? '',
      releaseDate: json['release_date'] == null
          ? null
          : DateTime.parse(json['release_date'] as String),
      revenue: (json['revenue'] as num?)?.toInt(),
      runtime: (json['runtime'] as num?)?.toInt(),
      adult: json['adult'] == null ? false : _boolFromJson(json['adult']),
      backdropPath: json['backdrop_path'] as String?,
      budget: (json['budget'] as num?)?.toInt(),
      homepage: json['homepage'] as String?,
      imdbId: json['imdb_id'] as String?,
      originalLanguage: json['original_language'] as String? ?? '',
      originalTitle: json['original_title'] as String? ?? '',
      overview: json['overview'] as String? ?? '',
      popularity: (json['popularity'] as num?)?.toDouble() ?? 0.0,
      posterPath: json['poster_path'] as String?,
      tagline: json['tagline'] as String?,
      genres: json['genres'] == null
          ? const []
          : _movieGenresFromJson(json['genres']),
      productionCompanies: json['production_companies'] == null
          ? const []
          : _movieProductionCompaniesFromJson(json['production_companies']),
      productionCountries: json['production_countries'] == null
          ? const []
          : _movieProductionCountriesFromJson(json['production_countries']),
      spokenLanguages: json['spoken_languages'] == null
          ? const []
          : _movieSpokenLanguagesFromJson(json['spoken_languages']),
      keywords: json['keywords'] == null
          ? const []
          : _movieKeywordsFromJson(json['keywords']),
      source: json['source'] as String?,
      downloadLinks: json['download_links'] == null
          ? const []
          : _movieStringListFromJson(json['download_links']),
    );

Map<String, dynamic> _$$MovieImplToJson(_$MovieImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'vote_average': instance.voteAverage,
      'vote_count': instance.voteCount,
      'status': instance.status,
      'release_date': instance.releaseDate?.toIso8601String(),
      'revenue': instance.revenue,
      'runtime': instance.runtime,
      'adult': _boolToJson(instance.adult),
      'backdrop_path': instance.backdropPath,
      'budget': instance.budget,
      'homepage': instance.homepage,
      'imdb_id': instance.imdbId,
      'original_language': instance.originalLanguage,
      'original_title': instance.originalTitle,
      'overview': instance.overview,
      'popularity': instance.popularity,
      'poster_path': instance.posterPath,
      'tagline': instance.tagline,
      'genres': _movieGenresToJson(instance.genres),
      'production_companies':
          _movieProductionCompaniesToJson(instance.productionCompanies),
      'production_countries':
          _movieProductionCountriesToJson(instance.productionCountries),
      'spoken_languages': _movieSpokenLanguagesToJson(instance.spokenLanguages),
      'keywords': _movieKeywordsToJson(instance.keywords),
      'source': instance.source,
      'download_links': _movieStringListToJson(instance.downloadLinks),
    };
