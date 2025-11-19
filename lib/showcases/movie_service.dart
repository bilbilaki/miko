import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http;
import 'package:miko/configs/consts2.dart';
import 'model.dart';

class MovieService {
  static const String _baseUrl =
      'https://linod.worker-inosuke.workers.dev/3';
  static const String _apiKey =
      tmdbapitokensc;

  final http.Client _client;
  MovieService({http.Client? client}) : _client = client ?? http.Client();

  Map<String, String> get _headers => {
        'Authorization': 'Bearer $_apiKey',
        'Accept': 'application/json',
      };

  Future<Map<String, Object>> mtom(id) async {
    final results = await getMovieDetailsWithCredits(movieId: id);
    return {
      'details': results[0] as Movie,
      'credits': results[1] as MovieCredits,
      'recommendations': results[2] as MovieResponse,
    };
  }

  Future<Movie> mtm(id) async {
    final results = await getMovieDetails(movieId: id);
    return results;
    //   Future<Movie> movieToMovie(movie) async {
    //     movie = await getMovieDetails(movieId: results.id);
    //     return movie;
    //   }
    //  final nm = await movieToMovie(results);

    //   return nm;
  }

  Future<TvShow> tmtm(id) async {
    final results = await getTvShowDetails(tvShowId: id);
    return results;

    // Future<TvShow> tTT(tvs) async {
    //   tvs = await getTvShowDetails(tvShowId: results.id);
    //   return movie;
    // }

    // final nm = await movieToMovie(results);

    // return nm;
  }

