// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watched_tracker.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WatchedTrackerMovieAdapter extends TypeAdapter<WatchedTrackerMovie> {
  @override
  final typeId = 221;

  @override
  WatchedTrackerMovie read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WatchedTrackerMovie(
      id: fields[0] as String,
      playedUrl: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, WatchedTrackerMovie obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.playedUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WatchedTrackerMovieAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WatchedTrackerSeriesEpisodeAdapter
    extends TypeAdapter<WatchedTrackerSeriesEpisode> {
  @override
  final typeId = 222;

  @override
  WatchedTrackerSeriesEpisode read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WatchedTrackerSeriesEpisode(
      type: fields[0] as WatchedTrackerType,
      seriesId: fields[1] as String,
      seriesName: fields[2] as String,
      itemId: (fields[3] as num).toInt(),
      seasonNumber: (fields[4] as num).toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, WatchedTrackerSeriesEpisode obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.seriesId)
      ..writeByte(2)
      ..write(obj.seriesName)
      ..writeByte(3)
      ..write(obj.itemId)
      ..writeByte(4)
      ..write(obj.seasonNumber);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WatchedTrackerSeriesEpisodeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WatchedTrackerTypeAdapter extends TypeAdapter<WatchedTrackerType> {
  @override
  final typeId = 220;

  @override
  WatchedTrackerType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return WatchedTrackerType.movie;
      case 1:
        return WatchedTrackerType.tvSeries;
      case 2:
        return WatchedTrackerType.anime;
      default:
        return WatchedTrackerType.movie;
    }
  }

  @override
  void write(BinaryWriter writer, WatchedTrackerType obj) {
    switch (obj) {
      case WatchedTrackerType.movie:
        writer.writeByte(0);
      case WatchedTrackerType.tvSeries:
        writer.writeByte(1);
      case WatchedTrackerType.anime:
        writer.writeByte(2);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WatchedTrackerTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WatchedTrackerMovie _$WatchedTrackerMovieFromJson(Map<String, dynamic> json) =>
    WatchedTrackerMovie(
      id: json['id'] as String,
      playedUrl: json['playedUrl'] as String?,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$WatchedTrackerMovieToJson(
  WatchedTrackerMovie instance,
) => <String, dynamic>{
  'id': instance.id,
  'playedUrl': instance.playedUrl,
  'runtimeType': instance.$type,
};

WatchedTrackerSeriesEpisode _$WatchedTrackerSeriesEpisodeFromJson(
  Map<String, dynamic> json,
) => WatchedTrackerSeriesEpisode(
  type: $enumDecode(_$WatchedTrackerTypeEnumMap, json['type']),
  seriesId: json['seriesId'] as String,
  seriesName: json['seriesName'] as String,
  itemId: (json['itemId'] as num).toInt(),
  seasonNumber: (json['seasonNumber'] as num).toInt(),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$WatchedTrackerSeriesEpisodeToJson(
  WatchedTrackerSeriesEpisode instance,
) => <String, dynamic>{
  'type': _$WatchedTrackerTypeEnumMap[instance.type]!,
  'seriesId': instance.seriesId,
  'seriesName': instance.seriesName,
  'itemId': instance.itemId,
  'seasonNumber': instance.seasonNumber,
  'runtimeType': instance.$type,
};

const _$WatchedTrackerTypeEnumMap = {
  WatchedTrackerType.movie: 'movie',
  WatchedTrackerType.tvSeries: 'tvSeries',
  WatchedTrackerType.anime: 'anime',
};
