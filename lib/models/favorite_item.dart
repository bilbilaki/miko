// lib/models/favorite_item.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';

part 'favorite_item.freezed.dart';
part 'favorite_item.g.dart';

@HiveType(typeId: 200, adapterName: 'FavoriteItemTypeAdapter')
enum FavoriteItemType {
  @HiveField(0)
  movie,
  @HiveField(1)
  tvSeries,
  @HiveField(2)
  anime,
  @HiveField(3)
  season,
  @HiveField(4)
  episode,
}

@freezed
abstract class FavoriteItem with _$FavoriteItem {
  const FavoriteItem._();

  // movie
  @JsonSerializable()
  @HiveType(typeId: 201, adapterName: 'FavoriteMovieItemAdapter')
  const factory FavoriteItem.movie({@HiveField(0) required String id}) =
      FavoriteMovieItem;

  // tvSeries
  @JsonSerializable()
  @HiveType(typeId: 202, adapterName: 'FavoriteTvSeriesItemAdapter')
  const factory FavoriteItem.tvSeries({@HiveField(0) required String id}) =
      FavoriteTvSeriesItem;

  // anime
  @JsonSerializable()
  @HiveType(typeId: 203, adapterName: 'FavoriteAnimeItemAdapter')
  const factory FavoriteItem.anime({@HiveField(0) required String id}) =
      FavoriteAnimeItem;

  // season (type: tvSeries or anime)
  @JsonSerializable()
  @HiveType(typeId: 204, adapterName: 'FavoriteSeasonItemAdapter')
  const factory FavoriteItem.season({
    // Only use tvSeries or anime here
    @HiveField(0) required FavoriteItemType type,
    @HiveField(1) required String seriesId,
    @HiveField(2) required int seasonNumber,
  }) = FavoriteSeasonItem;

  // episode (type: tvSeries or anime)
  @JsonSerializable()
  @HiveType(typeId: 205, adapterName: 'FavoriteEpisodeItemAdapter')
  const factory FavoriteItem.episode({
    // Only use tvSeries or anime here
    @HiveField(0) required FavoriteItemType type,
    @HiveField(1) required String seriesId,
    @HiveField(2) required int seasonNumber,
    @HiveField(3) required int episodeNumber,
  }) = FavoriteEpisodeItem;

  factory FavoriteItem.fromJson(Map<String, dynamic> json) =>
      _$FavoriteItemFromJson(json);

  String get uniqueId => map(
    movie: (m) => 'movie_${m.id}',
    tvSeries: (t) => 'tv_${t.id}',
    anime: (a) => 'anime_${a.id}',
    season: (s) => '${s.type.name}_${s.seriesId}_s${s.seasonNumber}',
    episode: (e) =>
        '${e.type.name}_${e.seriesId}_s${e.seasonNumber}_e${e.episodeNumber}',
  );
}
