
import 'package:flutter/material.dart';
import 'package:miko/configs/ai_config_etc.dart';
import 'package:miko/tools/function_tools.dart';
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
