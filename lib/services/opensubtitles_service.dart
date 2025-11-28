import 'dart:convert';
import 'package:http/http.dart' as http;

import '../configs/consts2.dart';
import '../models/subtitletranslator/opensubtitles_models.dart';

class OpenSubtitlesService {
  static const String baseUrl = 'https://api.opensubtitles.com/api/v1';
  
  // Cached JWT token
  static String? _authToken;

  /// Login to OpenSubtitles API and get JWT token
  /// 
  /// Uses credentials from env.dart
  static Future<OpenSubtitlesLoginResponse?> login() async {
    try {
      final request = OpenSubtitlesLoginRequest(
        username: opensubtitleUserName,
        password: opensubtitlePass,
      );

      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {
          'Content-Type': 'application/json',
          'Api-Key': opensubtitleAPIKey,
          'User-Agent': opensubtitleUA,
        },
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        final loginResponse = OpenSubtitlesLoginResponse.fromJson(jsonData);
        
        // Cache the token
        _authToken = loginResponse.token;
        
        return loginResponse;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  /// Logout from OpenSubtitles API
  /// 
  /// Invalidates the current JWT token
  static Future<bool> logout() async {
    if (_authToken == null) {
      return false;
    }

    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/logout'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_authToken',
          'Api-Key': opensubtitleAPIKey,
          'User-Agent': opensubtitleUA,
        },
      );

      if (response.statusCode == 200) {
        _authToken = null;
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  /// Search for subtitles on OpenSubtitles
  /// 
  /// Automatically handles login if no token is cached
  /// 
  /// Parameters:
  /// - [query]: Search query (movie/show name)
  /// - [languages]: Comma-separated language codes (e.g., 'en,es')
  /// - [type]: Content type ('movie', 'episode', or 'all')
  /// - [imdbId]: IMDB ID (without 'tt' prefix)
  /// - [tmdbId]: TMDB ID
  /// - [year]: Release year
  /// - [seasonNumber]: Season number (for TV shows)
  /// - [episodeNumber]: Episode number (for TV shows)
  /// - [hearingImpaired]: Filter hearing impaired subtitles ('include', 'exclude', 'only')
  /// - [foreignPartsOnly]: Filter foreign parts only ('include', 'exclude', 'only')
  /// - [trustedSources]: Filter trusted sources ('include', 'exclude', 'only')
  /// - [machineTranslated]: Filter machine translated ('include', 'exclude', 'only')
  /// - [aiTranslated]: Filter AI translated ('include', 'exclude', 'only')
  /// - [orderBy]: Sort by field (e.g., 'download_count', 'ratings', 'upload_date')
  /// - [orderDirection]: Sort direction ('asc' or 'desc')
  /// - [page]: Page number for pagination (default: 1)
  static Future<OpenSubtitlesSearchResponse?> searchSubtitles({
    String? query,
    String? languages,
    String? type,
    String? imdbId,
    int? tmdbId,
    int? year,
    String? seasonNumber,
    String? episodeNumber,
    String? hearingImpaired,
    String? foreignPartsOnly,
    String? trustedSources,
    String? machineTranslated,
    String? aiTranslated,
    String? orderBy,
    String? orderDirection,
    int? page,
  }) async {
    // Ensure we have a valid token
    if (_authToken == null) {
      final loginResult = await login();
      if (loginResult == null) {
        return null;
      }
    }

    try {
      final request = OpenSubtitlesSearchRequest(
        query: query,
        languages: languages,
        type: type,
        imdbId: imdbId,
        tmdbId: tmdbId,
        year: year,
        seasonNumber: seasonNumber,
        episodeNumber: episodeNumber,
        hearingImpaired: hearingImpaired,
        foreignPartsOnly: foreignPartsOnly,
        trustedSources: trustedSources,
        machineTranslated: machineTranslated,
        aiTranslated: aiTranslated,
        orderBy: orderBy,
        orderDirection: orderDirection,
        page: page,
      );

      final uri = Uri.parse('$baseUrl/subtitles').replace(
        queryParameters: request.toQueryParameters(),
      );

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Api-Key': opensubtitleAPIKey,
          'User-Agent': opensubtitleUA,
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        return OpenSubtitlesSearchResponse.fromJson(jsonData);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  /// Download subtitle from OpenSubtitles
  /// 
  /// Requires authentication (JWT token)
  /// 
  /// Parameters:
  /// - [fileId]: File ID from subtitle search results
  /// 
  /// Returns download response with link and remaining download count
  static Future<OpenSubtitlesDownloadResponse?> download(int fileId) async {
    // Ensure we have a valid token
    if (_authToken == null) {
      final loginResult = await login();
      if (loginResult == null) {
        return null;
      }
    }

    try {
      final request = OpenSubtitlesDownloadRequest(fileId: fileId);

      final response = await http.post(
        Uri.parse('$baseUrl/download'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_authToken',
          'Api-Key': opensubtitleAPIKey,
          'User-Agent': opensubtitleUA,
        },
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        return OpenSubtitlesDownloadResponse.fromJson(jsonData);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  /// Download subtitle file content from the download link
  /// 
  /// Parameters:
  /// - [downloadLink]: Download link from download response
  /// 
  /// Returns the subtitle file content as a string
  static Future<String?> downloadSubtitleFile(String downloadLink) async {
    try {
      final response = await http.get(Uri.parse(downloadLink));

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  /// Get current authentication token
  static String? get authToken => _authToken;

  /// Check if user is currently logged in
  static bool get isLoggedIn => _authToken != null;
}
