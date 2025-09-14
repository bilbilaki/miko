import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';

part 'alternative_titles.freezed.dart';
part 'alternative_titles.g.dart';
//part 'alternative_titles.hive.dart';

@injectable
@freezed
@HiveType(typeId: 113)
abstract class AlternativeTitle with _$AlternativeTitle {
  @JsonSerializable()
  const factory AlternativeTitle({
    @HiveField(0) required int id,
    @HiveField(1) @JsonKey(name: 'iso_3166_1') required String iso31661,
    @HiveField(2) required String title,
    @HiveField(3) String? type,
  }) = _AlternativeTitle;

  factory AlternativeTitle.fromJson(Map<String, dynamic> json) => _$AlternativeTitleFromJson(json);
}

@injectable
@freezed
@HiveType(typeId: 114)
abstract class AlternativeTitlesResponse with _$AlternativeTitlesResponse {
  @JsonSerializable(explicitToJson: true)
  const factory AlternativeTitlesResponse({
    @HiveField(0) required int id,
    @HiveField(1) @JsonKey(name: 'titles') required List<AlternativeTitle> titles,
  }) = _AlternativeTitlesResponse;

  factory AlternativeTitlesResponse.fromJson(Map<String, dynamic> json) => _$AlternativeTitlesResponseFromJson(json);
}