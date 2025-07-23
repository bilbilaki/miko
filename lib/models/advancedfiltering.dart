import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart'; // Make sure provider package is in pubspec.yaml

// Models (provided by user, copied for completeness)
import '../models/tv_series_anime.dart'; // Assuming this resolves to the file you provided
import '../showcases/model.dart' as TmdbApiMovieModel; // User's import, kept as is

// --- Helper Extensions ---
extension StringExtension on String {
  String? get nullIfEmpty => isEmpty ? null : this;
}

extension DateTimeExtension on DateTime {
  /// Returns a DateTime representing the end of the day (23:59:59.999).
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999, 999);
}

// --- Loading Status Enum (Provided by user, ensuring it's available) ---
enum LoadingStatus { idle, loading, loaded, error, notloaded }

// --- Part 1: The Central Filter State Model ---

enum SortBy {
  popularity,
  voteAverage,
  releaseDate, // For movies and TV series/anime first air date
  name, // For titles/names
  runtime, // For runtime
}

class ContentFilterState {
  final Set<String> genres;
  final Set<String> languages;
  final Set<String> countries; // For movies only
  final double minVoteAverage;
  final double maxVoteAverage;
  final int? minRuntime;
  final int? maxRuntime;
  final DateTime? startDate;
  final DateTime? endDate;
  final SortBy sortBy;
  final bool isAscending;

  ContentFilterState({
    required this.genres,
    required this.languages,
    required this.countries,
    required this.minVoteAverage,
    required this.maxVoteAverage,
    this.minRuntime,
    this.maxRuntime,
    this.startDate,
    this.endDate,
    required this.sortBy,
    required this.isAscending,
  });

  factory ContentFilterState.initial() {
    return ContentFilterState(
      genres: {},
      languages: {},
      countries: {},
      minVoteAverage: 0.0,
      maxVoteAverage: 10.0,
      minRuntime: null, // Null indicates no filter
      maxRuntime: null, // Null indicates no filter
      startDate: null,
      endDate: null,
      sortBy: SortBy.popularity, // Default sort by popularity
      isAscending: false, // Default: descending popularity
    );
  }

  ContentFilterState copyWith({
    Set<String>? genres,
    Set<String>? languages,
    Set<String>? countries,
    double? minVoteAverage,
    double? maxVoteAverage,
    int? minRuntime,
    int? maxRuntime,
    DateTime? startDate,
    DateTime? endDate,
    SortBy? sortBy,
    bool? isAscending,
  }) {
    return ContentFilterState(
      genres: genres ?? this.genres,
      languages: languages ?? this.languages,
      countries: countries ?? this.countries,
      minVoteAverage: minVoteAverage ?? this.minVoteAverage,
      maxVoteAverage: maxVoteAverage ?? this.maxVoteAverage,
      minRuntime: minRuntime ?? this.minRuntime,
      maxRuntime: maxRuntime ?? this.maxRuntime,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      sortBy: sortBy ?? this.sortBy,
      isAscending: isAscending ?? this.isAscending,
    );
  }

  bool get isClear => this == ContentFilterState.initial();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ContentFilterState &&
        setEquals(genres, other.genres) &&
        setEquals(languages, other.languages) &&
        setEquals(countries, other.countries) &&
        minVoteAverage == other.minVoteAverage &&
        maxVoteAverage == other.maxVoteAverage &&
        minRuntime == other.minRuntime &&
        maxRuntime == other.maxRuntime &&
        startDate == other.startDate &&
        endDate == other.endDate &&
        sortBy == other.sortBy &&
        isAscending == other.isAscending;
  }

  @override
  int get hashCode {
    return Object.hash(
      Object.hashAll(genres),
      Object.hashAll(languages),
      Object.hashAll(countries),
      minVoteAverage,
      maxVoteAverage,
      minRuntime,
      maxRuntime,
      startDate,
      endDate,
      sortBy,
      isAscending,
    );
  }
}

// --- Part 2: Enhancing the Providers ---

// NOTE: The `AnimeProvider` and `TvSeriesProvider` code is nearly identical.
// I will apply the filtering/sorting logic to the TvSeriesProvider as a representative example,
// and it can be directly adapted for AnimeProvider. MovieProvider will get its own specific implementation.
// The boilerplate like singleton pattern and data loading will remain as provided by the user.

/// Abstract base class for common provider functionality (optional, but good for shared logic)
abstract class ContentProvider<T> with ChangeNotifier {
  ContentFilterState _activeFilters = ContentFilterState.initial();
  String _searchQuery = '';
  List<T> _masterList = []; // This will hold all loaded data

  ContentFilterState get activeFilters => _activeFilters;
  String get searchQuery => _searchQuery;

  List<T> get filteredAndSortedContent; // Public getter for UI to consume

  Set<String> get allAvailableGenres;
  Set<String> get allAvailableLanguages;
  Set<String> get allAvailableCountries; // Only relevant for MovieProvider

