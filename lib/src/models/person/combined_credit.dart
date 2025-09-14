import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';

part 'combined_credit.freezed.dart';
part 'combined_credit.g.dart';

@injectable
@freezed
@HiveType(typeId: 110, adapterName: 'PersonCreditsAdapter')
 abstract class PersonCredits with _$PersonCredits {
  @JsonSerializable(explicitToJson: true)
  factory PersonCredits({
    @HiveField(0) required List<CastCredit> cast,
    @HiveField(1) required List<CrewCredit> crew,
  }) = _PersonCredits;

  factory PersonCredits.fromJson(Map<String, dynamic> json) => _$PersonCreditsFromJson(json);
}

@freezed
@HiveType(typeId: 111, adapterName: 'CastCreditAdapter')
 abstract class CastCredit with _$CastCredit {
  @JsonSerializable()
  factory CastCredit({
    @HiveField(0) @Default(true) bool adult,
    @HiveField(1) @JsonKey(name: 'backdrop_path') String? backdropPath,
    @HiveField(2) @JsonKey(name: 'genre_ids') List<int>? genreIds,
    @HiveField(3) @Default(0) int id,
    @HiveField(4) @JsonKey(name: 'original_language') String? originalLanguage,
    @HiveField(5) @JsonKey(name: 'original_title') String? originalTitle,
    @HiveField(6) String? overview,
    @HiveField(7) @Default(0.0) double popularity,
    @HiveField(8) @JsonKey(name: 'poster_path') String? posterPath,
    @HiveField(9) @JsonKey(name: 'release_date') String? releaseDate,
    @HiveField(10) String? title,
    @HiveField(11) @Default(true) bool video,
    @HiveField(12) @JsonKey(name: 'vote_average') @Default(0.0) double voteAverage,
    @HiveField(13) @JsonKey(name: 'vote_count') @Default(0) int voteCount,
    @HiveField(14) String? character,
    @HiveField(15) @JsonKey(name: 'credit_id') String? creditId,
    @HiveField(16) @Default(0) int order,
    @HiveField(17) @JsonKey(name: 'media_type') String? mediaType,
  }) = _CastCredit;

  factory CastCredit.fromJson(Map<String, dynamic> json) => _$CastCreditFromJson(json);
}

@freezed
@HiveType(typeId: 112, adapterName: 'CrewCreditAdapter')
 abstract class CrewCredit with _$CrewCredit {
  @JsonSerializable()
  factory CrewCredit({
    @HiveField(0) @Default(true) bool adult,
    @HiveField(1) @JsonKey(name: 'backdrop_path') String? backdropPath,
    @HiveField(2) @JsonKey(name: 'genre_ids') List<int>? genreIds,
    @HiveField(3) @Default(0) int id,
    @HiveField(4) @JsonKey(name: 'original_language') String? originalLanguage,
    @HiveField(5) @JsonKey(name: 'original_title') String? originalTitle,
    @HiveField(6) String? overview,
    @HiveField(7) @Default(0.0) double popularity,
    @HiveField(8) @JsonKey(name: 'poster_path') String? posterPath,
    @HiveField(9) @JsonKey(name: 'release_date') String? releaseDate,
    @HiveField(10) String? title,
    @HiveField(11) @Default(true) bool video,
    @HiveField(12) @JsonKey(name: 'vote_average') @Default(0.0) double voteAverage,
    @HiveField(13) @JsonKey(name: 'vote_count') @Default(0) int voteCount,
    @HiveField(14) @JsonKey(name: 'credit_id') String? creditId,
    @HiveField(15) String? department,
    @HiveField(16) String? job,
    @HiveField(17) @JsonKey(name: 'media_type') String? mediaType,
  }) = _CrewCredit;

  factory CrewCredit.fromJson(Map<String, dynamic> json) => _$CrewCreditFromJson(json);
}