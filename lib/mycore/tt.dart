import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:miko/mycore/adaptors.dart';
import 'package:miko/mycore/ai_core_models.dart' as cm;
import 'package:miko/mycore/ai_core_service.dart' as cm;
import 'package:miko/mycore/chat_controller.dart' as cm;
import 'package:miko/mycore/settings_service.dart';
import 'package:openai_dart/openai_dart.dart' as openai;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

// Import your new AiClient types you pasted (or place them in a shared file)

class OpenAIClientAdapter implements AiClient {
  OpenAIClientAdapter({required this.client, this.defaultVoice = 'alloy'});

  final openai.OpenAIClient client;
  final String defaultVoice;

  @override
  bool get supportsToolInjectionMidStream => false;

  @override
  Future<AiResponse> createCompletion(AiRequest request) async {
    final openaiReq = _toOpenAIRequest(request);
    final res = await client.createChatCompletion(request: openaiReq);

    final choice = res.choices.first;

    // Text
    final text = choice.message.content;

    // Audio (non-stream)
    Uint8List? audioBytes;
    AudioFormat? audioFmt;
    final audio = choice.message.audio?.data;
    if (audio != null && audio.isNotEmpty) {
      audioBytes = base64Decode(audio);
      audioFmt = AudioFormat.wav;
    }

    // Tool calls
    final toolCalls = <AiToolCall>[];
    for (final tc
        in (choice.message.toolCalls ??
            const <openai.ChatCompletionMessageToolCall>[])) {
      final fn = tc.function;
      Map<String, dynamic> args = {};
      try {
        final decoded = json.decode(fn.arguments);
        if (decoded is Map<String, dynamic>) args = decoded;
      } catch (_) {}
      toolCalls.add(AiToolCall(id: tc.id, name: fn.name, arguments: args));
    }

    return AiResponse(
      text: text,
      audioBytes: audioBytes,
      audioFormat: audioFmt,
      toolCalls: toolCalls,
      isFinal: true,
    );
  }

  @override
  Stream<AiStreamEvent> createCompletionStream(AiRequest request) async* {
    final openaiReq = _toOpenAIRequest(request);
    final stream = client.createChatCompletionStream(request: openaiReq);

    yield AiStreamStart(const Uuid().v4());
    await for (final chunk in stream) {
      final choices = chunk.choices;
      if (choices == null || choices.isEmpty) continue;
      final delta = choices.first.delta;

      // Text deltas
      final textDelta = delta?.content;
      if (textDelta != null && textDelta.isNotEmpty) {
        yield AiTextDelta(textDelta);
      }

      // Audio chunks (preview models)
      final audio = delta?.audio;
      if (audio != null) {
        final b64 = audio.data;
        if (b64 != null && b64.isNotEmpty) {
          final fmt = AudioFormat.wav;
          yield AiAudioChunk(base64Decode(b64), format: fmt);
        }
      }

      // Tool calls (delta -> final)
      final toolCalls =
          delta?.toolCalls ??
          const <openai.ChatCompletionStreamMessageToolCallChunk>[];
      for (final tcd in toolCalls) {
        final fn = tcd.function;
        Map<String, dynamic> args = {};
        try {
          final decoded = json.decode(fn?.arguments ?? '{}');
          if (decoded is Map<String, dynamic>) args = decoded;
        } catch (_) {}
        yield AiToolCallDelta(
          id: tcd.id ?? const Uuid().v4(),
          name: fn?.name ?? 'unknown_tool',
          arguments: args,
          isFinal: true,
        );
      }
    }
    yield AiStreamDone();
  }

  @override
  Future<void> injectToolResultIntoStream({
    required String sessionId,
    required String toolCallId,
    required Map<String, dynamic> result,
  }) {
    // Not supported by OpenAI chat completions stream
    throw UnimplementedError('OpenAI stream injection not supported');
  }

  // ------- Mapping helpers -------

