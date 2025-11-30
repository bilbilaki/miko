import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

// Enum for theme preference
enum AppThemeMode { system, light, dark }

// Enum for grid layout preference
enum GridLayout { grid3x3, grid1x2, custom }

/// Optimized UserDataService with better structure and extensibility
/// Maintains backward compatibility with existing API
class UserDataService extends ChangeNotifier {
  // ==================== CONSTANTS ====================
  // Preference Keys - Organized by category

  // Favorites & Watchlist Keys
  static const String _favoriteMoviesKey = 'favoriteMovies';
  static const String _favoriteTvSeriesKey = 'favoriteTvSeries';
  static const String _favoriteAnimeKey = 'favoriteAnime';
  static const String _watchlistMoviesKey = 'watchlistMovies';
  static const String _watchlistAnimeKey = 'watchlistAnime';
  static const String _watchlistTvSeriesKey = 'watchlistTvSeries';

  // Watch Progress Keys
  static const String _isWatchedEpisodeKey = 'isWatchedEpisode';
  static const String _isWatchedSeasonKey = 'isWatchedSeason';
  static const String _isWatchedMovieKey = 'isWatchedMovie';
  static const String _isWatchedSeriesKey = 'isWatchedSeries';

  // Library & Directory Keys
  static const String myListKey = 'myList';
  static const String _selectedDirectoryPathKey = 'selectedDirectoryPath';
  static const String _moviesLibraryPathsKey = 'moviesLibraryPaths';
  static const String _seriesLibraryPathsKey = 'seriesLibraryPaths';
  static const String _musicLibraryPathsKey = 'musicLibraryPaths';
  static const String _musicVideoLibraryPathsKey = 'musicVideoLibraryPaths';
  static const String _mixedLibraryPathsKey = 'mixedLibraryPaths';
  static const String _photoLibraryPathsKey = 'photoLibraryPaths';

  // Settings Keys
  static const String _themeModKey = 'themeMode';
  static const String _homeGridLayoutKey = 'homeGridLayout';
  static const String _useHardwareDecoderKey = 'useHardwareDecoder';
  static const String _useSecondaryPlayerKey = 'useSecondaryPlayer';
  static const String _externalDownloadManagerKey =
      'externalDownloadManagerPackage';
  static const String _externalPlayerKey = 'externalPlayerPackage';
  static const String _areyouwantfarsiKey = 'areyouwantfarsi';
  static const String _externalPlayerSettingKey = 'externalPlayer';
  static const String _downloadManagerSettingKey = 'downloadManager';
  static const String _gridSizeKey = 'gridSize';
  static const String _decoderPreferenceKey = 'decoderPreference';
  static const String _customBaseUrlKey = 'custoombaseurl';
  static const String _historyForModelsEnabledKey = 'historyformodelsenabled';
  static const String _historyChatEnabledKey = 'historychatenabled';
  static const String _tmdbBaseUrlKey = 'tmdbBaseUrl';

  // AI Settings Keys - Subtitle Generation
  static const String _aiSubtitleBaseUrlKey = 'aiSubtitleBaseUrl';
  static const String _aiSubtitleApiKeyKey = 'aiSubtitleApiKey';
  static const String _aiSubtitleModelIdKey = 'aiSubtitleModelId';

  // AI Settings Keys - Translation
  static const String _aiTranslationBaseUrlKey = 'aiTranslationBaseUrl';
  static const String _aiTranslationApiKeyKey = 'aiTranslationApiKey';
  static const String _aiTranslationModelIdKey = 'aiTranslationModelId';

  // ==================== PRIVATE FIELDS ====================
  SharedPreferences? _prefs;
  late SharedPreferences perfs;
  // Add keys for history, downloads if implemented later
  String _custoombaseurl = 'Farsi';
  String _tmdbBaseUrl = "https://db.inosuke.sbs";
  String? _selectedDirectoryPath; // Persisted user-chosen directory
  // Local libraries grouped paths
  List<String> _moviesLibraryPaths = [];
  List<String> _seriesLibraryPaths = [];
  List<String> _musicLibraryPaths = [];
  List<String> _musicVideoLibraryPaths = [];
  List<String> _mixedLibraryPaths = [];
  List<String> _photoLibraryPaths = [];

  bool _historyformodelsenabled = false;
  bool _historychatenabled = true;

  // AI Settings - Subtitle Generation
  String _aiSubtitleBaseUrl = '';
  String _aiSubtitleApiKey = '';
  String _aiSubtitleModelId = '';

