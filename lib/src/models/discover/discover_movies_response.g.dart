// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discover_movies_response.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DiscoverMoviesResponseAdapter
    extends TypeAdapter<DiscoverMoviesResponse> {
  @override
  final typeId = 144;

  @override
  DiscoverMoviesResponse read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DiscoverMoviesResponse(
      page: (fields[0] as num).toInt(),
      results: (fields[1] as List).cast<MovieListItem>(),
      totalResults: (fields[2] as num).toInt(),
      totalPages: (fields[3] as num).toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, DiscoverMoviesResponse obj) {
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
      other is DiscoverMoviesResponseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DiscoverMoviesResponse _$DiscoverMoviesResponseFromJson(
  Map<String, dynamic> json,
) => _DiscoverMoviesResponse(
  page: (json['page'] as num).toInt(),
  results: (json['results'] as List<dynamic>)
      .map((e) => MovieListItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalResults: (json['total_results'] as num).toInt(),
  totalPages: (json['total_pages'] as num).toInt(),
);

Map<String, dynamic> _$DiscoverMoviesResponseToJson(
  _DiscoverMoviesResponse instance,
) => <String, dynamic>{
  'page': instance.page,
  'results': instance.results.map((e) => e.toJson()).toList(),
  'total_results': instance.totalResults,
  'total_pages': instance.totalPages,
};
