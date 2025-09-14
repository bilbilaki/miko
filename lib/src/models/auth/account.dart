import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';

part 'account.freezed.dart';
part 'account.g.dart';
//part 'account.hive.dart';

@injectable
@freezed
@HiveType(typeId: 147)
abstract class AccountDetails with _$AccountDetails {
  @JsonSerializable()
  const factory AccountDetails({
    @HiveField(0) required int id,
    @HiveField(1) String? name,
    @HiveField(2) required String username,
    @HiveField(3) @JsonKey(name: 'include_adult') bool? includeAdult,
    @HiveField(4) @JsonKey(name: 'iso_639_1') String? iso6391,
    @HiveField(5) @JsonKey(name: 'iso_3166_1') String? iso31661,
  }) = _AccountDetails;

  factory AccountDetails.fromJson(Map<String, dynamic> json) => _$AccountDetailsFromJson(json);
}