  // AI Settings - Translation
  String _aiTranslationBaseUrl = '';
  String _aiTranslationApiKey = '';
  String _aiTranslationModelId = '';
  List<int> _favoriteMovieIds = [];
  List<int> _favoriteAnimeIds = [];
  List<int> _favoriteTvSeriesIds = [];
  List<int> _watchlistMovieIds = [];
  List<int> _watchlistAnimeIds = [];
  List<int> _watchlistTvSeriesIds = [];
  List<int> _isWatchedEpisodeIds = [];
  List<int> _isWatchedSeasonIds = [];
  List<int> _isWatchedSeriesIds = [];
  List<int> _isWatchedMovieIds = [];

  List<int> get favoriteMovieIds => List.unmodifiable(_favoriteMovieIds);
  List<int> get favoriteAnimeIds => List.unmodifiable(_favoriteAnimeIds);
  List<int> get favoriteTvSeriesIds => List.unmodifiable(_favoriteTvSeriesIds);
  List<int> get watchlistMovieIds => List.unmodifiable(_watchlistMovieIds);
  List<int> get watchlistAnimeIds => List.unmodifiable(_watchlistAnimeIds);
  List<int> get isWatchedEpisodeIds => List.unmodifiable(_isWatchedEpisodeIds);
  List<int> get isWatchedSeasonIds => List.unmodifiable(_isWatchedSeasonIds);
  List<int> get isWatchedSeriesIds => List.unmodifiable(_isWatchedSeriesIds);
  List<int> get isWatchedMovieIds => List.unmodifiable(_isWatchedMovieIds);

  bool get historyformodelsenabled => _historyformodelsenabled;
  bool get historychatenabled => _historychatenabled;
  String get custoombaseurl => _custoombaseurl;
  String? get selectedDirectoryPath => _selectedDirectoryPath;
  // Library groups getters
  List<String> get moviesLibraryPaths => List.unmodifiable(_moviesLibraryPaths);
  List<String> get seriesLibraryPaths => List.unmodifiable(_seriesLibraryPaths);
  List<String> get musicLibraryPaths => List.unmodifiable(_musicLibraryPaths);
  List<String> get musicVideoLibraryPaths =>
      List.unmodifiable(_musicVideoLibraryPaths);
  List<String> get mixedLibraryPaths => List.unmodifiable(_mixedLibraryPaths);
  List<String> get photoLibraryPaths => List.unmodifiable(_photoLibraryPaths);
  List<int> get watchlistTvSeriesIds =>
      List.unmodifiable(_watchlistTvSeriesIds);

  // Default settings
  AppThemeMode _themeMode = AppThemeMode.system;
  GridLayout _homeGridLayout = GridLayout.grid3x3; // Example for home screen
  bool _useHardwareDecoder = true;
  bool _useSecondaryPlayer = false;
  String? _externalDownloadManagerPackage;
  String? _externalPlayerPackage;
  bool? _areyouwantfarsi = true;
  // Settings
  String _externalPlayer = '';
  String _downloadManager = '';
  double _gridSize = 3.0;
  String _decoderPreference = 'default';
  // Getters
  AppThemeMode get themeMode => _themeMode;
  GridLayout get homeGridLayout => _homeGridLayout;
  bool get useHardwareDecoder => _useHardwareDecoder;
  bool get useSecondaryPlayer => _useSecondaryPlayer;
  String? get externalDownloadManagerPackage => _externalDownloadManagerPackage;
  String? get externalPlayerPackage => _externalPlayerPackage;
  bool? get areyouwantfarsi => _areyouwantfarsi;
  // Getters for settings
  String get externalPlayer => _externalPlayer;
  String get downloadManager => _downloadManager;
  double get gridSize => _gridSize;
  String get decoderPreference => _decoderPreference;
  String get tmdbBaseUrl => _tmdbBaseUrl;

  // AI Settings Getters - Subtitle Generation
  String get aiSubtitleBaseUrl => _aiSubtitleBaseUrl;
  String get aiSubtitleApiKey => _aiSubtitleApiKey;
  String get aiSubtitleModelId => _aiSubtitleModelId;

  // AI Settings Getters - Translation
  String get aiTranslationBaseUrl => _aiTranslationBaseUrl;
  String get aiTranslationApiKey => _aiTranslationApiKey;
  String get aiTranslationModelId => _aiTranslationModelId;

  // ==================== INITIALIZATION ====================
  UserDataService() {
    _init();
  }

  Future<void> _init() async {
    _prefs ??= await SharedPreferences.getInstance();
    perfs = _prefs ?? await SharedPreferences.getInstance();
    await _loadAllPreferences();
  }

