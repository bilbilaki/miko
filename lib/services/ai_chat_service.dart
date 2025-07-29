// lib/services/ai_chat_service.dart
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;
import 'package:miko/configs/consts.dart';
import 'package:miko/services/ai_tools.dart';


const String modelId = 'gemini-2.0-flash'; 
const double temperature = 0.7;

abstract class GeminiServiceBase {
final GenerativeModel model;
final customClient = http.Client();

  // 2. Define custom request options (e.g., different API endpoint)
  

  // Your actual app functions that the AI can call
  final Map<String, Function> _availableFunctions = {
    'performWebSearch': webSearchToolCall,
    'getMovieRecommendations': getRecommendsToolCall,
  };

  GeminiServiceBase()
      : model = GenerativeModel(
          // Use the 'pro' model for better function calling
          model: 'gemini-2.0-flash',
          apiKey: kApiKey,
          // Give the model all the tools it can use
          tools: [webSearchTool, movieRecommendTool],
          // Optional: Give the assistant a persona
          systemInstruction: Content.text(
              "You are Miko, a friendly and helpful in-app assistant. When asked for recommendations or web info, use your available tools."),
          safetySettings: [
            SafetySetting(HarmCategory.harassment, HarmBlockThreshold.low),
            SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.low),
          ],
        );
  final GenerationConfig generationConfig = GenerationConfig(
    temperature: temperature,
    maxOutputTokens: 2048, 
  );
  

// final model = GenerativeModel(
//   model: 'gemini-2.0-flash',
//   apiKey: kApiKey,
//   systemInstruction:Content("system", [TextPart("You are a helpful assistant")]),
//     //  tools: [tool],
// );
  // Common safety settings
  // final List<SafetySetting> safetySettings = [
  //   SafetySetting(
  //      SafetyCategory.harassment,
  //     threshold: SafetyThreshold.blockMediumAndAbove,
  //   ),
  //   SafetySetting(
  //     category: SafetyCategory.hateSpeech,
  //     threshold: SafetyThreshold.blockMediumAndAbove,
  //   ),
  // ];
  Future<String> getResponse(String prompt, {Uint8List? imageBytes});
        Future<Map<String, dynamic>> _callFunction(Function function, Map<String, Object?> args) {
      // Convert the model's arguments to a format our functions expect
      final positionalArgs = [];
      final namedArgs = <Symbol, dynamic>{};
      
      // This is a simplified dynamic invoker. For your specific functions:
      if (function == webSearchToolCall) {
        return webSearchToolCall(args['query'] as String);
      } else if (function == getRecommendsToolCall) {
        return getRecommendsToolCall(
          args['name'] as String,
          args['page'] as int?,
          args['language'] as String?,
          args['isMovie'] as bool,
        );
      }
      // Add more else-if blocks for new functions
      
      throw Exception('Function call dispatcher not implemented for this function.');
  }
Future<String> countMyTokens() async {
  final prompt = 'How many tokens are in this specific sentence?';
  final content = [Content.text(prompt)];

  final response = await model.countTokens(content);
  return ('Total tokens: ${response.totalTokens}');
}

    
  Stream<String> getStreamResponse(String prompt, {Uint8List? imageBytes});

  Future<String?> generateAudioResponse(String prompt) async => null;
}

class GeminiTextChatService extends GeminiServiceBase {
  @override
  Future<String> getResponse(String prompt, {Uint8List? imageBytes}) async {
      final content = [Content.text(prompt)];
    try {
      final res = await model.generateContent(content,generationConfig: generationConfig);
  print(res.promptFeedback?.blockReason);
  print(res.candidates.first.finishReason);
      return res.text ?? 'No content received.';
    } catch (e) {
      return 'Error: $e';
    }
  }

