// lib/providers/download_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_io/io.dart';
import 'package:miko/yt-dlp/models/download_task.dart';
import 'package:miko/yt-dlp/services/ytdlp_runner_service.dart';
import 'package:miko/yt-dlp/providers/settings_provider.dart';

final downloadProvider =
    StateNotifierProvider<DownloadNotifier, List<DownloadTask>>((ref) {
  return DownloadNotifier(ref);
});

class DownloadNotifier extends StateNotifier<List<DownloadTask>> {
  final Ref _ref;
  DownloadNotifier(this._ref) : super([]);

  Future<void> addDownload(DownloadTask task) async {
    state = [...state, task];
    _runNextTask();
  }

  void _runNextTask() {
    final runner = _ref.read(ytdlpRunnerServiceProvider);
    final settings = _ref.read(settingsProvider);

    if (settings.ytdlpPath == null || settings.ytdlpPath!.isEmpty) {
      final queuedTask = state.firstWhere(
        (t) => t.status.value == TaskStatus.queued,
        orElse: () => state.firstWhere((t) => t.status.value != TaskStatus.finished),
      );
      queuedTask.status.value = TaskStatus.error;
      queuedTask.addLog(
          'Error: yt-dlp executable not configured. Please set it up in the Settings tab.');
      queuedTask.completer.complete();
      return;
    }

    if (state.any((t) =>
        t.status.value == TaskStatus.downloading ||
        t.status.value == TaskStatus.processing)) {
      return;
    }

    final nextTask = state.firstWhere((t) => t.status.value == TaskStatus.queued,
        orElse: () => state.last); // Simplified to avoid error

    if (nextTask.status.value != TaskStatus.queued) return;

    runner.run(nextTask, settings.ytdlpPath!);
  }

  void stopTask(String taskId) async {
    final task = state.firstWhere((t) => t.id == taskId);
    task.eventSubscription?.cancel(); // Cancel listener regardless of platform

    if (Platform.isAndroid) {
      if (task.androidTaskId != null) {
        final client = _ref.read(ytdlpClientProvider);
       // await client.cancelDownload(task.androidTaskId!);
        // Event listener will update state to 'stopped'
      }
    } else {
      if (task.process != null) {
        task.process!.kill(ProcessSignal.sigterm);
        task.status.value = TaskStatus.stopped;
        task.addLog('Task stopped by user.');
        if (!task.completer.isCompleted) task.completer.complete();
      }
    }
  }

  void removeTask(String taskId) {
    // Ensure any active process/listener is stopped before removing
    final taskExists = state.any((t) => t.id == taskId);
    if(taskExists){
      final task = state.firstWhere((t) => t.id == taskId);
      if (task.status.value == TaskStatus.downloading || task.status.value == TaskStatus.processing) {
        stopTask(taskId);
      }
    }
    state = state.where((t) => t.id != taskId).toList();
  }
}