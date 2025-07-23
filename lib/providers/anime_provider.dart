
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import '../models/tv_series_anime.dart';

// Define enum outside the class if not already globally defined
// enum LoadingStatus { idle, loading, loaded, error }

class AnimeProvider extends ChangeNotifier {
  // --- Singleton Implementation ---
  static final AnimeProvider _instance = AnimeProvider._internal();

  factory AnimeProvider() {
    return _instance;
  }

  AnimeProvider._internal() {
    // Private constructor that is called only once
    _initializeData();
  }

  // --- Constants ---
  static const String _animeseriesDetailsCsvPath =
      'assets/anime_series_details.csv';
  static const String _episodesCsvPath = 'assets/anime_series_link.csv';

  // --- Private State ---
  Map<int, TvSeriesAnime> _animeseriesMap =
      {}; // Keyed by TMDB ID for efficient lookup
  List<TvSeriesAnime> _allAnimeSeriesList = []; // Sorted list for display
  List<TvSeriesAnime> _searchResults = [];
  LoadingStatus _status = LoadingStatus.notloaded;
  String? _errorMessage;
  String _searchQuery = '';
  bool _isInitialized = false;

  // --- Public Getters ---
  List<TvSeriesAnime> get animeseriesForDisplay =>
      _searchQuery.isEmpty ? _allAnimeSeriesList : _searchResults;
  LoadingStatus get status => _status;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == LoadingStatus.loading;
  bool get hasError => _status == LoadingStatus.error;
  String get searchQuery => _searchQuery;
  bool get isInitialized => _isInitialized;

  // Initialize data only once
  Future<void> _initializeData() async {
    if (!_isInitialized) {
      await loadAnimeData();
      _isInitialized = true;
    }
  }

  // Ensure data is loaded before accessing
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

    _updateStatus(LoadingStatus.loading);
    _animeseriesMap.clear();
    _allAnimeSeriesList.clear();
    _searchResults.clear();

    // Attempt to load cached data to avoid reprocessing CSV on each launch
    try {
      final dir = await getApplicationDocumentsDirectory();
      final cacheFile = File('${dir.path}/anime_cache.json');
      if (await cacheFile.exists()) {
        final content = await cacheFile.readAsString();
        final List<dynamic> jsonData = jsonDecode(content);
        for (var item in jsonData) {
          final series = TvSeriesAnime.fromJson(item as Map<String, dynamic>);
          _animeseriesMap[series.tmdbId] = series;
        }
        _allAnimeSeriesList = _animeseriesMap.values.toList()
          ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        _searchResults = _allAnimeSeriesList;
        _updateStatus(LoadingStatus.loaded);
        _isInitialized = true;
        if (kDebugMode) print('Loaded anime data from cache.');
        return;
      }
    } catch (e) {
      if (kDebugMode) print('Cache load failed, parsing CSV: $e');
    }

