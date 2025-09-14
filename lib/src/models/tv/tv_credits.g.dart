// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tv_credits.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TvCastAdapter extends TypeAdapter<TvCast> {
  @override
  final typeId = 132;

  @override
  TvCast read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TvCast(
      castId: (fields[0] as num?)?.toInt(),
      character: fields[1] as String?,
      creditId: fields[2] as String,
      gender: (fields[3] as num?)?.toInt(),
      id: (fields[4] as num).toInt(),
      name: fields[5] as String,
      order: (fields[6] as num?)?.toInt(),
      profilePath: fields[7] as String?,
      knownForDepartment: fields[8] as String?,
      popularity: (fields[9] as num?)?.toDouble(),
    );
  }

  @override
  void write(BinaryWriter writer, TvCast obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.castId)
      ..writeByte(1)
      ..write(obj.character)
      ..writeByte(2)
      ..write(obj.creditId)
      ..writeByte(3)
      ..write(obj.gender)
      ..writeByte(4)
      ..write(obj.id)
      ..writeByte(5)
      ..write(obj.name)
      ..writeByte(6)
      ..write(obj.order)
      ..writeByte(7)
      ..write(obj.profilePath)
      ..writeByte(8)
      ..write(obj.knownForDepartment)
      ..writeByte(9)
      ..write(obj.popularity);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TvCastAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TvCrewAdapter extends TypeAdapter<TvCrew> {
  @override
  final typeId = 133;

  @override
  TvCrew read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TvCrew(
      creditId: fields[0] as String,
      department: fields[1] as String?,
      job: fields[2] as String?,
      gender: (fields[3] as num?)?.toInt(),
      id: (fields[4] as num).toInt(),
      name: fields[5] as String,
      profilePath: fields[6] as String?,
      knownForDepartment: fields[7] as String?,
      popularity: (fields[8] as num?)?.toDouble(),
    );
  }

  @override
  void write(BinaryWriter writer, TvCrew obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.creditId)
      ..writeByte(1)
      ..write(obj.department)
      ..writeByte(2)
      ..write(obj.job)
      ..writeByte(3)
      ..write(obj.gender)
      ..writeByte(4)
      ..write(obj.id)
      ..writeByte(5)
      ..write(obj.name)
      ..writeByte(6)
      ..write(obj.profilePath)
      ..writeByte(7)
      ..write(obj.knownForDepartment)
      ..writeByte(8)
      ..write(obj.popularity);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TvCrewAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TvCreditsResponseAdapter extends TypeAdapter<TvCreditsResponse> {
  @override
  final typeId = 134;

  @override
  TvCreditsResponse read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TvCreditsResponse(
      id: (fields[0] as num).toInt(),
      cast: (fields[1] as List).cast<TvCast>(),
      crew: (fields[2] as List).cast<TvCrew>(),
    );
  }

  @override
  void write(BinaryWriter writer, TvCreditsResponse obj) {
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
      other is TvCreditsResponseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TvCast _$TvCastFromJson(Map<String, dynamic> json) => _TvCast(
  castId: (json['castId'] as num?)?.toInt(),
  character: json['character'] as String?,
  creditId: json['credit_id'] as String,
  gender: (json['gender'] as num?)?.toInt(),
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  order: (json['order'] as num?)?.toInt(),
  profilePath: json['profile_path'] as String?,
  knownForDepartment: json['known_for_department'] as String?,
  popularity: (json['popularity'] as num?)?.toDouble(),
);

Map<String, dynamic> _$TvCastToJson(_TvCast instance) => <String, dynamic>{
  'castId': instance.castId,
  'character': instance.character,
  'credit_id': instance.creditId,
  'gender': instance.gender,
  'id': instance.id,
  'name': instance.name,
  'order': instance.order,
  'profile_path': instance.profilePath,
  'known_for_department': instance.knownForDepartment,
  'popularity': instance.popularity,
};

_TvCrew _$TvCrewFromJson(Map<String, dynamic> json) => _TvCrew(
  creditId: json['credit_id'] as String,
  department: json['department'] as String?,
  job: json['job'] as String?,
  gender: (json['gender'] as num?)?.toInt(),
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  profilePath: json['profile_path'] as String?,
  knownForDepartment: json['known_for_department'] as String?,
  popularity: (json['popularity'] as num?)?.toDouble(),
);

Map<String, dynamic> _$TvCrewToJson(_TvCrew instance) => <String, dynamic>{
  'credit_id': instance.creditId,
  'department': instance.department,
  'job': instance.job,
  'gender': instance.gender,
  'id': instance.id,
  'name': instance.name,
  'profile_path': instance.profilePath,
  'known_for_department': instance.knownForDepartment,
  'popularity': instance.popularity,
};

_TvCreditsResponse _$TvCreditsResponseFromJson(Map<String, dynamic> json) =>
    _TvCreditsResponse(
      id: (json['id'] as num).toInt(),
      cast: (json['cast'] as List<dynamic>)
          .map((e) => TvCast.fromJson(e as Map<String, dynamic>))
          .toList(),
      crew: (json['crew'] as List<dynamic>)
          .map((e) => TvCrew.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TvCreditsResponseToJson(_TvCreditsResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'cast': instance.cast.map((e) => e.toJson()).toList(),
      'crew': instance.crew.map((e) => e.toJson()).toList(),
    };
