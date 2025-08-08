// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_core_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ImageAttachmentImpl _$$ImageAttachmentImplFromJson(
        Map<String, dynamic> json) =>
    _$ImageAttachmentImpl(
      base64Data: json['base64Data'] as String,
      mimeType: json['mimeType'] as String? ?? 'image/jpeg',
      width: (json['width'] as num?)?.toInt(),
      height: (json['height'] as num?)?.toInt(),
      description: json['description'] as String?,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$ImageAttachmentImplToJson(
        _$ImageAttachmentImpl instance) =>
    <String, dynamic>{
      'base64Data': instance.base64Data,
      'mimeType': instance.mimeType,
      'width': instance.width,
      'height': instance.height,
      'description': instance.description,
      'runtimeType': instance.$type,
    };

_$AudioAttachmentImpl _$$AudioAttachmentImplFromJson(
        Map<String, dynamic> json) =>
    _$AudioAttachmentImpl(
      bytes: const Uint8ListBase64Converter().fromJson(json['bytes'] as String),
      duration: const DurationMsConverter()
          .fromJson((json['duration'] as num).toInt()),
      sourceType: $enumDecode(_$AudioSourceTypeEnumMap, json['sourceType']),
      format: $enumDecodeNullable(_$AudioFormatEnumMap, json['format']) ??
          AudioFormat.wav,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$AudioAttachmentImplToJson(
        _$AudioAttachmentImpl instance) =>
    <String, dynamic>{
      'bytes': const Uint8ListBase64Converter().toJson(instance.bytes),
      'duration': const DurationMsConverter().toJson(instance.duration),
      'sourceType': _$AudioSourceTypeEnumMap[instance.sourceType]!,
      'format': _$AudioFormatEnumMap[instance.format]!,
      'runtimeType': instance.$type,
    };

const _$AudioSourceTypeEnumMap = {
  AudioSourceType.recorded: 'recorded',
  AudioSourceType.picked: 'picked',
};

const _$AudioFormatEnumMap = {
  AudioFormat.wav: 'wav',
  AudioFormat.mp3: 'mp3',
};

_$FileAttachmentImpl _$$FileAttachmentImplFromJson(Map<String, dynamic> json) =>
    _$FileAttachmentImpl(
      fileName: json['fileName'] as String,
      bytes: const Uint8ListBase64Converter().fromJson(json['bytes'] as String),
      mimeType: json['mimeType'] as String? ?? 'application/octet-stream',
      size: (json['size'] as num?)?.toInt(),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$FileAttachmentImplToJson(
        _$FileAttachmentImpl instance) =>
    <String, dynamic>{
      'fileName': instance.fileName,
      'bytes': const Uint8ListBase64Converter().toJson(instance.bytes),
      'mimeType': instance.mimeType,
      'size': instance.size,
      'runtimeType': instance.$type,
    };

_$ChunkAttachmentImpl _$$ChunkAttachmentImplFromJson(
        Map<String, dynamic> json) =>
    _$ChunkAttachmentImpl(
      text: json['text'] as String,
      sourceName: json['sourceName'] as String?,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$ChunkAttachmentImplToJson(
        _$ChunkAttachmentImpl instance) =>
    <String, dynamic>{
      'text': instance.text,
      'sourceName': instance.sourceName,
      'runtimeType': instance.$type,
    };

_$UnifiedMessageImpl _$$UnifiedMessageImplFromJson(Map<String, dynamic> json) =>
    _$UnifiedMessageImpl(
      id: json['id'] as String,
      role: $enumDecode(_$MessageRoleEnumMap, json['role']),
      text: json['text'] as String?,
      attachments: (json['attachments'] as List<dynamic>?)
              ?.map((e) => Attachment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <Attachment>[],
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
      isEdited: json['isEdited'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$UnifiedMessageImplToJson(
        _$UnifiedMessageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'role': _$MessageRoleEnumMap[instance.role]!,
      'text': instance.text,
      'attachments': instance.attachments,
      'metadata': instance.metadata,
      'isEdited': instance.isEdited,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$MessageRoleEnumMap = {
  MessageRole.system: 'system',
  MessageRole.user: 'user',
  MessageRole.assistant: 'assistant',
  MessageRole.tool: 'tool',
};

_$SessionImpl _$$SessionImplFromJson(Map<String, dynamic> json) =>
    _$SessionImpl(
      id: json['id'] as String,
      title: json['title'] as String? ?? 'New Chat',
      description: json['description'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      messages: (json['messages'] as List<dynamic>?)
              ?.map((e) => UnifiedMessage.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <UnifiedMessage>[],
      config: json['config'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$SessionImplToJson(_$SessionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'messages': instance.messages,
      'config': instance.config,
    };
