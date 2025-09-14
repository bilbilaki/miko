import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';

part 'video.freezed.dart';
part 'video.g.dart';
//part 'video.hive.dart';

@injectable
@freezed
@HiveType(typeId: 106)
abstract class MovieVideo with _$MovieVideo {
  @JsonSerializable()
  const factory MovieVideo({
    @HiveField(0) required String id,
    @HiveField(1) @JsonKey(name: 'iso_639_1') String? iso6391,
    @HiveField(2) @JsonKey(name: 'iso_3166_1') String? iso31661,
    @HiveField(3) required String key,
    @HiveField(4) required String name,
    @HiveField(5) required String site,
    @HiveField(6) int? size,
    @HiveField(7) required String type,
    @HiveField(8) bool? official,
    @HiveField(9) @JsonKey(name: 'published_at') String? publishedAt,
  }) = _MovieVideo;

  factory MovieVideo.fromJson(Map<String, dynamic> json) => _$MovieVideoFromJson(json);
}

@injectable
@freezed
@HiveType(typeId: 107)
abstract class MovieVideosResponse with _$MovieVideosResponse {
  @JsonSerializable(explicitToJson: true)
  const factory MovieVideosResponse({
    @HiveField(0) required int id,
    @HiveField(1) @JsonKey(name: 'results') required List<MovieVideo> results,
  }) = _MovieVideosResponse;

  factory MovieVideosResponse.fromJson(Map<String, dynamic> json) => _$MovieVideosResponseFromJson(json);
}