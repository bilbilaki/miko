// TODO Implement this library.

library;
import 'package:flutter/foundation.dart';
// lib/constants.dart
class AppConstants {
  // Custom TMDB Image Proxy Base URL
  static const String tmdbImageBaseUrl =
      'https://inosdb.worker-inosuke.workers.dev';
  static const String tmdbapitokens =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI2MDdlNDBhZjViYjY2NTc2ZjZmZDcyNTJkNTUyOWUyNCIsIm5iZiI6MTcyNTMxNjQ1OC4yNCwic3ViIjoiNjZkNjNkNmEzZTFhYjQ1Y2U1YjFiN2NmIiwic2NvcGVzIjpbImFwaV9yZWFkIl0sInZlcnNpb24iOjF9.N701knycQaKNMmYbdRnF3ag0dl9i28cL4oZBC-c42OY';
  static const String tmdbapikey = '607e40af5bb66576f6fd7252d5529e24'; // Standard YouTube Base URLs
  static const String youtubeBaseUrl = 'https://www.youtube.com/watch?v=';
  static const String youtubeThumbnailBaseUrl =
      'https://img.youtube.com/vi/'; // For thumbnails

  // Asset paths (adjust if needed)
  static const String movieInfoPath = 'assets/data/movies_info.csv';
  static const String tvInfoPath = 'assets/data/tv_info.csv';
  static const String tvLinksPath = 'assets/data/tv_links.csv';
  static const String animeInfoPath = 'assets/anime_series_details.csv';
  static const String animeLinksPath = 'assets/anime_series_link.csv';

  // Image sizes
  static const String imageSizeW500 = 'w500';
  static const String imageSizeW780 = 'w780';
  static const String imageSizeW1280 = 'w1280';
  static const String imageSizeOriginal = 'original';

  
}


/// A collection of constants and static helper methods for accessing The Movie Database (TMDB) API.
///
/// This file consolidates API keys, base URLs, and constructs specific endpoint URLs
/// for various TMDB operations (movies, TV shows, persons, search, authentication, etc.).
///
/// **Important Notes:**
///   - [tmdbRawApiKey] should ideally be stored securely (e.g., environment variables, FlutterConfig, etc.)
///     and not hardcoded directly in a production application's source code.
///   - [tmdbAuthToken] is for v4 authorization via `Authorization: Bearer <token>` header.
///   - Endpoints requiring parameters (e.g., IDs, query strings) are provided as static methods
///     that take arguments to construct the full URL.
///   - POST/DELETE requests often require session IDs or guest session IDs (instead of API key in URL)
///     and typically utilize the [tmdbAuthToken] in the Authorization header.


// --- API Authentication & Base URLs ---

/// The raw TMDB API key (v3). **Should be stored securely in a real application.**
const String tmdbRawApiKey = '607e40af5bb66576f6fd7252d5529e24';

/// The TMDB API key formatted as a query parameter string.
/// This matches your initial provided setup for [nowPlayingMoviesEndpoint], etc.
/// For other endpoints using the helper, [tmdbRawApiKey] is used directly.
const String tmdbApiKeyQuery = 'api_key=$tmdbRawApiKey';

/// The TMDB API Read Access Token (v4 auth), used in the Authorization header.
const String tmdbAuthToken = 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI2MDdlNDBhZjViYjY2NTc2ZjZmZDcyNTJkNTUyOWUyNCIsIm5iZiI6MTcyNTMxNjQ1OC4yNCwic3ViIjoiNjZkNjNkNmEzZTFhYjQ1Y2U1YjFiN2NmIiwic2NvcGVzIjpbImFwaV9yZWFkIl0sInZlcnNpb24iOjF9.N701knycQaKNMmYbdRnF3ag0dl9i28cL4oZBC-c42OY';

/// The base URL for the TMDB API v3.
const String tmdbBaseUrl = 'https://api.themoviedb.org/3';

// --- Image Base URLs & Sizes (from /3/configuration response) ---

/// Base URL for non-secure image requests.
const String tmdbImageBaseUrl = 'https://inosdb.worker-inosuke.workers.dev/';

/// Base URL for secure (HTTPS) image requests. **Recommended for all image loading.**
const String tmdbSecureImageBaseUrl = 'https://inosdb.worker-inosuke.workers.dev/';

/// List of available backdrop image sizes.
const List<String> tmdbBackdropSizes = ['w300', 'w780', 'w1280', 'original'];

/// List of available logo image sizes.
const List<String> tmdbLogoSizes = ['w45', 'w92', 'w154', 'w185', 'w300', 'w500', 'original'];

/// List of available poster image sizes.
const List<String> tmdbPosterSizes = ['w92', 'w154', 'w185', 'w342', 'w500', 'w780', 'original'];

/// List of available profile image sizes.
const List<String> tmdbProfileSizes = ['w45', 'w185', 'h632', 'original'];

/// List of available still image sizes (for TV episodes).
const List<String> tmdbStillSizes = ['w92', 'w185', 'w300', 'original'];

/// Helper function to construct a full image URL.
///
/// [path] should be the `file_path` returned by TMDB API (e.g., `/hZkgoQYus5vegHoetLkCJzb17zJ.jpg`).
/// [size] is the desired image size (e.g., 'w500', 'original'). Defaults to 'original'.
/// [secure] specifies whether to use HTTPS. Defaults to true.
String getTmdbImageUrl(String? path, {String size = 'original', bool secure = true}) {
  if (path == null || path.isEmpty) return '';
  final baseUrl = secure ? tmdbSecureImageBaseUrl : tmdbImageBaseUrl;
  return '$baseUrl$size$path';
}

// --- Internal Helper for Endpoint URL Construction ---

