// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommendations_response.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MovieRecommendationsResponseAdapter
    extends TypeAdapter<MovieRecommendationsResponse> {
  @override
  final typeId = 110;

  @override
  MovieRecommendationsResponse read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MovieRecommendationsResponse(
      page: (fields[0] as num).toInt(),
      results: (fields[1] as List).cast<MovieListItem>(),
      totalResults: (fields[2] as num).toInt(),
      totalPages: (fields[3] as num).toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, MovieRecommendationsResponse obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.page)
      ..writeByte(1)
      ..write(obj.results)
      ..writeByte(2)
      ..write(obj.totalResults)
      ..writeByte(3)
      ..write(obj.totalPages);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovieRecommendationsResponseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MovieRecommendationsResponse _$MovieRecommendationsResponseFromJson(
  Map<String, dynamic> json,
) => _MovieRecommendationsResponse(
  page: (json['page'] as num).toInt(),
  results: (json['results'] as List<dynamic>)
      .map((e) => MovieListItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalResults: (json['total_results'] as num).toInt(),
  totalPages: (json['total_pages'] as num).toInt(),
);

Map<String, dynamic> _$MovieRecommendationsResponseToJson(
  _MovieRecommendationsResponse instance,
) => <String, dynamic>{
  'page': instance.page,
  'results': instance.results.map((e) => e.toJson()).toList(),
  'total_results': instance.totalResults,
  'total_pages': instance.totalPages,
};
