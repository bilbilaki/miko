// lib/core/providers/openai_core.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:miko/ai/tools/ai_browser_tools.dart';
import 'package:miko/mycore/ai_converters.dart';
import 'package:miko/mycore/ai_core_models.dart' as cm;
import 'package:miko/mycore/ai_core_service.dart' as cm;
import 'package:miko/mycore/chat_controller.dart';
import 'package:miko/mycore/settings_service.dart';
import 'package:openai_dart/openai_dart.dart' as openai;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';


class OpenAiCoreService implements cm.AiCoreService {
  final openai.OpenAIClient client;
  final String defaultChatModelId;
  final double defaultTemperature;
  final String defaultVoice; // for audio responses
  final StorageSettingsService settingsService;
  final AiSettings settings;

  OpenAiCoreService({
    required this.client,
    this.defaultChatModelId = 'gpt-5-mini',
    this.defaultTemperature = 1,
    this.defaultVoice = 'alloy',
    required this.settingsService,
    required this.settings
  });

  @override
  cm.AiProviderCapabilities get capabilities => const cm.AiProviderCapabilities(
        supportsStreaming: true,
        supportsAudioInput: true,
        supportsAudioOutput: true,
        supportsTranscription: true,
        supportsTts: true,
        supportsToolCalling: true,
        supportsOcr: false,
        supportsVoiceStreaming: true,
        supportsReasoningStream: false,
        supportsWaitEstimates: true,
      );

  String _modelId(cm.AiCallOptions options) => settings.modelId;

  double _temp(cm.AiCallOptions options) => settings.temperature;

  String _voiceOrDefault(String? v) => settings.selectedVoice;

  @override
  Future<cm.AiResponse> messageMulti({
    required List<cm.UnifiedMessage> history,
    cm.AiCallOptions options =  const cm.AiCallOptions(),
  }) async {
    final messages = AiMessageConverters.buildOpenAiMessages(history,settings: settings);

    final res = await client.createChatCompletion(
      request: openai.CreateChatCompletionRequest(
        model: openai.ChatCompletionModel.modelId(settings.modelId),
        messages: messages,
        temperature: settings.temperature,
      ),
    );

    final content = res.choices.first.message.content ?? '';
    final msg = cm.UnifiedMessage(
      id:  Uuid().v4(),
      role: cm.MessageRole.assistant,
      text: content,
      createdAt: DateTime.now(),
      attachments:  [],
    );
    return cm.AiResponse(message: msg, raw: res.toJson());
  }

  @override
  Stream<cm.AiStreamEvent> streamMessage({
    required List<cm.UnifiedMessage> history,
    cm.AiCallOptions options = const cm.AiCallOptions(),
  }) async* {
    final messages = AiMessageConverters.buildOpenAiMessages(history,settings: settings);
    yield  cm.AiStreamStarted();
    yield  cm.AiStreamThinking(true);

    final stream = client.createChatCompletionStream(
      request: openai.CreateChatCompletionRequest(
        model: openai.ChatCompletionModel.modelId(settings.modelId),
        messages: messages,
        temperature: settings.temperature,
      ),
    );

    final buffer = StringBuffer();
    var thinking = true;

    try {
      await for (final chunk in stream) {
        final choices = chunk.choices;
        if (choices == null || choices.isEmpty) continue;
        final delta = choices.first.delta;

        final deltaContent = delta?.content;
        if (deltaContent != null && deltaContent.isNotEmpty) {
          buffer.write(deltaContent);
          if (thinking) {
            yield const cm.AiStreamThinking(false);
            thinking = false;
          }
          yield cm.AiStreamDeltaText(delta: deltaContent, fullText: buffer.toString());
        }
      }

      if (thinking) {
        yield const cm.AiStreamThinking(false);
      }

      final msg = cm.UnifiedMessage(
        id: const Uuid().v4(),
        role: cm.MessageRole.assistant,
        text: buffer.toString(),
        createdAt: DateTime.now(),
      );
      yield cm.AiStreamCompleted(
        cm.AiResponse(message: msg, raw: {'text': buffer.toString()}),
      );
    } catch (e, st) {
      yield cm.AiStreamError(e, st);
    }
  }

