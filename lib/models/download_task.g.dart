// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download_task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DownloadTask _$DownloadTaskFromJson(Map<String, dynamic> json) =>
    _DownloadTask(
      id: json['id'] as String? ?? '',
      url: json['url'] as String,
      urlQueryParameters:
          (json['urlQueryParameters'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const <String, String>{},
      filename: json['filename'] as String? ?? '',
      headers:
          (json['headers'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const <String, String>{},
      directory: json['directory'] as String? ?? '',
      updates:
          $enumDecodeNullable(_$UpdatesEnumMap, json['updates']) ??
          Updates.statusAndProgress,
      requiresWiFi: json['requiresWiFi'] as bool? ?? false,
      retries: (json['retries'] as num?)?.toInt() ?? 0,
      allowPause: json['allowPause'] as bool? ?? false,
      metaData: json['metaData'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$DownloadTaskToJson(_DownloadTask instance) =>
    <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'urlQueryParameters': instance.urlQueryParameters,
      'filename': instance.filename,
      'headers': instance.headers,
      'directory': instance.directory,
      'updates': _$UpdatesEnumMap[instance.updates]!,
      'requiresWiFi': instance.requiresWiFi,
      'retries': instance.retries,
      'allowPause': instance.allowPause,
      'metaData': instance.metaData,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

const _$UpdatesEnumMap = {
  Updates.none: 'none',
  Updates.status: 'status',
  Updates.statusAndProgress: 'statusAndProgress',
};

_DownloadResult _$DownloadResultFromJson(Map<String, dynamic> json) =>
    _DownloadResult(
      status:
          $enumDecodeNullable(_$TaskStatusEnumMap, json['status']) ??
          TaskStatus.queued,
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
      filePath: json['filePath'] as String?,
      error: json['error'] as String?,
      taskId: json['taskId'] as String?,
    );

Map<String, dynamic> _$DownloadResultToJson(_DownloadResult instance) =>
    <String, dynamic>{
      'status': _$TaskStatusEnumMap[instance.status]!,
      'progress': instance.progress,
      'filePath': instance.filePath,
      'error': instance.error,
      'taskId': instance.taskId,
    };

const _$TaskStatusEnumMap = {
  TaskStatus.queued: 'queued',
  TaskStatus.running: 'running',
  TaskStatus.paused: 'paused',
  TaskStatus.complete: 'complete',
  TaskStatus.canceled: 'canceled',
  TaskStatus.failed: 'failed',
};
