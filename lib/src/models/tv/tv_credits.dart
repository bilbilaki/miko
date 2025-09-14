import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';

part 'tv_credits.freezed.dart';
part 'tv_credits.g.dart';
//part 'tv_credits.hive.dart';

@injectable
@freezed
@HiveType(typeId: 132)
abstract class TvCast with _$TvCast {
  @JsonSerializable()
  const factory TvCast({
    @HiveField(0) int? castId,
    @HiveField(1) @JsonKey(name: 'character') String? character,
    @HiveField(2) @JsonKey(name: 'credit_id') required String creditId,
    @HiveField(3) int? gender,
    @HiveField(4) required int id,
    @HiveField(5) required String name,
    @HiveField(6) int? order,
    @HiveField(7) @JsonKey(name: 'profile_path') String? profilePath,
    @HiveField(8) @JsonKey(name: 'known_for_department') String? knownForDepartment,
    @HiveField(9) double? popularity,
  }) = _TvCast;

  factory TvCast.fromJson(Map<String, dynamic> json) => _$TvCastFromJson(json);
}

@injectable
@freezed
@HiveType(typeId: 133)
abstract class TvCrew with _$TvCrew {
  @JsonSerializable()
  const factory TvCrew({
    @HiveField(0) @JsonKey(name: 'credit_id') required String creditId,
    @HiveField(1) String? department,
    @HiveField(2) String? job,
    @HiveField(3) int? gender,
    @HiveField(4) required int id,
    @HiveField(5) required String name,
    @HiveField(6) @JsonKey(name: 'profile_path') String? profilePath,
    @HiveField(7) @JsonKey(name: 'known_for_department') String? knownForDepartment,
    @HiveField(8) double? popularity,
  }) = _TvCrew;

  factory TvCrew.fromJson(Map<String, dynamic> json) => _$TvCrewFromJson(json);
}

@injectable
@freezed
@HiveType(typeId: 134)
abstract class TvCreditsResponse with _$TvCreditsResponse {
  @JsonSerializable(explicitToJson: true)
  const factory TvCreditsResponse({
    @HiveField(0) required int id,
    @HiveField(1) @JsonKey(name: 'cast') required List<TvCast> cast,
    @HiveField(2) @JsonKey(name: 'crew') required List<TvCrew> crew,
  }) = _TvCreditsResponse;

  factory TvCreditsResponse.fromJson(Map<String, dynamic> json) => _$TvCreditsResponseFromJson(json);
}