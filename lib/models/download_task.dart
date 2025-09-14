// lib/data/model/download/download_task.dart
// Only the defaultOne helper is adjusted so that filename is derived from URL if not provided.

import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shortid/shortid.dart';

part 'download_task.g.dart';
part 'download_task.freezed.dart';

@freezed
abstract class DownloadTask with _$DownloadTask {
  const DownloadTask._();

  const factory DownloadTask({
    @Default('') String id,
    required String url,
    @Default(<String, String>{}) Map<String, String> urlQueryParameters,
    @Default('') String filename,
    @Default(<String, String>{}) Map<String, String> headers,
    @Default('') String directory,
    @Default(Updates.statusAndProgress) Updates updates,
    @Default(false) bool requiresWiFi,
    @Default(0) int retries,
    @Default(false) bool allowPause,
    String? metaData,
    DateTime? createdAt,
  }) = _DownloadTask;

  factory DownloadTask.fromJson(Map<String, dynamic> json) =>
      _$DownloadTaskFromJson(json);

  @override
  String toString() => 'DownloadTask($id, $url, $filename)';
}

enum Updates { none, status, statusAndProgress }

enum TaskStatus { queued, running, paused, complete, canceled, failed }

@freezed
abstract class DownloadResult with _$DownloadResult {
  const DownloadResult._();

  const factory DownloadResult({
    @Default(TaskStatus.queued) TaskStatus status,
    @Default(0.0) double progress,
    String? filePath,
    String? error,
    String? taskId,
  }) = _DownloadResult;

  factory DownloadResult.fromJson(Map<String, dynamic> json) =>
      _$DownloadResultFromJson(json);

  @override
  String toString() => 'DownloadResult($status, $progress, $filePath)';
}

extension DownloadTaskX on DownloadTask {
  static const defaultDirectory = '';

  static String _deriveFilenameFromUrl(String? url) {
    if (url == null || url.isEmpty)
      return 'file_${DateTime.now().millisecondsSinceEpoch}';
    try {
      final uri = Uri.parse(url);
      final p = uri.pathSegments.isNotEmpty ? uri.pathSegments.last : '';
      if (p.isNotEmpty) return p;
      final host = uri.host.replaceAll('.', '_');
      return '${host}_${DateTime.now().millisecondsSinceEpoch}';
    } catch (_) {
      return 'file_${DateTime.now().millisecondsSinceEpoch}';
    }
  }

  static DownloadTask defaultOne({
    String? url,
    String? filename,
    String? directory,
    Map<String, String>? headers,
    Map<String, String>? urlQueryParameters,
    Updates? updates,
    bool? requiresWiFi,
    int? retries,
    bool? allowPause,
    String? metaData,
  }) {
    final derived = _deriveFilenameFromUrl(url);
    return DownloadTask(
      id: shortid.generate(),
      url: url ?? '',
      filename: (filename != null && filename.isNotEmpty) ? filename : derived,
      directory: directory ?? defaultDirectory,
      headers: headers ?? const <String, String>{},
      urlQueryParameters: urlQueryParameters ?? const <String, String>{},
      updates: updates ?? Updates.statusAndProgress,
      requiresWiFi: requiresWiFi ?? false,
      retries: retries ?? 0,
      allowPause: allowPause ?? false,
      metaData: metaData,
      createdAt: DateTime.now(),
    );
  }
}
