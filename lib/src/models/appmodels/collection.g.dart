// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CollectionAdapter extends TypeAdapter<Collection> {
  @override
  final typeId = 70;

  @override
  Collection read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Collection(
      id: fields[0] as String,
      name: fields[1] as String,
      coverPath: fields[2] as String?,
      items: fields[3] == null
          ? []
          : (fields[3] as List).cast<CollectionItem>(),
      createdAt: (fields[4] as num).toInt(),
      updatedAt: (fields[5] as num).toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, Collection obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.coverPath)
      ..writeByte(3)
      ..write(obj.items)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CollectionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CollectionItemAdapter extends TypeAdapter<CollectionItem> {
  @override
  final typeId = 71;

  @override
  CollectionItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CollectionItem(
      id: (fields[0] as num).toInt(),
      name: fields[1] as String,
      posterPath: fields[2] as String?,
      voteCount: fields[3] == null ? 0 : (fields[3] as num).toInt(),
      overview: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CollectionItem obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.posterPath)
      ..writeByte(3)
      ..write(obj.voteCount)
      ..writeByte(4)
      ..write(obj.overview);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CollectionItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Collection _$CollectionFromJson(Map<String, dynamic> json) => _Collection(
  id: json['id'] as String,
  name: json['name'] as String,
  coverPath: json['coverPath'] as String?,
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => CollectionItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <CollectionItem>[],
  createdAt: (json['createdAt'] as num).toInt(),
  updatedAt: (json['updatedAt'] as num).toInt(),
);

Map<String, dynamic> _$CollectionToJson(_Collection instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'coverPath': instance.coverPath,
      'items': instance.items.map((e) => e.toJson()).toList(),
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };

_CollectionItem _$CollectionItemFromJson(Map<String, dynamic> json) =>
    _CollectionItem(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      posterPath: json['posterPath'] as String?,
      voteCount: (json['voteCount'] as num?)?.toInt() ?? 0,
      overview: json['overview'] as String?,
    );

Map<String, dynamic> _$CollectionItemToJson(_CollectionItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'posterPath': instance.posterPath,
      'voteCount': instance.voteCount,
      'overview': instance.overview,
    };
