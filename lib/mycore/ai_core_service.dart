// lib/core/ai_core_service.dart
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'ai_core_models.dart';

class AiProviderCapabilities {
  final bool supportsStreaming;
  final bool supportsAudioInput;
  final bool supportsAudioOutput;
  final bool supportsTranscription;
  final bool supportsTts;
  final bool supportsToolCalling;
  final bool supportsOcr;

  // Extended capabilities
  final bool supportsVoiceStreaming; // streaming TTS/audio out
  final bool supportsReasoningStream; // "thinking" stream before content
  final bool supportsWaitEstimates; // ETA/progress signaling

  const AiProviderCapabilities({
    required this.supportsStreaming,
    required this.supportsAudioInput,
    required this.supportsAudioOutput,
    required this.supportsTranscription,
    required this.supportsTts,
    required this.supportsToolCalling,
    required this.supportsOcr,
    this.supportsVoiceStreaming = false,
    this.supportsReasoningStream = false,
    this.supportsWaitEstimates = false,
  });
}

class AiCallOptions {
  final String? modelIdOverride;
  final double? temperature;
  final Map<String, dynamic> extra; // provider-specific

  // Extended options
  final bool requestReasoningStream; // request reasoning tokens stream if provider supports
  final bool requestVoiceStream; // request voice (tts) streaming if provider supports
  final Duration? clientWaitEstimate; // client-side ETA for non-stream calls (for UX)

  const AiCallOptions({
    this.modelIdOverride,
    this.temperature,
    this.extra = const {},
    this.requestReasoningStream = false,
    this.requestVoiceStream = false,
    this.clientWaitEstimate,
  });
}

class AiTtsOptions {
  final String? voice; // e.g., "alloy" (OpenAI) or "charon" (Gemini voices)
  final String responseMimeType; // e.g., "audio/wav", "audio/ogg; codecs=opus"

  const AiTtsOptions({
    this.voice,
    this.responseMimeType = 'audio/wav',
  });
}

class AiResponse {
  final UnifiedMessage message;
  final Map<String, dynamic> raw;
  AiResponse({required this.message, this.raw = const {}});
}

class VoiceResponse {
  final Uint8List audioBytes;
  final String? transcript;
  final String mimeType;
  final Map<String, dynamic> raw;
  final File file;
  VoiceResponse({
    required this.audioBytes,
    required this.mimeType,
    this.transcript,
    this.raw = const {},
   required this.file,
  });
}

// Streaming events
abstract class AiStreamEvent {
  const AiStreamEvent();
}

class AiStreamStarted extends AiStreamEvent {
  const AiStreamStarted();
}

class AiStreamThinking extends AiStreamEvent {
  final bool isThinking;
  const AiStreamThinking(this.isThinking);
}

// Streaming of explicit "reasoning" content/tokens before main answer
class AiStreamReasoningDelta extends AiStreamEvent {
  final String delta;
  final String fullText;
  const AiStreamReasoningDelta({required this.delta, required this.fullText});
}

class AiStreamDeltaText extends AiStreamEvent {
  final String delta;
  final String fullText;
  const AiStreamDeltaText({required this.delta, required this.fullText});
}

class AiStreamToolCall extends AiStreamEvent {
  final String toolName;
  final Map<String, dynamic> args;
  const AiStreamToolCall({required this.toolName, required this.args});
}

// Optional: surfaced tool result after handler executes
class AiStreamToolResult extends AiStreamEvent {
  final String toolName;
  final Map<String, dynamic> args;
  final String result;
  const AiStreamToolResult({
    required this.toolName,
    required this.args,
    required this.result,
  });
}

// Wait/ETA events useful for non-streaming calls
class AiStreamWaitEstimate extends AiStreamEvent {
  final Duration estimated;
  const AiStreamWaitEstimate(this.estimated);
}

class AiStreamWaitTick extends AiStreamEvent {
  final Duration elapsed;
  const AiStreamWaitTick(this.elapsed);
}

class AiStreamWaitDone extends AiStreamEvent {
  final Duration elapsed;
  const AiStreamWaitDone(this.elapsed);
}