  /// Centralized loading of all preferences
  Future<void> _loadAllPreferences() async {
    _prefs = await SharedPreferences.getInstance();

    // Load Favorites & Watchlists
    _favoriteMovieIds = _getIntList(_favoriteMoviesKey);
    _favoriteAnimeIds = _getIntList(_favoriteAnimeKey);
    _favoriteTvSeriesIds = _getIntList(_favoriteTvSeriesKey);
    _watchlistMovieIds = _getIntList(_watchlistMoviesKey);
    _watchlistAnimeIds = _getIntList(_watchlistAnimeKey);
    _watchlistTvSeriesIds = _getIntList(_watchlistTvSeriesKey);

    // Load Watch Progress
    _isWatchedEpisodeIds = _getIntList(_isWatchedEpisodeKey);
    _isWatchedSeasonIds = _getIntList(_isWatchedSeasonKey);
    _isWatchedSeriesIds = _getIntList(_isWatchedSeriesKey);
    _isWatchedMovieIds = _getIntList(_isWatchedMovieKey);

    // Load Library Paths
    _selectedDirectoryPath = _prefs?.getString(_selectedDirectoryPathKey);
    _moviesLibraryPaths = _getStringList(_moviesLibraryPathsKey);
    _seriesLibraryPaths = _getStringList(_seriesLibraryPathsKey);
    _musicLibraryPaths = _getStringList(_musicLibraryPathsKey);
    _musicVideoLibraryPaths = _getStringList(_musicVideoLibraryPathsKey);
    _mixedLibraryPaths = _getStringList(_mixedLibraryPathsKey);
    _photoLibraryPaths = _getStringList(_photoLibraryPathsKey);

    // Load Settings
    _custoombaseurl = _prefs?.getString(_customBaseUrlKey) ?? 'Farsi';
    _tmdbBaseUrl =
        _prefs?.getString(_tmdbBaseUrlKey) ?? "https://db.inosuke.sbs";
    _historyformodelsenabled =
        _prefs?.getBool(_historyForModelsEnabledKey) ?? false;
    _historychatenabled = _prefs?.getBool(_historyChatEnabledKey) ?? false;

    // Load AI Settings
    _aiSubtitleBaseUrl = _prefs?.getString(_aiSubtitleBaseUrlKey) ?? '';
    _aiSubtitleApiKey = _prefs?.getString(_aiSubtitleApiKeyKey) ?? '';
    _aiSubtitleModelId = _prefs?.getString(_aiSubtitleModelIdKey) ?? '';

    _aiTranslationBaseUrl = _prefs?.getString(_aiTranslationBaseUrlKey) ?? '';
    _aiTranslationApiKey = _prefs?.getString(_aiTranslationApiKeyKey) ?? '';
    _aiTranslationModelId = _prefs?.getString(_aiTranslationModelIdKey) ?? '';

    await _loadSettings();
    notifyListeners();
  }

  // ==================== PLAYBACK PROGRESS ====================
  /// Generate unique key for episode progress
  String _getEpisodeProgressKey(
    int seriesId,
    int seasonNumber,
    int episodeNumber,
  ) {
    return 'progress_${seriesId}_${seasonNumber}_$episodeNumber';
  }

  /// Save playback position for a specific episode
  Future<void> saveEpisodeProgress(
    int seriesId,
    int seasonNumber,
    int episodeNumber,
    Duration position,
  ) async {
    final key = _getEpisodeProgressKey(seriesId, seasonNumber, episodeNumber);
    await _prefs!.setInt(key, position.inSeconds);
    // No need to notify listeners for this, it's a background save.
  }

  /// Retrieve saved playback position for an episode
  Future<Duration?> getEpisodeProgress(
    int seriesId,
    int seasonNumber,
    int episodeNumber,
  ) async {
    final key = _getEpisodeProgressKey(seriesId, seasonNumber, episodeNumber);
    final seconds = _prefs?.getInt(key);
    if (seconds != null && seconds != 0) {
      return Duration(seconds: seconds);
    }
    return null;
  }

  Future<void> setTmdbBaseUrl(String value) async {
    _tmdbBaseUrl = value;
    await _prefs?.setString('tmdbBaseUrl', value.toString());
    notifyListeners();
  }

  /// Clear saved progress for an episode
  Future<void> clearEpisodeProgress(
    int seriesId,
    int seasonNumber,
    int episodeNumber,
  ) async {
    final key = _getEpisodeProgressKey(seriesId, seasonNumber, episodeNumber);
    await _prefs?.remove(key);
  }

  /// Generate unique key for video progress (with 4 parameters)
  String _getVideoProgressKey(
    String videoId,
    String videoName,
    String source,
    String url,
  ) {
    return 'video_progress_${videoId}_${videoName}_${source}_${url.hashCode}';
  }

