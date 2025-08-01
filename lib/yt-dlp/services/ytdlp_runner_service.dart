// lib/services/ytdlp_runner_service.dart
import 'dart:async';
import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:resumable_downloader/resumable_downloader.dart';
import 'package:universal_io/io.dart';
import 'package:miko/yt-dlp/models/download_task.dart';
import 'package:direct_link/direct_link.dart';
final ytdlpClientProvider = Provider((ref) => ());

class YtdlpRunnerService {
  final Ref _ref;
  YtdlpRunnerService(this._ref);

late DownloadManager _downloadManager;
  final DirectLink _directLink = DirectLink();
  bool _isInitialized = false;
Future<void> initialize(task) async {
    if (_isInitialized) return;

    final baseDir = await getApplicationDocumentsDirectory(); // Or getExternalStorageDirectory() for Android external storage
    _downloadManager = DownloadManager(
      subDir: 'app_downloads', // Files will be saved in <baseDir>/app_downloads/
      baseDirectory: baseDir,
      fileExistsStrategy: FileExistsStrategy.resume, // Resume download if file exists
      maxConcurrentDownloads: 2, // Maximum concurrent downloads
      maxRetries: 3, // Retries for failed downloads
      delayBetweenRetries: const Duration(seconds: 2),
      logger: (log) => task.addlog('[DownloadManager][${log.level.name}] ${log.message}'), // Custom logger
    );
    _isInitialized = true;
    task.addlog("DownloadService initialized with base directory: ${baseDir.path}/app_downloads");
  }
  Future<void> run(DownloadTask task, String ytdlpPath) async {
    if (Platform.isAndroid) {
      initialize(task);
runDownloadTask(task);
    } else {
      await _runOnDesktop(task, ytdlpPath);
    }
  }
   

  /// Initializes the DownloadManager. Call this once when your app starts or service is created.
  

  /// Runs a download task using direct_link and resumable_downloader.
  /// This function replaces the original _runOnAndroid logic.
  Future<void> runDownloadTask(DownloadTask task) async {
    if (!_isInitialized) {
      // Ensure the DownloadManager is initialized before running any task
      await initialize(task);
    }

    task.addLog("Starting download for task ID: ${task.id}...\n");

    try {
      task.status.value = TaskStatus.downloading;
      task.progressText.value = "Fetching media info...";
      task.addLog("Fetching media info for ${task.url} using DirectLink...\n");

      // Use the first URL if task.url contains multiple (like old yt-dlp behavior might imply)
      final urlToProcess = task.url.split('\n').first.trim();
      final directLinkData = await _directLink.check(urlToProcess);

      if (directLinkData == null || directLinkData.links == null || directLinkData.links!.isEmpty) {
        throw Exception("No downloadable links found for this URL after DirectLink check.");
      }

      Link? selectedLink;
      // Prioritize combined video/audio, then highest quality video, then any audio.
      // Adjust this selection logic based on your application's specific needs (e.g., preferred quality, format).
      selectedLink = await directLinkData.links!.firstWhere(
        (link) => link.link.isNotEmpty&& link.link !=null
      );

        // If no merged format, try to find a high quality video link
        selectedLink = directLinkData.links!.first;
      

        // If no video, try to find an audio only link
     //   selectedLink = directLinkData.links!.last;

      

      task.addLog("Selected format: ${selectedLink.quality} from URL: ${selectedLink.link}\n");

      // Ensure the target output directory exists
      final outputDir = Directory(task.outputDirectory);
      if (!(await outputDir.exists())) {
        await outputDir.create(recursive: true);
        task.addLog("Created output directory: ${outputDir.path}\n");
      }

      // Sanitize the title for use as a file name and determine file extension
      final fileNameWithoutExtension = directLinkData.title?.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_') ?? task.id;
      String fileExtension = 'mp4'; // Default to mp4, common for video
      if (selectedLink.type != null) {
          fileExtension = selectedLink.type!.split('/').last;
      } else if (selectedLink.link!.contains('.')) {
          // Fallback: try to infer from URL if mimeType is not specific enough
          fileExtension = selectedLink.link!.split('.').last.split('?').first;
      }
      // Basic sanitation for file extension (e.g., prevent overly long or invalid extensions)
      if (fileExtension.length > 5 || fileExtension.contains(RegExp(r'[^\w]'))) {
        fileExtension = 'bin'; // Fallback for unusual extensions
      }

      final fullOutputFilePath = '${outputDir.path}/$fileNameWithoutExtension.$fileExtension';

      task.addLog("Initiating download to path: $fullOutputFilePath\n");

      // Start the download using ResumableDownloader
      final downloadedFile = await _downloadManager.getFile(
        QueueItem(
          url: selectedLink.link!,
          fileName: fullOutputFilePath, // Provide the full absolute path
          progressCallback: (progress) {
            if (progress.totalByte > 0) {
              final currentProgress = progress.receivedByte / progress.totalByte;
              task.progress.value = currentProgress;
              task.progressText.value =
                  'Downloading: ${(currentProgress * 100).toStringAsFixed(1)}% (${progress.getReceivedMB()}/${progress.getTotalMB()}MB)';
            } else {
              task.progressText.value = 'Downloading: ${progress.getReceivedMB()}MB';
            }
            // You can add more granular logs if needed: task.addLog("Progress: ${task.progressText.value}\n");
          },
        ),
      );

      // Check if the download was successful
      if (downloadedFile != null && await downloadedFile.exists() && await downloadedFile.length() > 0) {
        task.status.value = TaskStatus.finished;
        task.progress.value = 1.0;
        task.progressText.value = 'Download complete!';
        task.addLog("Download complete. File saved to ${downloadedFile.path}\n");
        if (!task.completer.isCompleted) task.completer.complete();
      } else {
        // This case covers scenarios where `getFile` returns null or an empty file,
        // which might indicate a cancellation or an internal failure not resulting in an immediate throw.
        throw Exception("Download task completed but resulting file is missing or empty.");
      }
    } catch (e, s) {
      task.status.value = TaskStatus.error;
      task.addLog("Download failed: $e. Stacktrace: $s\n");
      task.progressText.value = "Error: ${e.toString().split(':').last.trim()}";
      if (!task.completer.isCompleted) task.completer.completeError(e, s); // Complete with error
    }
  }

  /// Disposes the DownloadManager to release resources. Call this when your app is closing.
  void dispose() {
    if (_isInitialized) {
      _downloadManager.dispose();
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