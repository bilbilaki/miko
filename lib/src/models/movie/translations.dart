import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';

part 'translations.freezed.dart';
part 'translations.g.dart';
//part 'translations.hive.dart';

@injectable
@freezed
@HiveType(typeId: 115)
abstract class TranslationData with _$TranslationData {
  @JsonSerializable()
  const factory TranslationData({
    @HiveField(0) String? title,
    @HiveField(1) String? overview,
    @HiveField(2) String? homepage,
    @HiveField(3) String? tagline,
    @HiveField(4) String? runtime, // optional, sometimes included in translations
  }) = _TranslationData;

  factory TranslationData.fromJson(Map<String, dynamic> json) => _$TranslationDataFromJson(json);
}

@injectable
@freezed
@HiveType(typeId: 116)
abstract class TranslationItem with _$TranslationItem {
  @JsonSerializable(explicitToJson: true)
  const factory TranslationItem({
    @HiveField(0) @JsonKey(name: 'iso_639_1') required String iso6391,
    @HiveField(1) required String name,
    @HiveField(2) @JsonKey(name: 'english_name') required String englishName,
    @HiveField(3) required TranslationData data,
  }) = _TranslationItem;

  factory TranslationItem.fromJson(Map<String, dynamic> json) => _$TranslationItemFromJson(json);
}

@injectable
@freezed
@HiveType(typeId: 117)
abstract class TranslationsResponse with _$TranslationsResponse {
  @JsonSerializable(explicitToJson: true)
  const factory TranslationsResponse({
    @HiveField(0) required int id,
    @HiveField(1) @JsonKey(name: 'translations') required List<TranslationItem> translations,
  }) = _TranslationsResponse;

  factory TranslationsResponse.fromJson(Map<String, dynamic> json) => _$TranslationsResponseFromJson(json);
}