  /// Save playback position for a video
  Future<void> saveVideoProgress(
    String videoId,
    String videoName,
    String source,
    String url,
    Duration position,
  ) async {
    final key = _getVideoProgressKey(videoId, videoName, source, url);
    await _prefs?.setInt(key, position.inSeconds);
  }

  /// Retrieve saved playback position for a video
  Future<Duration?> getVideoProgress(
    String videoId,
    String videoName,
    String source,
    String url,
  ) async {
    final key = _getVideoProgressKey(videoId, videoName, source, url);
    final seconds = _prefs?.getInt(key);
    if (seconds != null && seconds != 0) {
      return Duration(seconds: seconds);
    }
    return null;
  }

  /// Clear saved progress for a video
  Future<void> clearVideoProgress(
    String videoId,
    String videoName,
    String source,
    String url,
  ) async {
    final key = _getVideoProgressKey(videoId, videoName, source, url);
    await _prefs?.remove(key);
  }

  /// Generic string setter with change detection
  Future<void> _setString(
    String key,
    String newValue,
    String currentValue,
  ) async {
    if (currentValue == newValue) return;

    switch (key) {
      case _customBaseUrlKey:
        _custoombaseurl = newValue;
        break;
      default:
        debugPrint("Warning: Unhandled key in _setString: $key");
        return;
    }

    notifyListeners();
    await _prefs?.setString(key, newValue);
  }

  // ==================== UTILITY METHODS ====================
  /// Helper to get list of integers from SharedPreferences
  List<int> _getIntList(String key) {
    final List<String>? stringList = _prefs?.getStringList(key);
    if (stringList == null) return [];
    return stringList.map((id) => int.tryParse(id)).whereType<int>().toList();
  }

  /// Helper to get list of strings from SharedPreferences
  List<String> _getStringList(String key) {
    return List<String>.from(_prefs?.getStringList(key) ?? const []);
  }

  /// Helper to set list of integers to SharedPreferences
  Future<void> _setIntList(String key, List<int> list) async {
    await _prefs?.setStringList(key, list.map((id) => id.toString()).toList());
  }

  /// Helper to set list of strings to SharedPreferences
  Future<void> _setStringList(String key, List<String> list) async {
    await _prefs?.setStringList(key, list);
  }

  // ==================== WATCHED STATUS ====================
  /// Store watched episode information
  Future<void> _setIntListIsWatched(
    seriesId,
    seasonNumber,
    episodeNumber,
    url,
  ) async {
    final String watchedKey = [
      seriesId,
      seasonNumber,
      episodeNumber,
      url,
    ].where((e) => e != null).join(":");

    final List<String> watchedList =
        _prefs?.getStringList(_isWatchedEpisodeKey) ?? [];

    if (!watchedList.contains(watchedKey)) {
      watchedList.add(watchedKey);
      await _prefs?.setStringList(_isWatchedEpisodeKey, watchedList);
      notifyListeners();
    }
  }

  /// Check if episode is watched
  bool isWatchedEpisode(
    dynamic seriesId,
    dynamic seasonNumber,
    dynamic episodeNumber,
    dynamic url,
  ) {
    final String watchedKey = [
      seriesId,
      seasonNumber,
      episodeNumber,
      url,
    ].where((e) => e != null).join(":");
    final List<String> watchedList =
        _prefs?.getStringList(_isWatchedEpisodeKey) ?? [];
    return watchedList.contains(watchedKey);
  }

  /// Toggle watched state for an episode
  Future<void> toggleIsWatchedLink(
    dynamic seriesId,
    dynamic seasonNumber,
    dynamic episodeNumber,
    dynamic url,
  ) async {
    final String watchedKey = [
      seriesId,
      seasonNumber,
      episodeNumber,
      url,
    ].where((e) => e != null).join(":");
    final List<String> watchedList =
        _prefs?.getStringList(_isWatchedEpisodeKey) ?? [];

    watchedList.add(watchedKey);
    await _prefs?.setStringList(_isWatchedEpisodeKey, watchedList);
    notifyListeners();
  }

  /// Check if season is watched
  bool isWatchedSeason(seriesId, seasonNumber) {
    final String watchedKey = [
      seriesId,
      seasonNumber,
    ].where((e) => e != null).join(":");
    final List<String> watchedList =
        _prefs?.getStringList(_isWatchedEpisodeKey) ?? [];
    return watchedList.contains(watchedKey);
  }

