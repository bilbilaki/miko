import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';

part 'movie_credits.freezed.dart';
part 'movie_credits.g.dart';

@injectable
@freezed
@HiveType(typeId: 120, adapterName: 'MovieCreditsAdapter')
abstract class MovieCredits with _$MovieCredits {
  @JsonSerializable(explicitToJson: true)
  factory MovieCredits({
    @HiveField(0) required int id,
    @HiveField(1) required List<MovieCastMember> cast,
    @HiveField(2) required List<MovieCrewMember> crew,
  }) = _MovieCredits;

  factory MovieCredits.fromJson(Map<String, dynamic> json) => _$MovieCreditsFromJson(json);
}

@freezed
@HiveType(typeId: 121, adapterName: 'MovieCastMemberAdapter')
abstract class MovieCastMember with _$MovieCastMember {
  @JsonSerializable()
  factory MovieCastMember({
    @HiveField(0) @Default(true) bool adult,
    @HiveField(1) @Default(0) int gender,
    @HiveField(2) @Default(0) int id,
    @HiveField(3) @JsonKey(name: 'known_for_department') String? knownForDepartment,
    @HiveField(4) required String name,
    @HiveField(5) @JsonKey(name: 'original_name') String? originalName,
    @HiveField(6) @Default(0.0) double popularity,
    @HiveField(7) @JsonKey(name: 'profile_path') String? profilePath,
    @HiveField(8) @JsonKey(name: 'cast_id') @Default(0) int castId,
    @HiveField(9) String? character,
    @HiveField(10) @JsonKey(name: 'credit_id') String? creditId,
    @HiveField(11) @Default(0) int order,
  }) = _MovieCastMember;

  factory MovieCastMember.fromJson(Map<String, dynamic> json) => _$MovieCastMemberFromJson(json);
}

@freezed
@HiveType(typeId: 122, adapterName: 'MovieCrewMemberAdapter')
abstract class MovieCrewMember with _$MovieCrewMember {
  @JsonSerializable()
  factory MovieCrewMember({
    @HiveField(0) @Default(true) bool adult,
    @HiveField(1) @Default(0) int gender,
    @HiveField(2) @Default(0) int id,
    @HiveField(3) @JsonKey(name: 'known_for_department') String? knownForDepartment,
    @HiveField(4) required String name,
    @HiveField(5) @JsonKey(name: 'original_name') String? originalName,
    @HiveField(6) @Default(0.0) double popularity,
    @HiveField(7) @JsonKey(name: 'profile_path') String? profilePath,
    @HiveField(8) @JsonKey(name: 'credit_id') String? creditId,
    @HiveField(9) String? department,
    @HiveField(10) String? job,
  }) = _MovieCrewMember;

  factory MovieCrewMember.fromJson(Map<String, dynamic> json) => _$MovieCrewMemberFromJson(json);
}