import 'dart:convert';
import 'dart:typed_data';
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miko/mycore/audio_player_tile.dart';





import 'package:uuid/uuid.dart';

typedef JsonSchema = Map<String, dynamic>;

abstract class ChatTool {
  String get name;
  String get description;
  JsonSchema get parameters; // JSON Schema
  bool get strict; // enforce exact argument conformance

  Future<Map<String, dynamic>> execute(Map<String, dynamic> args);
}

class ToolsRegistry {
  final Map<String, ChatTool> _tools = {};

  void register(ChatTool tool) {
    _tools[tool.name] = tool;
  }

  void registerAll(Iterable<ChatTool> tools) {
    for (final t in tools) {
      register(t);
    }
  }

  ChatTool? get(String name) => _tools[name];

  List<ChatTool> get all => _tools.values.toList(growable: false);
}

class SchemaValidationException implements Exception {
  final String message;
  SchemaValidationException(this.message);
  @override
  String toString() => 'SchemaValidationException: $message';
}

/// Minimal strict JSON schema validator for tool arguments.
/// Supports: type: object with properties, required, enum; primitive types.
void validateArgsAgainstSchema({
  required Map<String, dynamic> args,
  required JsonSchema schema,
  required bool strict,
}) {
  if (schema['type'] != 'object') {
    throw SchemaValidationException('Top-level schema.type must be object');
  }
  final props = (schema['properties'] as Map?)?.cast<String, dynamic>() ?? {};
  final requiredList = (schema['required'] as List?)?.cast<String>() ?? const [];

  // required keys present
  for (final key in requiredList) {
    if (!args.containsKey(key)) {
      throw SchemaValidationException('Missing required key: $key');
    }
  }

  if (strict) {
    // no extra keys
    for (final key in args.keys) {
      if (!props.containsKey(key)) {
        throw SchemaValidationException('Unexpected key: $key');
      }
    }
  }

  bool checkType(dynamic value, dynamic typeSpec) {
    if (typeSpec is List) {
      // union type list
      return typeSpec.any((t) => checkType(value, t));
    }
    switch (typeSpec) {
      case 'string':
        return value is String;
      case 'number':
        return value is num;
      case 'integer':
        return value is int;
      case 'boolean':
        return value is bool;
      case 'object':
        return value is Map;
      case 'array':
        return value is List;
      default:
        return true; // unknown type, skip
    }
  }

  for (final entry in props.entries) {
    final key = entry.key;
    final propSchema = (entry.value as Map).cast<String, dynamic>();
    if (!args.containsKey(key)) continue;
    final value = args[key];
    final typeSpec = propSchema['type'];
    if (typeSpec != null && !checkType(value, typeSpec)) {
      throw SchemaValidationException('Key "$key" type mismatch. Expected $typeSpec');
    }
    if (propSchema.containsKey('enum')) {
      final enumVals = (propSchema['enum'] as List).toSet();
      if (!enumVals.contains(value)) {
        throw SchemaValidationException('Key "$key" not in enum set.');
      }
    }
  }
}

class GetCurrentWeatherTool extends ChatTool {
  @override
  String get name => 'get_current_weather';

  @override
  String get description => 'Get the current weather in a given location';

  @override
  Map<String, dynamic> get parameters => {
        'type': 'object',
        'properties': {
          'location': {
            'type': 'string',
            'description': 'The city and state, e.g. San Francisco, CA',
          },
          'unit': {
            'type': 'string',
            'description': 'The unit of temperature to return',
            'enum': ['celsius', 'fahrenheit'],
          },
        },
        'required': ['location'],
      };

  @override
  bool get strict => true;

  @override
  Future<Map<String, dynamic>> execute(Map<String, dynamic> args) async {
    final location = args['location'] as String;
    final unit = (args['unit'] as String?) ?? 'celsius';
    // Simulate an API call
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return {
      'location': location,
      'unit': unit,
      'temperature': unit == 'celsius' ? 22 : 71.6,
      'condition': 'sunny',
      'observedAt': DateTime.now().toIso8601String(),
    };
  }
}

// file: lib/bootstrap/register_tools.dart

void registerDefaultTools(ToolsRegistry registry) {
  registry.registerAll([
    GetCurrentWeatherTool(),
    // Add more tools here...
  ]);
}

enum RequestStatus {
  idle,
  creating,
  streaming,
  awaitingTool,
  finished,
  error,
}

class ChatHistoryNotifier extends StateNotifier<List<ChatMessageModel>> {
  ChatHistoryNotifier() : super(const []);

  void add(ChatMessageModel message) {
    state = [...state, message];
  }

  void updateById(String id, ChatMessageModel Function(ChatMessageModel) updater) {
    state = [
      for (final m in state)
        if (m.id == id) updater(m) else m,
    ];
  }

  void replaceLast(ChatMessageModel message) {
    if (state.isEmpty) {
      state = [message];
    } else {
      final newState = [...state];
      newState[newState.length - 1] = message;
      state = newState;
    }
  }

