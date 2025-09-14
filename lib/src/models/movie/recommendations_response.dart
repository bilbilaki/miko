import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';
import 'movie_list_response.dart'; // uses MovieListItem

part 'recommendations_response.freezed.dart';
part 'recommendations_response.g.dart';
//part 'recommendations_response.hive.dart';

@injectable
@freezed
@HiveType(typeId: 110)
abstract class MovieRecommendationsResponse with _$MovieRecommendationsResponse {
  @JsonSerializable(explicitToJson: true)
  const factory MovieRecommendationsResponse({
    @HiveField(0) required int page,
    @HiveField(1) @JsonKey(name: 'results') required List<MovieListItem> results,
    @HiveField(2) @JsonKey(name: 'total_results') required int totalResults,
    @HiveField(3) @JsonKey(name: 'total_pages') required int totalPages,
  }) = _MovieRecommendationsResponse;

  factory MovieRecommendationsResponse.fromJson(Map<String, dynamic> json) => _$MovieRecommendationsResponseFromJson(json);
}