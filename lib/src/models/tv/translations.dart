import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';

part 'translations.freezed.dart';
part 'translations.g.dart';
//part 'translations.hive.dart';

@injectable
@freezed
@HiveType(typeId: 135)
abstract class TvTranslationData with _$TvTranslationData {
  @JsonSerializable()
  const factory TvTranslationData({
    @HiveField(0) String? name,
    @HiveField(1) String? overview,
    @HiveField(2) String? homepage,
    @HiveField(3) String? tagline,
  }) = _TvTranslationData;

  factory TvTranslationData.fromJson(Map<String, dynamic> json) => _$TvTranslationDataFromJson(json);
}

@injectable
@freezed
@HiveType(typeId: 136)
abstract class TvTranslationItem with _$TvTranslationItem {
  @JsonSerializable(explicitToJson: true)
  const factory TvTranslationItem({
    @HiveField(0) @JsonKey(name: 'iso_639_1') required String iso6391,
    @HiveField(1) required String name,
    @HiveField(2) @JsonKey(name: 'english_name') required String englishName,
    @HiveField(3) required TvTranslationData data,
  }) = _TvTranslationItem;

  factory TvTranslationItem.fromJson(Map<String, dynamic> json) => _$TvTranslationItemFromJson(json);
}

@injectable
@freezed
@HiveType(typeId: 137)
abstract class TvTranslationsResponse with _$TvTranslationsResponse {
  @JsonSerializable(explicitToJson: true)
  const factory TvTranslationsResponse({
    @HiveField(0) required int id,
    @HiveField(1) @JsonKey(name: 'translations') required List<TvTranslationItem> translations,
  }) = _TvTranslationsResponse;

  factory TvTranslationsResponse.fromJson(Map<String, dynamic> json) => _$TvTranslationsResponseFromJson(json);
}