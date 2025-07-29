import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:miko/configs/consts.dart';
import 'package:miko/showcases/model.dart';
import '../showcases/movie_service.dart';

import 'package:flutter/material.dart';
import 'package:tmdb_api/tmdb_api.dart';

Future<Map<String, dynamic>> webSearchToolCall(String location) async {
  try {
    final Map<String, dynamic> ddgResult = await performWebSearch(location);
    debugPrint("Received DuckDuckGo result: $ddgResult");

    // Optionally decode if the result is still in raw JSON, but it's already structured
    return ddgResult;
  } on FormatException catch (e) {
    debugPrint("JSON decoding failed: $e");
    return {'error': 'Failed to parse weather data'};
  } catch (e) {
    debugPrint("Error getting weather data: $e");
    return {'error': 'Failed to fetch weather data'};
  }
}

Future<Map<String, dynamic>> getRecommendsToolCall(
    String name, int? page, String? language, bool isMovie) async {
  // Assuming TMDB is already initialized elsewhere or passed in
  final tmdb = TMDB(ApiKeys(tmdbapiv3, 'apiReadAccessTokenv4'),
      logConfig: const ConfigLogger(showLogs: false));

  try {
    // Determine which API to call based on the isMovie flag
    final searchResult = isMovie
        ? await tmdb.v3.search.queryMovies(name)
        : await tmdb.v3.search.queryTvShows(name);

    // Check if the search returned any results
    if (searchResult['results'] != null &&
        (searchResult['results'] as List).isNotEmpty) {
      final firstResult = searchResult['results'][0];
      final int id = firstResult['id'];

      // Now, call the tool wrapper function to get recommendations

      final Map<String, dynamic> recommendationResult =
          await getMovieRecommendationsToolWrapper(
              movieId: id, page: page, language: language, isMovie: isMovie);


       debugPrint("Received Recommendation result: $recommendationResult");
      return recommendationResult;
    } else {
      // THE FIX: Handle the case where no results are found.
      // Return a structured error map that is still a valid Map<String, dynamic>.
      debugPrint("No search results found for '$name'.");
      return {
        'error': true,
        'message': "Sorry, I couldn't find any movie or TV show named '$name'.",
      };
    }
  } on FormatException catch (e) {
    debugPrint("JSON decoding failed: $e");
    // Returning a structured error map
    return {'error': true, 'message': 'Failed to parse data from the service.'};
  } catch (e) {
    debugPrint("Error in getRecommendsToolCall: $e");
    // Returning a structured error map
    return {
      'error': true,
      'message': 'An unexpected error occurred while fetching recommendations.'
    };
  }
}
// Tool for performing a web search
final webSearchTool = Tool(
  functionDeclarations: [
    FunctionDeclaration(
      'performWebSearch',
      'Performs a web search to find current information or answer questions requiring up-to-date data. Provide the exact search query.',
      Schema(
        SchemaType.object,
        properties: {
          'query': Schema(SchemaType.string,
              description:
                  'The search query for which to retrieve instant answers.'),
        },
        nullable: false,
        requiredProperties: ['query'],
      ),
    ),
  ],
);

// Tool for getting movie/series recommendations
final movieRecommendTool = Tool(
  functionDeclarations: [
    FunctionDeclaration(
      'getMovieRecommendations',
      'Fetches a list of recommended movies, series, or anime that are similar to a specific title. You must provide the exact name of the title to get recommendations for.',
      Schema(
        SchemaType.object,
        properties: {
          'name': Schema(SchemaType.string,
              description:
                  "The name of the movie, series, or anime for which to find recommendations. Do not include the year."),
          'isMovie': Schema(SchemaType.boolean,
              description:
                  "Set to true if the user is asking for a movie. Set to false if it is a TV series or anime series."),
          'page': Schema(SchemaType.integer,
              description:
                  'The page number of results to retrieve. Defaults to 1.'),
          'language': Schema(SchemaType.string,
              description:
                  "The language of the results, in ISO 639-1 format (e.g., 'en-US'). Defaults to 'en-US'."),
        },
        requiredProperties: ['name', 'isMovie'],
      ),
    ),
  ],
);

// lib/tools/web_search_tool.dart


final MovieService _movieService = MovieService();

Future<Map<String, dynamic>> performWebSearch(String query) async {
  final url = Uri.https('api.duckduckgo.com', '/', {
    'q': query,
    'format': 'json',
  });

  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final topics = data['RelatedTopics'] as List<dynamic>;
    final results = topics
        .map((e) => e['Text'] ?? '')
        .where((t) => t.isNotEmpty)
        .join('\n');

    return {
      "query": query,
      "result": results,
    };
  } else {
    throw Exception('DuckDuckGo request failed: ${response.statusCode}');
  }
}

Future<Map<String, dynamic>> getMovieRecommendationsToolWrapper(
    {required int movieId,
    int? page,
    String? language,
    required bool isMovie}) async {
  if (isMovie) {
    final MovieResponse movieResponse =
        await _movieService.getMovieRecommendations(
      movieId: movieId,
      page: page ?? 1,
      language: language ?? 'en-US',
    );

    final simplifiedResults = movieResponse.results.map((movie) {
      return {
        'id': movie.id,
        'title': movie.title,
        'overview': movie.overview,
        'release_date': movie.releaseDate,
        'vote_average': movie.voteAverage,
      };
    }).toList();

    return {
      "source_movie_id": movieId,
      "page": movieResponse.page,
      "total_pages": movieResponse.totalPages,
      "recommendations": simplifiedResults,
    };
  }else {
  final  TvShowResponse tvResponse = await  _movieService.getTvShowRecommendations(
     tvShowId: movieId, page :page??1,language:language?? 'en-US'); 
     final simplifiedResults = tvResponse.results.map((movie) {
      return {
        'id': movie.id,
        'title': movie.name,
        'overview': movie.overview,
        'release_date': movie.firstAirDate,
        'vote_average': movie.voteAverage,
      };
    }).toList();
 return {
      "source_movie_id": movieId,
      "page": tvResponse.page,
      "total_pages": tvResponse.totalPages,
      "recommendations": simplifiedResults,
    };
  }
}

