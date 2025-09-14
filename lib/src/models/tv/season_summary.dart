import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';

part 'season_summary.freezed.dart';
part 'season_summary.g.dart';
//part 'season_summary.hive.dart';

@injectable
@freezed
@HiveType(typeId: 130)
abstract class SeasonSummary with _$SeasonSummary {
  @JsonSerializable()
  const factory SeasonSummary({
    @HiveField(0) @JsonKey(name: 'air_date') String? airDate,
    @HiveField(1) @JsonKey(name: 'episode_count') required int episodeCount,
    @HiveField(2) required int id,
    @HiveField(3) required String name,
    @HiveField(4) @JsonKey(name: 'overview') String? overview,
    @HiveField(5) @JsonKey(name: 'poster_path') String? posterPath,
    @HiveField(6) @JsonKey(name: 'season_number') required int seasonNumber,
  }) = _SeasonSummary;

  factory SeasonSummary.fromJson(Map<String, dynamic> json) => _$SeasonSummaryFromJson(json);
}