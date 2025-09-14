// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discover_params.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DiscoverParamsAdapter extends TypeAdapter<DiscoverParams> {
  @override
  final typeId = 143;

  @override
  DiscoverParams read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DiscoverParams(
      page: (fields[0] as num?)?.toInt(),
      sortBy: fields[1] as String?,
      includeAdult: fields[2] as bool?,
      withGenres: (fields[3] as List?)?.cast<int>(),
      year: (fields[4] as num?)?.toInt(),
      primaryReleaseYear: (fields[5] as num?)?.toInt(),
      voteCountGte: (fields[6] as num?)?.toInt(),
      voteAverageGte: (fields[7] as num?)?.toDouble(),
      withCompanies: (fields[8] as List?)?.cast<int>(),
      withWatchProviders: (fields[9] as List?)?.cast<int>(),
      withOriginalLanguage: fields[10] as String?,
      runtimeGte: (fields[11] as num?)?.toInt(),
      runtimeLte: (fields[12] as num?)?.toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, DiscoverParams obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.page)
      ..writeByte(1)
      ..write(obj.sortBy)
      ..writeByte(2)
      ..write(obj.includeAdult)
      ..writeByte(3)
      ..write(obj.withGenres)
      ..writeByte(4)
      ..write(obj.year)
      ..writeByte(5)
      ..write(obj.primaryReleaseYear)
      ..writeByte(6)
      ..write(obj.voteCountGte)
      ..writeByte(7)
      ..write(obj.voteAverageGte)
      ..writeByte(8)
      ..write(obj.withCompanies)
      ..writeByte(9)
      ..write(obj.withWatchProviders)
      ..writeByte(10)
      ..write(obj.withOriginalLanguage)
      ..writeByte(11)
      ..write(obj.runtimeGte)
      ..writeByte(12)
      ..write(obj.runtimeLte);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DiscoverParamsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DiscoverParams _$DiscoverParamsFromJson(Map<String, dynamic> json) =>
    _DiscoverParams(
      page: (json['page'] as num?)?.toInt(),
      sortBy: json['sort_by'] as String?,
      includeAdult: json['include_adult'] as bool?,
      withGenres: (json['with_genres'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      year: (json['year'] as num?)?.toInt(),
      primaryReleaseYear: (json['primary_release_year'] as num?)?.toInt(),
      voteCountGte: (json['vote_count.gte'] as num?)?.toInt(),
      voteAverageGte: (json['vote_average.gte'] as num?)?.toDouble(),
      withCompanies: (json['with_companies'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      withWatchProviders: (json['with_watch_providers'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      withOriginalLanguage: json['with_original_language'] as String?,
      runtimeGte: (json['with_runtime.gte'] as num?)?.toInt(),
      runtimeLte: (json['with_runtime.lte'] as num?)?.toInt(),
    );

Map<String, dynamic> _$DiscoverParamsToJson(_DiscoverParams instance) =>
    <String, dynamic>{
      'page': instance.page,
      'sort_by': instance.sortBy,
      'include_adult': instance.includeAdult,
      'with_genres': instance.withGenres,
      'year': instance.year,
      'primary_release_year': instance.primaryReleaseYear,
      'vote_count.gte': instance.voteCountGte,
      'vote_average.gte': instance.voteAverageGte,
      'with_companies': instance.withCompanies,
      'with_watch_providers': instance.withWatchProviders,
      'with_original_language': instance.withOriginalLanguage,
      'with_runtime.gte': instance.runtimeGte,
      'with_runtime.lte': instance.runtimeLte,
    };
