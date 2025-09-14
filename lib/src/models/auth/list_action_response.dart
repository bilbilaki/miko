import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';

part 'list_action_response.freezed.dart';
part 'list_action_response.g.dart';
//part 'list_action_response.hive.dart';

@injectable
@freezed
@HiveType(typeId: 149)
abstract class ListActionResponse with _$ListActionResponse {
  @JsonSerializable()
  const factory ListActionResponse({
    @HiveField(0) required bool success,
    @HiveField(1) @JsonKey(name: 'status_code') required int statusCode,
    @HiveField(2) @JsonKey(name: 'status_message') required String statusMessage,
    @HiveField(3) @JsonKey(name: 'list_id') int? listId,
  }) = _ListActionResponse;

  factory ListActionResponse.fromJson(Map<String, dynamic> json) => _$ListActionResponseFromJson(json);
}