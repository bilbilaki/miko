// lib/services/ytdlp_runner_service.dart
import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_io/io.dart';
import 'package:miko/yt-dlp/models/download_task.dart';
import 'package:flutter_yt_dlp/flutter_yt_dlp.dart';

final ytdlpClientProvider = Provider((ref) => FlutterYtDlpClient());

class YtdlpRunnerService {
  final Ref _ref;
  YtdlpRunnerService(this._ref);

  Future<void> run(DownloadTask task, String ytdlpPath) async {
    if (Platform.isAndroid) {
      await _runOnAndroid(task);
    } else {
      await _runOnDesktop(task, ytdlpPath);
    }
  }

  Future<void> _runOnAndroid(DownloadTask task) async {
    final client = _ref.read(ytdlpClientProvider);
    task.addLog("Starting download on Android...\n");

    try {
      task.status.value = TaskStatus.downloading;
      task.progressText.value = "Fetching video info...";
      task.addLog("Fetching video info for ${task.url}...\n");

      // flutter_yt_dlp doesn't support multiple URLs, take the first one.
      final singleUrl = task.url.split('\n').first.trim();
      final info = await client.getVideoInfo(singleUrl);
      
      Map<String, dynamic>? selectedFormat;
      if (info['rawVideoWithSoundFormats'] != null && info['rawVideoWithSoundFormats'].isNotEmpty) {
        selectedFormat = info['rawVideoWithSoundFormats'][0];
        task.addLog("Selected pre-merged format.\n");
      } else if (info['mergeFormats'] != null && info['mergeFormats'].isNotEmpty) {
        selectedFormat = info['mergeFormats'][0];
        task.addLog("Selected format requiring merge.\n");
      } else if (info['rawAudioOnlyFormats'] != null && info['rawAudioOnlyFormats'].isNotEmpty) {
        selectedFormat = info['rawAudioOnlyFormats'][0];
        task.addLog("Selected audio-only format.\n");
      }

      if (selectedFormat == null) {
        throw Exception("No downloadable formats found for this URL.");
      }

      task.addLog("Starting download with format: ${selectedFormat['formatNote'] ?? selectedFormat['format']}\n");
      
      final androidTaskId = await client.startDownload(
        format: selectedFormat,
        outputDir: task.outputDirectory,
        url: singleUrl,
        overwrite: task.config.forceOverwrites ?? false,
      );

      task.androidTaskId = androidTaskId;
      task.addLog("Download started with Android Task ID: $androidTaskId\n");

      task.eventSubscription = client.getDownloadEvents().listen((event) {
        if (event['taskId'] == androidTaskId) {
          if (event['type'] == 'progress') {
            final downloaded = event['downloaded'] as int;
            final total = event['total'] as int;
            if (total > 0) {
              final progress = downloaded / total;
              task.progress.value = progress;
              task.progressText.value = 'Downloading: ${(progress * 100).toStringAsFixed(1)}%';
            }
          } else if (event['type'] == 'state') {
            final stateName = event['stateName'] as String;
            task.addLog("State change: $stateName\n");
            switch (stateName) {
              case 'downloading':
                task.status.value = TaskStatus.downloading;
                task.progressText.value = 'Downloading...';
                break;
              case 'processing':
                task.status.value = TaskStatus.processing;
                task.progressText.value = 'Processing...';
                break;
              case 'success':
                task.status.value = TaskStatus.finished;
                task.progressText.value = 'Download complete!';
                task.eventSubscription?.cancel();
                if (!task.completer.isCompleted) task.completer.complete();
                break;
              case 'failed':
                task.status.value = TaskStatus.error;
                task.progressText.value = 'Task failed.';
                task.eventSubscription?.cancel();
                if (!task.completer.isCompleted) task.completer.complete();
                break;
              case 'canceled':
                task.status.value = TaskStatus.stopped;
                task.progressText.value = 'Task cancelled by user.';
                task.eventSubscription?.cancel();
                if (!task.completer.isCompleted) task.completer.complete();
                break;
            }
          }
        }
      });

      await task.completer.future;

    } catch (e, s) {
      task.status.value = TaskStatus.error;
      task.addLog("Android download failed: $e. Stacktrace: $s\n");
      task.progressText.value = "Error: ${e.toString().split(':').last.trim()}";
      if (!task.completer.isCompleted) task.completer.complete();
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