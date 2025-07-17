// lib/services/ai_chat_service.dart
// (Copy the full content from the previous response here)
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:miko/configs/ai_config_etc.dart';
import 'package:miko/tools/function_tools.dart';
import 'package:miko/tools/json_tools.dart';
import 'package:miko/tools/tool_call_performers.dart';
import 'package:openai_dart/openai_dart.dart';

//import 'dart:convert';

abstract class OpenAIServiceBase {
  late final OpenAIClient client;

  OpenAIServiceBase() {
    final apiKey = groqapi;
    client = OpenAIClient(
      apiKey: apiKey,
      baseUrl: 'https://api.groq.com/openai/v1',
    );
  }

  Future<String> getResponse(String prompt,
      {String? imageUrl,
      String? base64Image,
      String? base64Audio,
      String? audioFormat});
  Stream<String> getStreamResponse(String prompt,
      {String? imageUrl,
      String? base64Image,
      String? base64Audio,
      String? audioFormat});
  Future<String?> generateAudioResponse(
      String prompt); // New method for audio output
}

class OpenAITextChatService extends OpenAIServiceBase {
  @override
  Future<String> getResponse(String prompt,
      {String? imageUrl,
      String? base64Image,
      String? base64Audio,
      String? audioFormat}) async {
    final chatMessages = <ChatCompletionMessage>[
      ChatCompletionMessage.system(content: systemcontent),
      ChatCompletionMessage.user(
          content: ChatCompletionUserMessageContent.string(prompt)),
    ];

    final request = CreateChatCompletionRequest(
      model: ChatCompletionModel.modelId(modelid), // Or other appropriate model
      messages: chatMessages,
      temperature: tmp,
    );

    try {
      final res = await client.createChatCompletion(request: request);
      return res.choices.first.message.content ?? 'No content received.';
    } catch (e) {
      return 'Error: $e';
    }
  }

  @override
  Stream<String> getStreamResponse(String prompt,
      {String? imageUrl,
      String? base64Image,
      String? base64Audio,
      String? audioFormat}) {
    final List<ChatCompletionMessageContentPart> parts = [
      ChatCompletionMessageContentPart.text(text: prompt),
    ];
    if (base64Image != null && base64Image.isNotEmpty) {
      parts.add(ChatCompletionMessageContentPart.image(
        imageUrl: ChatCompletionMessageImageUrl(
            url: base64Image, detail: ChatCompletionMessageImageDetail.high),
      ));
    }
    // ... (add other parts for audio etc. as you did before) ...
    final chatMessages = <ChatCompletionMessage>[
      ChatCompletionMessage.system(content: systemcontent),
      ChatCompletionMessage.user(
          content: ChatCompletionUserMessageContent.parts(parts)),
    ];

    final request = CreateChatCompletionRequest(
      model: ChatCompletionModel.modelId(modelid),
      messages: chatMessages,
      temperature: tmp,
    );

    try {
      final stream = client.createChatCompletionStream(request: request);

      // Use asyncExpand for robust filtering and mapping
      return stream.asyncExpand((res) {
        // Check if the choices list is valid and has elements
        if (res.choices.isNotEmpty) {
          // Now it's safe to access .first
          final delta = res.choices.first.delta;
          final content = delta?.content;

          // Only yield content if it's not null
          if (content != null) {
            return Stream.value(content);
          }
        }
        // If choices is empty or content is null, yield nothing for this event.
        return const Stream.empty();
      });
    } catch (e) {
      // This catch block might not be reached for stream setup errors,
      // but it's good practice to keep it.
      return Stream.error(e);
    }
  }

  @override
  Future<String?> generateAudioResponse(String prompt) async {
    // Text-only chat service does not generate audio responses directly
    return null;
  }
}