// Voice streaming events (audio chunks + transcription deltas)
class AiStreamVoiceChunk extends AiStreamEvent {
  final Uint8List bytes;
  final String mimeType;
  final int index;
  final Duration? duration; // optional per-chunk duration if available
  const AiStreamVoiceChunk({
    required this.bytes,
    required this.mimeType,
    required this.index,
    this.duration,
  });
}

class AiStreamTranscriptionDelta extends AiStreamEvent {
  final String delta;
  final String fullText;
  final bool isFinal;
  const AiStreamTranscriptionDelta({
    required this.delta,
    required this.fullText,
    this.isFinal = false,
  });
}

class AiStreamCompleted extends AiStreamEvent {
  final AiResponse response;
  const AiStreamCompleted(this.response);
}

class AiStreamVoiceCompleted extends AiStreamEvent {
  final VoiceResponse response;
  const AiStreamVoiceCompleted(this.response);
}

class AiStreamError extends AiStreamEvent {
  final Object error;
  final StackTrace? stackTrace;
  const AiStreamError(this.error, [this.stackTrace]);
}

abstract class AiCoreService {
  AiProviderCapabilities get capabilities;

  // Non-streamed chat completion with full multi-modal message history
  Future<AiResponse> messageMulti({
    required List<UnifiedMessage> history,
    AiCallOptions options = const AiCallOptions(),
  });

  // Streamed chat completion (token deltas, optional tool-calls)
  Stream<AiStreamEvent> streamMessage({
    required List<UnifiedMessage> history,
    AiCallOptions options = const AiCallOptions(),
  });

  // Voice response for given history (provider-specific implementation)
  Future<VoiceResponse> voiceResponse({
    required List<UnifiedMessage> history,
    AiCallOptions options = const AiCallOptions(),
    AiTtsOptions tts = const AiTtsOptions(),
  });

  // Transcribe raw audio
  Future<String> transcribe({
    required Uint8List audioBytes,
    required AudioFormat format,
    AiCallOptions options = const AiCallOptions(),
  });

  // Generate speech from text
  Future<Uint8List> tts({
    required String text,
    AiTtsOptions tts = const AiTtsOptions(),
    AiCallOptions options = const AiCallOptions(),
  });

  // Summarize text or conversation
  Future<String> summarize({
    String? text,
    List<UnifiedMessage> history = const [],
    AiCallOptions options = const AiCallOptions(),
  });

  // Prompt/title helpers
  Future<String> generateTitle({
    required String seedText,
    AiCallOptions options = const AiCallOptions(),
  });

  // Tool calling surface (optional)
  Future<AiResponse> runWithTools({
    required List<UnifiedMessage> history,
    required List<ToolSpec> tools,
    AiCallOptions options = const AiCallOptions(),
  });

  // OCR by image (bytes + mime)
  Future<String> ocr({
    required Uint8List imageBytes,
    required String mimeType,
    AiCallOptions options = const AiCallOptions(),
  });

  // ---------- Convenience orchestrations (streaming wrappers) ----------

  // Emits Started -> (optional WaitEstimate + WaitTicks) -> Completed/Error for non-streaming messageMulti
  Stream<AiStreamEvent> eventsForMessageMulti({
    required List<UnifiedMessage> history,
    AiCallOptions options = const AiCallOptions(),
    Duration waitTick = const Duration(milliseconds: 250),
  }) {
    final controller = StreamController<AiStreamEvent>();
    controller.onListen = () async {
      controller.add(const AiStreamStarted());
      // If caller provided a client-side ETA, surface it
      final eta = options.clientWaitEstimate;
      if (eta != null) {
        controller.add(AiStreamWaitEstimate(eta));
      }
      final sw = Stopwatch()..start();
      final ticker = Timer.periodic(waitTick, (_) {
        controller.add(AiStreamWaitTick(sw.elapsed));
      });
      try {
        final resp = await messageMulti(history: history, options: options);
        ticker.cancel();
        sw.stop();
        controller.add(AiStreamWaitDone(sw.elapsed));
        controller.add(AiStreamCompleted(resp));
      } catch (e, st) {
        ticker.cancel();
        sw.stop();
        controller.add(AiStreamError(e, st));
      } finally {
        await controller.close();
      }
    };
    return controller.stream;
  }

