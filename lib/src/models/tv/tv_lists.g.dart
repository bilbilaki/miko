// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tv_lists.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TvListResponseAdapter extends TypeAdapter<TvListResponse> {
  @override
  final typeId = 90;

  @override
  TvListResponse read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TvListResponse(
      page: (fields[0] as num).toInt(),
      results: (fields[1] as List).cast<TvSummary>(),
      totalPages: fields[2] == null ? 0 : (fields[2] as num).toInt(),
      totalResults: fields[3] == null ? 0 : (fields[3] as num).toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, TvListResponse obj) {
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
      other is TvListResponseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TvSummaryAdapter extends TypeAdapter<TvSummary> {
  @override
  final typeId = 91;

  @override
  TvSummary read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TvSummary(
      backdropPath: fields[0] as String?,
      firstAirDate: fields[1] as String?,
      genreIds: (fields[2] as List?)?.cast<int>(),
      id: (fields[3] as num).toInt(),
      name: fields[4] as String,
      originCountry: (fields[5] as List?)?.cast<String>(),
      originalLanguage: fields[6] as String?,
      originalName: fields[7] as String?,
      overview: fields[8] as String?,
      popularity: fields[9] == null ? 0.0 : (fields[9] as num).toDouble(),
      posterPath: fields[10] as String?,
      voteAverage: fields[11] == null ? 0.0 : (fields[11] as num).toDouble(),
      voteCount: fields[12] == null ? 0 : (fields[12] as num).toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, TvSummary obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.backdropPath)
      ..writeByte(1)
      ..write(obj.firstAirDate)
      ..writeByte(2)
      ..write(obj.genreIds)
      ..writeByte(3)
      ..write(obj.id)
      ..writeByte(4)
      ..write(obj.name)
      ..writeByte(5)
      ..write(obj.originCountry)
      ..writeByte(6)
      ..write(obj.originalLanguage)
      ..writeByte(7)
      ..write(obj.originalName)
      ..writeByte(8)
      ..write(obj.overview)
      ..writeByte(9)
      ..write(obj.popularity)
      ..writeByte(10)
      ..write(obj.posterPath)
      ..writeByte(11)
      ..write(obj.voteAverage)
      ..writeByte(12)
      ..write(obj.voteCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TvSummaryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TvListResponse _$TvListResponseFromJson(Map<String, dynamic> json) =>
    _TvListResponse(
      page: (json['page'] as num).toInt(),
      results: (json['results'] as List<dynamic>)
          .map((e) => TvSummary.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalPages: (json['total_pages'] as num?)?.toInt() ?? 0,
      totalResults: (json['total_results'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$TvListResponseToJson(_TvListResponse instance) =>
    <String, dynamic>{
      'page': instance.page,
      'results': instance.results.map((e) => e.toJson()).toList(),
      'total_pages': instance.totalPages,
      'total_results': instance.totalResults,
    };

_TvSummary _$TvSummaryFromJson(Map<String, dynamic> json) => _TvSummary(
  backdropPath: json['backdrop_path'] as String?,
  firstAirDate: json['first_air_date'] as String?,
  genreIds: (json['genre_ids'] as List<dynamic>?)
      ?.map((e) => (e as num).toInt())
      .toList(),
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  originCountry: (json['origin_country'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  originalLanguage: json['original_language'] as String?,
  originalName: json['original_name'] as String?,
  overview: json['overview'] as String?,
  popularity: (json['popularity'] as num?)?.toDouble() ?? 0.0,
  posterPath: json['poster_path'] as String?,
  voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
  voteCount: (json['vote_count'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$TvSummaryToJson(_TvSummary instance) =>
    <String, dynamic>{
      'backdrop_path': instance.backdropPath,
      'first_air_date': instance.firstAirDate,
      'genre_ids': instance.genreIds,
      'id': instance.id,
      'name': instance.name,
      'origin_country': instance.originCountry,
      'original_language': instance.originalLanguage,
      'original_name': instance.originalName,
      'overview': instance.overview,
      'popularity': instance.popularity,
      'poster_path': instance.posterPath,
      'vote_average': instance.voteAverage,
      'vote_count': instance.voteCount,
    };
