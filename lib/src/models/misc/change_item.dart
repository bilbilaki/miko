import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';

part 'change_item.freezed.dart';
part 'change_item.g.dart';
//part 'change_item.hive.dart';

@injectable
@freezed
@HiveType(typeId: 152)
 abstract class ChangeItem with _$ChangeItem {
  @JsonSerializable()
  const factory ChangeItem({
    @HiveField(0) required int id,
    @HiveField(1) @JsonKey(name: 'adult') bool? adult,
    @HiveField(2) String? mediaType,
    @HiveField(3) String? description,
    @HiveField(4) @JsonKey(name: 'original_title') String? originalTitle,
    @HiveField(5) @JsonKey(name: 'original_name') String? originalName,
    @HiveField(6) @JsonKey(name: 'title') String? title,
    @HiveField(7) @JsonKey(name: 'name') String? name,
    @HiveField(8) @JsonKey(name: 'profile_path') String? profilePath,
    @HiveField(9) @JsonKey(name: 'change_type') String? changeType,
  @HiveField(10) @JsonKey(name: 'changes') List<Object?>? changes, // changes detail is complex, keep generic
  }) = _ChangeItem;

  factory ChangeItem.fromJson(Map<String, dynamic> json) => _$ChangeItemFromJson(json);
}