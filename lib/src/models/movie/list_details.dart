import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';

part 'list_details.freezed.dart';
part 'list_details.g.dart';
//part 'list_details.hive.dart';

@injectable
@freezed
@HiveType(typeId: 125)
abstract class MovieListItemDetail with _$MovieListItemDetail {
  @JsonSerializable()
  const factory MovieListItemDetail({
    @HiveField(0) required int id,
    @HiveField(1) required String title,
    @HiveField(2) @JsonKey(name: 'poster_path') String? posterPath,
    @HiveField(3) @JsonKey(name: 'backdrop_path') String? backdropPath,
    @HiveField(4) @JsonKey(name: 'media_type') String? mediaType,
    @HiveField(5) @JsonKey(name: 'release_date') String? releaseDate,
    @HiveField(6) @JsonKey(name: 'original_title') String? originalTitle,
  }) = _MovieListItemDetail;

  factory MovieListItemDetail.fromJson(Map<String, dynamic> json) => _$MovieListItemDetailFromJson(json);
}

@injectable
@freezed
@HiveType(typeId: 126)
abstract class MovieListDetails with _$MovieListDetails {
  @JsonSerializable(explicitToJson: true)
  const factory MovieListDetails({
    @HiveField(0) required String createdBy,
    @HiveField(1) required String description,
    @HiveField(2) required int favoriteCount,
    @HiveField(3) required int id,
    @HiveField(4) required String iso6391,
    @HiveField(5) required String itemCount,
    @HiveField(6) required String name,
    @HiveField(7) @JsonKey(name: 'items') required List<MovieListItemDetail> items,
  }) = _MovieListDetails;

  factory MovieListDetails.fromJson(Map<String, dynamic> json) => _$MovieListDetailsFromJson(json);
}