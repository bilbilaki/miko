import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';

part 'account_states.freezed.dart';
part 'account_states.g.dart';
//part 'account_states.hive.dart';

@injectable
@freezed
@HiveType(typeId: 148)
abstract class AccountStates with _$AccountStates {
  @JsonSerializable()
  const factory AccountStates({
    @HiveField(0) required int id,
    @HiveField(1) required bool favorite,
    @HiveField(2) required bool watchlist,
  // rated can be either false or an object { value: x }
  // use Object? to avoid type-checking issues in code generators
  @HiveField(3) Object? rated,
    @HiveField(4) @JsonKey(name: 'media_type') String? mediaType,
  }) = _AccountStates;

  factory AccountStates.fromJson(Map<String, dynamic> json) => _$AccountStatesFromJson(json);
}

