import 'dart:convert';
import 'package:http/http.dart' as http;

import '../configs/consts2.dart';
import '../models/subtitletranslator/subdl_models.dart';

class SubDLService {
  static const String baseUrl = 'https://api.subdl.com/api/v1/subtitles';

  /// Search for subtitles on SubDL
  /// 
  /// Parameters:
  /// - [filmName]: Name of the film/show
  /// - [type]: Type of content ('movie' or 'tv')
  /// - [languages]: Comma-separated language codes (e.g., 'en,es')
  /// - [year]: Release year
  /// - [seasonNumber]: Season number (for TV shows)
  /// - [episodeNumber]: Episode number (for TV shows)
  /// - [imdbId]: IMDB ID
  /// - [tmdbId]: TMDB ID
  /// - [subsPerPage]: Number of results per page
  /// - [comment]: Include comments (true/false)
  /// - [releases]: Include releases (true/false)
  /// - [hi]: Include hearing impaired (true/false)
  /// - [fullSeason]: Full season (true/false)
  static Future<SubDLSearchResponse> searchSubtitles({
    String? filmName,
    String? fileName,
    String? sdId,
    String? imdbId,
    String? tmdbId,
    int? seasonNumber,
    int? episodeNumber,
    String? type,
    int? year,
    String? languages,
    int? subsPerPage,
    bool? comment,
    bool? releases,
    bool? hi,
    bool? fullSeason,
  }) async {
    try {
      final request = SubDLSearchRequest(
        apiKey: subdlAPIKey,
        filmName: filmName,
        fileName: fileName,
        sdId: sdId,
        imdbId: imdbId,
        tmdbId: tmdbId,
        seasonNumber: seasonNumber,
        episodeNumber: episodeNumber,
        type: type,
        year: year,
        languages: languages,
        subsPerPage: subsPerPage,
        comment: comment,
        releases: releases,
        hi: hi,
        fullSeason: fullSeason,
      );

      final uri = Uri.parse(baseUrl).replace(
        queryParameters: request.toQueryParameters(),
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        return SubDLSearchResponse.fromJson(jsonData);
      } else {
        return SubDLSearchResponse(
          status: false,
          error: 'HTTP ${response.statusCode}: ${response.body}',
        );
      }
    } catch (e) {
      return SubDLSearchResponse(
        status: false,
        error: 'Request failed: $e',
      );
    }
  }

  /// Download subtitle file from SubDL
  /// 
  /// Returns the subtitle file content as a string
  static Future<String?> downloadSubtitle(String downloadUrl) async {
    try {
      final response = await http.get(Uri.parse(downloadUrl));

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  /// Construct download URL from subtitle URL
  /// SubDL download links follow pattern: https://dl.subdl.com/subtitle/[id]
  static String constructDownloadUrl(String subtitleUrl) {
    // Extract the ID from the subtitle URL
    // Example: https://subdl.com/subtitle/sd123456 -> https://dl.subdl.com/subtitle/sd123456
    final uri = Uri.parse(subtitleUrl);
    final pathSegments = uri.pathSegments;
    
    if (pathSegments.length >= 2 && pathSegments[0] == 'subtitle') {
      return 'https://dl.subdl.com/subtitle/${pathSegments[1]}';
    }
    
    return subtitleUrl; // Return original if pattern doesn't match
  }
}