  /// Applies active filters and search query to the master list and updates search results.
  /// This method should be called whenever filters or search query change.
  @protected
  List<T> applyFilteringAndSorting(
      List<T> contentList, String currentSearchQuery, ContentFilterState currentFilters) {
    List<T> results = contentList.where((item) {
      // 1. Apply existing text search (if any)
      bool textMatch = true;
      if (currentSearchQuery.isNotEmpty) {
        if (item is TvSeriesAnime) {
          final sItem = item;
          textMatch = sItem.name.toLowerCase().contains(currentSearchQuery) ||
              sItem.originalName.toLowerCase().contains(currentSearchQuery) ||
              sItem.overview.toLowerCase().contains(currentSearchQuery) ||
              sItem.genres.any(
                  (g) => g.toLowerCase().contains(currentSearchQuery)) ||
              sItem.keywords.any(
                  (k) => k.toLowerCase().contains(currentSearchQuery)) ||
              sItem.firstAirDate?.year.toString() == currentSearchQuery ||
              sItem.tmdbId.toString() == currentSearchQuery;
        } else if (item is Movie) {
          final mItem = item;
          textMatch = mItem.title.toLowerCase().contains(currentSearchQuery) ||
              mItem.originalTitle.toLowerCase().contains(currentSearchQuery) ||
              mItem.overview.toLowerCase().contains(currentSearchQuery) ||
              mItem.genres.any(
                  (g) => g.toLowerCase().contains(currentSearchQuery)) ||
              mItem.keywords.any(
                  (k) => k.toLowerCase().contains(currentSearchQuery)) ||
              mItem.releaseDate?.year.toString() == currentSearchQuery;
        }
      }
      if (!textMatch) return false;

      // 2. Apply filters from ContentFilterState
      // Genres
      if (currentFilters.genres.isNotEmpty) {
        if (item is TvSeriesAnime &&
            !item.genres.any((g) => currentFilters.genres.contains(g))) {
          return false;
        }
        if (item is Movie &&
            !item.genres.any((g) => currentFilters.genres.contains(g))) {
          return false;
        }
      }
      // Languages
      if (currentFilters.languages.isNotEmpty) {
        if (item is TvSeriesAnime &&
            !currentFilters.languages.contains(item.originalLanguage)) {
          return false;
        }
        if (item is Movie &&
            !currentFilters.languages.contains(item.originalLanguage)) {
          return false;
        }
      }
      // Countries (Movie-specific)
      if (item is Movie && currentFilters.countries.isNotEmpty) {
        if (!item.productionCountries
            .any((c) => currentFilters.countries.contains(c))) {
          return false;
        }
      }

      // Vote Average
      double itemVoteAverage = 0.0;
      if (item is TvSeriesAnime) itemVoteAverage = item.voteAverage;
      if (item is Movie) itemVoteAverage = item.voteAverage;
      if (itemVoteAverage < currentFilters.minVoteAverage ||
          itemVoteAverage > currentFilters.maxVoteAverage) {
        return false;
      }

      // Runtime
      int? itemRuntime;
      if (item is TvSeriesAnime) itemRuntime = item.runtime;
      if (item is Movie) itemRuntime = item.runtime;

      if (currentFilters.minRuntime != null && itemRuntime != null) {
        if (itemRuntime < currentFilters.minRuntime!) return false;
      } else if (currentFilters.minRuntime != null && itemRuntime == null) {
        // If a min runtime is set, but the item has no runtime, it doesn't match
        return false;
      }

      if (currentFilters.maxRuntime != null && itemRuntime != null) {
        if (itemRuntime > currentFilters.maxRuntime!) return false;
      } else if (currentFilters.maxRuntime != null && itemRuntime == null) {
        // If a max runtime is set, but the item has no runtime, it doesn't match
        return false;
      }

      // Date Range
      DateTime? itemDate;
      if (item is TvSeriesAnime) itemDate = item.firstAirDate;
      if (item is Movie) itemDate = item.releaseDate;

      if (itemDate != null) {
        if (currentFilters.startDate != null &&
            itemDate.isBefore(currentFilters.startDate!)) return false;
        if (currentFilters.endDate != null &&
            itemDate.isAfter(currentFilters.endDate!.endOfDay)) return false;
      } else {
        // If itemDate is null but a date filter is applied, it doesn't match
        if (currentFilters.startDate != null ||
            currentFilters.endDate != null) return false;
      }

      return true;
    }).toList();

    // 3. Apply sorting
    results.sort((a, b) {
      int compare = 0;
      switch (currentFilters.sortBy) {
        case SortBy.popularity:
          double popA = (a is Movie) ? a.popularity : (a as TvSeriesAnime).popularity;
          double popB = (b is Movie) ? b.popularity : (b as TvSeriesAnime).popularity;
          compare = popA.compareTo(popB);
          break;
        case SortBy.voteAverage:
          double voteA = (a is Movie) ? a.voteAverage : (a as TvSeriesAnime).voteAverage;
          double voteB = (b is Movie) ? b.voteAverage : (b as TvSeriesAnime).voteAverage;
          compare = voteA.compareTo(voteB);
          break;
        case SortBy.releaseDate:
          final dateA = (a is Movie) ? a.releaseDate : (a as TvSeriesAnime).firstAirDate;
          final dateB = (b is Movie) ? b.releaseDate : (b as TvSeriesAnime).firstAirDate;
          // Handle null dates: nulls come last in ascending, first in descending
          if (dateA == null && dateB == null) {
            compare = 0;
          } else if (dateA == null) {
            compare = 1;
          } else if (dateB == null) {
            compare = -1;
          } else {
            compare = dateA.compareTo(dateB);
          }
          break;
        case SortBy.name:
          final nameA = (a is Movie) ? a.title : (a as TvSeriesAnime).name;
          final nameB = (b is Movie) ? b.title : (b as TvSeriesAnime).name;
          compare = nameA.toLowerCase().compareTo(nameB.toLowerCase());
          break;
        case SortBy.runtime:
          final runtimeA = (a is Movie) ? a.runtime : (a as TvSeriesAnime).runtime;
          final runtimeB = (b is Movie) ? b.runtime : (b as TvSeriesAnime).runtime;
          if (runtimeA == null && runtimeB == null) {
            compare = 0;
          } else if (runtimeA == null) {
            compare = 1;
          } else if (runtimeB == null) {
            compare = -1;
          } else {
            compare = runtimeA.compareTo(runtimeB);
          }
          break;
      }
      return currentFilters.isAscending ? compare : -compare;
    });

    return results;
  }

