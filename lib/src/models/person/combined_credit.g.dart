// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'combined_credit.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PersonCreditsAdapter extends TypeAdapter<PersonCredits> {
  @override
  final typeId = 110;

  @override
  PersonCredits read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PersonCredits(
      cast: (fields[0] as List).cast<CastCredit>(),
      crew: (fields[1] as List).cast<CrewCredit>(),
    );
  }

  @override
  void write(BinaryWriter writer, PersonCredits obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.cast)
      ..writeByte(1)
      ..write(obj.crew);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PersonCreditsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CastCreditAdapter extends TypeAdapter<CastCredit> {
  @override
  final typeId = 111;

  @override
  CastCredit read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CastCredit(
      adult: fields[0] == null ? true : fields[0] as bool,
      backdropPath: fields[1] as String?,
      genreIds: (fields[2] as List?)?.cast<int>(),
      id: fields[3] == null ? 0 : (fields[3] as num).toInt(),
      originalLanguage: fields[4] as String?,
      originalTitle: fields[5] as String?,
      overview: fields[6] as String?,
      popularity: fields[7] == null ? 0.0 : (fields[7] as num).toDouble(),
      posterPath: fields[8] as String?,
      releaseDate: fields[9] as String?,
      title: fields[10] as String?,
      video: fields[11] == null ? true : fields[11] as bool,
      voteAverage: fields[12] == null ? 0.0 : (fields[12] as num).toDouble(),
      voteCount: fields[13] == null ? 0 : (fields[13] as num).toInt(),
      character: fields[14] as String?,
      creditId: fields[15] as String?,
      order: fields[16] == null ? 0 : (fields[16] as num).toInt(),
      mediaType: fields[17] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CastCredit obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.adult)
      ..writeByte(1)
      ..write(obj.backdropPath)
      ..writeByte(2)
      ..write(obj.genreIds)
      ..writeByte(3)
      ..write(obj.id)
      ..writeByte(4)
      ..write(obj.originalLanguage)
      ..writeByte(5)
      ..write(obj.originalTitle)
      ..writeByte(6)
      ..write(obj.overview)
      ..writeByte(7)
      ..write(obj.popularity)
      ..writeByte(8)
      ..write(obj.posterPath)
      ..writeByte(9)
      ..write(obj.releaseDate)
      ..writeByte(10)
      ..write(obj.title)
      ..writeByte(11)
      ..write(obj.video)
      ..writeByte(12)
      ..write(obj.voteAverage)
      ..writeByte(13)
      ..write(obj.voteCount)
      ..writeByte(14)
      ..write(obj.character)
      ..writeByte(15)
      ..write(obj.creditId)
      ..writeByte(16)
      ..write(obj.order)
      ..writeByte(17)
      ..write(obj.mediaType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CastCreditAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CrewCreditAdapter extends TypeAdapter<CrewCredit> {
  @override
  final typeId = 112;

  @override
  CrewCredit read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CrewCredit(
      adult: fields[0] == null ? true : fields[0] as bool,
      backdropPath: fields[1] as String?,
      genreIds: (fields[2] as List?)?.cast<int>(),
      id: fields[3] == null ? 0 : (fields[3] as num).toInt(),
      originalLanguage: fields[4] as String?,
      originalTitle: fields[5] as String?,
      overview: fields[6] as String?,
      popularity: fields[7] == null ? 0.0 : (fields[7] as num).toDouble(),
      posterPath: fields[8] as String?,
      releaseDate: fields[9] as String?,
      title: fields[10] as String?,
      video: fields[11] == null ? true : fields[11] as bool,
      voteAverage: fields[12] == null ? 0.0 : (fields[12] as num).toDouble(),
      voteCount: fields[13] == null ? 0 : (fields[13] as num).toInt(),
      creditId: fields[14] as String?,
      department: fields[15] as String?,
      job: fields[16] as String?,
      mediaType: fields[17] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CrewCredit obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.adult)
      ..writeByte(1)
      ..write(obj.backdropPath)
      ..writeByte(2)
      ..write(obj.genreIds)
      ..writeByte(3)
      ..write(obj.id)
      ..writeByte(4)
      ..write(obj.originalLanguage)
      ..writeByte(5)
      ..write(obj.originalTitle)
      ..writeByte(6)
      ..write(obj.overview)
      ..writeByte(7)
      ..write(obj.popularity)
      ..writeByte(8)
      ..write(obj.posterPath)
      ..writeByte(9)
      ..write(obj.releaseDate)
      ..writeByte(10)
      ..write(obj.title)
      ..writeByte(11)
      ..write(obj.video)
      ..writeByte(12)
      ..write(obj.voteAverage)
      ..writeByte(13)
      ..write(obj.voteCount)
      ..writeByte(14)
      ..write(obj.creditId)
      ..writeByte(15)
      ..write(obj.department)
      ..writeByte(16)
      ..write(obj.job)
      ..writeByte(17)
      ..write(obj.mediaType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CrewCreditAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PersonCredits _$PersonCreditsFromJson(Map<String, dynamic> json) =>
    _PersonCredits(
      cast: (json['cast'] as List<dynamic>)
          .map((e) => CastCredit.fromJson(e as Map<String, dynamic>))
          .toList(),
      crew: (json['crew'] as List<dynamic>)
          .map((e) => CrewCredit.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PersonCreditsToJson(_PersonCredits instance) =>
    <String, dynamic>{
      'cast': instance.cast.map((e) => e.toJson()).toList(),
      'crew': instance.crew.map((e) => e.toJson()).toList(),
    };

_CastCredit _$CastCreditFromJson(Map<String, dynamic> json) => _CastCredit(
  adult: json['adult'] as bool? ?? true,
  backdropPath: json['backdrop_path'] as String?,
  genreIds: (json['genre_ids'] as List<dynamic>?)
      ?.map((e) => (e as num).toInt())
      .toList(),
  id: (json['id'] as num?)?.toInt() ?? 0,
  originalLanguage: json['original_language'] as String?,
  originalTitle: json['original_title'] as String?,
  overview: json['overview'] as String?,
  popularity: (json['popularity'] as num?)?.toDouble() ?? 0.0,
  posterPath: json['poster_path'] as String?,
  releaseDate: json['release_date'] as String?,
  title: json['title'] as String?,
  video: json['video'] as bool? ?? true,
  voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
  voteCount: (json['vote_count'] as num?)?.toInt() ?? 0,
  character: json['character'] as String?,
  creditId: json['credit_id'] as String?,
  order: (json['order'] as num?)?.toInt() ?? 0,
  mediaType: json['media_type'] as String?,
);

Map<String, dynamic> _$CastCreditToJson(_CastCredit instance) =>
    <String, dynamic>{
      'adult': instance.adult,
      'backdrop_path': instance.backdropPath,
      'genre_ids': instance.genreIds,
      'id': instance.id,
      'original_language': instance.originalLanguage,
      'original_title': instance.originalTitle,
      'overview': instance.overview,
      'popularity': instance.popularity,
      'poster_path': instance.posterPath,
      'release_date': instance.releaseDate,
      'title': instance.title,
      'video': instance.video,
      'vote_average': instance.voteAverage,
      'vote_count': instance.voteCount,
      'character': instance.character,
      'credit_id': instance.creditId,
      'order': instance.order,
      'media_type': instance.mediaType,
    };

_CrewCredit _$CrewCreditFromJson(Map<String, dynamic> json) => _CrewCredit(
  adult: json['adult'] as bool? ?? true,
  backdropPath: json['backdrop_path'] as String?,
  genreIds: (json['genre_ids'] as List<dynamic>?)
      ?.map((e) => (e as num).toInt())
      .toList(),
  id: (json['id'] as num?)?.toInt() ?? 0,
  originalLanguage: json['original_language'] as String?,
  originalTitle: json['original_title'] as String?,
  overview: json['overview'] as String?,
  popularity: (json['popularity'] as num?)?.toDouble() ?? 0.0,
  posterPath: json['poster_path'] as String?,
  releaseDate: json['release_date'] as String?,
  title: json['title'] as String?,
  video: json['video'] as bool? ?? true,
  voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
  voteCount: (json['vote_count'] as num?)?.toInt() ?? 0,
  creditId: json['credit_id'] as String?,
  department: json['department'] as String?,
  job: json['job'] as String?,
  mediaType: json['media_type'] as String?,
);

Map<String, dynamic> _$CrewCreditToJson(_CrewCredit instance) =>
    <String, dynamic>{
      'adult': instance.adult,
      'backdrop_path': instance.backdropPath,
      'genre_ids': instance.genreIds,
      'id': instance.id,
      'original_language': instance.originalLanguage,
      'original_title': instance.originalTitle,
      'overview': instance.overview,
      'popularity': instance.popularity,
      'poster_path': instance.posterPath,
      'release_date': instance.releaseDate,
      'title': instance.title,
      'video': instance.video,
      'vote_average': instance.voteAverage,
      'vote_count': instance.voteCount,
      'credit_id': instance.creditId,
      'department': instance.department,
      'job': instance.job,
      'media_type': instance.mediaType,
    };
