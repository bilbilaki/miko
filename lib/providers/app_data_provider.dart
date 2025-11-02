// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:hive_ce/hive.dart';
// import 'package:miko/src/hive/hive_registrar.g.dart';
// import 'package:miko/models/watchlist_item.dart';
// import 'package:miko/models/favorite_item.dart';
// import 'package:miko/models/watched_tracker.dart';
// import 'package:miko/models/watch_progress.dart';
// import 'dart:async';

// final appDataManagerProvider = Provider<AppDataManager>(
//   (ref) => AppDataManager(),
// );

// class AppDataManager {
//   bool _initialized = false;
//   Box<WatchlistItem>? _watchlistBox;
//   Box<FavoriteItem>? _favoritesBox;
//   Box<WatchedTracker>? _watchedTrackerBox;
//   Box<WatchProgress>? _watchProgressBox;
//   Future<void>? _initFuture;

//   Future<void> init() async {
//     if (_initFuture != null) return _initFuture!;
//     _initFuture = _initInternal();
//     return _initFuture!;
//   }

//   // Internal init so we can return the same future to concurrent callers
//   Future<void> _initInternal() async {
//     if (_initialized) return;
//     // Ensure generated adapters are registered. Some build outputs
//     // register adapters via a central registrar, but guard in case
//     // registration has already happened.
//     try {
//       // ignore: avoid_dynamic_calls
//       Hive.registerAdapters();
//     } catch (_) {}
//     _watchlistBox = await Hive.openBox<WatchlistItem>('watchlist_box');
//     _favoritesBox = await Hive.openBox<FavoriteItem>('favorites_box');
//     _watchedTrackerBox = await Hive.openBox<WatchedTracker>(
//       'watched_tracker_box',
//     );
//     _watchProgressBox = await Hive.openBox<WatchProgress>('watch_progress_box');
//     _initialized = true;
//   }

//   // Helper that throws a clear error when boxes are accessed before init
//   Box<T> _box<T>(Box<T>? box, String name) {
//     if (!_initialized || box == null) {
//       throw StateError(
//         'AppDataManager not initialized. Call `await AppDataManager.init()` before using. Accessed: $name',
//       );
//     }
//     return box;
//   }

//   // Getters that return checked boxes
//   Box<WatchlistItem> get watchlistBox => _box(_watchlistBox, 'watchlist_box');
//   Box<FavoriteItem> get favoritesBox => _box(_favoritesBox, 'favorites_box');
//   Box<WatchedTracker> get watchedTrackerBox =>
//       _box(_watchedTrackerBox, 'watched_tracker_box');
//   Box<WatchProgress> get watchProgressBox =>
//       _box(_watchProgressBox, 'watch_progress_box');

//   // Watchlist methods
//   Future<void> addToWatchlist(WatchlistItem item) async {
//   await watchlistBox.put(item.uniqueId, item);
//   }

//   Future<void> removeFromWatchlist(String uniqueId) async {
//   await watchlistBox.delete(uniqueId);
//   }

//   bool isInWatchlist(String uniqueId) {
//   return watchlistBox.containsKey(uniqueId);
//   }

//   List<WatchlistItem> getAllWatchlist() {
//   return watchlistBox.values.toList();
//   }

//   List<WatchlistItem> getWatchlistMovies() {
//   return watchlistBox.values
//         .where((item) => item is WatchlistMovieItem)
//         .toList();
//   }

//   List<WatchlistItem> getWatchlistTvSeries() {
//   return watchlistBox.values
//         .where((item) => item is WatchlistTvSeriesItem)
//         .toList();
//   }

//   List<WatchlistItem> getWatchlistAnime() {
//   return watchlistBox.values
//         .where((item) => item is WatchlistAnimeItem)
//         .toList();
//   }

//   List<WatchlistItem> getWatchlistSeasons() {
//   return watchlistBox.values
//         .where((item) => item is WatchlistSeasonItem)
//         .toList();
//   }

