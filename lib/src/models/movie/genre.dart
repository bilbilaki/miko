import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';

part 'genre.freezed.dart';
part 'genre.g.dart';
//part 'genre.hive.dart';

@injectable
@freezed
@HiveType(typeId: 102)
abstract class MovieGenre with _$MovieGenre {
  @JsonSerializable()
  const factory MovieGenre({
    @HiveField(0) required int id,
    @HiveField(1) required String name,
  }) = _MovieGenre;

  factory MovieGenre.fromJson(Map<String, dynamic> json) => _$MovieGenreFromJson(json);
}

@injectable
@freezed
@HiveType(typeId: 103)
abstract class GenreListResponse with _$GenreListResponse {
  @JsonSerializable(explicitToJson: true)
  const factory GenreListResponse({
    @HiveField(0) required List<MovieGenre> genres,
  }) = _GenreListResponse;

  factory GenreListResponse.fromJson(Map<String, dynamic> json) => _$GenreListResponseFromJson(json);
}