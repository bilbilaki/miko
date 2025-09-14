import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';

part 'tv_lists.freezed.dart';
part 'tv_lists.g.dart';

@injectable
@freezed
@HiveType(typeId: 90, adapterName: 'TvListResponseAdapter')
abstract class TvListResponse with _$TvListResponse {
  @JsonSerializable(explicitToJson: true)
  factory TvListResponse({
    @HiveField(0) required int page,
    @HiveField(1) @JsonKey(name: 'results') required List<TvSummary> results,
    @HiveField(2) @JsonKey(name: 'total_pages') @Default(0) int totalPages,
    @HiveField(3) @JsonKey(name: 'total_results') @Default(0) int totalResults,
  }) = _TvListResponse;

  factory TvListResponse.fromJson(Map<String, dynamic> json) => _$TvListResponseFromJson(json);
}

@freezed
@HiveType(typeId: 91, adapterName: 'TvSummaryAdapter')
abstract class TvSummary with _$TvSummary {
  @JsonSerializable()
  factory TvSummary({
    @HiveField(0) @JsonKey(name: 'backdrop_path') String? backdropPath,
    @HiveField(1) @JsonKey(name: 'first_air_date') String? firstAirDate,
    @HiveField(2) @JsonKey(name: 'genre_ids') List<int>? genreIds,
    @HiveField(3) required int id,
    @HiveField(4) required String name,
    @HiveField(5) @JsonKey(name: 'origin_country') List<String>? originCountry,
    @HiveField(6) @JsonKey(name: 'original_language') String? originalLanguage,
    @HiveField(7) @JsonKey(name: 'original_name') String? originalName,
    @HiveField(8) String? overview,
    @HiveField(9) @Default(0.0) double popularity,
    @HiveField(10) @JsonKey(name: 'poster_path') String? posterPath,
    @HiveField(11) @JsonKey(name: 'vote_average') @Default(0.0) double voteAverage,
    @HiveField(12) @JsonKey(name: 'vote_count') @Default(0) int voteCount,
  }) = _TvSummary;

  factory TvSummary.fromJson(Map<String, dynamic> json) => _$TvSummaryFromJson(json);
}