  @override
  Stream<cm.AiStreamEvent> streamVoice({
    required List<cm.UnifiedMessage> history,
    cm.AiCallOptions options = const cm.AiCallOptions(),
    cm.AiTtsOptions tts = const cm.AiTtsOptions(),
  }) async* {
    final messages = AiMessageConverters.buildOpenAiMessages(history,settings: settings);
    yield const cm.AiStreamStarted();
    yield const cm.AiStreamThinking(true);

    final stream = client.createChatCompletionStream(
      request: openai.CreateChatCompletionRequest(
        model: openai.ChatCompletionModel.model(
          openai.ChatCompletionModels.gpt4oMiniAudioPreview,
        ),
        modalities: const [
          openai.ChatCompletionModality.text,
          openai.ChatCompletionModality.audio,
        ],
        audio: openai.ChatCompletionAudioOptions(
          voice: getOpenAIVoice(settings.selectedVoice),
          format: openai.ChatCompletionAudioFormat.wav,
        ),
        messages: messages,
        temperature: settings.temperature,
      ),
    );

    final textBuffer = StringBuffer();
    final transcriptBuffer = StringBuffer();
    final audioBuilder = BytesBuilder();
    var chunkIndex = 0;
    var thinking = true;
    String mime = tts.responseMimeType;

    try {
      await for (final chunk in stream) {
        final choices = chunk.choices;
        if (choices == null || choices.isEmpty) continue;
        final delta = choices.first.delta;

        final deltaText = delta?.content;
        if (deltaText != null && deltaText.isNotEmpty) {
          textBuffer.write(deltaText);
          if (thinking) {
            yield const cm.AiStreamThinking(false);
            thinking = false;
          }
          yield cm.AiStreamDeltaText(delta: deltaText, fullText: textBuffer.toString());
        }

        final audio = delta?.audio;
        if (audio != null) {
          final dataB64 = audio.data;
          if (dataB64 != null && dataB64.isNotEmpty) {
            final bytes = base64Decode(dataB64);
            audioBuilder.add(bytes);
            yield cm.AiStreamVoiceChunk(
              bytes: bytes,
              mimeType: mime,
              index: chunkIndex++,
              duration: null,
            );
          }
          final tdelta = audio.transcript;
          if (tdelta != null && tdelta.isNotEmpty) {
            transcriptBuffer.write(tdelta);
            yield cm.AiStreamTranscriptionDelta(
              delta: tdelta,
              fullText: transcriptBuffer.toString(),
              isFinal: false,
            );
          }
        }
      }

      if (thinking) {
        yield const cm.AiStreamThinking(false);
      }

      final finalAudio = audioBuilder.toBytes();
      final transcript = transcriptBuffer.isEmpty ? null : transcriptBuffer.toString();

      final finalMsg = cm.UnifiedMessage(
        id: const Uuid().v4(),
        role: cm.MessageRole.assistant,
        text: textBuffer.toString(),
        createdAt: DateTime.now(),
      );

      yield cm.AiStreamCompleted(
        cm.AiResponse(message: finalMsg, raw: {'text': textBuffer.toString()}),
      );

      yield cm.AiStreamVoiceCompleted(
        cm.VoiceResponse(
          audioBytes: finalAudio,
          mimeType: mime,
          transcript: transcript,
          raw: {'size': finalAudio.length},
          file: await audiofile(finalAudio)
        ),
      );
    } catch (e, st) {
      yield cm.AiStreamError(e, st);
    }
  }

