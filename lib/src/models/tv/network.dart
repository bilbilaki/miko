import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';

part 'network.freezed.dart';
part 'network.g.dart';
//part 'network.hive.dart';

@injectable
@freezed
@HiveType(typeId: 128)
abstract class Network with _$Network {
  @JsonSerializable()
  const factory Network({
    @HiveField(0) required int id,
    @HiveField(1) required String name,
    @HiveField(2) @JsonKey(name: 'logo_path') String? logoPath,
    @HiveField(3) @JsonKey(name: 'origin_country') String? originCountry,
  }) = _Network;

  factory Network.fromJson(Map<String, dynamic> json) => _$NetworkFromJson(json);
}