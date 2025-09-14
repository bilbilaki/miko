import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';

import '../movie/production.dart';
import 'tv_genre.dart';
import 'network.dart';
import 'creator.dart';
import 'season_summary.dart';

part 'tv_show_detail.freezed.dart';
part 'tv_show_detail.g.dart';
//part 'tv_show_detail.hive.dart';

@injectable
@freezed
@HiveType(typeId: 131)
abstract class TvShowDetail with _$TvShowDetail {
  @JsonSerializable(explicitToJson: true)
  const factory TvShowDetail({
    @HiveField(0) required int id,
    @HiveField(1) required String name,
    @HiveField(2) @JsonKey(name: 'original_name') String? originalName,
    @HiveField(3) @JsonKey(name: 'overview') String? overview,
    @HiveField(4) @JsonKey(name: 'first_air_date') String? firstAirDate,
    @HiveField(5) @JsonKey(name: 'last_air_date') String? lastAirDate,
    @HiveField(6) @JsonKey(name: 'number_of_seasons') int? numberOfSeasons,
    @HiveField(7) @JsonKey(name: 'number_of_episodes') int? numberOfEpisodes,
    @HiveField(8) String? status,
    @HiveField(9) String? type,
    @HiveField(10) String? homepage,
    @HiveField(11) @JsonKey(name: 'in_production') bool? inProduction,
    @HiveField(12) @JsonKey(name: 'languages') List<String>? languages,
    @HiveField(13) @JsonKey(name: 'origin_country') List<String>? originCountry,
    @HiveField(14) @JsonKey(name: 'original_language') String? originalLanguage,
    @HiveField(15) @JsonKey(name: 'episode_run_time') List<int>? episodeRunTime,
    @HiveField(16) @JsonKey(name: 'genres') List<TvGenre>? genres,
    @HiveField(17) @JsonKey(name: 'networks') List<Network>? networks,
    @HiveField(18) @JsonKey(name: 'created_by') List<Creator>? createdBy,
    @HiveField(19) @JsonKey(name: 'seasons') List<SeasonSummary>? seasons,
    @HiveField(20) @JsonKey(name: 'production_companies') List<ProductionCompany>? productionCompanies,
    @HiveField(21) @JsonKey(name: 'production_countries') List<ProductionCountry>? productionCountries,
    @HiveField(22) @JsonKey(name: 'poster_path') String? posterPath,
    @HiveField(23) @JsonKey(name: 'backdrop_path') String? backdropPath,
    @HiveField(24) @JsonKey(name: 'vote_average') double? voteAverage,
    @HiveField(25) @JsonKey(name: 'vote_count') int? voteCount,
    @HiveField(26) double? popularity,
    @HiveField(27) @JsonKey(name: 'tagline') String? tagline,
    @HiveField(28) @JsonKey(name: 'created_by_ids') List<int>? createdByIds, // convenience
  }) = _TvShowDetail;

  factory TvShowDetail.fromJson(Map<String, dynamic> json) => _$TvShowDetailFromJson(json);
}