// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'changes_response.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChangesResponseAdapter extends TypeAdapter<ChangesResponse> {
  @override
  final typeId = 153;

  @override
  ChangesResponse read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChangesResponse(
      page: (fields[0] as num).toInt(),
      results: (fields[1] as List).cast<ChangeItem>(),
      totalPages: (fields[2] as num).toInt(),
      totalResults: (fields[3] as num).toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, ChangesResponse obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.page)
      ..writeByte(1)
      ..write(obj.results)
      ..writeByte(2)
      ..write(obj.totalPages)
      ..writeByte(3)
      ..write(obj.totalResults);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChangesResponseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChangesResponse _$ChangesResponseFromJson(Map<String, dynamic> json) =>
    _ChangesResponse(
      page: (json['page'] as num).toInt(),
      results: (json['results'] as List<dynamic>)
          .map((e) => ChangeItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalPages: (json['total_pages'] as num).toInt(),
      totalResults: (json['total_results'] as num).toInt(),
    );

Map<String, dynamic> _$ChangesResponseToJson(_ChangesResponse instance) =>
    <String, dynamic>{
      'page': instance.page,
      'results': instance.results.map((e) => e.toJson()).toList(),
      'total_pages': instance.totalPages,
      'total_results': instance.totalResults,
    };
