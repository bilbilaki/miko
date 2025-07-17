// lib/tools/web_search_tool.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:miko/showcases/model.dart';
import '../showcases/movie_service.dart';

const String openAIApiKey =
    'aa-Ag0FkYecrGW214FK0YV8XFMwyVnadVUT1wZt3R1Q360lAOwa';
final MovieService _movieService = MovieService();
final TmdbApiService _tmdbService = TmdbApiService();

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

// Future<String> performWebSearch(String query) async {
//   print('Tool Called: performWebSearch with query: "$query"');

//   final url = Uri.parse('https://api.avalai.org/v1/responses'); // Or 'https://api.openai.com/v1/chat/completions' if the web_search_preview is available there.
//   final headers = {
//     'Content-Type': 'application/json',
//     'Authorization': 'Bearer $openAIApiKey',
//   };

//   final body = json.encode({
//     'model': 'gpt-4.1', // Use a model that supports web_search_preview, like gpt-4.1 or gpt-4o with specific parameters.
//     'tools': [
//       {'type': 'web_search_preview'}
//     ],
//     'input': query,
//     // You might need to add 'stream: false' if the default is true and you expect a single response.
//     // 'stream': false,
//   });

//   try {
//     final response = await http.post(url, headers: headers, body: body);

//     if (response.statusCode == 200) {
//       final Map<String, dynamic> responseData = json.decode(response.body);
//       print('Web Search API Raw Response: ${responseData}');

//       // Parse the response to extract the content
//       // The structure you provided shows 'output' as a list of objects.
//       // We need to find the 'message' type object and then extract its 'content'.
//       if (responseData.containsKey('output') && responseData['output'] is List) {
//         for (var item in responseData['output']) {
//           if (item is Map<String, dynamic> && item['type'] == 'message' && item.containsKey('content')) {
//             final List<dynamic> contentList = item['content'];
//             for (var contentItem in contentList) {
//               if (contentItem is Map<String, dynamic> && contentItem['type'] == 'output_text' && contentItem.containsKey('text')) {
//                 return contentItem['text']; // Return the first text content found
//               }
//             }
//           }
//         }
//         return 'Web search completed, but no text content found in the response structure.';
//       } else {
//         return 'Web search completed, but response structure is unexpected (no "output" key or not a list).';
//       }
//     } else {
//       print('Error calling OpenAI Web Search API: ${response.statusCode} - ${response.body}');
//       return 'Error performing web search: ${response.statusCode} - ${response.body}';
//     }
//   } catch (e) {
//     print('Exception during web search API call: $e');
//     return 'An unexpected error occurred during web search: $e';
//   }