  void clear() => state = const [];
}

final chatHistoryProvider =
    StateNotifierProvider<ChatHistoryNotifier, List<ChatMessageModel>>((ref) {
  return ChatHistoryNotifier();
});

class RequestStatusNotifier extends StateNotifier<RequestStatus> {
  RequestStatusNotifier() : super(RequestStatus.idle);
  void set(RequestStatus s) => state = s;
}

final requestStatusProvider =
    StateNotifierProvider<RequestStatusNotifier, RequestStatus>((ref) {
  return RequestStatusNotifier();
});

final modelsConfigProvider = StateProvider<ModelsConfig>((ref) {
  return const ModelsConfig();
});

final toolsRegistryProvider = Provider<ToolsRegistry>((ref) {
  return ToolsRegistry();
});


class ChatRepository {
  ChatRepository(this.ref);
  final Ref ref;

  AiClient get _ai => ref.read(aiClientProvider);
  ToolsRegistry get _tools => ref.read(toolsRegistryProvider);
  ModelsConfig get _models => ref.read(modelsConfigProvider);

  // Helper: convert ChatTurnInput into AiMessage.user parts
  AiMessage _userInputToAiMessage(ChatTurnInput input) {
    final parts = <AiMessagePart>[];
    for (final p in input.parts) {
      switch (p.kind) {
        case ContentKind.text:
          parts.add(AiMessagePart(kind: ContentKind.text, data: p.data));
          break;
        case ContentKind.imageBase64:
          parts.add(
            AiMessagePart(
              kind: ContentKind.imageBase64,
              data: p.data,
              imageDetail: p.imageDetail,
            ),
          );
          break;
        case ContentKind.audioBase64:
          parts.add(
            AiMessagePart(
              kind: ContentKind.audioBase64,
              data: p.data,
              audioFormat: p.audioFormat,
            ),
          );
          break;
      }
    }
    return AiMessage.user(parts: parts);
  }

  List<AiMessage> _buildHistoryMessages(List<ChatMessageModel> history) {
    final messages = <AiMessage>[];
    for (final m in history) {
      switch (m.role) {
        case ChatRole.system:
          messages.add(AiMessage.system(m.contentText ?? ''));
          break;
        case ChatRole.user:
          // Users in history are stored as text/audio; convert to parts
          final parts = <AiMessagePart>[];
          if ((m.contentText ?? '').isNotEmpty) {
            parts.add(AiMessagePart(kind: ContentKind.text, data: m.contentText!));
          }
          if (m.audioBase64 != null && m.audioFormat != null) {
            parts.add(AiMessagePart(
              kind: ContentKind.audioBase64,
              data: m.audioBase64!,
              audioFormat: m.audioFormat,
            ));
          }
          messages.add(AiMessage.user(parts: parts));
          break;
        case ChatRole.assistant:
          messages.add(AiMessage.assistantText(m.contentText ?? ''));
          break;
        case ChatRole.tool:
          if (m.toolResult != null) {
            messages.add(AiMessage.toolResult(
              toolCallId: m.toolResult!.toolCallId,
              resultJson: jsonEncode(m.toolResult!.result),
            ));
          } else {
            // fallback to plain text
            messages.add(AiMessage.assistantText(m.contentText ?? ''));
          }
          break;
      }
    }
    return messages;
  }

  List<AiToolDefinition> _buildAiTools() {
    return _tools.all
        .map(
          (t) => AiToolDefinition(
            name: t.name,
            description: t.description,
            parameters: t.parameters,
            strict: t.strict,
          ),
        )
        .toList(growable: false);
  }

  String _selectModelId({required bool requestAudioOutput}) {
    return requestAudioOutput ? _models.audioModelId : _models.textModelId;
  }

  List<ChatModality> _selectModalities({required bool requestAudioOutput}) {
    if (requestAudioOutput) {
      return const [ChatModality.text, ChatModality.audio];
    }
    return const [ChatModality.text];
  }

  // A) Non-Streaming Future<void>
  Future<void> sendMessageNonStreaming({
    required ChatTurnInput input,
    required bool requestAudioOutput,
    String? systemPrompt,
  }) async {
    final history = ref.read(chatHistoryProvider);
    final status = ref.read(requestStatusProvider.notifier);
    status.set(RequestStatus.creating);

    final messageId = const Uuid().v4();
    ref.read(chatHistoryProvider.notifier).add(
          ChatMessageModel(
            id: messageId,
            role: ChatRole.assistant,
            isStreaming: true,
            timestamp: DateTime.now(),
          ),
        );

    final messages = <AiMessage>[
      if ((systemPrompt ?? '').isNotEmpty) AiMessage.system(systemPrompt!),
      ..._buildHistoryMessages(history),
      _userInputToAiMessage(input),
    ];

    final request = AiRequest(
      model: _selectModelId(requestAudioOutput: requestAudioOutput),
      modalities: _selectModalities(requestAudioOutput: requestAudioOutput),
      messages: messages,
      tools: _buildAiTools(),
      toolChoice: null, // let model decide
      voice: null, // let model choose
      outputAudioFormat: null, // let model choose; playback handles formats dynamically
    );

    try {
      final finalMessage = await _toolLoopNonStreaming(
        baseRequest: request,
        pendingMessageId: messageId,
      );
      ref.read(chatHistoryProvider.notifier).updateById(messageId, (_) => finalMessage);
      status.set(RequestStatus.finished);
    } catch (e) {
      status.set(RequestStatus.error);
      ref.read(chatHistoryProvider.notifier).updateById(
            messageId,
            (m) => m.copyWith(
              isStreaming: false,
              contentText: 'Error: $e',
            ),
          );
      rethrow;
    }
  }

