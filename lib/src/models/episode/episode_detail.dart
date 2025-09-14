import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';



part 'episode_detail.freezed.dart';
part 'episode_detail.g.dart';
//part 'episode_detail.hive.dart';

@injectable
@freezed
@HiveType(typeId: 50, adapterName: 'EpisodeDetailAdapter')
abstract class EpisodeDetail with _$EpisodeDetail {
  @JsonSerializable(explicitToJson: true)
  factory EpisodeDetail({
    @HiveField(0) @JsonKey(name: 'air_date') String? airDate,
    @HiveField(1) @JsonKey(name: 'crew') List<CrewMember>? crew,
    @HiveField(2) @JsonKey(name: 'guest_stars') List<GuestStar>? guestStars,
    @HiveField(3) required String name,
    @HiveField(4) String? overview,
    @HiveField(5) required int id,
    @HiveField(6) @JsonKey(name: 'production_code') String? productionCode,
    @HiveField(7) @JsonKey(name: 'runtime') int? runtime,
    @HiveField(8) @JsonKey(name: 'season_number') int? seasonNumber,
    @HiveField(9) @JsonKey(name: 'episode_number') int? episodeNumber,
    @HiveField(10) @JsonKey(name: 'still_path') String? stillPath,
    @HiveField(11) @JsonKey(name: 'vote_average') double? voteAverage,
    @HiveField(12) @JsonKey(name: 'vote_count') int? voteCount,
  }) = _EpisodeDetail;

  factory EpisodeDetail.fromJson(Map<String, dynamic> json) => _$EpisodeDetailFromJson(json);
}

@freezed
@HiveType(typeId: 51, adapterName: 'CrewMemberAdapter')
abstract class CrewMember with _$CrewMember {
  @JsonSerializable()
  factory CrewMember({
    @HiveField(0) String? department,
    @HiveField(1) String? job,
    @HiveField(2) @JsonKey(name: 'credit_id') String? creditId,
    @HiveField(3) @Default(true) bool adult,
    @HiveField(4) @Default(0) int gender,
    @HiveField(5) @Default(0) int id,
    @HiveField(6) @JsonKey(name: 'known_for_department') String? knownForDepartment,
    @HiveField(7) required String name,
    @HiveField(8) @JsonKey(name: 'original_name') String? originalName,
    @HiveField(9) @Default(0.0) double popularity,
    @HiveField(10) @JsonKey(name: 'profile_path') String? profilePath,
  }) = _CrewMember;

  factory CrewMember.fromJson(Map<String, dynamic> json) => _$CrewMemberFromJson(json);
}

@freezed
@HiveType(typeId: 52, adapterName: 'GuestStarAdapter')
abstract class GuestStar with _$GuestStar {
  @JsonSerializable()
  factory GuestStar({
    @HiveField(0) String? character,
    @HiveField(1) @JsonKey(name: 'credit_id') String? creditId,
    @HiveField(2) @Default(0) int order,
    @HiveField(3) @Default(true) bool adult,
    @HiveField(4) @Default(0) int gender,
    @HiveField(5) @Default(0) int id,
    @HiveField(6) @JsonKey(name: 'known_for_department') String? knownForDepartment,
    @HiveField(7) required String name,
    @HiveField(8) @JsonKey(name: 'original_name') String? originalName,
    @HiveField(9) @Default(0.0) double popularity,
    @HiveField(10) @JsonKey(name: 'profile_path') String? profilePath,
  }) = _GuestStar;

  factory GuestStar.fromJson(Map<String, dynamic> json) => _$GuestStarFromJson(json);
}