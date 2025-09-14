import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';

import '../movie/movie_list_response.dart';

part 'discover_movies_response.freezed.dart';
part 'discover_movies_response.g.dart';
//part 'discover_movies_response.hive.dart';

@injectable
@freezed
@HiveType(typeId: 144)
abstract class DiscoverMoviesResponse with _$DiscoverMoviesResponse {
  @JsonSerializable(explicitToJson: true)
  const factory DiscoverMoviesResponse({
    @HiveField(0) required int page,
    @HiveField(1) @JsonKey(name: 'results') required List<MovieListItem> results,
    @HiveField(2) @JsonKey(name: 'total_results') required int totalResults,
    @HiveField(3) @JsonKey(name: 'total_pages') required int totalPages,
  }) = _DiscoverMoviesResponse;

  factory DiscoverMoviesResponse.fromJson(Map<String, dynamic> json) => _$DiscoverMoviesResponseFromJson(json);
}