  /// Public method to apply new filters.
  void applyFiltersAndSort(ContentFilterState newFilters) {
    _activeFilters = newFilters;
    _updateFilteredAndSortedContent();
  }

  /// Public method to update search query.
  void updateSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    _updateFilteredAndSortedContent();
  }

  /// Internal method to trigger the filter and sort logic and notify listeners.
  @protected
  void _updateFilteredAndSortedContent(); // Must be implemented by subclasses
}

// --- Movie Provider Implementation ---
class MovieProvider extends ContentProvider<Movie> {
  // --- Singleton Implementation ---
  static final MovieProvider _instance = MovieProvider._internal();

  factory MovieProvider() {
    return _instance;
  }

  MovieProvider._internal() {
    // Private constructor that is called only once
    _initializeData();
  }

  List<Movie> _searchResults = [];
  LoadingStatus _status = LoadingStatus.notloaded;
  String? _errorMessage;
  bool _isInitialized = false;

  @override
  List<Movie> get filteredAndSortedContent => _searchResults;
  LoadingStatus get status => _status;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == LoadingStatus.loading;
  bool get hasError => _status == LoadingStatus.error;
  bool get isIdeling => _status == LoadingStatus.idle;
  bool get isLooaded => _status == LoadingStatus.loaded;
  bool get isInitialized => _isInitialized;

  // New getters for filter options
  Set<String> _allAvailableGenres = {};
  Set<String> _allAvailableLanguages = {};
  Set<String> _allAvailableCountries = {};

  @override
  Set<String> get allAvailableGenres => _allAvailableGenres;
  @override
  Set<String> get allAvailableLanguages => _allAvailableLanguages;
  @override
  Set<String> get allAvailableCountries => _allAvailableCountries;

  Future<void> _initializeData() async {
    if (!_isInitialized) {
      await loadMovies();
      _isInitialized = true;
    }
  }

  Future<void> ensureInitialized() async {
    if (!_isInitialized) {
      await _initializeData();
    }
  }

  Future<void> loadMovies() async {
    if (_status == LoadingStatus.loading || _status == LoadingStatus.loaded) {
      return; // Prevent multiple loads
    }
    super.updateSearchQuery(''); // Reset search query on load
    _status = LoadingStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final rawData = await rootBundle.loadString('assets/movies_db.csv');
      List<List<dynamic>> csvTable = const CsvToListConverter().convert(rawData);

      final dataRows = csvTable.skip(1);
      _masterList = dataRows.map((row) {
        return Movie.fromCsvRow(row);
      }).toList();

      // Collect all unique filter options
      _allAvailableGenres = _masterList.expand((movie) => movie.genres).toSet();
      _allAvailableLanguages = _masterList.map((movie) => movie.originalLanguage).toSet();
      _allAvailableCountries = _masterList.expand((movie) => movie.productionCountries).toSet();

      _masterList.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase())); // Initial sort

      _status = LoadingStatus.loaded;
      if (kDebugMode) {
        print("Successfully loaded ${_masterList.length} movies from CSV.");
      }
    } catch (e, stacktrace) {
      _status = LoadingStatus.error;
      _errorMessage = "Failed to load or parse CSV: $e";
      if (kDebugMode) {
        print("CSV Loading Error (MovieProvider): $e");
        print(stacktrace);
      }
      _masterList = [];
    } finally {
      _updateFilteredAndSortedContent(); // Apply initial sort/filters
      notifyListeners();
    }
  }

  // Override searchMovies to use the new filtering logic
  void searchMovies(String? query) {
    super.updateSearchQuery(query ?? '');
  }

  @override
  void _updateFilteredAndSortedContent() {
    _searchResults = applyFilteringAndSorting(_masterList, _searchQuery, _activeFilters);
    notifyListeners();
  }

  Movie? getMovieById(int id) {
    try {
      return _masterList.firstWhere((movie) => movie.id == id);
    } catch (e) {
      return null;
    }
  }

  // Notifying listeners is handled by _updateFilteredAndSortedContent, so remove the duplicate
  @override
  // ignore: unnecessary_overrides
  void notifyListeners() {
    super.notifyListeners(); // Call ChangeNotifier's notifyListeners once
  }
}

