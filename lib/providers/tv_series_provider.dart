// TODO Implement this library.// lib/providers/tv_series_provider.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import '../models/episode.dart';
import '../models/season.dart';
import '../models/tv_series.dart';



class TvSeriesProvider extends ChangeNotifier {
  // --- Constants ---
  static const String _seriesDetailsCsvPath = 'assets/tv_series_details.csv';
  static const String _episodesCsvPath = 'assets/tv_series_link.csv';

  // --- Private State ---
  Map<int, TvSeries> _seriesMap = {}; // Keyed by TMDB ID for efficient lookup
  List<TvSeries> _allSeriesList = []; // Sorted list for display
  List<TvSeries> _searchResults = [];
  LoadingStatus _status = LoadingStatus.notloaded;
  String? _errorMessage;
  String _searchQuery = '';

  // --- Public Getters ---
  List<TvSeries> get seriesForDisplay =>
      _searchQuery.isEmpty ? _allSeriesList : _searchResults;
  LoadingStatus get status => _status;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == LoadingStatus.loading;
  bool get hasError => _status == LoadingStatus.error;
  String get searchQuery => _searchQuery;

  TvSeriesProvider() {
    loadTvSeriesData();
  }

  Future<void> loadTvSeriesData() async {
    if (_status == LoadingStatus.loading ||
        _status == LoadingStatus.loaded ||
        _status == LoadingStatus.idle) return;

    _updateStatus(LoadingStatus.loading);
    _seriesMap.clear();
    _allSeriesList.clear();
    _searchResults.clear();

    try {
      // 1. Load Series Details CSV
      final detailsRawData = await rootBundle.loadString(_seriesDetailsCsvPath);
      List<List<dynamic>> detailsCsvTable =
          const CsvToListConverter().convert(detailsRawData);

      final Map<int, TvSeries> tempSeriesMap = {};
      // Using a temporary map to store series names -> tmdb_id for linking episodes later
      final Map<String, int> seriesnameToTmdbidMap = {};

      for (final row in detailsCsvTable.skip(1)) {
        // Skip header row
        try {
          final series = TvSeries.fromCsvRow(row);
          if (series.tmdbId != 0) {
            // Use TMDB ID as the primary key
            tempSeriesMap[series.tmdbId] = series;
            // Store the mapping: case-insensitive name from details CSV to its TMDB ID
            //      seriesnameToTmdbidMap[series.originalName.trim().toLowerCase()] = series.tmdbId;
            // Also map the potentially different 'series' name if it exists and differs

            seriesnameToTmdbidMap[row[1].toString().toLowerCase()] =
                series.tmdbId;
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
            "Loaded ${tempSeriesMap.length} series details. Name mapping count: ${seriesnameToTmdbidMap.length}");
      }

      // 2. Load Episodes CSV
      final episodesRawData = await rootBundle.loadString(_episodesCsvPath);
      List<List<dynamic>> episodesCsvTable =
          const CsvToListConverter().convert(episodesRawData);

      // Group episodes temporarily by TMDB ID
      final Map<int, List<Episode>> tempEpisodesByTmdbId = {};

      for (final row in episodesCsvTable.skip(1)) {
        // Skip header row
          final String seriesNameFromEpisodeCsv = row[0].toString();
          final String seriesNameLower = seriesNameFromEpisodeCsv.toLowerCase();

          // *** IMPORTANT JOIN LOGIC ***
          // Attempt to find the TMDB ID using the name from the episode CSV
          int? targetTmdbId = seriesnameToTmdbidMap[seriesNameLower];

          if (targetTmdbId != null) {
            try {
              final episode = Episode.fromCsvInfo(seriesNameFromEpisodeCsv,
                  targetTmdbId, row); // Pass targetTmdbId
              if (!tempEpisodesByTmdbId.containsKey(targetTmdbId)) {
                tempEpisodesByTmdbId[targetTmdbId] = [];
              }
              tempEpisodesByTmdbId[targetTmdbId]!.add(episode);
            } catch (e) {
              if (kDebugMode) {
                print(
                    "Error parsing episode from row for series '$seriesNameFromEpisodeCsv' (mapped to $targetTmdbId): $row -> $e");
              }
            }
          } 
      }

      if (kDebugMode) {
        print("Processed episodes for ${tempEpisodesByTmdbId.length} series.");
      }

      // 3. Combine Details and Episodes
      for (final tmdbId in tempSeriesMap.keys) {
        final baseSeries = tempSeriesMap[tmdbId]!;
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
        _seriesMap[tmdbId] = finalSeries; // Add to the final map
      }

      // Create the sorted list for display
      _allSeriesList = _seriesMap.values.toList()
        ..sort((a, b) => a.name
            .toLowerCase()
            .compareTo(b.name.toLowerCase())); // Case-insensitive sort

    //  _searchResults = _allSeriesList; // Initialize search results
      _updateStatus(LoadingStatus.loaded);

      if (kDebugMode) {
        print(
            "Successfully loaded and combined data for ${_allSeriesList.length} TV series.");
      }
    } catch (e, stacktrace) {
      _updateStatus(LoadingStatus.error, "Failed to load TV series data: $e");
      if (kDebugMode) {
        print("TV Series Loading Error: $e");
        print(stacktrace);
      }
      _seriesMap = {};
      _allSeriesList = [];
      _searchResults = [];
    }
  }

  void searchTvSeries(String query) {
    _searchQuery = query.toLowerCase();
    if (_searchQuery.isEmpty) {
      _searchResults = _allSeriesList;
    } else {
      _searchResults = _allSeriesList.where((series) {
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

  TvSeries? getTvSeriesByTmdbId(int tmdbId) {
    return _seriesMap[tmdbId]; // Direct lookup is efficient
  }

  void _updateStatus(LoadingStatus newStatus, [String? message]) {
    _status = newStatus;
    _errorMessage = message;
    notifyListeners();
  }
}