//   List<WatchlistItem> getWatchlistEpisodes() {
//   return watchlistBox.values
//         .where((item) => item is WatchlistEpisodeItem)
//         .toList();
//   }

//   // Favorites methods (identical to watchlist, just different box)
//   Future<void> addToFavorites(FavoriteItem item) async {
//   await favoritesBox.put(item.uniqueId, item);
//   }

//   Future<void> removeFromFavorites(String uniqueId) async {
//   await favoritesBox.delete(uniqueId);
//   }

//   bool isInFavorites(String uniqueId) {
//   return favoritesBox.containsKey(uniqueId);
//   }

//   List<FavoriteItem> getAllFavorites() {
//   return favoritesBox.values.toList();
//   }

//   List<FavoriteItem> getFavoritesMovies() {
//   return favoritesBox.values
//         .where((item) => item is FavoriteMovieItem)
//         .toList();
//   }

//   List<FavoriteItem> getFavoritesTvSeries() {
//   return favoritesBox.values
//         .where((item) => item is FavoriteTvSeriesItem)
//         .toList();
//   }

//   List<FavoriteItem> getFavoritesAnime() {
//   return favoritesBox.values
//         .where((item) => item is FavoriteAnimeItem)
//         .toList();
//   }

//   List<FavoriteItem> getFavoritesSeasons() {
//   return favoritesBox.values
//         .where((item) => item is FavoriteSeasonItem)
//         .toList();
//   }

//   List<FavoriteItem> getFavoritesEpisodes() {
//   return favoritesBox.values
//         .where((item) => item is FavoriteEpisodeItem)
//         .toList();
//   }

//   // Watched Tracker methods
//   Future<void> addWatched(WatchedTracker item) async {
//   await watchedTrackerBox.put(item.uniqueId, item);
//   }

//   Future<void> removeWatched(String uniqueId) async {
//   await watchedTrackerBox.delete(uniqueId);
//   }

//   bool isWatched(String uniqueId) {
//   return watchedTrackerBox.containsKey(uniqueId);
//   }

//   WatchedTracker? getWatched(String uniqueId) {
//   return watchedTrackerBox.get(uniqueId);
//   }

//   List<WatchedTracker> getAllWatched() {
//   return watchedTrackerBox.values.toList();
//   }

//   List<WatchedTracker> getWatchedMovies() {
//   return watchedTrackerBox.values
//     .where((item) => item is WatchedTrackerMovie)
//     .toList();
//   }

//   List<WatchedTracker> getWatchedSeriesEpisodes() {
//   return watchedTrackerBox.values
//     .where((item) => item is WatchedTrackerSeriesEpisode)
//     .toList();
//   }

//   // Watch Progress methods
//   Future<void> saveWatchProgress(WatchProgress item) async {
//   await watchProgressBox.put(item.uniqueId, item);
//   }

//   Future<void> removeWatchProgress(String uniqueId) async {
//   await watchProgressBox.delete(uniqueId);
//   }

//   Duration? getWatchProgress(String uniqueId) {
//   final item = watchProgressBox.get(uniqueId);
//     return item?.map(movie: (m) => m.duration, episode: (e) => e.duration);
//   }

//   WatchProgress? getWatchProgressItem(String uniqueId) {
//   return watchProgressBox.get(uniqueId);
//   }

//   List<WatchProgress> getAllWatchProgress() {
//   return watchProgressBox.values.toList();
//   }

//   List<WatchProgress> getMovieWatchProgress() {
//   return watchProgressBox.values
//     .where((item) => item is WatchProgressMovie)
//     .toList();
//   }

//   List<WatchProgress> getEpisodeWatchProgress() {
//   return watchProgressBox.values
//     .where((item) => item is WatchProgressEpisode)
//     .toList();
//   }

