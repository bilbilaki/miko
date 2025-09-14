import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';

part 'keyword.freezed.dart';
part 'keyword.g.dart';
//part 'keyword.hive.dart';

@injectable
@freezed
@HiveType(typeId: 104)
abstract class MovieKeyword with _$MovieKeyword {
  @JsonSerializable()
  const factory MovieKeyword({
    @HiveField(0) required int id,
    @HiveField(1) required String name,
  }) = _MovieKeyword;

  factory MovieKeyword.fromJson(Map<String, dynamic> json) => _$MovieKeywordFromJson(json);
}

@injectable
@freezed
@HiveType(typeId: 105)
abstract class MovieKeywordsResponse with _$MovieKeywordsResponse {
  @JsonSerializable(explicitToJson: true)
  const factory MovieKeywordsResponse({
    @HiveField(0) required int id,
    @HiveField(1) required List<MovieKeyword> keywords,
  }) = _MovieKeywordsResponse;

  factory MovieKeywordsResponse.fromJson(Map<String, dynamic> json) => _$MovieKeywordsResponseFromJson(json);
}