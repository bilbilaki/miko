import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';

part 'movie_list_response.freezed.dart';
part 'movie_list_response.g.dart';
//part 'movie_list_response.hive.dart';

@injectable
@freezed
@HiveType(typeId: 100)
abstract class MovieListResponse with _$MovieListResponse {
  @JsonSerializable(explicitToJson: true)
  const factory MovieListResponse({
    @HiveField(0) required int page,
    @HiveField(1) @JsonKey(name: 'results') required List<MovieListItem> results,
    @HiveField(2) @JsonKey(name: 'total_results') required int totalResults,
    @HiveField(3) @JsonKey(name: 'total_pages') required int totalPages,
  }) = _MovieListResponse;

  factory MovieListResponse.fromJson(Map<String, dynamic> json) => _$MovieListResponseFromJson(json);
}

@injectable
@freezed
@HiveType(typeId: 101)
abstract class MovieListItem with _$MovieListItem {
  @JsonSerializable()
  const factory MovieListItem({
    @HiveField(0) required int id,
    @HiveField(1) required String title,
    @HiveField(2) @JsonKey(name: 'original_title') String? originalTitle,
    @HiveField(3) @JsonKey(name: 'overview') String? overview,
    @HiveField(4) @JsonKey(name: 'poster_path') String? posterPath,
    @HiveField(5) @JsonKey(name: 'backdrop_path') String? backdropPath,
    @HiveField(6) @JsonKey(name: 'release_date') String? releaseDate,
    @HiveField(7) @JsonKey(name: 'vote_average') double? voteAverage,
    @HiveField(8) @JsonKey(name: 'vote_count') int? voteCount,
    @HiveField(9) double? popularity,
    @HiveField(10) bool? adult,
    @HiveField(11) @JsonKey(name: 'genre_ids') List<int>? genreIds,
    @HiveField(12) bool? video,
    @HiveField(13) @JsonKey(name: 'original_language') String? originalLanguage,
  }) = _MovieListItem;

  factory MovieListItem.fromJson(Map<String, dynamic> json) => _$MovieListItemFromJson(json);
}