  openai.CreateChatCompletionRequest _toOpenAIRequest(AiRequest r) {
    final messages = <openai.ChatCompletionMessage>[];
    for (final m in r.messages) {
      messages.add(_toOpenAIMessage(m));
    }

    // Modalities and audio options if audio requested
    final wantsAudio = r.modalities.contains(ChatModality.audio);
    final modalities = wantsAudio
        ? const [
            openai.ChatCompletionModality.text,
            openai.ChatCompletionModality.audio,
          ]
        : const [openai.ChatCompletionModality.text];

    openai.ChatCompletionAudioOptions? audioOpts;
    if (wantsAudio) {
      audioOpts = openai.ChatCompletionAudioOptions(
        voice: _voice(r.voice ?? defaultVoice),
        format: _toOpenAIAudioFormat(r.outputAudioFormat)!,
      );
    }

    // Tools
    List<openai.ChatCompletionTool>? tools;
    if (r.tools != null && r.tools!.isNotEmpty) {
      tools = r.tools!
          .map(
            (t) => openai.ChatCompletionTool(
              type: openai.ChatCompletionToolType.function,
              function: openai.FunctionObject(
                name: t.name,
                description: t.description,
                parameters: t.parameters,
                strict: t.strict,
              ),
            ),
          )
          .toList(growable: false);
    }

    return openai.CreateChatCompletionRequest(
      model: openai.ChatCompletionModel.modelId(r.model),
      messages: messages,
      modalities: modalities,
      audio: audioOpts,
      tools: tools,
      toolChoice: r.toolChoice == null
          ? null
          : openai.ChatCompletionToolChoiceOption.mode(
              r.toolChoice == 'none'
                  ? openai.ChatCompletionToolChoiceMode.none
                  : openai.ChatCompletionToolChoiceMode.auto,
            ),
    );
  }

  openai.ChatCompletionMessage _toOpenAIMessage(AiMessage m) {
    switch (m.role) {
      case ChatRole.system:
        return openai.ChatCompletionMessage.system(content: m.text ?? '');
      case ChatRole.user:
        final parts = <openai.ChatCompletionMessageContentPart>[];
        for (final p in (m.parts ?? const [])) {
          switch (p.kind) {
            case ContentKind.text:
              parts.add(
                openai.ChatCompletionMessageContentPart.text(text: p.data),
              );
              break;
            case ContentKind.imageBase64:
              parts.add(
                openai.ChatCompletionMessageContentPart.image(
                  imageUrl: openai.ChatCompletionMessageImageUrl(
                    url: 'data:image/jpeg;base64,${p.data}',
                  ),
                ),
              );
              break;
            case ContentKind.audioBase64:
              parts.add(
                openai.ChatCompletionMessageContentPart.audio(
                  inputAudio: openai.ChatCompletionMessageInputAudio(
                    data: p.data,
                    format: _toOpenAIInputAudioFmt(p.audioFormat),
                  ),
                ),
              );
              break;
          }
        }
        return openai.ChatCompletionMessage.user(
          content: openai.ChatCompletionUserMessageContent.parts(parts),
        );
      case ChatRole.assistant:
        return openai.ChatCompletionMessage.assistant(content: m.text ?? '');
      case ChatRole.tool:
        return openai.ChatCompletionMessage.tool(
          toolCallId: m.toolCallId ?? const Uuid().v4(),
          content: m.text ?? '{}',
        );
    }
  }