  /// Check if series is watched
  bool isWatchedSeries(seriesId) {
    final String watchedKey = [seriesId].where((e) => e != null).join(":");
    final List<String> watchedList =
        _prefs?.getStringList(_isWatchedEpisodeKey) ?? [];
    return watchedList.contains(watchedKey);
  }

  /// Check if media is watched by URL
  bool isWatched(url) {
    final String watchedKey = [url].where((e) => e != null).join(":");
    final List<String> watchedList =
        _prefs?.getStringList(_isWatchedEpisodeKey) ?? [];
    return watchedList.contains(watchedKey);
  }

  /// Check if movie is watched
  bool isWatchedMovie(movieId, url) {
    final String watchedKey = [movieId, url].where((e) => e != null).join(":");
    final List<String> watchedList =
        _prefs?.getStringList(_isWatchedEpisodeKey) ?? [];
    return watchedList.contains(watchedKey);
  }

  /// Toggle watched state by URL
  Future<void> toggleIsWatched(url) async {
    await _setIntListIsWatched(url, url, url, url);
    notifyListeners();
  }

  // ==================== FAVORITES ==s in favorites
  bool isFavoriteMovie(int movieId) => _favoriteMovieIds.contains(movieId);

  /// Check if anime is in favorites
  bool isFavoriteAnime(int animeId) => _favoriteAnimeIds.contains(animeId);

  /// Check if TV series is in favorites
  bool isFavoriteTvSeries(int seriesId) =>
      _favoriteTvSeriesIds.contains(seriesId);

  /// Toggle favorite status for movie
  Future<void> toggleFavoriteMovie(int movieId) async {
    if (isFavoriteMovie(movieId)) {
      _favoriteMovieIds.remove(movieId);
    } else {
      _favoriteMovieIds.add(movieId);
    }
    await _setIntList(_favoriteMoviesKey, _favoriteMovieIds);
    notifyListeners();
  }

  /// Generic bool setter with change detection
  Future<void> _setBool(String key, bool newValue, bool currentValue) async {
    if (currentValue == newValue) return;

    switch (key) {
      case _historyForModelsEnabledKey:
        _historyformodelsenabled = newValue;
        break;
      case _historyChatEnabledKey:
        _historychatenabled = newValue;
        break;
      default:
        debugPrint("Warning: Unhandled key in _setBool: $key");
        return;
    }

    notifyListeners();
    await _prefs?.setBool(key, newValue);
  }

  /// Toggle favorite status for anime
  Future<void> toggleFavoriteAnime(int animeId) async {
    if (isFavoriteAnime(animeId)) {
      _favoriteAnimeIds.remove(animeId);
    } else {
      _favoriteAnimeIds.add(animeId);
    }
    await _setIntList(_favoriteAnimeKey, _favoriteAnimeIds);
    notifyListeners();
  }

  /// Toggle favorite status for TV series
  Future<void> toggleFavoriteTvSeries(int seriesId) async {
    if (isFavoriteTvSeries(seriesId)) {
      _favoriteTvSeriesIds.remove(seriesId);
    } else {
      _favoriteTvSeriesIds.add(seriesId);
    }
    await _setIntList(_favoriteTvSeriesKey, _favoriteTvSeriesIds);
    notifyListeners();
  }

  // ==================== WATCHLIST ==s in watchlist
  bool isOnWatchlistMovie(int movieId) => _watchlistMovieIds.contains(movieId);

  /// Check if anime is in watchlist
  bool isOnWatchlistAnime(int animeId) => _watchlistAnimeIds.contains(animeId);

  /// Check if TV series is in watchlist
  bool isOnWatchlistTvSeries(int seriesId) =>
      _watchlistTvSeriesIds.contains(seriesId);

  /// Toggle watchlist status for movie
  Future<void> toggleWatchlistMovie(int movieId) async {
    if (isOnWatchlistMovie(movieId)) {
      _watchlistMovieIds.remove(movieId);
    } else {
      _watchlistMovieIds.add(movieId);
    }
    await _setIntList(_watchlistMoviesKey, _watchlistMovieIds);
    notifyListeners();
  }

  /// Toggle watchlist status for anime
  Future<void> toggleWatchlistAnime(int animeId) async {
    if (isOnWatchlistAnime(animeId)) {
      _watchlistAnimeIds.remove(animeId);
    } else {
      _watchlistAnimeIds.add(animeId);
    }
    await _setIntList(_watchlistAnimeKey, _watchlistAnimeIds);
    notifyListeners();
  }

  /// Toggle watchlist status for TV series
  Future<void> toggleWatchlistTvSeries(int seriesId) async {
    if (isOnWatchlistTvSeries(seriesId)) {
      _watchlistTvSeriesIds.remove(seriesId);
    } else {
      _watchlistTvSeriesIds.add(seriesId);
    }
    await _setIntList(_watchlistTvSeriesKey, _watchlistTvSeriesIds);
    notifyListeners();
  }

