// lib/core/ai_core_models.dart
import 'dart:convert';
import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_core_models.freezed.dart';
part 'ai_core_models.g.dart';

enum MessageRole {
  system,
  user,
  assistant,
  tool,
}

enum AudioSourceType {
  recorded,
  picked,
}

enum AudioFormat {
  wav('audio/wav'),
  mp3('audio/mpeg');

  final String mimeType;
  const AudioFormat(this.mimeType);

  static AudioFormat fromMime(String mime) {
    switch (mime.toLowerCase()) {
      case 'audio/wav':
      case 'audio/x-wav':
        return AudioFormat.wav;
      case 'audio/mpeg':
      case 'audio/mp3':
        return AudioFormat.mp3;
      case 'audio/mp4':
      case 'audio/aac':
      default:
        return AudioFormat.wav;
    }
  }
}

class Uint8ListBase64Converter implements JsonConverter<Uint8List, String> {
  const Uint8ListBase64Converter();
  @override
  Uint8List fromJson(String json) => base64Decode(json);
  @override
  String toJson(Uint8List object) => base64Encode(object);
}

class DurationMsConverter implements JsonConverter<Duration, int> {
  const DurationMsConverter();
  @override
  Duration fromJson(int json) => Duration(milliseconds: json);
  @override
  int toJson(Duration object) => object.inMilliseconds;
}

@freezed
sealed class Attachment with _$Attachment {
  const Attachment._();

  const factory Attachment.image({
    required String base64Data,
    @Default('image/jpeg') String mimeType,
    int? width,
    int? height,
    String? description,
  }) = ImageAttachment;

  const factory Attachment.audio({
    @Uint8ListBase64Converter() required Uint8List bytes,
    @DurationMsConverter() required Duration duration,
    required AudioSourceType sourceType,
    @Default(AudioFormat.wav) AudioFormat format,
  }) = AudioAttachment;

  const factory Attachment.file({
    required String fileName,
    @Uint8ListBase64Converter() required Uint8List bytes,
    @Default('application/octet-stream') String mimeType,
    int? size,
  }) = FileAttachment;

  const factory Attachment.chunk({
    required String text,
    String? sourceName,
  }) = ChunkAttachment;

  factory Attachment.fromJson(Map<String, dynamic> json) =>
      _$AttachmentFromJson(json);
}

@freezed
class UnifiedMessage with _$UnifiedMessage {
  const UnifiedMessage._();

  const factory UnifiedMessage({
    required String id,
    required MessageRole role,
    String? text,
    @Default(<Attachment>[]) List<Attachment> attachments,
    @Default({}) Map<String, dynamic> metadata,
    @Default(false) bool isEdited,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _UnifiedMessage;

  factory UnifiedMessage.fromJson(Map<String, dynamic> json) =>
      _$UnifiedMessageFromJson(json);

  bool get hasContent =>
      (text != null && text!.trim().isNotEmpty) || attachments.isNotEmpty;
}

@freezed
class Session with _$Session {
  const Session._();

  const factory Session({
    required String id,
    @Default('New Chat') String title,
    String? description,
    required DateTime createdAt,
    DateTime? updatedAt,
    @Default(<UnifiedMessage>[]) List<UnifiedMessage> messages,
    // Optional per-session config surface
    @Default({}) Map<String, dynamic> config,
  }) = _Session;

  factory Session.fromJson(Map<String, dynamic> json) =>
      _$SessionFromJson(json);

  int get messageCount => messages.length;
  UnifiedMessage? get lastMessage =>
      messages.isEmpty ? null : messages.last;
}