// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************


Map<String, dynamic> _$SessionStateToJson(SessionState instance) =>
    <String, dynamic>{
      'sessionId': instance.sessionId,
      'associatedProjectId': instance.associatedProjectId,
      'displayHistory': instance.displayHistory.map((e) => e.toJson()).toList(),
      'apiHistory': const ContentConverter().toJson(instance.apiHistory),
      'attachedFilePaths': instance.attachedFilePaths,
      'customKnowledge': instance.customKnowledge,
    };

_$UserMessageEventImpl _$$UserMessageEventImplFromJson(
        Map<String, dynamic> json) =>
    _$UserMessageEventImpl(
      text: json['text'] as String,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$UserMessageEventImplToJson(
        _$UserMessageEventImpl instance) =>
    <String, dynamic>{
      'text': instance.text,
      'runtimeType': instance.$type,
    };

_$AiResponseMessageEventImpl _$$AiResponseMessageEventImplFromJson(
        Map<String, dynamic> json) =>
    _$AiResponseMessageEventImpl(
      markdownText: json['markdownText'] as String,
      isError: json['isError'] as bool? ?? false,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$AiResponseMessageEventImplToJson(
        _$AiResponseMessageEventImpl instance) =>
    <String, dynamic>{
      'markdownText': instance.markdownText,
      'isError': instance.isError,
      'runtimeType': instance.$type,
    };

_$FileAttachmentEventImpl _$$FileAttachmentEventImplFromJson(
        Map<String, dynamic> json) =>
    _$FileAttachmentEventImpl(
      fileName: json['fileName'] as String,
      filePath: json['filePath'] as String,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$FileAttachmentEventImplToJson(
        _$FileAttachmentEventImpl instance) =>
    <String, dynamic>{
      'fileName': instance.fileName,
      'filePath': instance.filePath,
      'runtimeType': instance.$type,
    };

_$ToolCallEventImpl _$$ToolCallEventImplFromJson(Map<String, dynamic> json) =>
    _$ToolCallEventImpl(
      toolName: json['toolName'] as String,
      args: json['args'] as Map<String, dynamic>,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$ToolCallEventImplToJson(_$ToolCallEventImpl instance) =>
    <String, dynamic>{
      'toolName': instance.toolName,
      'args': instance.args,
      'runtimeType': instance.$type,
    };

_$ToolResultEventImpl _$$ToolResultEventImplFromJson(
        Map<String, dynamic> json) =>
    _$ToolResultEventImpl(
      toolName: json['toolName'] as String,
      result: json['result'] as String,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$ToolResultEventImplToJson(
        _$ToolResultEventImpl instance) =>
    <String, dynamic>{
      'toolName': instance.toolName,
      'result': instance.result,
      'runtimeType': instance.$type,
    };

_$SessionStateImpl _$$SessionStateImplFromJson(Map<String, dynamic> json) =>
    _$SessionStateImpl(
      sessionId: json['sessionId'] as String,
      associatedProjectId: json['associatedProjectId'] as String,
      displayHistory: (json['displayHistory'] as List<dynamic>)
          .map((e) => SessionEvent.fromJson(e as Map<String, dynamic>))
          .toList(),
      apiHistory: json['apiHistory'] == null
          ? const []
          : const ContentConverter().fromJson(json['apiHistory'] as List),
      attachedFilePaths:
          (json['attachedFilePaths'] as Map<String, dynamic>?)?.map(
                (k, e) => MapEntry(k, e as String),
              ) ??
              const {},
      customKnowledge: json['customKnowledge'] as String? ?? '',
    );

Map<String, dynamic> _$$SessionStateImplToJson(_$SessionStateImpl instance) =>
    <String, dynamic>{
      'sessionId': instance.sessionId,
      'associatedProjectId': instance.associatedProjectId,
      'displayHistory': instance.displayHistory,
      'apiHistory': const ContentConverter().toJson(instance.apiHistory),
      'attachedFilePaths': instance.attachedFilePaths,
      'customKnowledge': instance.customKnowledge,
    };
