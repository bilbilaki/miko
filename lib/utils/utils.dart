import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:miko/showcases/model.dart' as TmdbApiModels;
import '../models/tv_series_anime.dart' as CsvModels;

void triggerVibration() {
    if (Platform.isAndroid) {
      HapticFeedback.lightImpact();
    }
  }
void tVheavy() {
    if (Platform.isAndroid) {
      HapticFeedback.heavyImpact();
    }
  }
void tVmedium() {
    if (Platform.isAndroid) {
      HapticFeedback.mediumImpact();
    }
  }
void tVClick() {
    if (Platform.isAndroid) {
      HapticFeedback.selectionClick();
    }
  }
// lib/converters/app_model_converters.dart


// IMPORTANT: For these imports to work correctly in your project,
// you must ensure your model classes are organized into distinct files
// to avoid name conflicts.
//
// Assuming your local/CSV-driven models are defined in:
// 'package:miko/models/tv_series.dart'
// This file should contain: CsvModels.TvSeriesAnime, CsvModels.Movie,
// CsvModels.Season, CsvModels.Episode, CsvModels.VideoInfo, CsvModels.Genre (simple).

// Assuming your TMDB API response models are defined in a separate file,
// for example: 'package:miko/models/tmdb_api_models.dart'
// This file should contain: TmdbApiModels.Movie (the second Movie def),
// TmdbApiModels.TvShow, TmdbApiModels.Season (the second Season def),
// TmdbApiModels.Episode (the second Episode def),
// TmdbApiModels.Genre (the second Genre def),
// TmdbApiModels.Person, TmdbApiModels.TVSearchResult, etc.
// NOTE: You will need to create 'tmdb_api_models.dart' and move the relevant TMDB
// response classes into it from your provided monolithic code block.

// --- Helper Functions (copied from your provided code for self-containment) ---
// These are included here to make the converter file as self-contained as possible.
// If you have these universally accessible elsewhere, you can remove them from here
// and import them instead.

extension StringExtension on String {
  String? get nullIfEmpty => isEmpty ? null : this;
}

T? _tryParse<T>(dynamic value, T Function(String) parser) {
  if (value == null ||
      value.toString().isEmpty ||
      value.toString().toLowerCase() == 'nan' ||
      value.toString().toLowerCase() == 'none') {
    return null;
  }
  try {
    if (T == int && value is String && value.contains('.')) {
      final doubleVal = double.tryParse(value);
      return doubleVal?.toInt() as T?;
    }
    return parser(value.toString().trim());
  } catch (e) {
    if (kDebugMode) {
      print("Conversion Helper Parsing Error for value '$value' as type $T: $e");
    }
    return null;
  }
}

int? _tryParseInt(dynamic value) => _tryParse(value, int.parse);
double? _tryParseDouble(dynamic value) => _tryParse(value, double.parse);
DateTime? _tryParseDate(dynamic value) => _tryParse(value, DateTime.parse);

List<String> _splitStringList(dynamic value, {String separator = ','}) {
  if (value == null ||
      value.toString().isEmpty ||
      value.toString().toLowerCase() == 'nan' ||
      value.toString().toLowerCase() == 'none') {
    return [];
  }
  return value
      .toString()
      .split(separator)
      .map((s) => s.trim())
      .where((s) => s.isNotEmpty)
      .toList();
}

// Utility for genre name to ID mapping based on your TvShow class's internal map
final Map<int, String> _tmdbGenreIdToNameMap = {
  10759: 'Action & Adventure',
  16: 'Animation',
  35: 'Comedy',
  80: 'Crime',
  99: 'Documentary',
  18: 'Drama',
  10751: 'Family',
  10762: 'Kids',
  9648: 'Mystery',
  10763: 'News',
  10764: 'Reality',
  10765: 'Sci-Fi & Fantasy',
  10766: 'Soap',
  10767: 'Talk',
  10768: 'War & Politics',
  37: 'Western',
  28: 'Action', // Common movie genres
  12: 'Adventure',
  14: 'Fantasy',
  36: 'History',
  27: 'Horror',
  10402: 'Music',
  10749: 'Romance',
  878: 'Science Fiction',
  53: 'Thriller',
  10752: 'War',
};

String getGenreNameFromId(int id) {
  return _tmdbGenreIdToNameMap[id] ?? 'Unknown Genre';
}

int getGenreIdFromName(String name) {
  final entry = _tmdbGenreIdToNameMap.entries.firstWhere(
    (e) => e.value.toLowerCase() == name.toLowerCase(),
    orElse: () => MapEntry(0, ''), // Default to 0 if not found
  );
  return entry.key;
}