/// Internal helper to build TMDB API URLs with common parameters.
///
/// [path] is the endpoint path (e.g., '/movie/popular').
/// [language] optional language parameter. Defaults to 'en-US'. Pass an empty string
///   if you don't want the language parameter (e.g., for POST/DELETE requests).
/// [includeApiKey] indicates whether to append the API key as a query parameter.
///   Set to `false` for POST/DELETE requests where API key is in the header,
///   or when session/guest_session_id is the primary authentication method in the URL.
/// [additionalParams] allows passing a map of extra query parameters.
@visibleForTesting
String _buildUrl(String path, {String language = 'en-US', bool includeApiKey = true, Map<String, dynamic>? additionalParams}) {
  Uri uri = Uri.parse('$tmdbBaseUrl$path');
  Map<String, String> queryParameters = Map.from(uri.queryParameters);

  if (includeApiKey) {
    queryParameters['api_key'] = tmdbRawApiKey;
  }

  if (language.isNotEmpty) {
    queryParameters['language'] = language;
  }

  // Add additional parameters, converting dynamic values to strings
  additionalParams?.forEach((key, value) {
    if (value != null) { // Only add if value is not null
      if (value is List) {
        queryParameters[key] = value.join(','); // Join list of IDs with comma
      } else {
        queryParameters[key] = value.toString();
      }
    }
  });

  return uri.replace(queryParameters: queryParameters).toString();
}

// --- Specific API Endpoints Grouped by Entity/Functionality ---

/// All endpoints related to Movies.
abstract class TmdbMovieEndpoints {
  // Existing movie endpoints as provided by the user (kept for direct use from original setup)
  static const String nowPlaying = '$tmdbBaseUrl/movie/now_playing?$tmdbApiKeyQuery';
  static const String popular = '$tmdbBaseUrl/movie/popular?$tmdbApiKeyQuery';
  static const String topRated = '$tmdbBaseUrl/movie/top_rated?$tmdbApiKeyQuery';
  static const String upcoming = '$tmdbBaseUrl/movie/upcoming?$tmdbApiKeyQuery';

  /// GET /3/discover/movie - Find movies using over 30 filters and sort options.
  static String discover({
    String language = 'en-US',
    String sortBy = 'popularity.desc',
    int page = 1,
    int? voteCountGte,
    double? voteAverageGte,
    String? withOriginalLanguage,
    String? primaryReleaseYear,
    List<int>? withKeywords,
    List<int>? withCast,
    List<int>? withCrew,
    List<int>? withPeople,
    int? withRuntimeGte,
    int? withRuntimeLte,
    bool? includeAdult,
  }) {
    Map<String, dynamic> params = {
      'sort_by': sortBy,
      'page': page,
      'vote_count.gte': voteCountGte,
      'vote_average.gte': voteAverageGte,
      'with_original_language': withOriginalLanguage,
      'primary_release_year': primaryReleaseYear,
      'with_keywords': withKeywords,
      'with_cast': withCast,
      'with_crew': withCrew,
      'with_people': withPeople,
      'with_runtime.gte': withRuntimeGte,
      'with_runtime.lte': withRuntimeLte,
      'include_adult': includeAdult,
    };
    return _buildUrl('/discover/movie', language: language, additionalParams: params);
  }

  /// GET /3/movie/{movie_id} - Get the top level details of a movie by ID.
  static String details(int movieId, {String language = 'en-US'}) =>
      _buildUrl('/movie/$movieId', language: language);

  /// GET /3/movie/{movie_id}/images - Get the images that belong to a movie.
  static String images(int movieId) => _buildUrl('/movie/$movieId/images', language: '');

  /// GET /3/movie/{movie_id}/account_states - Get the rating, watchlist and favourite status of an account for a movie.
  static String accountStates(int movieId, {String? guestSessionId, String? sessionId}) {
    Map<String, dynamic> params = {};
    if (guestSessionId != null) params['guest_session_id'] = guestSessionId;
    if (sessionId != null) params['session_id'] = sessionId;
    return _buildUrl('/movie/$movieId/account_states', language: '', additionalParams: params);
  }

  /// POST /3/movie/{movie_id}/rating - Rate a movie. (Requires sessionId or guestSessionId in query, Authorization header for v4 token)
  /// DELETE /3/movie/{movie_id}/rating - Delete a user rating.
  static String rating(int movieId, {String? guestSessionId, String? sessionId}) {
    Map<String, dynamic> params = {};
    if (guestSessionId != null) params['guest_session_id'] = guestSessionId;
    if (sessionId != null) params['session_id'] = sessionId;
    return _buildUrl('/movie/$movieId/rating', includeApiKey: false, language: '', additionalParams: params);
  }

  /// GET /3/movie/{movie_id}/alternative_titles - Get the alternative titles for a movie.
  static String alternativeTitles(int movieId) => _buildUrl('/movie/$movieId/alternative_titles', language: '');

  /// GET /3/movie/{movie_id}/changes - Get the recent changes for a movie.
  static String changes(int movieId, {String? startDate, String? endDate}) {
    Map<String, dynamic> params = {};
    if (startDate != null) params['start_date'] = startDate;
    if (endDate != null) params['end_date'] = endDate;
    return _buildUrl('/movie/$movieId/changes', language: '', additionalParams: params);
  }

  /// GET /3/movie/{movie_id}/credits - Get the cast and crew credits for a movie.
  static String credits(int movieId, {String language = 'en-US'}) => _buildUrl('/movie/$movieId/credits', language: language);

  /// GET /3/movie/{movie_id}/external_ids - Get the external ID's that belong to a movie.
  static String externalIds(int movieId) => _buildUrl('/movie/$movieId/external_ids', language: '');