  // ==================== SETTINGS SETTERS ==
  Future<void> setCustoombaseurl(String value) =>
      _setString(_customBaseUrlKey, value, _custoombaseurl);

  /// Set history for models enabled
  Future<void> setHistoryformodelsenabled(bool value) =>
      _setBool(_historyForModelsEnabledKey, value, _historyformodelsenabled);

  /// Set history chat enabled
  Future<void> setHistorychatenabled(bool value) =>
      _setBool(_historyChatEnabledKey, value, _historychatenabled);
  Future<void> clearAllUserData() async {
  _favoriteMovieIds.clear();
    _favoriteAnimeIds.clear();
    _favoriteTvSeriesIds.clear();
    _watchlistMovieIds.clear();
    _watchlistAnimeIds.clear();
    _watchlistTvSeriesIds.clear();
    _isWatchedEpisodeIds.clear();
    _isWatchedMovieIds.clear();
    _isWatchedSeasonIds.clear();
    _isWatchedSeriesIds.clear();
    _moviesLibraryPaths.clear();
    _seriesLibraryPaths.clear();
    _musicLibraryPaths.clear();
    _musicVideoLibraryPaths.clear();
    _mixedLibraryPaths.clear();
    _photoLibraryPaths.clear();

    _custoombaseurl = '';
    _selectedDirectoryPath = null;

    // Clear AI settings
    _aiSubtitleBaseUrl = '';
    _aiSubtitleApiKey = '';
    _aiSubtitleModelId = '';
    _aiTranslationBaseUrl = '';
    _aiTranslationApiKey = '';
    _aiTranslationModelId = '';

    // Remove all keys from SharedPreferences
    final keysToRemove = [
      _favoriteMoviesKey,
      _favoriteAnimeKey,
      _favoriteTvSeriesKey,
      _watchlistMoviesKey,
      _watchlistAnimeKey,
      _watchlistTvSeriesKey,
      _isWatchedEpisodeKey,
      _isWatchedMovieKey,
      _isWatchedSeasonKey,
      _isWatchedSeriesKey,
      _customBaseUrlKey,
      _tmdbBaseUrlKey,
      _themeModKey,
      _homeGridLayoutKey,
      _useHardwareDecoderKey,
      _useSecondaryPlayerKey,
      _externalDownloadManagerKey,
      _externalPlayerKey,
      _externalPlayerSettingKey,
      _downloadManagerSettingKey,
      _gridSizeKey,
      _decoderPreferenceKey,
      _areyouwantfarsiKey,
      _historyForModelsEnabledKey,
      _historyChatEnabledKey,
      _selectedDirectoryPathKey,
      _moviesLibraryPathsKey,
      _seriesLibraryPathsKey,
      _musicLibraryPathsKey,
      _musicVideoLibraryPathsKey,
      _mixedLibraryPathsKey,
      _photoLibraryPathsKey,
      _aiSubtitleBaseUrlKey,
      _aiSubtitleApiKeyKey,
      _aiSubtitleModelIdKey,
      _aiTranslationBaseUrlKey,
      _aiTranslationApiKeyKey,
      _aiTranslationModelIdKey,
    ];

    for (final key in keysToRemove) {
      await _prefs?.remove(key);
    }

    // Reload settings to reset to defaults
    await _loadSettings();
    notifyListeners();
  }
  // ==================== DIRECTORY & LIBRARY MANAGEMENT ====================
  /// Set selected directory path
  Future<void> setSelectedDirectoryPath(String? path) async {
    _selectedDirectoryPath = path;
    if (path == null || path.isEmpty) {
      await _prefs?.remove(_selectedDirectoryPathKey);
    } else {
      await _prefs?.setString(_selectedDirectoryPathKey, path);
    }
    notifyListeners();
  }

  /// Add path to movies library
  Future<void> addMoviesPath(String path) async {
    if (path.isEmpty || _moviesLibraryPaths.contains(path)) return;
    _moviesLibraryPaths = [..._moviesLibraryPaths, path];
    await _setStringList(_moviesLibraryPathsKey, _moviesLibraryPaths);
    notifyListeners();
  }

  /// Remove path from movies library
  Future<void> removeMoviesPath(String path) async {
    _moviesLibraryPaths = List.of(_moviesLibraryPaths)..remove(path);
    await _setStringList(_moviesLibraryPathsKey, _moviesLibraryPaths);
    notifyListeners();
  }

