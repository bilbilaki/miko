// lib/models/tv_series.dart
import 'package:flutter/foundation.dart';

import 'package:url_launcher/url_launcher.dart';

import '../showcases/model.dart' as TmdbApiMovieModel show Movie; // Import url_launcher

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
      String seriesNameFromCsv, int seriesTmdbId, List<dynamic> rowData) {
    // Helper to safely get data from row, returning null if index out of bounds or value is null/empty
    String? safeGetString(int index) {
      if (index >= 0 && index < rowData.length && rowData[index] != null) {
        final val = rowData[index].toString().trim();
        return val.isNotEmpty ? val : null;
      }
      return null;
    }

    String episodeId =
        safeGetString(1) ?? 'S00E00'; // Column 1: Episode Identifier
    String? url1080 = safeGetString(2)?.nullIfEmpty; // Column 2: 1080p
    String? url720 = safeGetString(3)?.nullIfEmpty; // Column 3: 720p
    String? url540 = safeGetString(4)?.nullIfEmpty; // Column 4: 540p
    String? url480 = safeGetString(5)?.nullIfEmpty; // Column 5: 480p
    String? dubbed = safeGetString(6)?.nullIfEmpty; // Column 6: Dubbed

    // Parse season and episode numbers from episodeId (format: S01E05)
    int seasonNum = 0;
    int episodeNum = 0;

    try {
      final match = RegExp(r'[Ss](\d+)[Ee](\d+)')
          .firstMatch(episodeId); // Case-insensitive S/E
      if (match != null && match.groupCount >= 2) {
        seasonNum = int.parse(match.group(1)!);
        episodeNum = int.parse(match.group(2)!);
      } else {
        if (kDebugMode) {
          print(
              "Could not parse S/E numbers from '$episodeId' for series '$seriesNameFromCsv'. Defaulting to S0/E0.");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(
            "Error parsing episode numbers from '$episodeId' for series '$seriesNameFromCsv': $e");
      }
      // Keep default S0/E0 on error
    }

    // Validate that we have at least S/E numbers, otherwise skip? Or maybe allow S0E0?
    // For now, we allow S0E0 from the parsing default/error.
    if (seasonNum == 0 && episodeNum == 0 && episodeId != 'S00E00') {
      // Log a warning if parsing failed but the ID wasn't literally S00E00
      if (kDebugMode) {
        print(
            "Warning: Episode identifier '$episodeId' for '$seriesNameFromCsv' parsed as S0E0.");
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
      print("CSV Parsing Error for value '$value' as type $T: $e");
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
  static const String _imageBaseUrl =
      'https://inosdb.worker-inosuke.workers.dev/w500';
  static const String _backdropBaseUrl =
      'https://inosdb.worker-inosuke.workers.dev/w780'; // Use a higher res for backdrop

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
    if (posterPath == null ||
        posterPath!.isEmpty ||
        posterPath == "nan" ||
        posterPath == "None") {
      return null;
    }
    final path = posterPath!.startsWith('/') ? posterPath! : '/$posterPath';
    return '$_imageBaseUrl$path';
  }

  // Helper to get the full backdrop URL
  String? get fullBackdropUrl {
    if (backdropPath == null ||
        backdropPath!.isEmpty ||
        backdropPath == "nan" ||
        backdropPath == "None") {
      return null;
    }
    final path =
        backdropPath!.startsWith('/') ? backdropPath! : '/$backdropPath';
    return '$_backdropBaseUrl$path'; // Use higher res backdrop url
  }

  // Factory constructor to create from CSV row data
  factory TvSeriesAnime.fromCsvRow(List<dynamic> row) {
    // Ensure row has enough columns to avoid RangeError
    dynamic safeGet(int index, [dynamic defaultValue]) {
      return (row.length > index && row[index] != null)
          ? row[index]
          : defaultValue;
    }

    DateTime? parsedDate = tryParseDate(safeGet(3)); // Column 3: release_date

    return TvSeriesAnime(
      tmdbId: tryParseInt(safeGet(0)) ??
          0, // Column 0: tmdb_id - Default to 0 if invalid
      name: safeGet(1)?.toString() ?? 'Unknown Series', // Column 1: series
      status: safeGet(2)?.toString() ?? 'Unknown', // Column 2: status
      firstAirDate: parsedDate, // Column 3: release_date
      runtime: tryParseInt(safeGet(4)), // Column 4: runtime
      overview: safeGet(5)?.toString() ?? '', // Column 5: overview
      voteAverage: tryParseDouble(safeGet(6)) ?? 0.0, // Column 6: vote_average
      voteCount: tryParseInt(safeGet(7)) ?? 0, // Column 7: vote_count
      genres: splitStringList(safeGet(8)), // Column 8: genres
      keywords: splitStringList(safeGet(9)), // Column 9: keywords
      originalName: safeGet(10)?.toString() ??
          'Unknown Original Name', // Column 10: original_name
      posterPath: safeGet(11)?.toString(), // Column 11: poster_path
      backdropPath: safeGet(12)?.toString(), // Column 12: backdrop_path
      popularity: tryParseDouble(safeGet(13)) ?? 0.0, // Column 13: popularity
      originalLanguage:
          safeGet(14)?.toString() ?? 'N/A', // Column 14: original_language
      type: safeGet(15)?.toString() ?? 'Unknown', // Column 15: type
      numberOfEpisodes:
          tryParseInt(safeGet(16)), // Column 16: number_of_episodes
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
    if (rawVideos == null ||
        rawVideos!.trim().isEmpty ||
        rawVideos!.toLowerCase() == 'nan') {
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
        if (kDebugMode) print("Could not parse video entry: $entry");
      }
    }
    return results;
  }

  Future<void> launchVideo(String key) async {
    final Uri youtubeUrl = Uri.parse('https://www.youtube.com/watch?v=$key');
    final Uri youtubeAppUrl =
        Uri.parse('youtube://www.youtube.com/watch?v=$key');
    try {
      if (await canLaunchUrl(youtubeAppUrl)) {
        await launchUrl(youtubeAppUrl, mode: LaunchMode.externalApplication);
      } else if (await canLaunchUrl(youtubeUrl)) {
        await launchUrl(youtubeUrl, mode: LaunchMode.externalApplication);
      } else {
        if (kDebugMode) print("Could not launch YouTube URL for key: $key");
      }
    } catch (e) {
      if (kDebugMode) print("Error launching url: $e");
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

  static const String imageBaseUrl =
      'https://inosdb.worker-inosuke.workers.dev/w500';

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
  factory Movie.fromTmdbResponseMovie(TmdbApiMovieModel.Movie tmdbMovie) {
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
      genres: tmdbMovie.genres?.map((g) => g.name).toList() ??
          [], // Convert Genre objects to List<String>
      productionCompanies:
          tmdbMovie.productionCompanies?.map((pc) => pc.name).toList() ?? [],
      productionCountries:
          tmdbMovie.productionCountries?.map((pc) => pc.name).toList() ?? [],
      spokenLanguages:
          tmdbMovie.spokenLanguages?.map((sl) => sl.englishName).toList() ?? [],
      // Keywords are often fetched separately or part of a different endpoint section in TMDB.
      // The TMDB Movie model provided doesn't have 'keywords' directly as a List<String>.
      // If the 'tmdbMovie.keywords' (if it exists in TmdbApiMovieModel.Movie) is a List<KeywordObject>, map names.
      // For now, defaulting to empty. You might need to fetch keywords separately for recommendations.
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
    const String backdropBaseUrl =
        'https://inosdb.worker-inosuke.workers.dev/w780';
    if (backdropPath == null ||
        backdropPath!.isEmpty ||
        backdropPath == "nan") {
      return null;
    }
    final path =
        backdropPath!.startsWith('/') ? backdropPath! : '/$backdropPath';
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
      if (value == null ||
          value.toString().isEmpty ||
          value.toString().toLowerCase() == 'nan') {
        return null;
      }
      try {
        return parser(value.toString());
      } catch (e) {
        if (kDebugMode) {
          print("CSV Parsing Error for value '$value': $e");
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
      if (value == null ||
          value.toString().isEmpty ||
          value.toString().toLowerCase() == 'nan') {
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
    if (rawVideos == null ||
        rawVideos!.trim().isEmpty ||
        rawVideos!.toLowerCase() == 'nan') {
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
        String key = parts
            .sublist(1)
            .join(':')
            .trim(); // Join back in case title had ':'
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
      releaseDate: map['release_date'] != null
          ? DateTime.parse(map['release_date'])
          : null,
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
  final Uri youtubeAppUrl =
      Uri.parse('youtube://www.youtube.com/watch?v=$key'); // For app intent

  try {
    // Try opening in app first (might need platform-specific checks or alternative packages for better integration)
    if (await canLaunchUrl(youtubeAppUrl)) {
      await launchUrl(youtubeAppUrl, mode: LaunchMode.externalApplication);
    }
    // Fallback to web browser
    else if (await canLaunchUrl(youtubeUrl)) {
      await launchUrl(youtubeUrl, mode: LaunchMode.externalApplication);
    } else {
      if (kDebugMode) print("Could not launch YouTube URL for key: $key");
      // Optionally show a message to the user
    }
  } catch (e) {
    if (kDebugMode) print("Error launching url: $e");
    // Optionally show a message to the user
  }
}