// --- TvSeries Provider Implementation ---
class TvSeriesProvider extends ContentProvider<TvSeriesAnime> {
  // --- Constants (provided by user, kept as is) ---
  static const String _tvSeriesDetailPath = 'assets/tv_series_details.csv';
  static const String _episodetvsCsvPath = 'assets/tv_series_link.csv';

  // --- Singleton Implementation ---
  static final TvSeriesProvider _instance = TvSeriesProvider._internal();

  factory TvSeriesProvider() {
    return _instance;
  }

  TvSeriesProvider._internal() {
    // Private constructor that is called only once
    _initializeData();
  }

  // --- Private State ---
  Map<int, TvSeriesAnime> _animeseriesMap = {};
  List<TvSeriesAnime> _searchResults = [];
  LoadingStatus _status = LoadingStatus.notloaded;
  String? _errorMessage;
  bool _isInitialized = false;

  // --- Public Getters ---
  @override
  List<TvSeriesAnime> get filteredAndSortedContent => _searchResults;
  LoadingStatus get status => _status;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == LoadingStatus.loading;
  bool get hasError => _status == LoadingStatus.error;
  bool get isInitialized => _isInitialized;

  // New getters for filter options
  Set<String> _allAvailableGenres = {};
  Set<String> _allAvailableLanguages = {};

  @override
  Set<String> get allAvailableGenres => _allAvailableGenres;
  @override
  Set<String> get allAvailableLanguages => _allAvailableLanguages;
  @override
  Set<String> get allAvailableCountries => {}; // TV Series does not have this property

  // Initialize data only once
  Future<void> _initializeData() async {
    if (!_isInitialized) {
      await loadTvSeriesData();
      _isInitialized = true;
    }
  }

  // Ensure data is loaded before accessing
  Future<void> ensureInitialized() async {
    if (!_isInitialized) {
      await _initializeData();
    }
  }

  Future<void> loadTvSeriesData() async {
    if (_status == LoadingStatus.loading ||
        _status == LoadingStatus.loaded ||
        _status == LoadingStatus.idle) {
      return;
    }

    super.updateSearchQuery(''); // Reset search query on load
    super.applyFiltersAndSort(ContentFilterState.initial()); // Reset filters on load
    _status = LoadingStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      // 1. Load Series Details CSV
      final detailsRawData = await rootBundle.loadString(_tvSeriesDetailPath);
      List<List<dynamic>> detailsCsvTable = const CsvToListConverter().convert(detailsRawData);

      final Map<int, TvSeriesAnime> tempAnimeSeriesMap = {};
      final Map<String, int> animeseriesnameToTmdbidMap = {};

      for (final row in detailsCsvTable.skip(1)) {
        try {
          final animeseries = TvSeriesAnime.fromCsvRow(row);
          if (animeseries.tmdbId != 0) {
            tempAnimeSeriesMap[animeseries.tmdbId] = animeseries;
            animeseriesnameToTmdbidMap[animeseries.originalName.toLowerCase()] = animeseries.tmdbId;
            if (row.length > 1 &&
                row[1] != null &&
                row[1].toString().toLowerCase() !=
                    animeseries.originalName.trim().toLowerCase()) {
              animeseriesnameToTmdbidMap[row[1].toString().toLowerCase()] = animeseries.tmdbId;
            }
          }
        } catch (e, stacktrace) {
          if (kDebugMode) {
            print("Error parsing TV Series details row: $row -> $e");
            print(stacktrace);
          }
        }
      }

      // 2. Load Episodes CSV
      final episodesRawData = await rootBundle.loadString(_episodetvsCsvPath);
      List<List<dynamic>> episodesCsvTable = const CsvToListConverter().convert(episodesRawData);

      final Map<int, List<Episode>> tempEpisodesByTmdbId = {};

      for (final row in episodesCsvTable.skip(1)) {
        if (row.isNotEmpty && row[0] != null) {
          final String animeseriesNameFromEpisodeCsv = row[0].toString();
          final String animeseriesNameLower = animeseriesNameFromEpisodeCsv.toLowerCase();
          int? targetTmdbId = animeseriesnameToTmdbidMap[animeseriesNameLower];

          if (targetTmdbId != null) {
            try {
              final episode = Episode.fromCsvInfo(animeseriesNameFromEpisodeCsv, targetTmdbId, row);
              tempEpisodesByTmdbId.putIfAbsent(targetTmdbId, () => []).add(episode);
            } catch (e) {
              if (kDebugMode) {
                print(
                    "Error parsing episode from row for series '$animeseriesNameFromEpisodeCsv' (mapped to $targetTmdbId): $row -> $e");
              }
            }
          } else {
            if (kDebugMode) {
              print(
                  "Warning: Could not find matching TMDB ID for series name '$animeseriesNameFromEpisodeCsv' from episodes CSV.");
            }
          }
        }
      }

      // 3. Combine Details and Episodes
      for (final tmdbId in tempAnimeSeriesMap.keys) {
        final baseSeries = tempAnimeSeriesMap[tmdbId]!;
        final csvEpisodes = tempEpisodesByTmdbId[tmdbId] ?? [];

        csvEpisodes.sort((a, b) {
          if (a.seasonNumber != b.seasonNumber) return a.seasonNumber.compareTo(b.seasonNumber);
          return a.episodeNumber.compareTo(b.episodeNumber);
        });

        Map<int, List<Episode>> episodesBySeason = {};
        for (var episode in csvEpisodes) {
          episodesBySeason.putIfAbsent(episode.seasonNumber, () => []).add(episode);
        }

        List<Season> seasons = episodesBySeason.entries
            .map((entry) => Season(
                  seasonNumber: entry.key,
                  episodes: entry.value,
                ))
            .toList()
          ..sort((a, b) => a.seasonNumber.compareTo(b.seasonNumber));

        final finalSeries = baseSeries.copyWith(seasons: seasons);
        _animeseriesMap[tmdbId] = finalSeries;
      }

      _masterList = _animeseriesMap.values.toList()
        ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase())); // Initial Sort

      // Collect all unique filter options
      _allAvailableGenres = _masterList.expand((series) => series.genres).toSet();
      _allAvailableLanguages = _masterList.map((series) => series.originalLanguage).toSet();

      _status = LoadingStatus.loaded;
      if (kDebugMode) {
        print("Successfully loaded and combined data for ${_masterList.length} TV series.");
      }
    } catch (e, stacktrace) {
      _status = LoadingStatus.error;
      _errorMessage = "Failed to load TV series data: $e";
      if (kDebugMode) {
        print("TvSeries Loading Error: $e");
        print(stacktrace);
      }
      _animeseriesMap = {};
      _masterList = [];
    } finally {
      // Cache logic could be here (it was in the original, but let's re-evaluate caching after filtering)
      // For now, focus on direct CSV loading and filtering.
      _updateFilteredAndSortedContent(); // Apply initial sort/filters
      notifyListeners();
    }
  }

  // Override searchAnime to use the new filtering logic
  void searchTvSeries(String query) {
    super.updateSearchQuery(query);
  }

  @override
  void _updateFilteredAndSortedContent() {
    _searchResults = applyFilteringAndSorting(_masterList, _searchQuery, _activeFilters);
    notifyListeners();
  }

  TvSeriesAnime? getTvSeriesByTmdbId(int tmdbId) {
    return _animeseriesMap[tmdbId];
  }
}

