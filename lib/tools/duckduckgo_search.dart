// lib/tools/duckduckgo_search.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

/// Represents the structure of an instant answer from DuckDuckGo.
class DuckDuckGoInstantAnswer {
  final String abstractText;
  final String abstractUrl;
  final String heading;
  final String definition;
  final String answer;

  DuckDuckGoInstantAnswer({
    this.abstractText = '',
    this.abstractUrl = '',
    this.heading = '',
    this.definition = '',
    this.answer = '',
  });

  factory DuckDuckGoInstantAnswer.fromJson(Map<String, dynamic> json) {
    return DuckDuckGoInstantAnswer(
      abstractText: json['AbstractText'] ?? '',
      abstractUrl: json['AbstractURL'] ?? '',
      heading: json['Heading'] ?? '',
      definition: json['Definition'] ?? '',
      answer: json['Answer'] ?? '',
    );
  }

  // Helper to format the output for the LLM
  String toLLMString(String query) {
    String resultSummary = " Answer for '$query':\n";

    if (answer.isNotEmpty) {
      resultSummary += "Answer: $answer\n";
    } else if (heading.isNotEmpty) {
      resultSummary += "Heading: $heading\n";
      if (abstractText.isNotEmpty) {
        resultSummary += "Summary: $abstractText\n";
      } else if (definition.isNotEmpty) {
        resultSummary += "Definition: $definition\n";
      }
    } else if (abstractText.isNotEmpty) {
      resultSummary += "Summary: $abstractText\n";
    } else if (definition.isNotEmpty) {
      resultSummary += "Definition: $definition\n";
    }

    if (abstractUrl.isNotEmpty) {
      resultSummary += "More Info: $abstractUrl\n";
    }

    if (resultSummary == "DuckDuckGo Instant Answer for '$query':\n") {
      return "No specific instant answer found for '$query'. The DuckDuckGo Instant Answer API provides very direct answers and may not have a result for all queries.";
    }
    return resultSummary;
  }
}

/// Calls the DuckDuckGo Instant Answer API.
///
/// Returns a [DuckDuckGoInstantAnswer] object or throws an exception on error.
Future<DuckDuckGoInstantAnswer> callDuckDuckGoInstantAnswerAPI({
  required String query,
  bool noHtml = true,
  bool noRedirect = false,
  bool skipDisambig = false,
}) async {
  final Map<String, String> queryParams = {
    'q': query,
    'format': 'json',
    'no_html': noHtml ? '1' : '0',
    'no_redirect': noRedirect ? '1' : '0',
    'skip_disambig': skipDisambig ? '1' : '0',
  };

  final Uri uri = Uri.https('api.duckduckgo.com', '/', queryParams);

  try {
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return DuckDuckGoInstantAnswer.fromJson(data);
    } else {
      throw Exception(
          "DuckDuckGo API error: Status ${response.statusCode}, Body: ${response.body}");
    }
  } catch (e) {
    throw Exception("Error connecting to DuckDuckGo API: $e");
  }
}
