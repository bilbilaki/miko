// lib/services/file_downloader.dart
// Modified to use DownloadStore.putTask/updateStatus and avoid re-enqueueing completed tasks.
// Also won't delete partial file on shutdown; explicit delete operation should be used to remove file.

import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:miko/models/download.dart';
import 'package:miko/models/download_task.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shortid/shortid.dart';

abstract class TaskUpdate {}

class TaskStatusUpdate extends TaskUpdate {
  final String taskId;
  final TaskStatus status;
  final String? filePath;
  final String? error;
  final int? expectedFileSize;

  TaskStatusUpdate({
    required this.taskId,
    required this.status,
    this.filePath,
    this.error,
    this.expectedFileSize,
  });
}

class TaskProgressUpdate extends TaskUpdate {
  final String taskId;
  final double progress;

  TaskProgressUpdate({required this.taskId, required this.progress});
}

final class FileDownloader {
  FileDownloader._internal();
  static final FileDownloader _instance = FileDownloader._internal();
  factory FileDownloader() => _instance;

  final StreamController<TaskUpdate> _updates =
      StreamController<TaskUpdate>.broadcast();
  Stream<TaskUpdate> get updates => _updates.stream;

  final Queue<DownloadTask> _queue = Queue<DownloadTask>();
  final Map<String, _ActiveTask> _active = {};
  int concurrency = 3;
  bool _started = false;
  final DownloadStore _store = DownloadStore.instance;

  Future<void> start() async {
    if (_started) return;
    _started = true;
    await _store.init();
    final raw = await _store.fetchAllRaw();
    for (final entry in raw.entries) {
      final id = entry.key;
      final map = entry.value;
      final statusStr = map['status'] as String? ?? TaskStatus.queued.name;
      final status = TaskStatus.values.firstWhere(
        (e) => e.name == statusStr,
        orElse: () => TaskStatus.queued,
      );
      if (status == TaskStatus.complete) {
        // don't re-enqueue completed tasks
        // still emit a complete status so UI can load initial state from store
        final filePath = map['filePath'] as String?;
        _updates.add(
          TaskStatusUpdate(
            taskId: id,
            status: TaskStatus.complete,
            filePath: filePath,
          ),
        );
        continue;
      }
      final taskMap = map['task'];
      if (taskMap == null) continue;
      try {
        final task = DownloadTask.fromJson(Map<String, dynamic>.from(taskMap));
        // ensure filename is filled
        final finalTask = task.filename.isEmpty
            ? task.copyWith(filename: _deriveFilenameFromUrl(task.url))
            : task;
        // store updated info
        await _store.putTask(
          finalTask,
          status: status,
          progress: (map['progress'] as num?)?.toDouble() ?? 0.0,
          filePath: map['filePath'] as String?,
          expectedFileSize: map['expectedFileSize'] as int?,
        );
        _enqueueInternal(finalTask);
      } catch (_) {
        continue;
      }
    }
    _schedule();
  }

  void stop() {
    _started = false;
  }

  Future<void> shutdown({bool cancelActive = true}) async {
    _started = false;
    if (cancelActive) {
      final ids = _active.keys.toList();
      for (final id in ids) {
        // Cancel but do NOT remove partial files — preserve for restart/resume.
        final active = _active[id];
        if (active != null) {
          active.canceled = true;
          _signalCancelActive(
            active,
            statusAfterCancel: TaskStatus.paused,
            deletePartial: false,
          );
        }
      }
    }
    await _updates.close();
  }

  Future<DownloadResult> download(
    DownloadTask task, {
    void Function(double progress)? onProgress,
    void Function(TaskStatus status)? onStatus,
  }) async {
    final id = task.id.isEmpty ? shortid.generate() : task.id;
    final t = task.copyWith(
      id: id,
      createdAt: task.createdAt ?? DateTime.now(),
    );
    // do not persist in one-shot
    return _performDownloadSingle(
      t,
      onProgress: onProgress,
      onStatus: onStatus,
    );
  }

