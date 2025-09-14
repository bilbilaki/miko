import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';


import 'package:url_launcher/url_launcher.dart';
// Generated full Riverpod providers with all functionalities for the provided linked classes.
// The main provider will extend existing functionality

import 'package:flutter_riverpod/flutter_riverpod.dart';

// Assuming that the main provider is MovieProvider and TvSeriesProvider manage episodes as providers.
// This example provides an enhanced implementation of both movies and TV series classes.
//
// Main MovieProvider
final movieProvider = ChangeNotifierProvider<MovieProvider>((ref) {
  return MovieProvider();
});

// TVSeriesProvider with episodes also added as provider
final tvSeriesProvider = ChangeNotifierProvider<TvSeriesProvider>((ref) {
  return TvSeriesProvider();
});

// Individual Serializable Seializable Record Extension on TV Series Clip
final tvSeriesUnisqueseriesNameChangeNotifierProvider =
    ChangeNotifierProvider<TvSeriesProvider>((ref) {
      final val = TvSeriesProvider();

      return val;
    });
// AnimeProvider necessary to extend basic functionality
final animeProvider = ChangeNotifierProvider<AnimeProvider>((ref) {
  return AnimeProvider();
});
// Models (provided by user, copied for completeness)
enum LoadingStatus { idle, loading, loaded, error, notloaded }

class VideoInfo {
  final String title;
  final String key; // YouTube key
  final String type; // e.g., "Trailer", "Opening", "Clip"

  VideoInfo({required this.title, required this.key, required this.type});
}

/// Extension providing advanced filtering on TvSeriesAnime
extension TvSeriesAnimeFilter on TvSeriesAnime {
  /// Returns true if this series matches all provided criteria.
  bool matchesFilter({
    List<String>? genres,
    DateTime? startDate,
    DateTime? endDate,
    List<String>? languages,
    int? minRuntime,
    int? maxRuntime,
    double? minVoteAverage,
    double? maxVoteAverage,
  }) {
    // Filter by genres (any match)
    if (genres != null && genres.isNotEmpty) {
      final wanted = genres.map((g) => g.toLowerCase()).toSet();
      final have = this.genres.map((g) => g.toLowerCase()).toSet();
      if (!wanted.any((g) => have.contains(g))) return false;
    }
    // Filter by release date range
    if (startDate != null) {
      if (this.firstAirDate == null || this.firstAirDate!.isBefore(startDate)) return false;
    }
    if (endDate != null) {
      if (this.firstAirDate == null || this.firstAirDate!.isAfter(endDate)) return false;
    }
    // Filter by language
    if (languages != null && languages.isNotEmpty) {
      final langs = languages.map((l) => l.toLowerCase()).toSet();
      if (!langs.contains(this.originalLanguage.toLowerCase())) return false;
    }
    // Filter by runtime
    if (minRuntime != null) {
      if (this.runtime == null || this.runtime! < minRuntime) return false;
    }
    if (maxRuntime != null) {
      if (this.runtime == null || this.runtime! > maxRuntime) return false;
    }
    // Filter by vote average
    if (minVoteAverage != null && this.voteAverage < minVoteAverage) return false;
    if (maxVoteAverage != null && this.voteAverage > maxVoteAverage) return false;
    return true;
  }
}

class Season {
  final int seasonNumber;
  final List<Episode> episodes;

  Season({
    required this.seasonNumber,
    required this.episodes,
  }) {
    episodes.sort((a, b) => a.episodeNumber.compareTo(b.episodeNumber));
  }
  /// Serialize Season to JSON
  Map<String, dynamic> toJson() => {
        'seasonNumber': seasonNumber,
        'episodes': episodes.map((e) => e.toJson()).toList(),
      };
  /// Deserialize Season from JSON
  static Season fromJson(Map<String, dynamic> m) => Season(
        seasonNumber: m['seasonNumber'] as int,
        episodes: (m['episodes'] as List).map((e) => Episode.fromJson(e as Map<String, dynamic>)).toList(),
      );
}

class Episode {
  final String seriesNameCsv;
  final int seriesTmdbId;
  final String episodeIdentifier;
  final int seasonNumber;
  final int episodeNumber;
  final String? url1080p;
  final String? url720p;
  final String? url540p;
  final String? url480p;
  final String? dubbedUrl;

  Episode({
    required this.seriesNameCsv,
    required this.seriesTmdbId,
    required this.episodeIdentifier,
    required this.seasonNumber,
    required this.episodeNumber,
    this.url1080p,
    this.url720p,
    this.url540p,
    this.url480p,
    this.dubbedUrl,
  });

  // Helper to get available quality URLs (remains the same)
  Map<String, String> getAvailableQualityUrls() {
    final Map<String, String> urls = {};
    if (url1080p != null && url1080p!.isNotEmpty) urls['1080p'] = url1080p!;
    if (url720p != null && url720p!.isNotEmpty) urls['720p'] = url720p!;
    if (url540p != null && url540p!.isNotEmpty) urls['540p'] = url540p!;
    if (dubbedUrl != null && dubbedUrl!.isNotEmpty) urls['dubbed'] = dubbedUrl!;
    if (url480p != null && url480p!.isNotEmpty) urls['480p'] = url480p!;
    return urls;
  }

  // Factory to create from CSV row data (UPDATED indices based on example)
  // Now requires seriesTmdbId to be passed in
  factory Episode.fromCsvInfo(
    String seriesNameFromCsv,
    int seriesTmdbId,
    List<dynamic> rowData,
  ) {
    // Helper to safely get data from row, returning null if index out of bounds or value is null/empty
    String? safeGetString(int index) {
      if (index >= 0 && index < rowData.length && rowData[index] != null) {
        final val = rowData[index].toString().trim();
        return val.isNotEmpty ? val : null;
      }
      return null;
    }

    String episodeId = safeGetString(1) ?? 'S00E00'; // Column 1: Episode Identifier
    String? url1080 = safeGetString(2)?.nullIfEmpty; // Column 2: 1080p
    String? url720 = safeGetString(3)?.nullIfEmpty; // Column 3: 720p
    String? url540 = safeGetString(4)?.nullIfEmpty; // Column 4: 540p
    String? url480 = safeGetString(5)?.nullIfEmpty; // Column 5: 480p
    String? dubbed = safeGetString(6)?.nullIfEmpty; // Column 6: Dubbed

    // Parse season and episode numbers from episodeId (format: S01E05)
    int seasonNum = 0;
    int episodeNum = 0;

    try {
      final match = RegExp(r'[Ss](\d+)[Ee](\d+)').firstMatch(episodeId); // Case-insensitive S/E
      if (match != null && match.groupCount >= 2) {
        seasonNum = int.parse(match.group(1)!);
        episodeNum = int.parse(match.group(2)!);
      } else {
        if (kDebugMode) {
        //  print(
         //   "Could not parse S/E numbers from '$episodeId' for series '$seriesNameFromCsv'. Defaulting to S0/E0.",
         // );
        }
      }
    } catch (e) {
      if (kDebugMode) {
        //print(
        //  "Error parsing episode numbers from '$episodeId' for series '$seriesNameFromCsv': $e",
       // );
      }
      // Keep default S0/E0 on error
    }

    // Validate that we have at least S/E numbers, otherwise skip? Or maybe allow S0E0?
    // For now, we allow S0E0 from the parsing default/error.
    if (seasonNum == 0 && episodeNum == 0 && episodeId != 'S00E00') {
      // Log a warning if parsing failed but the ID wasn't literally S00E00
      if (kDebugMode) {
      //  print(
         // "Warning: Episode identifier '$episodeId' for '$seriesNameFromCsv' parsed as S0E0.",
        //);
      }
    }

    return Episode(
      seriesNameCsv: seriesNameFromCsv,
      seriesTmdbId: seriesTmdbId,
      episodeIdentifier: episodeId,
      seasonNumber: seasonNum,
      episodeNumber: episodeNum,
      url1080p: url1080,
      url720p: url720,
      url540p: url540,
      url480p: url480,
      dubbedUrl: dubbed,
    );
  }

