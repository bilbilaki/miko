// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_detail.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MovieDetailAdapter extends TypeAdapter<MovieDetail> {
  @override
  final typeId = 60;

  @override
  MovieDetail read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MovieDetail(
      adult: fields[0] == null ? true : fields[0] as bool,
      backdropPath: fields[1] as String?,
      belongsToCollection: fields[2] as String?,
      budget: fields[3] == null ? 0 : (fields[3] as num).toInt(),
      genres: (fields[4] as List?)?.cast<Genre>(),
      homepage: fields[5] as String?,
      id: (fields[6] as num).toInt(),
      imdbId: fields[7] as String?,
      originalLanguage: fields[8] as String?,
      originalTitle: fields[9] as String?,
      overview: fields[10] as String?,
      popularity: fields[11] == null ? 0.0 : (fields[11] as num).toDouble(),
      posterPath: fields[12] as String?,
      productionCompanies: (fields[13] as List?)?.cast<ProductionCompany>(),
      productionCountries: (fields[14] as List?)?.cast<ProductionCountry>(),
      releaseDate: fields[15] as String?,
      revenue: fields[16] == null ? 0 : (fields[16] as num).toInt(),
      runtime: fields[17] == null ? 0 : (fields[17] as num).toInt(),
      spokenLanguages: (fields[18] as List?)?.cast<SpokenLanguage>(),
      status: fields[19] as String?,
      tagline: fields[20] as String?,
      title: fields[21] as String,
      video: fields[22] == null ? true : fields[22] as bool,
      voteAverage: fields[23] == null ? 0.0 : (fields[23] as num).toDouble(),
      voteCount: fields[24] == null ? 0 : (fields[24] as num).toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, MovieDetail obj) {
    writer
      ..writeByte(25)
      ..writeByte(0)
      ..write(obj.adult)
      ..writeByte(1)
      ..write(obj.backdropPath)
      ..writeByte(2)
      ..write(obj.belongsToCollection)
      ..writeByte(3)
      ..write(obj.budget)
      ..writeByte(4)
      ..write(obj.genres)
      ..writeByte(5)
      ..write(obj.homepage)
      ..writeByte(6)
      ..write(obj.id)
      ..writeByte(7)
      ..write(obj.imdbId)
      ..writeByte(8)
      ..write(obj.originalLanguage)
      ..writeByte(9)
      ..write(obj.originalTitle)
      ..writeByte(10)
      ..write(obj.overview)
      ..writeByte(11)
      ..write(obj.popularity)
      ..writeByte(12)
      ..write(obj.posterPath)
      ..writeByte(13)
      ..write(obj.productionCompanies)
      ..writeByte(14)
      ..write(obj.productionCountries)
      ..writeByte(15)
      ..write(obj.releaseDate)
      ..writeByte(16)
      ..write(obj.revenue)
      ..writeByte(17)
      ..write(obj.runtime)
      ..writeByte(18)
      ..write(obj.spokenLanguages)
      ..writeByte(19)
      ..write(obj.status)
      ..writeByte(20)
      ..write(obj.tagline)
      ..writeByte(21)
      ..write(obj.title)
      ..writeByte(22)
      ..write(obj.video)
      ..writeByte(23)
      ..write(obj.voteAverage)
      ..writeByte(24)
      ..write(obj.voteCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovieDetailAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class GenreAdapter extends TypeAdapter<Genre> {
  @override
  final typeId = 61;

  @override
  Genre read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Genre(
      id: fields[0] == null ? 0 : (fields[0] as num).toInt(),
      name: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Genre obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GenreAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SpokenLanguageAdapter extends TypeAdapter<SpokenLanguage> {
  @override
  final typeId = 64;

  @override
  SpokenLanguage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SpokenLanguage(
      englishName: fields[0] as String?,
      iso6391: fields[1] as String?,
      name: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SpokenLanguage obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.englishName)
      ..writeByte(1)
      ..write(obj.iso6391)
      ..writeByte(2)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SpokenLanguageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MovieDetail _$MovieDetailFromJson(Map<String, dynamic> json) => _MovieDetail(
  adult: json['adult'] as bool? ?? true,
  backdropPath: json['backdrop_path'] as String?,
  belongsToCollection: json['belongs_to_collection'] as String?,
  budget: (json['budget'] as num?)?.toInt() ?? 0,
  genres: (json['genres'] as List<dynamic>?)
      ?.map((e) => Genre.fromJson(e as Map<String, dynamic>))
      .toList(),
  homepage: json['homepage'] as String?,
  id: (json['id'] as num).toInt(),
  imdbId: json['imdb_id'] as String?,
  originalLanguage: json['original_language'] as String?,
  originalTitle: json['original_title'] as String?,
  overview: json['overview'] as String?,
  popularity: (json['popularity'] as num?)?.toDouble() ?? 0.0,
  posterPath: json['poster_path'] as String?,
  productionCompanies: (json['production_companies'] as List<dynamic>?)
      ?.map((e) => ProductionCompany.fromJson(e as Map<String, dynamic>))
      .toList(),
  productionCountries: (json['production_countries'] as List<dynamic>?)
      ?.map((e) => ProductionCountry.fromJson(e as Map<String, dynamic>))
      .toList(),
  releaseDate: json['release_date'] as String?,
  revenue: (json['revenue'] as num?)?.toInt() ?? 0,
  runtime: (json['runtime'] as num?)?.toInt() ?? 0,
  spokenLanguages: (json['spoken_languages'] as List<dynamic>?)
      ?.map((e) => SpokenLanguage.fromJson(e as Map<String, dynamic>))
      .toList(),
  status: json['status'] as String?,
  tagline: json['tagline'] as String?,
  title: json['title'] as String,
  video: json['video'] as bool? ?? true,
  voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
  voteCount: (json['vote_count'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$MovieDetailToJson(
  _MovieDetail instance,
) => <String, dynamic>{
  'adult': instance.adult,
  'backdrop_path': instance.backdropPath,
  'belongs_to_collection': instance.belongsToCollection,
  'budget': instance.budget,
  'genres': instance.genres?.map((e) => e.toJson()).toList(),
  'homepage': instance.homepage,
  'id': instance.id,
  'imdb_id': instance.imdbId,
  'original_language': instance.originalLanguage,
  'original_title': instance.originalTitle,
  'overview': instance.overview,
  'popularity': instance.popularity,
  'poster_path': instance.posterPath,
  'production_companies': instance.productionCompanies
      ?.map((e) => e.toJson())
      .toList(),
  'production_countries': instance.productionCountries
      ?.map((e) => e.toJson())
      .toList(),
  'release_date': instance.releaseDate,
  'revenue': instance.revenue,
  'runtime': instance.runtime,
  'spoken_languages': instance.spokenLanguages?.map((e) => e.toJson()).toList(),
  'status': instance.status,
  'tagline': instance.tagline,
  'title': instance.title,
  'video': instance.video,
  'vote_average': instance.voteAverage,
  'vote_count': instance.voteCount,
};

_Genre _$GenreFromJson(Map<String, dynamic> json) => _Genre(
  id: (json['id'] as num?)?.toInt() ?? 0,
  name: json['name'] as String,
);

Map<String, dynamic> _$GenreToJson(_Genre instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
};

_SpokenLanguage _$SpokenLanguageFromJson(Map<String, dynamic> json) =>
    _SpokenLanguage(
      englishName: json['english_name'] as String?,
      iso6391: json['iso_639_1'] as String?,
      name: json['name'] as String,
    );

Map<String, dynamic> _$SpokenLanguageToJson(_SpokenLanguage instance) =>
    <String, dynamic>{
      'english_name': instance.englishName,
      'iso_639_1': instance.iso6391,
      'name': instance.name,
    };