  Future<ChatMessageModel> _toolLoopNonStreaming({
    required AiRequest baseRequest,
    required String pendingMessageId,
  }) async {
    var messages = List<AiMessage>.from(baseRequest.messages);
    final tools = _tools;

    while (true) {
      final resp = await _ai.createCompletion(
        AiRequest(
          model: baseRequest.model,
          modalities: baseRequest.modalities,
          messages: messages,
          tools: baseRequest.tools,
          toolChoice: baseRequest.toolChoice,
          voice: baseRequest.voice,
          outputAudioFormat: baseRequest.outputAudioFormat,
        ),
      );

      // If tool calls
      if (resp.toolCalls.isNotEmpty) {
        ref.read(requestStatusProvider.notifier).set(RequestStatus.awaitingTool);
        for (final call in resp.toolCalls) {
          final tool = tools.get(call.name);
          if (tool == null) {
            // Send back error result to model so it can recover
            final errorResult = {
              'error': 'Unknown tool: ${call.name}',
              'args': call.arguments,
            };
            messages.add(AiMessage.toolResult(
              toolCallId: call.id,
              resultJson: jsonEncode(errorResult),
            ));
            continue;
          }

          if (tool.strict) {
            validateArgsAgainstSchema(
              args: call.arguments,
              schema: tool.parameters,
              strict: true,
            );
          }

          final result = await tool.execute(call.arguments);
          messages.add(AiMessage.toolResult(
            toolCallId: call.id,
            resultJson: jsonEncode(result),
          ));

          // Log tool call in pending stream message
          ref.read(chatHistoryProvider.notifier).updateById(
                pendingMessageId,
                (m) => m.copyWith(
                  toolCall: ToolCall(id: call.id, name: call.name, arguments: call.arguments),
                  toolResult: ToolResultMessage(toolCallId: call.id, result: result),
                ),
              );
        }
        // continue loop with new messages including tool results
        continue;
      }

      // Final answer
      final text = resp.text ?? '';
      String? audioB64;
      AudioFormat? audioFmt;
      if (resp.audioBytes != null) {
        audioB64 = base64Encode(resp.audioBytes!);
        audioFmt = resp.audioFormat;
        // Prepare a local player for immediate playback
        final playerCtrl = ref.read(audioPlayersProvider).ensure(pendingMessageId);
        await playerCtrl.setBytes(resp.audioBytes!,
            contentType: _audioContentTypeFromFormat(audioFmt));
      }

      return ChatMessageModel(
        id: pendingMessageId,
        role: ChatRole.assistant,
        contentText: text.isNotEmpty ? text : null,
        audioBase64: audioB64,
        audioFormat: audioFmt,
        isStreaming: false,
        timestamp: DateTime.now(),
      );
    }
  }

  // B) Streaming Future<void>
  Future<void> sendMessageStreaming({
    required ChatTurnInput input,
    required bool requestAudioOutput,
    String? systemPrompt,
  }) async {
    final history = ref.read(chatHistoryProvider);
    final status = ref.read(requestStatusProvider.notifier);
    status.set(RequestStatus.streaming);

    final messageId = const Uuid().v4();
    // Create pending assistant message
    ref.read(chatHistoryProvider.notifier).add(
          ChatMessageModel(
            id: messageId,
            role: ChatRole.assistant,
            isStreaming: true,
            partialTextBuffer: '',
            partialAudioChunks: <Uint8List>[],
            timestamp: DateTime.now(),
          ),
        );

    // Base request
    final baseMessages = <AiMessage>[
      if ((systemPrompt ?? '').isNotEmpty) AiMessage.system(systemPrompt!),
      ..._buildHistoryMessages(history),
      _userInputToAiMessage(input),
    ];

    final request = AiRequest(
      model: _selectModelId(requestAudioOutput: requestAudioOutput),
      modalities: _selectModalities(requestAudioOutput: requestAudioOutput),
      messages: baseMessages,
      tools: _buildAiTools(),
      toolChoice: null,
      voice: null,
      outputAudioFormat: null,
    );

    try {
      await _toolLoopStreaming(
        baseRequest: request,
        pendingMessageId: messageId,
      );
      status.set(RequestStatus.finished);
    } catch (e) {
      status.set(RequestStatus.error);
      ref.read(chatHistoryProvider.notifier).updateById(
            messageId,
            (m) => m.copyWith(
              isStreaming: false,
              contentText: (m.partialTextBuffer?.isNotEmpty ?? false)
                  ? m.partialTextBuffer
                  : 'Error: $e',
            ),
          );
      rethrow;
    }
  }