  @override
  Stream<String> getStreamResponse(String prompt, {Uint8List? imageBytes}) async* {
    try {
      // Start the chat session on the first message
      final chat = model.startChat();
      
      // 1. Send the user's prompt to the model
      var response = await chat.sendMessage(Content.text(prompt));

      // 2. Check if the model wants to call a function
      var functionCall = response.candidates.first.content.parts
          .whereType<FunctionCall>()
          .firstOrNull;

      // 3. Loop as long as the model wants to call functions
      while (functionCall != null) {
        // 3a. Find the function in our available functions map
        final functionToCall = _availableFunctions[functionCall.name];
        if (functionToCall == null) {
          throw Exception('Error: Model requested an unknown function: ${functionCall.name}');
        }

        // 3b. Call the actual Dart function with arguments from the model
        // Note: This dynamic calling is powerful but requires careful argument handling
        final result = await _callFunction(functionToCall, functionCall.args);
        
        // 3c. Send the function's result back to the model
        response = await chat.sendMessage(
          Content.functionResponse(functionCall.name, result),
        );
        
        // 3d. Check if the model wants to call *another* function
        functionCall = response.candidates.first.content.parts
            .whereType<FunctionCall>()
            .firstOrNull;
      }
      
      // 4. Once the loop is done, the model has a final text answer. Stream it.
      if (response.text != null) {
        yield response.text!;
      } else {
        yield 'Sorry, I could not process that request.';
      }

    } catch (e) {
      print('Error in AssistantService: $e');
      yield 'An error occurred. Please try again.';
    }
  }
}

class GeminiMultiModalService extends GeminiServiceBase {


  @override
  Future<String> getResponse(String prompt, {Uint8List? imageBytes}) async {
        final chat = model.startChat(generationConfig: generationConfig);
final prompts = TextPart(prompt);
    if (imageBytes != null) {

  final data = imageBytes.buffer.asUint8List();
  final imagePart = DataPart('image/jpeg', data);
final content = Content.multi([prompts, imagePart]);

var response = await chat.sendMessage(content);
      return response.text ?? 'No content received.';

    }else{

      final content = Content.multi([prompts]);

var response = await chat.sendMessage(content);
      return response.text ?? 'No content received.';

    }
    

   
  }

  @override
  Stream<String> getStreamResponse(String prompt, {Uint8List? imageBytes}) async*{
final prompts = TextPart(prompt);
    if (imageBytes != null) {

  final data = imageBytes.buffer.asUint8List();
  final imagePart = DataPart('image/jpeg', data);
final content = ([Content.multi([prompts, imagePart])]);

var response = model.generateContentStream(content,generationConfig: generationConfig);
      await for (final value in response) {
        yield value.text ?? '';
      }

    }else{

      final content = ([Content.multi([prompts])]);

var response = model.generateContentStream(content,generationConfig: generationConfig);
await for (final value in response) {
        yield value.text ?? '';
      }
    }}
}

// class GeminiToolCallingService extends GeminiServiceBase {

//   @override
//   Future<String> getResponse(String prompt, {Uint8List? imageBytes}) async {
   
//   }

//   @override
//   Stream<String> getStreamResponse(String prompt, {Uint8List? imageBytes}) {
  
//   }
// }

// // Service to simulate structured JSON output via prompt engineering.
// class GeminiStructuredOutputService extends GeminiServiceBase {
//   final String _jsonSchemaPrompt = '''
// From the user's text, extract the information requested and respond ONLY with a valid JSON object. Do not include any explanatory text before or after the JSON.
// The JSON object must match this schema:
// {
//   "type": "object",
//   "properties": {
//     "name": {"type": "string", "description": "The full name of the person."},
//     "age": {"type": "integer", "description": "The age of the person."}
//   },
//   "required": ["name", "age"]
// }

// User text:
// ''';

//   @override
//   Future<String> getResponse(String prompt, {Uint8List? imageBytes}) async {
  
//   }

//   @override
//   Stream<String> getStreamResponse(String prompt, {Uint8List? imageBytes}) {
   
// }}