class OpenAIMultiModalService extends OpenAIServiceBase {
  @override
  Future<String> getResponse(String prompt,
      {String? imageUrl,
      String? base64Image,
      String? base64Audio,
      String? audioFormat}) async {
    final List<ChatCompletionMessageContentPart> parts = [
      ChatCompletionMessageContentPart.text(text: prompt),
    ];

    if (imageUrl != null && imageUrl.isNotEmpty) {
      parts.add(ChatCompletionMessageContentPart.image(
        imageUrl: ChatCompletionMessageImageUrl(url: imageUrl),
      ));
    } else if (base64Image != null && base64Image.isNotEmpty) {
      parts.add(ChatCompletionMessageContentPart.image(
        imageUrl: ChatCompletionMessageImageUrl(
            url: base64Image,
            detail: ChatCompletionMessageImageDetail
                .high), // Use detail: high for base64
      ));
    } else if (base64Audio != null &&
        base64Audio.isNotEmpty &&
        audioFormat != null) {
      parts.add(ChatCompletionMessageContentPart.audio(
        inputAudio: ChatCompletionMessageInputAudio(
          data: base64Audio,
          format: ChatCompletionMessageInputAudioFormat
              .mp3, // Convert string to enum
        ),
      ));
    }

    final chatMessages = <ChatCompletionMessage>[
      ChatCompletionMessage.system(content: systemcontent),
      ChatCompletionMessage.user(
          content: ChatCompletionUserMessageContent.parts(parts)),
    ];

    final request = CreateChatCompletionRequest(
      model: ChatCompletionModel.modelId(
          modelid), // qwen/qwen3-32b supports multimodal input
      messages: chatMessages,
      temperature: tmp,
    );

    try {
      final res = await client.createChatCompletion(request: request);
      return res.choices.first.message.content ?? 'No content received.';
    } catch (e) {
      return 'Error: $e';
    }
  }

  @override
  Stream<String> getStreamResponse(String prompt,
      {String? imageUrl,
      String? base64Image,
      String? base64Audio,
      String? audioFormat}) {
    final List<ChatCompletionMessageContentPart> parts = [
      ChatCompletionMessageContentPart.text(text: prompt),
    ];
    if (base64Image != null && base64Image.isNotEmpty) {
      parts.add(ChatCompletionMessageContentPart.image(
        imageUrl: ChatCompletionMessageImageUrl(
            url: base64Image, detail: ChatCompletionMessageImageDetail.high),
      ));
    }
    // ... (add other parts for audio etc. as you did before) ...

    if (imageUrl != null && imageUrl.isNotEmpty) {
      parts.add(ChatCompletionMessageContentPart.image(
        imageUrl: ChatCompletionMessageImageUrl(url: imageUrl),
      ));
    } else if (base64Image != null && base64Image.isNotEmpty) {
      parts.add(ChatCompletionMessageContentPart.image(
        imageUrl: ChatCompletionMessageImageUrl(
            url: base64Image, detail: ChatCompletionMessageImageDetail.high),
      ));
    } else if (base64Audio != null &&
        base64Audio.isNotEmpty &&
        audioFormat != null) {
      parts.add(ChatCompletionMessageContentPart.audio(
        inputAudio: ChatCompletionMessageInputAudio(
          data: base64Audio,
          format: ChatCompletionMessageInputAudioFormat.mp3,
        ),
      ));
    }

    final chatMessages = <ChatCompletionMessage>[
      ChatCompletionMessage.system(content: systemcontent),
      ChatCompletionMessage.user(
          content: ChatCompletionUserMessageContent.parts(parts)),
    ];

    final request = CreateChatCompletionRequest(
      model: ChatCompletionModel.modelId(modelid),
      messages: chatMessages,
      temperature: tmp,
    );

    try {
      final stream = client.createChatCompletionStream(request: request);

      // Use asyncExpand for robust filtering and mapping
      return stream.asyncExpand((res) {
        // Check if the choices list is valid and has elements
        if (res.choices.isNotEmpty) {
          // Now it's safe to access .first
          final delta = res.choices.first.delta;
          final content = delta?.content;

          // Only yield content if it's not null
          if (content != null) {
            return Stream.value(content);
          }
        }
        // If choices is empty or content is null, yield nothing for this event.
        return const Stream.empty();
      });
    } catch (e) {
      // This catch block might not be reached for stream setup errors,
      // but it's good practice to keep it.
      return Stream.error(e);
    }
  }

