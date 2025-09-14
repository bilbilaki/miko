import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';

import '../movie/list_details.dart';

part 'search_multi_response.freezed.dart';
part 'search_multi_response.g.dart';
//part 'search_multi_response.hive.dart';

@injectable
@freezed
@HiveType(typeId: 141)
abstract class SearchResultItem with _$SearchResultItem {
  @JsonSerializable(explicitToJson: true)
  const factory SearchResultItem({
    @HiveField(0) required int id,
    @HiveField(1) @JsonKey(name: 'media_type') required String mediaType,
    // Movie fields
    @HiveField(2) String? title,
    @HiveField(3) @JsonKey(name: 'original_title') String? originalTitle,
    @HiveField(4) @JsonKey(name: 'release_date') String? releaseDate,
    // TV fields
    @HiveField(5) String? name,
    @HiveField(6) @JsonKey(name: 'original_name') String? originalName,
    @HiveField(7) @JsonKey(name: 'first_air_date') String? firstAirDate,
    // Common
    @HiveField(8) String? overview,
    @HiveField(9) @JsonKey(name: 'poster_path') String? posterPath,
    @HiveField(10) @JsonKey(name: 'backdrop_path') String? backdropPath,
    @HiveField(11) @JsonKey(name: 'profile_path') String? profilePath,
    @HiveField(12) double? popularity,
    @HiveField(13) @JsonKey(name: 'vote_average') double? voteAverage,
    @HiveField(14) @JsonKey(name: 'vote_count') int? voteCount,
    @HiveField(15) List<MovieListItemDetail>? knownFor, // for people search results
    @HiveField(16) @JsonKey(name: 'known_for_department') String? knownForDepartment,
    @HiveField(17) int? gender,
    @HiveField(18) @JsonKey(name: 'adult') bool? adult,
    @HiveField(19) @JsonKey(name: 'original_language') String? originalLanguage,
    @HiveField(20) @JsonKey(name: 'genre_ids') List<int>? genreIds,
  }) = _SearchResultItem;

  factory SearchResultItem.fromJson(Map<String, dynamic> json) => _$SearchResultItemFromJson(json);
}

@injectable
@freezed
@HiveType(typeId: 142)
abstract class SearchMultiResponse with _$SearchMultiResponse {
  @JsonSerializable(explicitToJson: true)
  const factory SearchMultiResponse({
    @HiveField(0) required int page,
    @HiveField(1) @JsonKey(name: 'results') required List<SearchResultItem> results,
    @HiveField(2) @JsonKey(name: 'total_results') required int totalResults,
    @HiveField(3) @JsonKey(name: 'total_pages') required int totalPages,
  }) = _SearchMultiResponse;

  factory SearchMultiResponse.fromJson(Map<String, dynamic> json) => _$SearchMultiResponseFromJson(json);
}