  Future<MovieResponse> getPopularMovies(
      {int page = 1, String language = 'en-US'}) async {
    try {
      final url =
          Uri.parse('$_baseUrl/movie/popular?language=$language&page=$page&include_adult=true');

      final response = await _client.get(url, headers: _headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return MovieResponse.fromJson(data);
      } else {
        throw Exception('Failed to load movies: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching movies: $e');
    }
  }

  Future<Movie> getMovieDetails(
      {required int movieId, String language = 'en-US'}) async {
      final url = Uri.parse('$_baseUrl/movie/$movieId?language=$language&include_adult=true');

      final response = await _client.get(url, headers: _headers);
     // if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Movie.fromJson(data);
      
  }

  Future<MovieCredits> getMovieCredits(
      {required int movieId, String language = 'en-US'}) async {
    try {
      final url =
          Uri.parse('$_baseUrl/movie/$movieId/credits?language=$language&include_adult=true');

      final response = await _client.get(url, headers: _headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return MovieCredits.fromJson(data);
      } else {
        throw Exception('Failed to load movie credits: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching movie credits: $e');
    }
  }

  Future<Person> getPersonDetails(
      {required int personId, String language = 'en-US'}) async {
    try {
      final url = Uri.parse('$_baseUrl/person/$personId?language=$language&include_adult=true');

      final response = await _client.get(url, headers: _headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Person.fromJson(data);
      } else {
        throw Exception(
            'Failed to load person details: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching person details: $e');
    }
  }

  // Helper method to get both movie details and credits in parallel
  Future<MovieResponse> getMovieRecommendations(
      {required int movieId, int page = 1, String language = 'en-US'}) async {
    try {
      final url = Uri.parse(
          '$_baseUrl/movie/$movieId/recommendations?language=$language&page=$page&include_adult=true');

      final response = await _client.get(url, headers: _headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return MovieResponse.fromJson(data);
      } else {
        throw Exception(
            'Failed to load movie recommendations: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching movie recommendations: $e');
    }
  }

  Future<Map<String, dynamic>> getMovieDetailsWithCredits(
      {required int movieId, String language = 'en-US'}) async {
    try {
      final detailsFuture =
          getMovieDetails(movieId: movieId, language: language);
      final creditsFuture =
          getMovieCredits(movieId: movieId, language: language);
      final recommendationsFuture =
          getMovieRecommendations(movieId: movieId, language: language);

      final results = await Future.wait(
          [detailsFuture, creditsFuture, recommendationsFuture]);

      return {
        'details': results[0] as Movie,
        'credits': results[1] as MovieCredits,
        'recommendations': results[2] as MovieResponse,
      };
    } catch (e) {
      throw Exception('Error fetching movie data: $e');
    }
  }

  Future<TvShowResponse> getPopularTvShows(
      {int page = 1, String language = 'en-US'}) async {
    try {
      final url =
          Uri.parse('$_baseUrl/tv/popular?language=$language&page=$page&include_adult=true');

      final response = await _client.get(url, headers: _headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return TvShowResponse.fromJson(data);
      } else {
        throw Exception('Failed to load TV shows: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching TV shows: $e');
    }
  }

  Future<TvShowResponse> getTvShowRecommendations(
      {required int tvShowId, int page = 1, String language = 'en-US'}) async {
    try {
      final url = Uri.parse(
          '$_baseUrl/tv/$tvShowId/recommendations?language=$language&page=$page&include_adult=true');

      final response = await _client.get(url, headers: _headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return TvShowResponse.fromJson(data);
      } else {
        throw Exception(
            'Failed to load TV show recommendations: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching TV show recommendations: $e');
    }
  }

  Future<Map<String, dynamic>> getTvShowDetailsWithRecommendations(
      {required int tvShowId, String language = 'en-US'}) async {
    try {
      final detailsFuture =
          getTvShowDetails(tvShowId: tvShowId, language: language);
      final recommendationsFuture =
          getTvShowRecommendations(tvShowId: tvShowId, language: language);

      final results = await Future.wait([detailsFuture, recommendationsFuture]);

      return {
        'details': results[0] as TvShow,
        'recommendations': results[1] as TvShowResponse,
      };
    } catch (e) {
      throw Exception('Error fetching TV show data: $e');
    }
  }

  Future<TvShow> getTvShowDetails(
      {required int tvShowId, String language = 'en-US'}) async {
    try {
      final url = Uri.parse('$_baseUrl/tv/$tvShowId?language=$language&include_adult=true');

      final response = await _client.get(url, headers: _headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return TvShow.fromJson(data);
      } else {
        throw Exception(
            'Failed to load TV show details: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching TV show details: $e');
    }
  }

  Future<SeasonDetails> getTvShowSeasonDetails({
    required int tvShowId,
    required int seasonNumber,
    String language = 'en-US',
  }) async {
    try {
      final url = Uri.parse(
          '$_baseUrl/tv/$tvShowId/season/$seasonNumber?language=$language&include_adult=true');

      final response = await _client.get(url, headers: _headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return SeasonDetails.fromJson(data);
      } else {
        throw Exception(
            'Failed to load TV show season details: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching TV show season details: $e');
    }
  }

  Future<YoutubeVideoForSeries> getTvShowVideos({
    required int tvShowId,
    String language = 'en-US',
  }) async {
    try {
      final url = Uri.parse('$_baseUrl/tv/$tvShowId/videos?language=$language&include_adult=true');

      final response = await _client.get(url, headers: _headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return YoutubeVideoForSeries.fromJson(data);
      } else {
        throw Exception(
            'Failed to load TV show videos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching TV show videos: $e');
    }
  }

  Future<EpisodeDetails> getTvShowEpisodeDetails({
    required int tvShowId,
    required int seasonNumber,
    required int episodeNumber,
    String language = 'en-US',
  }) async {
    try {
      final url = Uri.parse(
          '$_baseUrl/tv/$tvShowId/season/$seasonNumber/episode/$episodeNumber?language=$language&include_adult=true');

      final response = await _client.get(url, headers: _headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return EpisodeDetails.fromJson(data);
      } else {
        throw Exception(
            'Failed to load TV show episode details: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching TV show episode details: $e');
    }
  }

  Future<SearchResponse> searchMovies({
    required String query,
    bool includeAdult = true,
    String language = 'en-US',
    int page = 1,
    String? region,
    int? year,
  }) async {
    try {
      // Prepare query parameters
      final Map<String, dynamic> queryParams = {
        'query': query,
        'include_adult': 'true',
        'language': language,
        'page': page.toString(),
      };

      // Add optional parameters if provided
      if (region != null) queryParams['region'] = region;
      if (year != null) queryParams['year'] = year.toString();

      // Construct the URL
      final url = Uri.parse('$_baseUrl/search/movie').replace(
        queryParameters:
            queryParams.map((key, value) => MapEntry(key, value.toString())),
      );

      // Make the API call
      final response = await _client.get(url, headers: _headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return SearchResponse.fromJson(data);
      } else {
        throw Exception('Failed to search movies: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching movies: $e');
    }
  }

  Future<MultiSearchResponse> multiSearch({
    required String query,
    bool includeAdult = true,
    String language = 'en-US',
    int page = 1,
  }) async {
    try {
      final queryParams = {
        'query': query,
        'include_adult': 'true',
        'language': language,
        'page': page.toString(),
      };

      final url = Uri.parse('$_baseUrl/search/multi').replace(
        queryParameters: queryParams,
      );

      final response = await _client.get(url, headers: _headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return MultiSearchResponse.fromJson(data);
      } else {
        throw Exception(
            'Failed to perform multi-search: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error performing multi-search: $e');
    }
  }

  // Keyword Search Method
  Future<KeywordSearchResponse> searchKeywords({
    required String query,
    int page = 1,
  }) async {
    try {
      final queryParams = {
        'query': query,
        'page': page.toString(),
      };

      final url = Uri.parse('$_baseUrl/search/keyword').replace(
        queryParameters: queryParams,
      );

      final response = await _client.get(url, headers: _headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return KeywordSearchResponse.fromJson(data);
      } else {
        throw Exception('Failed to search keywords: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching keywords: $e');
    }
  }

  // Keyword Movies Method
  Future<KeywordMoviesResponse> getMoviesByKeyword({
    required int keywordId,
    bool includeAdult = true,
    String language = 'en-US',
    int page = 1,
  }) async {
    try {
      final queryParams = {
        'include_adult': true,
        'language': language,
        'page': page.toString(),
      };

      final url = Uri.parse('$_baseUrl/keyword/$keywordId/movies').replace(
        queryParameters: queryParams,
      );

      final response = await _client.get(url, headers: _headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return KeywordMoviesResponse.fromJson(data);
      } else {
        throw Exception(
            'Failed to get movies by keyword: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting movies by keyword: $e');
    }
  }

  // TV Search Method
  Future<TVSearchResponse> searchTV({
    required String query,
    bool includeAdult = false,
    String language = 'en-US',
    int page = 1,
  }) async {
    try {
      final queryParams = {
        'query': query,
        'include_adult': 'true',
        'language': language,
        'page': page.toString(),
      };

      final url = Uri.parse('$_baseUrl/search/tv').replace(
        queryParameters: queryParams,
      );

      final response = await _client.get(url, headers: _headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return TVSearchResponse.fromJson(data);
      } else {
        throw Exception('Failed to search TV shows: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching TV shows: $e');
    }
  }

  // TV Credits Method
  Future<TVCredits> getTVCredits({
    required int tvId,
    String language = 'en-US',
  }) async {
    try {
      final queryParams = {
        'language': language,
                'include_adult': 'true',
      };

      final url = Uri.parse('$_baseUrl/tv/$tvId/credits').replace(
        queryParameters: queryParams,
      );

      final response = await _client.get(url, headers: _headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return TVCredits.fromJson(data);
      } else {
//         final response = await getMovieCredits(movieId: tvId, language: language);
// return TVCredits(
//           cast: response.cast,
//           crew: response.crew,
//         );
throw Exception('Error fetching TV credits: ');

      }
    } catch (e) {
throw Exception('Error fetching TV credits: $e');
    }

  }

  void dispose() {
    _client.close();
  }
}

/// Custom exception for TMDB API errors.
class TmdbApiException implements Exception {
  final int? statusCode;
  final String message;

  TmdbApiException(this.message, {this.statusCode});

  @override
  String toString() {
    return 'TmdbApiException: ${statusCode != null ? 'Status $statusCode - ' : ''}$message';
  }
}

/// A service class to interact with The Movie Database (TMDB) API.
// class TmdbApiService {
//   final http.Client _httpClient;
//   final Logger _logger;

//   TmdbApiService({http.Client? httpClient, Logger? logger})
//       : _httpClient = httpClient ?? http.Client(),
//         _logger = logger ??
//             Logger(
//               printer: PrettyPrinter(
//                 methodCount: 0, // No method calls to be displayed
//                 errorMethodCount:
//                     5, // Number of stacktrace lines to be displayed
//                 lineLength: 120, // Width of the output
//                 colors: true, // Colorful log messages
//                 printEmojis: true, // Print an emoji for each log message
//                 printTime: false, // Should each log message contain a timestamp
//               ),
//             );

//   Map<String, String> _getHeaders(
//       {bool requireAuth = true, bool contentTypeJson = false}) {
//     final headers = <String, String>{};
//     if (requireAuth) {
//       headers['Authorization'] = tmdbAuthToken;
//     }
//     if (contentTypeJson) {
//       headers['Content-Type'] = 'application/json;charset=utf-8';
//     }
//     headers['accept'] = 'application/json';
//     return headers;
//   }

//   Future<T> _get<T>(
//       String url, T Function(Map<String, dynamic>) fromJson) async {
//     _logger.i('GET: $url');
//     try {
//       final response = await _httpClient.get(
//         Uri.parse(url),
//         headers: _getHeaders(),
//       );
//       return _handleResponse<T>(response, fromJson);
//     } catch (e) {
//       _logger.e('HTTP GET error: $e');
//       throw TmdbApiException('Failed to perform GET request: $e');
//     }
//   }

//   Future<T> _post<T>(String url, Map<String, dynamic> body,
//       T Function(Map<String, dynamic>) fromJson) async {
//     _logger.i('POST: $url, Body: ${jsonEncode(body)}');
//     try {
//       final response = await _httpClient.post(
//         Uri.parse(url),
//         headers: _getHeaders(contentTypeJson: true),
//         body: jsonEncode(body),
//       );
//       return _handleResponse<T>(response, fromJson);
//     } catch (e) {
//       _logger.e('HTTP POST error: $e');
//       throw TmdbApiException('Failed to perform POST request: $e');
//     }
//   }

//   // Future<T> _delete<T>(String url, {Map<String, dynamic>? body, T Function(Map<String, dynamic>) fromJson = _defaultSuccessResponseFromJson}) async {
//   //   _logger.i('DELETE: $url, Body: ${body != null ? jsonEncode(body) : 'N/A'}');
//   //   try {
//   //     final response = await _httpClient.delete(
//   //       Uri.parse(url),
//   //       headers: _getHeaders(contentTypeJson: body != null),
//   //       body: body != null ? jsonEncode(body) : null,
//   //     );
//   //     return _handleResponse<T>(response, fromJson);
//   //   } catch (e) {
//   //     _logger.e('HTTP DELETE error: $e');
//   //     throw TmdbApiException('Failed to perform DELETE request: $e');
//   //   }
//   // }

//   T _handleResponse<T>(
//       http.Response response, T Function(Map<String, dynamic>) fromJson) {
//     if (response.statusCode == 200) {
//       final Map<String, dynamic> data = json.decode(response.body);
//       _logger
//           .d('Response Data: ${data.keys}'); // Log top-level keys for brevity
//       return fromJson(data);
//     } else {
//       _logger.e(
//           'API Error: Status ${response.statusCode}, Body: ${response.body}');
//       try {
//         final errorData = json.decode(response.body);
//         final statusMessage = errorData['status_message'] ?? 'Unknown error';
//         throw TmdbApiException(statusMessage, statusCode: response.statusCode);
//       } catch (e) {
//         throw TmdbApiException('Failed to parse error response: $e',
//             statusCode: response.statusCode);
//       }
//     }
//   }

//   // A default JSON parser for simple success responses like {"status_code": 1, "status_message": "Success."}
//   // This is used for POST/DELETE requests that don't return complex data.
//   static TmdbStatusResponse _defaultSuccessResponseFromJson(
//       Map<String, dynamic> json) {
//     return TmdbStatusResponse.fromJson(json);
//   }

//   // --- 1. Movie Search ---
//   Future<PagedResponse<MovieResult>> searchMovies({
//     required String query,
//     String language = 'en-US',
//     bool includeAdult = true,
//     int page = 1,
//   }) {
//     return _get(
//       TmdbSearchEndpoints.movie(
//         query: query,
//         language: language,
//         includeAdult: true,
//         page: page,
//       ),
//       (json) => PagedResponse.fromJson(json,
//           (itemJson) => MovieResult.fromJson(itemJson as Map<String, dynamic>)),
//     );
//   }

//   // --- 2. Movie Discover ---
//   Future<MovieResponse> discoverMovies({
//     String sortBy = 'popularity.desc',
//     String language = 'en-US',
//     int page = 1,
//     int? voteCountGte,
//     double? voteAverageGte,
//     String? withOriginalLanguage,
//     String? primaryReleaseYear,
//     List<int>? withKeywords,
//     List<int>? withCast,
//     List<int>? withCrew,
//     List<int>? withPeople,
//     int? withRuntimeGte,
//     int? withRuntimeLte,
//     bool? includeAdult,
//   }) async {
//     return _get(
//       TmdbMovieEndpoints.discover(
//         language: language,
//         sortBy: sortBy,
//         page: page,
//         voteCountGte: voteCountGte,
//         voteAverageGte: voteAverageGte,
//         withOriginalLanguage: withOriginalLanguage,
//         primaryReleaseYear: primaryReleaseYear,
//         withKeywords: withKeywords,
//         withCast: withCast,
//         withCrew: withCrew,
//         withPeople: withPeople,
//         withRuntimeGte: withRuntimeGte,
//         withRuntimeLte: withRuntimeLte,
//         includeAdult: true,
//       ),
//       //, (itemJson) => MovieResult.fromJson(itemJson as Map<String, dynamic>)

//       (json) => MovieResponse.fromJson(json),
//     );
//   }

//   // --- 3. Movie Details ---
//   Future<Movie> getMovieDetails(int movieId, {String language = 'en-US'}) {
//     return _get(
//       TmdbMovieEndpoints.details(movieId, language: language),
//       Movie.fromJson,
//     );
//   }

//   // --- 4. TV Series Details ---
//   Future<TvShow> getTvSeriesDetails(int seriesId, {String language = 'en-US'}) {
//     return _get(
//       TmdbTvEndpoints.details(seriesId, language: language),
//       TvShow.fromJson,
//     );
//   }

//   // --- 5. TV Search ---
//   Future<PagedResponse<TvShowResult>> searchTvShows({
//     required String query,
//     String language = 'en-US',
//     bool includeAdult = true,
//     int page = 1,
//   }) {
//     return _get(
//       TmdbSearchEndpoints.tv(
//         query: query,
//         language: language,
//         includeAdult: includeAdult,
//         page: page,
//       ),
//       (json) => PagedResponse.fromJson(
//           json,
//           (itemJson) =>
//               TvShowResult.fromJson(itemJson as Map<String, dynamic>)),
//     );
//   }

//   // --- 6. Multi Search ---
//   Future<PagedResponse<dynamic>> multiSearch({
//     // dynamic for now, can be refactored to a union type if common fields are minimal
//     required String query,
//     String language = 'en-US',
//     bool includeAdult = true,
//     int page = 1,
//   }) async {
//     // The results here can be MovieResult, TvShowResult, or PersonResult.
//     // Handling this requires a custom deserializer for the list of results.
//     return _get(
//       TmdbSearchEndpoints.multi(
//         query: query,
//         language: language,
//         includeAdult: true,
//         page: page,
//       ),
//       (json) => PagedResponse.fromJson(json, (itemJson) {
//         final Map<String, dynamic> itemMap = itemJson as Map<String, dynamic>;
//         switch (itemMap['media_type']) {
//           case 'movie':
//             return MovieResult.fromJson(itemMap);
//           case 'tv':
//             return TvShowResult.fromJson(itemMap);
//           case 'person':
//             return PersonResult.fromJson(itemMap);
//           default:
//             return itemMap; // Return raw map if type is unknown for simplicity
//         }
//       }),
//     );
//   }

//   // --- 7. Person Search ---
//   Future<PagedResponse<PersonResult>> searchPersons({
//     required String query,
//     String language = 'en-US',
//     bool includeAdult = true,
//     int page = 1,
//   }) {
//     return _get(
//       TmdbSearchEndpoints.person(
//         query: query,
//         language: language,
//         includeAdult: true,
//         page: page,
//       ),
//       (json) => PagedResponse.fromJson(
//           json,
//           (itemJson) =>
//               PersonResult.fromJson(itemJson as Map<String, dynamic>)),
//     );
//   }

//   // --- 8. Configuration Details ---
//   Future<TmdbConfiguration> getConfiguration() {
//     return _get(
//       TmdbConfigurationEndpoints.details(),
//       TmdbConfiguration.fromJson,
//     );
//   }

//   // --- 9. TV Season Details ---
//   Future<TvSeason> getTvSeasonDetails(int seriesId, int seasonNumber,
//       {String language = 'en-US'}) {
//     return _get(
//       TmdbTvSeasonEndpoints.details(seriesId, seasonNumber, language: language),
//       TvSeason.fromJson,
//     );
//   }

//   // --- 10. TV Episode Details ---
//   Future<TvEpisode> getTvEpisodeDetails(
//       int seriesId, int seasonNumber, int episodeNumber,
//       {String language = 'en-US'}) {
//     return _get(
//       TmdbTvEpisodeEndpoints.details(seriesId, seasonNumber, episodeNumber,
//           language: language),
//       TvEpisode.fromJson,
//     );
//   }

//   // --- 11. TV Discover ---
//   Future<TvShowResponse> discoverTvShows({
//     String sortBy = 'popularity.desc',
//     String language = 'en-US',
//     int page = 1,
//     int? voteCountGte,
//     double? voteAverageGte,
//     String? withOriginalLanguage,
//     String? firstAirDateYear,
//     List<int>? withKeywords,
//     List<int>? withCast,
//     List<int>? withCrew,
//     List<int>? withPeople,
//     int? withRuntimeGte,
//     int? withRuntimeLte,
//     bool? includeAdult,
//     String? withOriginCountry,
//   }) async {
//     return _get(
//       TmdbTvEndpoints.discover(
//         language: language,
//         sortBy: sortBy,
//         page: page,
//         voteCountGte: voteCountGte,
//         voteAverageGte: voteAverageGte,
//         withOriginalLanguage: withOriginalLanguage,
//         firstAirDateYear: firstAirDateYear,
//         withKeywords: withKeywords,
//         withCast: withCast,
//         withCrew: withCrew,
//         withPeople: withPeople,
//         withRuntimeGte: withRuntimeGte,
//         withRuntimeLte: withRuntimeLte,
//         includeAdult: true,
//         withOriginCountry: withOriginCountry,
//       ),
//       //, (itemJson) => TvShowResult.fromJson(itemJson as Map<String, dynamic>)
//       (json) => TvShowResponse.fromJson(json),
//     );
//   }

//   // --- 12. Movie Images ---
//   Future<ImageResponse> getMovieImages(int movieId) {
//     return _get(
//       TmdbMovieEndpoints.images(movieId),
//       ImageResponse.fromJson,
//     );
//   }

//   // --- 13. TV Series Images ---
//   Future<ImageResponse> getTvSeriesImages(int seriesId) {
//     return _get(
//       TmdbTvEndpoints.images(seriesId),
//       ImageResponse.fromJson,
//     );
//   }

//   // --- 14. TV Season Images ---
//   Future<ImageResponse> getTvSeasonImages(int seriesId, int seasonNumber) {
//     return _get(
//       TmdbTvSeasonEndpoints.images(seriesId, seasonNumber),
//       ImageResponse.fromJson,
//     );
//   }

//   // --- 15. TV Episode Images ---
//   Future<ImageResponse> getTvEpisodeImages(
//       int seriesId, int seasonNumber, int episodeNumber) {
//     return _get(
//       TmdbTvEpisodeEndpoints.images(seriesId, seasonNumber, episodeNumber),
//       ImageResponse.fromJson,
//     );
//   }

//   // --- 16. Trending All ---
//   Future<PagedResponse<dynamic>> getTrendingAll(String timeWindow,
//       {String language = 'en-US'}) {
//     return _get(
//       TmdbTrendingEndpoints.all(timeWindow, language: language),
//       (json) => PagedResponse.fromJson(json, (itemJson) {
//         final Map<String, dynamic> itemMap = itemJson as Map<String, dynamic>;
//         switch (itemMap['media_type']) {
//           case 'movie':
//             return MovieResult.fromJson(itemMap);
//           case 'tv':
//             return TvShowResult.fromJson(itemMap);
//           case 'person':
//             return PersonResult.fromJson(itemMap);
//           default:
//             return itemMap;
//         }
//       }),
//     );
//   }

//   // --- 17. Trending Movies ---
//   Future<PagedResponse<MovieResult>> getTrendingMovies(String timeWindow,
//       {String language = 'en-US'}) {
//     return _get(
//       TmdbTrendingEndpoints.movie(timeWindow, language: language),
//       (json) => PagedResponse.fromJson(json,
//           (itemJson) => MovieResult.fromJson(itemJson as Map<String, dynamic>)),
//     );
//   }

//   // --- 18. Trending TV ---
//   Future<PagedResponse<TvShowResult>> getTrendingTv(String timeWindow,
//       {String language = 'en-US'}) {
//     return _get(
//       TmdbTrendingEndpoints.tv(timeWindow, language: language),
//       (json) => PagedResponse.fromJson(
//           json,
//           (itemJson) =>
//               TvShowResult.fromJson(itemJson as Map<String, dynamic>)),
//     );
//   }

//   // --- 19. Movie Account States ---
//   Future<MediaAccountStates> getMovieAccountStates(int movieId,
//       {String? guestSessionId, String? sessionId}) {
//     return _get(
//       TmdbMovieEndpoints.accountStates(movieId,
//           guestSessionId: guestSessionId, sessionId: sessionId),
//       MediaAccountStates.fromJson,
//     );
//   }

//   // --- 20. TV Series Account States ---
//   Future<MediaAccountStates> getTvSeriesAccountStates(int seriesId,
//       {String? guestSessionId, String? sessionId}) {
//     return _get(
//       TmdbTvEndpoints.accountStates(seriesId,
//           guestSessionId: guestSessionId, sessionId: sessionId),
//       MediaAccountStates.fromJson,
//     );
//   }

//   // --- 21. TV Episode Account States ---
//   Future<MediaAccountStates> getTvEpisodeAccountStates(
//       int seriesId, int seasonNumber, int episodeNumber,
//       {String? guestSessionId, String? sessionId}) {
//     return _get(
//       TmdbTvEpisodeEndpoints.accountStates(
//           seriesId, seasonNumber, episodeNumber,
//           guestSessionId: guestSessionId, sessionId: sessionId),
//       MediaAccountStates.fromJson,
//     );
//   }

//   // --- 22. Trending People ---
//   Future<PagedResponse<PersonResult>> getTrendingPeople(String timeWindow,
//       {String language = 'en-US'}) {
//     return _get(
//       TmdbTrendingEndpoints.person(timeWindow, language: language),
//       (json) => PagedResponse.fromJson(
//           json,
//           (itemJson) =>
//               PersonResult.fromJson(itemJson as Map<String, dynamic>)),
//     );
//   }

//   // --- 23. Movie Alternative Titles ---
//   Future<MovieAlternativeTitlesResponse> getMovieAlternativeTitles(
//       int movieId) {
//     return _get(
//       TmdbMovieEndpoints.alternativeTitles(movieId),
//       MovieAlternativeTitlesResponse.fromJson,
//     );
//   }

//   // --- 24. Movie Changes ---
//   Future<ChangesResponse> getMovieChanges(int movieId,
//       {String? startDate, String? endDate}) {
//     return _get(
//       TmdbMovieEndpoints.changes(movieId,
//           startDate: startDate, endDate: endDate),
//       ChangesResponse.fromJson,
//     );
//   }

//   // --- 25. Movie Credits ---
//   Future<CreditsResponse> getMovieCredits(int movieId,
//       {String language = 'en-US'}) {
//     return _get(
//       TmdbMovieEndpoints.credits(movieId, language: language),
//       CreditsResponse.fromJson,
//     );
//   }

//   // --- 26. Movie External IDs ---
//   Future<MovieExternalIds> getMovieExternalIds(int movieId) {
//     return _get(
//       TmdbMovieEndpoints.externalIds(movieId),
//       MovieExternalIds.fromJson,
//     );
//   }

//   // --- 27. Movie Keywords ---
//   Future<KeywordsResponse> getMovieKeywords(int movieId) {
//     return _get(
//       TmdbMovieEndpoints.keywords(movieId),
//       KeywordsResponse.fromJson,
//     );
//   }

//   // --- 28. Movie Lists ---
//   Future<PagedResponse<TmdbList>> getMovieLists(int movieId,
//       {String language = 'en-US', int page = 1}) {
//     return _get(
//       TmdbMovieEndpoints.lists(movieId, language: language, page: page),
//       (json) => PagedResponse.fromJson(json,
//           (itemJson) => TmdbList.fromJson(itemJson as Map<String, dynamic>)),
//     );
//   }

//   // --- 29. Movie Recommendations ---
//   Future<PagedResponse<MovieResult>> getMovieRecommendations(int movieId,
//       {String language = 'en-US', int page = 1}) {
//     return _get(
//       TmdbMovieEndpoints.recommendations(movieId,
//           language: language, page: page),
//       (json) => PagedResponse.fromJson(json,
//           (itemJson) => MovieResult.fromJson(itemJson as Map<String, dynamic>)),
//     );
//   }

//   // --- 30. Movie Release Dates ---
//   Future<MovieReleaseDatesResponse> getMovieReleaseDates(int movieId) {
//     return _get(
//       TmdbMovieEndpoints.releaseDates(movieId),
//       MovieReleaseDatesResponse.fromJson,
//     );
//   }

//   // --- 31. Movie Reviews ---
//   Future<PagedResponse<Review>> getMovieReviews(int movieId,
//       {String language = 'en-US', int page = 1}) {
//     return _get(
//       TmdbMovieEndpoints.reviews(movieId, language: language, page: page),
//       (json) => PagedResponse.fromJson(json,
//           (itemJson) => Review.fromJson(itemJson as Map<String, dynamic>)),
//     );
//   }

//   // --- 32. Movie Similar ---
//   Future<PagedResponse<MovieResult>> getMovieSimilar(int movieId,
//       {String language = 'en-US', int page = 1}) {
//     return _get(
//       TmdbMovieEndpoints.similar(movieId, language: language, page: page),
//       (json) => PagedResponse.fromJson(json,
//           (itemJson) => MovieResult.fromJson(itemJson as Map<String, dynamic>)),
//     );
//   }

//   // --- 33. Movie Translations ---
//   Future<TranslationsResponse> getMovieTranslations(int movieId) {
//     return _get(
//       TmdbMovieEndpoints.translations(movieId),
//       TranslationsResponse.fromJson,
//     );
//   }

//   // --- 34. Movie Videos ---
//   Future<VideoResponse> getMovieVideos(int movieId,
//       {String language = 'en-US'}) {
//     return _get(
//       TmdbMovieEndpoints.videos(movieId, language: language),
//       VideoResponse.fromJson,
//     );
//   }

//   // --- 35. Movie Watch Providers ---
//   Future<WatchProvidersResponse> getMovieWatchProviders(int movieId) {
//     return _get(
//       TmdbMovieEndpoints.watchProviders(movieId),
//       WatchProvidersResponse.fromJson,
//     );
//   }

//   // --- 36. Movie Add Rating ---
//   Future<TmdbStatusResponse> addMovieRating(int movieId, double value,
//       {String? guestSessionId, String? sessionId}) {
//     return _post(
//       TmdbMovieEndpoints.rating(movieId,
//           guestSessionId: guestSessionId, sessionId: sessionId),
//       {'value': value},
//       _defaultSuccessResponseFromJson,
//     );
//   }

//   // --- 37. Movie Delete Rating ---
//   // Future<TmdbStatusResponse> deleteMovieRating(int movieId, {String? guestSessionId, String? sessionId}) {
//   //   return _delete(
//   //     TmdbMovieEndpoints.rating(movieId, guestSessionId: guestSessionId, sessionId: sessionId),
//   //     fromJson: _defaultSuccessResponseFromJson,
//   //   );
//   // }

//   // --- 38. Authentication Create Guest Session ---
//   Future<GuestSession> createGuestSession() {
//     return _get(
//       TmdbAuthEndpoints.createGuestSession(),
//       GuestSession.fromJson,
//     );
//   }

//   // --- 39. Authentication Create Request Token ---
//   Future<RequestToken> createRequestToken() {
//     return _get(
//       TmdbAuthEndpoints.createRequestToken(),
//       RequestToken.fromJson,
//     );
//   }

//   // --- 40. Authentication Create Session ---
//   Future<UserSession> createSession(String requestToken) {
//     return _post(
//       TmdbAuthEndpoints.createSession(),
//       {'request_token': requestToken},
//       UserSession.fromJson,
//     );
//   }

//   // --- 41. Authentication Create Session from v4 token ---
//   Future<UserSession> createSessionFromV4(String accessToken) {
//     return _post(
//       TmdbAuthEndpoints.createSessionFromV4(),
//       {'access_token': accessToken},
//       UserSession.fromJson,
//     );
//   }

//   // --- 42. Authentication Delete Session ---
//   // Future<TmdbStatusResponse> deleteSession(String sessionId) {
//   //   return _delete(
//   //     TmdbAuthEndpoints.deleteSession(),
//   //     body: {'session_id': sessionId},
//   //     fromJson: _defaultSuccessResponseFromJson,
//   //   );
//   // }

//   // --- 43. Find By ID ---
//   Future<FindByIdResponse> findById(String externalId, String externalSource,
//       {String language = 'en-US', bool includeAdult = false}) {
//     return _get(
//       TmdbFindEndpoints.byId(externalId, externalSource,
//           language: language, includeAdult: includeAdult),
//       FindByIdResponse.fromJson,
//     );
//   }

//   // --- 44. Person Details ---
//   Future<Person> getPersonDetails(int personId, {String language = 'en-US'}) {
//     return _get(
//       TmdbPersonEndpoints.details(personId, language: language),
//       Person.fromJson,
//     );
//   }

//   // --- 45. Person Changes ---
//   Future<ChangesResponse> getPersonChanges(int personId,
//       {String? startDate, String? endDate, int page = 1}) {
//     return _get(
//       TmdbPersonEndpoints.changes(personId,
//           startDate: startDate, endDate: endDate, page: page),
//       ChangesResponse.fromJson,
//     );
//   }

//   // --- 46. TV Series Changes ---
//   // Future<ChangesResponse> getTvSeriesChanges(int seriesId, {String? startDate, String? endDate, int page = 1}) {
//   //   return _get(
//   //     TmdbTvEndpoints.(seriesId, startDate: startDate, endDate: endDate, page: page),
//   //     ChangesResponse.fromJson,
//   //   );
//   // }

//   // --- 47. Person Images ---
//   Future<PersonImagesResponse> getPersonImages(int personId) {
//     return _get(
//       TmdbPersonEndpoints.images(personId),
//       PersonImagesResponse.fromJson,
//     );
//   }

//   // --- 48. Person Movie Credits ---
//   Future<PersonMovieCredits> getPersonMovieCredits(int personId,
//       {String language = 'en-US'}) {
//     return _get(
//       TmdbPersonEndpoints.movieCredits(personId, language: language),
//       PersonMovieCredits.fromJson,
//     );
//   }

//   // --- 49. Person TV Credits ---
//   Future<PersonTvCredits> getPersonTvCredits(int personId,
//       {String language = 'en-US'}) {
//     return _get(
//       TmdbPersonEndpoints.tvCredits(personId, language: language),
//       PersonTvCredits.fromJson,
//     );
//   }

//   // --- 50. Person Combined Credits ---
//   Future<PersonCombinedCredits> getPersonCombinedCredits(int personId,
//       {String language = 'en-US'}) {
//     return _get(
//       TmdbPersonEndpoints.combinedCredits(personId, language: language),
//       PersonCombinedCredits.fromJson,
//     );
//   }

//   // --- 51. Person External IDs ---
//   Future<PersonExternalIds> getPersonExternalIds(int personId) {
//     return _get(
//       TmdbPersonEndpoints.externalIds(personId),
//       PersonExternalIds.fromJson,
//     );
//   }

//   // --- 52. Person Tagged Images ---
//   Future<PagedResponse<TaggedImageResult>> getPersonTaggedImages(int personId,
//       {int page = 1}) {
//     return _get(
//       TmdbPersonEndpoints.taggedImages(personId, page: page),
//       (json) => PagedResponse.fromJson(
//           json,
//           (itemJson) =>
//               TaggedImageResult.fromJson(itemJson as Map<String, dynamic>)),
//     );
//   }

//   // --- 53. Person Popular List ---
//   Future<PagedResponse<PersonResult>> getPopularPeople(
//       {String language = 'en-US', int page = 1}) {
//     return _get(
//       TmdbPersonEndpoints.popular(language: language, page: page),
//       (json) => PagedResponse.fromJson(
//           json,
//           (itemJson) =>
//               PersonResult.fromJson(itemJson as Map<String, dynamic>)),
//     );
//   }

//   // --- 54. Movie Popular List ---
//   Future<PagedResponse<MovieResult>> getPopularMovies(
//       {String language = 'en-US', int page = 1}) {
//     return _get(
//       TmdbMovieEndpoints.popular,
//       (json) => PagedResponse.fromJson(json,
//           (itemJson) => MovieResult.fromJson(itemJson as Map<String, dynamic>)),
//     );
//   }

//   // --- 55. Movie Top Rated List ---
//   Future<PagedResponse<MovieResult>> getTopRatedMovies(
//       {String language = 'en-US', int page = 1}) {
//     return _get(
//       TmdbMovieEndpoints.topRated,
//       (json) => PagedResponse.fromJson(json,
//           (itemJson) => MovieResult.fromJson(itemJson as Map<String, dynamic>)),
//     );
//   }

//   // --- 56. Movie Upcoming List ---
//   Future<MovieUpcomingResponse> getUpcomingMovies(
//       {String language = 'en-US', int page = 1}) {
//     return _get(
//       TmdbMovieEndpoints.upcoming,
//       MovieUpcomingResponse.fromJson,
//     );
//   }

//   // --- 57. Movie Now Playing List ---
//   Future<MovieNowPlayingResponse> getNowPlayingMovies(
//       {String language = 'en-US', int page = 1}) {
//     return _get(
//       TmdbMovieEndpoints.nowPlaying,
//       MovieNowPlayingResponse.fromJson,
//     );
//   }

//   // --- 58. TV Series Airing Today List ---
//   Future<PagedResponse<TvShowResult>> getTvSeriesAiringToday(
//       {String language = 'en-US', int page = 1}) {
//     return _get(
//       TmdbTvEndpoints.airingToday(language: language, page: page),
//       (json) => PagedResponse.fromJson(
//           json,
//           (itemJson) =>
//               TvShowResult.fromJson(itemJson as Map<String, dynamic>)),
//     );
//   }

//   // --- 59. TV Series Popular List ---
//   Future<PagedResponse<TvShowResult>> getPopularTvSeries(
//       {String language = 'en-US', int page = 1}) {
//     return _get(
//       TmdbTvEndpoints.popular(language: language, page: page),
//       (json) => PagedResponse.fromJson(
//           json,
//           (itemJson) =>
//               TvShowResult.fromJson(itemJson as Map<String, dynamic>)),
//     );
//   }

//   // --- 60. TV Series Top Rated List ---
//   Future<PagedResponse<TvShowResult>> getTopRatedTvSeries(
//       {String language = 'en-US', int page = 1}) {
//     return _get(
//       TmdbTvEndpoints.topRated(language: language, page: page),
//       (json) => PagedResponse.fromJson(
//           json,
//           (itemJson) =>
//               TvShowResult.fromJson(itemJson as Map<String, dynamic>)),
//     );
//   }

//   // --- 61. Movie Latest ID ---
//   Future<MovieLatest> getLatestMovie() {
//     return _get(
//       TmdbMovieEndpoints.latest(),
//       MovieLatest.fromJson,
//     );
//   }

//   // --- 62. TV Series Latest ID ---
//   Future<TvSeriesLatest> getLatestTvSeries() {
//     return _get(
//       TmdbTvEndpoints.latest(),
//       TvSeriesLatest.fromJson,
//     );
//   }

//   // --- 63. TV Series Aggregate Credits ---
//   Future<AggregateCreditsResponse> getTvSeriesAggregateCredits(int seriesId,
//       {String language = 'en-US'}) {
//     return _get(
//       TmdbTvEndpoints.aggregateCredits(seriesId, language: language),
//       AggregateCreditsResponse.fromJson,
//     );
//   }

//   // --- 64. TV Series Alternative Titles ---
//   Future<TvAlternativeTitlesResponse> getTvSeriesAlternativeTitles(
//       int seriesId) {
//     return _get(
//       TmdbTvEndpoints.alternativeTitles(seriesId),
//       TvAlternativeTitlesResponse.fromJson,
//     );
//   }

//   // --- 65. TV Series Content Ratings ---
//   Future<TvContentRatingsResponse> getTvSeriesContentRatings(int seriesId) {
//     return _get(
//       TmdbTvEndpoints.contentRatings(seriesId),
//       TvContentRatingsResponse.fromJson,
//     );
//   }

//   // --- 66. TV Series Credits ---
//   Future<CreditsResponse> getTvSeriesCredits(int seriesId,
//       {String language = 'en-US'}) {
//     return _get(
//       TmdbTvEndpoints.credits(seriesId, language: language),
//       CreditsResponse.fromJson,
//     );
//   }

//   // --- 67. TV Series Episode Groups ---
//   Future<TvEpisodeGroupsResponse> getTvSeriesEpisodeGroups(int seriesId) {
//     return _get(
//       TmdbTvEndpoints.episodeGroups(seriesId),
//       TvEpisodeGroupsResponse.fromJson,
//     );
//   }

//   // --- 68. TV Series External IDs ---
//   Future<TvExternalIds> getTvSeriesExternalIds(int seriesId) {
//     return _get(
//       TmdbTvEndpoints.externalIds(seriesId),
//       TvExternalIds.fromJson,
//     );
//   }

//   // --- 69. TV Series Keywords ---
//   Future<KeywordsResponse> getTvSeriesKeywords(int seriesId) {
//     return _get(
//       TmdbTvEndpoints.keywords(seriesId),
//       KeywordsResponse.fromJson,
//     );
//   }

//   // --- 70. TV Series Recommendations ---
//   Future<PagedResponse<TvShowResult>> getTvSeriesRecommendations(int seriesId,
//       {String language = 'en-US', int page = 1}) {
//     return _get(
//       TmdbTvEndpoints.recommendations(seriesId, language: language, page: page),
//       (json) => PagedResponse.fromJson(
//           json,
//           (itemJson) =>
//               TvShowResult.fromJson(itemJson as Map<String, dynamic>)),
//     );
//   }

//   // --- 71. TV Series Reviews ---
//   Future<PagedResponse<Review>> getTvSeriesReviews(int seriesId,
//       {String language = 'en-US', int page = 1}) {
//     return _get(
//       TmdbTvEndpoints.reviews(seriesId, language: language, page: page),
//       (json) => PagedResponse.fromJson(json,
//           (itemJson) => Review.fromJson(itemJson as Map<String, dynamic>)),
//     );
//   }

//   // --- 72. TV Series Screened Theatrically ---
//   Future<TvScreenedTheatricallyResponse> getTvSeriesScreenedTheatrically(
//       int seriesId) {
//     return _get(
//       TmdbTvEndpoints.screenedTheatrically(seriesId),
//       TvScreenedTheatricallyResponse.fromJson,
//     );
//   }

//   // --- 73. TV Series Similar ---
//   Future<PagedResponse<TvShowResult>> getTvSeriesSimilar(int seriesId,
//       {String language = 'en-US', int page = 1}) {
//     return _get(
//       TmdbTvEndpoints.similar(seriesId, language: language, page: page),
//       (json) => PagedResponse.fromJson(
//           json,
//           (itemJson) =>
//               TvShowResult.fromJson(itemJson as Map<String, dynamic>)),
//     );
//   }

//   // --- 74. TV Series Translations ---
//   Future<TranslationsResponse> getTvSeriesTranslations(int seriesId) {
//     return _get(
//       TmdbTvEndpoints.translations(seriesId),
//       TranslationsResponse.fromJson,
//     );
//   }

//   // --- 75. TV Series Videos ---
//   Future<VideoResponse> getTvSeriesVideos(int seriesId,
//       {String language = 'en-US'}) {
//     return _get(
//       TmdbTvEndpoints.videos(seriesId, language: language),
//       VideoResponse.fromJson,
//     );
//   }

//   // --- 76. TV Series Watch Providers ---
//   Future<WatchProvidersResponse> getTvSeriesWatchProviders(int seriesId) {
//     return _get(
//       TmdbTvEndpoints.watchProviders(seriesId),
//       WatchProvidersResponse.fromJson,
//     );
//   }

//   // --- 77. TV Series Add Rating ---
//   Future<TmdbStatusResponse> addTvSeriesRating(int seriesId, double value,
//       {String? guestSessionId, String? sessionId}) {
//     return _post(
//       TmdbTvEndpoints.rating(seriesId,
//           guestSessionId: guestSessionId, sessionId: sessionId),
//       {'value': value},
//       _defaultSuccessResponseFromJson,
//     );
//   }

//   // --- 78. TV Series Delete Rating ---
//   // Future<TmdbStatusResponse> deleteTvSeriesRating(int seriesId, {String? guestSessionId, String? sessionId}) {
//   //   return _delete(
//   //     TmdbTvEndpoints.rating(seriesId, guestSessionId: guestSessionId, sessionId: sessionId),
//   //     fromJson: _defaultSuccessResponseFromJson,
//   //   );
//   // }

//   // --- 79. TV Season Account States ---
//   Future<TvSeasonAccountStates> getTvSeasonAccountStates(
//       int seriesId, int seasonNumber,
//       {String? guestSessionId, String? sessionId, String language = 'en-US'}) {
//     return _get(
//       TmdbTvSeasonEndpoints.accountStates(seriesId, seasonNumber,
//           guestSessionId: guestSessionId,
//           sessionId: sessionId,
//           language: language),
//       TvSeasonAccountStates.fromJson,
//     );
//   }

//   // --- 80. TV Season Aggregate Credits ---
//   Future<AggregateCreditsResponse> getTvSeasonAggregateCredits(
//       int seriesId, int seasonNumber,
//       {String language = 'en-US'}) {
//     return _get(
//       TmdbTvSeasonEndpoints.aggregateCredits(seriesId, seasonNumber,
//           language: language),
//       AggregateCreditsResponse.fromJson,
//     );
//   }

//   // --- 81. TV Season Changes By ID ---
//   Future<ChangesResponse> getTvSeasonChanges(int seasonId,
//       {String? startDate, String? endDate, int page = 1}) {
//     return _get(
//       TmdbTvSeasonEndpoints.changes(seasonId,
//           startDate: startDate, endDate: endDate, page: page),
//       ChangesResponse.fromJson,
//     );
//   }

//   // --- 82. TV Season Credits ---
//   Future<CreditsResponse> getTvSeasonCredits(int seriesId, int seasonNumber,
//       {String language = 'en-US'}) {
//     return _get(
//       TmdbTvSeasonEndpoints.credits(seriesId, seasonNumber, language: language),
//       CreditsResponse.fromJson,
//     );
//   }

//   // --- 83. TV Season External IDs ---
//   Future<TvSeasonExternalIds> getTvSeasonExternalIds(
//       int seriesId, int seasonNumber) {
//     return _get(
//       TmdbTvSeasonEndpoints.externalIds(seriesId, seasonNumber),
//       TvSeasonExternalIds.fromJson,
//     );
//   }

//   // --- 84. TV Season Translations ---
//   Future<TranslationsResponse> getTvSeasonTranslations(
//       int seriesId, int seasonNumber) {
//     return _get(
//       TmdbTvSeasonEndpoints.translations(seriesId, seasonNumber),
//       TranslationsResponse.fromJson,
//     );
//   }

//   // --- 85. TV Season Videos ---
//   Future<VideoResponse> getTvSeasonVideos(int seriesId, int seasonNumber) {
//     return _get(
//       TmdbTvSeasonEndpoints.videos(seriesId, seasonNumber),
//       VideoResponse.fromJson,
//     );
//   }

//   // --- 86. TV Episode Credits ---
//   Future<CreditsResponse> getTvEpisodeCredits(
//       int seriesId, int seasonNumber, int episodeNumber,
//       {String language = 'en-US'}) {
//     return _get(
//       TmdbTvEpisodeEndpoints.credits(seriesId, seasonNumber, episodeNumber,
//           language: language),
//       CreditsResponse.fromJson,
//     );
//   }

//   // --- 87. TV Episode External IDs ---
//   Future<TvEpisodeExternalIds> getTvEpisodeExternalIds(
//       int seriesId, int seasonNumber, int episodeNumber) {
//     return _get(
//       TmdbTvEpisodeEndpoints.externalIds(seriesId, seasonNumber, episodeNumber),
//       TvEpisodeExternalIds.fromJson,
//     );
//   }

//   // --- 88. TV Episode Translations ---
//   Future<TranslationsResponse> getTvEpisodeTranslations(
//       int seriesId, int seasonNumber, int episodeNumber) {
//     return _get(
//       TmdbTvEpisodeEndpoints.translations(
//           seriesId, seasonNumber, episodeNumber),
//       TranslationsResponse.fromJson,
//     );
//   }

//   // --- 89. TV Episode Videos ---
//   Future<VideoResponse> getTvEpisodeVideos(
//       int seriesId, int seasonNumber, int episodeNumber) {
//     return _get(
//       TmdbTvEpisodeEndpoints.videos(seriesId, seasonNumber, episodeNumber),
//       VideoResponse.fromJson,
//     );
//   }

//   // --- 90. TV Episode Add Rating ---
//   Future<TmdbStatusResponse> addTvEpisodeRating(
//       int seriesId, int seasonNumber, int episodeNumber, double value,
//       {String? guestSessionId, String? sessionId}) {
//     return _post(
//       TmdbTvEpisodeEndpoints.rating(seriesId, seasonNumber, episodeNumber,
//           guestSessionId: guestSessionId, sessionId: sessionId),
//       {'value': value},
//       _defaultSuccessResponseFromJson,
//     );
//   }

//   // --- 91. TV Episode Delete Rating ---
//   // Future<TmdbStatusResponse> deleteTvEpisodeRating(int seriesId, int seasonNumber, int episodeNumber, {String? guestSessionId, String? sessionId}) {
//   //   return _delete(
//   //     TmdbTvEpisodeEndpoints.rating(seriesId, seasonNumber, episodeNumber, guestSessionId: guestSessionId, sessionId: sessionId),
//   //     fromJson: _defaultSuccessResponseFromJson,
//   //   );
//   // }

//   // --- 92. Account Details ---
//   Future<AccountDetails> getAccountDetails(int accountId,
//       {required String sessionId}) {
//     return _get(
//       TmdbAccountEndpoints.details(accountId, sessionId: sessionId),
//       AccountDetails.fromJson,
//     );
//   }

//   // --- 93. Account Lists ---
//   Future<PagedResponse<TmdbList>> getAccountLists(int accountId,
//       {int page = 1, required String sessionId}) {
//     return _get(
//       TmdbAccountEndpoints.lists(accountId, page: page, sessionId: sessionId),
//       (json) => PagedResponse.fromJson(json,
//           (itemJson) => TmdbList.fromJson(itemJson as Map<String, dynamic>)),
//     );
//   }

//   // --- 94. Account Favorite Movies ---
//   Future<PagedResponse<MovieResult>> getAccountFavoriteMovies(int accountId,
//       {String language = 'en-US',
//       int page = 1,
//       String sortBy = 'created_at.asc',
//       required String sessionId}) {
//     return _get(
//       TmdbAccountEndpoints.favoriteMovies(accountId,
//           language: language, page: page, sortBy: sortBy, sessionId: sessionId),
//       (json) => PagedResponse.fromJson(json,
//           (itemJson) => MovieResult.fromJson(itemJson as Map<String, dynamic>)),
//     );
//   }

//   // --- 95. Account Favorite TV ---
//   Future<PagedResponse<TvShowResult>> getAccountFavoriteTv(int accountId,
//       {String language = 'en-US',
//       int page = 1,
//       String sortBy = 'created_at.asc',
//       required String sessionId}) {
//     return _get(
//       TmdbAccountEndpoints.favoriteTv(accountId,
//           language: language, page: page, sortBy: sortBy, sessionId: sessionId),
//       (json) => PagedResponse.fromJson(
//           json,
//           (itemJson) =>
//               TvShowResult.fromJson(itemJson as Map<String, dynamic>)),
//     );
//   }

//   // --- 96. Account Rated Movies ---
//   Future<PagedResponse<MovieResultWithRating>> getAccountRatedMovies(
//       int accountId,
//       {String language = 'en-US',
//       int page = 1,
//       String sortBy = 'created_at.asc',
//       required String sessionId}) {
//     return _get(
//       TmdbAccountEndpoints.ratedMovies(accountId,
//           language: language, page: page, sortBy: sortBy, sessionId: sessionId),
//       (json) => PagedResponse.fromJson(
//           json,
//           (itemJson) =>
//               MovieResultWithRating.fromJson(itemJson as Map<String, dynamic>)),
//     );
//   }

//   // --- 97. Account Rated TV ---
//   Future<PagedResponse<TvShowResultWithRating>> getAccountRatedTv(int accountId,
//       {String language = 'en-US',
//       int page = 1,
//       String sortBy = 'created_at.asc',
//       required String sessionId}) {
//     return _get(
//       TmdbAccountEndpoints.ratedTv(accountId,
//           language: language, page: page, sortBy: sortBy, sessionId: sessionId),
//       (json) => PagedResponse.fromJson(
//           json,
//           (itemJson) => TvShowResultWithRating.fromJson(
//               itemJson as Map<String, dynamic>)),
//     );
//   }

//   // --- 98. Account Rated TV Episodes ---
//   Future<PagedResponse<TvEpisodeWithRating>> getAccountRatedTvEpisodes(
//       int accountId,
//       {String language = 'en-US',
//       int page = 1,
//       String sortBy = 'created_at.asc',
//       required String sessionId}) {
//     return _get(
//       TmdbAccountEndpoints.ratedTvEpisodes(accountId,
//           language: language, page: page, sortBy: sortBy, sessionId: sessionId),
//       (json) => PagedResponse.fromJson(
//           json,
//           (itemJson) =>
//               TvEpisodeWithRating.fromJson(itemJson as Map<String, dynamic>)),
//     );
//   }

//   // --- 99. Account Watchlist Movies ---
//   Future<PagedResponse<MovieResult>> getAccountWatchlistMovies(int accountId,
//       {String language = 'en-US',
//       int page = 1,
//       String sortBy = 'created_at.asc',
//       required String sessionId}) {
//     return _get(
//       TmdbAccountEndpoints.watchlistMovies(accountId,
//           language: language, page: page, sortBy: sortBy, sessionId: sessionId),
//       (json) => PagedResponse.fromJson(json,
//           (itemJson) => MovieResult.fromJson(itemJson as Map<String, dynamic>)),
//     );
//   }

//   // --- 100. Account Watchlist TV ---
//   Future<PagedResponse<TvShowResult>> getAccountWatchlistTv(int accountId,
//       {String language = 'en-US',
//       int page = 1,
//       String sortBy = 'created_at.asc',
//       required String sessionId}) {
//     return _get(
//       TmdbAccountEndpoints.watchlistTv(accountId,
//           language: language, page: page, sortBy: sortBy, sessionId: sessionId),
//       (json) => PagedResponse.fromJson(
//           json,
//           (itemJson) =>
//               TvShowResult.fromJson(itemJson as Map<String, dynamic>)),
//     );
//   }

//   // --- 101. Account Add Favorite ---
//   Future<TmdbStatusResponse> addAccountFavorite(
//       int accountId, String mediaType, int mediaId, bool favorite,
//       {required String sessionId}) {
//     return _post(
//       TmdbAccountEndpoints.addFavorite(accountId, sessionId: sessionId),
//       {'media_type': mediaType, 'media_id': mediaId, 'favorite': favorite},
//       _defaultSuccessResponseFromJson,
//     );
//   }

//   // --- 102. Account Add To Watchlist ---
//   Future<TmdbStatusResponse> addToAccountWatchlist(
//       int accountId, String mediaType, int mediaId, bool watchlist,
//       {required String sessionId}) {
//     return _post(
//       TmdbAccountEndpoints.addToWatchlist(accountId, sessionId: sessionId),
//       {'media_type': mediaType, 'media_id': mediaId, 'watchlist': watchlist},
//       _defaultSuccessResponseFromJson,
//     );
//   }

//   // --- 103. Certification Movie List ---
//   Future<MovieCertificationsResponse> getMovieCertifications(
//       {String language = 'en-US'}) {
//     return _get(
//       TmdbCertificationEndpoints.movieCertifications(language: language),
//       MovieCertificationsResponse.fromJson,
//     );
//   }

//   // --- 104. Certification TV List ---
//   Future<TvCertificationsResponse> getTvCertifications(
//       {String language = 'en-US'}) {
//     return _get(
//       TmdbCertificationEndpoints.tvCertifications(language: language),
//       TvCertificationsResponse.fromJson,
//     );
//   }

//   // --- 105. Changes Movie List ---
//   Future<ChangesListResponse> getChangesMovieList(
//       {String? startDate, String? endDate, int page = 1}) {
//     return _get(
//       TmdbChangesListEndpoints.movieChanges(
//           startDate: startDate, endDate: endDate, page: page),
//       ChangesListResponse.fromJson,
//     );
//   }

//   // --- 106. Changes TV List ---
//   Future<ChangesListResponse> getChangesTvList(
//       {String? startDate, String? endDate, int page = 1}) {
//     return _get(
//       TmdbChangesListEndpoints.tvChanges(
//           startDate: startDate, endDate: endDate, page: page),
//       ChangesListResponse.fromJson,
//     );
//   }

//   // --- 107. Changes People List ---
//   Future<ChangesListResponse> getChangesPeopleList(
//       {String? startDate, String? endDate, int page = 1}) {
//     return _get(
//       TmdbChangesListEndpoints.personChanges(
//           startDate: startDate, endDate: endDate, page: page),
//       ChangesListResponse.fromJson,
//     );
//   }

//   // --- 108. Collection Details ---
//   Future<Collection> getCollectionDetails(int collectionId,
//       {String language = 'en-US'}) {
//     return _get(
//       TmdbCollectionEndpoints.details(collectionId, language: language),
//       Collection.fromJson,
//     );
//   }

//   // --- 109. Collection Images ---
//   Future<ImageResponse> getCollectionImages(int collectionId) {
//     return _get(
//       TmdbCollectionEndpoints.images(collectionId),
//       ImageResponse.fromJson,
//     );
//   }

//   // --- 110. Collection Translations ---
//   Future<TranslationsResponse> getCollectionTranslations(int collectionId) {
//     return _get(
//       TmdbCollectionEndpoints.translations(collectionId),
//       TranslationsResponse.fromJson,
//     );
//   }

//   // --- 111. Company Details ---
//   Future<Company> getCompanyDetails(int companyId) {
//     return _get(
//       TmdbCompanyEndpoints.details(companyId),
//       Company.fromJson,
//     );
//   }

//   // --- 112. Company Alternative Names ---
//   Future<CompanyAlternativeNamesResponse> getCompanyAlternativeNames(
//       int companyId) {
//     return _get(
//       TmdbCompanyEndpoints.alternativeNames(companyId),
//       CompanyAlternativeNamesResponse.fromJson,
//     );
//   }

//   // --- 113. Company Images ---
//   Future<CompanyImagesResponse> getCompanyImages(int companyId) {
//     return _get(
//       TmdbCompanyEndpoints.images(companyId),
//       CompanyImagesResponse.fromJson,
//     );
//   }

//   // --- 114. Credit Details ---
//   Future<CreditDetails> getCreditDetails(String creditId) {
//     return _get(
//       TmdbCreditEndpoints.details(creditId),
//       CreditDetails.fromJson,
//     );
//   }

//   // --- 115. Genre Movie List ---
//   Future<GenresResponse> getMovieGenres({String language = 'en-US'}) {
//     return _get(
//       TmdbGenreEndpoints.movieGenres(language: language),
//       GenresResponse.fromJson,
//     );
//   }

//   // --- 116. Genre TV List ---
//   Future<GenresResponse> getTvGenres({String language = 'en-US'}) {
//     return _get(
//       TmdbGenreEndpoints.tvGenres(language: language),
//       GenresResponse.fromJson,
//     );
//   }

//   // --- 117. Guest Session Rated Movies ---
//   Future<PagedResponse<MovieResultWithRating>> getGuestSessionRatedMovies(
//       String guestSessionId,
//       {String language = 'en-US',
//       int page = 1,
//       String sortBy = 'created_at.asc'}) {
//     return _get(
//       TmdbGuestSessionEndpoints.ratedMovies(guestSessionId,
//           language: language, page: page, sortBy: sortBy),
//       (json) => PagedResponse.fromJson(
//           json,
//           (itemJson) =>
//               MovieResultWithRating.fromJson(itemJson as Map<String, dynamic>)),
//     );
//   }

//   // --- 118. Guest Session Rated TV ---
//   Future<PagedResponse<TvShowResultWithRating>> getGuestSessionRatedTv(
//       String guestSessionId,
//       {String language = 'en-US',
//       int page = 1,
//       String sortBy = 'created_at.asc'}) {
//     return _get(
//       TmdbGuestSessionEndpoints.ratedTv(guestSessionId,
//           language: language, page: page, sortBy: sortBy),
//       (json) => PagedResponse.fromJson(
//           json,
//           (itemJson) => TvShowResultWithRating.fromJson(
//               itemJson as Map<String, dynamic>)),
//     );
//   }

//   // --- 119. Guest Session Rated TV Episodes ---
//   Future<PagedResponse<TvEpisodeWithRating>> getGuestSessionRatedTvEpisodes(
//       String guestSessionId,
//       {String language = 'en-US',
//       int page = 1,
//       String sortBy = 'created_at.asc'}) {
//     return _get(
//       TmdbGuestSessionEndpoints.ratedTvEpisodes(guestSessionId,
//           language: language, page: page, sortBy: sortBy),
//       (json) => PagedResponse.fromJson(
//           json,
//           (itemJson) =>
//               TvEpisodeWithRating.fromJson(itemJson as Map<String, dynamic>)),
//     );
//   }

//   // --- 120. Watch Providers Available Regions ---
//   Future<WatchProviderRegionsResponse> getWatchProviderRegions(
//       {String language = 'en-US'}) {
//     return _get(
//       TmdbWatchProviderEndpoints.regions(language: language),
//       WatchProviderRegionsResponse.fromJson,
//     );
//   }

//   // --- 121. Watch Providers Movie Providers ---
//   Future<WatchProviderProvidersResponse> getMovieWatchProvidersList(
//       {String language = 'en-US', required String watchRegion}) {
//     return _get(
//       TmdbWatchProviderEndpoints.movieProviders(
//           language: language, watchRegion: watchRegion),
//       WatchProviderProvidersResponse.fromJson,
//     );
//   }

//   // --- 122. Watch Providers TV Providers ---
//   Future<WatchProviderProvidersResponse> getTvWatchProvidersList(
//       {String language = 'en-US', required String watchRegion}) {
//     return _get(
//       TmdbWatchProviderEndpoints.tvProviders(
//           language: language, watchRegion: watchRegion),
//       WatchProviderProvidersResponse.fromJson,
//     );
//   }

//   // --- 123. Keyword Details ---
//   Future<KeywordObject> getKeywordDetails(int keywordId) {
//     return _get(
//       TmdbKeywordEndpoints.details(keywordId),
//       KeywordObject.fromJson,
//     );
//   }

//   // --- 124. Keyword Movies ---
//   Future<PagedResponse<MovieResult>> getKeywordMovies(int keywordId,
//       {bool includeAdult = false, String language = 'en-US', int page = 1}) {
//     return _get(
//       TmdbKeywordEndpoints.movies(keywordId,
//           includeAdult: includeAdult, language: language, page: page),
//       (json) => PagedResponse.fromJson(json,
//           (itemJson) => MovieResult.fromJson(itemJson as Map<String, dynamic>)),
//     );
//   }

//   // --- 125. List Details ---
//   Future<TmdbListDetails> getListDetails(int listId,
//       {String language = 'en-US', int page = 1}) {
//     return _get(
//       TmdbListEndpoints.details(listId, language: language, page: page),
//       TmdbListDetails.fromJson,
//     );
//   }

//   // --- 126. List Delete ---
//   // Future<TmdbStatusResponse> deleteList(int listId, {required String sessionId}) {
//   //   return _delete(
//   //     TmdbListEndpoints.delete(listId, sessionId: sessionId),
//   //     fromJson: _defaultSuccessResponseFromJson,
//   //   );
//   // }

//   // --- 127. List Check Item Status ---
//   Future<ListItemStatusResponse> checkListItemStatus(int listId,
//       {required int mediaId, required String mediaType}) {
//     return _get(
//       TmdbListEndpoints.checkItemStatus(listId,
//           mediaId: mediaId, mediaType: mediaType),
//       ListItemStatusResponse.fromJson,
//     );
//   }
// }