  @override
  String toString() {
    return 'Episode(seriesCsv: $seriesNameCsv, tmdbId: $seriesTmdbId, id: $episodeIdentifier, S$seasonNumber E$episodeNumber, #Qualities: ${getAvailableQualityUrls().length})';
  }
  /// Serialize Episode to JSON
  Map<String, dynamic> toJson() => {
        'seriesNameCsv': seriesNameCsv,
        'seriesTmdbId': seriesTmdbId,
        'episodeIdentifier': episodeIdentifier,
        'seasonNumber': seasonNumber,
        'episodeNumber': episodeNumber,
        'url1080p': url1080p,
        'url720p': url720p,
        'url540p': url540p,
        'url480p': url480p,
        'dubbedUrl': dubbedUrl,
      };
  /// Deserialize Episode from JSON
  static Episode fromJson(Map<String, dynamic> m) => Episode(
        seriesNameCsv: m['seriesNameCsv'] as String,
        seriesTmdbId: m['seriesTmdbId'] as int,
        episodeIdentifier: m['episodeIdentifier'] as String,
        seasonNumber: m['seasonNumber'] as int,
        episodeNumber: m['episodeNumber'] as int,
        url1080p: m['url1080p'] as String?,
        url720p: m['url720p'] as String?,
        url540p: m['url540p'] as String?,
        url480p: m['url480p'] as String?,
        dubbedUrl: m['dubbedUrl'] as String?,
      );
}

// Helper function for safe parsing (can be moved to a utility file)
T? tryParse<T>(dynamic value, T Function(String) parser) {
  if (value == null ||
      value.toString().isEmpty ||
      value.toString().toLowerCase() == 'nan' ||
      value.toString().toLowerCase() == 'none') {
    return null;
  }
  try {
    // Handle potential double strings like "6.5" before parsing int
    if (T == int && value is String && value.contains('.')) {
      final doubleVal = double.tryParse(value);
      return doubleVal?.toInt() as T?;
    }
    return parser(value.toString().trim());
  } catch (e) {
    if (kDebugMode) {
     // print("CSV Parsing Error for value '$value' as type $T: $e");
    }
    return null;
  }
}

int? tryParseInt(dynamic value) => tryParse(value, int.parse);
double? tryParseDouble(dynamic value) => tryParse(value, double.parse);
DateTime? tryParseDate(dynamic value) => tryParse(value, DateTime.parse);
bool parseBool(dynamic value) {
  final lowerVal = value?.toString().toLowerCase();
  return lowerVal == 'true' || lowerVal == '1';
}

// Helper to split potentially complex string fields
List<String> splitStringList(dynamic value, {String separator = ','}) {
  if (value == null ||
      value.toString().isEmpty ||
      value.toString().toLowerCase() == 'nan' ||
      value.toString().toLowerCase() == 'none') {
    return [];
  }
  // Handles simple separator splitting, trims whitespace, removes empty strings
  return value
      .toString()
      .split(separator)
      .map((s) => s.trim())
      .where((s) => s.isNotEmpty)
      .toList();
}

class TvSeriesAnime {
  // --- Details primarily from CSV ---
  final int tmdbId; // Column 0: tmdb_id
  final String name; // Column 1: series (often used as display name)
  final String status; // Column 2: status
  final DateTime? firstAirDate; // Column 3: release_date (parsed)
  final int? runtime; // Column 4: runtime
  final String overview; // Column 5: overview
  final double voteAverage; // Column 6: vote_average
  final int voteCount; // Column 7: vote_count
  final List<String> genres; // Column 8: genres (comma-separated)
  final List<String> keywords; // Column 9: keywords (comma-separated)
  final String originalName; // Column 10: original_name
  final String? posterPath; // Column 11: poster_path
  final String? backdropPath; // Column 12: backdrop_path
  final double popularity; // Column 13: popularity
  final String originalLanguage; // Column 14: original_language
  final String type; // Column 15: type
  final int? numberOfEpisodes; // Column 16: number_of_episodes
  final int? numberOfSeasons; // Column 17: number_of_seasons
  final String? homepage; // Column 18: homepage
  // You might want to parse cast (19), crew (20), videos (21) if needed later
  final List<String> cast;
  final List<String> crew;
  final List<String> videos;
  final String? rawVideos;

  // --- Data structure for combined data ---
  final List<Season> seasons; // Populated by provider

  // --- Base URL for images (keep this) ---
  static const String _imageBaseUrl = 'https://db.inosuke.sbs/t/p/w500';
  static const String _backdropBaseUrl = 'https://db.inosuke.sbs/t/p/w780'; // Use a higher res for backdrop