  @override
  Future<String?> generateAudioResponse(String prompt) async {
    final chatMessages = <ChatCompletionMessage>[
      ChatCompletionMessage.user(
          content: ChatCompletionUserMessageContent.string(prompt)),
    ];

    final request = CreateChatCompletionRequest(
      // The documentation suggests gpt4oAudioPreview, but qwen/qwen3-32b might also work for some cases.
      // If you specifically need audio output, you might need to use `qwen/qwen3-32b-audio-preview` if `qwen/qwen3-32b` doesn't natively return it.
      // However, the example shows "gpt4oAudioPreview" used with modalities.
      model: ChatCompletionModel.modelId(ttsmodelid),
      modalities: [ChatCompletionModality.text, ChatCompletionModality.audio],
      audio: ChatCompletionAudioOptions(
        voice: ChatCompletionAudioVoice.alloy,
        format: ChatCompletionAudioFormat.wav,
      ),
      messages: chatMessages,
    );

    try {
      final res = await client.createChatCompletion(request: request);
      final audioData = res.choices.first.message.audio?.data;
      if (audioData != null) {
        return audioData; // Returns base64 audio data
      }
      return null;
    } catch (e) {
      print('Error generating audio response: $e');
      return null;
    }
  }
}

class OpenAIToolCallingService extends OpenAIServiceBase {
  @override
  Future<String> getResponse(String prompt,
      {String? imageUrl,
      String? base64Image,
      String? base64Audio,
      String? audioFormat}) async {
    List<ChatCompletionMessage> messages = [
      ChatCompletionMessage.system(content: systemcontent),
      ChatCompletionMessage.user(
          content: ChatCompletionUserMessageContent.string(prompt)),
    ];

    try {
      // Step 1: Send user message with tool definition
      final res1 = await client.createChatCompletion(
        request: CreateChatCompletionRequest(
          model: ChatCompletionModel.modelId(
              modelid), // Models like qwen/qwen3-32b support tool calling
          messages: messages,
          tools: [weatherTool, movieRecommendTool],
          toolChoice: ChatCompletionToolChoiceOption.mode(
              ChatCompletionToolChoiceMode.auto), // Let model decide
        ),
      );

      final choice1 = res1.choices.first;
      final message1 = choice1.message;

      if (message1.toolCalls != null && message1.toolCalls!.isNotEmpty) {
        // Model wants to call a tool
        final toolCall = message1.toolCalls!.first;
        if (toolCall.function.name == weatherFunction.name) {
          final arguments =
              json.decode(toolCall.function.arguments) as Map<String, dynamic>;
          final functionResult = await webSearchToolCall(
            arguments['query'] as String,
          );

          // Step 2: Add tool message and send again
          messages.add(message1); // Add the assistant's tool_calls message
          messages.add(ChatCompletionMessage.tool(
            toolCallId: toolCall.id,
            content: json.encode(functionResult), // Provide the tool's output
          ));

          final res2 = await client.createChatCompletion(
            request: CreateChatCompletionRequest(
              model: ChatCompletionModel.modelId(modelid),
              messages: messages,
              tools: [
                weatherTool
              ], // Include tools again if model might call another
            ),
          );
          return res2.choices.first.message.content ??
              'No content received after tool call.';
        } else if (toolCall.function.name == movieRecommendFunction.name) {
         // yield '\n\n-- Calling tool: ${movieRecommendFunction.name}(${jsonEncode(functionArguments)}) --\n\n';
           final arguments = json.decode(toolCall.function.arguments) as Map<String, dynamic>;

          // Call our wrapper function with the arguments provided by the AI
          final functionResult = await getRecommendsToolCall(
             arguments['name'] as String,
             arguments['page'] as int?, // Handle optional params
             arguments['language'] as String?,
             arguments['isMovie'] as bool
          );

          // Step 2: Send the result of the function call back to the AI
          messages.add(message1
              as ChatCompletionMessage); // Add the AI's tool_calls message
          messages.add(ChatCompletionMessage.tool(
            toolCallId: toolCall.id,
            content: json.encode(functionResult), // Provide the tool's output
          ));

 final res2 = await client.createChatCompletion(
            request: CreateChatCompletionRequest(
              model: ChatCompletionModel.modelId(modelid),
              messages: messages,
              tools: [
                movieRecommendTool
              ], // Include tools again if model might call another
            ),
          );
          return res2.choices.first.message.content ??
              'No content received after tool call.';
          
        } else {
          return 'Model requested an unknown tool: ${toolCall.function.name}';
        }
      } else {
        // Model responded directly without a tool call
        return message1.content ?? 'No tool call or content.';
      }
    } catch (e) {
      return 'Error in tool calling: $e';
    }
  }