  Future<bool> enqueue(DownloadTask task) async {
    final id = task.id.isEmpty ? shortid.generate() : task.id;
    var t = task.copyWith(id: id, createdAt: task.createdAt ?? DateTime.now());
    if (t.filename.isEmpty) {
      t = t.copyWith(filename: _deriveFilenameFromUrl(t.url));
    }
    // persist with queued status
    await _store.putTask(t, status: TaskStatus.queued, progress: 0.0);
    final added = _enqueueInternal(t);
    if (added) _schedule();
    return added;
  }

  Future<void> enqueueAll(List<DownloadTask> tasks) async {
    for (final task in tasks) {
      await enqueue(task);
    }
  }

  bool pause(String taskId) {
    final active = _active[taskId];
    if (active == null) {
      // if queued, mark as paused in store
      unawaited(_store.updateStatus(taskId, status: TaskStatus.paused));
      _updates.add(TaskStatusUpdate(taskId: taskId, status: TaskStatus.paused));
      return true;
    }
    if (!active.task.allowPause) return false;
    active.paused = true;
    _signalCancelActive(
      active,
      statusAfterCancel: TaskStatus.paused,
      deletePartial: false,
    );
    return true;
  }

  Future<bool> resume(String taskId) async {
    final stored = await _store.fetch(taskId);
    if (stored == null) return false;
    final t = stored.copyWith(createdAt: stored.createdAt ?? DateTime.now());
    await _store.putTask(t, status: TaskStatus.queued, progress: 0.0);
    _enqueueInternal(t);
    _schedule();
    return true;
  }

  bool cancel(String taskId) {
    final active = _active[taskId];
    if (active != null) {
      active.canceled = true;
      // cancel but keep partial file — caller can explicitly delete afterward
      _signalCancelActive(
        active,
        statusAfterCancel: TaskStatus.canceled,
        deletePartial: false,
      );
      unawaited(_store.updateStatus(taskId, status: TaskStatus.canceled));
      _updates.add(
        TaskStatusUpdate(taskId: taskId, status: TaskStatus.canceled),
      );
      return true;
    } else {
      // if queued, remove from queue and mark canceled in store
      final initialLength = _queue.length;
      _queue.removeWhere((t) => t.id == taskId);
      final removed = initialLength != _queue.length;
      unawaited(_store.updateStatus(taskId, status: TaskStatus.canceled));
      _updates.add(
        TaskStatusUpdate(taskId: taskId, status: TaskStatus.canceled),
      );
      return removed;
    }
  }

  /// Deletes persisted task and optionally deletes file on disk (if filePath present).
  /// caller should ensure UI confirms deletion.
  Future<bool> deleteTaskCompletely(
    String taskId, {
    bool deleteFile = true,
  }) async {
    final raw = await _store.fetchAllRaw();
    final entry = raw[taskId];
    final filePath = entry?['filePath'] as String?;
    // cancel if active
    final active = _active[taskId];
    if (active != null) {
      active.canceled = true;
      _signalCancelActive(
        active,
        statusAfterCancel: TaskStatus.canceled,
        deletePartial: false,
      );
    }
    // remove from queue if present
    _queue.removeWhere((t) => t.id == taskId);
    final deletedFromStore = await _store.delete(taskId);
    if (deleteFile && filePath != null && filePath.isNotEmpty) {
      try {
        final f = File(filePath);
        if (await f.exists()) await f.delete();
      } catch (_) {}
    }
    return deletedFromStore;
  }

  bool _enqueueInternal(DownloadTask task) {
    if (_active.containsKey(task.id)) return false;
    if (_queue.any((t) => t.id == task.id)) return false;
    _queue.add(task);
    _updates.add(TaskStatusUpdate(taskId: task.id, status: TaskStatus.queued));
    unawaited(
      _store.updateStatus(task.id, status: TaskStatus.queued, progress: 0.0),
    );
    return true;
  }