  TvSeriesAnime({
    required this.tmdbId,
    required this.name,
    required this.status,
    this.firstAirDate,
    this.runtime,
    required this.overview,
    required this.voteAverage,
    required this.voteCount,
    required this.genres,
    required this.keywords,
    required this.originalName,
    this.posterPath,
    this.backdropPath,
    required this.popularity,
    required this.originalLanguage,
    required this.type,
    this.numberOfEpisodes,
    this.numberOfSeasons,
    this.homepage,
    required this.cast,
    required this.crew,
    required this.videos,
    required this.seasons,
    this.rawVideos, // Add to constructor
  });
  /// Serialize this instance to JSON
  Map<String, dynamic> toJson() => {
        'tmdbId': tmdbId,
        'name': name,
        'status': status,
        'firstAirDate': firstAirDate?.toIso8601String(),
        'runtime': runtime,
        'overview': overview,
        'voteAverage': voteAverage,
        'voteCount': voteCount,
        'genres': genres,
        'keywords': keywords,
        'originalName': originalName,
        'posterPath': posterPath,
        'backdropPath': backdropPath,
        'popularity': popularity,
        'originalLanguage': originalLanguage,
        'type': type,
        'numberOfEpisodes': numberOfEpisodes,
        'numberOfSeasons': numberOfSeasons,
        'homepage': homepage,
        'cast': cast,
        'crew': crew,
        'videos': videos,
        'rawVideos': rawVideos,
        'seasons': seasons.map((s) => s.toJson()).toList(),
      };
  /// Deserialize from JSON
  static TvSeriesAnime fromJson(Map<String, dynamic> m) => TvSeriesAnime(
        tmdbId: m['tmdbId'] as int,
        name: m['name'] as String,
        status: m['status'] as String,
        firstAirDate: m['firstAirDate'] != null ? DateTime.parse(m['firstAirDate'] as String) : null,
        runtime: m['runtime'] as int?,
        overview: m['overview'] as String,
        voteAverage: (m['voteAverage'] as num).toDouble(),
        voteCount: m['voteCount'] as int,
        genres: List<String>.from(m['genres'] as List<dynamic>),
        keywords: List<String>.from(m['keywords'] as List<dynamic>),
        originalName: m['originalName'] as String,
        posterPath: m['posterPath'] as String?,
        backdropPath: m['backdropPath'] as String?,
        popularity: (m['popularity'] as num).toDouble(),
        originalLanguage: m['originalLanguage'] as String,
        type: m['type'] as String,
        numberOfEpisodes: m['numberOfEpisodes'] as int?,
        numberOfSeasons: m['numberOfSeasons'] as int?,
        homepage: m['homepage'] as String?,
        cast: List<String>.from(m['cast'] as List<dynamic>),
        crew: List<String>.from(m['crew'] as List<dynamic>),
        videos: List<String>.from(m['videos'] as List<dynamic>),
        seasons: (m['seasons'] as List<dynamic>).map((e) => Season.fromJson(e as Map<String, dynamic>)).toList(),
        rawVideos: m['rawVideos'] as String?,
      );

  // Helper to get the full poster URL
  String? get fullPosterUrl {
    if (posterPath == null || posterPath!.isEmpty || posterPath == "nan" || posterPath == "None") {
      return null;
    }
    final path = posterPath!.startsWith('/') ? posterPath! : '/$posterPath';
    return '$_imageBaseUrl$path';
  }

  // Helper to get the full backdrop URL
  String? get fullBackdropUrl {
    if (backdropPath == null || backdropPath!.isEmpty || backdropPath == "nan" || backdropPath == "None") {
      return null;
    }
    final path = backdropPath!.startsWith('/') ? backdropPath! : '/$backdropPath';
    return '$_backdropBaseUrl$path'; // Use higher res backdrop url
  }

  // Factory constructor to create from CSV row data
  factory TvSeriesAnime.fromCsvRow(List<dynamic> row) {
    // Ensure row has enough columns to avoid RangeError
    dynamic safeGet(int index, [dynamic defaultValue]) {
      return (row.length > index && row[index] != null) ? row[index] : defaultValue;
    }

    DateTime? parsedDate = tryParseDate(safeGet(3)); // Column 3: release_date

    return TvSeriesAnime(
      tmdbId: tryParseInt(safeGet(0)) ?? 0, // Column 0: tmdb_id - Default to 0 if invalid
      name: safeGet(1)?.toString() ?? 'Unknown Series', // Column 1: series
      status: safeGet(2)?.toString() ?? 'Unknown', // Column 2: status
      firstAirDate: parsedDate, // Column 3: release_date
      runtime: tryParseInt(safeGet(4)), // Column 4: runtime
      overview: safeGet(5)?.toString() ?? '', // Column 5: overview
      voteAverage: tryParseDouble(safeGet(6)) ?? 0.0, // Column 6: vote_average
      voteCount: tryParseInt(safeGet(7)) ?? 0, // Column 7: vote_count
      genres: splitStringList(safeGet(8)), // Column 8: genres
      keywords: splitStringList(safeGet(9)), // Column 9: keywords
      originalName: safeGet(10)?.toString() ?? 'Unknown Original Name', // Column 10: original_name
      posterPath: safeGet(11)?.toString(), // Column 11: poster_path
      backdropPath: safeGet(12)?.toString(), // Column 12: backdrop_path
      popularity: tryParseDouble(safeGet(13)) ?? 0.0, // Column 13: popularity
      originalLanguage: safeGet(14)?.toString() ?? 'N/A', // Column 14: original_language
      type: safeGet(15)?.toString() ?? 'Unknown', // Column 15: type
      numberOfEpisodes: tryParseInt(safeGet(16)), // Column 16: number_of_episodes
      numberOfSeasons: tryParseInt(safeGet(17)), // Column 17: number_of_seasons
      homepage: safeGet(18)?.toString(), // Column 18: homepage
      cast: splitStringList(safeGet(19), separator: '|'), // Example if needed
      crew: splitStringList(safeGet(20), separator: '|'), // Example if needed
      videos: splitStringList(safeGet(21), separator: '|'), // Example if needed
      rawVideos: safeGet(21)?.toString(),
      seasons: [], // Initially empty, added by provider
    );
  }

  // Method to create a new TvSeries instance by adding seasons to an existing one
  TvSeriesAnime copyWith({
    List<Season>? seasons,
  }) {
    // Sort seasons by number before assigning
    final sortedSeasons = seasons ?? this.seasons;
    sortedSeasons.sort((a, b) => a.seasonNumber.compareTo(b.seasonNumber));

    return TvSeriesAnime(
      tmdbId: tmdbId,
      name: name,
      status: status,
      firstAirDate: firstAirDate,
      runtime: runtime,
      overview: overview,
      voteAverage: voteAverage,
      voteCount: voteCount,
      genres: genres,
      keywords: keywords,
      originalName: originalName,
      posterPath: posterPath,
      backdropPath: backdropPath,
      popularity: popularity,
      originalLanguage: originalLanguage,
      type: type,
      numberOfEpisodes: numberOfEpisodes,
      numberOfSeasons: numberOfSeasons,
      homepage: homepage,
      cast: cast,
      crew: crew,
      videos: videos,
      seasons: sortedSeasons, // Use the new or existing sorted list
    );
  }

  List<VideoInfo> parseVideoData() {
    final List<VideoInfo> results = [];
    if (rawVideos == null || rawVideos!.trim().isEmpty || rawVideos!.toLowerCase() == 'nan') {
      return results;
    }
    final entries = rawVideos!.split('|');
    for (String entry in entries) {
      entry = entry.trim();
      if (entry.isEmpty) continue;
      final parts = entry.split(':');
      if (parts.length >= 2) {
        String title = parts[0].trim();
        String key = parts.sublist(1).join(':').trim();
        String type = "Clip";
        if (title.toLowerCase().contains('trailer')) type = "Trailer";
        if (title.toLowerCase().contains('teaser')) type = "Teaser";
        if (title.toLowerCase().contains('opening')) type = "Opening";
        if (title.toLowerCase().contains('ending')) type = "Ending";

        if (key.isNotEmpty) {
          results.add(VideoInfo(title: title, key: key, type: type));
        }
      } else {
        if (kDebugMode){}// print("Could not parse video entry: $entry");
      }
    }
    return results;
  }

