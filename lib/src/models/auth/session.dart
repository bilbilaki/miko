import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';

part 'session.freezed.dart';
part 'session.g.dart';
//part 'session.hive.dart';

@injectable
@freezed
@HiveType(typeId: 146)
abstract class SessionResponse with _$SessionResponse {
  @JsonSerializable()
  const factory SessionResponse({
    @HiveField(0) required bool success,
    @HiveField(1) @JsonKey(name: 'session_id') required String sessionId,
  }) = _SessionResponse;

  factory SessionResponse.fromJson(Map<String, dynamic> json) => _$SessionResponseFromJson(json);
}