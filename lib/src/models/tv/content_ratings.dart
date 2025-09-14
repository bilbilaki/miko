import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';

part 'content_ratings.freezed.dart';
part 'content_ratings.g.dart';
//part 'content_ratings.hive.dart';

@injectable
@freezed
@HiveType(typeId: 139)
abstract class ContentRatingItem with _$ContentRatingItem {
  @JsonSerializable()
  const factory ContentRatingItem({
    @HiveField(0) @JsonKey(name: 'iso_3166_1') required String iso31661,
    @HiveField(1) required String rating,
  }) = _ContentRatingItem;

  factory ContentRatingItem.fromJson(Map<String, dynamic> json) => _$ContentRatingItemFromJson(json);
}

@injectable
@freezed
@HiveType(typeId: 140)
abstract class TvContentRatingsResponse with _$TvContentRatingsResponse {
  @JsonSerializable(explicitToJson: true)
  const factory TvContentRatingsResponse({
    @HiveField(0) required int id,
    @HiveField(1) @JsonKey(name: 'results') required List<ContentRatingItem> results,
  }) = _TvContentRatingsResponse;

  factory TvContentRatingsResponse.fromJson(Map<String, dynamic> json) => _$TvContentRatingsResponseFromJson(json);
}