// --- Anime Provider Implementation (identical to TvSeriesProvider, minimal changes) ---
class AnimeProvider extends ContentProvider<TvSeriesAnime> {
  // --- Constants ---
  static const String _animeseriesDetailsCsvPath = 'assets/anime_series_details.csv';
  static const String _episodesCsvPath = 'assets/anime_series_link.csv';

  // --- Singleton Implementation ---
  static final AnimeProvider _instance = AnimeProvider._internal();

  factory AnimeProvider() {
    return _instance;
  }

  AnimeProvider._internal() {
    _initializeData();
  }

  // --- Private State ---
  Map<int, TvSeriesAnime> _animeseriesMap = {};
  List<TvSeriesAnime> _searchResults = [];
  LoadingStatus _status = LoadingStatus.notloaded;
  String? _errorMessage;
  bool _isInitialized = false;

  // --- Public Getters ---
  @override
  List<TvSeriesAnime> get filteredAndSortedContent => _searchResults;
  LoadingStatus get status => _status;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == LoadingStatus.loading;
  bool get hasError => _status == LoadingStatus.error;
  bool get isInitialized => _isInitialized;

  // New getters for filter options
  Set<String> _allAvailableGenres = {};
  Set<String> _allAvailableLanguages = {};

  @override
  Set<String> get allAvailableGenres => _allAvailableGenres;
  @override
  Set<String> get allAvailableLanguages => _allAvailableLanguages;
  @override
  Set<String> get allAvailableCountries => {}; // Anime does not have this property

  // Initialize data only once
  Future<void> _initializeData() async {
    if (!_isInitialized) {
      await loadAnimeData();
      _isInitialized = true;
    }
  }

  Future<void> ensureInitialized() async {
    if (!_isInitialized) {
      await _initializeData();
    }
  }