  /// GET /3/movie/{movie_id}/keywords - Get the keywords that have been added to a movie.
  static String keywords(int movieId) => _buildUrl('/movie/$movieId/keywords', language: '');

  /// GET /3/movie/{movie_id}/lists - Get the lists that a movie has been added to.
  static String lists(int movieId, {String language = 'en-US', int page = 1}) =>
      _buildUrl('/movie/$movieId/lists', language: language, additionalParams: {'page': page});

  /// GET /3/movie/{movie_id}/recommendations - Get the similar movies based on genres and keywords.
  static String recommendations(int movieId, {String language = 'en-US', int page = 1}) =>
      _buildUrl('/movie/$movieId/recommendations', language: language, additionalParams: {'page': page});

  /// GET /3/movie/{movie_id}/release_dates - Get the release dates and certifications for a movie.
  static String releaseDates(int movieId) => _buildUrl('/movie/$movieId/release_dates', language: '');

  /// GET /3/movie/{movie_id}/reviews - Get the user reviews for a movie.
  static String reviews(int movieId, {String language = 'en-US', int page = 1}) =>
      _buildUrl('/movie/$movieId/reviews', language: language, additionalParams: {'page': page});

  /// GET /3/movie/{movie_id}/similar - Get the similar movies based on genres and keywords.
  static String similar(int movieId, {String language = 'en-US', int page = 1}) =>
      _buildUrl('/movie/$movieId/similar', language: language, additionalParams: {'page': page});

  /// GET /3/movie/{movie_id}/translations - Get the translations for a movie.
  static String translations(int movieId) => _buildUrl('/movie/$movieId/translations', language: '');

  /// GET /3/movie/{movie_id}/videos - Get the videos that belong to a movie.
  static String videos(int movieId, {String language = 'en-US'}) => _buildUrl('/movie/$movieId/videos', language: language);

  /// GET /3/movie/{movie_id}/watch/providers - Get the list of streaming providers we have for a movie.
  static String watchProviders(int movieId) => _buildUrl('/movie/$movieId/watch/providers', language: '');

  /// GET /3/movie/latest - Get the newest movie ID.
  static String latest() => _buildUrl('/movie/latest');
}

/// All endpoints related to TV Series.
abstract class TmdbTvEndpoints {
  /// GET /3/discover/tv - Find TV shows using over 30 filters and sort options.
  static String discover({
    String language = 'en-US',
    String sortBy = 'popularity.desc',
    int page = 1,
    int? voteCountGte,
    double? voteAverageGte,
    String? withOriginalLanguage,
    String? firstAirDateYear,
    List<int>? withKeywords,
    List<int>? withCast,
    List<int>? withCrew,
    List<int>? withPeople,
    int? withRuntimeGte,
    int? withRuntimeLte,
    bool? includeAdult,
    String? withOriginCountry,
  }) {
    Map<String, dynamic> params = {
      'sort_by': sortBy,
      'page': page,
      'vote_count.gte': voteCountGte,
      'vote_average.gte': voteAverageGte,
      'with_original_language': withOriginalLanguage,
      'first_air_date_year': firstAirDateYear,
      'with_keywords': withKeywords,
      'with_cast': withCast,
      'with_crew': withCrew,
      'with_people': withPeople,
      'with_runtime.gte': withRuntimeGte,
      'with_runtime.lte': withRuntimeLte,
      'include_adult': includeAdult,
      'with_origin_country': withOriginCountry,
    };
    return _buildUrl('/discover/tv', language: language, additionalParams: params);
  }

  /// GET /3/tv/{series_id} - Get the details of a TV show.
  static String details(int seriesId, {String language = 'en-US'}) =>
      _buildUrl('/tv/$seriesId', language: language);

  /// GET /3/tv/{series_id}/images - Get the images that belong to a TV series.
  static String images(int seriesId) => _buildUrl('/tv/$seriesId/images', language: '');

  /// GET /3/tv/{series_id}/account_states - Get the rating, watchlist and favourite status for a TV series.
  static String accountStates(int seriesId, {String? guestSessionId, String? sessionId}) {
    Map<String, dynamic> params = {};
    if (guestSessionId != null) params['guest_session_id'] = guestSessionId;
    if (sessionId != null) params['session_id'] = sessionId;
    return _buildUrl('/tv/$seriesId/account_states', language: '', additionalParams: params);
  }

  /// GET /3/tv/airing_today - Get a list of TV shows airing today.
  static String airingToday({String language = 'en-US', int page = 1}) =>
      _buildUrl('/tv/airing_today', language: language, additionalParams: {'page': page});

  /// GET /3/tv/popular - Get a list of TV shows ordered by popularity.
  static String popular({String language = 'en-US', int page = 1}) =>
      _buildUrl('/tv/popular', language: language, additionalParams: {'page': page});

  /// GET /3/tv/top_rated - Get a list of TV shows ordered by rating.
  static String topRated({String language = 'en-US', int page = 1}) =>
      _buildUrl('/tv/top_rated', language: language, additionalParams: {'page': page});

  /// GET /3/tv/latest - Get the newest TV show ID.
  static String latest() => _buildUrl('/tv/latest');

  /// GET /3/tv/{series_id}/aggregate_credits - Get the aggregate credits (cast and crew) that have been added to a TV show.
  static String aggregateCredits(int seriesId, {String language = 'en-US'}) =>
      _buildUrl('/tv/$seriesId/aggregate_credits', language: language);

  /// GET /3/tv/{series_id}/alternative_titles - Get the alternative titles that have been added to a TV show.
  static String alternativeTitles(int seriesId) => _buildUrl('/tv/$seriesId/alternative_titles', language: '');

