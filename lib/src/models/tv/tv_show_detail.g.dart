// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tv_show_detail.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TvShowDetailAdapter extends TypeAdapter<TvShowDetail> {
  @override
  final typeId = 131;

  @override
  TvShowDetail read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TvShowDetail(
      id: (fields[0] as num).toInt(),
      name: fields[1] as String,
      originalName: fields[2] as String?,
      overview: fields[3] as String?,
      firstAirDate: fields[4] as String?,
      lastAirDate: fields[5] as String?,
      numberOfSeasons: (fields[6] as num?)?.toInt(),
      numberOfEpisodes: (fields[7] as num?)?.toInt(),
      status: fields[8] as String?,
      type: fields[9] as String?,
      homepage: fields[10] as String?,
      inProduction: fields[11] as bool?,
      languages: (fields[12] as List?)?.cast<String>(),
      originCountry: (fields[13] as List?)?.cast<String>(),
      originalLanguage: fields[14] as String?,
      episodeRunTime: (fields[15] as List?)?.cast<int>(),
      genres: (fields[16] as List?)?.cast<TvGenre>(),
      networks: (fields[17] as List?)?.cast<Network>(),
      createdBy: (fields[18] as List?)?.cast<Creator>(),
      seasons: (fields[19] as List?)?.cast<SeasonSummary>(),
      productionCompanies: (fields[20] as List?)?.cast<ProductionCompany>(),
      productionCountries: (fields[21] as List?)?.cast<ProductionCountry>(),
      posterPath: fields[22] as String?,
      backdropPath: fields[23] as String?,
      voteAverage: (fields[24] as num?)?.toDouble(),
      voteCount: (fields[25] as num?)?.toInt(),
      popularity: (fields[26] as num?)?.toDouble(),
      tagline: fields[27] as String?,
      createdByIds: (fields[28] as List?)?.cast<int>(),
    );
  }

  @override
  void write(BinaryWriter writer, TvShowDetail obj) {
    writer
      ..writeByte(29)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.originalName)
      ..writeByte(3)
      ..write(obj.overview)
      ..writeByte(4)
      ..write(obj.firstAirDate)
      ..writeByte(5)
      ..write(obj.lastAirDate)
      ..writeByte(6)
      ..write(obj.numberOfSeasons)
      ..writeByte(7)
      ..write(obj.numberOfEpisodes)
      ..writeByte(8)
      ..write(obj.status)
      ..writeByte(9)
      ..write(obj.type)
      ..writeByte(10)
      ..write(obj.homepage)
      ..writeByte(11)
      ..write(obj.inProduction)
      ..writeByte(12)
      ..write(obj.languages)
      ..writeByte(13)
      ..write(obj.originCountry)
      ..writeByte(14)
      ..write(obj.originalLanguage)
      ..writeByte(15)
      ..write(obj.episodeRunTime)
      ..writeByte(16)
      ..write(obj.genres)
      ..writeByte(17)
      ..write(obj.networks)
      ..writeByte(18)
      ..write(obj.createdBy)
      ..writeByte(19)
      ..write(obj.seasons)
      ..writeByte(20)
      ..write(obj.productionCompanies)
      ..writeByte(21)
      ..write(obj.productionCountries)
      ..writeByte(22)
      ..write(obj.posterPath)
      ..writeByte(23)
      ..write(obj.backdropPath)
      ..writeByte(24)
      ..write(obj.voteAverage)
      ..writeByte(25)
      ..write(obj.voteCount)
      ..writeByte(26)
      ..write(obj.popularity)
      ..writeByte(27)
      ..write(obj.tagline)
      ..writeByte(28)
      ..write(obj.createdByIds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TvShowDetailAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TvShowDetail _$TvShowDetailFromJson(Map<String, dynamic> json) =>
    _TvShowDetail(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      originalName: json['original_name'] as String?,
      overview: json['overview'] as String?,
      firstAirDate: json['first_air_date'] as String?,
      lastAirDate: json['last_air_date'] as String?,
      numberOfSeasons: (json['number_of_seasons'] as num?)?.toInt(),
      numberOfEpisodes: (json['number_of_episodes'] as num?)?.toInt(),
      status: json['status'] as String?,
      type: json['type'] as String?,
      homepage: json['homepage'] as String?,
      inProduction: json['in_production'] as bool?,
      languages: (json['languages'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      originCountry: (json['origin_country'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      originalLanguage: json['original_language'] as String?,
      episodeRunTime: (json['episode_run_time'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      genres: (json['genres'] as List<dynamic>?)
          ?.map((e) => TvGenre.fromJson(e as Map<String, dynamic>))
          .toList(),
      networks: (json['networks'] as List<dynamic>?)
          ?.map((e) => Network.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdBy: (json['created_by'] as List<dynamic>?)
          ?.map((e) => Creator.fromJson(e as Map<String, dynamic>))
          .toList(),
      seasons: (json['seasons'] as List<dynamic>?)
          ?.map((e) => SeasonSummary.fromJson(e as Map<String, dynamic>))
          .toList(),
      productionCompanies: (json['production_companies'] as List<dynamic>?)
          ?.map((e) => ProductionCompany.fromJson(e as Map<String, dynamic>))
          .toList(),
      productionCountries: (json['production_countries'] as List<dynamic>?)
          ?.map((e) => ProductionCountry.fromJson(e as Map<String, dynamic>))
          .toList(),
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      voteAverage: (json['vote_average'] as num?)?.toDouble(),
      voteCount: (json['vote_count'] as num?)?.toInt(),
      popularity: (json['popularity'] as num?)?.toDouble(),
      tagline: json['tagline'] as String?,
      createdByIds: (json['created_by_ids'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
    );

Map<String, dynamic> _$TvShowDetailToJson(_TvShowDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'original_name': instance.originalName,
      'overview': instance.overview,
      'first_air_date': instance.firstAirDate,
      'last_air_date': instance.lastAirDate,
      'number_of_seasons': instance.numberOfSeasons,
      'number_of_episodes': instance.numberOfEpisodes,
      'status': instance.status,
      'type': instance.type,
      'homepage': instance.homepage,
      'in_production': instance.inProduction,
      'languages': instance.languages,
      'origin_country': instance.originCountry,
      'original_language': instance.originalLanguage,
      'episode_run_time': instance.episodeRunTime,
      'genres': instance.genres?.map((e) => e.toJson()).toList(),
      'networks': instance.networks?.map((e) => e.toJson()).toList(),
      'created_by': instance.createdBy?.map((e) => e.toJson()).toList(),
      'seasons': instance.seasons?.map((e) => e.toJson()).toList(),
      'production_companies': instance.productionCompanies
          ?.map((e) => e.toJson())
          .toList(),
      'production_countries': instance.productionCountries
          ?.map((e) => e.toJson())
          .toList(),
      'poster_path': instance.posterPath,
      'backdrop_path': instance.backdropPath,
      'vote_average': instance.voteAverage,
      'vote_count': instance.voteCount,
      'popularity': instance.popularity,
      'tagline': instance.tagline,
      'created_by_ids': instance.createdByIds,
    };
