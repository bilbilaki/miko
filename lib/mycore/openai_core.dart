// lib/core/providers/openai_core.dart
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:miko/mycore/ai_converters.dart';
import 'package:miko/mycore/ai_core_models.dart';
import 'package:miko/mycore/ai_core_service.dart';
import 'package:openai_dart/openai_dart.dart' as openai;
import 'package:uuid/uuid.dart';

class OpenAiCoreService implements AiCoreService {
  final openai.OpenAIClient client;
  final String defaultChatModelId;
  final double defaultTemperature;
  final String defaultVoice; // for audio responses

  OpenAiCoreService({
    required this.client,
    this.defaultChatModelId = 'gpt-5-mini',
    this.defaultTemperature = 0.7,
    this.defaultVoice = 'alloy',
  });

  @override
  AiProviderCapabilities get capabilities => const AiProviderCapabilities(
        supportsStreaming: true,
        supportsAudioInput: true,
        supportsAudioOutput: true,
        supportsTranscription: true,
        supportsTts: true,
        supportsToolCalling: false, // set true after tool support is implemented
        supportsOcr: false,
      );

  String _modelId(AiCallOptions options) =>
      options.modelIdOverride ?? defaultChatModelId;

  double _temp(AiCallOptions options) =>
      options.temperature ?? defaultTemperature;
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
  Future<AiResponse> messageMulti({
    required List<UnifiedMessage> history,
    AiCallOptions options = const AiCallOptions(),
  }) async {
    final messages = AiMessageConverters.buildOpenAiMessages(history);

    final res = await client.createChatCompletion(
      request: openai.CreateChatCompletionRequest(
        model: openai.ChatCompletionModel.modelId(_modelId(options)),
        messages: messages,
        temperature: _temp(options),
      ),
    );

    final content = res.choices.first.message.content ?? '';
    final msg = UnifiedMessage(
      id: const Uuid().v4(),
      role: MessageRole.assistant,
      text: content,
      createdAt: DateTime.now(),
      attachments: const [],
    );
    return AiResponse(message: msg, raw: res.toJson());
  }

  @override
  Stream<AiStreamEvent> streamMessage({
    required List<UnifiedMessage> history,
    AiCallOptions options = const AiCallOptions(),
  }) async* {
    final messages = AiMessageConverters.buildOpenAiMessages(history);
    yield const AiStreamStarted();
    yield const AiStreamThinking(true);

    final stream = client.createChatCompletionStream(
      request: openai.CreateChatCompletionRequest(
        model: openai.ChatCompletionModel.modelId(_modelId(options)),
        messages: messages,
        temperature: _temp(options),
      ),
    );

    final buffer = StringBuffer();

    try {
      await for (final chunk in stream) {
        final delta = chunk.choices?.firstOrNull?.delta?.content;
        if (delta != null && delta.isNotEmpty) {
          buffer.write(delta);
          yield AiStreamDeltaText(delta: delta, fullText: buffer.toString());
        }
      }
      yield const AiStreamThinking(false);

      final msg = UnifiedMessage(
        id: const Uuid().v4(),
        role: MessageRole.assistant,
        text: buffer.toString(),
        createdAt: DateTime.now(),
      );
      yield AiStreamCompleted(
        AiResponse(message: msg, raw: {'text': buffer.toString()}),
      );
    } catch (e, st) {
      yield AiStreamError(e, st);
    }
  }

