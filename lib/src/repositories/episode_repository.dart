import 'package:miko/src/models/episode/episode_detail.dart';

abstract class EpisodeRepository {
  Future<EpisodeDetail?> getEpisodeDetail(int tvId, int seasonNumber, int episodeNumber, {bool forceRefresh = false});
}