  /// GET /3/tv/{series_id}/content_ratings - Get the content ratings that have been added to a TV show.
  static String contentRatings(int seriesId) => _buildUrl('/tv/$seriesId/content_ratings', language: '');

  /// GET /3/tv/{series_id}/credits - Get the latest season credits of a TV show.
  static String credits(int seriesId, {String language = 'en-US'}) => _buildUrl('/tv/$seriesId/credits', language: language);

  /// GET /3/tv/{series_id}/episode_groups - Get the episode groups that have been added to a TV show.
  static String episodeGroups(int seriesId) => _buildUrl('/tv/$seriesId/episode_groups', language: '');

  /// GET /3/tv/{series_id}/external_ids - Get a list of external IDs that have been added to a TV show.
  static String externalIds(int seriesId) => _buildUrl('/tv/$seriesId/external_ids', language: '');

  /// GET /3/tv/{series_id}/keywords - Get a list of keywords that have been added to a TV show.
  static String keywords(int seriesId) => _buildUrl('/tv/$seriesId/keywords', language: '');

  /// GET /3/tv/{series_id}/recommendations - Get the similar TV shows.
  static String recommendations(int seriesId, {String language = 'en-US', int page = 1}) =>
      _buildUrl('/tv/$seriesId/recommendations', language: language, additionalParams: {'page': page});

  /// GET /3/tv/{series_id}/reviews - Get the reviews that have been added to a TV show.
  static String reviews(int seriesId, {String language = 'en-US', int page = 1}) =>
      _buildUrl('/tv/$seriesId/reviews', language: language, additionalParams: {'page': page});

  /// GET /3/tv/{series_id}/screened_theatrically - Get the seasons and episodes that have screened theatrically.
  static String screenedTheatrically(int seriesId) => _buildUrl('/tv/$seriesId/screened_theatrically', language: '');

  /// GET /3/tv/{series_id}/similar - Get the similar TV shows.
  static String similar(int seriesId, {String language = 'en-US', int page = 1}) =>
      _buildUrl('/tv/$seriesId/similar', language: language, additionalParams: {'page': page});

  /// GET /3/tv/{series_id}/translations - Get the translations that have been added to a TV show.
  static String translations(int seriesId) => _buildUrl('/tv/$seriesId/translations', language: '');

  /// GET /3/tv/{series_id}/videos - Get the videos that belong to a TV show.
  static String videos(int seriesId, {String language = 'en-US'}) => _buildUrl('/tv/$seriesId/videos', language: language);

  /// GET /3/tv/{series_id}/watch/providers - Get the list of streaming providers we have for a TV show.
  static String watchProviders(int seriesId) => _buildUrl('/tv/$seriesId/watch/providers', language: '');

  /// POST/DELETE /3/tv/{series_id}/rating - Rate a TV show or delete a user rating.
  static String rating(int seriesId, {String? guestSessionId, String? sessionId}) {
    Map<String, dynamic> params = {};
    if (guestSessionId != null) params['guest_session_id'] = guestSessionId;
    if (sessionId != null) params['session_id'] = sessionId;
    return _buildUrl('/tv/$seriesId/rating', includeApiKey: false, language: '', additionalParams: params);
  }
}

/// All endpoints related to TV Seasons.
abstract class TmdbTvSeasonEndpoints {
  /// GET /3/tv/{series_id}/season/{season_number} - Query the details of a TV season.
  static String details(int seriesId, int seasonNumber, {String language = 'en-US'}) =>
      _buildUrl('/tv/$seriesId/season/$seasonNumber', language: language);

  /// GET /3/tv/{series_id}/season/{season_number}/images - Get the images that belong to a TV season.
  static String images(int seriesId, int seasonNumber) =>
      _buildUrl('/tv/$seriesId/season/$seasonNumber/images', language: '');

  /// GET /3/tv/{series_id}/season/{season_number}/account_states - Get the rating, watchlist and favourite status for a TV season.
  static String accountStates(int seriesId, int seasonNumber, {String? guestSessionId, String? sessionId, String language = 'en-US'}) {
    Map<String, dynamic> params = {};
    if (guestSessionId != null) params['guest_session_id'] = guestSessionId;
    if (sessionId != null) params['session_id'] = sessionId;
    return _buildUrl('/tv/$seriesId/season/$seasonNumber/account_states', language: language, additionalParams: params);
  }

  /// GET /3/tv/season/{season_id}/changes - Get the recent changes for a TV season.
  static String changes(int seasonId, {String? startDate, String? endDate, int page = 1}) {
    Map<String, dynamic> params = {'page': page};
    if (startDate != null) params['start_date'] = startDate;
    if (endDate != null) params['end_date'] = endDate;
    return _buildUrl('/tv/season/$seasonId/changes', language: '', additionalParams: params);
  }

  /// GET /3/tv/{series_id}/season/{season_number}/aggregate_credits - Get the aggregate credits (cast and crew) that have been added to a TV season.
  static String aggregateCredits(int seriesId, int seasonNumber, {String language = 'en-US'}) =>
      _buildUrl('/tv/$seriesId/season/$seasonNumber/aggregate_credits', language: language);

  /// GET /3/tv/{series_id}/season/{season_number}/credits - Get the cast and crew credits for a TV season.
  static String credits(int seriesId, int seasonNumber, {String language = 'en-US'}) =>
      _buildUrl('/tv/$seriesId/season/$seasonNumber/credits', language: language);

  /// GET /3/tv/{series_id}/season/{season_number}/external_ids - Get a list of external IDs that have been added to a TV season.
  static String externalIds(int seriesId, int seasonNumber) =>
      _buildUrl('/tv/$seriesId/season/$seasonNumber/external_ids', language: '');

