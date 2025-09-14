import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';

part 'tv_genre.freezed.dart';
part 'tv_genre.g.dart';
//part 'tv_genre.hive.dart';

@injectable
@freezed
@HiveType(typeId: 127)
abstract class TvGenre with _$TvGenre {
  @JsonSerializable()
  const factory TvGenre({
    @HiveField(0) required int id,
    @HiveField(1) required String name,
  }) = _TvGenre;

  factory TvGenre.fromJson(Map<String, dynamic> json) => _$TvGenreFromJson(json);
}