  @override
  Stream<String> getStreamResponse(String prompt,
      {String? imageUrl,
      String? base64Image,
      String? base64Audio,
      String? audioFormat}) async* {
    List<ChatCompletionMessage> messages = [
      ChatCompletionMessage.system(content: systemcontent),
      ChatCompletionMessage.user(
          content: ChatCompletionUserMessageContent.string(prompt)),
    ];

    try {
      // Step 1: Initial stream request
      final stream1 = client.createChatCompletionStream(
        request: CreateChatCompletionRequest(
          model: ChatCompletionModel.modelId(modelid),
          messages: messages,
          tools: [weatherTool, movieRecommendTool],
          toolChoice: ChatCompletionToolChoiceOption.mode(
              ChatCompletionToolChoiceMode.auto),
        ),
      );

      StringBuffer streamedContent = StringBuffer();
      ChatCompletionStreamMessageFunctionCall? assistantToolCallMessage;
      String? toolCallId;
      String? functionName;
      Map<String, dynamic>? functionArguments;

      await for (final res in stream1) {
        final choice = res.choices.first;

        // Accumulate tool call data if present
        if (choice.delta!.toolCalls != null &&
            choice.delta!.toolCalls!.isNotEmpty) {
          final toolCallDelta = choice.delta!.toolCalls!.first;
          toolCallId = toolCallDelta.id ?? toolCallId;
          functionName = toolCallDelta.function?.name ?? functionName;
          if (toolCallDelta.function?.arguments != null) {
            functionArguments = (functionArguments ?? {})
              ..addAll(json.decode(toolCallDelta.function!.arguments!));
          }
          // The full tool_calls message is received in the last chunk for streaming tool calls
          if (res.choices.first.delta!.toolCalls != null &&
              res.choices.first.delta!.toolCalls!.isNotEmpty) {
            assistantToolCallMessage = res.choices.first.delta!.functionCall;
          }
        } else if (choice.delta!.content != null) {
          // If content is streamed, yield it
          streamedContent.write(choice.delta!.content);
          yield choice.delta!.content!;
        }
      }

      // If a tool call was detected and completed
      if (functionName != null &&
          functionArguments != null &&
          toolCallId != null &&
          assistantToolCallMessage != null) {
        if (functionName == weatherFunction.name) {
          yield '\n\n-- Calling tool: ${weatherFunction.name}(${jsonEncode(functionArguments)}) --\n\n';
          final functionResult = await webSearchToolCall(
            functionArguments['query'] as String,
          );

          // Step 2: Add tool message and send again for the final response
          messages.add(assistantToolCallMessage
              as ChatCompletionMessage); // Add the full assistant tool_calls message from the stream
          messages.add(ChatCompletionMessage.tool(
            toolCallId: toolCallId,
            content: json.encode(functionResult),
          ));

          final stream2 = client.createChatCompletionStream(
            request: CreateChatCompletionRequest(
              model: ChatCompletionModel.modelId(modelid),
              messages: messages,
              tools: [movieRecommendTool],
            ),
          );

          await for (final res in stream2) {
            yield res.choices.first.delta!.content ?? '';
          }
        } else if (functionName == movieRecommendFunction.name) {
          yield '\n\n-- Calling tool: ${movieRecommendFunction.name}(${jsonEncode(functionArguments)}) --\n\n';
          // final arguments = json.decode(functionArguments) as Map<String, dynamic>;

          // Call our wrapper function with the arguments provided by the AI
          final functionResult = await getRecommendsToolCall(
           functionArguments['name'] as String,
             functionArguments['page'] as int?, // Handle optional params
           functionArguments['language'] as String?,
           functionArguments['isMovie'] as bool
          );

          // Step 2: Send the result of the function call back to the AI
          messages.add(assistantToolCallMessage
              as ChatCompletionMessage); // Add the AI's tool_calls message
          messages.add(ChatCompletionMessage.tool(
            toolCallId: toolCallId,
            content: json.encode(functionResult), // Provide the tool's output
          ));

          final stream2 = client.createChatCompletionStream(
            request: CreateChatCompletionRequest(
              model: ChatCompletionModel.modelId(modelid),
              messages: messages,
              tools: [movieRecommendTool],
            ),
          );

          // The AI now has the context and the data to give a final, user-friendly answer
          await for (final res in stream2) {
            yield res.choices.first.delta!.content ?? '';
          }
        } else {
          yield 'Model requested an unknown tool: $functionName';
        }
      } else if (streamedContent.isNotEmpty) {
        // If content was streamed and no tool call, we already yielded it.
        // No further action needed here for this path.
      } else {
        yield 'No tool call or content received.';
      }
    } catch (e) {
      yield 'Error in streaming tool calling: $e';
    }
  }