  Future<void> _toolLoopStreaming({
    required AiRequest baseRequest,
    required String pendingMessageId,
  }) async {
    var messages = List<AiMessage>.from(baseRequest.messages);

    while (true) {
      final stream = _ai.createCompletionStream(
        AiRequest(
          model: baseRequest.model,
          modalities: baseRequest.modalities,
          messages: messages,
          tools: baseRequest.tools,
          toolChoice: baseRequest.toolChoice,
          voice: baseRequest.voice,
          outputAudioFormat: baseRequest.outputAudioFormat,
        ),
      );

      String? sessionId;
      AudioPlaybackController? audioCtrl;
      AudioFormat? currentAudioFmt;

      final completer = Completer<void>();
      final sub = stream.listen(
        (event) async {
          if (event is AiStreamStart) {
            sessionId = event.sessionId;
            // init audio streaming if needed
            final pending = ref.read(chatHistoryProvider).lastWhere((m) => m.id == pendingMessageId);
            if (pending.partialAudioChunks != null) {
              audioCtrl = ref.read(audioPlayersProvider).ensure(pendingMessageId);
              await audioCtrl!.startStreaming(
                contentType: _audioContentTypeFromFormat(null), // let player adapt (wav default)
              );
              // Autoplay
              unawaited(audioCtrl!.play());
            }
          } else if (event is AiTextDelta) {
            ref.read(chatHistoryProvider.notifier).updateById(
              pendingMessageId,
              (m) => m.copyWith(
                partialTextBuffer: (m.partialTextBuffer ?? '') + event.textDelta,
              ),
            );
          } else if (event is AiAudioChunk) {
            currentAudioFmt = event.format ?? currentAudioFmt;
            ref.read(chatHistoryProvider.notifier).updateById(
              pendingMessageId,
              (m) {
                final chunks = List<Uint8List>.from(m.partialAudioChunks ?? const []);
                chunks.add(event.bytes);
                return m.copyWith(partialAudioChunks: chunks);
              },
            );
            audioCtrl?.appendStreamChunk(event.bytes);
          } else if (event is AiToolCallDelta) {
            // Tool call detected mid-stream
            ref.read(requestStatusProvider.notifier).set(RequestStatus.awaitingTool);

            final tool = _tools.get(event.name);
            Map<String, dynamic> toolResult;
            if (tool == null) {
              toolResult = {
                'error': 'Unknown tool: ${event.name}',
                'args': event.arguments,
              };
            } else {
              if (tool.strict) {
                validateArgsAgainstSchema(
                  args: event.arguments,
                  schema: tool.parameters,
                  strict: true,
                );
              }
              toolResult = await tool.execute(event.arguments);
            }

            ref.read(chatHistoryProvider.notifier).updateById(
                  pendingMessageId,
                  (m) => m.copyWith(
                    toolCall: ToolCall(id: event.id, name: event.name, arguments: event.arguments),
                    toolResult: ToolResultMessage(toolCallId: event.id, result: toolResult),
                  ),
                );

            // Try to inject tool result into the live stream if supported
            if (_ai.supportsToolInjectionMidStream && sessionId != null) {
              try {
                await _ai.injectToolResultIntoStream(
                  sessionId: sessionId!,
                  toolCallId: event.id,
                  result: toolResult,
                );
                // After injection, continue receiving the same stream
                ref.read(requestStatusProvider.notifier).set(RequestStatus.streaming);
                return;
              } catch (_) {
                // Fallback to restart strategy if injection fails
              }
              
            }

            // Fallback: cancel current stream and restart with tool result appended

            messages.add(
              AiMessage.toolResult(toolCallId: event.id, resultJson: jsonEncode(toolResult)),
            );

            // Continue loop with new messages
            completer.complete();
          } else if (event is AiStreamError) {
            throw event.error;
          } else if (event is AiStreamDone) {
            // Finalize pending message: consolidate buffers
            final current = ref.read(chatHistoryProvider).lastWhere((m) => m.id == pendingMessageId);
            String? audioB64;
            if ((current.partialAudioChunks?.isNotEmpty ?? false)) {
              final bytes = _concatChunks(current.partialAudioChunks!);
              audioB64 = base64Encode(bytes);
              await audioCtrl?.endStreaming();
            }
            ref.read(chatHistoryProvider.notifier).updateById(
                  pendingMessageId,
                  (m) => m.copyWith(
                    isStreaming: false,
                    contentText: (m.partialTextBuffer?.isNotEmpty ?? false) ? m.partialTextBuffer : m.contentText,
                    audioBase64: audioB64 ?? m.audioBase64,
                    audioFormat: currentAudioFmt ?? m.audioFormat,
                    partialAudioChunks: null,
                  ),
                );
            completer.complete();
          }
        },
        onError: (e, st) {
          if (!completer.isCompleted) {
            completer.completeError(e, st);
          }
        },
        cancelOnError: true,
      );
                       await sub.cancel();

            await audioCtrl?.endStreaming();

      await completer.future;

      // If we completed due to a tool injection fallback, the loop continues and restarts stream.
      // Check if the last event was a full completion (no early completer.complete() before done).
      // We detect by checking the current message is no longer streaming.
      final message = ref.read(chatHistoryProvider).lastWhere((m) => m.id == pendingMessageId);
      if (!message.isStreaming) {
        // finished fully
        break;
      } else {
        // streaming still active indicates we restarted due to tool call; loop continues
        ref.read(requestStatusProvider.notifier).set(RequestStatus.streaming);
        continue;
      }
    }
  }