  /// Add path to series library
  Future<void> addSeriesPath(String path) async {
    if (path.isEmpty || _seriesLibraryPaths.contains(path)) return;
    _seriesLibraryPaths = [..._seriesLibraryPaths, path];
    await _setStringList(_seriesLibraryPathsKey, _seriesLibraryPaths);
    notifyListeners();
  }

  /// Remove path from series library
  Future<void> removeSeriesPath(String path) async {
    _seriesLibraryPaths = List.of(_seriesLibraryPaths)..remove(path);
    await _setStringList(_seriesLibraryPathsKey, _seriesLibraryPaths);
    notifyListeners();
  }

  /// Add path to music library

  Future<void> addMusicPath(String path) async {
    if (path.isEmpty || _musicLibraryPaths.contains(path)) return;
    _musicLibraryPaths = [..._musicLibraryPaths, path];
    await _setStringList(_musicLibraryPathsKey, _musicLibraryPaths);
    notifyListeners();
  }

  /// Remove path from music library
  Future<void> removeMusicPath(String path) async {
    _musicLibraryPaths = List.of(_musicLibraryPaths)..remove(path);
    await _setStringList(_musicLibraryPathsKey, _musicLibraryPaths);
    notifyListeners();
  }

  /// Add path to music video library

  Future<void> addMusicVideoPath(String path) async {
    if (path.isEmpty || _musicVideoLibraryPaths.contains(path)) return;
    _musicVideoLibraryPaths = [..._musicVideoLibraryPaths, path];
    await _setStringList(_musicVideoLibraryPathsKey, _musicVideoLibraryPaths);
    notifyListeners();
  }

  /// Remove path from music video library
  Future<void> removeMusicVideoPath(String path) async {
    _musicVideoLibraryPaths = List.of(_musicVideoLibraryPaths)..remove(path);
    await _setStringList(_musicVideoLibraryPathsKey, _musicVideoLibraryPaths);
    notifyListeners();
  }

  /// Add path to mixed library

  Future<void> addMixedPath(String path) async {
    if (path.isEmpty || _mixedLibraryPaths.contains(path)) return;
    _mixedLibraryPaths = [..._mixedLibraryPaths, path];
    await _setStringList(_mixedLibraryPathsKey, _mixedLibraryPaths);
    notifyListeners();
  }

  /// Remove path from mixed library
  Future<void> removeMixedPath(String path) async {
    _mixedLibraryPaths = List.of(_mixedLibraryPaths)..remove(path);
    await _setStringList(_mixedLibraryPathsKey, _mixedLibraryPaths);
    notifyListeners();
  }

  /// Add path to photo library

  Future<void> addPhotoPath(String path) async {
    if (path.isEmpty || _photoLibraryPaths.contains(path)) return;
    _photoLibraryPaths = [..._photoLibraryPaths, path];
    await _setStringList(_photoLibraryPathsKey, _photoLibraryPaths);
    notifyListeners();
  }

  /// Remove path from photo library
  Future<void> removePhotoPath(String path) async {
    _photoLibraryPaths = List.of(_photoLibraryPaths)..remove(path);
    await _setStringList(_photoLibraryPathsKey, _photoLibraryPaths);
    notifyListeners();
  }

  /// Generic value getter for dynamic access
  dynamic getValue(String key) {
    switch (key) {
      case _customBaseUrlKey:
        return _custoombaseurl;
      case _historyForModelsEnabledKey:
        return _historyformodelsenabled;
      case _historyChatEnabledKey:
        return _historychatenabled;
      default:
        debugPrint(
          'SettingsService: Unknown setting key requested in getValue: $key',
        );
        return null;
    }
  }

  /// Load UI and player settings
  Future<void> _loadSettings() async {
    final themeModeIndex =
        _prefs?.getInt(_themeModKey) ?? AppThemeMode.system.index;
    _themeMode = AppThemeMode.values[themeModeIndex];

    final homeGridLayoutIndex =
        _prefs?.getInt(_homeGridLayoutKey) ?? GridLayout.grid3x3.index;
    _homeGridLayout = GridLayout.values[homeGridLayoutIndex];

    _useHardwareDecoder = _prefs?.getBool(_useHardwareDecoderKey) ?? true;
    _useSecondaryPlayer = _prefs?.getBool(_useSecondaryPlayerKey) ?? false;
    _areyouwantfarsi = _prefs?.getBool(_areyouwantfarsiKey) ?? true;

    _externalDownloadManagerPackage = _prefs?.getString(
      _externalDownloadManagerKey,
    );
    _externalPlayerPackage = _prefs?.getString(_externalPlayerKey);

    _externalPlayer = _prefs?.getString(_externalPlayerSettingKey) ?? '';
    _downloadManager = _prefs?.getString(_downloadManagerSettingKey) ?? '';
    _gridSize = _prefs?.getDouble(_gridSizeKey) ?? 3.0;
    _decoderPreference = _prefs?.getString(_decoderPreferenceKey) ?? 'default';
  }

