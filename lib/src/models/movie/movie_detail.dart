import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';

import 'production.dart';

part 'movie_detail.freezed.dart';
part 'movie_detail.g.dart';

@injectable
@freezed
@HiveType(typeId: 60, adapterName: 'MovieDetailAdapter')
abstract class MovieDetail with _$MovieDetail {
  @JsonSerializable(explicitToJson: true)
  factory MovieDetail({
    @HiveField(0) @Default(true) bool adult,
    @HiveField(1) @JsonKey(name: 'backdrop_path') String? backdropPath,
    @HiveField(2) @JsonKey(name: 'belongs_to_collection') String? belongsToCollection,
    @HiveField(3) @Default(0) int budget,
    @HiveField(4) @JsonKey(name: 'genres') List<Genre>? genres,
    @HiveField(5) String? homepage,
    @HiveField(6) required int id,
    @HiveField(7) @JsonKey(name: 'imdb_id') String? imdbId,
    @HiveField(8) @JsonKey(name: 'original_language') String? originalLanguage,
    @HiveField(9) @JsonKey(name: 'original_title') String? originalTitle,
    @HiveField(10) String? overview,
    @HiveField(11) @Default(0.0) double popularity,
    @HiveField(12) @JsonKey(name: 'poster_path') String? posterPath,
    @HiveField(13) @JsonKey(name: 'production_companies') List<ProductionCompany>? productionCompanies,
    @HiveField(14) @JsonKey(name: 'production_countries') List<ProductionCountry>? productionCountries,
    @HiveField(15) @JsonKey(name: 'release_date') String? releaseDate,
    @HiveField(16) @Default(0) int revenue,
    @HiveField(17) @Default(0) int runtime,
    @HiveField(18) @JsonKey(name: 'spoken_languages') List<SpokenLanguage>? spokenLanguages,
    @HiveField(19) String? status,
    @HiveField(20) String? tagline,
    @HiveField(21) required String title,
    @HiveField(22) @Default(true) bool video,
    @HiveField(23) @JsonKey(name: 'vote_average') @Default(0.0) double voteAverage,
    @HiveField(24) @JsonKey(name: 'vote_count') @Default(0) int voteCount,
  }) = _MovieDetail;

  factory MovieDetail.fromJson(Map<String, dynamic> json) => _$MovieDetailFromJson(json);
}

@freezed
@HiveType(typeId: 61, adapterName: 'GenreAdapter')
abstract class Genre with _$Genre {
  @JsonSerializable()
  factory Genre({
    @HiveField(0) @Default(0) int id,
    @HiveField(1) required String name,
  }) = _Genre;

  factory Genre.fromJson(Map<String, dynamic> json) => _$GenreFromJson(json);
}



@freezed
@HiveType(typeId: 64, adapterName: 'SpokenLanguageAdapter')
abstract class SpokenLanguage with _$SpokenLanguage {
  @JsonSerializable()
  factory SpokenLanguage({
    @HiveField(0) @JsonKey(name: 'english_name') String? englishName,
    @HiveField(1) @JsonKey(name: 'iso_639_1') String? iso6391,
    @HiveField(2) required String name,
  }) = _SpokenLanguage;

  factory SpokenLanguage.fromJson(Map<String, dynamic> json) => _$SpokenLanguageFromJson(json);
}