  Future<void> loadAnimeData() async {
    if (_status == LoadingStatus.loading ||
        _status == LoadingStatus.loaded ||
        _status == LoadingStatus.idle) {
      return;
    }

    super.updateSearchQuery(''); // Reset search query on load
    super.applyFiltersAndSort(ContentFilterState.initial()); // Reset filters on load
    _status = LoadingStatus.loading;
    _errorMessage = null;
    notifyListeners();

    // Attempt to load cached data to avoid reprocessing CSV on each launch
    // NOTE: Caching logic needs to be robust. For this task, removed direct cache load
    // to ensure CSV parsing happens for initial setup/collection of all unique filter options.
    // Re-added general cache saving after parsing.

    try {
      // 1. Load Series Details CSV
      final detailsRawData = await rootBundle.loadString(_animeseriesDetailsCsvPath);
      List<List<dynamic>> detailsCsvTable = const CsvToListConverter().convert(detailsRawData);

      final Map<int, TvSeriesAnime> tempAnimeSeriesMap = {};
      final Map<String, int> animeseriesnameToTmdbidMap = {};

      for (final row in detailsCsvTable.skip(1)) {
        try {
          final animeseries = TvSeriesAnime.fromCsvRow(row);
          if (animeseries.tmdbId != 0) {
            tempAnimeSeriesMap[animeseries.tmdbId] = animeseries;
            animeseriesnameToTmdbidMap[animeseries.originalName.toLowerCase()] = animeseries.tmdbId;
            if (row.length > 1 &&
                row[1] != null &&
                row[1].toString().toLowerCase() !=
                    animeseries.originalName.trim().toLowerCase()) {
              animeseriesnameToTmdbidMap[row[1].toString().toLowerCase()] = animeseries.tmdbId;
            }
          }
        } catch (e, stacktrace) {
          if (kDebugMode) {
            print("Error parsing TV Series details row: $row -> $e");
            print(stacktrace);
          }
        }
      }

      // 2. Load Episodes CSV
      final episodesRawData = await rootBundle.loadString(_episodesCsvPath);
      List<List<dynamic>> episodesCsvTable = const CsvToListConverter().convert(episodesRawData);

      final Map<int, List<Episode>> tempEpisodesByTmdbId = {};

      for (final row in episodesCsvTable.skip(1)) {
        if (row.isNotEmpty && row[0] != null) {
          final String animeseriesNameFromEpisodeCsv = row[0].toString();
          final String animeseriesNameLower = animeseriesNameFromEpisodeCsv.toLowerCase();
          int? targetTmdbId = animeseriesnameToTmdbidMap[animeseriesNameLower];

          if (targetTmdbId != null) {
            try {
              final episode = Episode.fromCsvInfo(animeseriesNameFromEpisodeCsv, targetTmdbId, row);
              tempEpisodesByTmdbId.putIfAbsent(targetTmdbId, () => []).add(episode);
            } catch (e) {
              if (kDebugMode) {
                print(
                    "Error parsing episode from row for series '$animeseriesNameFromEpisodeCsv' (mapped to $targetTmdbId): $row -> $e");
              }
            }
          } else {
            if (kDebugMode) {
              print(
                  "Warning: Could not find matching TMDB ID for series name '$animeseriesNameFromEpisodeCsv' from episodes CSV.");
            }
          }
        }
      }

      // 3. Combine Details and Episodes
      for (final tmdbId in tempAnimeSeriesMap.keys) {
        final baseSeries = tempAnimeSeriesMap[tmdbId]!;
        final csvEpisodes = tempEpisodesByTmdbId[tmdbId] ?? [];

        csvEpisodes.sort((a, b) {
          if (a.seasonNumber != b.seasonNumber) return a.seasonNumber.compareTo(b.seasonNumber);
          return a.episodeNumber.compareTo(b.episodeNumber);
        });

        Map<int, List<Episode>> episodesBySeason = {};
        for (var episode in csvEpisodes) {
          episodesBySeason.putIfAbsent(episode.seasonNumber, () => []).add(episode);
        }

        List<Season> seasons = episodesBySeason.entries
            .map((entry) => Season(
                  seasonNumber: entry.key,
                  episodes: entry.value,
                ))
            .toList()
          ..sort((a, b) => a.seasonNumber.compareTo(b.seasonNumber));

        final finalSeries = baseSeries.copyWith(seasons: seasons);
        _animeseriesMap[tmdbId] = finalSeries;
      }

      _masterList = _animeseriesMap.values.toList()
        ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase())); // Initial sort

      // Collect all unique filter options
      _allAvailableGenres = _masterList.expand((series) => series.genres).toSet();
      _allAvailableLanguages = _masterList.map((series) => series.originalLanguage).toSet();

      // Cache the combined data
      try {
        final dir = await getApplicationDocumentsDirectory();
        final cacheFile = File('${dir.path}/anime_cache.json');
        final List<Map<String, dynamic>> jsonData = _masterList.map((s) => s.toJson()).toList();
        await cacheFile.writeAsString(jsonEncode(jsonData));
        if (kDebugMode) print('Cached anime data to ${cacheFile.path}');
      } catch (e) {
        if (kDebugMode) print('Failed to write anime cache: $e');
      }

      _status = LoadingStatus.loaded;
      if (kDebugMode) {
        print("Successfully loaded and combined data for ${_masterList.length} anime series.");
      }
    } catch (e, stacktrace) {
      _status = LoadingStatus.error;
      _errorMessage = "Failed to load anime data: $e";
      if (kDebugMode) {
        print("Anime Loading Error: $e");
        print(stacktrace);
      }
      _animeseriesMap = {};
      _masterList = [];
    } finally {
      _updateFilteredAndSortedContent(); // Apply initial sort/filters
      notifyListeners();
    }
  }

  void searchAnime(String query) {
    super.updateSearchQuery(query);
  }

  @override
  void _updateFilteredAndSortedContent() {
    _searchResults = applyFilteringAndSorting(_masterList, _searchQuery, _activeFilters);
    notifyListeners();
  }

  TvSeriesAnime? getAnimeByTmdbId(int tmdbId) {
    return _animeseriesMap[tmdbId];
  }
}

// --- Part 3: Building the Filter UI ---


// --- Main Application Entry (Example of how to set up providers) ---