  @override
  Future<VoiceResponse> voiceResponse({
    required List<UnifiedMessage> history,
    AiCallOptions options = const AiCallOptions(),
    AiTtsOptions tts = const AiTtsOptions(),
  }) async {
    final messages = AiMessageConverters.buildOpenAiMessages(history);

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
          voice: getOpenAIVoice(tts.voice.toString()),
          format: _audioFormatFromMime(tts.responseMimeType),
        ),
        messages: messages,
        temperature: _temp(options),
      ),
    );

    final choice = res.choices.first;
    final audio = choice.message.audio;
    if (audio == null) {
      // Fallback: if audio absent, generate text-only and return empty audio
      final text = choice.message.content ?? '';
      return VoiceResponse(
        audioBytes: Uint8List(0),
        mimeType: tts.responseMimeType,
        transcript: text,
        raw: res.toJson(),
      );
    }

    final bytes = Uint8List.fromList(audio.data.codeUnits);
    final transcript = audio.transcript;
    return VoiceResponse(
      audioBytes: bytes,
      mimeType: tts.responseMimeType,
      transcript: transcript,
      raw: res.toJson(),
    );
  }

  @override
  Future<String> transcribe({
    required Uint8List audioBytes,
    required AudioFormat format,
    AiCallOptions options = const AiCallOptions(),
  }) async {
    // Use chat-completion with audio input + instruction to transcribe
    final parts = <openai.ChatCompletionMessageContentPart>[
      openai.ChatCompletionMessageContentPart.text(
          text: 'Transcribe the following audio accurately. Return only text.'),
      openai.ChatCompletionMessageContentPart.audio(
        inputAudio: openai.ChatCompletionMessageInputAudio(
          data: base64Encode(audioBytes),
          format: _toOpenAiAudioFormat(format),
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
    AiTtsOptions tts = const AiTtsOptions(),
    AiCallOptions options = const AiCallOptions(),
  }) async {
    // Generate audio-only via chat completion
    final res = await client.createChatCompletion(
      request: openai.CreateChatCompletionRequest(
        model: openai.ChatCompletionModel.model(
          openai.ChatCompletionModels.gpt4oMiniAudioPreview,
        ),
        modalities: const [openai.ChatCompletionModality.audio],
        audio: openai.ChatCompletionAudioOptions(
          voice: getOpenAIVoice(tts.voice.toString()),
          format: _audioFormatFromMime(tts.responseMimeType),
        ),
        messages: [
          openai.ChatCompletionMessage.user(content: openai.ChatCompletionUserMessageContent.string( text)),
        ],
        temperature: 0.7,
      ),
    );

    final audio = res.choices.first.message.audio;
    if (audio == null) return Uint8List(0);
    return Uint8List.fromList(audio.data.codeUnits);
  }

  @override
  Future<String> summarize({
    String? text,
    List<UnifiedMessage> history = const [],
    AiCallOptions options = const AiCallOptions(),
  }) async {
    final messages = <openai.ChatCompletionMessage>[
      openai.ChatCompletionMessage.system(
        content:
            'You are a concise summarizer. Provide a brief, clear summary in 3-5 bullet points.',
      ),
    ];

    if (text != null && text.trim().isNotEmpty) {
      messages.add(openai.ChatCompletionMessage.user(content: openai.ChatCompletionUserMessageContent.string( text)));
    } else if (history.isNotEmpty) {
      messages.addAll(AiMessageConverters.buildOpenAiMessages(history));
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
    AiCallOptions options = const AiCallOptions(),
  }) async {
    final res = await client.createChatCompletion(
      request: openai.CreateChatCompletionRequest(
        model: openai.ChatCompletionModel.modelId(_modelId(options)),
        messages: [
          openai.ChatCompletionMessage.system(
            content:
                'Return a short 1-3 word title based on the input. No punctuation.',
          ),
          openai.ChatCompletionMessage.user(content: openai.ChatCompletionUserMessageContent.string(seedText)),
        ],
        temperature: 0.9,
      ),
    );
    return (res.choices.first.message.content ?? '').trim();
  }

  @override
  Future<AiResponse> runWithTools({
    required List<UnifiedMessage> history,
    required List<ToolSpec> tools,
    AiCallOptions options = const AiCallOptions(),
  }) async {
    // Not implemented with OpenAI Tools API in this version.
    // You can handle tools on top of streamMessage by inspecting model output.
    throw UnimplementedError('OpenAI tool-calling not implemented yet.');
  }

  @override
  Future<String> ocr({
    required Uint8List imageBytes,
    required String mimeType,
    AiCallOptions options = const AiCallOptions(),
  }) async {
    // OCR requested via Mistral. Not supported in OpenAI provider.
    throw UnsupportedError('OCR via Mistral is not supported by OpenAI provider.');
  }

  String _voiceOrDefault(String? v) => (v == null || v.isEmpty) ? defaultVoice : v;

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

  openai.ChatCompletionMessageInputAudioFormat _toOpenAiAudioFormat(AudioFormat f) {
    switch (f) {
      case AudioFormat.wav:
        return openai.ChatCompletionMessageInputAudioFormat.wav;
      case AudioFormat.mp3:
        return openai.ChatCompletionMessageInputAudioFormat.mp3;
    }
  }
}