  // Emits Started -> (optional WaitEstimate + WaitTicks) -> VoiceCompleted/Error for non-streaming voiceResponse
  Stream<AiStreamEvent> eventsForVoiceResponse({
    required List<UnifiedMessage> history,
    AiCallOptions options = const AiCallOptions(),
    AiTtsOptions tts = const AiTtsOptions(),
    Duration waitTick = const Duration(milliseconds: 250),
  }) {
    final controller = StreamController<AiStreamEvent>();
    controller.onListen = () async {
      controller.add(const AiStreamStarted());
      final eta = options.clientWaitEstimate;
      if (eta != null) {
        controller.add(AiStreamWaitEstimate(eta));
      }
      final sw = Stopwatch()..start();
      final ticker = Timer.periodic(waitTick, (_) {
        controller.add(AiStreamWaitTick(sw.elapsed));
      });
      try {
        final resp = await voiceResponse(history: history, options: options, tts: tts);
        ticker.cancel();
        sw.stop();
        controller.add(AiStreamWaitDone(sw.elapsed));
        // Provide one chunk for simple players, then completion
        controller.add(AiStreamVoiceChunk(
          bytes: resp.audioBytes,
          mimeType: resp.mimeType,
          index: 0,
          duration: null,
        ));
        controller.add(AiStreamVoiceCompleted(resp));
      } catch (e, st) {
        ticker.cancel();
        sw.stop();
        controller.add(AiStreamError(e, st));
      } finally {
        await controller.close();
      }
    };
    return controller.stream;
  }

  // If provider supports streaming voice, override this method to yield chunks progressively.
  // Default behavior falls back to non-streaming voiceResponse and emits a single chunk.
  Stream<AiStreamEvent> streamVoice({
    required List<UnifiedMessage> history,
    AiCallOptions options = const AiCallOptions(),
    AiTtsOptions tts = const AiTtsOptions(),
  }) {
    // Default to non-streaming wrapper
    return eventsForVoiceResponse(history: history, options: options, tts: tts);
  }

  // Emits Started -> (optional WaitEstimate + WaitTicks) -> Completed/Error for non-streaming tool orchestration
  Stream<AiStreamEvent> eventsForRunWithTools({
    required List<UnifiedMessage> history,
    required List<ToolSpec> tools,
    AiCallOptions options = const AiCallOptions(),
    Duration waitTick = const Duration(milliseconds: 250),
  }) {
    final controller = StreamController<AiStreamEvent>();
    controller.onListen = () async {
      controller.add(const AiStreamStarted());
      final eta = options.clientWaitEstimate;
      if (eta != null) {
        controller.add(AiStreamWaitEstimate(eta));
      }
      final sw = Stopwatch()..start();
      final ticker = Timer.periodic(waitTick, (_) {
        controller.add(AiStreamWaitTick(sw.elapsed));
      });
      try {
        final resp = await runWithTools(history: history, tools: tools, options: options);
        ticker.cancel();
        sw.stop();
        controller.add(AiStreamWaitDone(sw.elapsed));
        controller.add(AiStreamCompleted(resp));
      } catch (e, st) {
        ticker.cancel();
        sw.stop();
        controller.add(AiStreamError(e, st));
      } finally {
        await controller.close();
      }
    };
    return controller.stream;
  }
}

typedef ToolHandler = Future<String> Function(Map<String, dynamic> args);

class ToolSpec {
  final String name;
  final String description;
  // JSON Schema for arguments expected by LLM tool-calling APIs (provider-specific usage)
  final Map<String, dynamic> jsonSchema;
  final ToolHandler handler;

  const ToolSpec({
    required this.name,
    required this.description,
    required this.jsonSchema,
    required this.handler,
  });
}