  /// GET /3/tv/{series_id}/season/{season_number}/translations - Get the translations for a TV season.
  static String translations(int seriesId, int seasonNumber) =>
      _buildUrl('/tv/$seriesId/season/$seasonNumber/translations', language: '');

  /// GET /3/tv/{series_id}/season/{season_number}/videos - Get the videos that belong to a TV season.
  static String videos(int seriesId, int seasonNumber) =>
      _buildUrl('/tv/$seriesId/season/$seasonNumber/videos', language: '');
}

/// All endpoints related to TV Episodes.
abstract class TmdbTvEpisodeEndpoints {
  /// GET /3/tv/{series_id}/season/{season_number}/episode/{episode_number} - Query the details of a TV episode.
  static String details(int seriesId, int seasonNumber, int episodeNumber, {String language = 'en-US'}) =>
      _buildUrl('/tv/$seriesId/season/$seasonNumber/episode/$episodeNumber', language: language);

  /// GET /3/tv/{series_id}/season/{season_number}/episode/{episode_number}/images - Get the images that belong to a TV episode.
  static String images(int seriesId, int seasonNumber, int episodeNumber) =>
      _buildUrl('/tv/$seriesId/season/$seasonNumber/episode/$episodeNumber/images', language: '');

  /// GET /3/tv/{series_id}/season/{season_number}/episode/{episode_number}/account_states - Get the rating, watchlist and favourite status for a TV episode.
  static String accountStates(int seriesId, int seasonNumber, int episodeNumber, {String? guestSessionId, String? sessionId}) {
    Map<String, dynamic> params = {};
    if (guestSessionId != null) params['guest_session_id'] = guestSessionId;
    if (sessionId != null) params['session_id'] = sessionId;
    return _buildUrl('/tv/$seriesId/season/$seasonNumber/episode/$episodeNumber/account_states', language: '', additionalParams: params);
  }

  /// GET /3/tv/{series_id}/season/{season_number}/episode/{episode_number}/credits - Get the cast and crew credits for a TV episode.
  static String credits(int seriesId, int seasonNumber, int episodeNumber, {String language = 'en-US'}) =>
      _buildUrl('/tv/$seriesId/season/$seasonNumber/episode/$episodeNumber/credits', language: language);

  /// GET /3/tv/{series_id}/season/{season_number}/episode/{episode_number}/external_ids - Get a list of external IDs that have been added to a TV episode.
  static String externalIds(int seriesId, int seasonNumber, int episodeNumber) =>
      _buildUrl('/tv/$seriesId/season/$seasonNumber/episode/$episodeNumber/external_ids', language: '');

  /// GET /3/tv/{series_id}/season/{season_number}/episode/{episode_number}/translations - Get the translations that have been added to a TV episode.
  static String translations(int seriesId, int seasonNumber, int episodeNumber) =>
      _buildUrl('/tv/$seriesId/season/$seasonNumber/episode/$episodeNumber/translations', language: '');

  /// GET /3/tv/{series_id}/season/{season_number}/episode/{episode_number}/videos - Get the videos that belong to a TV episode.
  static String videos(int seriesId, int seasonNumber, int episodeNumber) =>
      _buildUrl('/tv/$seriesId/season/$seasonNumber/episode/$episodeNumber/videos', language: '');

  /// POST/DELETE /3/tv/{series_id}/season/{season_number}/episode/{episode_number}/rating - Rate a TV episode or delete a user rating.
  static String rating(int seriesId, int seasonNumber, int episodeNumber, {String? guestSessionId, String? sessionId}) {
    Map<String, dynamic> params = {};
    if (guestSessionId != null) params['guest_session_id'] = guestSessionId;
    if (sessionId != null) params['session_id'] = sessionId;
    return _buildUrl('/tv/$seriesId/season/$seasonNumber/episode/$episodeNumber/rating', includeApiKey: false, language: '', additionalParams: params);
  }
}

/// All endpoints for Search operations (Movie, TV, Multi, Person).
abstract class TmdbSearchEndpoints {
  /// GET /3/search/movie - Search for movies by their original, translated and alternative titles.
  static String movie({required String query, String language = 'en-US', bool includeAdult = false, int page = 1}) =>
      _buildUrl('/search/movie', language: language, additionalParams: {
        'query': Uri.encodeComponent(query),
        'include_adult': includeAdult,
        'page': page,
      });

  /// GET /3/search/tv - Search for TV shows by their original, translated and also known as names.
  static String tv({required String query, String language = 'en-US', bool includeAdult = false, int page = 1}) =>
      _buildUrl('/search/tv', language: language, additionalParams: {
        'query': Uri.encodeComponent(query),
        'include_adult': includeAdult,
        'page': page,
      });

  /// GET /3/search/multi - Use multi search when you want to search for movies, TV shows and people in a single request.
  static String multi({required String query, String language = 'en-US', bool includeAdult = false, int page = 1}) =>
      _buildUrl('/search/multi', language: language, additionalParams: {
        'query': Uri.encodeComponent(query),
        'include_adult': includeAdult,
        'page': page,
      });

  /// GET /3/search/person - Search for people by their name and also known as names.
  static String person({required String query, String language = 'en-US', bool includeAdult = false, int page = 1}) =>
      _buildUrl('/search/person', language: language, additionalParams: {
        'query': Uri.encodeComponent(query),
        'include_adult': includeAdult,
        'page': page,
      });
}

