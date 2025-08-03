// lib/services/ytdlp_runner_service.dart
import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_io/io.dart';
import 'package:miko/yt-dlp/models/download_task.dart';
final ytdlpClientProvider = Provider((ref) => ());

class YtdlpRunnerService {
  final Ref ref;
  YtdlpRunnerService(this.ref);

  bool _isInitialized = false;
Future<void> initialize(task) async {
    if (_isInitialized) return;

    final baseDir = await getApplicationDocumentsDirectory(); // Or getExternalStorageDirectory() for Android external storage
    _isInitialized = true;
    task.addlog("DownloadService initialized with base directory: ${baseDir.path}/app_downloads");
  }
  Future<void> run(DownloadTask task, String ytdlpPath) async {
    if (Platform.isAndroid) {
   
    } else {
      await _runOnDesktop(task, ytdlpPath);
    }
  }
   

  /// Initializes the DownloadManager. Call this once when your app starts or service is created.
  

  /// Runs a download task using direct_link and resumable_downloader.
  /// This function replaces the original _runOnAndroid logic.
  

  /// Disposes the DownloadManager to release resources. Call this when your app is closing.
  void dispose() {
    if (_isInitialized) {
      _isInitialized = false;
    //  tas("DownloadService disposed.");
    }
  }
  Future<void> _runOnDesktop(DownloadTask task, String ytdlpPath) async {
    final command = task.config.buildCommand(task.url, task.outputDirectory);

    try {
      task.status.value = TaskStatus.downloading;
      task.addLog('Starting yt-dlp with command:\n$ytdlpPath ${command.join(' ')}\n\n');

      final process = await Process.start(
        ytdlpPath,
        command,
        workingDirectory: task.outputDirectory,
      );
      task.process = process;

      final progressRegex = RegExp(r'\[download\]\s+([\d\.]+)%\s+of\s+~?\s*([\d\.\w]+)\s+at\s+([\d\.\w/s]+)\s+ETA\s+([\d:]+)');

      process.stdout.transform(utf8.decoder).transform(const LineSplitter()).listen(
        (line) {
          task.addLog('$line\n');
          final match = progressRegex.firstMatch(line);
          if (match != null) {
            final percentage = double.tryParse(match.group(1) ?? '0') ?? 0;
            task.progress.value = percentage / 100.0;
            task.progressText.value = 'Downloading: ${match.group(1)}% of ${match.group(2)} at ${match.group(3)} ETA ${match.group(4)}';
          } else if (line.contains('has already been downloaded') || line.contains('moving to final destination')) {
            task.progress.value = 1.0;
            task.progressText.value = "Post-processing...";
            task.status.value = TaskStatus.processing;
          } else {
            task.progressText.value = line;
          }
        },
        onError: (error) {
          task.addLog("Error reading stdout: $error\n");
        },
      );

      process.stderr.transform(utf8.decoder).transform(const LineSplitter()).listen(
        (line) {
          task.addLog('ERROR: $line\n');
          task.progressText.value = "Error: $line";
        },
        onError: (error) {
          task.addLog("Error reading stderr: $error\n");
        },
      );

      final exitCode = await process.exitCode;

      if (task.status.value != TaskStatus.stopped) {
        if (exitCode == 0) {
          task.status.value = TaskStatus.finished;
          task.progressText.value = "Download complete!";
        } else {
          task.status.value = TaskStatus.error;
          task.progressText.value = "Task failed with exit code $exitCode.";
        }
      }
    } catch (e, s) {
      if (task.status.value != TaskStatus.stopped) {
        task.status.value = TaskStatus.error;
        task.addLog("Failed to start process: $e. Stacktrace: $s\n");
        task.progressText.value = "Failed to start yt-dlp process.";
      }
    } finally {
      if (!task.completer.isCompleted) task.completer.complete();
    }
  }
}

final ytdlpRunnerServiceProvider = Provider((ref) => YtdlpRunnerService(ref));