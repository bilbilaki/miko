import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';

import 'change_item.dart';

part 'changes_response.freezed.dart';
part 'changes_response.g.dart';
//part 'changes_response.hive.dart';

@injectable
@freezed
@HiveType(typeId: 153)
abstract class ChangesResponse with _$ChangesResponse {
  @JsonSerializable(explicitToJson: true)
  const factory ChangesResponse({
    @HiveField(0) required int page,
    @HiveField(1) @JsonKey(name: 'results') required List<ChangeItem> results,
    @HiveField(2) @JsonKey(name: 'total_pages') required int totalPages,
    @HiveField(3) @JsonKey(name: 'total_results') required int totalResults,
  }) = _ChangesResponse;

  factory ChangesResponse.fromJson(Map<String, dynamic> json) => _$ChangesResponseFromJson(json);
}