//   // Helper: Initialize Hive in main or app init
//   Future<void> dispose() async {
//   if (!_initialized) return;
//   await watchlistBox.close();
//   await favoritesBox.close();
//   await watchedTrackerBox.close();
//   await watchProgressBox.close();
//   }


//   Future<void> upsertWatched(WatchedTracker item) async {
//   await watchedTrackerBox.put(item.uniqueId, item);
//   }

//   /// Convenience: Track a movie as watched.
//   Future<void> trackMovieWatched({
//     required String id,
//     String? playedUrl,
//   }) async {
//     final item = WatchedTracker.movie(id: id, playedUrl: playedUrl);
//     await upsertWatched(item);
//   }

//   /// Convenience: Track a series/anime episode as watched.
//   Future<void> trackSeriesEpisodeWatched({
//     required WatchedTrackerType type, // tvSeries or anime
//     required String seriesId,
//     required String seriesName,
//     required int itemId, // episode id/number
//     required int seasonNumber,
//   }) async {
//     final item = WatchedTracker.seriesEpisode(
//       type: type,
//       seriesId: seriesId,
//       seriesName: seriesName,
//       itemId: itemId,
//       seasonNumber: seasonNumber,
//     );
//     await upsertWatched(item);
//   }

//   /// Remove watched tracker by unique id.
//   Future<void> untrackByUniqueId(String uniqueId) async {
//   await watchedTrackerBox.delete(uniqueId);
//   }

//   /// Remove watched tracker for a movie by raw movie id.
//   Future<void> untrackMovie(String movieId) async {
//     await untrackByUniqueId(buildMovieUniqueId(movieId));
//   }

//   /// Remove watched tracker for a specific episode.
//   Future<void> untrackSeriesEpisode({
//     required WatchedTrackerType type,
//     required String seriesId,
//     required int seasonNumber,
//     required int itemId,
//   }) async {
//     await untrackByUniqueId(
//       buildEpisodeUniqueId(
//         type: type,
//         seriesId: seriesId,
//         seasonNumber: seasonNumber,
//         itemId: itemId,
//       ),
//     );
//   }

 

//   /// Check if a movie (by raw id) is watched.
//   bool isMovieWatched(String movieId) {
//     return isWatched(buildMovieUniqueId(movieId));
//   }

//   /// Check if a specific episode is watched.
//   bool isSeriesEpisodeWatched({
//     required WatchedTrackerType type,
//     required String seriesId,
//     required int seasonNumber,
//     required int itemId,
//   }) {
//     return isWatched(
//       buildEpisodeUniqueId(
//         type: type,
//         seriesId: seriesId,
//         seasonNumber: seasonNumber,
//         itemId: itemId,
//       ),
//     );
//   }

//   /// Get a watched tracker item by unique id.
//   WatchedTracker? getWatchedByUniqueId(String uniqueId) {
//   return watchedTrackerBox.get(uniqueId);
//   }

//   /// Get all watched tracker items.

//   /// Get all watched episodes (tvSeries + anime).
//   List<WatchedTrackerSeriesEpisode> getWatchedEpisodes() {
//   return watchedTrackerBox.values
//     .whereType<WatchedTrackerSeriesEpisode>()
//     .toList(growable: false);
//   }

//   /// Get watched TV series episodes only.
//   List<WatchedTrackerSeriesEpisode> getWatchedTvSeriesEpisodes() {
//     return getWatchedEpisodes()
//         .where((e) => e.type == WatchedTrackerType.tvSeries)
//         .toList(growable: false);
//   }

//   /// Get watched Anime episodes only.
//   List<WatchedTrackerSeriesEpisode> getWatchedAnimeEpisodes() {
//     return getWatchedEpisodes()
//         .where((e) => e.type == WatchedTrackerType.anime)
//         .toList(growable: false);
//   }