/// All endpoints for Trending content (All, Movie, TV, Person).
abstract class TmdbTrendingEndpoints {
  /// GET /3/trending/all/{time_window} - Get the trending movies, TV shows and people.
  /// [timeWindow] can be 'day' or 'week'.
  static String all(String timeWindow, {String language = 'en-US'}) => _buildUrl('/trending/all/$timeWindow', language: language);

  /// GET /3/trending/movie/{time_window} - Get the trending movies on TMDB.
  /// [timeWindow] can be 'day' or 'week'.
  static String movie(String timeWindow, {String language = 'en-US'}) => _buildUrl('/trending/movie/$timeWindow', language: language);

  /// GET /3/trending/tv/{time_window} - Get the trending TV shows on TMDB.
  /// [timeWindow] can be 'day' or 'week'.
  static String tv(String timeWindow, {String language = 'en-US'}) => _buildUrl('/trending/tv/$timeWindow', language: language);

  /// GET /3/trending/person/{time_window} - Get the trending people on TMDB.
  /// [timeWindow] can be 'day' or 'week'.
  static String person(String timeWindow, {String language = 'en-US'}) => _buildUrl('/trending/person/$timeWindow', language: language);
}

/// All endpoints related to Authentication.
abstract class TmdbAuthEndpoints {
  /// GET /3/authentication/guest_session/new - Create a new guest session.
  static String createGuestSession() => _buildUrl('/authentication/guest_session/new');

  /// GET /3/authentication/token/new - Create a new request token.
  static String createRequestToken() => _buildUrl('/authentication/token/new');

  /// POST /3/authentication/session/new - Create a new user session. (Requires request token in body)
  static String createSession() => _buildUrl('/authentication/session/new', includeApiKey: false, language: '');

  /// POST /3/authentication/session/convert/4 - Convert a v4 access token to a v3 session ID. (Requires v4_access_token in body)
  static String createSessionFromV4() => _buildUrl('/authentication/session/convert/4', includeApiKey: false, language: '');

  /// DELETE /3/authentication/session - Delete a user session. (Requires session ID in body)
  static String deleteSession() => _buildUrl('/authentication/session', includeApiKey: false, language: '');
}

/// All endpoints related to User Accounts.
abstract class TmdbAccountEndpoints {
  /// GET /3/account/{account_id} - Get the public details of an account on TMDB.
  static String details(int accountId, {required String sessionId}) =>
      _buildUrl('/account/$accountId', language: '', additionalParams: {'session_id': sessionId});

  /// GET /3/account/{account_id}/lists - Get a user's list of custom lists.
  static String lists(int accountId, {int page = 1, required String sessionId}) =>
      _buildUrl('/account/$accountId/lists', language: '', additionalParams: {'page': page, 'session_id': sessionId});

  /// GET /3/account/{account_id}/favorite/movies - Get a user's list of favourite movies.
  static String favoriteMovies(int accountId, {String language = 'en-US', int page = 1, String sortBy = 'created_at.asc', required String sessionId}) =>
      _buildUrl('/account/$accountId/favorite/movies', language: language, additionalParams: {'page': page, 'sort_by': sortBy, 'session_id': sessionId});

  /// GET /3/account/{account_id}/favorite/tv - Get a user's list of favourite TV shows.
  static String favoriteTv(int accountId, {String language = 'en-US', int page = 1, String sortBy = 'created_at.asc', required String sessionId}) =>
      _buildUrl('/account/$accountId/favorite/tv', language: language, additionalParams: {'page': page, 'sort_by': sortBy, 'session_id': sessionId});

  /// GET /3/account/{account_id}/rated/movies - Get a user's list of rated movies.
  static String ratedMovies(int accountId, {String language = 'en-US', int page = 1, String sortBy = 'created_at.asc', required String sessionId}) =>
      _buildUrl('/account/$accountId/rated/movies', language: language, additionalParams: {'page': page, 'sort_by': sortBy, 'session_id': sessionId});

  /// GET /3/account/{account_id}/rated/tv - Get a user's list of rated TV shows.
  static String ratedTv(int accountId, {String language = 'en-US', int page = 1, String sortBy = 'created_at.asc', required String sessionId}) =>
      _buildUrl('/account/$accountId/rated/tv', language: language, additionalParams: {'page': page, 'sort_by': sortBy, 'session_id': sessionId});

  /// GET /3/account/{account_id}/rated/tv/episodes - Get a user's list of rated TV episodes.
  static String ratedTvEpisodes(int accountId, {String language = 'en-US', int page = 1, String sortBy = 'created_at.asc', required String sessionId}) =>
      _buildUrl('/account/$accountId/rated/tv/episodes', language: language, additionalParams: {'page': page, 'sort_by': sortBy, 'session_id': sessionId});

  /// GET /3/account/{account_id}/watchlist/movies - Get a list of movies added to a user's watchlist.
  static String watchlistMovies(int accountId, {String language = 'en-US', int page = 1, String sortBy = 'created_at.asc', required String sessionId}) =>
      _buildUrl('/account/$accountId/watchlist/movies', language: language, additionalParams: {'page': page, 'sort_by': sortBy, 'session_id': sessionId});

  /// GET /3/account/{account_id}/watchlist/tv - Get a list of TV shows added to a user's watchlist.
  static String watchlistTv(int accountId, {String language = 'en-US', int page = 1, String sortBy = 'created_at.asc', required String sessionId}) =>
      _buildUrl('/account/$accountId/watchlist/tv', language: language, additionalParams: {'page': page, 'sort_by': sortBy, 'session_id': sessionId});

  /// POST /3/account/{account_id}/favorite - Mark a movie or TV show as a favourite.
  static String addFavorite(int accountId, {required String sessionId}) =>
      _buildUrl('/account/$accountId/favorite', includeApiKey: false, language: '', additionalParams: {'session_id': sessionId});

