import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/subtitletranslator/app_settings.dart';

class AiModelsService {
  static const String _openaiModelsEndpoint = '/models';
  static const String _geminiModelsEndpoint = '/models';

  /// Fetch available models from AI provider with retry logic
  static Future<List<String>> fetchAvailableModels({
    required String baseUrl,
    required String apiKey,
    required AiProvider provider,
    int maxRetries = 5,
  }) async {
    for (int attempt = 0; attempt <= maxRetries; attempt++) {
      try {
        switch (provider) {
          case AiProvider.openai:
            return await _fetchOpenAIModels(baseUrl, apiKey);
          case AiProvider.genai:
            return await _fetchGeminiModels(baseUrl, apiKey);
        }
      } catch (e) {
        if (attempt == maxRetries) {
          rethrow;
        }
        // Exponential backoff: wait 1s, 2s, 4s, 8s, 16s
        await Future.delayed(Duration(seconds: 1 << attempt));
      }
    }
    return [];
  }

  /// Fetch models from OpenAI API
  static Future<List<String>> _fetchOpenAIModels(
    String baseUrl,
    String apiKey,
  ) async {
    final uri = Uri.parse('$baseUrl/models');

    final response = await http
        .get(
          uri,
          headers: {
            'Authorization': 'Bearer $apiKey',
            'Content-Type': 'application/json',
          },
        )
        .timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final data = json['data'] as List<dynamic>?;

      if (data != null) {
        return data
            .whereType<Map<String, dynamic>>()
            .map((model) => model['id'] as String? ?? '')
            .where((id) => id.isNotEmpty)
            .toList()
          ..sort();
      }
    } else if (response.statusCode == 401) {
      throw Exception('Invalid API key');
    } else if (response.statusCode == 403) {
      throw Exception('Access denied to models endpoint');
    } else {
      throw Exception('Failed to fetch models: ${response.statusCode}');
    }

    return [];
  }

  /// Fetch models from Google Gemini API
  static Future<List<String>> _fetchGeminiModels(
    String baseUrl,
    String apiKey,
  ) async {
    final uri = Uri.parse('$baseUrl/models?key=$apiKey');

    final response = await http
        .get(uri, headers: {'Content-Type': 'application/json'})
        .timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final models = json['models'] as List<dynamic>?;

      if (models != null) {
        return models
            .whereType<Map<String, dynamic>>()
            .map((model) => model['name'] as String? ?? '')
            .where((name) => name.isNotEmpty)
            .map((name) => name.replaceFirst('models/', ''))
            .toList()
          ..sort();
      }
    } else if (response.statusCode == 401) {
      throw Exception('Invalid API key');
    } else if (response.statusCode == 403) {
      throw Exception('Access denied to models endpoint');
    } else {
      throw Exception('Failed to fetch models: ${response.statusCode}');
    }

    return [];
  }
}