//   /// Get all watched episodes for given series (optionally by type and/or season).
//   List<WatchedTrackerSeriesEpisode> getWatchedEpisodesForSeries({
//     required String seriesId,
//     WatchedTrackerType? type, // optional filter
//     int? seasonNumber, // optional filter
//   }) {
//     Iterable<WatchedTrackerSeriesEpisode> eps = getWatchedEpisodes().where(
//       (e) => e.seriesId == seriesId,
//     );
//     if (type != null) {
//       eps = eps.where((e) => e.type == type);
//     }
//     if (seasonNumber != null) {
//       eps = eps.where((e) => e.seasonNumber == seasonNumber);
//     }
//     return eps.toList(growable: false);
//   }

//   /// Get last watched episode for a series (by type) based on seasonNumber then itemId.
//   WatchedTrackerSeriesEpisode? getLastWatchedEpisode({
//     required String seriesId,
//     required WatchedTrackerType type,
//   }) {
//     final eps = getWatchedEpisodesForSeries(seriesId: seriesId, type: type);
//     if (eps.isEmpty) return null;

//     // Sort by seasonNumber asc, then itemId asc, take last
//     final sorted = eps.toList()
//       ..sort((a, b) {
//         final seasonCmp = a.seasonNumber.compareTo(b.seasonNumber);
//         if (seasonCmp != 0) return seasonCmp;
//         return a.itemId.compareTo(b.itemId);
//       });
//     return sorted.lastOrNull;
//   }

//   /// Update a movie's playedUrl (upsert if not existing).
//   Future<void> updateMoviePlayedUrl({
//     required String movieId,
//     String? playedUrl,
//   }) async {
//     final uniqueId = buildMovieUniqueId(movieId);
//     final existing = watchedTrackerBox.get(uniqueId);
//     if (existing is WatchedTrackerMovie) {
//       final updated = existing.copyWith(playedUrl: playedUrl);
//       await watchedTrackerBox.put(uniqueId, updated);
//       return;
//     }
//     // If not exists or wrong type, upsert a new movie
//     await watchedTrackerBox.put(
//       uniqueId,
//       WatchedTracker.movie(id: movieId, playedUrl: playedUrl),
//     );
//   }

//   /// Toggle movie watched: adds if not present, removes if present.
//   Future<void> toggleMovieWatched({
//     required String movieId,
//     String? playedUrl,
//   }) async {
//     final uniqueId = buildMovieUniqueId(movieId);
//     if (isWatched(uniqueId)) {
//       await untrackByUniqueId(uniqueId);
//     } else {
//       await trackMovieWatched(id: movieId, playedUrl: playedUrl);
//     }
//   }

//   /// Toggle episode watched: adds if not present, removes if present.
//   Future<void> toggleSeriesEpisodeWatched({
//     required WatchedTrackerType type,
//     required String seriesId,
//     required String seriesName,
//     required int seasonNumber,
//     required int itemId,
//   }) async {
//     final uniqueId = buildEpisodeUniqueId(
//       type: type,
//       seriesId: seriesId,
//       seasonNumber: seasonNumber,
//       itemId: itemId,
//     );
//     if (isWatched(uniqueId)) {
//       await untrackByUniqueId(uniqueId);
//     } else {
//       await trackSeriesEpisodeWatched(
//         type: type,
//         seriesId: seriesId,
//         seriesName: seriesName,
//         seasonNumber: seasonNumber,
//         itemId: itemId,
//       );
//     }
//   }

//   /// Count watched episodes for a given series (optionally by season).
//   int countWatchedEpisodesForSeries({
//     required String seriesId,
//     WatchedTrackerType? type,
//     int? seasonNumber,
//   }) {
//     return getWatchedEpisodesForSeries(
//       seriesId: seriesId,
//       type: type,
//       seasonNumber: seasonNumber,
//     ).length;
//   }

//   /// Clear all watched tracker entries.
//   Future<void> clearAllWatched() async {
//   await watchedTrackerBox.clear();
//   }