  Future<void> launchVideo(String key) async {
    final Uri youtubeUrl = Uri.parse('https://www.youtube.com/watch?v=$key');
    final Uri youtubeAppUrl = Uri.parse('youtube://www.youtube.com/watch?v=$key');
    try {
      if (await canLaunchUrl(youtubeAppUrl)) {
        await launchUrl(youtubeAppUrl, mode: LaunchMode.externalApplication);
      } else if (await canLaunchUrl(youtubeUrl)) {
        await launchUrl(youtubeUrl, mode: LaunchMode.externalApplication);
      } else {
        if (kDebugMode){}// print("Could not launch YouTube URL for key: $key");
      }
    } catch (e) {
      if (kDebugMode){}// print("Error launching url: $e");
    }
  }

  @override
  String toString() {
    return 'TvSeries(id: $tmdbId, name: $name, seasons: ${seasons.length})';
  }

  // Optional: Add Genre class if needed for JSON structure, but for CSV it's often just strings
  // Replace the `Genre.fromJson` calls if you were using a Genre class before
}

// If you were using a Genre class like this from TMDB:
class Genre {
  final int id; // May not be available from CSV
  final String name;

  Genre({required this.id, required this.name});

  // Keep this if you might merge with TMDB data later, otherwise remove
  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? 'Unknown Genre',
    );
  }
}
// If you only have genre names (strings) from the CSV, TvSeries can just store List<String> genres.
// Make sure the TvSeries class uses List<String> genres if you remove the Genre class.
// (The provided TvSeries.fromCsvRow already assumes List<String>)

// Add the helper extension if it's not globally available
extension StringExtension on String {
  String? get nullIfEmpty => isEmpty ? null : this;
}

class Movie {
  final int id;
  final String title;
  final double voteAverage;
  final int voteCount;
  final String status;
  final DateTime? releaseDate; // Make nullable
  final int revenue;
  final int? runtime; // Make nullable
  final bool adult;
  final String? backdropPath; // Make nullable
  final int budget;
  final String? homepage; // Make nullable
  final String? imdbId; // Make nullable
  final String originalLanguage;
  final String originalTitle;
  final String overview;
  final double popularity;
  final String? posterPath; // Make nullable
  final String? tagline; // Make nullable
  final List<String> genres;
  final List<String> productionCompanies;
  final List<String> productionCountries;
  final List<String> spokenLanguages;
  final List<String> keywords;
  final String? source; // Make nullable
  final String? rawDownloadLinks; // Store the raw string
  final String? rawVideos;

  static const String imageBaseUrl = 'https://db.inosuke.sbs/t/p/w500';

  Movie({
    required this.id,
    required this.title,
    required this.voteAverage,
    required this.voteCount,
    required this.status,
    this.releaseDate,
    required this.revenue,
    this.runtime,
    required this.adult,
    this.backdropPath,
    required this.budget,
    this.homepage,
    this.imdbId,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    this.posterPath,
    this.tagline,
    required this.genres,
    required this.productionCompanies,
    required this.productionCountries,
    required this.spokenLanguages,
    required this.keywords,
    this.source,
    this.rawDownloadLinks,
    this.rawVideos, // Make sure it's included
  });
  factory Movie.fromTmdbResponseMovie(dynamic tmdbMovie) { // Adjusted to accept dynamic for compatibility
    // Helper to parse DateTime, returning null on failure
    DateTime? parseTmdbDate(String? dateString) {
      if (dateString == null || dateString.isEmpty) return null;
      try {
        return DateTime.parse(dateString);
      } catch (e) {
        return null;
      }
    }

    return Movie(
      id: tmdbMovie.id,
      title: tmdbMovie.title,
      voteAverage: tmdbMovie.voteAverage,
      voteCount: tmdbMovie.voteCount,
      status: tmdbMovie.status ?? 'Unknown', // TMDB details might have status
      releaseDate: parseTmdbDate(tmdbMovie.releaseDate),
      revenue: tmdbMovie.revenue ?? 0,
      runtime: tmdbMovie.runtime,
      adult: tmdbMovie.adult,
      backdropPath: tmdbMovie.backdropPath,
      budget: tmdbMovie.budget ?? 0,
      homepage: tmdbMovie.homepage,
      imdbId: tmdbMovie.imdbId,
      originalLanguage: tmdbMovie.originalLanguage,
      originalTitle: tmdbMovie.originalTitle,
      overview: tmdbMovie.overview,
      popularity: tmdbMovie.popularity,
      posterPath: tmdbMovie.posterPath,
      tagline: tmdbMovie.tagline,
      genres: tmdbMovie.genres?.map((g) => g.name).toList() ?? [], // Convert Genre objects to List<String>
      productionCompanies: tmdbMovie.productionCompanies?.map((pc) => pc.name).toList() ?? [],
      productionCountries: tmdbMovie.productionCountries?.map((pc) => pc.name).toList() ?? [],
      spokenLanguages: tmdbMovie.spokenLanguages?.map((sl) => sl.englishName).toList() ?? [],
      keywords: [], // Placeholder - TMDB details often have keywords differently structured
      source: null, // Not available from TMDB general movie response
      rawDownloadLinks: null, // Not available from TMDB
      rawVideos: null, // Not available from TMDB
    );
  }

  String? getPosterUrl() {
    if (posterPath == null || posterPath!.isEmpty || posterPath == "nan") {
      return null;
    }
    // Handle potential leading slash if it's not already there in the base URL or path
    final path = posterPath!.startsWith('/') ? posterPath! : '/$posterPath';
    return imageBaseUrl + path;
  }

  String? getBackdropUrl() {
    // Use w780 or original for backdrops for better quality
    const String backdropBaseUrl = 'https://db.inosuke.sbs/t/p/w780';
    if (backdropPath == null || backdropPath!.isEmpty || backdropPath == "nan") {
      return null;
    }
    final path = backdropPath!.startsWith('/') ? backdropPath! : '/$backdropPath';
    return backdropBaseUrl + path;
  }

  // Helper to get a nicely formatted list of download links
  List<String> getDownloadLinksList() {
    if (rawDownloadLinks == null || rawDownloadLinks!.trim().isEmpty) {
      return [];
    }
    // Split by comma, trim whitespace, and filter out empty strings or non-http links
    return rawDownloadLinks!
        .split(',')
        .map((link) => link.trim())
        .where((link) => link.isNotEmpty && link.startsWith('http'))
        .toList();
  }

