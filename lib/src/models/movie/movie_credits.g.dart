// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_credits.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MovieCreditsAdapter extends TypeAdapter<MovieCredits> {
  @override
  final typeId = 120;

  @override
  MovieCredits read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MovieCredits(
      id: (fields[0] as num).toInt(),
      cast: (fields[1] as List).cast<MovieCastMember>(),
      crew: (fields[2] as List).cast<MovieCrewMember>(),
    );
  }

  @override
  void write(BinaryWriter writer, MovieCredits obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.cast)
      ..writeByte(2)
      ..write(obj.crew);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovieCreditsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MovieCastMemberAdapter extends TypeAdapter<MovieCastMember> {
  @override
  final typeId = 121;

  @override
  MovieCastMember read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MovieCastMember(
      adult: fields[0] == null ? true : fields[0] as bool,
      gender: fields[1] == null ? 0 : (fields[1] as num).toInt(),
      id: fields[2] == null ? 0 : (fields[2] as num).toInt(),
      knownForDepartment: fields[3] as String?,
      name: fields[4] as String,
      originalName: fields[5] as String?,
      popularity: fields[6] == null ? 0.0 : (fields[6] as num).toDouble(),
      profilePath: fields[7] as String?,
      castId: fields[8] == null ? 0 : (fields[8] as num).toInt(),
      character: fields[9] as String?,
      creditId: fields[10] as String?,
      order: fields[11] == null ? 0 : (fields[11] as num).toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, MovieCastMember obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.adult)
      ..writeByte(1)
      ..write(obj.gender)
      ..writeByte(2)
      ..write(obj.id)
      ..writeByte(3)
      ..write(obj.knownForDepartment)
      ..writeByte(4)
      ..write(obj.name)
      ..writeByte(5)
      ..write(obj.originalName)
      ..writeByte(6)
      ..write(obj.popularity)
      ..writeByte(7)
      ..write(obj.profilePath)
      ..writeByte(8)
      ..write(obj.castId)
      ..writeByte(9)
      ..write(obj.character)
      ..writeByte(10)
      ..write(obj.creditId)
      ..writeByte(11)
      ..write(obj.order);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovieCastMemberAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MovieCrewMemberAdapter extends TypeAdapter<MovieCrewMember> {
  @override
  final typeId = 122;

  @override
  MovieCrewMember read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MovieCrewMember(
      adult: fields[0] == null ? true : fields[0] as bool,
      gender: fields[1] == null ? 0 : (fields[1] as num).toInt(),
      id: fields[2] == null ? 0 : (fields[2] as num).toInt(),
      knownForDepartment: fields[3] as String?,
      name: fields[4] as String,
      originalName: fields[5] as String?,
      popularity: fields[6] == null ? 0.0 : (fields[6] as num).toDouble(),
      profilePath: fields[7] as String?,
      creditId: fields[8] as String?,
      department: fields[9] as String?,
      job: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MovieCrewMember obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.adult)
      ..writeByte(1)
      ..write(obj.gender)
      ..writeByte(2)
      ..write(obj.id)
      ..writeByte(3)
      ..write(obj.knownForDepartment)
      ..writeByte(4)
      ..write(obj.name)
      ..writeByte(5)
      ..write(obj.originalName)
      ..writeByte(6)
      ..write(obj.popularity)
      ..writeByte(7)
      ..write(obj.profilePath)
      ..writeByte(8)
      ..write(obj.creditId)
      ..writeByte(9)
      ..write(obj.department)
      ..writeByte(10)
      ..write(obj.job);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovieCrewMemberAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MovieCredits _$MovieCreditsFromJson(Map<String, dynamic> json) =>
    _MovieCredits(
      id: (json['id'] as num).toInt(),
      cast: (json['cast'] as List<dynamic>)
          .map((e) => MovieCastMember.fromJson(e as Map<String, dynamic>))
          .toList(),
      crew: (json['crew'] as List<dynamic>)
          .map((e) => MovieCrewMember.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MovieCreditsToJson(_MovieCredits instance) =>
    <String, dynamic>{
      'id': instance.id,
      'cast': instance.cast.map((e) => e.toJson()).toList(),
      'crew': instance.crew.map((e) => e.toJson()).toList(),
    };

_MovieCastMember _$MovieCastMemberFromJson(Map<String, dynamic> json) =>
    _MovieCastMember(
      adult: json['adult'] as bool? ?? true,
      gender: (json['gender'] as num?)?.toInt() ?? 0,
      id: (json['id'] as num?)?.toInt() ?? 0,
      knownForDepartment: json['known_for_department'] as String?,
      name: json['name'] as String,
      originalName: json['original_name'] as String?,
      popularity: (json['popularity'] as num?)?.toDouble() ?? 0.0,
      profilePath: json['profile_path'] as String?,
      castId: (json['cast_id'] as num?)?.toInt() ?? 0,
      character: json['character'] as String?,
      creditId: json['credit_id'] as String?,
      order: (json['order'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$MovieCastMemberToJson(_MovieCastMember instance) =>
    <String, dynamic>{
      'adult': instance.adult,
      'gender': instance.gender,
      'id': instance.id,
      'known_for_department': instance.knownForDepartment,
      'name': instance.name,
      'original_name': instance.originalName,
      'popularity': instance.popularity,
      'profile_path': instance.profilePath,
      'cast_id': instance.castId,
      'character': instance.character,
      'credit_id': instance.creditId,
      'order': instance.order,
    };

_MovieCrewMember _$MovieCrewMemberFromJson(Map<String, dynamic> json) =>
    _MovieCrewMember(
      adult: json['adult'] as bool? ?? true,
      gender: (json['gender'] as num?)?.toInt() ?? 0,
      id: (json['id'] as num?)?.toInt() ?? 0,
      knownForDepartment: json['known_for_department'] as String?,
      name: json['name'] as String,
      originalName: json['original_name'] as String?,
      popularity: (json['popularity'] as num?)?.toDouble() ?? 0.0,
      profilePath: json['profile_path'] as String?,
      creditId: json['credit_id'] as String?,
      department: json['department'] as String?,
      job: json['job'] as String?,
    );

Map<String, dynamic> _$MovieCrewMemberToJson(_MovieCrewMember instance) =>
    <String, dynamic>{
      'adult': instance.adult,
      'gender': instance.gender,
      'id': instance.id,
      'known_for_department': instance.knownForDepartment,
      'name': instance.name,
      'original_name': instance.originalName,
      'popularity': instance.popularity,
      'profile_path': instance.profilePath,
      'credit_id': instance.creditId,
      'department': instance.department,
      'job': instance.job,
    };
