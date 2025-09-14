import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';

part 'creator.freezed.dart';
part 'creator.g.dart';

@injectable
@freezed
@HiveType(typeId: 129)
abstract class Creator with _$Creator {
  @JsonSerializable()
  const factory Creator({
    @HiveField(0) required int id,
    @HiveField(1) required String name,
    @HiveField(2) @JsonKey(name: 'credit_id') String? creditId,
    @HiveField(3) @JsonKey(name: 'gender') int? gender,
    @HiveField(4) @JsonKey(name: 'profile_path') String? profilePath,
  }) = _Creator;

  factory Creator.fromJson(Map<String, dynamic> json) => _$CreatorFromJson(json);
}