  /// Set theme mode
  Future<void> setThemeMode(AppThemeMode mode) async {
    _themeMode = mode;
    await _prefs?.setInt(_themeModKey, mode.index);
    notifyListeners();
  }

  /// Set home grid layout
  Future<void> setHomeGridLayout(GridLayout layout) async {
    _homeGridLayout = layout;
    await _prefs?.setInt(_homeGridLayoutKey, layout.index);
    notifyListeners();
  }

  /// Set hardware decoder preference
  Future<void> setUseHardwareDecoder(bool value) async {
    _useHardwareDecoder = value;
    await _prefs?.setBool(_useHardwareDecoderKey, value);
    notifyListeners();
  }

  /// Set secondary player preference
  Future<void> setUseSecondaryPlayer(bool value) async {
    _useSecondaryPlayer = value;
    await _prefs?.setBool(_useSecondaryPlayerKey, value);
    notifyListeners();
  }

  /// Set Farsi preference
  Future<void> setAreuwanfarsi(bool value) async {
    _areyouwantfarsi = value;
    await _prefs?.setBool(_areyouwantfarsiKey, value);
    notifyListeners();
  }

  /// Set external download manager package
  Future<void> setExternalDownloadManagerPackage(String? packageName) async {
    _externalDownloadManagerPackage = packageName;
    if (packageName == null || packageName.isEmpty) {
      await _prefs?.remove(_externalDownloadManagerKey);
    } else {
      await _prefs?.setString(_externalDownloadManagerKey, packageName);
    }
    notifyListeners();
  }

  /// Set external player package
  Future<void> setExternalPlayerPackage(String? packageName) async {
    _externalPlayerPackage = packageName;
    if (packageName == null || packageName.isEmpty) {
      await _prefs?.remove(_externalPlayerKey);
    } else {
      await _prefs?.setString(_externalPlayerKey, packageName);
    }
    notifyListeners();
  }

  /// Set external player
  Future<void> setExternalPlayer(String value) async {
    _externalPlayer = value;
    await _prefs?.setString(_externalPlayerSettingKey, value);
    notifyListeners();
  }

  /// Set download manager
  Future<void> setDownloadManager(String value) async {
    _downloadManager = value;
    await _prefs?.setString(_downloadManagerSettingKey, value);
    notifyListeners();
  }

  /// Set grid size
  Future<void> setGridSize(double value) async {
    _gridSize = value;
    await _prefs?.setDouble(_gridSizeKey, value);
    notifyListeners();
  }

  /// Set decoder preference
  Future<void> setDecoderPreference(String value) async {
    _decoderPreference = value;
    await _prefs?.setString(_decoderPreferenceKey, value);
    notifyListeners();
  }

  // ==================== AI SETTINGS ====================
  // Subtitle Generation AI Settings

  /// Set AI subtitle base URL
  Future<void> setAiSubtitleBaseUrl(String value) async {
    _aiSubtitleBaseUrl = value;
    await _prefs?.setString(_aiSubtitleBaseUrlKey, value);
    notifyListeners();
  }

  /// Set AI subtitle API key
  Future<void> setAiSubtitleApiKey(String value) async {
    _aiSubtitleApiKey = value;
    await _prefs?.setString(_aiSubtitleApiKeyKey, value);
    notifyListeners();
  }

  /// Set AI subtitle model ID
  Future<void> setAiSubtitleModelId(String value) async {
    _aiSubtitleModelId = value;
    await _prefs?.setString(_aiSubtitleModelIdKey, value);
    notifyListeners();
  }

  // Translation AI Settings

  /// Set AI translation base URL
  Future<void> setAiTranslationBaseUrl(String value) async {
    _aiTranslationBaseUrl = value;
    await _prefs?.setString(_aiTranslationBaseUrlKey, value);
    notifyListeners();
  }

  /// Set AI translation API key
  Future<void> setAiTranslationApiKey(String value) async {
    _aiTranslationApiKey = value;
    await _prefs?.setString(_aiTranslationApiKeyKey, value);
    notifyListeners();
  }

  /// Set AI translation model ID
  Future<void> setAiTranslationModelId(String value) async {
    _aiTranslationModelId = value;
    await _prefs?.setString(_aiTranslationModelIdKey, value);
    notifyListeners();
  }
}