/// A utility class for converting between different movie and TV show model representations
/// within your application. It handles models with the same name but different structures
/// by utilizing import aliases for clarity.
class AppModelConverters {
  // --- Movie Conversions (CsvModels.Movie <-> TmdbApiModels.Movie) ---

Future<TmdbApiModels.Movie?> toTmdbMovie(CsvModels.Movie? csvMovie) async {

  /// Converts a [CsvModels.Movie] (your local CSV-driven Movie) to a [TmdbApiModels.Movie] (TMDB API detailed Movie model).
  /// Fields not available in [CsvModels.Movie] will be null or assigned sensible defaults.
//  static TmdbApiModels.Movie? toTmdbMovie(CsvModels.Movie? csvMovie) {
    if (csvMovie == null) return null;
    return TmdbApiModels.Movie(
      adult: csvMovie.adult,
      backdropPath: csvMovie.backdropPath,
      genreIds: csvMovie.genres.map(getGenreIdFromName).toList(),
      genres: csvMovie.genres.map((name) => TmdbApiModels.Genre(id: getGenreIdFromName(name), name: name)).toList(),
      id: csvMovie.id,
      originalLanguage: csvMovie.originalLanguage,
      originalTitle: csvMovie.originalTitle,
      overview: csvMovie.overview,
      popularity: csvMovie.popularity,
      posterPath: csvMovie.posterPath,
      // Convert DateTime to ISO 8601 String
      releaseDate: csvMovie.releaseDate?.toIso8601String() ?? '',
      title: csvMovie.title,
      video: false, // Default: not explicitly available in CsvModels.Movie
      voteAverage: csvMovie.voteAverage,
      voteCount: csvMovie.voteCount,
      // Additional fields from TmdbApiModels.Movie that might not be in CsvModels.Movie
      belongsToCollection: null, // Not in CsvModels.Movie
      budget: csvMovie.budget,
      homepage: csvMovie.homepage,
      imdbId: csvMovie.imdbId,
      // Infer origin country from first production company's country if available
      originCountry: csvMovie.productionCountries.isNotEmpty ? [csvMovie.productionCountries.first] : null,
      // Convert List<String> to List<TmdbApiModels.ProductionCompany> with dummy IDs/countries
      productionCompanies: csvMovie.productionCompanies.map((name) => TmdbApiModels.ProductionCompany(id: 0, logoPath: null, name: name, originCountry: '')).toList(),
      // Convert List<String> to List<TmdbApiModels.ProductionCountry> with dummy ISO codes
      productionCountries: csvMovie.productionCountries.map((name) => TmdbApiModels.ProductionCountry(iso31661: '', name: name)).toList(),
      revenue: csvMovie.revenue,
      runtime: csvMovie.runtime,
      // Convert List<String> to List<TmdbApiModels.SpokenLanguage> with dummy ISO codes
      spokenLanguages: csvMovie.spokenLanguages.map((name) => TmdbApiModels.SpokenLanguage(englishName: name, iso6391: '', name: name)).toList(),
      status: csvMovie.status,
      tagline: csvMovie.tagline,
      // Convert List<String> to List<TmdbApiModels.Keyword> with dummy IDs
      keywords: csvMovie.keywords.map((name) => TmdbApiModels.Keyword(id: 0, name: name)).toList(),
      hasDetails: true, // Assuming this conversion produces a detailed model
    );
  }

  /// Converts a [TmdbApiModels.Movie] (TMDB API detailed Movie model) to a [CsvModels.Movie] (your local CSV-driven Movie).
  /// Fields like raw download links are not available from the TMDB API model and will be null.
  static CsvModels.Movie? fromTmdbMovie(TmdbApiModels.Movie? tmdbMovie) {
    if (tmdbMovie == null) return null;
    return CsvModels.Movie(
      id: tmdbMovie.id,
      title: tmdbMovie.title,
      voteAverage: tmdbMovie.voteAverage,
      voteCount: tmdbMovie.voteCount,
      status: tmdbMovie.status ?? 'Unknown',
      // Convert String to DateTime
      releaseDate: _tryParseDate(tmdbMovie.releaseDate),
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
      // Convert TmdbApiModels.Genre objects to List<String> (genre names)
      genres: tmdbMovie.genres?.map((g) => g.name).toList() ?? [],
      productionCompanies: tmdbMovie.productionCompanies?.map((pc) => pc.name).toList() ?? [],
      productionCountries: tmdbMovie.productionCountries?.map((pc) => pc.name).toList() ?? [],
      spokenLanguages: tmdbMovie.spokenLanguages?.map((sl) => sl.englishName).toList() ?? [],
      keywords: tmdbMovie.keywords?.map((k) => k.name).toList() ?? [], // Ensure keywords are handled, added null check as TMDB may omit
      source: null, // Not applicable from TMDB API
      rawDownloadLinks: null, // Not applicable from TMDB API
      rawVideos: null, // Not applicable from TMDB API
    );
  }

