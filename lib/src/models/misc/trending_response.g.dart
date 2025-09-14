// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trending_response.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TrendingResponseAdapter extends TypeAdapter<TrendingResponse> {
  @override
  final typeId = 151;

  @override
  TrendingResponse read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TrendingResponse(
      page: (fields[0] as num).toInt(),
      results: (fields[1] as List).cast<SearchResultItem>(),
      totalPages: (fields[2] as num).toInt(),
      totalResults: (fields[3] as num).toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, TrendingResponse obj) {
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
      other is TrendingResponseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TrendingResponse _$TrendingResponseFromJson(Map<String, dynamic> json) =>
    _TrendingResponse(
      page: (json['page'] as num).toInt(),
      results: (json['results'] as List<dynamic>)
          .map((e) => SearchResultItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalPages: (json['total_pages'] as num).toInt(),
      totalResults: (json['total_results'] as num).toInt(),
    );

Map<String, dynamic> _$TrendingResponseToJson(_TrendingResponse instance) =>
    <String, dynamic>{
      'page': instance.page,
      'results': instance.results.map((e) => e.toJson()).toList(),
      'total_pages': instance.totalPages,
      'total_results': instance.totalResults,
    };