  void _schedule() {
    if (!_started) return;
    while (_active.length < concurrency && _queue.isNotEmpty) {
      final next = _queue.removeFirst();
      _startBackgroundDownload(next);
    }
  }

  void _startBackgroundDownload(DownloadTask task) {
    final worker = _ActiveTask(task: task);
    _active[task.id] = worker;
    _updates.add(TaskStatusUpdate(taskId: task.id, status: TaskStatus.running));
    unawaited(_store.updateStatus(task.id, status: TaskStatus.running));
    unawaited(
      _backgroundDownloadWorker(worker).whenComplete(() {
        _active.remove(task.id);
        _schedule();
      }),
    );
  }

  Future<void> _backgroundDownloadWorker(_ActiveTask worker) async {
    final task = worker.task;
    try {
      final res = await _performDownloadSingle(
        task,
        onProgress: (p) async {
          _updates.add(TaskProgressUpdate(taskId: task.id, progress: p));
          await _store.updateStatus(task.id, progress: p);
        },
        onStatus: (status) async {
          _updates.add(TaskStatusUpdate(taskId: task.id, status: status));
          await _store.updateStatus(task.id, status: status);
        },
        activeTracker: worker,
      );

      if (res.status == TaskStatus.complete) {
        await _store.updateStatus(
          task.id,
          status: TaskStatus.complete,
          progress: 1.0,
          filePath: res.filePath,
          expectedFileSize: null,
        );
        _updates.add(
          TaskStatusUpdate(
            taskId: task.id,
            status: TaskStatus.complete,
            filePath: res.filePath,
          ),
        );
      } else {
        // final non-complete state handled already by callbacks, ensure stored
        await _store.updateStatus(
          task.id,
          status: res.status,
          progress: res.progress,
          filePath: res.filePath,
        );
        _updates.add(
          TaskStatusUpdate(
            taskId: task.id,
            status: res.status,
            error: res.error,
          ),
        );
      }
    } catch (e) {
      _updates.add(
        TaskStatusUpdate(
          taskId: task.id,
          status: TaskStatus.failed,
          error: e.toString(),
        ),
      );
      await _store.updateStatus(task.id, status: TaskStatus.failed);
    }
  }