  // --- TV Series Conversions (CsvModels.TvSeriesAnime <-> TmdbApiModels.TvShow) ---
Future<TmdbApiModels.TvShow?> toTmdbTvSeries(CsvModels.TvSeriesAnime? csvTvSeries) async {

  /// Converts a [CsvModels.TvSeriesAnime] (your local CSV-driven TV Series) to a [TmdbApiModels.TvShow] (TMDB API detailed TvShow model).
  /// Season and Episode data are also converted with synthetic IDs if original IDs are missing.
 // static TmdbApiModels.TvShow? toTmdbTvShow(CsvModels.TvSeriesAnime? csvTvSeries) {
    if (csvTvSeries == null) return null;

    final List<TmdbApiModels.Season> tmdbSeasons = csvTvSeries.seasons.map((csvSeason) {
      final List<TmdbApiModels.Episode> tmdbEpisodes = csvSeason.episodes.map((csvEpisode) {
        return TmdbApiModels.Episode(
          id: csvEpisode.episodeIdentifier.hashCode, // Synthetic ID for episodes from CSV
          name: 'Episode ${csvEpisode.episodeNumber}',
          overview: 'No overview from local CSV.',
          voteAverage: 0.0,
          voteCount: 0,
          airDate: null,
          episodeNumber: csvEpisode.episodeNumber,
          episodeType: 'standard', // Default type
          productionCode: null,
          runtime: null,
          seasonNumber: csvEpisode.seasonNumber,
          showId: csvTvSeries.tmdbId, // Link back to the show ID
          stillPath: null,
      //    crew: [], // Not available in CSV
        //  guestStars: [], // Not available in CSV
        );
      }).toList();

      return TmdbApiModels.Season(
        airDate: null, // Not directly available in CSV Season
        episodeCount: csvSeason.episodes.length,
        id: csvSeason.seasonNumber.hashCode, // Synthetic ID for seasons
        name: 'Season ${csvSeason.seasonNumber}',
        overview: 'No overview available from local CSV.',
        posterPath: null, // Not available in CSV Season
        seasonNumber: csvSeason.seasonNumber,
        voteAverage: 0.0, // Not available
     //   episodes: tmdbEpisodes,
      );
    }).toList();

    return TmdbApiModels.TvShow(
      adult: false, // Default: not explicitly in CsvModels.TvSeriesAnime
      backdropPath: csvTvSeries.backdropPath,
      genreIds: csvTvSeries.genres.map(getGenreIdFromName).toList(),
      genres: csvTvSeries.genres.map((name) => TmdbApiModels.Genre(id: getGenreIdFromName(name), name: name)).toList(),
      id: csvTvSeries.tmdbId,
      originCountry: csvTvSeries.originalLanguage.isNotEmpty ? [csvTvSeries.originalLanguage] : [],
      originalLanguage: csvTvSeries.originalLanguage,
      originalName: csvTvSeries.originalName,
      overview: csvTvSeries.overview,
      popularity: csvTvSeries.popularity,
      posterPath: csvTvSeries.posterPath,
      firstAirDate: csvTvSeries.firstAirDate?.toIso8601String(),
      lastAirDate: null, // Not available directly in CsvModels.TvSeriesAnime
      name: csvTvSeries.name,
      voteAverage: csvTvSeries.voteAverage,
      voteCount: csvTvSeries.voteCount,
      createdBy: [], // Not available in CSV
      episodeRunTime: csvTvSeries.runtime != null ? [csvTvSeries.runtime!] : [], // Propagate runtime if available
      homepage: csvTvSeries.homepage,
      inProduction: csvTvSeries.status.toLowerCase().contains('airing'), // Heuristic guess
      languages: csvTvSeries.originalLanguage.isNotEmpty ? [csvTvSeries.originalLanguage] : [],
      lastEpisodeToAir: null, // Not available directly
      nextEpisodeToAir: null, // Not available directly
      networks: [], // Not available in CSV
      numberOfEpisodes: csvTvSeries.numberOfEpisodes,
      numberOfSeasons: csvTvSeries.numberOfSeasons,
      productionCompanies: [], // Not available in CSV
      productionCountries: [], // Not available in CSV
      seasons: tmdbSeasons,
      spokenLanguages: csvTvSeries.originalLanguage.isNotEmpty ? [TmdbApiModels.SpokenLanguage(englishName: csvTvSeries.originalLanguage, iso6391: '', name: csvTvSeries.originalLanguage)] : [],
      status: csvTvSeries.status,
      tagline: null, // Not available in CSV
      type: csvTvSeries.type,
    );
  }