  @override
  Future<String?> generateAudioResponse(String prompt) async {
    final chatMessages = <ChatCompletionMessage>[
      ChatCompletionMessage.user(
          content: ChatCompletionUserMessageContent.string(prompt)),
    ];

    final request = CreateChatCompletionRequest(
      // The documentation suggests gpt4oAudioPreview, but qwen/qwen3-32b might also work for some cases.
      // If you specifically need audio output, you might need to use `qwen/qwen3-32b-audio-preview` if `qwen/qwen3-32b` doesn't natively return it.
      // However, the example shows "gpt4oAudioPreview" used with modalities.
      model: ChatCompletionModel.modelId(ttsmodelid),
      modalities: [ChatCompletionModality.text, ChatCompletionModality.audio],
      audio: ChatCompletionAudioOptions(
        voice: ChatCompletionAudioVoice.alloy,
        format: ChatCompletionAudioFormat.wav,
      ),
      messages: chatMessages,
    );

    try {
      final res = await client.createChatCompletion(request: request);
      final audioData = res.choices.first.message.audio?.data;
      if (audioData != null) {
        return audioData; // Returns base64 audio data
      }
      return null;
    } catch (e) {
      print('Error generating audio response: $e');
      return null;
    }
  }
}

class OpenAIStructuredOutputService extends OpenAIServiceBase {
  @override
  Future<String> getResponse(String prompt,
      {String? imageUrl,
      String? base64Image,
      String? base64Audio,
      String? audioFormat}) async {
    final chatMessages = <ChatCompletionMessage>[
      ChatCompletionMessage.system(content: systemcontent),
      ChatCompletionMessage.user(
          content: ChatCompletionUserMessageContent.string(prompt)),
    ];

    try {
      final res = await client.createChatCompletion(
        request: CreateChatCompletionRequest(
          model: ChatCompletionModel.modelId(
              modelid), // Or a similar model that supports Structured Outputs
          messages: chatMessages,
          temperature: 0,
          responseFormat: ResponseFormat.jsonSchema(
            jsonSchema: JsonSchemaObject(
              name: 'PersonInfo',
              description: 'Extracts name and age from text.',
              strict: true,
              schema: {
                'type': 'object',
                'properties': {
                  'name': {
                    'type': 'string',
                    'description': 'The full name of the person.',
                  },
                  'age': {
                    'type': 'integer',
                    'description': 'The age of the person.',
                  },
                },
                'additionalProperties': false,
                'required': ['name', 'age'],
              },
            ),
          ),
        ),
      );
      final content = res.choices.first.message.content;
      if (content == null) {
        return 'No content received for structured output.';
      }
      // Attempt to parse JSON to confirm it's valid
      try {
        final parsedJson = json.decode(content);
        return 'Structured Output (JSON):\n${JsonEncoder.withIndent('  ').convert(parsedJson)}';
      } catch (e) {
        return 'Received non-JSON content: $content\nError parsing: $e';
      }
    } catch (e) {
      return 'Error in structured output: $e';
    }
  }

