// lib/core/ai_core_service.dart
import 'dart:async';
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

  const AiProviderCapabilities({
    required this.supportsStreaming,
    required this.supportsAudioInput,
    required this.supportsAudioOutput,
    required this.supportsTranscription,
    required this.supportsTts,
    required this.supportsToolCalling,
    required this.supportsOcr,
  });
}

class AiCallOptions {
  final String? modelIdOverride;
  final double? temperature;
  final Map<String, dynamic> extra; // provider-specific

  const AiCallOptions({
    this.modelIdOverride,
    this.temperature,
    this.extra = const {},
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
  VoiceResponse({
    required this.audioBytes,
    required this.mimeType,
    this.transcript,
    this.raw = const {},
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

class AiStreamCompleted extends AiStreamEvent {
  final AiResponse response;
  const AiStreamCompleted(this.response);
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