  /// Converts a [TmdbApiModels.TvShow] (TMDB API detailed TvShow model) to a [CsvModels.TvSeriesAnime] (your local CSV-driven TV Series).
  /// Note: Detailed episode URLs available in [CsvModels.Episode] will be null from this conversion.
  static CsvModels.TvSeriesAnime? fromTmdbTvShow(TmdbApiModels.TvShow? tmdbTvShow) {
    if (tmdbTvShow == null) return null;

    final List<CsvModels.Season> csvSeasons = tmdbTvShow.seasons?.map((tmdbSeason) {
      final List<Object> csvEpisodes = [tmdbSeason.episodeCount].toList();
      return CsvModels.Season(
        seasonNumber: tmdbSeason.seasonNumber,
        episodes: csvEpisodes as List<CsvModels.Episode>,
      );
    }).toList() ?? [];

    return CsvModels.TvSeriesAnime(
      tmdbId: tmdbTvShow.id,
      name: tmdbTvShow.name,
      status: tmdbTvShow.status ?? 'Unknown',
      firstAirDate: _tryParseDate(tmdbTvShow.firstAirDate),
      runtime: tmdbTvShow.episodeRunTime?.isNotEmpty == true ? tmdbTvShow.episodeRunTime!.first : null,
      overview: tmdbTvShow.overview,
      voteAverage: tmdbTvShow.voteAverage,
      voteCount: tmdbTvShow.voteCount,
      genres: tmdbTvShow.genres?.map((g) => g.name).toList() ?? [], // Convert TmdbApiModels.Genre objects to List<String>
     // keywords: List<tmdbTvShow.tagline>.isNotEmpty ? tmdbTvShow.tagline?.split(',') : [] , // Assuming TvShow details include keywords. Added null check.
      originalName: tmdbTvShow.originalName,
      posterPath: tmdbTvShow.posterPath,
      backdropPath: tmdbTvShow.backdropPath,
      popularity: tmdbTvShow.popularity,
      originalLanguage: tmdbTvShow.originalLanguage,
      type: tmdbTvShow.type ?? 'TV Series',
      numberOfEpisodes: tmdbTvShow.numberOfEpisodes,
      numberOfSeasons: tmdbTvShow.numberOfSeasons,
      homepage: tmdbTvShow.homepage,
      cast: tmdbTvShow.createdBy?.map((c) => c.name).toList() ?? [], // Using createdBy as a proxy for 'cast'
      crew: [], // Not available directly from main TvShow model
      videos: [], // Cannot directly map from TmdbApiModels.TvShow main model
      seasons: csvSeasons,
      rawVideos: null, keywords: [], // Not available
    );
  }

  // --- Episode Conversions (CsvModels.Episode <-> TmdbApiModels.Episode) ---

  /// Converts a [CsvModels.Episode] to a [TmdbApiModels.Episode].
  /// Requires the parent show's ID.
  static TmdbApiModels.Episode? toTmdbEpisode(CsvModels.Episode? csvEpisode, int showId) {
    if (csvEpisode == null) return null;
    return TmdbApiModels.Episode(
      id: csvEpisode.episodeIdentifier.hashCode, // Use a hash as a synthetic ID
      name: 'Episode ${csvEpisode.episodeNumber}',
      overview: 'No overview available from CSV episode data.',
      voteAverage: 0.0, // Not available in CSV
      voteCount: 0, // Not available in CSV
      airDate: null, // Not available in CSV
      episodeNumber: csvEpisode.episodeNumber,
      episodeType: 'standard', // Default type
      productionCode: null,
      runtime: null, // Not available in CSV
      seasonNumber: csvEpisode.seasonNumber,
      showId: showId, // Parent show ID is required
      stillPath: null, // Not available in CSV
     // crew: [], // Not available in CSV
     // guestStars: [], // Not available in CSV
    );
  }

  /// Converts a [TmdbApiModels.Episode] to a [CsvModels.Episode].
  /// Requires parent series name and TMDB ID for the CsvModels.Episode structure.
  static CsvModels.Episode? fromTmdbEpisode(TmdbApiModels.Episode? tmdbEpisode, String seriesNameCsv, int seriesTmdbId) {
    if (tmdbEpisode == null) return null;
    return CsvModels.Episode(
      seriesNameCsv: seriesNameCsv,
      seriesTmdbId: seriesTmdbId,
      episodeIdentifier: 'S${tmdbEpisode.seasonNumber}E${tmdbEpisode.episodeNumber}',
      seasonNumber: tmdbEpisode.seasonNumber,
      episodeNumber: tmdbEpisode.episodeNumber,
      url1080p: null, // TMDB episode doesn't have these URLs
      url720p: null,
      url540p: null,
      url480p: null,
      dubbedUrl: null,
    );
  }

  // --- Season Conversions (CsvModels.Season <-> TmdbApiModels.Season) ---

