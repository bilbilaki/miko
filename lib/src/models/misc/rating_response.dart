import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';

part 'rating_response.freezed.dart';
part 'rating_response.g.dart';
//part 'rating_response.hive.dart';

@injectable
@freezed
@HiveType(typeId: 150)
abstract class RatingResponse with _$RatingResponse {
  @JsonSerializable()
  const factory RatingResponse({
    @HiveField(0) required bool success,
    @HiveField(1) @JsonKey(name: 'status_code') required int statusCode,
    @HiveField(2) @JsonKey(name: 'status_message') required String statusMessage,
  }) = _RatingResponse;

  factory RatingResponse.fromJson(Map<String, dynamic> json) => _$RatingResponseFromJson(json);
}