  Future<DownloadResult> _performDownloadSingle(
    DownloadTask task, {
    void Function(double progress)? onProgress,
    void Function(TaskStatus status)? onStatus,
    _ActiveTask? activeTracker,
  }) async {
    final maxRetries = task.retries;
    var attempt = 0;
    while (true) {
      attempt++;
      if (activeTracker?.canceled == true) {
        onStatus?.call(TaskStatus.canceled);
        return DownloadResult(
          status: TaskStatus.canceled,
          progress: 0.0,
          taskId: task.id,
        );
      }

      final client = HttpClient();
      if (activeTracker != null) activeTracker.client = client;

      HttpClientRequest? request;
      HttpClientResponse? response;
      File? file;
      IOSink? sink;
      StreamSubscription<List<int>>? subscription;
      try {
        onStatus?.call(TaskStatus.running);
        final uri = Uri.parse(task.url);
        request = await client.getUrl(uri);

        // headers
        task.headers.forEach((k, v) {
          if (k.isNotEmpty) request!.headers.set(k, v);
        });

        response = await request.close();
        if (response.statusCode >= 400) {
          throw HttpException(
            'HTTP ${response.statusCode} for ${uri.toString()}',
          );
        }

        final targetDir = await _getTargetDirectory(task.directory);
        await targetDir.create(recursive: true);
        final filename = task.filename.isNotEmpty
            ? task.filename
            : _deriveFilenameFromUrl(task.url);
        final filePath = p.join(targetDir.path, filename);
        file = File(filePath);
        sink = file.openWrite(
          mode: FileMode.append,
        ); // append to preserve partials if present

        final contentLength = response.contentLength;
        if (contentLength != null && contentLength > 0) {
          _updates.add(
            TaskStatusUpdate(
              taskId: task.id,
              status: TaskStatus.running,
              expectedFileSize: contentLength,
            ),
          );
          unawaited(
            _store.updateStatus(
              task.id,
              status: TaskStatus.running,
              expectedFileSize: contentLength,
            ),
          );
        } else {
          _updates.add(
            TaskStatusUpdate(taskId: task.id, status: TaskStatus.running),
          );
          unawaited(_store.updateStatus(task.id, status: TaskStatus.running));
        }

        // If file already exists and has length, attempt a ranged resume if server supports it.
        var existingLength = 0;
        try {
          if (await file.exists()) {
            existingLength = await file.length();
          }
        } catch (_) {
          existingLength = 0;
        }

        // If server supports ranges and we have existingLength > 0 we should request Range header.
        // NOTE: Full robust resumable implementation requires server Range support and re-request logic.
        // For now we attempt a naive approach: if existingLength > 0 and response is providing full content,
        // we will append the response body. This is not guaranteed to resume correctly; a full resume needs
        // HEAD request and Range header. Implementing that fully is out-of-scope here, but we avoid deleting
        // partial file so at least the partial content is preserved across restarts.
        var downloaded = existingLength;
        final completer = Completer<void>();

        subscription = response.listen(
          (chunk) {
            if ((activeTracker?.canceled ?? false) ||
                (activeTracker?.paused ?? false)) {
              subscription?.cancel();
              return;
            }
            downloaded += chunk.length;
            sink?.add(chunk);
            if (contentLength > 0) {
              final progress = (downloaded / contentLength).clamp(0.0, 1.0);
              onProgress?.call(progress);
              _updates.add(
                TaskProgressUpdate(taskId: task.id, progress: progress),
              );
            } else {
              // unknown content length: emit progress=0.0 (UI will show percent only if expectedFileSize present)
              onProgress?.call(0.0);
            }
          },
          onError: (e) {
            if (!completer.isCompleted) completer.completeError(e);
          },
          onDone: () {
            if (!completer.isCompleted) completer.complete();
          },
          cancelOnError: true,
        );

        if (activeTracker != null) {
          activeTracker.sub = subscription;
          activeTracker.sink = sink;
          activeTracker.file = file;
        }

        try {
          await completer.future;
        } catch (e) {
          rethrow;
        } finally {
          try {
            await sink?.flush();
            await sink?.close();
          } catch (_) {}
        }

        if (activeTracker?.paused == true) {
          onStatus?.call(TaskStatus.paused);
          _updates.add(
            TaskStatusUpdate(taskId: task.id, status: TaskStatus.paused),
          );
          return DownloadResult(
            status: TaskStatus.paused,
            progress: 0.0,
            taskId: task.id,
          );
        }

        if (activeTracker?.canceled == true) {
          onStatus?.call(TaskStatus.canceled);
          _updates.add(
            TaskStatusUpdate(taskId: task.id, status: TaskStatus.canceled),
          );
          return DownloadResult(
            status: TaskStatus.canceled,
            progress: 0.0,
            taskId: task.id,
          );
        }

        onProgress?.call(1.0);
        onStatus?.call(TaskStatus.complete);
        return DownloadResult(
          status: TaskStatus.complete,
          progress: 1.0,
          filePath: file?.path,
          taskId: task.id,
        );
      } catch (e) {
        try {
          await subscription?.cancel();
        } catch (_) {}
        try {
          await sink?.close();
        } catch (_) {}
        try {
          await request?.flush();
        } catch (_) {}
        try {
          client.close(force: true);
        } catch (_) {}

        final isLastAttempt = attempt > maxRetries;
        if (activeTracker?.canceled == true) {
          onStatus?.call(TaskStatus.canceled);
          return DownloadResult(
            status: TaskStatus.canceled,
            progress: 0.0,
            error: e.toString(),
            taskId: task.id,
          );
        } else if (activeTracker?.paused == true) {
          onStatus?.call(TaskStatus.paused);
          return DownloadResult(
            status: TaskStatus.paused,
            progress: 0.0,
            error: e.toString(),
            taskId: task.id,
          );
        } else if (!isLastAttempt) {
          await Future.delayed(const Duration(seconds: 1));
          continue;
        } else {
          onStatus?.call(TaskStatus.failed);
          return DownloadResult(
            status: TaskStatus.failed,
            progress: 0.0,
            error: e.toString(),
            taskId: task.id,
          );
        }
      } finally {
        try {
          client.close(force: true);
        } catch (_) {}
      }
    }
  }

