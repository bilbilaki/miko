import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';

part 'guest_session.freezed.dart';
part 'guest_session.g.dart';
//part 'guest_session.hive.dart';

@injectable
@freezed
@HiveType(typeId: 145)
abstract class GuestSession with _$GuestSession {
  @JsonSerializable()
  const factory GuestSession({
    @HiveField(0) required bool success,
    @HiveField(1) @JsonKey(name: 'guest_session_id') required String guestSessionId,
    @HiveField(2) @JsonKey(name: 'expires_at') required String expiresAt,
  }) = _GuestSession;

  factory GuestSession.fromJson(Map<String, dynamic> json) => _$GuestSessionFromJson(json);
}