    try {
      // 1. Load Series Details CSV
      final detailsRawData =
          await rootBundle.loadString(_animeseriesDetailsCsvPath);
      List<List<dynamic>> detailsCsvTable =
          const CsvToListConverter().convert(detailsRawData);

      final Map<int, TvSeriesAnime> tempAnimeSeriesMap = {};
      // Using a temporary map to store series names -> tmdb_id for linking episodes later
      final Map<String, int> animeseriesnameToTmdbidMap = {};

      for (final row in detailsCsvTable.skip(1)) {
        // Skip header row
        try {
          final animeseries = TvSeriesAnime.fromCsvRow(row);
          if (animeseries.tmdbId != 0) {
            // Use TMDB ID as the primary key
            tempAnimeSeriesMap[animeseries.tmdbId] = animeseries;
            // Store the mapping: case-insensitive name from details CSV to its TMDB ID
            animeseriesnameToTmdbidMap[animeseries.originalName.toLowerCase()] =
                animeseries.tmdbId;
            // Also map the potentially different 'series' name if it exists and differs
            if (row.length > 1 &&
                row[1] != null &&
                row[1].toString().toLowerCase() !=
                    animeseries.originalName.trim().toLowerCase()) {
              animeseriesnameToTmdbidMap[row[1].toString().toLowerCase()] =
                  animeseries.tmdbId;
            }
          } else {
            if (kDebugMode) {
              print(
                  "Skipping series due to missing or invalid TMDB ID in row: $row");
            }
          }
        } catch (e, stacktrace) {
          if (kDebugMode) {
            print("Error parsing TV Series details row: $row -> $e");
            print(stacktrace);
          }
          // Decide if you want to stop loading or just skip the row
        }
      }

      if (kDebugMode) {
        print(
            "Loaded ${tempAnimeSeriesMap.length} series details. Name mapping count: ${animeseriesnameToTmdbidMap.length}");
      }

      // 2. Load Episodes CSV
      final episodesRawData = await rootBundle.loadString(_episodesCsvPath);
      List<List<dynamic>> episodesCsvTable =
          const CsvToListConverter().convert(episodesRawData);

      // Group episodes temporarily by TMDB ID
      final Map<int, List<Episode>> tempEpisodesByTmdbId = {};

      for (final row in episodesCsvTable.skip(1)) {
        // Skip header row
        if (row.isNotEmpty && row[0] != null) {
          final String animeseriesNameFromEpisodeCsv = row[0].toString();
          final String animeseriesNameLower =
              animeseriesNameFromEpisodeCsv.toLowerCase();

          // *** IMPORTANT JOIN LOGIC ***
          // Attempt to find the TMDB ID using the name from the episode CSV
          int? targetTmdbId = animeseriesnameToTmdbidMap[animeseriesNameLower];

          if (targetTmdbId != null) {
            try {
              final episode = Episode.fromCsvInfo(animeseriesNameFromEpisodeCsv,
                  targetTmdbId, row); // Pass targetTmdbId
              if (!tempEpisodesByTmdbId.containsKey(targetTmdbId)) {
                tempEpisodesByTmdbId[targetTmdbId] = [];
              }
              tempEpisodesByTmdbId[targetTmdbId]!.add(episode);
            } catch (e) {
              if (kDebugMode) {
                print(
                    "Error parsing episode from row for series '$animeseriesNameFromEpisodeCsv' (mapped to $targetTmdbId): $row -> $e");
              }
            }
          } else {
            // If the name wasn't found in the map
            if (kDebugMode) {
              // This indicates a mismatch or missing series in the details CSV
              print(
                  "Warning: Could not find matching TMDB ID for series name '$animeseriesNameFromEpisodeCsv' from episodes CSV.");
              // Optionally, try a fallback or log more prominently
            }
          }
        }
      }

      if (kDebugMode) {
        print("Processed episodes for ${tempEpisodesByTmdbId.length} series.");
      }

      // 3. Combine Details and Episodes
      for (final tmdbId in tempAnimeSeriesMap.keys) {
        final baseSeries = tempAnimeSeriesMap[tmdbId]!;
        final csvEpisodes =
            tempEpisodesByTmdbId[tmdbId] ?? []; // Get episodes for this TMDB ID

        // Sort episodes by season and episode number
        csvEpisodes.sort((a, b) {
          if (a.seasonNumber != b.seasonNumber) {
            return a.seasonNumber.compareTo(b.seasonNumber);
          }
          return a.episodeNumber.compareTo(b.episodeNumber);
        });

        // Group episodes by season number
        Map<int, List<Episode>> episodesBySeason = {};
        for (var episode in csvEpisodes) {
          if (!episodesBySeason.containsKey(episode.seasonNumber)) {
            episodesBySeason[episode.seasonNumber] = [];
          }
          episodesBySeason[episode.seasonNumber]!.add(episode);
        }

        // Create Season objects and sort them
        List<Season> seasons = episodesBySeason.entries
            .map((entry) => Season(
                  seasonNumber: entry.key,
                  episodes: entry.value,
                ))
            .toList()
          ..sort((a, b) => a.seasonNumber.compareTo(b.seasonNumber));

        // Create the final TvSeries object with combined data
        final finalSeries = baseSeries.copyWith(seasons: seasons);
        _animeseriesMap[tmdbId] = finalSeries; // Add to the final map
      }

    // Create the sorted list for display
    _allAnimeSeriesList = _animeseriesMap.values.toList()
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    _searchResults = _allAnimeSeriesList; // Initialize search results

    // Cache the combined data to avoid reprocessing CSV on next launch
    try {
      final dir = await getApplicationDocumentsDirectory();
      final cacheFile = File('${dir.path}/anime_cache.json');
      final List<Map<String, dynamic>> jsonData =
          _allAnimeSeriesList.map((s) => s.toJson()).toList();
      await cacheFile.writeAsString(jsonEncode(jsonData));
      if (kDebugMode) print('Cached anime data to ${cacheFile.path}');
    } catch (e) {
      if (kDebugMode) print('Failed to write anime cache: $e');
    }

    _updateStatus(LoadingStatus.loaded);
    _isInitialized = true;
    if (kDebugMode) {
      print("Successfully loaded and combined data for ${_allAnimeSeriesList.length} TV series.");
    }
    } catch (e, stacktrace) {
      _updateStatus(LoadingStatus.error, "Failed to load TV series data: $e");
      if (kDebugMode) {
        print("TV Series Loading Error: $e");
        print(stacktrace);
      }
      _animeseriesMap = {};
      _allAnimeSeriesList = [];
      _searchResults = [];
      _isInitialized = false;
    }
  }

  

  void searchAnime(String query) {
    _searchQuery = query.toLowerCase();
    if (_searchQuery.isEmpty) {
      _searchResults = _allAnimeSeriesList;
    } else {
      _searchResults = _allAnimeSeriesList.where((series) {
        // Adjust search logic based on available fields in TvSeries from CSV
        return series.name.toLowerCase().contains(_searchQuery) ||
            series.originalName.toLowerCase().contains(_searchQuery) ||
            series.overview.toLowerCase().contains(_searchQuery) ||
            series.genres.any((g) => g.toLowerCase().contains(_searchQuery)) ||
            series.keywords
                .any((k) => k.toLowerCase().contains(_searchQuery)) ||
            series.firstAirDate?.year.toString() ==
                _searchQuery || // Search by year
            series.tmdbId.toString() ==
                _searchQuery; // Allow searching by TMDB ID
      }).toList();
    }
  }

  TvSeriesAnime? getAnimeByTmdbId(int tmdbId) {
    return _animeseriesMap[tmdbId]; // Direct lookup is efficient
  }

  void _updateStatus(LoadingStatus newStatus, [String? message]) {
    _status = newStatus;
    _errorMessage = message;
    notifyListeners();
  }
}
class MovieProvider extends ChangeNotifier {
  // --- Singleton Implementation ---
  static final MovieProvider _instance = MovieProvider._internal();

