// lib/models/watched_tracker.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';

part 'watched_tracker.freezed.dart';
part 'watched_tracker.g.dart';

@HiveType(typeId: 220, adapterName: 'WatchedTrackerTypeAdapter')
enum WatchedTrackerType {
  @HiveField(0)
  movie,
  @HiveField(1)
  tvSeries,
  @HiveField(2)
  anime,
}

@freezed
abstract class WatchedTracker with _$WatchedTracker {
  const WatchedTracker._();

  // movie
  @JsonSerializable()
  @HiveType(typeId: 221, adapterName: 'WatchedTrackerMovieAdapter')
  const factory WatchedTracker.movie({
    @HiveField(0) required String id,
    @HiveField(1) String? playedUrl,
  }) = WatchedTrackerMovie;

  // series episode (type = tvSeries or anime)
  @JsonSerializable()
  @HiveType(typeId: 222, adapterName: 'WatchedTrackerSeriesEpisodeAdapter')
  const factory WatchedTracker.seriesEpisode({
    @HiveField(0) required WatchedTrackerType type, // tvSeries or anime
    @HiveField(1) required String seriesId,
    @HiveField(2) required String seriesName,
    @HiveField(3) required int itemId, // episode id/number
    @HiveField(4) required int seasonNumber,
  }) = WatchedTrackerSeriesEpisode;

  factory WatchedTracker.fromJson(Map<String, dynamic> json) =>
      _$WatchedTrackerFromJson(json);

  String get uniqueId => map(
    movie: (m) => 'movie_${m.id}',
    seriesEpisode: (e) =>
        '${e.type.name}_${e.seriesId}_s${e.seasonNumber}_e${e.itemId}',
  );
}