  @override
  Future<cm.VoiceResponse> voiceResponse({
    required List<cm.UnifiedMessage> history,
    cm.AiCallOptions options = const cm.AiCallOptions(),
    cm.AiTtsOptions tts = const cm.AiTtsOptions(),
  }) async {
    final messages = AiMessageConverters.buildOpenAiMessages(history, settings: settings);

    final res = await client.createChatCompletion(
      request: openai.CreateChatCompletionRequest(
        model: openai.ChatCompletionModel.model(
          openai.ChatCompletionModels.gpt4oMiniAudioPreview,
        ),
        modalities: const [
          openai.ChatCompletionModality.text,
          openai.ChatCompletionModality.audio,
        ],
        audio: openai.ChatCompletionAudioOptions(
          voice: getOpenAIVoice(settings.selectedVoice),
          format: openai.ChatCompletionAudioFormat.wav,
        ),
        messages: messages,
        temperature: _temp(options),
      ),
    );

    final choice = res.choices.first;
    final audio = choice.message.audio?.data;
    if (audio == null) {
      final text = choice.message.content ?? '';
      settingsService.setIsAudioPlaying(true);

      return cm.VoiceResponse(
        audioBytes: Uint8List(0),
        mimeType: tts.responseMimeType,
        transcript: text,
        raw: res.toJson(), file: await audiofile(audio),
      );
    }

    final audioBinary = base64Decode(audio);
    final transcript = choice.message.audio?.transcript;

    settingsService.setIsAudioPlaying(true);
    return cm.VoiceResponse(
      audioBytes: audioBinary,
      mimeType: tts.responseMimeType,
      transcript: transcript,
      raw: res.toJson(),
      file: await audiofile(audioBinary)
    );
  }
Future<File> audiofile(bytes)async{



  final supportDir = await getApplicationSupportDirectory();
  final audioDir = Directory(p.join(supportDir.path,'audio'));
  if (!await audioDir.exists()
  
  ){
    await audioDir.create(recursive:  true);
  }

  final id = const Uuid().v4;
  final file = File(p.join(audioDir.path,'$id.mp3'));
  await file.writeAsBytes(bytes,flush: true);
  return file;
}
  @override
  Future<String> transcribe({
    required Uint8List audioBytes,
    required cm.AudioFormat format,
    cm.AiCallOptions options = const cm.AiCallOptions(),
  }) async {
    final parts = <openai.ChatCompletionMessageContentPart>[
      openai.ChatCompletionMessageContentPart.text(
        text: 'Transcribe the following audio accurately. Return only text.',
      ),
      openai.ChatCompletionMessageContentPart.audio(
        inputAudio: openai.ChatCompletionMessageInputAudio(
          data: base64Encode(audioBytes),
          format: openai.ChatCompletionMessageInputAudioFormat.wav,
        ),
      ),
    ];

    final res = await client.createChatCompletion(
      request: openai.CreateChatCompletionRequest(
        model: openai.ChatCompletionModel.modelId(_modelId(options)),
        messages: [
          openai.ChatCompletionMessage.user(
            content: openai.ChatCompletionUserMessageContent.parts(parts),
          ),
        ],
        temperature: 0,
      ),
    );

    return res.choices.first.message.content ?? '';
  }

  @override
  Future<Uint8List> tts({
    required String text,
    cm.AiTtsOptions tts = const cm.AiTtsOptions(),
    cm.AiCallOptions options = const cm.AiCallOptions(),
  }) async {
    final res = await client.createChatCompletion(
      request: openai.CreateChatCompletionRequest(
        model: openai.ChatCompletionModel.model(
          openai.ChatCompletionModels.gpt4oMiniAudioPreview,
        ),
        modalities: const [openai.ChatCompletionModality.audio],
        audio: openai.ChatCompletionAudioOptions(
          voice: getOpenAIVoice(settings.selectedVoice),
          format: openai.ChatCompletionAudioFormat.wav,
        ),
        messages: [
          openai.ChatCompletionMessage.user(
            content: openai.ChatCompletionUserMessageContent.string(text),
          ),
        ],
        temperature: 0.7,
      ),
    );

    final audio = res.choices.first.message.audio;
    if (audio == null) return Uint8List(0);

    return base64Decode(audio.data);
  }

  @override
  Future<String> summarize({
    String? text,
    List<cm.UnifiedMessage> history = const [],
    cm.AiCallOptions options = const cm.AiCallOptions(),
  }) async {
    final messages = <openai.ChatCompletionMessage>[
      openai.ChatCompletionMessage.system(
        content: 'You are a concise summarizer. Provide a brief, clear summary in 3-5 bullet points.',
      ),
    ];

    if (text != null && text.trim().isNotEmpty) {
      messages.add(
        openai.ChatCompletionMessage.user(
          content: openai.ChatCompletionUserMessageContent.string(text),
        ),
      );
    } else if (history.isNotEmpty) {
      messages.addAll(AiMessageConverters.buildOpenAiMessages(history,settings: settings));
    } else {
      return '';
    }

    final res = await client.createChatCompletion(
      request: openai.CreateChatCompletionRequest(
        model: openai.ChatCompletionModel.modelId(_modelId(options)),
        messages: messages,
        temperature: 0.5,
      ),
    );
    return res.choices.first.message.content ?? '';
  }