  // Factory constructor to create a Movie from a CSV row (List<dynamic>)
  factory Movie.fromCsvRow(List<dynamic> row) {
    // Helper function for safe parsing
    T? tryParse<T>(dynamic value, T Function(String) parser) {
      if (value == null || value.toString().isEmpty || value.toString().toLowerCase() == 'nan') {
        return null;
      }
      try {
        return parser(value.toString());
      } catch (e) {
        if (kDebugMode) {
         // print("CSV Parsing Error for value '$value': $e");
        }
        return null;
      }
    }

    int? tryParseInt(dynamic value) => tryParse(value, int.parse);
    double? tryParseDouble(dynamic value) => tryParse(value, double.parse);
    DateTime? tryParseDate(dynamic value) => tryParse(value, DateTime.parse);
    bool parseBool(dynamic value) => value.toString().toUpperCase() == 'TRUE';

    // Helper to split potentially complex string fields (like genres)
    List<String> splitStringList(dynamic value) {
      if (value == null || value.toString().isEmpty || value.toString().toLowerCase() == 'nan') {
        return [];
      }
      // Handles simple comma separation, might need adjustment
      // if format is more complex (e.g., JSON string within CSV)
      return value
          .toString()
          .split(',')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();
    }

    return Movie(
      id: tryParseInt(row[0]) ?? 0, // Default to 0 if parsing fails
      title: row[1]?.toString() ?? 'No Title',
      voteAverage: tryParseDouble(row[2]) ?? 0.0,
      voteCount: tryParseInt(row[3]) ?? 0,
      status: row[4]?.toString() ?? 'Unknown',
      releaseDate: tryParseDate(row[5]),
      revenue: tryParseInt(row[6]) ?? 0,
      runtime: tryParseInt(row[7]),
      adult: parseBool(row[8]),
      backdropPath: row[9]?.toString(),
      budget: tryParseInt(row[10]) ?? 0,
      homepage: row[11]?.toString(),
      imdbId: row[12]?.toString(),
      originalLanguage: row[13]?.toString() ?? 'N/A',
      originalTitle: row[14]?.toString() ?? 'No Original Title',
      overview: row[15]?.toString() ?? 'No Overview',
      popularity: tryParseDouble(row[16]) ?? 0.0,
      posterPath: row[17]?.toString(),
      tagline: row[18]?.toString(),
      // Assuming columns 19-23 are simple comma-separated strings
      genres: splitStringList(row[19]),
      productionCompanies: splitStringList(row[20]),
      productionCountries: splitStringList(row[21]),
      spokenLanguages: splitStringList(row[22]),
      keywords: splitStringList(row[23]),
      source: row[24]?.toString(),
      rawDownloadLinks: row[25]?.toString(), // Store the raw string
    );
  }
  List<VideoInfo> parseVideoData() {
    final List<VideoInfo> results = [];
    if (rawVideos == null || rawVideos!.trim().isEmpty || rawVideos!.toLowerCase() == 'nan') {
      return results;
    }

    // Example format: "Trailer: KEY1 | Opening Credits: KEY2 | Clip Name: KEY3"
    final entries = rawVideos!.split('|'); // Split entries by '|'

    for (String entry in entries) {
      entry = entry.trim();
      if (entry.isEmpty) continue;

      final parts = entry.split(':'); // Split title and key by ':'
      if (parts.length >= 2) {
        String title = parts[0].trim();
        String key = parts.sublist(1).join(':').trim(); // Join back in case title had ':'
        String type = "Clip"; // Default type

        // Basic type detection from title (customize as needed)
        if (title.toLowerCase().contains('trailer')) type = "Trailer";
        if (title.toLowerCase().contains('teaser')) type = "Teaser";
        if (title.toLowerCase().contains('opening')) type = "Opening";
        if (title.toLowerCase().contains('ending')) type = "Ending";

        if (key.isNotEmpty) {
          // Ensure key is not empty
          results.add(VideoInfo(title: title, key: key, type: type));
        }
      } else {
        // Maybe handle entries without ':' (e.g., just a key?)
        if (kDebugMode) print("Could not parse video entry: $entry");
      }
    }
    return results;
  }

  // Convert Movie object to Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id.toString(),
      'title': title,
      'release_date': releaseDate?.toIso8601String(),
      'overview': overview,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'vote_average': voteAverage,
      'vote_count': voteCount,
      'popularity': popularity,
      'genre_ids': genres.join(','),
      'original_language': originalLanguage,
      'video': false, // Default value since not in model
      'adult': adult ? 1 : 0, // SQLite doesn't have boolean type
    };
  }

  // Create Movie object from database Map
  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      id: int.parse(map['id']),
      title: map['title'],
      voteAverage: map['vote_average'],
      voteCount: map['vote_count'],
      status: map['status'], // Default value since not in database
      releaseDate: map['release_date'] != null ? DateTime.parse(map['release_date']) : null,
      revenue: 0, // Default value since not in database
      runtime: map['runtime'], // Default value since not in database
      adult: map['adult'] == 1,
      backdropPath: map['backdrop_path'],
      budget: map['budget'], // Default value since not in database
      homepage: map['homepage'], // Default value since not in database
      imdbId: map['imdb_id'], // Default value since not in database
      originalLanguage: map['original_language'],
      originalTitle: map['title'], // Using title as fallback
      overview: map['overview'],
      popularity: map['popularity'],
      posterPath: map['poster_path'],
      tagline: null, // Default value since not in database
      genres: map['genres']?.toString().split(',') ?? [],
      productionCompanies: [], // Default value since not in database
      productionCountries: [], // Default value since not in database
      spokenLanguages: [], // Default value since not in database
      keywords: map['keywords'], // Default value since not in database
      source: null, // Default value since not in database
      rawDownloadLinks: null, // Default value since not in database
    );
  }
}

Future<void> launchVideo(String key) async {
  final Uri youtubeUrl = Uri.parse('https://www.youtube.com/watch?v=$key');
  final Uri youtubeAppUrl = Uri.parse('youtube://www.youtube.com/watch?v=$key'); // For app intent

  try {
    // Try opening in app first (might need platform-specific checks or alternative packages for better integration)
    if (await canLaunchUrl(youtubeAppUrl)) {
      await launchUrl(youtubeAppUrl, mode: LaunchMode.externalApplication);
    }
    // Fallback to web browser
    else if (await canLaunchUrl(youtubeUrl)) {
      await launchUrl(youtubeUrl, mode: LaunchMode.externalApplication);
    } else {
      if (kDebugMode){}// print("Could not launch YouTube URL for key: $key");
      // Optionally show a message to the user
    }
  } catch (e) {
    if (kDebugMode){}// print("Error launching url: $e");
    // Optionally show a message to the user
  }
}

// --- Helper Extensions ---
extension DateTimeExtension on DateTime {
  /// Returns a DateTime representing the end of the day (23:59:59.999).
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999, 999);
}

// --- Central Filter State Model ---

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

