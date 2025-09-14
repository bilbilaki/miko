import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';

part 'review.freezed.dart';
part 'review.g.dart';
//part 'review.hive.dart';

@injectable
@freezed
@HiveType(typeId: 111)
abstract class MovieReview with _$MovieReview {
 @JsonSerializable()
 const factory MovieReview({
 @HiveField(0) required String id,
 @HiveField(1) required String author,
 @HiveField(2) @JsonKey(name: 'author_details') required Map<String, Object?> authorDetails,
 @HiveField(3) required String content,
 @HiveField(4) @JsonKey(name: 'created_at') required String createdAt,
 @HiveField(5) @JsonKey(name: 'updated_at') required String updatedAt,
 @HiveField(6) @JsonKey(name: 'url') String? url,
 }) = _MovieReview;

 factory MovieReview.fromJson(Map<String, dynamic> json) => _$MovieReviewFromJson(json);
}

@injectable
@freezed
@HiveType(typeId: 112)
abstract class MovieReviewsResponse with _$MovieReviewsResponse {
 @JsonSerializable(explicitToJson: true)
 const factory MovieReviewsResponse({
 @HiveField(0) required int id,
 @HiveField(1) @JsonKey(name: 'page') required int page,
 @HiveField(2) @JsonKey(name: 'results') required List<MovieReview> results,
 @HiveField(3) @JsonKey(name: 'total_pages') required int totalPages,
 @HiveField(4) @JsonKey(name: 'total_results') required int totalResults,
 }) = _MovieReviewsResponse;

 factory MovieReviewsResponse.fromJson(Map<String, dynamic> json) => _$MovieReviewsResponseFromJson(json);
}