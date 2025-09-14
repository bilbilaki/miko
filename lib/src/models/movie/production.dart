import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';

part 'production.freezed.dart';
part 'production.g.dart';
//part 'production.hive.dart';

@injectable
@freezed
@HiveType(typeId: 118)
abstract class ProductionCompany with _$ProductionCompany {
  @JsonSerializable()
  const factory ProductionCompany({
    @HiveField(0) required int id,
    @HiveField(1) String? logoPath,
    @HiveField(2) required String name,
    @HiveField(3) String? originCountry,
  }) = _ProductionCompany;

  factory ProductionCompany.fromJson(Map<String, dynamic> json) => _$ProductionCompanyFromJson(json);
}

@injectable
@freezed
@HiveType(typeId: 119)
abstract class ProductionCountry with _$ProductionCountry {
  @JsonSerializable()
  const factory ProductionCountry({
    @HiveField(0) @JsonKey(name: 'iso_3166_1') required String iso31661,
    @HiveField(1) required String name,
  }) = _ProductionCountry;

  factory ProductionCountry.fromJson(Map<String, dynamic> json) => _$ProductionCountryFromJson(json);
}