  /// Converts a [CsvModels.Season] to a [TmdbApiModels.Season].
  /// Requires parent show's ID and name for episode conversions.
  static TmdbApiModels.Season? toTmdbSeason(CsvModels.Season? csvSeason, int showId, String showName) {
    if (csvSeason == null) return null;
    return TmdbApiModels.Season(
      id: csvSeason.seasonNumber.hashCode, // Synthetic ID for season
      airDate: null, // Not available in CSV Season
      episodeCount: csvSeason.episodes.length,
      name: 'Season ${csvSeason.seasonNumber}',
      overview: 'No overview available from CSV season data.',
      posterPath: null, // Not available in CSV Season
      seasonNumber: csvSeason.seasonNumber,
      voteAverage: 0.0, // Not available in CSV
   //   episodes: csvSeason.episodes.map((e) => AppModelConverters.toTmdbEpisode(e, showId)!)
     //     .whereType<TmdbApiModels.Episode>()
       //   .toList(), // Recursively convert episodes
    );
  }

  // /// Converts a [TmdbApiModels.Season] to a [CsvModels.Season].
  // /// Requires parent series name and TMDB ID for episode conversions.
  // static CsvModels.Season? fromTmdbSeason(TmdbApiModels.Season? tmdbSeason, String seriesNameCsv, int seriesTmdbId) {
  //   if (tmdbSeason == null) return null;
  //   return CsvModels.Season(
  //     seasonNumber: tmdbSeason.seasonNumber,
  //     episodes: tmdbSeason.?.map((e) => AppModelConverters.fromTmdbEpisode(e, seriesNameCsv, seriesTmdbId)!)
  //         .whereType<CsvModels.Episode>()
  //         .toList() ?? [], // Recursively convert episodes
  //   );
  // }

  // --- Search Result Conversions ---

  /// Converts a [TmdbApiModels.Movie] (detailed) to a [TmdbApiModels.MultiSearchMovie] (search result).
  static TmdbApiModels.MultiSearchMovie? toMultiSearchMovie(TmdbApiModels.Movie? movie) {
    if (movie == null) return null;
    return TmdbApiModels.MultiSearchMovie(
      id: movie.id,
      name: movie.title, // MultiSearchMovie can have 'name' or 'title'
      originalName: movie.originalTitle,
      mediaType: TmdbApiModels.MediaType.movie,
      adult: movie.adult,
      popularity: movie.popularity,
      posterPath: movie.posterPath,
      backdropPath: movie.backdropPath,
      title: movie.title,
      // originalTitle: movie.originalTitle, // already mapped to originalName
      overview: movie.overview,
      releaseDate: movie.releaseDate,
      genreIds: movie.genreIds,
      voteAverage: movie.voteAverage,
      voteCount: movie.voteCount,
      video: movie.video,
      originalLanguage: movie.originalLanguage, originalTitle: movie.originalTitle,
    );
  }

  /// Converts a [TmdbApiModels.MultiSearchMovie] to a [TmdbApiModels.Movie] (detailed, with missing data).
  static TmdbApiModels.Movie? fromMultiSearchMovie(TmdbApiModels.MultiSearchMovie? multiMovie) {
    if (multiMovie == null) return null;
    return TmdbApiModels.Movie(
      adult: multiMovie.adult,
      backdropPath: multiMovie.backdropPath,
      genreIds: multiMovie.genreIds,
      // TmdbApiModels.Movie expects List<TmdbApiModels.Genre> but MultiSearch only has IDs
      // so this will be null, requiring a new fetch for genre names.
      genres: null,
      id: multiMovie.id,
      originalLanguage: multiMovie.originalLanguage ?? 'en',
      originalTitle: multiMovie.originalTitle,
      overview: multiMovie.overview ?? '',
      popularity: multiMovie.popularity,
      posterPath: multiMovie.posterPath,
      releaseDate: multiMovie.releaseDate ?? '',
      title: multiMovie.title,
      video: multiMovie.video,
      voteAverage: multiMovie.voteAverage,
      voteCount: multiMovie.voteCount,
      // Other detailed fields will be null/default as they are not in MultiSearchMovie
      belongsToCollection: null,
      budget: null,
      homepage: null,
      imdbId: null,
      originCountry: null,
      productionCompanies: null,
      productionCountries: null,
      revenue: null,
      runtime: null,
      spokenLanguages: null,
      status: null,
      tagline: null,
      keywords: [],
      hasDetails: false, // Indicates a partial conversion from a search result
    );
  }

  /// Converts a [TmdbApiModels.TvShow] (detailed) to a [TmdbApiModels.MultiSearchTV] (search result).
  static TmdbApiModels.MultiSearchTV? toMultiSearchTv(TmdbApiModels.TvShow? tvShow) {
    if (tvShow == null) return null;
    return TmdbApiModels.MultiSearchTV(
      id: tvShow.id,
      name: tvShow.name,
      originalName: tvShow.originalName,
      mediaType: TmdbApiModels.MediaType.tv,
      adult: tvShow.adult,
      popularity: tvShow.popularity,
      posterPath: tvShow.posterPath,
      backdropPath: tvShow.backdropPath,
      overview: tvShow.overview,
      firstAirDate: tvShow.firstAirDate,
      genreIds: tvShow.genreIds,
      voteAverage: tvShow.voteAverage,
      voteCount: tvShow.voteCount,
      originCountry: tvShow.originCountry,
      originalLanguage: tvShow.originalLanguage,
      // MultiSearchTV doesn't always have a video flag, default based on common patterns
      video: false,
    );
  }