  @override
  Future<String> generateTitle({
    required String seedText,
    cm.AiCallOptions options = const cm.AiCallOptions(),
  }) async {
    final res = await client.createChatCompletion(
      request: openai.CreateChatCompletionRequest(
        model: openai.ChatCompletionModel.modelId(_modelId(options)),
        messages: [
          openai.ChatCompletionMessage.system(
            content: 'Return a short 1-3 word title based on the input. No punctuation.',
          ),
          openai.ChatCompletionMessage.user(
            content: openai.ChatCompletionUserMessageContent.string(seedText),
          ),
        ],
        temperature: 0.9,
      ),
    );
    return (res.choices.first.message.content ?? '').trim();
  }

  @override
  Future<cm.AiResponse> runWithTools({
    required List<cm.UnifiedMessage> history,
    required List<cm.ToolSpec> tools,
    cm.AiCallOptions options = const cm.AiCallOptions(),
  }) async {
    // Convert incoming history to OpenAI messages and attach tools
    final messages = <openai.ChatCompletionMessage>[];
    messages.addAll(AiMessageConverters.buildOpenAiMessages(history,settings: settings));

    final openAiTools = 
allTools;
    // Tool loop
    const maxIterations = 12;
    for (var i = 0; i < maxIterations; i++) {
      final res = await client.createChatCompletion(
        request: openai.CreateChatCompletionRequest(
          model: openai.ChatCompletionModel.modelId(_modelId(options)),
          messages: messages,
          tools: openAiTools,
          toolChoice: openai.ChatCompletionToolChoiceOption.mode(
            openai.ChatCompletionToolChoiceMode.auto,
          ),
          temperature: _temp(options),
        ),
      );

      final choice = res.choices.first;
      final message = choice.message;
      messages.add(message);

      final toolCalls = message.toolCalls ?? const <openai.ChatCompletionMessageToolCall>[];
      if (toolCalls.isEmpty) {
        // Final content
        final text = message.content ?? '';
        final finalMsg = cm.UnifiedMessage(
          id: const Uuid().v4(),
          role: cm.MessageRole.assistant,
          text: text,
          createdAt: DateTime.now(),
          attachments: const [],
        );
        return cm.AiResponse(message: finalMsg, raw: res.toJson());
      }

      // Execute tool calls
      for (final toolCall in toolCalls) {
        final fn = toolCall.function;
        final name = fn.name;
        // Parse arguments
        Map<String, dynamic> args = {};
        try {
          final decoded = json.decode(fn.arguments);
          if (decoded is Map<String, dynamic>) {
            args = decoded;
          }
        } catch (_) {
          // Leave args empty and return an error result
        }

        // Dispatch to provided ToolSpec handlers
        String toolResult;
        try {
          final spec = tools.firstWhere(
            (t) => t.name == name,
            orElse: () => cm.ToolSpec(
              name: name,
              description: 'Unknown tool',
              jsonSchema: const {
                'type': 'object',
                'properties': {},
              },
              handler: (a) async => 'Error: Unknown tool "$name"',
            ),
          );
          toolResult = await spec.handler(args);
        } catch (e) {
          toolResult = 'Error calling tool $name: $e';
        }

        // Append tool result back to conversation
        messages.add(
          openai.ChatCompletionMessage.tool(
            toolCallId: toolCall.id,
            content: toolResult,
          ),
        );
      }
      // Loop continues for the assistant to read tool outputs
    }

    // If loop exceeds iterations
    final finalMsg = cm.UnifiedMessage(
      id: const Uuid().v4(),
      role: cm.MessageRole.assistant,
      text: 'Tool loop exceeded iteration limit.',
      createdAt: DateTime.now(),
      attachments: const [],
    );
    return cm.AiResponse(message: finalMsg, raw: const {'error': 'max_iterations_exceeded'});
  }