// --- Abstract base class for common provider functionality (optional, but good for shared logic)
abstract class ContentProvider<T> extends ChangeNotifier {
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
    List<T> contentList,
    String currentSearchQuery,
    ContentFilterState currentFilters,
  ) {
    List<T> results = contentList.where((item) {
      // 1. Apply existing text search (if any)
      bool textMatch = true;
      if (currentSearchQuery.isNotEmpty) {
        if (item is TvSeriesAnime) {
          final sItem = item;
          textMatch = sItem.name.toLowerCase().contains(currentSearchQuery) ||
              sItem.originalName.toLowerCase().contains(currentSearchQuery) ||
              sItem.overview.toLowerCase().contains(currentSearchQuery) ||
              sItem.genres.any((g) => g.toLowerCase().contains(currentSearchQuery)) ||
              sItem.keywords.any((k) => k.toLowerCase().contains(currentSearchQuery)) ||
              sItem.firstAirDate?.year.toString() == currentSearchQuery ||
              sItem.tmdbId.toString() == currentSearchQuery;
        } else if (item is Movie) {
          final mItem = item;
          textMatch = mItem.title.toLowerCase().contains(currentSearchQuery) ||
              mItem.originalTitle.toLowerCase().contains(currentSearchQuery) ||
              mItem.overview.toLowerCase().contains(currentSearchQuery) ||
              mItem.genres.any((g) => g.toLowerCase().contains(currentSearchQuery)) ||
              mItem.keywords.any((k) => k.toLowerCase().contains(currentSearchQuery)) ||
              mItem.releaseDate?.year.toString() == currentSearchQuery;
        }
      }
      if (!textMatch) return false;

      // 2. Apply filters from ContentFilterState
      // Genres
      if (currentFilters.genres.isNotEmpty) {
        if (item is TvSeriesAnime && !item.genres.any((g) => currentFilters.genres.contains(g))) {
          return false;
        }
        if (item is Movie && !item.genres.any((g) => currentFilters.genres.contains(g))) {
          return false;
        }
      }
      // Languages
      if (currentFilters.languages.isNotEmpty) {
        if (item is TvSeriesAnime && !currentFilters.languages.contains(item.originalLanguage)) {
          return false;
        }
        if (item is Movie && !currentFilters.languages.contains(item.originalLanguage)) {
          return false;
        }
      }
      // Countries (Movie-specific)
      if (item is Movie && currentFilters.countries.isNotEmpty) {
        if (!item.productionCountries.any((c) => currentFilters.countries.contains(c))) {
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
        if (currentFilters.startDate != null && itemDate.isBefore(currentFilters.startDate!)) return false;
        if (currentFilters.endDate != null && itemDate.isAfter(currentFilters.endDate!.endOfDay)) return false;
      } else {
        // If itemDate is null but a date filter is applied, it doesn't match
        if (currentFilters.startDate != null || currentFilters.endDate != null) return false;
      }

      return true;
    }).toList();

    // 3. Apply sorting
    results.sort((a, b) {
      int compare = 0;
      switch (currentFilters.sortBy) {
        case SortBy.popularity:
          double popA = (a is Movie) ? (a).popularity : (a as TvSeriesAnime).popularity;
          double popB = (b is Movie) ? (b).popularity : (b as TvSeriesAnime).popularity;
          compare = popA.compareTo(popB);
          break;
        case SortBy.voteAverage:
          double voteA = (a is Movie) ? (a).voteAverage : (a as TvSeriesAnime).voteAverage;
          double voteB = (b is Movie) ? (b).voteAverage : (b as TvSeriesAnime).voteAverage;
          compare = voteA.compareTo(voteB);
          break;
        case SortBy.releaseDate:
          DateTime? dateA = (a is Movie) ? (a).releaseDate : (a as TvSeriesAnime).firstAirDate;
          DateTime? dateB = (b is Movie) ? (b).releaseDate : (b as TvSeriesAnime).firstAirDate;
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
          String nameA = (a is Movie) ? (a).title : (a as TvSeriesAnime).name;
          String nameB = (b is Movie) ? (b).title : (b as TvSeriesAnime).name;
          compare = nameA.toLowerCase().compareTo(nameB.toLowerCase());
          break;
        case SortBy.runtime:
          int? runtimeA = (a is Movie) ? (a).runtime : (a as TvSeriesAnime).runtime;
          int? runtimeB = (b is Movie) ? (b).runtime : (b as TvSeriesAnime).runtime;
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
int _currentPage = 0;
  int _perPage = 50; // Items per page (adjust for performance, e.g., 20-100)
  bool _isLoadingNextPage = false;
  bool get isLoadingNextPage => _isLoadingNextPage;
  bool get hasMorePages => (_currentPage + 1) * _perPage < _masterList.length;
  List<Movie> _visibleItems = [];
  List<Movie> get visibleItems => _visibleItems;

  Future<void> loadInitialPage() async {
    if (_masterList.isEmpty) await loadMovies(); // Ensure data is loaded
    _currentPage = 0;
    _visibleItems = _masterList.take(_perPage).toList();
    notifyListeners();
  }

  Future<void> loadNextPage() async {
    if (_isLoadingNextPage || !hasMorePages) return;
    _isLoadingNextPage = true;
    notifyListeners();
    await Future.delayed(
      const Duration(milliseconds: 100),
    ); // Simulate load delay (remove if not needed)
    _currentPage++;
    final start = _currentPage * _perPage;
    final end = start + _perPage;
    _visibleItems.addAll(
      _masterList.sublist(start, end.clamp(0, _masterList.length)),
    );
    _isLoadingNextPage = false;
    notifyListeners();
  }

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
    updateSearchQuery(''); // Reset search query on load
    _status = LoadingStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      String rawData = await rootBundle.loadString('assets/movies_db.csv');
      List<List<dynamic>> csvTable = const CsvToListConverter().convert(rawData);

      var dataRows = csvTable.skip(1);
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
    } catch (e) {
      _status = LoadingStatus.error;
      _errorMessage = "Failed to load or parse CSV: $e";
      if (kDebugMode) {
    //    print("CSV Loading Error (MovieProvider): $e");
    //    print(stacktrace);
      }
      _masterList = [];
    } finally {
      _updateFilteredAndSortedContent(); // Apply initial sort/filters
      notifyListeners();
    }
  }

  // Override searchMovies to use the new filtering logic
  void searchMovies(String? query) {
    updateSearchQuery(query ?? '');
  }

  @override
  void _updateFilteredAndSortedContent() {
    _searchResults = applyFilteringAndSorting(_masterList, searchQuery, activeFilters);
    notifyListeners();
  }

  Movie? getMovieById(int id) {
    try {
      return _masterList.firstWhere((movie) => movie.id == id);
    } catch (e) {
      return null;
    }
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
int _currentPage = 0;
  int _perPage = 50; // Items per page (adjust for performance, e.g., 20-100)
  bool _isLoadingNextPage = false;
  bool get isLoadingNextPage => _isLoadingNextPage;
  bool get hasMorePages => (_currentPage + 1) * _perPage < _masterList.length;
  List<TvSeriesAnime> _visibleItems = [];
  List<TvSeriesAnime> get visibleItems => _visibleItems;

  Future<void> loadInitialPage() async {
    if (_masterList.isEmpty) await loadAnimeData(); // Ensure data is loaded
    _currentPage = 0;
    _visibleItems = _masterList.take(_perPage).toList();
    notifyListeners();
  }

  Future<void> loadNextPage() async {
    if (_isLoadingNextPage || !hasMorePages) return;
    _isLoadingNextPage = true;
    notifyListeners();
    await Future.delayed(
      const Duration(milliseconds: 100),
    ); // Simulate load delay (remove if not needed)
    _currentPage++;
    final start = _currentPage * _perPage;
    final end = start + _perPage;
    _visibleItems.addAll(
      _masterList.sublist(start, end.clamp(0, _masterList.length)),
    );
    _isLoadingNextPage = false;
    notifyListeners();
  }
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

    updateSearchQuery(''); // Reset search query on load
    applyFiltersAndSort(ContentFilterState.initial()); // Reset filters on load
    _status = LoadingStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      // 1. Load Series Details CSV
      String detailsRawData = await rootBundle.loadString(_tvSeriesDetailPath);
      List<List<dynamic>> detailsCsvTable = const CsvToListConverter().convert(detailsRawData);

       Map<int, TvSeriesAnime> tempAnimeSeriesMap = {};
      // Using a temporary map to store series names -> tmdb_id for linking episodes later
       Map<String, int> animeseriesnameToTmdbidMap = {};

      for (final row in detailsCsvTable.skip(1)) {
        // Skip header row
        try {
          TvSeriesAnime animeseries = TvSeriesAnime.fromCsvRow(row);
          if (animeseries.tmdbId != 0) {
            // Use TMDB ID as the primary key
            tempAnimeSeriesMap[animeseries.tmdbId] = animeseries;
            // Store the mapping: case-insensitive name from details CSV to its TMDB ID
            animeseriesnameToTmdbidMap[animeseries.originalName.toLowerCase()] = animeseries.tmdbId;
            // Also map the potentially different 'series' name if it exists and differs
            if (row.length > 1 &&
                row[1] != null &&
                row[1].toString().toLowerCase() != animeseries.originalName.trim().toLowerCase()) {
              animeseriesnameToTmdbidMap[row[1].toString().toLowerCase()] = animeseries.tmdbId;
            }
          } else {
            if (kDebugMode) {
           //   print("Skipping series due to missing or invalid TMDB ID in row: $row");
            }
          }
        } catch (e) {
          if (kDebugMode) {
        //    print("Error parsing TV Series details row: $row -> $e");
         //   print(stacktrace);
          }
          // Decide if you want to stop loading or just skip the row
        }
      }

      if (kDebugMode) {
        print(
            "Loaded ${tempAnimeSeriesMap.length} series details. Name mapping count: ${animeseriesnameToTmdbidMap.length}");
      }

      // 2. Load Episodes CSV
      String episodesRawData = await rootBundle.loadString(_episodetvsCsvPath);
      List<List<dynamic>> episodesCsvTable = const CsvToListConverter().convert(episodesRawData);

      // Group episodes temporarily by TMDB ID
       Map<int, List<Episode>> tempEpisodesByTmdbId = {};

      for (final row in episodesCsvTable.skip(1)) {
        // Skip header row
        if (row.isNotEmpty && row[0] != null) {
           String animeseriesNameFromEpisodeCsv = row[0].toString();
           String animeseriesNameLower = animeseriesNameFromEpisodeCsv.toLowerCase();

          // *** IMPORTANT JOIN LOGIC ***
          // Attempt to find the TMDB ID using the name from the episode CSV
          int? targetTmdbId = animeseriesnameToTmdbidMap[animeseriesNameLower];

          if (targetTmdbId != null) {
            try {
              Episode episode = Episode.fromCsvInfo(animeseriesNameFromEpisodeCsv, targetTmdbId, row); // Pass targetTmdbId
              if (!tempEpisodesByTmdbId.containsKey(targetTmdbId)) {
                tempEpisodesByTmdbId[targetTmdbId] = [];
              }
              tempEpisodesByTmdbId[targetTmdbId]!.add(episode);
            } catch (e) {
              if (kDebugMode) {
              //  print(
                  //  "Error parsing episode from row for series '$animeseriesNameFromEpisodeCsv' (mapped to $targetTmdbId): $row -> $e");
              }
            }
          } else {
            // If the name wasn't found in the map
            if (kDebugMode) {
              // This indicates a mismatch or missing series in the details CSV
            //  print(
           //       "Warning: Could not find matching TMDB ID for series name '$animeseriesNameFromEpisodeCsv' from episodes CSV.");
              // Optionally, try a fallback or log more prominently
            }
          }
        }
      }

      if (kDebugMode) {
        print("Processed episodes for ${tempEpisodesByTmdbId.length} series.");
      }

      // 3. Combine Details and Episodes
      for (int tmdbId in tempAnimeSeriesMap.keys) {
        TvSeriesAnime baseSeries = tempAnimeSeriesMap[tmdbId]!;
        List<Episode> csvEpisodes = tempEpisodesByTmdbId[tmdbId] ?? []; // Get episodes for this TMDB ID

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
        TvSeriesAnime finalSeries = baseSeries.copyWith(seasons: seasons);
        _animeseriesMap[tmdbId] = finalSeries; // Add to the final map
      }

      // Create the sorted list for display
      _masterList = _animeseriesMap.values.toList()
        ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      _searchResults = _masterList; // Initialize search results

      // Collect all unique filter options
      _allAvailableGenres = _masterList.expand((series) => series.genres).toSet();
      _allAvailableLanguages = _masterList.map((series) => series.originalLanguage).toSet();

      if (kDebugMode) {
     //   print("Successfully loaded and combined data for ${_masterList.length} TV series.");
      }

      _status = LoadingStatus.loaded;
      _isInitialized = true;
    } catch (e) {
      _status = LoadingStatus.error;
      _errorMessage = "Failed to load TV series data: $e";
      if (kDebugMode) {
     //   print("TV Series Loading Error: $e");
      //  print(stacktrace);
      }
      _animeseriesMap = {};
      _masterList = [];
      _searchResults = [];
      _isInitialized = false;
    } finally {
      _updateFilteredAndSortedContent(); // Apply initial sort/filters
      notifyListeners();
    }
  }

  void searchAnime(String query) {
    updateSearchQuery(query);
  }

  TvSeriesAnime? getAnimeByTmdbId(int tmdbId) {
    return _animeseriesMap[tmdbId]; // Direct lookup is efficient
  }

  @override
  void _updateFilteredAndSortedContent() {
    _searchResults = applyFilteringAndSorting(_masterList, searchQuery, activeFilters);
    notifyListeners();
  }

  void updateStatus(LoadingStatus newStatus, [String? message]) {
    _status = newStatus;
    _errorMessage = message;
    notifyListeners();
  }
}

// --- Anime Provider Implementation (identical to TvSeriesProvider, minimal changes) ---
class AnimeProvider extends ContentProvider<TvSeriesAnime> {
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
  static const String _animeseriesDetailsCsvPath = 'assets/anime_series_details.csv';
  static const String _episodesCsvPath = 'assets/anime_series_link.csv';

  // --- Private State ---
  Map<int, TvSeriesAnime> _animeseriesMap = {}; // Keyed by TMDB ID for efficient lookup
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
int _currentPage = 0;
  int _perPage = 50; // Items per page (adjust for performance, e.g., 20-100)
  bool _isLoadingNextPage = false;
  bool get isLoadingNextPage => _isLoadingNextPage;
  bool get hasMorePages => (_currentPage + 1) * _perPage < _masterList.length;
  List<TvSeriesAnime> _visibleItems = [];
  List<TvSeriesAnime> get visibleItems => _visibleItems;

  Future<void> loadInitialPage() async {
    if (_masterList.isEmpty) await loadAnimeData(); // Ensure data is loaded
    _currentPage = 0;
    _visibleItems = _masterList.take(_perPage).toList();
    notifyListeners();
  }

  Future<void> loadNextPage() async {
    if (_isLoadingNextPage || !hasMorePages) return;
    _isLoadingNextPage = true;
    notifyListeners();
    await Future.delayed(
      const Duration(milliseconds: 100),
    ); // Simulate load delay (remove if not needed)
    _currentPage++;
    final start = _currentPage * _perPage;
    final end = start + _perPage;
    _visibleItems.addAll(
      _masterList.sublist(start, end.clamp(0, _masterList.length)),
    );
    _isLoadingNextPage = false;
    notifyListeners();
  }
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

    //updateSearchQuery(''); // Reset search query on load
    applyFiltersAndSort(ContentFilterState.initial()); // Reset filters on load
    _status = LoadingStatus.loading;
    _errorMessage = null;
    notifyListeners();

    // Attempt to load cached data to avoid reprocessing CSV on each launch
    // try {
    //   final dir = await getApplicationDocumentsDirectory();
    //   final cacheFile = File('${dir.path}/anime_cache.json');
    //   if (await cacheFile.exists()) {
    //     final content = await cacheFile.readAsString();
    //     final List<dynamic> jsonData = jsonDecode(content);
    //     for (var item in jsonData) {
    //       final series = TvSeriesAnime.fromJson(item as Map<String, dynamic>);
    //       _animeseriesMap[series.tmdbId] = series;
    //     }
    //     _masterList = _animeseriesMap.values.toList()
    //       ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    //     _searchResults = _masterList;

    //     // Collect all unique filter options from cache
    //     _allAvailableGenres = _masterList.expand((series) => series.genres).toSet();
    //     _allAvailableLanguages = _masterList.map((series) => series.originalLanguage).toSet();

    //     _status = LoadingStatus.loaded;
    //     _isInitialized = true;
    //     if (kDebugMode) print('Loaded anime data from cache.');
    //     _updateFilteredAndSortedContent();
    //     return;
    //   }
    // } catch (e) {
    //   if (kDebugMode) {}//print('Cache load failed, parsing CSV: $e');
    // }

    try {
      // 1. Load Series Details CSV
      String detailsRawData = await rootBundle.loadString(_animeseriesDetailsCsvPath);
      List<List<dynamic>> detailsCsvTable = const CsvToListConverter().convert(detailsRawData);

       Map<int, TvSeriesAnime> tempAnimeSeriesMap = {};
       Map<String, int> animeseriesnameToTmdbidMap = {};

      for (var row in detailsCsvTable.skip(1)) {
        try {
          TvSeriesAnime animeseries = TvSeriesAnime.fromCsvRow(row);
          if (animeseries.tmdbId != 0) {
            tempAnimeSeriesMap[animeseries.tmdbId] = animeseries;
            animeseriesnameToTmdbidMap[animeseries.originalName.toLowerCase()] = animeseries.tmdbId;
            if (row.length > 1 &&
                row[1] != null &&
                row[1].toString().toLowerCase() != animeseries.originalName.trim().toLowerCase()) {
              animeseriesnameToTmdbidMap[row[1].toString().toLowerCase()] = animeseries.tmdbId;
            }
          }
        } catch (e) {
          if (kDebugMode) {
          //  print("Error parsing TV Series details row: $row -> $e");
         //   print(stacktrace);
          }
        }
      }

      // 2. Load Episodes CSV
      String episodesRawData = await rootBundle.loadString(_episodesCsvPath);
      List<List<dynamic>> episodesCsvTable = const CsvToListConverter().convert(episodesRawData);

       Map<int, List<Episode>> tempEpisodesByTmdbId = {};

      for (var row in episodesCsvTable.skip(1)) {
        if (row.isNotEmpty && row[0] != null) {
           String animeseriesNameFromEpisodeCsv = row[0].toString();
           String animeseriesNameLower = animeseriesNameFromEpisodeCsv.toLowerCase();
          int? targetTmdbId = animeseriesnameToTmdbidMap[animeseriesNameLower];

          if (targetTmdbId != null) {
            try {
              final episode = Episode.fromCsvInfo(animeseriesNameFromEpisodeCsv, targetTmdbId, row);
              tempEpisodesByTmdbId.putIfAbsent(targetTmdbId, () => []).add(episode);
            } catch (e) {
              if (kDebugMode) {
               // print(
                 //   "Error parsing episode from row for series '$animeseriesNameFromEpisodeCsv' (mapped to $targetTmdbId): $row -> $e");
              }
            }
          } else {
            if (kDebugMode) {
             // print(
             //     "Warning: Could not find matching TMDB ID for series name '$animeseriesNameFromEpisodeCsv' from episodes CSV.");
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

      // Cache the combined data to avoid reprocessing CSV on next launch
      // try {
      //   final dir = await getApplicationDocumentsDirectory();
      //   final cacheFile = File('${dir.path}/anime_cache.json');
      //   final List<Map<String, dynamic>> jsonData = _masterList.map((s) => s.toJson()).toList();
      //   await cacheFile.writeAsString(jsonEncode(jsonData));
      //   if (kDebugMode){} //print('Cached anime data to ${cacheFile.path}');
      // } catch (e) {
      //   if (kDebugMode){  }// print('Failed to write anime cache: $e');
      // }

      _status = LoadingStatus.loaded;
      _isInitialized = true;
      if (kDebugMode) {
      //  print("Successfully loaded and combined data for ${_masterList.length} anime series.");
      }
    } catch (e) {
      _status = LoadingStatus.error;
      _errorMessage = "Failed to load anime data: $e";
      if (kDebugMode) {
     //   print("Anime Loading Error: $e");
     //   print(stacktrace);
      }
      _animeseriesMap = {};
      _masterList = [];
      _searchResults = [];
      _isInitialized = false;
    } finally {
      _updateFilteredAndSortedContent(); // Apply initial sort/filters
      notifyListeners();
    }
  }

  void searchAnime(String query) {
    updateSearchQuery(query);
  }

  @override
  void _updateFilteredAndSortedContent() {
    _searchResults = applyFilteringAndSorting(_masterList, searchQuery, activeFilters);
    notifyListeners();
  }

  TvSeriesAnime? getAnimeByTmdbId(int tmdbId) {
    return _animeseriesMap[tmdbId]; // Direct lookup is efficient
  }

  void updateStatus(LoadingStatus newStatus, [String? message]) {
    _status = newStatus;
    _errorMessage = message;
    notifyListeners();
  }
}