  /// Converts a [TmdbApiModels.MultiSearchTV] to a [TmdbApiModels.TvShow] (detailed, with missing data).
  static TmdbApiModels.TvShow? fromMultiSearchTv(TmdbApiModels.MultiSearchTV? multiTv) {
    if (multiTv == null) return null;
    return TmdbApiModels.TvShow(
      adult: multiTv.adult,
      backdropPath: multiTv.backdropPath,
      genreIds: multiTv.genreIds,
      // TmdbApiModels.TvShow expects List<TmdbApiModels.Genre> but MultiSearch only has IDs
      genres: null,
      id: multiTv.id,
      originCountry: multiTv.originCountry,
      originalLanguage: multiTv.originalLanguage ?? 'en',
      originalName: multiTv.originalName,
      overview: multiTv.overview ?? '',
      popularity: multiTv.popularity,
      posterPath: multiTv.posterPath,
      firstAirDate: multiTv.firstAirDate,
      name: multiTv.name,
      voteAverage: multiTv.voteAverage,
      voteCount: multiTv.voteCount,
      // Other detailed fields will be null/default as they are not in MultiSearchTV
      createdBy: null,
      episodeRunTime: null,
      homepage: null,
      inProduction: null,
      languages: null,
      lastAirDate: null,
      lastEpisodeToAir: null,
      networks: null,
      nextEpisodeToAir: null,
      numberOfEpisodes: null,
      numberOfSeasons: null,
      productionCompanies: null,
      productionCountries: null,
      seasons: null,
      spokenLanguages: null,
      status: null,
      tagline: null,
      type: null,
   //   keywords: null,
    );
  }

  /// Converts a [TmdbApiModels.TvShow] (detailed) to a [TmdbApiModels.TVSearchResult] (TV search result).
  static TmdbApiModels.TVSearchResult? toTVSearchResult(TmdbApiModels.TvShow? tvShow) {
    if (tvShow == null) return null;
    return TmdbApiModels.TVSearchResult(
      id: tvShow.id,
      name: tvShow.name,
      originalName: tvShow.originalName,
      overview: tvShow.overview,
      backdropPath: tvShow.backdropPath,
      posterPath: tvShow.posterPath,
      genreIds: tvShow.genres?.map((g) => g.id).toList() ?? [], // Map Genre objects to IDs
      originCountry: tvShow.originCountry,
      originalLanguage: tvShow.originalLanguage,
      adult: tvShow.adult,
      popularity: tvShow.popularity,
      firstAirDate: tvShow.firstAirDate,
      voteAverage: tvShow.voteAverage,
      voteCount: tvShow.voteCount,
    );
  }

  /// Converts a [TmdbApiModels.TVSearchResult] to a [TmdbApiModels.TvShow] (detailed, with missing data).
  static TmdbApiModels.TvShow? fromTVSearchResult(TmdbApiModels.TVSearchResult? tvSearchResult) {
    if (tvSearchResult == null) return null;
    return TmdbApiModels.TvShow(
      id: tvSearchResult.id,
      name: tvSearchResult.name,
      originalName: tvSearchResult.originalName,
      overview: tvSearchResult.overview ?? '',
      backdropPath: tvSearchResult.backdropPath,
      posterPath: tvSearchResult.posterPath,
      genreIds: tvSearchResult.genreIds, // Already IDs
      genres: null, // Detailed genres must be fetched
      originCountry: tvSearchResult.originCountry,
      originalLanguage: tvSearchResult.originalLanguage,
      adult: tvSearchResult.adult,
      popularity: tvSearchResult.popularity,
      firstAirDate: tvSearchResult.firstAirDate,
      voteAverage: tvSearchResult.voteAverage,
      voteCount: tvSearchResult.voteCount,
      // Other detailed fields are not present in TVSearchResult
    );
  }

  /// Converts a [TmdbApiModels.Person] to a [TmdbApiModels.MultiSearchPerson].
  static TmdbApiModels.MultiSearchPerson? toMultiSearchPerson(TmdbApiModels.Person? person) {
    if (person == null) return null;
    return TmdbApiModels.MultiSearchPerson(
      id: person.id,
      name: person.name,
      originalName: person.name,
      mediaType: TmdbApiModels.MediaType.person,
      adult: person.adult,
      popularity: person.popularity,
      profilePath: person.profilePath,
      gender: person.gender,
      knownForDepartment: person.knownForDepartment,
      knownFor: [], // Not directly available as a list in TmdbApiModels.Person in the simple Person model
    );
  }