  @override
  Stream<String> getStreamResponse(String prompt,
      {String? imageUrl,
      String? base64Image,
      String? base64Audio,
      String? audioFormat}) async* {
    final chatMessages = <ChatCompletionMessage>[
      ChatCompletionMessage.system(
          content:
              'You are an assistant that extracts information into a structured JSON format and streams.'),
      ChatCompletionMessage.user(
          content: ChatCompletionUserMessageContent.string(prompt)),
    ];

    try {
      final stream = client.createChatCompletionStream(
        request: CreateChatCompletionRequest(
          model: ChatCompletionModel.modelId(modelid),
          messages: chatMessages,
          temperature: 0,
          responseFormat: ResponseFormat.jsonSchema(
            jsonSchema: JsonSchemaObject(
              name: 'PersonInfo',
              description: 'Extracts name and age from text.',
              strict: true,
              schema: {
                'type': 'object',
                'properties': {
                  'name': {
                    'type': 'string',
                    'description': 'The full name of the person.',
                  },
                  'age': {
                    'type': 'integer',
                    'description': 'The age of the person.',
                  },
                },
                'additionalProperties': false,
                'required': ['name', 'age'],
              },
            ),
          ),
        ),
      );

      StringBuffer fullResponseBuffer = StringBuffer();
      await for (final res in stream) {
        final contentDelta = res.choices.first.delta!.content;
        if (contentDelta != null) {
          fullResponseBuffer.write(contentDelta);
          yield contentDelta; // Yield each part of the JSON as it comes
        }
      }
      yield '\n\n-- Stream complete. Attempting to parse JSON: --\n';
      // After stream completes, try to parse the full accumulated JSON
      try {
        final parsedJson = json.decode(fullResponseBuffer.toString());
        yield '\nParsed JSON:\n${JsonEncoder.withIndent('  ').convert(parsedJson)}';
      } catch (e) {
        yield '\nError parsing final JSON: $e\nReceived: ${fullResponseBuffer.toString()}';
      }
    } catch (e) {
      yield 'Error in streaming structured output: $e';
    }
  }

  @override
  Future<String?> generateAudioResponse(String prompt) async {
    return null; // Structured output service does not generate audio responses directly
  }
}

class AIChatService extends ChangeNotifier {
  static const String _openAIApiKey =
groqapi;
  final List<ChatCompletionMessage> _messages = [];
  String _currentResponse = "Hello! Ask me anything.";
  bool _isLoading = false;
  late OpenAIClient _client;

  String get currentResponse => _currentResponse;
  bool get isLoading => _isLoading;

  AIChatService() {
    _initializeClient();
  }

  void _initializeClient() {
    _client = OpenAIClient(
      apiKey: _openAIApiKey,
      baseUrl: 'https://api.groq.com/openai/v1',
    );
    _messages.add(
      ChatCompletionMessage.system(content: systemcontent),
    );
    print("OpenAI Client initialized successfully.");
  }

  // Define DuckDuckGo tool
  final ChatCompletionTool _duckDuckGoTool = ChatCompletionTool(
    type: ChatCompletionToolType.function,
    function: FunctionObject(
      name: 'performWebSearch',
      description:
          'Perform a web search to find current information or answer questions requiring up-to-date data. Provide the exact search query.',
      parameters: {
        'type': 'object',
        'properties': {
          'query': {
            'type': 'string',
            'description':
                'The search query for which to retrieve instant answers.',
          },
        },
        'required': ['query'],
      },
    ),
  );