  @override
  Future<String> ocr({
    required Uint8List imageBytes,
    required String mimeType,
    cm.AiCallOptions options = const cm.AiCallOptions(),
  }) async {
    throw UnsupportedError('OCR via OpenAI provider is not supported.');
  }

  // ------- Helpers -------

  openai.ChatCompletionTool _toOpenAiTool(cm.ToolSpec spec) {
    return openai.ChatCompletionTool(
      type: openai.ChatCompletionToolType.function,
      function: openai.FunctionObject(
        name: spec.name,
        description: spec.description,
        parameters: spec.jsonSchema,
      ),
    );
  }

  openai.ChatCompletionMessageInputAudioFormat _audioinputFormatFromMime(String mime) {
    switch (mime.toLowerCase()) {
      case 'audio/wav':
      case 'audio/x-wav':
        return openai.ChatCompletionMessageInputAudioFormat.wav;
      case 'audio/mpeg':
      case 'audio/mp3':
        return openai.ChatCompletionMessageInputAudioFormat.mp3;
      case 'audio/mp4':
      case 'audio/aac':
      case 'audio/x-m4a':
      default:
        return openai.ChatCompletionMessageInputAudioFormat.wav;
    }
  }

  openai.ChatCompletionAudioFormat _audioFormatFromMime(String mime) {
    switch (mime.toLowerCase()) {
      case 'audio/wav':
      case 'audio/x-wav':
        return openai.ChatCompletionAudioFormat.wav;
      case 'audio/mpeg':
      case 'audio/mp3':
        return openai.ChatCompletionAudioFormat.mp3;
      case 'audio/mp4':
      case 'audio/aac':
      case 'audio/x-m4a':
      default:
        return openai.ChatCompletionAudioFormat.wav;
    }
  }

  openai.ChatCompletionMessageInputAudioFormat _toOpenAiAudioFormat(cm.AudioFormat f) {
    switch (f) {
      case cm.AudioFormat.wav:
        return openai.ChatCompletionMessageInputAudioFormat.wav;
      case cm.AudioFormat.mp3:
        return openai.ChatCompletionMessageInputAudioFormat.wav;
    }
  }

  openai.ChatCompletionAudioVoice getOpenAIVoice(String voiceParams) {
    switch (voiceParams.toLowerCase()) {
      case 'alloy':
        return openai.ChatCompletionAudioVoice.alloy;
      case 'ash':
        return openai.ChatCompletionAudioVoice.ash;
      case 'echo':
        return openai.ChatCompletionAudioVoice.echo;
      case 'ballad':
        return openai.ChatCompletionAudioVoice.ballad;
      case 'sage':
        return openai.ChatCompletionAudioVoice.sage;
      case 'coral':
        return openai.ChatCompletionAudioVoice.coral;
      case 'shimmer':
        return openai.ChatCompletionAudioVoice.shimmer;
      default:
        return openai.ChatCompletionAudioVoice.alloy;
    }
  }
  
  @override
  Stream<cm.AiStreamEvent> eventsForMessageMulti({required List<cm.UnifiedMessage> history, cm.AiCallOptions options = const cm.AiCallOptions(), Duration waitTick = const Duration(milliseconds: 250)}) {
    // TODO: implement eventsForMessageMulti
    throw UnimplementedError();
  }
  
  @override
  Stream<cm.AiStreamEvent> eventsForRunWithTools({required List<cm.UnifiedMessage> history, required List<cm.ToolSpec> tools, cm.AiCallOptions options = const cm.AiCallOptions(), Duration waitTick = const Duration(milliseconds: 250)}) {
    // TODO: implement eventsForRunWithTools
    throw UnimplementedError();
  }
  
  @override
  Stream<cm.AiStreamEvent> eventsForVoiceResponse({required List<cm.UnifiedMessage> history, cm.AiCallOptions options = const cm.AiCallOptions(), cm.AiTtsOptions tts = const cm.AiTtsOptions(), Duration waitTick = const Duration(milliseconds: 250)}) {
    // TODO: implement eventsForVoiceResponse
    throw UnimplementedError();
  }
}