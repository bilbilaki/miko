import 'dart:convert';
import 'dart:typed_data';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:path/path.dart';

part 'session_models.freezed.dart';
part 'session_models.g.dart';

// --- Custom JSON Converter for Content ---
// This is crucial for saving/loading chat history (List<Content>)
class ContentConverter implements JsonConverter<List<Content>, List<dynamic>> {
  const ContentConverter();

  @override
  List<Content> fromJson(List<dynamic> json) {
    return json.map((e) {
      final Map<String, dynamic> contentMap = e as Map<String, dynamic>;
      final role = contentMap['role'] as String?;
      final List<Part> parts = (contentMap['parts'] as List<dynamic>)
          .map((p) {
            final partMap = p as Map<String, dynamic>;
            if (partMap.containsKey('text')) {
              return TextPart(partMap['text'] as String);
            } else if (partMap.containsKey('inlineData')) {
              final inlineData = partMap['inlineData'] as Map<String, dynamic>;
              return DataPart(
                inlineData['mimeType'] as String,
                base64Decode(inlineData['data'] as String),
              );
            }
            throw FormatException('Unknown part type: $partMap');
          })
          .toList();
      return Content(role ?? 'user', parts); // Assuming Content constructor is Content(String role, List<Part> parts)
    }).toList();
  }

  @override
  List<dynamic> toJson(List<Content> object) {
    return object.map((content) {
      return {
        'role': content.role,
        'parts': content.parts.map((part) {
          if (part is TextPart) {
            return {'text': part.text};
          } else if (part is DataPart) {
            return {
              'inlineData': {
                'mimeType': part.mimeType,
                'data': base64Encode(part.bytes),
              }
            };
          }
          throw FormatException('Unknown part type: $part');
        }).toList(),
      };
    }).toList();
  }
}

// --- Session Events ---
@freezed
sealed class SessionEvent with _$SessionEvent {
  const factory SessionEvent.userMessage({required String text}) = UserMessageEvent;
  const factory SessionEvent.aiResponse({required String markdownText, @Default(false) bool isError}) = AiResponseMessageEvent;
  const factory SessionEvent.fileAttachment({required String fileName, required String filePath}) = FileAttachmentEvent; // Use file path for now
  const factory SessionEvent.toolCall({required String toolName, required Map<String, dynamic> args}) = ToolCallEvent;
  const factory SessionEvent.toolResult({required String toolName, required String result}) = ToolResultEvent;

  factory SessionEvent.fromJson(Map<String, dynamic> json) => _$SessionEventFromJson(json);
}

// --- Session State ---
@freezed
@JsonSerializable(explicitToJson: true)
class SessionState with _$SessionState {
  const factory SessionState({
    required String sessionId,
    required String associatedProjectId,
    required List<SessionEvent> displayHistory,
    // Use the custom converter for JSON serialization/deserialization of chat history
    @ContentConverter() @Default([]) List<Content> apiHistory,
    @Default({}) Map<String, String> attachedFilePaths, // Store paths, not bytes
    @Default('') String customKnowledge,
  }) = _SessionState;

  factory SessionState.fromJson(Map<String, dynamic> json) => _$SessionStateFromJson(json);
  Map<String, dynamic> toJson() => _$$SessionStateImplToJson(_$SessionStateImpl.fromJson(json as Map<String, dynamic>));
}