  Uri _buildUri(DownloadTask task) {
    final base = Uri.parse(task.url);
    final mergedQuery = <String, String>{};
    mergedQuery.addAll(base.queryParameters);
    mergedQuery.addAll(task.urlQueryParameters);
    return base.replace(
      queryParameters: mergedQuery.isEmpty ? null : mergedQuery,
    );
  }

  Future<Directory> _getTargetDirectory(String userSubdir) async {
    late final Directory baseDir;
    if (Platform.isAndroid) {
      baseDir = Directory('/storage/emulated/0/Download');
    } else if (Platform.isLinux) {
      baseDir = Directory(p.join(Platform.environment['HOME']!, 'Downloads'));
    } else if (Platform.isWindows) {
      baseDir = Directory(
        p.join(Platform.environment['USERPROFILE']!, 'Downloads'),
      );
    } else {
      final Directory? downloadsDir = await getDownloadsDirectory();
      baseDir = downloadsDir ?? await getApplicationDocumentsDirectory();
    }
    const String appFolderName = 'Miko';
    const String downloadsSubFolderName = 'Downloads';
    String appDownloadsPath = p.join(
      baseDir.path,
      appFolderName,
      downloadsSubFolderName,
    );
    if (userSubdir.isNotEmpty) {
      appDownloadsPath = p.join(appDownloadsPath, userSubdir);
    }
    return Directory(appDownloadsPath);
  }

  String _filenameFromUri(Uri uri) {
    final last = uri.pathSegments.isNotEmpty ? uri.pathSegments.last : '';
    if (last.isEmpty) return 'file_${DateTime.now().millisecondsSinceEpoch}';
    return last;
  }

  String _deriveFilenameFromUrl(String url) {
    try {
      final uri = Uri.parse(url);
      final p = uri.pathSegments.isNotEmpty ? uri.pathSegments.last : '';
      if (p.isNotEmpty) return p;
      // fallback: use host + timestamp
      final host = uri.host.replaceAll('.', '_');
      return '${host}_${DateTime.now().millisecondsSinceEpoch}';
    } catch (_) {
      return 'file_${DateTime.now().millisecondsSinceEpoch}';
    }
  }

  void _signalCancelActive(
    _ActiveTask active, {
    required TaskStatus statusAfterCancel,
    bool deletePartial = false,
  }) {
    active.canceled = true;
    try {
      active.sub?.cancel();
    } catch (_) {}
    try {
      active.client?.close(force: true);
    } catch (_) {}
    try {
      active.sink?.close();
    } catch (_) {}
    if (deletePartial) {
      try {
        if (active.file != null && active.file!.existsSync()) {
          active.file!.deleteSync();
        }
      } catch (_) {}
    }
    _updates.add(
      TaskStatusUpdate(taskId: active.task.id, status: statusAfterCancel),
    );
  }

  void unawaited(Future<void> f) {
    f.catchError((e, st) {});
  }
}

class _ActiveTask {
  final DownloadTask task;
  HttpClient? client;
  StreamSubscription<List<int>>? sub;
  IOSink? sink;
  File? file;
  bool paused = false;
  bool canceled = false;

  _ActiveTask({required this.task});
}