  openai.ChatCompletionAudioVoice _voice(String v) {
    switch (v.toLowerCase()) {
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
  openai.ChatCompletionMessageInputAudioFormat _toOpenAIInputAudioFmt(
    AudioFormat? f,
  ) {
    switch (f) {
      case AudioFormat.mp3:
        return openai.ChatCompletionMessageInputAudioFormat.mp3;
      case AudioFormat.wav:
        return openai.ChatCompletionMessageInputAudioFormat.wav;
      case AudioFormat.opus:
      case AudioFormat.flac:
      case AudioFormat.m4a:
      case AudioFormat.webm:
      default:
        return openai.ChatCompletionMessageInputAudioFormat.wav;
    }
  }

  openai.ChatCompletionAudioFormat? _toOpenAIAudioFormat(AudioFormat? f) {
    switch (f) {
      case AudioFormat.mp3:
        return openai.ChatCompletionAudioFormat.mp3;
      case AudioFormat.wav:
        return openai.ChatCompletionAudioFormat.wav;
      case AudioFormat.opus:
      case AudioFormat.flac:
      case AudioFormat.m4a:
      case AudioFormat.webm:
      default:
        return openai.ChatCompletionAudioFormat.wav;
    }
  }

  AudioFormat? _fromOpenAIAudioFormat(openai.ChatCompletionAudioFormat? f) {
    switch (f) {
      case openai.ChatCompletionAudioFormat.mp3:
        return AudioFormat.mp3;
      case openai.ChatCompletionAudioFormat.wav:
        return AudioFormat.wav;
      default:
        return null;
    }
  }
}

class AiClientCoreServiceAdapter implements cm.AiCoreService {
  AiClientCoreServiceAdapter({
    required this.aiClient,
    required this.settings,
    required this.settingsService,
  });

  final AiClient aiClient;
  final cm.AiSettings settings;
  final StorageSettingsService settingsService;

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

  // ---------- Basic messaging ----------

  @override
  Future<cm.AiResponse> messageMulti({
    required List<cm.UnifiedMessage> history,
    cm.AiCallOptions options = const cm.AiCallOptions(),
  }) async {
    final req = AiRequest(
      model: settings.modelId,
      modalities: const [ChatModality.text],
      messages: _toAiMessages(history),
      tools: null,
      toolChoice: null,
      voice: null,
      outputAudioFormat: null,
    );
    final resp = await aiClient.createCompletion(req);

    final msg = cm.UnifiedMessage(
      id: const Uuid().v4(),
      role: cm.MessageRole.assistant,
      text: resp.text ?? '',
      attachments: const [],
      createdAt: DateTime.now(),
    );
    return cm.AiResponse(message: msg, raw: {'text': resp.text});
  }

  @override
  Stream<cm.AiStreamEvent> streamMessage({
    required List<cm.UnifiedMessage> history,
    cm.AiCallOptions options = const cm.AiCallOptions(),
  }) async* {
    yield const cm.AiStreamStarted();
    yield const cm.AiStreamThinking(true);

    final req = AiRequest(
      model: settings.modelId,
      modalities: const [
        ChatModality.text,
      ], // text stream; audio is handled in streamVoice/voiceResponse
      messages: _toAiMessages(history),
      tools: null,
      toolChoice: null,
      voice: null,
      outputAudioFormat: null,
    );

    final buf = StringBuffer();
    var thinking = true;

    try {
      await for (final ev in aiClient.createCompletionStream(req)) {
        if (ev is AiTextDelta) {
          buf.write(ev.textDelta);
          if (thinking) {
            yield const cm.AiStreamThinking(false);
            thinking = false;
          }
          yield cm.AiStreamDeltaText(
            delta: ev.textDelta,
            fullText: buf.toString(),
          );
        } else if (ev is AiToolCallDelta) {
          yield cm.AiStreamToolCall(toolName: ev.name, args: ev.arguments);
        } else if (ev is AiStreamError) {
          throw ev.error;
        } else if (ev is AiStreamDone) {
          if (thinking) yield const cm.AiStreamThinking(false);
          final m = cm.UnifiedMessage(
            id: const Uuid().v4(),
            role: cm.MessageRole.assistant,
            text: buf.toString(),
            createdAt: DateTime.now(),
          );
          yield cm.AiStreamCompleted(
            cm.AiResponse(message: m, raw: {'text': buf.toString()}),
          );
        }
      }
    } catch (e, st) {
      yield cm.AiStreamError(e, st);
    }
  }

  // ---------- Voice (non-stream) ----------

  @override
  Future<cm.VoiceResponse> voiceResponse({
    required List<cm.UnifiedMessage> history,
    cm.AiCallOptions options = const cm.AiCallOptions(),
    cm.AiTtsOptions tts = const cm.AiTtsOptions(),
  }) async {
    final req = AiRequest(
      model: settings.modelId, // choose audio capable model in your settings
      modalities: const [ChatModality.text, ChatModality.audio],
      messages: _toAiMessages(history),
      tools: null,
      toolChoice: null,
      voice: settings.selectedVoice,
      outputAudioFormat: _pickAudioFormat(tts.responseMimeType),
    );

    final resp = await aiClient.createCompletion(req);
    final audio = resp.audioBytes ?? Uint8List(0);
    final file = await _persistAudio(
      audio,
      suggestedExt: _extFromFormat(resp.audioFormat),
    );

    settingsService.setIsAudioPlaying(audio.isNotEmpty);

    return cm.VoiceResponse(
      audioBytes: audio,
      mimeType: _mimeFromFormat(resp.audioFormat),
      transcript: resp.text,
      raw: {'size': audio.length, 'text': resp.text},
      file: file,
    );
  }

  // ---------- Voice streaming passthrough ----------

  @override
  Stream<cm.AiStreamEvent> streamVoice({
    required List<cm.UnifiedMessage> history,
    cm.AiCallOptions options = const cm.AiCallOptions(),
    cm.AiTtsOptions tts = const cm.AiTtsOptions(),
  }) async* {
    yield const cm.AiStreamStarted();
    yield const cm.AiStreamThinking(true);

    final req = AiRequest(
      model: settings.modelId,
      modalities: const [ChatModality.text, ChatModality.audio],
      messages: _toAiMessages(history),
      tools: null,
      toolChoice: null,
      voice: settings.selectedVoice,
      outputAudioFormat: _pickAudioFormat(tts.responseMimeType),
    );

    final textBuf = StringBuffer();
    final audioBuilder = BytesBuilder();
    var thinking = true;

    try {
      await for (final ev in aiClient.createCompletionStream(req)) {
        if (ev is AiTextDelta) {
          textBuf.write(ev.textDelta);
          if (thinking) {
            yield const cm.AiStreamThinking(false);
            thinking = false;
          }
          yield cm.AiStreamDeltaText(
            delta: ev.textDelta,
            fullText: textBuf.toString(),
          );
        } else if (ev is AiAudioChunk) {
          audioBuilder.add(ev.bytes);
          yield cm.AiStreamVoiceChunk(
            bytes: ev.bytes,
            mimeType: _mimeFromFormat(ev.format),
            index: 0,
          );
        } else if (ev is AiStreamError) {
          throw ev.error;
        } else if (ev is AiStreamDone) {
          if (thinking) yield const cm.AiStreamThinking(false);

          final text = textBuf.toString();
          final finalMsg = cm.UnifiedMessage(
            id: const Uuid().v4(),
            role: cm.MessageRole.assistant,
            text: text,
            createdAt: DateTime.now(),
          );
          yield cm.AiStreamCompleted(
            cm.AiResponse(message: finalMsg, raw: {'text': text}),
          );

          final audio = audioBuilder.toBytes();
          final file = await _persistAudio(audio, suggestedExt: '.wav');
          yield cm.AiStreamVoiceCompleted(
            cm.VoiceResponse(
              audioBytes: audio,
              mimeType: 'audio/wav',
              transcript: text.isEmpty ? null : text,
              raw: {'size': audio.length},
              file: file,
            ),
          );
        }
      }
    } catch (e, st) {
      yield cm.AiStreamError(e, st);
    }
  }

  // ---------- Tools (non-stream loop) ----------

  @override
  Future<cm.AiResponse> runWithTools({
    required List<cm.UnifiedMessage> history,
    required List<cm.ToolSpec> tools,
    cm.AiCallOptions options = const cm.AiCallOptions(),
  }) async {
    final aiTools = tools
        .map(
          (t) => AiToolDefinition(
            name: t.name,
            description: t.description,
            parameters: t.jsonSchema,
            strict: true,
          ),
        )
        .toList(growable: false);

    final baseReq = AiRequest(
      model: settings.modelId,
      modalities: const [ChatModality.text],
      messages: _toAiMessages(history),
      tools: aiTools,
      toolChoice: null,
      voice: null,
      outputAudioFormat: null,
    );

    var messages = List<AiMessage>.from(baseReq.messages);
    for (var i = 0; i < 12; i++) {
      final resp = await aiClient.createCompletion(
        AiRequest(
          model: baseReq.model,
          modalities: baseReq.modalities,
          messages: messages,
          tools: baseReq.tools,
          toolChoice: baseReq.toolChoice,
          voice: baseReq.voice,
          outputAudioFormat: baseReq.outputAudioFormat,
        ),
      );

      if (resp.toolCalls.isEmpty) {
        final m = cm.UnifiedMessage(
          id: const Uuid().v4(),
          role: cm.MessageRole.assistant,
          text: resp.text ?? '',
          createdAt: DateTime.now(),
        );
        return cm.AiResponse(message: m, raw: {'text': resp.text});
      }

      for (final call in resp.toolCalls) {
        // Execute via provided ToolSpec handlers
        final spec = tools.firstWhere(
          (t) => t.name == call.name,
          orElse: () => cm.ToolSpec(
            name: call.name,
            description: 'Unknown tool',
            jsonSchema: const {'type': 'object', 'properties': {}},
            handler: (a) async => 'Error: Unknown tool "${call.name}"',
          ),
        );
        final result = await spec.handler(call.arguments);
        messages.add(
          AiMessage.toolResult(
            toolCallId: call.id,
            resultJson: jsonEncode({'result': result}),
          ),
        );
      }
    }

    final timeoutMsg = cm.UnifiedMessage(
      id: const Uuid().v4(),
      role: cm.MessageRole.assistant,
      text: 'Tool loop exceeded iteration limit.',
      createdAt: DateTime.now(),
    );
    return cm.AiResponse(
      message: timeoutMsg,
      raw: const {'error': 'max_iterations_exceeded'},
    );
  }

  // ---------- Misc you already had ----------

  @override
  Future<String> transcribe({
    required Uint8List audioBytes,
    required cm.AudioFormat format,
    cm.AiCallOptions options = const cm.AiCallOptions(),
  }) async {
    // Keep your existing OpenAI transcribe (via chat) or leave unimplemented
    // for minimal change you can return '' and keep old implementation if needed.
    return '';
  }

  @override
  Future<Uint8List> tts({
    required String text,
    cm.AiTtsOptions tts = const cm.AiTtsOptions(),
    cm.AiCallOptions options = const cm.AiCallOptions(),
  }) async {
    // Use voiceResponse over a simple prompt
    final resp = await voiceResponse(
      history: [
        cm.UnifiedMessage(
          id: const Uuid().v4(),
          role: cm.MessageRole.user,
          text: text,
          createdAt: DateTime.now(),
        ),
      ],
    );
    return resp.audioBytes;
  }

  @override
  Future<String> summarize({
    String? text,
    List<cm.UnifiedMessage> history = const [],
    cm.AiCallOptions options = const cm.AiCallOptions(),
  }) async {
    final messages = <AiMessage>[
      const AiMessage.system(
        'You are a concise summarizer. Provide a brief, clear summary in 3-5 bullet points.',
      ),
      if (text != null && text.trim().isNotEmpty)
        AiMessage.user(
          parts: [AiMessagePart(kind: ContentKind.text, data: text)],
        ),
      ..._toAiMessages(history),
    ];
    final resp = await aiClient.createCompletion(
      AiRequest(
        model: settings.modelId,
        modalities: const [ChatModality.text],
        messages: messages,
        tools: null,
        toolChoice: null,
        voice: null,
        outputAudioFormat: null,
      ),
    );
    return resp.text ?? '';
  }

  @override
  Future<String> generateTitle({
    required String seedText,
    cm.AiCallOptions options = const cm.AiCallOptions(),
  }) async {
    final resp = await aiClient.createCompletion(
      AiRequest(
        model: settings.modelId,
        modalities: const [ChatModality.text],
        messages: [
          const AiMessage.system(
            'Return a short 1-3 word title based on the input. No punctuation.',
          ),
          AiMessage.user(
            parts: [AiMessagePart(kind: ContentKind.text, data: seedText)],
          ),
        ],
        tools: null,
        toolChoice: null,
        voice: null,
        outputAudioFormat: null,
      ),
    );
    return (resp.text ?? '').trim();
  }

  @override
  Future<String> ocr({
    required Uint8List imageBytes,
    required String mimeType,
    cm.AiCallOptions options = const cm.AiCallOptions(),
  }) async {
    throw UnsupportedError('OCR via this provider is not supported.');
  }

  // ---------- Mapping helpers ----------

  List<AiMessage> _toAiMessages(List<cm.UnifiedMessage> history) {
    final list = <AiMessage>[];
    for (final m in history) {
      switch (m.role) {
        case cm.MessageRole.system:
          // Prefer your settings.systemPrompt if you need; here we use actual text if present
          list.add(AiMessage.system(m.text ?? ''));
          break;
        case cm.MessageRole.user:
          final parts = <AiMessagePart>[];
          if ((m.text ?? '').isNotEmpty) {
            parts.add(AiMessagePart(kind: ContentKind.text, data: m.text!));
          }
          for (final a in m.attachments) {
            a.map(
              image: (img) {
                parts.add(
                  AiMessagePart(
                    kind: ContentKind.imageBase64,
                    data: img.base64Data,
                  ),
                );
              },
              audio: (aud) {
                parts.add(
                  AiMessagePart(
                    kind: ContentKind.audioBase64,
                    data: base64Encode(aud.bytes),
                    audioFormat: _toAiAudioFormat(aud.format),
                  ),
                );
              },
              file: (f) {
                // optional: append as text notice
                parts.add(
                  AiMessagePart(
                    kind: ContentKind.text,
                    data: 'Attached file: ${f.fileName} (${f.mimeType})',
                  ),
                );
              },
              chunk: (c) {
                parts.add(AiMessagePart(kind: ContentKind.text, data: c.text));
              },
            );
          }
          list.add(AiMessage.user(parts: parts));
          break;
        case cm.MessageRole.assistant:
          list.add(AiMessage.assistantText(m.text ?? ''));
          break;
        case cm.MessageRole.tool:
          // If you have tool results in history, inject as tool result JSON
          list.add(AiMessage.assistantText(m.text ?? ''));
          break;
      }
    }
    return list;
  }

  AudioFormat _toAiAudioFormat(cm.AudioFormat f) {
    switch (f) {
      case cm.AudioFormat.mp3:
        return AudioFormat.mp3;
      case cm.AudioFormat.wav:
        return AudioFormat.wav;
    }
  }

  String _mimeFromFormat(AudioFormat? f) {
    switch (f) {
      case AudioFormat.mp3:
        return 'audio/mpeg';
      case AudioFormat.opus:
        return 'audio/opus';
      case AudioFormat.flac:
        return 'audio/flac';
      case AudioFormat.m4a:
        return 'audio/mp4';
      case AudioFormat.webm:
        return 'audio/webm';
      case AudioFormat.wav:
      default:
        return 'audio/wav';
    }
  }

  String _extFromFormat(AudioFormat? f) {
    switch (f) {
      case AudioFormat.mp3:
        return '.mp3';
      case AudioFormat.opus:
        return '.opus';
      case AudioFormat.flac:
        return '.flac';
      case AudioFormat.m4a:
        return '.m4a';
      case AudioFormat.webm:
        return '.webm';
      case AudioFormat.wav:
      default:
        return '.wav';
    }
  }

  AudioFormat? _pickAudioFormat(String mime) {
    switch (mime.toLowerCase()) {
      case 'audio/mpeg':
        return AudioFormat.mp3;
      case 'audio/opus':
        return AudioFormat.opus;
      case 'audio/flac':
        return AudioFormat.flac;
      case 'audio/mp4':
        return AudioFormat.m4a;
      case 'audio/webm':
        return AudioFormat.webm;
      case 'audio/wav':
      default:
        return AudioFormat.wav;
    }
  }

  Future<File> _persistAudio(
    Uint8List bytes, {
    String suggestedExt = '.wav',
  }) async {
    final dir = await getApplicationSupportDirectory();
    final audioDir = Directory(p.join(dir.path, 'audio'));
    if (!await audioDir.exists()) {
      await audioDir.create(recursive: true);
    }
    final id = const Uuid().v4();
    final file = File(p.join(audioDir.path, '$id$suggestedExt'));
    await file.writeAsBytes(bytes, flush: true);
    return file;
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

  // Unused default wrappers in this adapter (you can inherit base defaults if desired)
}
