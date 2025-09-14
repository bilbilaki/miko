import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';

part 'image.freezed.dart';
part 'image.g.dart';
//part 'image.hive.dart';

@injectable
@freezed
@HiveType(typeId: 108)
abstract class MovieImage with _$MovieImage {
  @JsonSerializable()
  const factory MovieImage({
    @HiveField(0) @JsonKey(name: 'file_path') required String filePath,
    @HiveField(1) required int width,
    @HiveField(2) required int height,
    @HiveField(3) @JsonKey(name: 'iso_639_1') String? iso6391,
    @HiveField(4) @JsonKey(name: 'aspect_ratio') required double aspectRatio,
    @HiveField(5) @JsonKey(name: 'vote_average') double? voteAverage,
    @HiveField(6) @JsonKey(name: 'vote_count') int? voteCount,
  }) = _MovieImage;

  factory MovieImage.fromJson(Map<String, dynamic> json) => _$MovieImageFromJson(json);
}

@injectable
@freezed
@HiveType(typeId: 109)
abstract class MovieImagesResponse with _$MovieImagesResponse {
  @JsonSerializable(explicitToJson: true)
  const factory MovieImagesResponse({
    @HiveField(0) required int id,
    @HiveField(1) @JsonKey(name: 'backdrops') required List<MovieImage> backdrops,
    @HiveField(2) @JsonKey(name: 'posters') required List<MovieImage> posters,
  }) = _MovieImagesResponse;

  factory MovieImagesResponse.fromJson(Map<String, dynamic> json) => _$MovieImagesResponseFromJson(json);
}