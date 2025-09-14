// lib/models/watchlist_item.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';

part 'watchlist_item.freezed.dart';
part 'watchlist_item.g.dart';

@HiveType(typeId: 210, adapterName: 'WatchlistItemTypeAdapter')
enum WatchlistItemType {
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
abstract class WatchlistItem with _$WatchlistItem {
  const WatchlistItem._();

  // movie
  @JsonSerializable()
  @HiveType(typeId: 211, adapterName: 'WatchlistMovieItemAdapter')
  const factory WatchlistItem.movie({@HiveField(0) required String id}) =
      WatchlistMovieItem;

  // tvSeries
  @JsonSerializable()
  @HiveType(typeId: 212, adapterName: 'WatchlistTvSeriesItemAdapter')
  const factory WatchlistItem.tvSeries({@HiveField(0) required String id}) =
      WatchlistTvSeriesItem;

  // anime
  @JsonSerializable()
  @HiveType(typeId: 213, adapterName: 'WatchlistAnimeItemAdapter')
  const factory WatchlistItem.anime({@HiveField(0) required String id}) =
      WatchlistAnimeItem;

  // season (type: tvSeries or anime)
  @JsonSerializable()
  @HiveType(typeId: 214, adapterName: 'WatchlistSeasonItemAdapter')
  const factory WatchlistItem.season({
    // Only use tvSeries or anime here
    @HiveField(0) required WatchlistItemType type,
    @HiveField(1) required String seriesId,
    @HiveField(2) required int seasonNumber,
  }) = WatchlistSeasonItem;

  // episode (type: tvSeries or anime)
  @JsonSerializable()
  @HiveType(typeId: 215, adapterName: 'WatchlistEpisodeItemAdapter')
  const factory WatchlistItem.episode({
    // Only use tvSeries or anime here
    @HiveField(0) required WatchlistItemType type,
    @HiveField(1) required String seriesId,
    @HiveField(2) required int seasonNumber,
    @HiveField(3) required int episodeNumber,
  }) = WatchlistEpisodeItem;

  factory WatchlistItem.fromJson(Map<String, dynamic> json) =>
      _$WatchlistItemFromJson(json);

  String get uniqueId => map(
    movie: (m) => 'movie_${m.id}',
    tvSeries: (t) => 'tv_${t.id}',
    anime: (a) => 'anime_${a.id}',
    season: (s) => '${s.type.name}_${s.seriesId}_s${s.seasonNumber}',
    episode: (e) =>
        '${e.type.name}_${e.seriesId}_s${e.seasonNumber}_e${e.episodeNumber}',
  );
}
