// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FavoriteMovieItemAdapter extends TypeAdapter<FavoriteMovieItem> {
  @override
  final typeId = 201;

  @override
  FavoriteMovieItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FavoriteMovieItem(id: fields[0] as String);
  }

  @override
  void write(BinaryWriter writer, FavoriteMovieItem obj) {
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
      other is FavoriteMovieItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FavoriteTvSeriesItemAdapter extends TypeAdapter<FavoriteTvSeriesItem> {
  @override
  final typeId = 202;

  @override
  FavoriteTvSeriesItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FavoriteTvSeriesItem(id: fields[0] as String);
  }

  @override
  void write(BinaryWriter writer, FavoriteTvSeriesItem obj) {
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
      other is FavoriteTvSeriesItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FavoriteAnimeItemAdapter extends TypeAdapter<FavoriteAnimeItem> {
  @override
  final typeId = 203;

  @override
  FavoriteAnimeItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FavoriteAnimeItem(id: fields[0] as String);
  }

  @override
  void write(BinaryWriter writer, FavoriteAnimeItem obj) {
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
      other is FavoriteAnimeItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FavoriteSeasonItemAdapter extends TypeAdapter<FavoriteSeasonItem> {
  @override
  final typeId = 204;

  @override
  FavoriteSeasonItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FavoriteSeasonItem(
      type: fields[0] as FavoriteItemType,
      seriesId: fields[1] as String,
      seasonNumber: (fields[2] as num).toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, FavoriteSeasonItem obj) {
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
      other is FavoriteSeasonItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FavoriteEpisodeItemAdapter extends TypeAdapter<FavoriteEpisodeItem> {
  @override
  final typeId = 205;

  @override
  FavoriteEpisodeItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FavoriteEpisodeItem(
      type: fields[0] as FavoriteItemType,
      seriesId: fields[1] as String,
      seasonNumber: (fields[2] as num).toInt(),
      episodeNumber: (fields[3] as num).toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, FavoriteEpisodeItem obj) {
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
      other is FavoriteEpisodeItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FavoriteItemTypeAdapter extends TypeAdapter<FavoriteItemType> {
  @override
  final typeId = 200;

  @override
  FavoriteItemType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return FavoriteItemType.movie;
      case 1:
        return FavoriteItemType.tvSeries;
      case 2:
        return FavoriteItemType.anime;
      case 3:
        return FavoriteItemType.season;
      case 4:
        return FavoriteItemType.episode;
      default:
        return FavoriteItemType.movie;
    }
  }

  @override
  void write(BinaryWriter writer, FavoriteItemType obj) {
    switch (obj) {
      case FavoriteItemType.movie:
        writer.writeByte(0);
      case FavoriteItemType.tvSeries:
        writer.writeByte(1);
      case FavoriteItemType.anime:
        writer.writeByte(2);
      case FavoriteItemType.season:
        writer.writeByte(3);
      case FavoriteItemType.episode:
        writer.writeByte(4);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoriteItemTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FavoriteMovieItem _$FavoriteMovieItemFromJson(Map<String, dynamic> json) =>
    FavoriteMovieItem(
      id: json['id'] as String,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$FavoriteMovieItemToJson(FavoriteMovieItem instance) =>
    <String, dynamic>{'id': instance.id, 'runtimeType': instance.$type};

FavoriteTvSeriesItem _$FavoriteTvSeriesItemFromJson(
  Map<String, dynamic> json,
) => FavoriteTvSeriesItem(
  id: json['id'] as String,
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$FavoriteTvSeriesItemToJson(
  FavoriteTvSeriesItem instance,
) => <String, dynamic>{'id': instance.id, 'runtimeType': instance.$type};

FavoriteAnimeItem _$FavoriteAnimeItemFromJson(Map<String, dynamic> json) =>
    FavoriteAnimeItem(
      id: json['id'] as String,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$FavoriteAnimeItemToJson(FavoriteAnimeItem instance) =>
    <String, dynamic>{'id': instance.id, 'runtimeType': instance.$type};

FavoriteSeasonItem _$FavoriteSeasonItemFromJson(Map<String, dynamic> json) =>
    FavoriteSeasonItem(
      type: $enumDecode(_$FavoriteItemTypeEnumMap, json['type']),
      seriesId: json['seriesId'] as String,
      seasonNumber: (json['seasonNumber'] as num).toInt(),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$FavoriteSeasonItemToJson(FavoriteSeasonItem instance) =>
    <String, dynamic>{
      'type': _$FavoriteItemTypeEnumMap[instance.type]!,
      'seriesId': instance.seriesId,
      'seasonNumber': instance.seasonNumber,
      'runtimeType': instance.$type,
    };

const _$FavoriteItemTypeEnumMap = {
  FavoriteItemType.movie: 'movie',
  FavoriteItemType.tvSeries: 'tvSeries',
  FavoriteItemType.anime: 'anime',
  FavoriteItemType.season: 'season',
  FavoriteItemType.episode: 'episode',
};

FavoriteEpisodeItem _$FavoriteEpisodeItemFromJson(Map<String, dynamic> json) =>
    FavoriteEpisodeItem(
      type: $enumDecode(_$FavoriteItemTypeEnumMap, json['type']),
      seriesId: json['seriesId'] as String,
      seasonNumber: (json['seasonNumber'] as num).toInt(),
      episodeNumber: (json['episodeNumber'] as num).toInt(),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$FavoriteEpisodeItemToJson(
  FavoriteEpisodeItem instance,
) => <String, dynamic>{
  'type': _$FavoriteItemTypeEnumMap[instance.type]!,
  'seriesId': instance.seriesId,
  'seasonNumber': instance.seasonNumber,
  'episodeNumber': instance.episodeNumber,
  'runtimeType': instance.$type,
};
