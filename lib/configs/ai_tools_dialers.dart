part of '../services/ai_chat_service.dart';

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

Future<Map<String, dynamic>> getPopularToolCall(
   String? language, int? page, bool isMovie,ref) async {

  try {

      final Map<String, dynamic> recommendationResult =
          await getPopularToolWrapper(
              language??"en-US",page, isMovie);


       debugPrint("Received Recommendation result: $recommendationResult");
      return recommendationResult;

  } catch (e) {
    debugPrint("Error in getRecommendsToolCall: $e");
    // Returning a structured error map
    return {
      'error': true,
      'message': 'An unexpected error occurred while fetching recommendations.'
    };
  }
}

Future<Map<String, dynamic>> getMovieCreditsToolCall({
 required String movieName,
 String? language,
}) async {
 final tmdb = TMDB(ApiKeys(tmdbapiv3, 'apiReadAccessTokenv4'),
 logConfig: const ConfigLogger(showLogs: false));

 try {
 final searchResult = await tmdb.v3.search.queryMovies(movieName);

 if (searchResult['results'] != null &&
 (searchResult['results'] as List).isNotEmpty) {
 final int movieId = searchResult['results'][0]['id'];

 final Map<String, dynamic> creditsResult =
 await getMovieCreditsToolWrapper(
 movieId: movieId, language: language);

 debugPrint("Received Movie Credits result: $creditsResult");
 return creditsResult;
 } else {
 debugPrint("No movie found for '$movieName'.");
 return {
 'error': true,
 'message': "Sorry, I couldn't find a movie named '$movieName' to get credits for.",
 };
 }
 } on FormatException catch (e) {
 debugPrint("JSON decoding failed: $e");
 return {'error': true, 'message': 'Failed to parse data from the service.'};
 } catch (e) {
 debugPrint("Error in getMovieCreditsToolCall: $e");
 return {
 'error': true,
 'message': 'An unexpected error occurred while fetching movie credits.'
 };
 }
}

// --- Wrapper for getPersonDetails ---
Future<Map<String, dynamic>> getPersonDetailsToolCall({
 required String personName,
 String? language,
}) async {
 final tmdb = TMDB(ApiKeys(tmdbapiv3, 'apiReadAccessTokenv4'),
 logConfig: const ConfigLogger(showLogs: false));

 try {
 final searchResult = await tmdb.v3.search.queryPeople(personName);

 if (searchResult['results'] != null &&
 (searchResult['results'] as List).isNotEmpty) {
 final int personId = searchResult['results'][0]['id'];

 final Map<String, dynamic> personDetailsResult =
 await getPersonDetailsToolWrapper(
 personId: personId, language: language);

 debugPrint("Received Person Details result: $personDetailsResult");
 return personDetailsResult;
 } else {
 debugPrint("No person found for '$personName'.");
 return {
 'error': true,
 'message': "Sorry, I couldn't find a person named '$personName'.",
 };
 }
 } on FormatException catch (e) {
 debugPrint("JSON decoding failed: $e");
 return {'error': true, 'message': 'Failed to parse data from the service.'};
 } catch (e) {
 debugPrint("Error in getPersonDetailsToolCall: $e");
 return {
 'error': true,
 'message': 'An unexpected error occurred while fetching person details.'
 };
 }
}

// --- Wrapper for getTvShowEpisodeDetails ---
Future<Map<String, dynamic>> getTvShowEpisodeDetailsToolCall({
 required String tvShowName,
 required int seasonNumber,
 required int episodeNumber,
 String? language,
}) async {
 final tmdb = TMDB(ApiKeys(tmdbapiv3, 'apiReadAccessTokenv4'),
 logConfig: const ConfigLogger(showLogs: false));

 try {
 final searchResult = await tmdb.v3.search.queryTvShows(tvShowName);

 if (searchResult['results'] != null &&
 (searchResult['results'] as List).isNotEmpty) {
 final int tvShowId = searchResult['results'][0]['id'];

 final Map<String, dynamic> episodeDetailsResult =
 await getTvShowEpisodeDetailsToolWrapper(
 tvShowId: tvShowId,
 seasonNumber: seasonNumber,
 episodeNumber: episodeNumber,
 language: language);

 debugPrint("Received TV Show Episode Details result: $episodeDetailsResult");
 return episodeDetailsResult;
 } else {
 debugPrint("No TV show found for '$tvShowName'.");
 return {
 'error': true,
 'message': "Sorry, I couldn't find a TV show named '$tvShowName' to get episode details for.",
 };
 }
 } on FormatException catch (e) {
 debugPrint("JSON decoding failed: $e");
 return {'error': true, 'message': 'Failed to parse data from the service.'};
 } catch (e) {
 debugPrint("Error in getTvShowEpisodeDetailsToolCall: $e");
 return {
 'error': true,
 'message': 'An unexpected error occurred while fetching TV show episode details.'
 };
 }
}

// --- Wrapper for getTVCredits ---
Future<Map<String, dynamic>> getTVCreditsToolCall({
 required String tvShowName,
 String? language,
}) async {
 final tmdb = TMDB(ApiKeys(tmdbapiv3, 'apiReadAccessTokenv4'),
 logConfig: const ConfigLogger(showLogs: false));

 try {
 final searchResult = await tmdb.v3.search.queryTvShows(tvShowName);

 if (searchResult['results'] != null &&
 (searchResult['results'] as List).isNotEmpty) {
 final int tvId = searchResult['results'][0]['id'];

 final Map<String, dynamic> creditsResult =
 await getTVCreditsToolWrapper(tvId: tvId, language: language);

 debugPrint("Received TV Credits result: $creditsResult");
 return creditsResult;
 } else {
 debugPrint("No TV show found for '$tvShowName'.");
 return {
 'error': true,
 'message': "Sorry, I couldn't find a TV show named '$tvShowName' to get credits for.",
 };
 }
 } on FormatException catch (e) {
 debugPrint("JSON decoding failed: $e");
 return {'error': true, 'message': 'Failed to parse data from the service.'};
 } catch (e) {
 debugPrint("Error in getTVCreditsToolCall: $e");
 return {
 'error': true,
 'message': 'An unexpected error occurred while fetching TV credits.'
 };
 }
}


// --- Tool Declarations ---