  /// Converts a [TmdbApiModels.MultiSearchPerson] to a [TmdbApiModels.Person] (detailed, with missing data).
  static TmdbApiModels.Person? fromMultiSearchPerson(TmdbApiModels.MultiSearchPerson? multiPerson) {
    if (multiPerson == null) return null;
    return TmdbApiModels.Person(
      adult: multiPerson.adult,
      gender: multiPerson.gender ?? 0,
      id: multiPerson.id,
      knownForDepartment: multiPerson.knownForDepartment ?? '',
      name: multiPerson.name,
   //   originalName: multiPerson.originalName,
      popularity: multiPerson.popularity,
      profilePath: multiPerson.profilePath,
      // Other detailed fields (biography, birthday, etc.) are not present in MultiSearchPerson
      biography: null,
      birthday: null,
      deathday: null,
      homepage: null,
      imdbId: null,
      placeOfBirth: null,
    //  profilePaths: null,
    );
  }

  // --- Extra Functions: Conversions between different media types or contexts ---

  /// Converts a [CsvModels.Movie] (your local CSV-driven Movie) to a [TmdbApiModels.MultiSearchTV].
  /// This is a conceptual conversion, mapping movie fields to TV search fields.
  static TmdbApiModels.MultiSearchTV? toMultiSearchTvFromCsvMovie(CsvModels.Movie? csvMovie) {
    if (csvMovie == null) return null;
    return TmdbApiModels.MultiSearchTV(
      id: csvMovie.id,
      name: csvMovie.title,
      originalName: csvMovie.originalTitle,
      mediaType: TmdbApiModels.MediaType.tv, // Force to TV type
      adult: csvMovie.adult,
      popularity: csvMovie.popularity,
      posterPath: csvMovie.posterPath,
      backdropPath: csvMovie.backdropPath,
      overview: csvMovie.overview,
      firstAirDate: csvMovie.releaseDate?.toIso8601String(), // Use movie release date as first air date
      genreIds: csvMovie.genres.map(getGenreIdFromName).toList(),
      voteAverage: csvMovie.voteAverage,
      voteCount: csvMovie.voteCount,
      originCountry: csvMovie.productionCountries.isNotEmpty ? [csvMovie.productionCountries.first] : [],
      originalLanguage: csvMovie.originalLanguage,
      video: false, // Default for this conceptual conversion
    );
  }

  /// Converts a [CsvModels.TvSeriesAnime] (your local CSV-driven TV Series) to a [TmdbApiModels.MultiSearchMovie].
  /// This is a conceptual conversion, mapping TV series fields to movie search fields.
  static TmdbApiModels.MultiSearchMovie? toMultiSearchMovieFromCsvTvSeries(CsvModels.TvSeriesAnime? csvTvSeries) {
    if (csvTvSeries == null) return null;
    return TmdbApiModels.MultiSearchMovie(
      id: csvTvSeries.tmdbId,
      name: csvTvSeries.name,
      originalName: csvTvSeries.originalName,
      mediaType: TmdbApiModels.MediaType.movie, // Force to Movie type
      adult: false, // Not explicitly in CsvModels.TvSeriesAnime
      popularity: csvTvSeries.popularity,
      posterPath: csvTvSeries.posterPath,
      backdropPath: csvTvSeries.backdropPath,
      title: csvTvSeries.name,
      originalTitle: csvTvSeries.originalName,
      overview: csvTvSeries.overview,
      releaseDate: csvTvSeries.firstAirDate?.toIso8601String(), // Use first air date as release date
      genreIds: csvTvSeries.genres.map(getGenreIdFromName).toList(),
      voteAverage: csvTvSeries.voteAverage,
      voteCount: csvTvSeries.voteCount,
      video: false, // Default for this conceptual conversion
      originalLanguage: csvTvSeries.originalLanguage,
    );
  }

  /// Converts a [TmdbApiModels.Movie] to a [TmdbApiModels.TVSearchResult].
  /// This attempts to map a movie to a TV search result, losing details specific to TV.
  static TmdbApiModels.TVSearchResult? toTVSearchResultFromTmdbMovie(TmdbApiModels.Movie? tmdbMovie) {
    if (tmdbMovie == null) return null;
    return TmdbApiModels.TVSearchResult(
      id: tmdbMovie.id,
      name: tmdbMovie.title,
      originalName: tmdbMovie.originalTitle,
      overview: tmdbMovie.overview,
      backdropPath: tmdbMovie.backdropPath,
      posterPath: tmdbMovie.posterPath,
      genreIds: tmdbMovie.genres?.map((g) => g.id).toList() ?? [],
      originCountry: tmdbMovie.originCountry ?? [],
      originalLanguage: tmdbMovie.originalLanguage,
      adult: tmdbMovie.adult,
      popularity: tmdbMovie.popularity,
      firstAirDate: tmdbMovie.releaseDate, // Using movie's release date as first air date for TV
      voteAverage: tmdbMovie.voteAverage,
      voteCount: tmdbMovie.voteCount,
    );
  }

