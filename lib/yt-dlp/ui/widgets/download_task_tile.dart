// TODO Implement this library.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_filex/open_filex.dart';
import 'package:miko/yt-dlp/models/download_task.dart';
import 'package:miko/yt-dlp/providers/download_provider.dart';
import 'package:miko/yt-dlp/ui/widgets/log_viewer.dart';

class DownloadTaskTile extends ConsumerWidget {
  final DownloadTask task;

  const DownloadTaskTile({super.key, required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ValueListenableBuilder<TaskStatus>(
          valueListenable: task.status,
          builder: (context, status, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(_getStatusIcon(status)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        task.url.split('\n').first,
                        style: Theme.of(context).textTheme.titleMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    _buildActionButtons(context, ref, status),
                  ],
                ),
                const SizedBox(height: 8),
                ValueListenableBuilder<String>(
                  valueListenable: task.progressText,
                  builder: (context, progressText, child) {
                    return Text(
                      progressText,
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    );
                  },
                ),
                const SizedBox(height: 4),
                ValueListenableBuilder<double?>(
                  valueListenable: task.progress,
                  builder: (context, progress, child) {
                    if (progress == null || status == TaskStatus.queued) return const SizedBox.shrink();
                    return LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey.shade800,
                    );
                  },
                ),
              ],
           );
          },
        ),
      ),
    );
  }

  IconData _getStatusIcon(TaskStatus status) {
    switch (status) {
      case TaskStatus.queued: return Icons.queue;
      case TaskStatus.downloading: return Icons.downloading;
      case TaskStatus.processing: return Icons.sync;
      case TaskStatus.finished: return Icons.check_circle;
      case TaskStatus.error: return Icons.error;
      case TaskStatus.stopped: return Icons.stop_circle;
    }
  }
  
  Widget _buildActionButtons(BuildContext context, WidgetRef ref, TaskStatus status) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (status == TaskStatus.downloading || status == TaskStatus.processing)
          IconButton(
            icon: const Icon(Icons.stop),
            tooltip: 'Stop Task',
            onPressed: () => ref.read(downloadProvider.notifier).stopTask(task.id),
          ),
        
        IconButton(
          icon: const Icon(Icons.article_outlined),
          tooltip: 'View Log',
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => LogViewer(logNotifier: task.log),
            );
          },
        ),

        if (status == TaskStatus.finished)
          IconButton(
            icon: const Icon(Icons.folder_open),
            tooltip: 'Open Output Directory',
            onPressed: () async {
              final result = await OpenFilex.open(task.outputDirectory);
              if (result.type != ResultType.done) {
                 ScaffoldMessenger.of(context).showSnackBar(
                   SnackBar(content: Text('Could not open directory: ${result.message}')),
                 );
              }
            },
          ),
        
        if (status == TaskStatus.finished || status == TaskStatus.error || status == TaskStatus.stopped)
          IconButton(
            icon: const Icon(Icons.delete_forever),
            tooltip: 'Remove from List',
            onPressed: () => ref.read(downloadProvider.notifier).removeTask(task.id),
          ),
      ],
    );
  }
}
