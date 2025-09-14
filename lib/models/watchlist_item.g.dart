// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watchlist_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WatchlistMovieItemAdapter extends TypeAdapter<WatchlistMovieItem> {
  @override
  final typeId = 211;

  @override
  WatchlistMovieItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WatchlistMovieItem(id: fields[0] as String);
  }

  @override
  void write(BinaryWriter writer, WatchlistMovieItem obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WatchlistMovieItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WatchlistTvSeriesItemAdapter extends TypeAdapter<WatchlistTvSeriesItem> {
  @override
  final typeId = 212;

  @override
  WatchlistTvSeriesItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WatchlistTvSeriesItem(id: fields[0] as String);
  }

  @override
  void write(BinaryWriter writer, WatchlistTvSeriesItem obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WatchlistTvSeriesItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WatchlistAnimeItemAdapter extends TypeAdapter<WatchlistAnimeItem> {
  @override
  final typeId = 213;

  @override
  WatchlistAnimeItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WatchlistAnimeItem(id: fields[0] as String);
  }

  @override
  void write(BinaryWriter writer, WatchlistAnimeItem obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WatchlistAnimeItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WatchlistSeasonItemAdapter extends TypeAdapter<WatchlistSeasonItem> {
  @override
  final typeId = 214;

  @override
  WatchlistSeasonItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WatchlistSeasonItem(
      type: fields[0] as WatchlistItemType,
      seriesId: fields[1] as String,
      seasonNumber: (fields[2] as num).toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, WatchlistSeasonItem obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.seriesId)
      ..writeByte(2)
      ..write(obj.seasonNumber);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WatchlistSeasonItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WatchlistEpisodeItemAdapter extends TypeAdapter<WatchlistEpisodeItem> {
  @override
  final typeId = 215;

  @override
  WatchlistEpisodeItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WatchlistEpisodeItem(
      type: fields[0] as WatchlistItemType,
      seriesId: fields[1] as String,
      seasonNumber: (fields[2] as num).toInt(),
      episodeNumber: (fields[3] as num).toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, WatchlistEpisodeItem obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.seriesId)
      ..writeByte(2)
      ..write(obj.seasonNumber)
      ..writeByte(3)
      ..write(obj.episodeNumber);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WatchlistEpisodeItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WatchlistItemTypeAdapter extends TypeAdapter<WatchlistItemType> {
  @override
  final typeId = 210;

  @override
  WatchlistItemType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return WatchlistItemType.movie;
      case 1:
        return WatchlistItemType.tvSeries;
      case 2:
        return WatchlistItemType.anime;
      case 3:
        return WatchlistItemType.season;
      case 4:
        return WatchlistItemType.episode;
      default:
        return WatchlistItemType.movie;
    }
  }

  @override
  void write(BinaryWriter writer, WatchlistItemType obj) {
    switch (obj) {
      case WatchlistItemType.movie:
        writer.writeByte(0);
      case WatchlistItemType.tvSeries:
        writer.writeByte(1);
      case WatchlistItemType.anime:
        writer.writeByte(2);
      case WatchlistItemType.season:
        writer.writeByte(3);
      case WatchlistItemType.episode:
        writer.writeByte(4);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WatchlistItemTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WatchlistMovieItem _$WatchlistMovieItemFromJson(Map<String, dynamic> json) =>
    WatchlistMovieItem(
      id: json['id'] as String,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$WatchlistMovieItemToJson(WatchlistMovieItem instance) =>
    <String, dynamic>{'id': instance.id, 'runtimeType': instance.$type};

WatchlistTvSeriesItem _$WatchlistTvSeriesItemFromJson(
  Map<String, dynamic> json,
) => WatchlistTvSeriesItem(
  id: json['id'] as String,
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$WatchlistTvSeriesItemToJson(
  WatchlistTvSeriesItem instance,
) => <String, dynamic>{'id': instance.id, 'runtimeType': instance.$type};

WatchlistAnimeItem _$WatchlistAnimeItemFromJson(Map<String, dynamic> json) =>
    WatchlistAnimeItem(
      id: json['id'] as String,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$WatchlistAnimeItemToJson(WatchlistAnimeItem instance) =>
    <String, dynamic>{'id': instance.id, 'runtimeType': instance.$type};

WatchlistSeasonItem _$WatchlistSeasonItemFromJson(Map<String, dynamic> json) =>
    WatchlistSeasonItem(
      type: $enumDecode(_$WatchlistItemTypeEnumMap, json['type']),
      seriesId: json['seriesId'] as String,
      seasonNumber: (json['seasonNumber'] as num).toInt(),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$WatchlistSeasonItemToJson(
  WatchlistSeasonItem instance,
) => <String, dynamic>{
  'type': _$WatchlistItemTypeEnumMap[instance.type]!,
  'seriesId': instance.seriesId,
  'seasonNumber': instance.seasonNumber,
  'runtimeType': instance.$type,
};

const _$WatchlistItemTypeEnumMap = {
  WatchlistItemType.movie: 'movie',
  WatchlistItemType.tvSeries: 'tvSeries',
  WatchlistItemType.anime: 'anime',
  WatchlistItemType.season: 'season',
  WatchlistItemType.episode: 'episode',
};

WatchlistEpisodeItem _$WatchlistEpisodeItemFromJson(
  Map<String, dynamic> json,
) => WatchlistEpisodeItem(
  type: $enumDecode(_$WatchlistItemTypeEnumMap, json['type']),
  seriesId: json['seriesId'] as String,
  seasonNumber: (json['seasonNumber'] as num).toInt(),
  episodeNumber: (json['episodeNumber'] as num).toInt(),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$WatchlistEpisodeItemToJson(
  WatchlistEpisodeItem instance,
) => <String, dynamic>{
  'type': _$WatchlistItemTypeEnumMap[instance.type]!,
  'seriesId': instance.seriesId,
  'seasonNumber': instance.seasonNumber,
  'episodeNumber': instance.episodeNumber,
  'runtimeType': instance.$type,
};
