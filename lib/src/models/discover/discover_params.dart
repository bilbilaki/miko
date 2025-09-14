import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';

part 'discover_params.freezed.dart';
part 'discover_params.g.dart';
//part 'discover_params.hive.dart';

@injectable
@freezed
@HiveType(typeId: 143)
abstract class DiscoverParams with _$DiscoverParams {
  const factory DiscoverParams({
    @HiveField(0) int? page,
    @HiveField(1) @JsonKey(name: 'sort_by') String? sortBy,
    @HiveField(2) @JsonKey(name: 'include_adult') bool? includeAdult,
    @HiveField(3) @JsonKey(name: 'with_genres') List<int>? withGenres,
    @HiveField(4) int? year,
    @HiveField(5) @JsonKey(name: 'primary_release_year') int? primaryReleaseYear,
    @HiveField(6) @JsonKey(name: 'vote_count.gte') int? voteCountGte,
    @HiveField(7) @JsonKey(name: 'vote_average.gte') double? voteAverageGte,
    @HiveField(8) @JsonKey(name: 'with_companies') List<int>? withCompanies,
    @HiveField(9) @JsonKey(name: 'with_watch_providers') List<int>? withWatchProviders,
    @HiveField(10) @JsonKey(name: 'with_original_language') String? withOriginalLanguage,
    @HiveField(11) @JsonKey(name: 'with_runtime.gte') int? runtimeGte,
    @HiveField(12) @JsonKey(name: 'with_runtime.lte') int? runtimeLte,
  }) = _DiscoverParams;

  factory DiscoverParams.fromJson(Map<String, dynamic> json) => _$DiscoverParamsFromJson(json);
}