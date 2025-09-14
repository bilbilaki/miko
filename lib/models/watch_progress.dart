// lib/models/watch_progress.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';

part 'watch_progress.freezed.dart';
part 'watch_progress.g.dart';

/// Used only for episode variant (tvSeries or anime)
@HiveType(typeId: 230, adapterName: 'WatchProgressTypeAdapter')
enum WatchProgressType {
  @HiveField(0)
  tvSeries,
  @HiveField(1)
  anime,
}

@freezed
abstract class WatchProgress with _$WatchProgress {
  const WatchProgress._();

  // movie
  @JsonSerializable()
  @HiveType(typeId: 231, adapterName: 'WatchProgressMovieAdapter')
  const factory WatchProgress.movie({
    @HiveField(0) required String id,
    @HiveField(1) String? playedUrl,
    // Store Duration directly; requires registering DurationAdapter
    @HiveField(2) required Duration duration,
  }) = WatchProgressMovie;

  // episode
  @JsonSerializable()
  @HiveType(typeId: 232, adapterName: 'WatchProgressEpisodeAdapter')
  const factory WatchProgress.episode({
    // tvSeries or anime
    @HiveField(0) required WatchProgressType type,
    @HiveField(1) required String seriesId,
    @HiveField(2) required String seriesName,
    @HiveField(3) required int itemId,
    @HiveField(4) required int seasonNumber,
    // Store Duration directly; requires registering DurationAdapter
    @HiveField(5) required Duration duration,
  }) = WatchProgressEpisode;

  factory WatchProgress.fromJson(Map<String, dynamic> json) =>
      _$WatchProgressFromJson(json);

  String get uniqueId => map(
    movie: (m) => 'movie_${m.id}',
    episode: (e) =>
        '${e.type.name}_${e.seriesId}_s${e.seasonNumber}_e${e.itemId}',
  );
}

/// Manual Hive adapter for Duration (required because Hive doesn't support Duration natively)
class DurationAdapter extends TypeAdapter<Duration> {
  @override
  final int typeId = 90; // ensure this doesn't collide with other adapters

  @override
  Duration read(BinaryReader reader) {
    final ms = reader.readInt();
    return Duration(milliseconds: ms);
  }

  @override
  void write(BinaryWriter writer, Duration obj) {
    writer.writeInt(obj.inMilliseconds);
  }
}