  factory MovieProvider() {
    return _instance;
  }

  MovieProvider._internal() {
    // Private constructor that is called only once
    _initializeData();
  }

  List<Movie> _animeseriesForDisplay = [];
  List<Movie> _searchResults = [];
  LoadingStatus _status = LoadingStatus.notloaded;
  String? _errorMessage;
  String _searchQuery = '';
  bool _isInitialized = false;

  List<Movie> get animeseriesForDisplay => _searchQuery.isEmpty ? _animeseriesForDisplay : _searchResults;
  LoadingStatus get status => _status;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == LoadingStatus.loading;
  bool get hasError => _status == LoadingStatus.error;
  bool get isIdeling => _status == LoadingStatus.idle;
  bool get isLooaded => _status == LoadingStatus.loaded;
  String get searchQuery => _searchQuery;
  bool get isInitialized => _isInitialized;

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
    _searchQuery = '';
    _status = LoadingStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final rawData = await rootBundle.loadString('assets/movies_db.csv');
      List<List<dynamic>> csvTable =
          const CsvToListConverter().convert(rawData);

      // Make sure you are processing ALL rows, not just the first one.
      // If your CSV has a header row, you might need to skip it (e.g., .skip(1))
      final dataRows = csvTable.skip(1); // Example: Skip header row

