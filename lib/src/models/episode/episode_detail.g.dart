// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'episode_detail.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EpisodeDetailAdapter extends TypeAdapter<EpisodeDetail> {
  @override
  final typeId = 50;

  @override
  EpisodeDetail read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EpisodeDetail(
      airDate: fields[0] as String?,
      crew: (fields[1] as List?)?.cast<CrewMember>(),
      guestStars: (fields[2] as List?)?.cast<GuestStar>(),
      name: fields[3] as String,
      overview: fields[4] as String?,
      id: (fields[5] as num).toInt(),
      productionCode: fields[6] as String?,
      runtime: (fields[7] as num?)?.toInt(),
      seasonNumber: (fields[8] as num?)?.toInt(),
      episodeNumber: (fields[9] as num?)?.toInt(),
      stillPath: fields[10] as String?,
      voteAverage: (fields[11] as num?)?.toDouble(),
      voteCount: (fields[12] as num?)?.toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, EpisodeDetail obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.airDate)
      ..writeByte(1)
      ..write(obj.crew)
      ..writeByte(2)
      ..write(obj.guestStars)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.overview)
      ..writeByte(5)
      ..write(obj.id)
      ..writeByte(6)
      ..write(obj.productionCode)
      ..writeByte(7)
      ..write(obj.runtime)
      ..writeByte(8)
      ..write(obj.seasonNumber)
      ..writeByte(9)
      ..write(obj.episodeNumber)
      ..writeByte(10)
      ..write(obj.stillPath)
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
      other is EpisodeDetailAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CrewMemberAdapter extends TypeAdapter<CrewMember> {
  @override
  final typeId = 51;

  @override
  CrewMember read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CrewMember(
      department: fields[0] as String?,
      job: fields[1] as String?,
      creditId: fields[2] as String?,
      adult: fields[3] == null ? true : fields[3] as bool,
      gender: fields[4] == null ? 0 : (fields[4] as num).toInt(),
      id: fields[5] == null ? 0 : (fields[5] as num).toInt(),
      knownForDepartment: fields[6] as String?,
      name: fields[7] as String,
      originalName: fields[8] as String?,
      popularity: fields[9] == null ? 0.0 : (fields[9] as num).toDouble(),
      profilePath: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CrewMember obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.department)
      ..writeByte(1)
      ..write(obj.job)
      ..writeByte(2)
      ..write(obj.creditId)
      ..writeByte(3)
      ..write(obj.adult)
      ..writeByte(4)
      ..write(obj.gender)
      ..writeByte(5)
      ..write(obj.id)
      ..writeByte(6)
      ..write(obj.knownForDepartment)
      ..writeByte(7)
      ..write(obj.name)
      ..writeByte(8)
      ..write(obj.originalName)
      ..writeByte(9)
      ..write(obj.popularity)
      ..writeByte(10)
      ..write(obj.profilePath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CrewMemberAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class GuestStarAdapter extends TypeAdapter<GuestStar> {
  @override
  final typeId = 52;

  @override
  GuestStar read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GuestStar(
      character: fields[0] as String?,
      creditId: fields[1] as String?,
      order: fields[2] == null ? 0 : (fields[2] as num).toInt(),
      adult: fields[3] == null ? true : fields[3] as bool,
      gender: fields[4] == null ? 0 : (fields[4] as num).toInt(),
      id: fields[5] == null ? 0 : (fields[5] as num).toInt(),
      knownForDepartment: fields[6] as String?,
      name: fields[7] as String,
      originalName: fields[8] as String?,
      popularity: fields[9] == null ? 0.0 : (fields[9] as num).toDouble(),
      profilePath: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, GuestStar obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.character)
      ..writeByte(1)
      ..write(obj.creditId)
      ..writeByte(2)
      ..write(obj.order)
      ..writeByte(3)
      ..write(obj.adult)
      ..writeByte(4)
      ..write(obj.gender)
      ..writeByte(5)
      ..write(obj.id)
      ..writeByte(6)
      ..write(obj.knownForDepartment)
      ..writeByte(7)
      ..write(obj.name)
      ..writeByte(8)
      ..write(obj.originalName)
      ..writeByte(9)
      ..write(obj.popularity)
      ..writeByte(10)
      ..write(obj.profilePath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GuestStarAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EpisodeDetail _$EpisodeDetailFromJson(Map<String, dynamic> json) =>
    _EpisodeDetail(
      airDate: json['air_date'] as String?,
      crew: (json['crew'] as List<dynamic>?)
          ?.map((e) => CrewMember.fromJson(e as Map<String, dynamic>))
          .toList(),
      guestStars: (json['guest_stars'] as List<dynamic>?)
          ?.map((e) => GuestStar.fromJson(e as Map<String, dynamic>))
          .toList(),
      name: json['name'] as String,
      overview: json['overview'] as String?,
      id: (json['id'] as num).toInt(),
      productionCode: json['production_code'] as String?,
      runtime: (json['runtime'] as num?)?.toInt(),
      seasonNumber: (json['season_number'] as num?)?.toInt(),
      episodeNumber: (json['episode_number'] as num?)?.toInt(),
      stillPath: json['still_path'] as String?,
      voteAverage: (json['vote_average'] as num?)?.toDouble(),
      voteCount: (json['vote_count'] as num?)?.toInt(),
    );

Map<String, dynamic> _$EpisodeDetailToJson(_EpisodeDetail instance) =>
    <String, dynamic>{
      'air_date': instance.airDate,
      'crew': instance.crew?.map((e) => e.toJson()).toList(),
      'guest_stars': instance.guestStars?.map((e) => e.toJson()).toList(),
      'name': instance.name,
      'overview': instance.overview,
      'id': instance.id,
      'production_code': instance.productionCode,
      'runtime': instance.runtime,
      'season_number': instance.seasonNumber,
      'episode_number': instance.episodeNumber,
      'still_path': instance.stillPath,
      'vote_average': instance.voteAverage,
      'vote_count': instance.voteCount,
    };

_CrewMember _$CrewMemberFromJson(Map<String, dynamic> json) => _CrewMember(
  department: json['department'] as String?,
  job: json['job'] as String?,
  creditId: json['credit_id'] as String?,
  adult: json['adult'] as bool? ?? true,
  gender: (json['gender'] as num?)?.toInt() ?? 0,
  id: (json['id'] as num?)?.toInt() ?? 0,
  knownForDepartment: json['known_for_department'] as String?,
  name: json['name'] as String,
  originalName: json['original_name'] as String?,
  popularity: (json['popularity'] as num?)?.toDouble() ?? 0.0,
  profilePath: json['profile_path'] as String?,
);

Map<String, dynamic> _$CrewMemberToJson(_CrewMember instance) =>
    <String, dynamic>{
      'department': instance.department,
      'job': instance.job,
      'credit_id': instance.creditId,
      'adult': instance.adult,
      'gender': instance.gender,
      'id': instance.id,
      'known_for_department': instance.knownForDepartment,
      'name': instance.name,
      'original_name': instance.originalName,
      'popularity': instance.popularity,
      'profile_path': instance.profilePath,
    };

_GuestStar _$GuestStarFromJson(Map<String, dynamic> json) => _GuestStar(
  character: json['character'] as String?,
  creditId: json['credit_id'] as String?,
  order: (json['order'] as num?)?.toInt() ?? 0,
  adult: json['adult'] as bool? ?? true,
  gender: (json['gender'] as num?)?.toInt() ?? 0,
  id: (json['id'] as num?)?.toInt() ?? 0,
  knownForDepartment: json['known_for_department'] as String?,
  name: json['name'] as String,
  originalName: json['original_name'] as String?,
  popularity: (json['popularity'] as num?)?.toDouble() ?? 0.0,
  profilePath: json['profile_path'] as String?,
);

Map<String, dynamic> _$GuestStarToJson(_GuestStar instance) =>
    <String, dynamic>{
      'character': instance.character,
      'credit_id': instance.creditId,
      'order': instance.order,
      'adult': instance.adult,
      'gender': instance.gender,
      'id': instance.id,
      'known_for_department': instance.knownForDepartment,
      'name': instance.name,
      'original_name': instance.originalName,
      'popularity': instance.popularity,
      'profile_path': instance.profilePath,
    };
