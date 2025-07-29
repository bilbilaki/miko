// lib/models/download_task.dart
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:universal_io/io.dart';
import 'package:miko/yt-dlp/models/ytdlp_config.dart';

enum TaskStatus { queued, downloading, processing, finished, error, stopped }

class DownloadTask {
  final String id;
  final String url;
  final YtdlpConfig config;
  final String outputDirectory;

  ValueNotifier<TaskStatus> status = ValueNotifier(TaskStatus.queued);
  ValueNotifier<double?> progress = ValueNotifier(null); // 0.0 to 1.0
  ValueNotifier<String> progressText = ValueNotifier('');
  ValueNotifier<String> log = ValueNotifier('');

  // Desktop process
  Process? process;
  // Android state
  String? androidTaskId;
  StreamSubscription? eventSubscription;

  final Completer<void> completer = Completer<void>();

  DownloadTask({
    required this.url,
    required this.config,
    required this.outputDirectory,
  }) : id = DateTime.now().millisecondsSinceEpoch.toString();

  void addLog(String data) {
    log.value += data;
  }
}