      // Ensure the .map() processes all 'dataRows' and .toList() collects them all.
      _animeseriesForDisplay = dataRows.map((row) {
        // Replace with your actual Movie object creation based on CSV columns
        return Movie.fromCsvRow(row);
      }).toList(); // This should create a list of ALL movies from the CSV rows processed.

      _status = LoadingStatus.loaded;
      if (kDebugMode) {
        print("Successfully loaded ${_animeseriesForDisplay.length} movies from CSV.");
      }
    } catch (e, stacktrace) {
      _status = LoadingStatus.error;
      _errorMessage = "Failed to load or parse CSV: $e";
      if (kDebugMode) {
        print("CSV Loading Error: $e");
        print(stacktrace);
      }
      _animeseriesForDisplay = []; // Clear movies on error
    } finally {
      _searchResults = _animeseriesForDisplay; // Initialize search results
      notifyListeners();
    }
  }

  void searchMovies(String? query) {
    _searchQuery = query?.toLowerCase().trim() ?? '';
    if (_searchQuery.isEmpty) {
      _searchResults = _animeseriesForDisplay; // Show all if query is empty
    } else {
      _searchResults = _animeseriesForDisplay.where((movie) {
        // Search logic: check title, original title, overview, genres, keywords
        // Add more fields as needed (actors would require parsing 'cast' if available)
        return movie.title.toLowerCase().contains(_searchQuery) ||
            movie.originalTitle.toLowerCase().contains(_searchQuery) ||
            movie.overview.toLowerCase().contains(_searchQuery) ||
            movie.genres.any((g) => g.toLowerCase().contains(_searchQuery)) ||
            movie.keywords.any((k) => k.toLowerCase().contains(_searchQuery)) ||
            movie.releaseDate?.year.toString() ==
                _searchQuery; // Allow searching by year
      }).toList();
    }
  }

  // Function to get a movie by its ID (useful for detail pages)
  Movie? getMovieById(int id) {
    try {
      return _animeseriesForDisplay.firstWhere((movie) => movie.id == id);
    } catch (e) {
      return null; // Not found
    }
  }

  @override
  notifyListeners();
}
class TvSeriesProvider extends ChangeNotifier {
  // --- Constants ---
  static const String _tvSeriesDetailPath = 'assets/tv_series_details.csv';
  static const String _episodetvsCsvPath = 'assets/tv_series_link.csv';

  static final TvSeriesProvider _instance = TvSeriesProvider._internal();

  factory TvSeriesProvider() {
    return _instance;
  }

  TvSeriesProvider._internal() {
    // Private constructor that is called only once
    _initializeData();
  }

  // --- Constants ---

  // --- Private State ---
  Map<int, TvSeriesAnime> _animeseriesMap =
      {}; // Keyed by TMDB ID for efficient lookup
  List<TvSeriesAnime> _allAnimeSeriesList = []; // Sorted list for display
  List<TvSeriesAnime> _searchResults = [];
  LoadingStatus _status = LoadingStatus.notloaded;
  String? _errorMessage;
  String _searchQuery = '';
  bool _isInitialized = false;

  // --- Public Getters ---
  List<TvSeriesAnime> get animeseriesForDisplay =>
      _searchQuery.isEmpty ? _allAnimeSeriesList : _searchResults;
  LoadingStatus get status => _status;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == LoadingStatus.loading;
  bool get hasError => _status == LoadingStatus.error;
  String get searchQuery => _searchQuery;
  bool get isInitialized => _isInitialized;