// void main() {
//   // Ensure Flutter binding is initialized if running independently for testing
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider<MovieProvider>(
//             create: (_) => MovieProvider()),
//         ChangeNotifierProvider<TvSeriesProvider>(
//             create: (_) => TvSeriesProvider()),
//         ChangeNotifierProvider<AnimeProvider>(
//             create: (_) => AnimeProvider()),
//       ],
//       child: const MyApp(),
//     ),
//   );
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Content Filter App',
//       theme: ThemeData(
//         brightness: Brightness.dark,
//         primarySwatch: Colors.blueGrey,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//         appBarTheme: const AppBarTheme(
//           backgroundColor: Colors.blueGrey,
//           foregroundColor: Colors.white,
//         ),
//         chipTheme: const ChipThemeData(
//           backgroundColor: Colors.blueGrey,
//           labelStyle: TextStyle(color: Colors.white),
//           selectedColor: Colors.blueGrey, // Used for FilterChip selected background
//           deleteIconColor: Colors.white,
//           checkmarkColor: Colors.white,
//         ),
//         sliderTheme: const SliderThemeData(
//           activeTrackColor: Colors.blueGrey,
//           inactiveTrackColor: Colors.blueGrey,
//           thumbColor: Colors.white,
//           valueIndicatorColor: Colors.blueGrey,
//           overlayColor: Colors.blueGrey,
//         ),
//         elevatedButtonTheme: ElevatedButtonThemeData(
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.blueGrey,
//             foregroundColor: Colors.white,
//           ),
//         ),
//       ),
//       home: DefaultTabController(
//         length: 3, // For Movies, TV Series, Anime tabs
//         child: Scaffold(
//           appBar: AppBar(
//             title: const Text('Movies, TV & Anime'),
//             bottom: const TabBar(
//               tabs: [
//                 Tab(text: 'Movies'),
//                 Tab(text: 'TV Series'),
//                 Tab(text: 'Anime'),
//               ],
//             ),
//           ),
//           body: TabBarView(
//             children: [
//               // Movie List Page with filter integration
//               Consumer<MovieProvider>(
//                 builder: (context, movieProvider, child) {
//                   // Ensure data is loaded
//                   if (!movieProvider.isInitialized) {
//                     movieProvider.ensureInitialized();
//                     return const Center(child: CircularProgressIndicator());
//                   }
//                   return const MovieListPage(); // Your actual movie list UI
//                 },
//               ),
//               // TV Series List Page (similar structure as MovieListPage, adapt as needed)
//               Consumer<TvSeriesProvider>(
//                 builder: (context, tvSeriesProvider, child) {
//                   if (!tvSeriesProvider.isInitialized) {
//                     tvSeriesProvider.ensureInitialized();
//                     return const Center(child: CircularProgressIndicator());
//                   }
//                   return _buildContentListPage<TvSeriesProvider, TvSeriesAnime>(
//                       tvSeriesProvider, (item) => item.name, (item) => item.firstAirDate);
//                 },
//               ),
//               // Anime List Page (identical structure to TvSeriesListPage, likely a shared widget)
//               Consumer<AnimeProvider>(
//                 builder: (context, animeProvider, child) {
//                   if (!animeProvider.isInitialized) {
//                     animeProvider.ensureInitialized();
//                     return const Center(child: CircularProgressIndicator());
//                   }
//                   return _buildContentListPage<AnimeProvider, TvSeriesAnime>(
//                       animeProvider, (item) => item.name, (item) => item.firstAirDate);
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // Generic content list page builder for TV Series and Anime
//   Widget _buildContentListPage<P extends ContentProvider<T>, T>(
//       P provider,
//       String Function(T) getTitle,
//       DateTime? Function(T) getDate,
//       ) {
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: const Size.fromHeight(100.0), // Adjust height for search bar + filters
//         child: AppBar(
//           automaticallyImplyLeading: false, // Don't show back button on tab views
//           title: Text('${T == Movie ? 'Movies' : T == TvSeriesAnime ? 'TV & Anime' : 'Content'}'), // Dynamic title
//           actions: [
//             IconButton(
//               icon: const Icon(Icons.filter_list),
//               onPressed: () {
//                 showModalBottomSheet(
//                   context: context,
//                   isScrollControlled: true,
//                   builder: (context) => ContentFilterBottomSheet<P>(
//                     provider: provider,
//                   ),
//                 );
//               },
//             ),
//           ],
//           bottom: PreferredSize(
//             preferredSize: const Size.fromHeight(60.0),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//               child: TextField(
//                 decoration: InputDecoration(
//                   hintText: 'Search...',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8.0),
//                     borderSide: BorderSide.none,
//                   ),
//                   filled: true,
//                   fillColor: Colors.white,
//                   contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
//                   prefixIcon: const Icon(Icons.search),
//                 ),
//                 onChanged: (query) {
//                   provider.updateSearchQuery(query);
//                 },
//               ),
//             ),
//           ),
//         ),
//       ),
//       body: Column(
//         children: [
//           Consumer<P>(
//             builder: (context, currentProvider, child) {
//               final activeFilters = currentProvider.activeFilters;
//               final List<Widget> filterChips = [];

//               if (!activeFilters.isClear) {
//                 if (activeFilters.genres.isNotEmpty) {
//                   filterChips.add(_buildActiveFilterChip(
//                     'Genres: ${activeFilters.genres.join(', ')}',
//                         () => currentProvider.applyFiltersAndSort(
//                         activeFilters.copyWith(genres: {})),
//                   ));
//                 }
//                 if (activeFilters.languages.isNotEmpty) {
//                   filterChips.add(_buildActiveFilterChip(
//                     'Languages: ${activeFilters.languages.join(', ')}',
//                         () => currentProvider.applyFiltersAndSort(
//                         activeFilters.copyWith(languages: {})),
//                   ));
//                 }
//                 if (activeFilters.minVoteAverage > ContentFilterState.initial().minVoteAverage ||
//                     activeFilters.maxVoteAverage < ContentFilterState.initial().maxVoteAverage) {
//                   filterChips.add(_buildActiveFilterChip(
//                     'Vote: ${activeFilters.minVoteAverage.toStringAsFixed(1)}-${activeFilters.maxVoteAverage.toStringAsFixed(1)}',
//                         () => currentProvider.applyFiltersAndSort(activeFilters.copyWith(
//                           minVoteAverage: ContentFilterState.initial().minVoteAverage,
//                           maxVoteAverage: ContentFilterState.initial().maxVoteAverage,
//                         )),
//                   ));
//                 }
//                 if (activeFilters.minRuntime != null || activeFilters.maxRuntime != null) {
//                   filterChips.add(_buildActiveFilterChip(
//                     'Runtime: ${activeFilters.minRuntime ?? 'Any'}-${activeFilters.maxRuntime ?? 'Any'} min',
//                         () => currentProvider.applyFiltersAndSort(
//                         activeFilters.copyWith(minRuntime: null, maxRuntime: null)),
//                   ));
//                 }
//                 if (activeFilters.startDate != null || activeFilters.endDate != null) {
//                   String dateRange = '';
//                   if (activeFilters.startDate != null)
//                     dateRange +=
//                         'From: ${activeFilters.startDate!.toLocal().year}-${activeFilters.startDate!.toLocal().month.toString().padLeft(2, '0')}-${activeFilters.startDate!.toLocal().day.toString().padLeft(2, '0')}';
//                   if (activeFilters.endDate != null)
//                     dateRange +=
//                         ' To: ${activeFilters.endDate!.toLocal().year}-${activeFilters.endDate!.toLocal().month.toString().padLeft(2, '0')}-${activeFilters.endDate!.toLocal().day.toString().padLeft(2, '0')}';
//                   filterChips.add(_buildActiveFilterChip(
//                     'Date: $dateRange',
//                         () => currentProvider.applyFiltersAndSort(
//                         activeFilters.copyWith(startDate: null, endDate: null)),
//                   ));
//                 }

//                 String sortLabel = 'Sort by: ${activeFilters.sortBy.toString().split('.').last.replaceAllMapped(RegExp(r'([A-Z])'), (match) => ' ${match.group(1)}').trim()} (${activeFilters.isAscending ? 'Asc' : 'Desc'})';
//                 filterChips.add(Chip(label: Text(sortLabel)));
//               }

//               if (filterChips.isEmpty && currentProvider.searchQuery.isEmpty) {
//                 return const SizedBox.shrink();
//               }

//               return Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//                 child: Wrap(
//                   spacing: 8.0,
//                   runSpacing: 4.0,
//                   children: [
//                     if (currentProvider.searchQuery.isNotEmpty)
//                       _buildActiveFilterChip(
//                         'Search: "${currentProvider.searchQuery}"',
//                             () {
//                           currentProvider.updateSearchQuery('');
//                         },
//                       ),
//                     ...filterChips,
//                     if (!activeFilters.isClear)
//                       ActionChip(
//                         label: const Text('Clear All Filters'),
//                         avatar: const Icon(Icons.clear_all),
//                         onPressed: () {
//                           currentProvider.applyFiltersAndSort(ContentFilterState.initial());
//                         },
//                       ),
//                   ],
//                 ),
//               );
//             },
//           ),
//           Expanded(
//             child: provider.isLoading
//                 ? const Center(child: CircularProgressIndicator())
//                 : provider.hasError
//                     ? Center(child: Text('Error: ${provider.errorMessage}'))
//                     : provider.filteredAndSortedContent.isEmpty
//                         ? const Center(child: Text('No content found matching criteria.'))
//                         : ListView.builder(
//                             itemCount: provider.filteredAndSortedContent.length,
//                             itemBuilder: (context, index) {
//                               final item = provider.filteredAndSortedContent[index];
//                               return ListTile(
//                                 leading: (item is TvSeriesAnime) && item.fullPosterUrl != null
//                                     ? Image.network(item.fullPosterUrl!,
//                                         height: 60, width: 40, fit: BoxFit.cover)
//                                     : (item is Movie) && item.getPosterUrl() != null
//                                         ? Image.network(item.getPosterUrl()!,
//                                             height: 60, width: 40, fit: BoxFit.cover)
//                                         : null,
//                                 title: Text(getTitle(item)),
//                                 subtitle: Text(
//                                     'Rating: ${((item is Movie) ? item.voteAverage : (item as TvSeriesAnime).voteAverage).toStringAsFixed(1)} | '
//                                     'Year: ${getDate(item)?.year ?? 'N/A'}'),
//                               );
//                             },
//                           ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildActiveFilterChip(String label, VoidCallback onDelete) {
//     return Chip(
//       label: Text(label),
//       onDeleted: onDelete,
//       deleteIcon: const Icon(Icons.cancel),
//     );
//   }
// }