  Uint8List _concatChunks(List<Uint8List> parts) {
    final total = parts.fold<int>(0, (sum, b) => sum + b.length);
    final out = Uint8List(total);
    int offset = 0;
    for (final p in parts) {
      out.setAll(offset, p);
      offset += p.length;
    }
    return out;
  }

  String _audioContentTypeFromFormat(AudioFormat? fmt) {
    switch (fmt) {
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
}
enum ChatRole { system, user, assistant, tool }

enum ContentKind { text, imageBase64, audioBase64 }

enum ImageDetail { low, medium, high }

enum AudioFormat { wav, mp3, opus, flac, m4a, webm }

enum ChatModality { text, audio }

class UserContentPart {
  final ContentKind kind;
  final String data;
  final AudioFormat? audioFormat;
  final ImageDetail? imageDetail;

  const UserContentPart.text(String text)
      : kind = ContentKind.text,
        data = text,
        audioFormat = null,
        imageDetail = null;

  const UserContentPart.imageBase64({
    required String base64Data,
    this.imageDetail,
  })  : kind = ContentKind.imageBase64,
        data = base64Data,
        audioFormat = null;

  const UserContentPart.audioBase64({
    required String base64Data,
    required this.audioFormat,
  })  : kind = ContentKind.audioBase64,
        data = base64Data,
        imageDetail = null;

  Map<String, dynamic> toJson() => {
        'kind': kind.name,
        'data': data,
        'audioFormat': audioFormat?.name,
        'imageDetail': imageDetail?.name,
      };
}

class ChatTurnInput {
  final String id;
  final List<UserContentPart> parts;
  final Map<String, dynamic>? metadata;

  const ChatTurnInput({
    required this.id,
    required this.parts,
    this.metadata,
  });

  ChatTurnInput copyWith({
    String? id,
    List<UserContentPart>? parts,
    Map<String, dynamic>? metadata,
  }) =>
      ChatTurnInput(
        id: id ?? this.id,
        parts: parts ?? this.parts,
        metadata: metadata ?? this.metadata,
      );
}

class ToolCall {
  final String id;
  final String name;
  final Map<String, dynamic> arguments;

  const ToolCall({
    required this.id,
    required this.name,
    required this.arguments,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'arguments': arguments,
      };
}

class ToolResultMessage {
  final String toolCallId;
  final Map<String, dynamic> result;

  const ToolResultMessage({
    required this.toolCallId,
    required this.result,
  });

  Map<String, dynamic> toJson() => {
        'toolCallId': toolCallId,
        'result': result,
      };
}

class ChatMessageModel {
  final String id;
  final ChatRole role;
  final String? contentText;
  final String? audioBase64;
  final AudioFormat? audioFormat;
  final bool isStreaming;
  final String? partialTextBuffer;
  final List<Uint8List>? partialAudioChunks;
  final ToolCall? toolCall; // The tool request emitted by model
  final ToolResultMessage? toolResult; // The tool result we sent back
  final DateTime timestamp;
  final Map<String, dynamic>? metadata;

  const ChatMessageModel({
    required this.id,
    required this.role,
    this.contentText,
    this.audioBase64,
    this.audioFormat,
    this.isStreaming = false,
    this.partialTextBuffer,
    this.partialAudioChunks,
    this.toolCall,
    this.toolResult,
    required this.timestamp,
    this.metadata,
  });

  ChatMessageModel copyWith({
    String? id,
    ChatRole? role,
    String? contentText,
    String? audioBase64,
    AudioFormat? audioFormat,
    bool? isStreaming,
    String? partialTextBuffer,
    List<Uint8List>? partialAudioChunks,
    ToolCall? toolCall,
    ToolResultMessage? toolResult,
    DateTime? timestamp,
    Map<String, dynamic>? metadata,
  }) {
    return ChatMessageModel(
      id: id ?? this.id,
      role: role ?? this.role,
      contentText: contentText ?? this.contentText,
      audioBase64: audioBase64 ?? this.audioBase64,
      audioFormat: audioFormat ?? this.audioFormat,
      isStreaming: isStreaming ?? this.isStreaming,
      partialTextBuffer: partialTextBuffer ?? this.partialTextBuffer,
      partialAudioChunks: partialAudioChunks ?? this.partialAudioChunks,
      toolCall: toolCall ?? this.toolCall,
      toolResult: toolResult ?? this.toolResult,
      timestamp: timestamp ?? this.timestamp,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'role': role.name,
        'contentText': contentText,
        'audioBase64Len': audioBase64?.length,
        'audioFormat': audioFormat?.name,
        'isStreaming': isStreaming,
        'partialTextBufferLen': partialTextBuffer?.length,
        'partialAudioChunksCount': partialAudioChunks?.length,
        'toolCall': toolCall?.toJson(),
        'toolResult': toolResult?.toJson(),
        'timestamp': timestamp.toIso8601String(),
        'metadata': metadata,
      };
}

class ModelsConfig {
  final String textModelId;
  final String audioModelId;

  const ModelsConfig({
    this.textModelId = 'gpt-5-mini',
    this.audioModelId = 'gpt-4o-mini-audio',
  });

  ModelsConfig copyWith({
    String? textModelId,
    String? audioModelId,
  }) =>
      ModelsConfig(
        textModelId: textModelId ?? this.textModelId,
        audioModelId: audioModelId ?? this.audioModelId,
      );
}

// file: lib/core/tools.dart




// file: lib/core/ai_client.dart


class AiToolDefinition {
  final String name;
  final String description;
  final Map<String, dynamic> parameters;
  final bool strict;

  const AiToolDefinition({
    required this.name,
    required this.description,
    required this.parameters,
    this.strict = true,
  });
}

class AiMessagePart {
  final ContentKind kind;
  final String data;
  final AudioFormat? audioFormat;
  final ImageDetail? imageDetail;

  const AiMessagePart({
    required this.kind,
    required this.data,
    this.audioFormat,
    this.imageDetail,
  });
}

class AiMessage {
  final ChatRole role;
  final List<AiMessagePart>? parts; // for user messages
  final String? text; // for system/assistant/tool text
  final String? toolCallId; // for tool result messages
  final String? toolName;
  final Map<String, dynamic>? toolArguments;

  const AiMessage.user({required this.parts})
      : role = ChatRole.user,
        text = null,
        toolCallId = null,
        toolName = null,
        toolArguments = null;

  const AiMessage.system(this.text)
      : role = ChatRole.system,
        parts = null,
        toolCallId = null,
        toolName = null,
        toolArguments = null;

  const AiMessage.assistantText(this.text)
      : role = ChatRole.assistant,
        parts = null,
        toolCallId = null,
        toolName = null,
        toolArguments = null;

  const AiMessage.toolResult({
    required this.toolCallId,
    required String resultJson,
  })  : role = ChatRole.tool,
        parts = null,
        text = resultJson,
        toolName = null,
        toolArguments = null;
}

class AiRequest {
  final String model;
  final List<ChatModality> modalities;
  final List<AiMessage> messages;
  final List<AiToolDefinition>? tools;
  final String? toolChoice; // optional: 'auto', 'none', or function name
  final String? voice; // let model pick if null
  final AudioFormat? outputAudioFormat; // let model pick if null

  const AiRequest({
    required this.model,
    required this.modalities,
    required this.messages,
    this.tools,
    this.toolChoice,
    this.voice,
    this.outputAudioFormat,
  });
}

class AiToolCall {
  final String id;
  final String name;
  final Map<String, dynamic> arguments;

  const AiToolCall({
    required this.id,
    required this.name,
    required this.arguments,
  });
}

class AiResponse {
  final String? text;
  final Uint8List? audioBytes;
  final AudioFormat? audioFormat;
  final List<AiToolCall> toolCalls;
  final bool isFinal;

  const AiResponse({
    required this.text,
    required this.audioBytes,
    required this.audioFormat,
    required this.toolCalls,
    required this.isFinal,
  });
}

abstract class AiStreamEvent {}

class AiStreamStart extends AiStreamEvent {
  final String sessionId;
  AiStreamStart(this.sessionId);
}

class AiTextDelta extends AiStreamEvent {
  final String textDelta;
  AiTextDelta(this.textDelta);
}

class AiAudioChunk extends AiStreamEvent {
  final Uint8List bytes;
  final AudioFormat? format;
  AiAudioChunk(this.bytes, {this.format});
}

class AiToolCallDelta extends AiStreamEvent {
  final String id;
  final String name;
  final Map<String, dynamic> arguments;
  final bool isFinal;

  AiToolCallDelta({
    required this.id,
    required this.name,
    required this.arguments,
    this.isFinal = true,
  });
}

class AiStreamError extends AiStreamEvent {
  final Object error;
  AiStreamError(this.error);
}

class AiStreamDone extends AiStreamEvent {}

abstract class AiClient {
  bool get supportsToolInjectionMidStream;

  Future<AiResponse> createCompletion(AiRequest request);

  Stream<AiStreamEvent> createCompletionStream(AiRequest request);

  Future<void> injectToolResultIntoStream({
    required String sessionId,
    required String toolCallId,
    required Map<String, dynamic> result,
  });
}

// file: lib/core/audio.dart





class AudioPlayersController {
  final Map<String, AudioPlaybackController> _players = {};

  AudioPlaybackController ensure(String messageId) {
    return _players.putIfAbsent(messageId, () => AudioPlaybackController());
  }

  AudioPlaybackController? get(String messageId) => _players[messageId];

  Future<void> dispose(String messageId) async {
    final p = _players.remove(messageId);
    await p?.dispose();
  }

  Future<void> disposeAll() async {
    final futures = _players.values.map((p) => p.dispose());
    await Future.wait(futures);
    _players.clear();
  }
}

final audioPlayersProvider = Provider<AudioPlayersController>((ref) {
  final ctrl = AudioPlayersController();
  ref.onDispose(() => ctrl.disposeAll());
  return ctrl;
});

final aiClientProvider = Provider<AiClient>((ref) {
  throw UnimplementedError('Provide AiClient implementation via override in your app bootstrap.');
});

// file: lib/core/chat_repository.dart





// file: lib/core/sample_tools/weather_tool.dart


// file: lib/impl/your_sdk_ai_client_adapter.dart
// This adapter outlines how to connect the abstract AiClient to your concrete SDK.
// Replace the import below with your actual AI SDK package and implement the adapter accordingly.



class YourSdkAiClientAdapter implements AiClient {
  YourSdkAiClientAdapter({
    required this.createCompletionFn,
    required this.createCompletionStreamFn,
    required this.injectToolResultFn,
    this.toolInjectionSupported = false,
  });

  // Inject your SDK functions via constructor
  final Future<YourSdkResponse> Function(YourSdkRequest) createCompletionFn;
  final Stream<YourSdkStreamEvent> Function(YourSdkRequest) createCompletionStreamFn;
  final Future<void> Function({
    required String sessionId,
    required String toolCallId,
    required Map<String, dynamic> result,
  }) injectToolResultFn;

  final bool toolInjectionSupported;

  @override
  bool get supportsToolInjectionMidStream => toolInjectionSupported;

  @override
  Future<AiResponse> createCompletion(AiRequest request) async {
    final sdkReq = _mapToSdkRequest(request);
    final res = await createCompletionFn(sdkReq);

    String? text;
    Uint8List? audioBytes;
    AudioFormat? audioFmt;
    final toolCalls = <AiToolCall>[];

    // Map SDK response to AiResponse
    text = res.text;
    if (res.audioBase64 != null) {
      audioBytes = base64Decode(res.audioBase64!);
      audioFmt = _mapAudioFormat(res.audioFormat);
    }

    for (final tc in res.toolCalls) {
      toolCalls.add(AiToolCall(id: tc.id, name: tc.name, arguments: tc.arguments));
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
    final sdkReq = _mapToSdkRequest(request);
    final stream = createCompletionStreamFn(sdkReq);
    await for (final ev in stream) {
      if (ev is YourSdkStreamStart) {
        yield AiStreamStart(ev.sessionId);
      } else if (ev is YourSdkTextDelta) {
        yield AiTextDelta(ev.delta);
      } else if (ev is YourSdkAudioChunk) {
        yield AiAudioChunk(
          base64Decode(ev.base64Chunk),
          format: _mapAudioFormat(ev.format),
        );
      } else if (ev is YourSdkToolCall) {
        yield AiToolCallDelta(
          id: ev.id,
          name: ev.name,
          arguments: ev.arguments,
          isFinal: ev.isFinal,
        );
      } else if (ev is YourSdkStreamDone) {
        yield AiStreamDone();
      } else if (ev is YourSdkStreamError) {
        yield AiStreamError(ev.error);
      }
    }
  }

  @override
  Future<void> injectToolResultIntoStream({
    required String sessionId,
    required String toolCallId,
    required Map<String, dynamic> result,
  }) {
    return injectToolResultFn(
      sessionId: sessionId,
      toolCallId: toolCallId,
      result: result,
    );
  }

  // --- Mapping helpers below ---

  YourSdkRequest _mapToSdkRequest(AiRequest r) {
    return YourSdkRequest(
      model: r.model,
      wantsText: r.modalities.contains(ChatModality.text),
      wantsAudio: r.modalities.contains(ChatModality.audio),
      messages: r.messages.map(_mapToSdkMessage).toList(),
      tools: r.tools?.map(_mapToSdkTool).toList(),
      voice: r.voice,
      audioFormat: r.outputAudioFormat?.name,
    );
  }

  YourSdkMessage _mapToSdkMessage(AiMessage m) {
    switch (m.role) {
      case ChatRole.user:
        return YourSdkMessage.user(
          parts: m.parts!.map((p) {
            switch (p.kind) {
              case ContentKind.text:
                return YourSdkMessagePart.text(p.data);
              case ContentKind.imageBase64:
                return YourSdkMessagePart.imageBase64(p.data, detail: p.imageDetail?.name);
              case ContentKind.audioBase64:
                return YourSdkMessagePart.audioBase64(p.data, format: p.audioFormat?.name);
            }
          }).toList(),
        );
      case ChatRole.system:
        return YourSdkMessage.system(m.text ?? '');
      case ChatRole.assistant:
        return YourSdkMessage.assistant(m.text ?? '');
      case ChatRole.tool:
        return YourSdkMessage.tool(toolCallId: m.toolCallId!, contentJson: m.text ?? '{}');
    }
  }

  YourSdkTool _mapToSdkTool(AiToolDefinition t) {
    return YourSdkTool(
      name: t.name,
      description: t.description,
      parameters: t.parameters,
      strict: t.strict,
    );
  }

  AudioFormat? _mapAudioFormat(String? fmt) {
    switch (fmt) {
      case 'wav':
        return AudioFormat.wav;
      case 'mp3':
        return AudioFormat.mp3;
      case 'opus':
        return AudioFormat.opus;
      case 'flac':
        return AudioFormat.flac;
      case 'm4a':
        return AudioFormat.m4a;
      case 'webm':
        return AudioFormat.webm;
      default:
        return null;
    }
  }
}

// Replace below placeholders with your SDK types.
class YourSdkRequest {
  final String model;
  final bool wantsText;
  final bool wantsAudio;
  final List<YourSdkMessage> messages;
  final List<YourSdkTool>? tools;
  final String? voice;
  final String? audioFormat;

  YourSdkRequest({
    required this.model,
    required this.wantsText,
    required this.wantsAudio,
    required this.messages,
    this.tools,
    this.voice,
    this.audioFormat,
  });
}

abstract class YourSdkMessage {
  factory YourSdkMessage.user({required List<YourSdkMessagePart> parts}) = _UserMsg;
  factory YourSdkMessage.system(String content) = _SystemMsg;
  factory YourSdkMessage.assistant(String content) = _AssistantMsg;
  factory YourSdkMessage.tool({required String toolCallId, required String contentJson}) = _ToolMsg;
}

class _UserMsg implements YourSdkMessage {
  final List<YourSdkMessagePart> parts;
  _UserMsg({required this.parts});
}

class _SystemMsg implements YourSdkMessage {
  final String content;
  _SystemMsg(this.content);
}

class _AssistantMsg implements YourSdkMessage {
  final String content;
  _AssistantMsg(this.content);
}

class _ToolMsg implements YourSdkMessage {
  final String toolCallId;
  final String contentJson;
  _ToolMsg({required this.toolCallId, required this.contentJson});
}

abstract class YourSdkMessagePart {
  factory YourSdkMessagePart.text(String text) = _PartText;
  factory YourSdkMessagePart.imageBase64(String b64, {String? detail}) = _PartImage;
  factory YourSdkMessagePart.audioBase64(String b64, {String? format}) = _PartAudio;
}

class _PartText implements YourSdkMessagePart {
  final String text;
  _PartText(this.text);
}

class _PartImage implements YourSdkMessagePart {
  final String base64;
  final String? detail;
  _PartImage(this.base64, {this.detail});
}

class _PartAudio implements YourSdkMessagePart {
  final String base64;
  final String? format;
  _PartAudio(this.base64, {this.format});
}

class YourSdkTool {
  final String name;
  final String description;
  final Map<String, dynamic> parameters;
  final bool strict;

  YourSdkTool({
    required this.name,
    required this.description,
    required this.parameters,
    required this.strict,
  });
}

class YourSdkResponse {
  final String? text;
  final String? audioBase64;
  final String? audioFormat;
  final List<YourSdkToolCall> toolCalls;

  YourSdkResponse({
    this.text,
    this.audioBase64,
    this.audioFormat,
    this.toolCalls = const [],
  });
}

// class YourSdkToolCall {
//   final String id;
//   final String name;
//   final Map<String, dynamic> arguments;

//   YourSdkToolCall({required this.id, required this.name, required this.arguments});
// }

abstract class YourSdkStreamEvent {}

class YourSdkStreamStart implements YourSdkStreamEvent {
  final String sessionId;
  YourSdkStreamStart(this.sessionId);
}

class YourSdkTextDelta implements YourSdkStreamEvent {
  final String delta;
  YourSdkTextDelta(this.delta);
}

class YourSdkAudioChunk implements YourSdkStreamEvent {
  final String base64Chunk;
  final String? format;
  YourSdkAudioChunk(this.base64Chunk, {this.format});
}

class YourSdkToolCall implements YourSdkStreamEvent {
  final String id;
  final String name;
  final Map<String, dynamic> arguments;
  final bool isFinal;
  YourSdkToolCall({
    required this.id,
    required this.name,
    required this.arguments,
    this.isFinal = true,
  });
}



class YourSdkStreamDone implements YourSdkStreamEvent {}

class YourSdkStreamError implements YourSdkStreamEvent {
  final Object error;
  YourSdkStreamError(this.error);
}