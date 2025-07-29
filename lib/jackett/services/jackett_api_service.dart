import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:miko/jackett/models/jackett_config.dart';
import 'package:miko/jackett/models/search_params.dart';
import 'package:miko/jackett/models/torznab_result_item.dart';
import 'package:xml/xml.dart';

class JackettApiService {
  final JackettConfig config;
  final http.Client _client;

  JackettApiService({required this.config, http.Client? client})
      : _client = client ?? http.Client();

  Uri _buildUri(
    String indexer, {
    Map<String, String> queryParameters = const {},
  }) {
    // Trim any trailing slashes from the user-provided URL to prevent double slashes.
    String baseUrl = config.url.endsWith('/')
        ? config.url.substring(0, config.url.length - 1)
        : config.url;

    final String fullUrlPath = '$baseUrl/api/v2.0/indexers/$indexer/results/torznab/api';

    final allParams = {
      'apikey': config.apiKey,
      ...queryParameters,
    };
    allParams.removeWhere((key, value) => value.isEmpty);

    return Uri.parse(fullUrlPath).replace(queryParameters: allParams);
  }

  Future<List<TorznabResultItem>> search(
      {String indexer = 'all', required SearchParams params}) async {
    final uri = _buildUri(indexer, queryParameters: params.toMap());
    try {
      final response = await _client.get(uri).timeout(const Duration(seconds: 30));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final document = XmlDocument.parse(response.body);

        final error = document.findAllElements('error').firstOrNull;
        if (error != null) {
          final description =
              error.getAttribute('description') ?? 'Unknown API error';
          throw Exception('Jackett API Error: $description');
        }

        final items = document.findAllElements('item');
        return items.map((node) => TorznabResultItem.fromXmlElement(node)).toList();
      } else {
        // Provide a more helpful error message to the user.
        throw Exception(
            'HTTP Error: ${response.statusCode}. Please check the Jackett URL and API Key in settings. Response: ${response.body}');
      }
    } on TimeoutException {
      throw Exception(
          'Request to Jackett timed out. Please check the server address and your connection.');
    } on http.ClientException catch (e) {
      throw Exception(
          'Network Error: ${e.message}. Is the Jackett server running and accessible at ${config.url}?');
    } catch (e) {
      rethrow;
    }
  }

  void dispose() {
    _client.close();
  }
}