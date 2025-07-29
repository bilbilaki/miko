// TODO Implement this library.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miko/yt-dlp/providers/download_provider.dart';
import 'package:miko/yt-dlp/ui/widgets/download_task_tile.dart';

class QueueScreen extends ConsumerWidget {
  const QueueScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(downloadProvider);
    
    return Scaffold(
      appBar: AppBar(title: const Text('Download Queue')),
      body: tasks.isEmpty
          ? const Center(child: Text('No downloads in queue.'))
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return DownloadTaskTile(task: task);
              },
            ),
    );
  }
}