  /// POST /3/account/{account_id}/watchlist - Add a movie or TV show to your watchlist.
  static String addToWatchlist(int accountId, {required String sessionId}) =>
      _buildUrl('/account/$accountId/watchlist', includeApiKey: false, language: '', additionalParams: {'session_id': sessionId});
}

/// All endpoints for retrieving API Configuration details.
abstract class TmdbConfigurationEndpoints {
  /// GET /3/configuration - Query the API configuration details (useful for image base URLs and sizes).
  static String details() => _buildUrl('/configuration');
}

/// All endpoints for Certifications (Movie and TV).
abstract class TmdbCertificationEndpoints {
  /// GET /3/certification/movie/list - Get an up to date list of the officially supported movie certifications on TMDB.
  static String movieCertifications({String language = 'en-US'}) => _buildUrl('/certification/movie/list', language: language);

  /// GET /3/certification/tv/list - Get an up to date list of the officially supported TV certifications on TMDB.
  static String tvCertifications({String language = 'en-US'}) => _buildUrl('/certification/tv/list', language: language);
}

/// All endpoints for tracking changes on Movie, TV, and Person entities.
abstract class TmdbChangesListEndpoints {
  /// GET /3/movie/changes - Get a list of all of the movie ids that have been changed in the past 24 hours.
  static String movieChanges({String? startDate, String? endDate, int page = 1}) {
    Map<String, dynamic> params = {'page': page};
    if (startDate != null) params['start_date'] = startDate;
    if (endDate != null) params['end_date'] = endDate;
    return _buildUrl('/movie/changes', language: '', additionalParams: params); // No language for changes API
  }

  /// GET /3/tv/changes - Get a list of all of the TV show ids that have been changed in the past 24 hours.
  static String tvChanges({String? startDate, String? endDate, int page = 1}) {
    Map<String, dynamic> params = {'page': page};
    if (startDate != null) params['start_date'] = startDate;
    if (endDate != null) params['end_date'] = endDate;
    return _buildUrl('/tv/changes', language: '', additionalParams: params); // No language for changes API
  }

  /// GET /3/person/changes - Get a list of all of the person ids that have been changed in the past 24 hours.
  static String personChanges({String? startDate, String? endDate, int page = 1}) {
    Map<String, dynamic> params = {'page': page};
    if (startDate != null) params['start_date'] = startDate;
    if (endDate != null) params['end_date'] = endDate;
    return _buildUrl('/person/changes', language: '', additionalParams: params); // No language for changes API
  }
}

/// All endpoints related to Movie Collections.
abstract class TmdbCollectionEndpoints {
  /// GET /3/collection/{collection_id} - Get collection details by ID.
  static String details(int collectionId, {String language = 'en-US'}) => _buildUrl('/collection/$collectionId', language: language);

  /// GET /3/collection/{collection_id}/images - Get the images that belong to a collection.
  static String images(int collectionId) => _buildUrl('/collection/$collectionId/images', language: '');

  /// GET /3/collection/{collection_id}/translations - Get the translations of a collection.
  static String translations(int collectionId) => _buildUrl('/collection/$collectionId/translations', language: '');
}

/// All endpoints related to Production Companies.
abstract class TmdbCompanyEndpoints {
  /// GET /3/company/{company_id} - Get the company details by ID.
  static String details(int companyId) => _buildUrl('/company/$companyId');

  /// GET /3/company/{company_id}/alternative_names - Get the alternative names of a company.
  static String alternativeNames(int companyId) => _buildUrl('/company/$companyId/alternative_names', language: '');

  /// GET /3/company/{company_id}/images - Get the company logos by id.
  static String images(int companyId) => _buildUrl('/company/$companyId/images', language: '');
}

/// All endpoints for retrieving Credit details (for cast/crew).
abstract class TmdbCreditEndpoints {
  /// GET /3/credit/{credit_id} - Retrieve the details of a movie or TV credit.
  static String details(String creditId) => _buildUrl('/credit/$creditId');
}

/// All endpoints for finding data by external IDs (e.g., IMDb ID, TVDB ID).
abstract class TmdbFindEndpoints {
  /// GET /3/find/{external_id} - Find data by external ID's.
  /// [externalSource] is the source of the ID (e.g., 'imdb_id', 'tvdb_id', 'facebook_id', 'twitter_id').
  static String byId(String externalId, String externalSource, {String language = 'en-US', bool includeAdult = false}) =>
      _buildUrl('/find/$externalId', language: language, additionalParams: {
        'external_source': externalSource,
        'include_adult': includeAdult,
      });
}

/// All endpoints for retrieving Genre lists (Movie and TV).
abstract class TmdbGenreEndpoints {
  /// GET /3/genre/movie/list - Get the list of official genres for movies.
  static String movieGenres({String language = 'en-US'}) => _buildUrl('/genre/movie/list', language: language);

  /// GET /3/genre/tv/list - Get the list of official genres for TV shows.
  static String tvGenres({String language = 'en-US'}) => _buildUrl('/genre/tv/list', language: language);
}

/// All endpoints related to Guest Sessions (for unauthenticated rating/actions).
abstract class TmdbGuestSessionEndpoints {
  /// GET /3/guest_session/{guest_session_id}/rated/movies - Get the rated movies for a guest session.
  static String ratedMovies(String guestSessionId, {String language = 'en-US', int page = 1, String sortBy = 'created_at.asc'}) =>
      _buildUrl('/guest_session/$guestSessionId/rated/movies', language: language, includeApiKey: false, additionalParams: {
        'page': page,
        'sort_by': sortBy,
      });

