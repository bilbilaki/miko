// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person_detail.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PersonDetailAdapter extends TypeAdapter<PersonDetail> {
  @override
  final typeId = 100;

  @override
  PersonDetail read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PersonDetail(
      adult: fields[0] == null ? true : fields[0] as bool,
      alsoKnownAs: (fields[1] as List?)?.cast<String>(),
      biography: fields[2] as String?,
      birthday: fields[3] as String?,
      deathday: fields[4] as String?,
      gender: fields[5] == null ? 0 : (fields[5] as num).toInt(),
      homepage: fields[6] as String?,
      id: (fields[7] as num).toInt(),
      imdbId: fields[8] as String?,
      knownForDepartment: fields[9] as String?,
      name: fields[10] as String,
      placeOfBirth: fields[11] as String?,
      popularity: fields[12] == null ? 0.0 : (fields[12] as num).toDouble(),
      profilePath: fields[13] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PersonDetail obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.adult)
      ..writeByte(1)
      ..write(obj.alsoKnownAs)
      ..writeByte(2)
      ..write(obj.biography)
      ..writeByte(3)
      ..write(obj.birthday)
      ..writeByte(4)
      ..write(obj.deathday)
      ..writeByte(5)
      ..write(obj.gender)
      ..writeByte(6)
      ..write(obj.homepage)
      ..writeByte(7)
      ..write(obj.id)
      ..writeByte(8)
      ..write(obj.imdbId)
      ..writeByte(9)
      ..write(obj.knownForDepartment)
      ..writeByte(10)
      ..write(obj.name)
      ..writeByte(11)
      ..write(obj.placeOfBirth)
      ..writeByte(12)
      ..write(obj.popularity)
      ..writeByte(13)
      ..write(obj.profilePath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PersonDetailAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PersonDetail _$PersonDetailFromJson(Map<String, dynamic> json) =>
    _PersonDetail(
      adult: json['adult'] as bool? ?? true,
      alsoKnownAs: (json['also_known_as'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      biography: json['biography'] as String?,
      birthday: json['birthday'] as String?,
      deathday: json['deathday'] as String?,
      gender: (json['gender'] as num?)?.toInt() ?? 0,
      homepage: json['homepage'] as String?,
      id: (json['id'] as num).toInt(),
      imdbId: json['imdb_id'] as String?,
      knownForDepartment: json['known_for_department'] as String?,
      name: json['name'] as String,
      placeOfBirth: json['place_of_birth'] as String?,
      popularity: (json['popularity'] as num?)?.toDouble() ?? 0.0,
      profilePath: json['profile_path'] as String?,
    );

Map<String, dynamic> _$PersonDetailToJson(_PersonDetail instance) =>
    <String, dynamic>{
      'adult': instance.adult,
      'also_known_as': instance.alsoKnownAs,
      'biography': instance.biography,
      'birthday': instance.birthday,
      'deathday': instance.deathday,
      'gender': instance.gender,
      'homepage': instance.homepage,
      'id': instance.id,
      'imdb_id': instance.imdbId,
      'known_for_department': instance.knownForDepartment,
      'name': instance.name,
      'place_of_birth': instance.placeOfBirth,
      'popularity': instance.popularity,
      'profile_path': instance.profilePath,
    };