//     String buildMovieUniqueId(String movieId) => 'movie_$movieId';

//   /// Build uniqueId for an episode using the same scheme as WatchedTracker.uniqueId
//   String buildEpisodeUniqueId({
//     required WatchedTrackerType type,
//     required String seriesId,
//     required int seasonNumber,
//     required int itemId,
//   }) => '${type.name}_${seriesId}_s${seasonNumber}_e${itemId}';

// Future<Duration> setMovieWatchProgress({
//     required String id,
//     String? playedUrl,
//     required Duration duration,
//   }) async {
//     final uniqueId = buildMovieUniqueId(id);
//     final item = WatchProgress.movie(
//       id: id,
//       playedUrl: playedUrl,
//       duration: duration,
//     );
//   await watchProgressBox.put(uniqueId, item);
//     return duration;
//   }

//   /// Set an episode watch progress (upsert). Returns the saved duration.
//   Future<Duration> setEpisodeWatchProgress({
//     required WatchProgressType type, // tvSeries or anime
//     required String seriesId,
//     required String seriesName,
//     required int seasonNumber,
//     required int itemId,
//     required Duration duration,
//   }) async {
//     final uniqueId = buildEpisodeUniqueIdprog(
//       type: type,
//       seriesId: seriesId,
//       seasonNumber: seasonNumber,
//       itemId: itemId,
//     );
//     final item = WatchProgress.episode(
//       type: type,
//       seriesId: seriesId,
//       seriesName: seriesName,
//       seasonNumber: seasonNumber,
//       itemId: itemId,
//       duration: duration,
//     );
//   await watchProgressBox.put(uniqueId, item);
//     return duration;
//   }

//   // ---------- Getters that return Duration ----------

//   /// Returns stored duration for a uniqueId, or Duration.zero if not found.
//   Duration getWatchProgressByUniqueId(String uniqueId) {
//   final wp = watchProgressBox.get(uniqueId);
//     return wp?.map(movie: (m) => m.duration, episode: (e) => e.duration) ??
//         Duration.zero;
//   }

//   /// Returns stored movie progress duration, or Duration.zero if not found.
//   Duration getMovieWatchProgressprog(String movieId) {
//     final uniqueId = buildMovieUniqueIdprog(movieId);
//     return getWatchProgressByUniqueId(uniqueId);
//   }

//   /// Returns stored episode progress duration, or Duration.zero if not found.
//   Duration getEpisodeWatchProgressprog({
//     required WatchProgressType type,
//     required String seriesId,
//     required int seasonNumber,
//     required int itemId,
//   }) {
//     final uniqueId = buildEpisodeUniqueIdprog(
//       type: type,
//       seriesId: seriesId,
//       seasonNumber: seasonNumber,
//       itemId: itemId,
//     );
//     return getWatchProgressByUniqueId(uniqueId);
//   }

//   /// Returns total watched duration for a series (sum of all its episodes),
//   /// optionally filtering by type (tvSeries/anime) and season.
//   Duration getSeriesTotalWatchProgress({
//     required String seriesId,
//     WatchProgressType? type,
//     int? seasonNumber,
//   }) {
//   final Iterable<WatchProgress> values = watchProgressBox.values;
//     final durations = values
//         .whereType<WatchProgressEpisode>()
//         .where((e) {
//           if (e.seriesId != seriesId) return false;
//           if (type != null && e.type != type) return false;
//           if (seasonNumber != null && e.seasonNumber != seasonNumber)
//             return false;
//           return true;
//         })
//         .map((e) => e.duration);

//     return durations.fold(Duration.zero, (a, b) => a + b);
//   }

//   /// Returns total watched duration across all movies.
//   Duration getAllMoviesTotalWatchProgress() {
//   final movies = watchProgressBox.values.whereType<WatchProgressMovie>();
//     return movies.map((m) => m.duration).fold(Duration.zero, (a, b) => a + b);
//   }