  /// Converts a [TmdbApiModels.TvShow] to a [TmdbApiModels.Movie].
  /// This is a highly lossy conceptual conversion, focusing only on common fields.
  static TmdbApiModels.Movie? toTmdbMovieFromTmdbTvShow(TmdbApiModels.TvShow? tmdbTvShow) {
    if (tmdbTvShow == null) return null;
    return TmdbApiModels.Movie(
      adult: tmdbTvShow.adult,
      backdropPath: tmdbTvShow.backdropPath,
      genreIds: tmdbTvShow.genreIds,
      genres: tmdbTvShow.genres,
      id: tmdbTvShow.id,
      originalLanguage: tmdbTvShow.originalLanguage,
      originalTitle: tmdbTvShow.originalName, // Map originalName to originalTitle
      overview: tmdbTvShow.overview,
      popularity: tmdbTvShow.popularity,
      posterPath: tmdbTvShow.posterPath,
      releaseDate: tmdbTvShow.firstAirDate ?? '', // Use first_air_date as release_date
      title: tmdbTvShow.name, // Map name to title
      video: false, // Default, as TV shows typically don't have this property for a movie conversion
      voteAverage: tmdbTvShow.voteAverage,
      voteCount: tmdbTvShow.voteCount,
      // Additional fields from TmdbApiModels.Movie that might match or need a default
      belongsToCollection: null,
      budget: null,
      homepage: tmdbTvShow.homepage,
      imdbId: null, // Not directly in TvShow
      originCountry: tmdbTvShow.originCountry,
      productionCompanies: [], // TmdbApiModels.TvShow details don't expose this directly in the main model
      productionCountries: [], // Same as above
      revenue: null,
      // Use the first episode runtime if available, otherwise null.
      runtime: tmdbTvShow.episodeRunTime?.isNotEmpty == true ? tmdbTvShow.episodeRunTime!.first : null,
      spokenLanguages: tmdbTvShow.spokenLanguages,
      status: tmdbTvShow.status,
      tagline: tmdbTvShow.tagline,
      keywords: [], // Map keywords if available
      hasDetails: true, // Assuming data is detailed enough from a TvShow object
    );
  }

  /// Converts a [TmdbApiModels.Movie] to a [TmdbApiModels.TvShow].
  /// This is a highly lossy conceptual conversion, focusing only on common fields.
  static TmdbApiModels.TvShow? toTmdbTvShowFromTmdbMovie(TmdbApiModels.Movie? tmdbMovie) {
    if (tmdbMovie == null) return null;
    return TmdbApiModels.TvShow(
      adult: tmdbMovie.adult,
      backdropPath: tmdbMovie.backdropPath,
      genreIds: tmdbMovie.genreIds,
      genres: tmdbMovie.genres,
      id: tmdbMovie.id,
      originCountry: tmdbMovie.originCountry ?? [],
      originalLanguage: tmdbMovie.originalLanguage,
      originalName: tmdbMovie.originalTitle, // Map originalTitle to originalName
      overview: tmdbMovie.overview,
      popularity: tmdbMovie.popularity,
      posterPath: tmdbMovie.posterPath,
      firstAirDate: tmdbMovie.releaseDate, // Use movie's release_date as TV show's first_air_date
      lastAirDate: tmdbMovie.releaseDate, // Use movie's release_date as TV show's last_air_date
      name: tmdbMovie.title, // Map title to name
      voteAverage: tmdbMovie.voteAverage,
      voteCount: tmdbMovie.voteCount,
      // Additional fields from TmdbApiModels.TvShow that might match or need a default
      createdBy: null,
      episodeRunTime: tmdbMovie.runtime != null ? [tmdbMovie.runtime!] : [],
      homepage: tmdbMovie.homepage,
      inProduction: false, // Movies are not 'in production' like ongoing series
      languages: tmdbMovie.spokenLanguages?.map((sl) => sl.iso6391).toList() ?? [], // Using ISO code
      lastEpisodeToAir: null,
      networks: null,
      nextEpisodeToAir: null,
      numberOfEpisodes: null, // Movies don't have distinct episodes in this context
      numberOfSeasons: null, // Movies don't have seasons
      productionCompanies: tmdbMovie.productionCompanies,
      productionCountries: tmdbMovie.productionCountries,
      seasons: null, // No seasons from a movie
      spokenLanguages: tmdbMovie.spokenLanguages,
      status: tmdbMovie.status,
      tagline: tmdbMovie.tagline,
      type: 'Movie-to-TvShow-Conversion', // Custom type to indicate conversion origin
   //   keywords: tmdbMovie.keywords?.map((k) => TmdbApiModels.Keyword(id: k.id, name: k.name)).toList() ?? [], // Map keywords if available
    );
  }
}