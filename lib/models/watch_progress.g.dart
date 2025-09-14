// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watch_progress.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WatchProgressMovieAdapter extends TypeAdapter<WatchProgressMovie> {
  @override
  final typeId = 231;

  @override
  WatchProgressMovie read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WatchProgressMovie(
      id: fields[0] as String,
      playedUrl: fields[1] as String?,
      duration: fields[2] as Duration,
    );
  }

  @override
  void write(BinaryWriter writer, WatchProgressMovie obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.playedUrl)
      ..writeByte(2)
      ..write(obj.duration);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WatchProgressMovieAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WatchProgressEpisodeAdapter extends TypeAdapter<WatchProgressEpisode> {
  @override
  final typeId = 232;

  @override
  WatchProgressEpisode read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WatchProgressEpisode(
      type: fields[0] as WatchProgressType,
      seriesId: fields[1] as String,
      seriesName: fields[2] as String,
      itemId: (fields[3] as num).toInt(),
      seasonNumber: (fields[4] as num).toInt(),
      duration: fields[5] as Duration,
    );
  }

  @override
  void write(BinaryWriter writer, WatchProgressEpisode obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.seriesId)
      ..writeByte(2)
      ..write(obj.seriesName)
      ..writeByte(3)
      ..write(obj.itemId)
      ..writeByte(4)
      ..write(obj.seasonNumber)
      ..writeByte(5)
      ..write(obj.duration);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WatchProgressEpisodeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WatchProgressTypeAdapter extends TypeAdapter<WatchProgressType> {
  @override
  final typeId = 230;

  @override
  WatchProgressType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return WatchProgressType.tvSeries;
      case 1:
        return WatchProgressType.anime;
      default:
        return WatchProgressType.tvSeries;
    }
  }

  @override
  void write(BinaryWriter writer, WatchProgressType obj) {
    switch (obj) {
      case WatchProgressType.tvSeries:
        writer.writeByte(0);
      case WatchProgressType.anime:
        writer.writeByte(1);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WatchProgressTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WatchProgressMovie _$WatchProgressMovieFromJson(Map<String, dynamic> json) =>
    WatchProgressMovie(
      id: json['id'] as String,
      playedUrl: json['playedUrl'] as String?,
      duration: Duration(microseconds: (json['duration'] as num).toInt()),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$WatchProgressMovieToJson(WatchProgressMovie instance) =>
    <String, dynamic>{
      'id': instance.id,
      'playedUrl': instance.playedUrl,
      'duration': instance.duration.inMicroseconds,
      'runtimeType': instance.$type,
    };

WatchProgressEpisode _$WatchProgressEpisodeFromJson(
  Map<String, dynamic> json,
) => WatchProgressEpisode(
  type: $enumDecode(_$WatchProgressTypeEnumMap, json['type']),
  seriesId: json['seriesId'] as String,
  seriesName: json['seriesName'] as String,
  itemId: (json['itemId'] as num).toInt(),
  seasonNumber: (json['seasonNumber'] as num).toInt(),
  duration: Duration(microseconds: (json['duration'] as num).toInt()),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$WatchProgressEpisodeToJson(
  WatchProgressEpisode instance,
) => <String, dynamic>{
  'type': _$WatchProgressTypeEnumMap[instance.type]!,
  'seriesId': instance.seriesId,
  'seriesName': instance.seriesName,
  'itemId': instance.itemId,
  'seasonNumber': instance.seasonNumber,
  'duration': instance.duration.inMicroseconds,
  'runtimeType': instance.$type,
};

const _$WatchProgressTypeEnumMap = {
  WatchProgressType.tvSeries: 'tvSeries',
  WatchProgressType.anime: 'anime',
};
