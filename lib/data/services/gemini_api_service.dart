import 'dart:typed_data'; // For Uint8List
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:miko/configs/consts.dart';

class GeminiModelService {
  late final GenerativeModel _textModel;
  late final GenerativeModel _visionModel;

  final List<String> availableModels = ['gemini-2.5-flash', 'gemini-2.5-pro', 'gemini-2.5-pro-vision'];
  String _selectedModel = 'gemini-2.5-flash';
  bool thinkingMode = false;

  GeminiModelService() {
    final apiKey = kApiKey;
    if (apiKey == null || apiKey.isEmpty) {
      throw StateError('GEMINI_API_KEY is not set in the .env file.');
    }

    _updateModels(apiKey);
  }

  void _updateModels(String apiKey) {
    _textModel = GenerativeModel(model: _selectedModel, apiKey: apiKey);
    _visionModel = GenerativeModel(model: 'gemini-2.5-pro-vision', apiKey: apiKey);
  }

  void setModel(String modelName) {
    if (availableModels.contains(modelName)) {
      _selectedModel = modelName;
      final apiKey = kApiKey;
      if (apiKey != null && apiKey.isNotEmpty) {
        _updateModels(apiKey);
      }
    }
  }

  void setTemperature(double temperature) {
    // The generationConfig is part of the GenerativeModel object.
    // We need to recreate the models with the new temperature.
    final apiKey = kApiKey;
    if (apiKey != null && apiKey.isNotEmpty) {
      _textModel = GenerativeModel(
        model: _selectedModel,
        apiKey: apiKey,
        generationConfig: GenerationConfig(temperature: temperature),
      );
      _visionModel = GenerativeModel(
        model: 'gemini-2.5-pro-vision',
        apiKey: apiKey,
        generationConfig: GenerationConfig(temperature: temperature),
      );
    }
  }

  void setThinkingMode(bool enabled) {
    thinkingMode = enabled;
  }

  /// For the "Thinking Client" (One-shot tasks)
  /// Accepts text and optional image bytes (as JPEG for simplicity here).
  Future<String> generateSingleTurnResponse(String textPrompt, {List<Uint8List>? imageBytes}) async {
    final modelToUse = (imageBytes != null && imageBytes.isNotEmpty) ? _visionModel : _textModel;
    
    final contentParts = [
      TextPart(textPrompt),
      if (imageBytes != null && imageBytes.isNotEmpty)
        // Assuming JPEG for simplicity. For other formats, you'd need logic
        // to determine the MIME type.
        ...imageBytes.map((bytes) => DataPart('image/jpeg', bytes)).toList(),
    ];

    try {
      final response = await modelToUse.generateContent([Content.multi(contentParts)]);
      return response.text ?? '';
    } catch (e) {
      print('Gemini API Error (generateSingleTurnResponse): $e');
      throw Exception('Failed to generate single turn response: ${e.toString()}');
    }
  }

  /// For the "Chatting Client" (Conversational tasks)
  /// Returns a ChatSession object that can manage chat history.
  ChatSession startChatSession({List<Content>? history}) {
    // The history passed here is what Gemini will consider as context for this new session.
    return _textModel.startChat(history: history ?? []);
  }

  /// For the "Tools Client" (Function Calling)
  Future<GenerateContentResponse> generateWithTools(String textPrompt, List<Tool> availableTools) async {
    final modelWithTools = GenerativeModel(
      model: 'gemini-2.5-flash', // Gemini Pro is used for function calling
      apiKey: kApiKey,
      tools: availableTools,
    );
    try {
      final response = await modelWithTools.generateContent([Content.text(textPrompt)]);
      return response;
    } catch (e) {
      print('Gemini API Error (generateWithTools): $e');
      throw Exception('Failed to generate response with tools: ${e.toString()}');
    }
  }
}