  // Initialize data only once
  Future<void> _initializeData() async {
    if (!_isInitialized) {
      await loadAnimeData();
      _isInitialized = true;
    }
  }

  // Ensure data is loaded before accessing
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

    _updateStatus(LoadingStatus.loading);
    _animeseriesMap.clear();
    _allAnimeSeriesList.clear();
    _searchResults.clear();

    try {
      // 1. Load Series Details CSV
      final detailsRawData = await rootBundle.loadString(_tvSeriesDetailPath);
      List<List<dynamic>> detailsCsvTable =
          const CsvToListConverter().convert(detailsRawData);

      final Map<int, TvSeriesAnime> tempAnimeSeriesMap = {};
      // Using a temporary map to store series names -> tmdb_id for linking episodes later
      final Map<String, int> animeseriesnameToTmdbidMap = {};

      for (final row in detailsCsvTable.skip(1)) {
        // Skip header row
        try {
          final animeseries = TvSeriesAnime.fromCsvRow(row);
          if (animeseries.tmdbId != 0) {
            // Use TMDB ID as the primary key
            tempAnimeSeriesMap[animeseries.tmdbId] = animeseries;
            // Store the mapping: case-insensitive name from details CSV to its TMDB ID
            animeseriesnameToTmdbidMap[animeseries.originalName.toLowerCase()] =
                animeseries.tmdbId;
            // Also map the potentially different 'series' name if it exists and differs
            if (row.length > 1 &&
                row[1] != null &&
                row[1].toString().toLowerCase() !=
                    animeseries.originalName.trim().toLowerCase()) {
              animeseriesnameToTmdbidMap[row[1].toString().toLowerCase()] =
                  animeseries.tmdbId;
            }
          } else {
            if (kDebugMode) {
              print(
                  "Skipping series due to missing or invalid TMDB ID in row: $row");
            }
          }
        } catch (e, stacktrace) {
          if (kDebugMode) {
            print("Error parsing TV Series details row: $row -> $e");
            print(stacktrace);
          }
          // Decide if you want to stop loading or just skip the row
        }
      }

      if (kDebugMode) {
        print(
            "Loaded ${tempAnimeSeriesMap.length} series details. Name mapping count: ${animeseriesnameToTmdbidMap.length}");
      }

      // 2. Load Episodes CSV
      final episodesRawData = await rootBundle.loadString(_episodetvsCsvPath);
      List<List<dynamic>> episodesCsvTable =
          const CsvToListConverter().convert(episodesRawData);

      // Group episodes temporarily by TMDB ID
      final Map<int, List<Episode>> tempEpisodesByTmdbId = {};

      for (final row in episodesCsvTable.skip(1)) {
        // Skip header row
        if (row.isNotEmpty && row[0] != null) {
          final String animeseriesNameFromEpisodeCsv = row[0].toString();
          final String animeseriesNameLower =
              animeseriesNameFromEpisodeCsv.toLowerCase();

          // *** IMPORTANT JOIN LOGIC ***
          // Attempt to find the TMDB ID using the name from the episode CSV
          int? targetTmdbId = animeseriesnameToTmdbidMap[animeseriesNameLower];

          if (targetTmdbId != null) {
            try {
              final episode = Episode.fromCsvInfo(animeseriesNameFromEpisodeCsv,
                  targetTmdbId, row); // Pass targetTmdbId
              if (!tempEpisodesByTmdbId.containsKey(targetTmdbId)) {
                tempEpisodesByTmdbId[targetTmdbId] = [];
              }
              tempEpisodesByTmdbId[targetTmdbId]!.add(episode);
            } catch (e) {
              if (kDebugMode) {
                print(
                    "Error parsing episode from row for series '$animeseriesNameFromEpisodeCsv' (mapped to $targetTmdbId): $row -> $e");
              }
            }
          } else {
            // If the name wasn't found in the map
            if (kDebugMode) {
              // This indicates a mismatch or missing series in the details CSV
              print(
                  "Warning: Could not find matching TMDB ID for series name '$animeseriesNameFromEpisodeCsv' from episodes CSV.");
              // Optionally, try a fallback or log more prominently
            }
          }
        }
      }

      if (kDebugMode) {
        print("Processed episodes for ${tempEpisodesByTmdbId.length} series.");
      }

      // 3. Combine Details and Episodes
      for (final tmdbId in tempAnimeSeriesMap.keys) {
        final baseSeries = tempAnimeSeriesMap[tmdbId]!;
        final csvEpisodes =
            tempEpisodesByTmdbId[tmdbId] ?? []; // Get episodes for this TMDB ID

        // Sort episodes by season and episode number
        csvEpisodes.sort((a, b) {
          if (a.seasonNumber != b.seasonNumber) {
            return a.seasonNumber.compareTo(b.seasonNumber);
          }
          return a.episodeNumber.compareTo(b.episodeNumber);
        });

        // Group episodes by season number
        Map<int, List<Episode>> episodesBySeason = {};
        for (var episode in csvEpisodes) {
          if (!episodesBySeason.containsKey(episode.seasonNumber)) {
            episodesBySeason[episode.seasonNumber] = [];
          }
          episodesBySeason[episode.seasonNumber]!.add(episode);
        }

        // Create Season objects and sort them
        List<Season> seasons = episodesBySeason.entries
            .map((entry) => Season(
                  seasonNumber: entry.key,
                  episodes: entry.value,
                ))
            .toList()
          ..sort((a, b) => a.seasonNumber.compareTo(b.seasonNumber));

        // Create the final TvSeries object with combined data
        final finalSeries = baseSeries.copyWith(seasons: seasons);
        _animeseriesMap[tmdbId] = finalSeries; // Add to the final map
      }

      // Create the sorted list for display
      _allAnimeSeriesList = _animeseriesMap.values.toList()
        ..sort((a, b) => a.name
            .toLowerCase()
            .compareTo(b.name.toLowerCase())); // Case-insensitive sort

      _searchResults = _allAnimeSeriesList; // Initialize search results
      _updateStatus(LoadingStatus.loaded);
      _isInitialized = true;

      if (kDebugMode) {
        print(
            "Successfully loaded and combined data for ${_allAnimeSeriesList.length} TV series.");
      }
    } catch (e, stacktrace) {
      _updateStatus(LoadingStatus.error, "Failed to load TV series data: $e");
      if (kDebugMode) {
        print("TV Series Loading Error: $e");
        print(stacktrace);
      }
      _animeseriesMap = {};
      _allAnimeSeriesList = [];
      _searchResults = [];
      _isInitialized = false;
    }
  }

  void searchAnime(String query) {
    _searchQuery = query.toLowerCase();
    if (_searchQuery.isEmpty) {
      _searchResults = _allAnimeSeriesList;
    } else {
      _searchResults = _allAnimeSeriesList.where((series) {
        // Adjust search logic based on available fields in TvSeries from CSV
        return series.name.toLowerCase().contains(_searchQuery) ||
            series.originalName.toLowerCase().contains(_searchQuery) ||
            series.overview.toLowerCase().contains(_searchQuery) ||
            series.genres.any((g) => g.toLowerCase().contains(_searchQuery)) ||
            series.keywords
                .any((k) => k.toLowerCase().contains(_searchQuery)) ||
            series.firstAirDate?.year.toString() ==
                _searchQuery || // Search by year
            series.tmdbId.toString() ==
                _searchQuery; // Allow searching by TMDB ID
      }).toList();
    }
  }

  TvSeriesAnime? getAnimeByTmdbId(int tmdbId) {
    return _animeseriesMap[tmdbId]; // Direct lookup is efficient
  }

  void _updateStatus(LoadingStatus newStatus, [String? message]) {
    _status = newStatus;
    _errorMessage = message;
    notifyListeners();
  }
}