  /// GET /3/guest_session/{guest_session_id}/rated/tv - Get the rated TV shows for a guest session.
  static String ratedTv(String guestSessionId, {String language = 'en-US', int page = 1, String sortBy = 'created_at.asc'}) =>
      _buildUrl('/guest_session/$guestSessionId/rated/tv', language: language, includeApiKey: false, additionalParams: {
        'page': page,
        'sort_by': sortBy,
      });

  /// GET /3/guest_session/{guest_session_id}/rated/tv/episodes - Get the rated TV episodes for a guest session.
  static String ratedTvEpisodes(String guestSessionId, {String language = 'en-US', int page = 1, String sortBy = 'created_at.asc'}) =>
      _buildUrl('/guest_session/$guestSessionId/rated/tv/episodes', language: language, includeApiKey: false, additionalParams: {
        'page': page,
        'sort_by': sortBy,
      });
}

/// All endpoints related to Keywords.
abstract class TmdbKeywordEndpoints {
  /// GET /3/keyword/{keyword_id} - Get keyword details by ID.
  static String details(int keywordId) => _buildUrl('/keyword/$keywordId');

  /// GET /3/keyword/{keyword_id}/movies - Get the movies that belong to a keyword.
  static String movies(int keywordId, {bool includeAdult = false, String language = 'en-US', int page = 1}) =>
      _buildUrl('/keyword/$keywordId/movies', language: language, additionalParams: {
        'include_adult': includeAdult,
        'page': page,
      });
}

/// All endpoints related to Custom Lists created by users.
abstract class TmdbListEndpoints {
  /// GET /3/list/{list_id} - Get list details by ID.
  static String details(int listId, {String language = 'en-US', int page = 1}) =>
      _buildUrl('/list/$listId', language: language, additionalParams: {'page': page});

  /// DELETE /3/list/{list_id} - Delete a list. (Requires session ID in query, Authorization header for v4 token)
  static String delete(int listId, {required String sessionId}) =>
      _buildUrl('/list/$listId', includeApiKey: false, language: '', additionalParams: {'session_id': sessionId});

  /// GET /3/list/{list_id}/item_status - Use this method to check if an item has already been added to the list.
  /// [mediaType] can be 'movie' or 'tv'.
  static String checkItemStatus(int listId, {required int mediaId, required String mediaType}) =>
      _buildUrl('/list/$listId/item_status', language: '', additionalParams: {
        'media_id': mediaId,
        'media_type': mediaType,
      });
}

/// All endpoints related to People (Actors, Directors, etc.).
abstract class TmdbPersonEndpoints {
  /// GET /3/person/{person_id} - Query the top level details of a person.
  static String details(int personId, {String language = 'en-US'}) => _buildUrl('/person/$personId', language: language);

  /// GET /3/person/{person_id}/changes - Get the recent changes for a person.
  static String changes(int personId, {String? startDate, String? endDate, int page = 1}) {
    Map<String, dynamic> params = {'page': page};
    if (startDate != null) params['start_date'] = startDate;
    if (endDate != null) params['end_date'] = endDate;
    return _buildUrl('/person/$personId/changes', language: '', additionalParams: params);
  }

  /// GET /3/person/{person_id}/images - Get the profile images that belong to a person.
  static String images(int personId) => _buildUrl('/person/$personId/images', language: '');

  /// GET /3/person/{person_id}/movie_credits - Get the movie credits for a person.
  static String movieCredits(int personId, {String language = 'en-US'}) => _buildUrl('/person/$personId/movie_credits', language: language);

  /// GET /3/person/{person_id}/tv_credits - Get the TV credits that belong to a person.
  static String tvCredits(int personId, {String language = 'en-US'}) => _buildUrl('/person/$personId/tv_credits', language: language);

  /// GET /3/person/{person_id}/combined_credits - Get the combined movie and TV credits that belong to a person.
  static String combinedCredits(int personId, {String language = 'en-US'}) => _buildUrl('/person/$personId/combined_credits', language: language);

  /// GET /3/person/{person_id}/external_ids - Get the external ID's that belong to a person.
  static String externalIds(int personId) => _buildUrl('/person/$personId/external_ids', language: '');

  /// GET /3/person/{person_id}/tagged_images - Get the tagged images for a person.
  static String taggedImages(int personId, {int page = 1}) => _buildUrl('/person/$personId/tagged_images', language: '', additionalParams: {'page': page});

  /// GET /3/person/popular - Get a list of people ordered by popularity.
  static String popular({String language = 'en-US', int page = 1}) =>
      _buildUrl('/person/popular', language: language, additionalParams: {'page': page});
}

/// All endpoints related to Watch Providers (OTT/streaming services).
abstract class TmdbWatchProviderEndpoints {
  /// GET /3/watch/providers/regions - Get the list of the countries we have watch provider (OTT/streaming) data for.
  static String regions({String language = 'en-US'}) => _buildUrl('/watch/providers/regions', language: language);

  /// GET /3/watch/providers/movie - Get the list of streaming providers we have for movies.
  /// [watchRegion] is the 2-letter ISO 3166-1 country code (e.g., 'US', 'AE').
  static String movieProviders({String language = 'en-US', required String watchRegion}) =>
      _buildUrl('/watch/providers/movie', language: language, additionalParams: {'watch_region': watchRegion});

  /// GET /3/watch/providers/tv - Get the list of streaming providers we have for TV shows.
  /// [watchRegion] is the 2-letter ISO 3166-1 country code (e.g., 'US', 'AE').
  static String tvProviders({String language = 'en-US', required String watchRegion}) =>
      _buildUrl('/watch/providers/tv', language: language, additionalParams: {'watch_region': watchRegion});
}