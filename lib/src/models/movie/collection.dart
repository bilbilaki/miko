import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';

part 'collection.freezed.dart';
part 'collection.g.dart';
//part 'collection.hive.dart';

@injectable
@freezed
@HiveType(typeId: 120)
abstract class CollectionPart with _$CollectionPart {
  @JsonSerializable()
  const factory CollectionPart({
    @HiveField(0) required int id,
    @HiveField(1) required String title,
    @HiveField(2) @JsonKey(name: 'original_title') String? originalTitle,
    @HiveField(3) @JsonKey(name: 'poster_path') String? posterPath,
    @HiveField(4) @JsonKey(name: 'backdrop_path') String? backdropPath,
    @HiveField(5) @JsonKey(name: 'release_date') String? releaseDate,
  }) = _CollectionPart;

  factory CollectionPart.fromJson(Map<String, dynamic> json) => _$CollectionPartFromJson(json);
}

@injectable
@freezed
@HiveType(typeId: 121)
abstract class CollectionDetails with _$CollectionDetails {
  @JsonSerializable(explicitToJson: true)
  const factory CollectionDetails({
    @HiveField(0) required int id,
    @HiveField(1) required String name,
    @HiveField(2) String? overview,
    @HiveField(3) @JsonKey(name: 'poster_path') String? posterPath,
    @HiveField(4) @JsonKey(name: 'backdrop_path') String? backdropPath,
    @HiveField(5) @JsonKey(name: 'parts') required List<CollectionPart> parts,
  }) = _CollectionDetails;

  factory CollectionDetails.fromJson(Map<String, dynamic> json) => _$CollectionDetailsFromJson(json);
}