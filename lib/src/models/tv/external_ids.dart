import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';

part 'external_ids.freezed.dart';
part 'external_ids.g.dart';
//part 'external_ids.hive.dart';

@injectable
@freezed
@HiveType(typeId: 138)
abstract class TvExternalIds with _$TvExternalIds {
  @JsonSerializable()
  const factory TvExternalIds({
    @HiveField(0) required int id,
    @HiveField(1) String? imdbId,
    @HiveField(2) String? freebaseMid,
    @HiveField(3) String? freebaseId,
    @HiveField(4) String? tvdbId,
    @HiveField(5) String? tvrageId,
    @HiveField(6) @JsonKey(name: 'facebook_id') String? facebookId,
    @HiveField(7) @JsonKey(name: 'instagram_id') String? instagramId,
    @HiveField(8) @JsonKey(name: 'twitter_id') String? twitterId,
  }) = _TvExternalIds;

  factory TvExternalIds.fromJson(Map<String, dynamic> json) => _$TvExternalIdsFromJson(json);
}