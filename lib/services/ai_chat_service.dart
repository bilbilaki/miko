// lib/services/ai_chat_service.dart
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_gemini/flutter_gemini.dart';

// Common settings for Gemini can be defined here if needed
const String modelId = 'gemini-2.0-flash'; // Or any other suitable model
const double temperature = 0.7;

// A new base class for Gemini services
abstract class GeminiServiceBase {
  final gemini = Gemini.instance;

  // Common generation configuration
  final GenerationConfig generationConfig = GenerationConfig(
    temperature: temperature,
    maxOutputTokens: 2048, // Example value
  );

  // Common safety settings
  final List<SafetySetting> safetySettings = [
    SafetySetting(
      category: SafetyCategory.harassment,
      threshold: SafetyThreshold.blockMediumAndAbove,
    ),
    SafetySetting(
      category: SafetyCategory.hateSpeech,
      threshold: SafetyThreshold.blockMediumAndAbove,
    ),
  ];

  Future<String> getResponse(String prompt, {Uint8List? imageBytes});
  Stream<String> getStreamResponse(String prompt, {Uint8List? imageBytes});

  // Audio generation is not directly supported by the flutter_gemini package
  Future<String?> generateAudioResponse(String prompt) async => null;
}

// Service for simple text-only chats
class GeminiTextChatService extends GeminiServiceBase {
  @override
  Future<String> getResponse(String prompt, {Uint8List? imageBytes}) async {
    try {
      final res = await gemini.prompt(
       model: modelId,
        generationConfig: generationConfig,
        safetySettings: safetySettings,
         parts: [Part.text(prompt)],
      );
      return res?.output ?? 'No content received.';
    } catch (e) {
      return 'Error: $e';
    }
  }

  @override
  Stream<String> getStreamResponse(String prompt, {Uint8List? imageBytes}) {
    try {
      return gemini
          .promptStream(
        parts: [Part.text(prompt)],
        generationConfig: generationConfig,
        safetySettings: safetySettings,
        model: modelId,
      )
          .map((value) => value?.output ?? '');
    } catch (e) {
      return Stream.error(e);
    }
  }
}

// Service for multimodal chats (text and image)
class GeminiMultiModalService extends GeminiServiceBase {
  @override
  Future<String> getResponse(String prompt, {Uint8List? imageBytes}) async {
    final List<Part> parts = [Part.text(prompt)];
    if (imageBytes != null) {
      // The flutter_gemini package uses `Part.inline` for raw byte data.
      // We assume a generic MIME type; adjust if you have specific file types.
      parts.add(Part.inline(imageBytes as InlineData));
    }

    try {
      final res = await gemini.prompt(
        parts: parts,
        generationConfig: generationConfig,
        safetySettings: safetySettings,
        model: modelId,
      );
      return res?.output ?? 'No content received.';
    } catch (e) {
      return 'Error: $e';
    }
  }

  @override
  Stream<String> getStreamResponse(String prompt, {Uint8List? imageBytes}) {
    final List<Part> parts = [Part.text(prompt)];
    if (imageBytes != null) {
      parts.add(Part.inline(imageBytes as InlineData));
    }

    try {
      return gemini
          .promptStream(
        parts: parts,
        generationConfig: generationConfig,
        safetySettings: safetySettings,
        model: modelId,
      )
          .map((value) => value?.output ?? '');
    } catch (e) {
      return Stream.error(e);
    }
  }
}

// Service to simulate "Tool Calling" mode as a multi-turn chat.
// Note: The provided flutter_gemini docs do not include native tool/function calling.
// This implementation uses the chat endpoint, but true tool calling logic is omitted.
class GeminiToolCallingService extends GeminiServiceBase {
  // For a real multi-turn conversation, chat history should be managed
  // in the AIChatNotifier and passed to this service. Since it's not,
  // we start a new "chat" every time.

  @override
  Future<String> getResponse(String prompt, {Uint8List? imageBytes}) async {
    // Represents a single-turn "chat"
    final chatHistory = [
      Content(parts: [Part.text("You are a helpful assistant.")], role: 'model'),
      Content(parts: [Part.text(prompt)], role: 'user'),
    ];
    try {
      final res = await gemini.chat(
        chatHistory,
        generationConfig: generationConfig,
        safetySettings: safetySettings,
        modelName: modelId,
      );
      return res?.output ?? 'No content received.';
    } catch (e) {
      return 'Error: $e';
    }
  }

  @override
  Stream<String> getStreamResponse(String prompt, {Uint8List? imageBytes}) {
    // The gemini.chat() method doesn't have a streaming equivalent in the docs.
    // We fall back to promptStream, which is suitable for single-turn streaming.
    try {
      return gemini
          .promptStream(
        parts: [Part.text(prompt)], // Simplification for streaming
        generationConfig: generationConfig,
        safetySettings: safetySettings,
        model: modelId,
      )
          .map((value) => value!.output ?? '');
    } catch (e) {
      return Stream.error(e);
    }
  }
}

// Service to simulate structured JSON output via prompt engineering.
class GeminiStructuredOutputService extends GeminiServiceBase {
  final String _jsonSchemaPrompt = '''
From the user's text, extract the information requested and respond ONLY with a valid JSON object. Do not include any explanatory text before or after the JSON.
The JSON object must match this schema:
{
  "type": "object",
  "properties": {
    "name": {"type": "string", "description": "The full name of the person."},
    "age": {"type": "integer", "description": "The age of the person."}
  },
  "required": ["name", "age"]
}

User text:
''';

  @override
  Future<String> getResponse(String prompt, {Uint8List? imageBytes}) async {
    final fullPrompt = '$_jsonSchemaPrompt"$prompt"';
    try {
      final res = await gemini.prompt(
       parts: [Part.text(fullPrompt)],
        generationConfig: GenerationConfig(temperature: 0), // Low temp for precision
        safetySettings: safetySettings,
        model: modelId,
      );
      final output = res?.output ?? 'No content received.';
      // Attempt to parse and pretty-print the JSON response
      try {
        final parsedJson = json.decode(output);
        return 'Structured Output (JSON):\n${JsonEncoder.withIndent('  ').convert(parsedJson)}';
      } catch (e) {
        return 'Received non-JSON content: $output';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }

  @override
  Stream<String> getStreamResponse(String prompt, {Uint8List? imageBytes}) {
    final fullPrompt = '$_jsonSchemaPrompt"$prompt"';
    try {
      // It's tricky to validate streaming JSON. We stream the raw output
      // and let the client handle parsing the complete result.
      return gemini
          .promptStream(
        parts: [Part.text(fullPrompt)],
        generationConfig: GenerationConfig(temperature: 0),
        safetySettings: safetySettings,
        model: modelId,
      )
          .map((value) => value!.output ?? '');
    } catch (e) {
      return Stream.error(e);
    }
  }
}