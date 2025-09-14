// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'season_summary.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SeasonSummaryAdapter extends TypeAdapter<SeasonSummary> {
  @override
  final typeId = 130;

  @override
  SeasonSummary read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SeasonSummary(
      airDate: fields[0] as String?,
      episodeCount: (fields[1] as num).toInt(),
      id: (fields[2] as num).toInt(),
      name: fields[3] as String,
      overview: fields[4] as String?,
      posterPath: fields[5] as String?,
      seasonNumber: (fields[6] as num).toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, SeasonSummary obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.airDate)
      ..writeByte(1)
      ..write(obj.episodeCount)
      ..writeByte(2)
      ..write(obj.id)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.overview)
      ..writeByte(5)
      ..write(obj.posterPath)
      ..writeByte(6)
      ..write(obj.seasonNumber);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SeasonSummaryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SeasonSummary _$SeasonSummaryFromJson(Map<String, dynamic> json) =>
    _SeasonSummary(
      airDate: json['air_date'] as String?,
      episodeCount: (json['episode_count'] as num).toInt(),
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      overview: json['overview'] as String?,
      posterPath: json['poster_path'] as String?,
      seasonNumber: (json['season_number'] as num).toInt(),
    );

Map<String, dynamic> _$SeasonSummaryToJson(_SeasonSummary instance) =>
    <String, dynamic>{
      'air_date': instance.airDate,
      'episode_count': instance.episodeCount,
      'id': instance.id,
      'name': instance.name,
      'overview': instance.overview,
      'poster_path': instance.posterPath,
      'season_number': instance.seasonNumber,
    };
