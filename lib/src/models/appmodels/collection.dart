// lib/src/models/collection.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';

part 'collection.freezed.dart';
part 'collection.g.dart';

@freezed
@HiveType(typeId: 70, adapterName: 'CollectionAdapter')
abstract class Collection with _$Collection {
  @JsonSerializable(explicitToJson: true)
  factory Collection({
    @HiveField(0) required String id, // unique id (e.g., uuid)
    @HiveField(1) required String name,
    @HiveField(2) String? coverPath,
    @HiveField(3) @Default(<CollectionItem>[]) List<CollectionItem> items,
    @HiveField(4) required int createdAt, // epoch ms UTC
    @HiveField(5) required int updatedAt, // epoch ms UTC
  }) = _Collection;

  factory Collection.fromJson(Map<String, dynamic> json) =>
      _$CollectionFromJson(json);
}

@freezed
@HiveType(typeId: 71, adapterName: 'CollectionItemAdapter')
abstract class CollectionItem with _$CollectionItem {
  @JsonSerializable()
  factory CollectionItem({
    @HiveField(0) required int id, // movie/tv id
    @HiveField(1) required String name,
    @HiveField(2) String? posterPath,
    @HiveField(3) @Default(0) int voteCount,
    @HiveField(4) String? overview,
  }) = _CollectionItem;

  factory CollectionItem.fromJson(Map<String, dynamic> json) =>
      _$CollectionItemFromJson(json);
}
