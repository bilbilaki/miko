import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';

part 'person_detail.freezed.dart';
part 'person_detail.g.dart';

@injectable
@freezed
@HiveType(typeId: 100, adapterName: 'PersonDetailAdapter')
abstract class PersonDetail with _$PersonDetail {
  @JsonSerializable(explicitToJson: true)
  factory PersonDetail({
    @HiveField(0) @Default(true) bool adult,
    @HiveField(1) @JsonKey(name: 'also_known_as') List<String>? alsoKnownAs,
    @HiveField(2) String? biography,
    @HiveField(3) String? birthday,
    @HiveField(4) String? deathday,
    @HiveField(5) @Default(0) int gender,
    @HiveField(6) String? homepage,
    @HiveField(7) required int id,
    @HiveField(8) @JsonKey(name: 'imdb_id') String? imdbId,
    @HiveField(9) @JsonKey(name: 'known_for_department') String? knownForDepartment,
    @HiveField(10) required  String name,
    @HiveField(11) @JsonKey(name: 'place_of_birth') String? placeOfBirth,
    @HiveField(12) @Default(0.0) double popularity,
    @HiveField(13) @JsonKey(name: 'profile_path') String? profilePath,
  }) = _PersonDetail;

  factory PersonDetail.fromJson(Map<String, dynamic> json) => _$PersonDetailFromJson(json);
}