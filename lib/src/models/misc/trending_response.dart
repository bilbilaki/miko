import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';

import '../search/search_multi_response.dart';

part 'trending_response.freezed.dart';
part 'trending_response.g.dart';
//part 'trending_response.hive.dart';

@injectable
@freezed
@HiveType(typeId: 151)
abstract class TrendingResponse with _$TrendingResponse {
  @JsonSerializable(explicitToJson: true)
  const factory TrendingResponse({
    @HiveField(0) required int page,
    @HiveField(1) @JsonKey(name: 'results') required List<SearchResultItem> results,
    @HiveField(2) @JsonKey(name: 'total_pages') required int totalPages,
    @HiveField(3) @JsonKey(name: 'total_results') required int totalResults,
  }) = _TrendingResponse;

  factory TrendingResponse.fromJson(Map<String, dynamic> json) => _$TrendingResponseFromJson(json);
}