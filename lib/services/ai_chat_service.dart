// lib/services/ai_chat_service.dart
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:miko/configs/consts.dart';
//import 'package:miko/services/ai_chat_service.dart';
import 'package:tmdb_api/tmdb_api.dart';
import 'dart:convert';
import 'package:miko/showcases/model.dart';
//import '../providers/ai_chat_provider.dart';
import '../showcases/movie_service.dart';
part '../configs/ai_tools_schema.dart';
part '../configs/ai_tools_dialers.dart';
part 'ai_tools_functions.dart';

final MovieService _movieService = MovieService();

const String modelId = 'gemini-2.0-flash';
const double temperature = 0.7;

abstract class GeminiServiceBase {
  final GenerativeModel model;
  final customClient = http.Client();
  final Map<String, Function> _availableFunctions = {
    'performWebSearch': webSearchToolCall,
    'getMovieRecommendations': getRecommendsToolCall,
    'getPopular': getPopularToolCall,
    'getMovieCredits': getMovieCreditsToolCall,
    'getPersonDetails': getPersonDetailsToolCall,
    'getTvShowEpisodeDetails': getTvShowEpisodeDetailsToolCall,
    'getTVCredits': getTVCreditsToolCall
  };
  Ref ref;

  GeminiServiceBase(this.ref)
      : model = GenerativeModel(
          model: 'gemini-2.0-flash',
          apiKey: kApiKey,
          tools: [
            webSearchTool,
            movieRecommendTool,
            getPopularTool,
            movieCreditsTool,
            personDetailsTool,
            tvShowEpisodeDetailsTool,
            tvCreditsTool
          ],
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

  Future<Map<String, dynamic>> _callFunction(
      Function function, Map<String, Object?> args) {
    // Convert the model's arguments to a format our functions expect
    //final positionalArgs = [];
    //final namedArgs = <Symbol, dynamic>{};

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
    } else if (function == getPopularToolCall) {
      return getPopularToolCall(args['language'] as String?,
          args['page'] as int?, args['isMovie'] as bool, ref);
    } else if (function == getPersonDetailsToolCall) {
      return getPersonDetailsToolCall(personName: args['personName'] as String);
    } else if (function == getMovieCreditsToolCall) {
      return getMovieCreditsToolCall(movieName: args['movieName'] as String);
    } else if (function == getTvShowEpisodeDetailsToolCall) {
      return getTvShowEpisodeDetailsToolCall(
          tvShowName: args['tvShowName'] as String,
          seasonNumber: args['seasonNumber'] as int,
          episodeNumber: args['episodeNumber'] as int);
    } else if (function == getTVCreditsToolCall) {
      return getTVCreditsToolCall(tvShowName: args['tvShowName'] as String);
    }

    throw Exception(
        'Function call dispatcher not implemented for this function.');
  }

  Future<String> countMyTokens(String prompt) async {
    final content = [Content.text(prompt)];

    final response = await model.countTokens(content);
    return ('Total tokens: ${response.totalTokens}');
  }

  Stream<String> getStreamResponse(String prompt, {Uint8List? imageBytes});

  Future<String?> generateAudioResponse(String prompt) async => null;
}

class GeminiTextChatService extends GeminiServiceBase {
  GeminiTextChatService(super.ref);

  @override
  Stream<String> getStreamResponse(String prompt,
      {Uint8List? imageBytes}) async* {
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
          throw Exception(
              'Error: Model requested an unknown function: ${functionCall.name}');
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
  GeminiMultiModalService(super.ref);

  @override
  Stream<String> getStreamResponse(String prompt,
      {Uint8List? imageBytes}) async* {
    final prompts = TextPart(prompt);
    if (imageBytes != null) {
      final data = imageBytes.buffer.asUint8List();
      final imagePart = DataPart('image/jpeg', data);
      final content = ([
        Content.multi([prompts, imagePart])
      ]);

      var response = model.generateContentStream(content,
          generationConfig: generationConfig);
      await for (final value in response) {
        yield value.text ?? '';
      }
    } else {
      final content = ([
        Content.multi([prompts])
      ]);

      var response = model.generateContentStream(content,
          generationConfig: generationConfig);
      await for (final value in response) {
        yield value.text ?? '';
      }
    }
  }
}
