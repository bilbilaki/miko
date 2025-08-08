// lib/core/providers/gemini_core.dart
import 'dart:async';
import 'dart:typed_data';

import 'package:google_generative_ai/google_generative_ai.dart' as gemini;
import 'package:miko/configs/consts.dart';
import 'package:miko/mycore/ai_converters.dart';
import 'package:miko/mycore/ai_core_models.dart';
import 'package:miko/mycore/ai_core_service.dart';
import 'package:miko/mycore/openai_core.dart';
import 'package:uuid/uuid.dart';
import 'package:openai_dart/openai_dart.dart' as openai;


class GeminiCoreService implements AiCoreService {
  final gemini.GenerativeModel chatModel;
  final double defaultTemperature;
  final String ttsModelId;
  final gemini.SafetySetting? safetyOverride;

  GeminiCoreService({
    required String apiKey,
    String chatModelId = 'gemini-2.0-flash',
    this.defaultTemperature = 0.7,
    this.ttsModelId = 'gemini-2.5-tts',
    this.safetyOverride,
  }) : chatModel = gemini.GenerativeModel(
          model: chatModelId,
          apiKey: apiKey,
        );

  @override
  AiProviderCapabilities get capabilities => const AiProviderCapabilities(
        supportsStreaming: true,
        supportsAudioInput: true,
        supportsAudioOutput: true, // via TTS model
        supportsTranscription: true,
        supportsTts: true,
        supportsToolCalling: false, // enable when function-calling added
        supportsOcr: true, // basic OCR via vision
      );

  gemini.GenerationConfig _genConfig(AiCallOptions options) {
    return gemini.GenerationConfig(
      temperature: options.temperature ?? defaultTemperature,
    );
  }

  gemini.GenerativeModel _chatModelWith(AiCallOptions options) {
    final modelId = options.modelIdOverride ?? chatModel;
    return modelId == chatModel
        ? gemini.GenerativeModel(
            model: 'gemini-2.5-flash',
            apiKey: kApiKey,
            generationConfig: _genConfig(options),
          ): chatModel;
  }

  @override
  Future<AiResponse> messageMulti({
    required List<UnifiedMessage> history,
    AiCallOptions options = const AiCallOptions(),
  }) async {
    final model = _chatModelWith(options);
    final contents = AiMessageConverters.buildGeminiHistory(history);

    final res = await model.generateContent(contents);
    final text = res.text ?? '';

    final msg = UnifiedMessage(
      id: const Uuid().v4(),
      role: MessageRole.assistant,
      text: text,
      createdAt: DateTime.now(),
    );

    return AiResponse(message: msg, raw: {'candidates': res.candidates?.length ?? 0});
  }