//   /// Returns total watched duration across all episodes (tvSeries + anime).
//   Duration getAllEpisodesTotalWatchProgress() {
//   final episodes = watchProgressBox.values.whereType<WatchProgressEpisode>();
//     return episodes.map((e) => e.duration).fold(Duration.zero, (a, b) => a + b);
//   }

//   /// Returns total watched duration across all content (movies + episodes).
//   Duration getAllContentTotalWatchProgress() {
//     return watchProgressBox.values
//         .map(
//           (wp) => wp.map(movie: (m) => m.duration, episode: (e) => e.duration),
//         )
//         .fold(Duration.zero, (a, b) => a + b);
//   }

//   // ---------- Increment helpers (return the new Duration) ----------

//   /// Increment movie progress by delta, clamped to [min: 0, max: optional].
//   /// Returns the new duration after increment.
//   Future<Duration> incrementMovieWatchProgress({
//     required String id,
//     String? playedUrl,
//     required Duration delta,
//     Duration? maxDuration,
//   }) async {
//     final current = getMovieWatchProgressprog(id);
//     var next = current + delta;
//     if (next.isNegative) next = Duration.zero;
//     if (maxDuration != null && next > maxDuration) next = maxDuration;
//     return setMovieWatchProgress(id: id, playedUrl: playedUrl, duration: next);
//   }

//   /// Increment episode progress by delta, clamped to [min: 0, max: optional].
//   /// Returns the new duration after increment.
//   Future<Duration> incrementEpisodeWatchProgress({
//     required WatchProgressType type,
//     required String seriesId,
//     required String seriesName,
//     required int seasonNumber,
//     required int itemId,
//     required Duration delta,
//     Duration? maxDuration,
//   }) async {
//     final current = getEpisodeWatchProgressprog(
//       type: type,
//       seriesId: seriesId,
//       seasonNumber: seasonNumber,
//       itemId: itemId,
//     );
//     var next = current + delta;
//     if (next.isNegative) next = Duration.zero;
//     if (maxDuration != null && next > maxDuration) next = maxDuration;
//     return setEpisodeWatchProgress(
//       type: type,
//       seriesId: seriesId,
//       seriesName: seriesName,
//       seasonNumber: seasonNumber,
//       itemId: itemId,
//       duration: next,
//     );
//   }

//   // ---------- Cleanup helpers (optional) ----------

//   /// Remove movie progress. Returns the removed duration (or Duration.zero).
//   Future<Duration> removeMovieWatchProgress(String movieId) async {
//     final uniqueId = buildMovieUniqueId(movieId);
//     final prev = getWatchProgressByUniqueId(uniqueId);
//   await watchProgressBox.delete(uniqueId);
//     return prev;
//   }

//   /// Remove episode progress. Returns the removed duration (or Duration.zero).
//   Future<Duration> removeEpisodeWatchProgress({
//     required WatchProgressType type,
//     required String seriesId,
//     required int seasonNumber,
//     required int itemId,
//   }) async {
//     final uniqueId = buildEpisodeUniqueIdprog(
//       type: type,
//       seriesId: seriesId,
//       seasonNumber: seasonNumber,
//       itemId: itemId,
//     );
//     final prev = getWatchProgressByUniqueId(uniqueId);
//   await watchProgressBox.delete(uniqueId);
//     return prev;
//   }

//   // ------------------------------------------------------------
//   // Helpers to build unique ids (same scheme as WatchProgress.uniqueId)
//   // ------------------------------------------------------------

//   String buildMovieUniqueIdprog(String movieId) => 'movie_$movieId';

//   String buildEpisodeUniqueIdprog({
//     required WatchProgressType type,
//     required String seriesId,
//     required int seasonNumber,
//     required int itemId,
//   }) => '${type.name}_${seriesId}_s${seasonNumber}_e${itemId}';


// }