  final ChatCompletionTool _imageprocess = ChatCompletionTool(
    type: ChatCompletionToolType.function,
    function: FunctionObject(
      name: 'analyzeImageWithGemini',
      description:
          'Analyzes an image using Google Gemini to answer questions about its content. Requires an image to be provided by the user.',
      parameters: {
        'type': 'object',
        'properties': {
          'query': {
            'type': 'string',
            'description':
                'The specific question or query about the image content, e.g., "What is in this image?", "Describe the objects.", "What text is visible?".',
          },
          'contentBase64': {
            'type': 'string',
            'description': 'Base64-encoded content of the file.',
          },
        },
        'required': ['query'],
      },
    ),
  );

  Future<void> sendMessageToModel(String userMessage) async {
    debugPrint("sendMessageToModel called with: $userMessage");

    if (userMessage.trim().isEmpty) {
      debugPrint("Empty message. Exiting.");
      return;
    }

    _isLoading = true;
    _currentResponse = "Thinking...";
    notifyListeners();
    debugPrint("Set loading to true and initial response");

    _messages.add(ChatCompletionMessage.user(
      content: ChatCompletionUserMessageContent.string(userMessage),
    ));
    debugPrint("Added user message to _messages");

    try {
      bool requiresToolCall = true;
      String fullResponse = "";

      while (requiresToolCall) {
        debugPrint(
            "Entering while loop with requiresToolCall=$requiresToolCall");

        final request = CreateChatCompletionRequest(
          model: ChatCompletionModel.modelId(modelid),
          messages: _messages,
          tools: [_duckDuckGoTool, _imageprocess],
        );
        debugPrint(
            "Created request with model=qwen/qwen3-32b and tool=duckduckgo");

        final response = await _client.createChatCompletion(request: request);
        final message = response.choices.first.message;
        debugPrint("Received response from OpenAI");

        if (message.toolCalls != null && message.toolCalls!.isNotEmpty) {
          debugPrint("Tool call required, processing tool calls");
          _messages.add(message);

          for (final toolCall in message.toolCalls!) {
            debugPrint("Tool call function: ${toolCall.function.name}");

            if (toolCall.function.name == 'performWebSearch') {
              _currentResponse = "Searching The Web...";
              notifyListeners();
              debugPrint("Tool: web_search triggered");

              try {
                final args = jsonDecode(toolCall.function.arguments)
                    as Map<String, dynamic>;
                final query = args['query'] as String;
                debugPrint("Parsed toolCall arguments: query=$query");

                final ddgResult = await performWebSearch(query);
                debugPrint("Received DuckDuckGo result");

                final toolResult = ddgResult;

                _messages.add(ChatCompletionMessage.tool(
                  toolCallId: toolCall.id,
                  content: toolResult.toString(),
                ));
                debugPrint("Added tool result to _messages");
              } catch (e) {
                debugPrint("Error calling DuckDuckGo API: $e");
                _messages.add(ChatCompletionMessage.tool(
                  toolCallId: toolCall.id,
                  content: "Error: $e",
                ));
              }
            }
          }
        } else if (message.content != null) {
          debugPrint("Assistant returned text message");
          requiresToolCall = false;
          fullResponse = message.content!;
          _messages.add(message);
        }
      }

      _currentResponse = fullResponse;
      debugPrint("Streaming final response: $fullResponse");

      //   for (var i = 0; i < fullResponse.length; i++) {
      //     await Future.delayed(const Duration(milliseconds: 20));
      //     _currentResponse = fullResponse.substring(0, i + 1);
      //     notifyListeners();
      //   }
      // } on OpenAIClientException catch (e) {
      //   _currentResponse = "Error: ${e.message}";
      //   debugPrint("API Error: ${e.message}");
      // } catch (e) {
      //   _currentResponse = "An unexpected error occurred: $e";
      //   debugPrint("Unexpected Error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
      debugPrint("Finished processing. Loading set to false.");
    }
  }

  void resetChat() {
    _messages.clear();
    _messages.add(
      ChatCompletionMessage.system(content: systemcontent),
    );
    _currentResponse = "Hello! Ask me anything.";
    _isLoading = false;
    notifyListeners();
  }
}
