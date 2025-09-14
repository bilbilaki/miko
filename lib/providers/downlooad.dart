// lib/providers/download_provider.dart
// Updated DownloadRecord to include createdAt and provider initialization to read createdAt
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miko/download/download.dart';
import 'package:miko/models/download.dart';
import 'package:miko/models/download_task.dart';

class TaskNotification {
  final String titleTemplate;
  final String bodyTemplate;

  const TaskNotification(this.titleTemplate, this.bodyTemplate);

  String _interpolate(
    String template,
    DownloadTask task, {
    String? subDirPath,
  }) {
    return template
        .replaceAll('{filename}', task.filename)
        .replaceAll('{url}', task.url)
        .replaceAll('{taskId}', task.id)
        .replaceAll('{subDirPath}', subDirPath ?? '');
  }

  String titleFor(DownloadTask task, {String? subDirPath}) =>
      _interpolate(titleTemplate, task, subDirPath: subDirPath);

  String bodyFor(DownloadTask task, {String? subDirPath}) =>
      _interpolate(bodyTemplate, task, subDirPath: subDirPath);
}

class DownloadRecord {
  final String taskId;
  TaskStatus status;
  double progress;
  int? expectedFileSize;
  String? subDirPath;
  String? error;
  final DownloadTask? task;
  final DateTime createdAt;
  DateTime updatedAt;

  DownloadRecord({
    required this.taskId,
    this.status = TaskStatus.queued,
    this.progress = 0.0,
    this.expectedFileSize,
    this.subDirPath,
    this.error,
    this.task,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  void updateStatus(
    TaskStatus s, {
    String? subDirPath,
    String? error,
    int? expectedFileSize,
  }) {
    status = s;
    this.subDirPath = subDirPath ?? this.subDirPath;
    this.error = error ?? this.error;
    this.expectedFileSize = expectedFileSize ?? this.expectedFileSize;
    updatedAt = DateTime.now();
  }

  void updateProgress(double p) {
    progress = p;
    updatedAt = DateTime.now();
  }
}

final fileDownloaderProvider = Provider<FileDownloader>((ref) {
  final fd = FileDownloader();
  ref.onDispose(() {
    fd.shutdown();
  });
  return fd;
});

class DownloadNotifier extends StateNotifier<Map<String, DownloadRecord>> {
  final Ref ref;
  late final FileDownloader _downloader;
  StreamSubscription<TaskUpdate>? _sub;

  TaskNotification? _runningNotification;
  TaskNotification? _completeNotification;
  bool _progressBarEnabled = false;

  DownloadNotifier(this.ref) : super({}) {
    _init();
  }

  Future<void> _init() async {
    await DownloadStore.instance.init();
    _downloader = ref.read(fileDownloaderProvider);

    final raw = await DownloadStore.instance.fetchAllRaw();
    // prime state
    for (final entry in raw.entries) {
      final id = entry.key;
      final map = entry.value;
      final taskMap = map['task'];
      if (taskMap == null) continue;
      try {
        final task = DownloadTask.fromJson(Map<String, dynamic>.from(taskMap));
        final statusStr = map['status'] as String? ?? TaskStatus.queued.name;
        final status = TaskStatus.values.firstWhere(
          (e) => e.name == statusStr,
          orElse: () => TaskStatus.queued,
        );
        final progress = (map['progress'] as num?)?.toDouble() ?? 0.0;
        final expected = map['expectedFileSize'] as int?;
        final createdAtMillis = map['createdAt'] as int?;
        final createdAt = createdAtMillis != null
            ? DateTime.fromMillisecondsSinceEpoch(createdAtMillis)
            : (task.createdAt ?? DateTime.now());
        final rec = DownloadRecord(
          taskId: id,
          status: status,
          progress: progress,
          expectedFileSize: expected,
          subDirPath: map['filePath'] as String?,
          error: map['error'] as String?,
          task: task,
          createdAt: createdAt,
          updatedAt: DateTime.now(),
        );
        state = {...state, id: rec};
      } catch (_) {
        continue;
      }
    }

    await _downloader.start();

    _sub = _downloader.updates.listen(
      (update) {
        if (update is TaskStatusUpdate) {
          final id = update.taskId;
          final existing = state[id];
          final rec =
              existing ??
              DownloadRecord(taskId: id, task: null, createdAt: DateTime.now());
          rec.updateStatus(
            update.status,
            subDirPath: update.filePath,
            error: update.error,
            expectedFileSize: update.expectedFileSize,
          );
          state = {...state, id: rec};
          _handleNotificationForStatus(rec);
        } else if (update is TaskProgressUpdate) {
          final id = update.taskId;
          final existing = state[id];
          final rec =
              existing ??
              DownloadRecord(taskId: id, task: null, createdAt: DateTime.now());
          rec.updateProgress(update.progress);
          state = {...state, id: rec};
        }
      },
      onError: (e) {
        // swallow
      },
    );
  }

  Future<DownloadResult> download(
    DownloadTask task, {
    void Function(double progress)? onProgress,
    void Function(TaskStatus status)? onStatus,
  }) => _downloader.download(task, onProgress: onProgress, onStatus: onStatus);

  Future<bool> enqueue(DownloadTask task) => _downloader.enqueue(task);

  Future<void> enqueueAll(List<DownloadTask> tasks) =>
      _downloader.enqueueAll(tasks);

  bool pause(String taskId) => _downloader.pause(taskId);

  Future<bool> resume(String taskId) => _downloader.resume(taskId);

  bool cancel(String taskId) => _downloader.cancel(taskId);

  Future<bool> deleteCompletely(String taskId, {bool deleteFile = true}) =>
      _downloader.deleteTaskCompletely(taskId, deleteFile: deleteFile);

  void configureNotification({
    TaskNotification? running,
    TaskNotification? complete,
    bool progressBar = false,
  }) {
    _runningNotification = running;
    _completeNotification = complete;
    _progressBarEnabled = progressBar;
  }

  List<DownloadRecord> snapshotRecords() =>
      state.values.toList(growable: false);

  DownloadRecord? snapshotRecordForId(String id) => state[id];

  void _handleNotificationForStatus(DownloadRecord record) {
    final task = record.task;
    if (task == null) return;
    switch (record.status) {
      case TaskStatus.running:
        if (_runningNotification != null) {
          _showNotification(
            title: _runningNotification!.titleFor(
              task,
              subDirPath: record.subDirPath,
            ),
            body: _runningNotification!.bodyFor(
              task,
              subDirPath: record.subDirPath,
            ),
            progress: _progressBarEnabled ? record.progress : null,
          );
        }
        break;
      case TaskStatus.complete:
        if (_completeNotification != null) {
          _showNotification(
            title: _completeNotification!.titleFor(
              task,
              subDirPath: record.subDirPath,
            ),
            body: _completeNotification!.bodyFor(
              task,
              subDirPath: record.subDirPath,
            ),
            progress: null,
          );
        }
        break;
      default:
        break;
    }
  }

  void _showNotification({
    required String title,
    required String body,
    double? progress,
  }) {
    if (kDebugMode) {
      if (progress != null) {
        debugPrint(
          '[DownloadNotifier Notification] $title - $body (${(progress * 100).toStringAsFixed(1)}%)',
        );
      } else {
        debugPrint('[DownloadNotifier Notification] $title - $body');
      }
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}

final downloadNotifierProvider =
    StateNotifierProvider<DownloadNotifier, Map<String, DownloadRecord>>((ref) {
      return DownloadNotifier(ref);
    });