  @override
  Stream<AiStreamEvent> streamMessage({
    required List<UnifiedMessage> history,
    AiCallOptions options = const AiCallOptions(),
  }) async* {
    final model = _chatModelWith(options);
    final contents = AiMessageConverters.buildGeminiHistory(history);

    yield const AiStreamStarted();
    yield const AiStreamThinking(true);

    final buffer = StringBuffer();

    try {
      final stream = model.generateContentStream(contents);
      await for (final chunk in stream) {
        final delta = chunk.text;
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
    // 1) Get text answer via chat
    final textRes = await messageMulti(history: history, options: options);
    final text = textRes.message.text ?? '';

    // 2) TTS using gemini-2.5-tts
    final bytes = await ttsGenerateInternal(
      text: text,
      responseMimeType: tts.responseMimeType,
      options: options,
    );

    return VoiceResponse(
      audioBytes: bytes,
      mimeType: tts.responseMimeType,
      transcript: text,
      raw: const {},
    );
  }

  @override
  Future<String> transcribe({
    required Uint8List audioBytes,
    required AudioFormat format,
    AiCallOptions options = const AiCallOptions(),
  }) async {
    final model = _chatModelWith(
      AiCallOptions(
        modelIdOverride: options.modelIdOverride ?? 'gemini-2.0-flash',
        temperature: 0.2,
      ),
    );

    final prompt = gemini.TextPart(
        'Transcribe the following audio accurately. Return only text, no extra notes.');
    final audioPart = gemini.DataPart(format.mimeType, audioBytes);

    final res = await model.generateContent([
      gemini.Content('user', [prompt, audioPart])
    ]);

    return res.text?.trim() ?? '';
  }

  @override
  Future<Uint8List> tts({
    required String text,
    AiTtsOptions tts = const AiTtsOptions(),
    AiCallOptions options = const AiCallOptions(),
  }) async {
    return ttsGenerateInternal(
      text: text,
      responseMimeType: tts.responseMimeType,
      options: options,
    );
  }

  Future<Uint8List> ttsGenerateInternal({
    required String text,
    required String responseMimeType,
    AiCallOptions options = const AiCallOptions(),
  }) async {
    final ttsModel = gemini.GenerativeModel(
      model: ttsModelId,
      apiKey: kApiKey,
      generationConfig: gemini.GenerationConfig(
        responseMimeType: responseMimeType,
      ),
    );
       Uint8List b ;
     openai.OpenAIClient client = openai.OpenAIClient();
 b= await OpenAiCoreService(client: client).tts(text: text);
    final res = await ttsModel.generateContent(gemini.Content("Assistant",[gemini.TextPart(text)]) as Iterable<gemini.Content>);
    final parts = res.candidates.firstOrNull?.content.parts ?? const [];
  
    for (final p in parts) {
      if (p is gemini.DataPart && p.bytes != null) {
        // In newer SDKs audio is returned as DataPart(bytes+mime)
        return p.bytes;
      }
    }
    // Fallback for SDKs returning via blobs
    for (final p in parts) {
       if (p is gemini.DataPart && p.bytes != null) {
        // In newer SDKs audio is returned as DataPart(bytes+mime)
        return p.bytes;
       }
  }
         return b;

  }

  @override
  Future<String> summarize({
    String? text,
    List<UnifiedMessage> history = const [],
    AiCallOptions options = const AiCallOptions(),
  }) async {
    final model = _chatModelWith(
      AiCallOptions(
        modelIdOverride: options.modelIdOverride ?? 'gemini-2.0-flash',
        temperature: 0.3,
      ),
    );

    if (text != null && text.trim().isNotEmpty) {
      final res = await model.generateContent([
        gemini.Content('user', [
          gemini.TextPart(
              'Summarize concisely in 3-5 bullet points:\n\n$text'),
        ])
      ]);
      return res.text?.trim() ?? '';
    } else if (history.isNotEmpty) {
      final contents = AiMessageConverters.buildGeminiHistory(history);
      contents.insert(
          0,
          gemini.Content('user', [
            gemini.TextPart(
                'Summarize the following conversation concisely in 3-5 bullet points.')
          ]));
      final res = await model.generateContent(contents);
      return res.text?.trim() ?? '';
    }
    return '';
  }

  @override
  Future<String> generateTitle({
    required String seedText,
    AiCallOptions options = const AiCallOptions(),
  }) async {
    final model = _chatModelWith(
      AiCallOptions(
        modelIdOverride: options.modelIdOverride ?? 'gemini-2.0-flash',
        temperature: 0.9,
      ),
    );

    final res = await model.generateContent([
      gemini.Content('user', [
        gemini.TextPart(
            'Return a short 1-3 word title based on the input. No punctuation. Input:\n$seedText'),
      ])
    ]);
    return (res.text ?? '').trim();
  }

  @override
  Future<AiResponse> runWithTools({
    required List<UnifiedMessage> history,
    required List<ToolSpec> tools,
    AiCallOptions options = const AiCallOptions(),
  }) async {
    // Not implemented with Gemini Function Calling in this version.
    throw UnimplementedError('Gemini tool-calling not implemented yet.');
  }

  @override
  Future<String> ocr({
    required Uint8List imageBytes,
    required String mimeType,
    AiCallOptions options = const AiCallOptions(),
  }) async {
    // Basic OCR via vision (Gemini multimodal)
    final model = _chatModelWith(
      AiCallOptions(
        modelIdOverride: options.modelIdOverride ?? 'gemini-2.0-flash',
        temperature: 0.2,
      ),
    );

    final res = await model.generateContent([
      gemini.Content('user', [
        gemini.TextPart(
            'Extract readable text from this image. Return only the text.'),
        gemini.DataPart(mimeType, imageBytes),
      ])
    ]);

    return res.text?.trim() ?? '';
  }
}