// lib/ui/download_screen.dart
// Sort changed to use stable ordering: status priority then createdAt.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:miko/models/download_task.dart';
import 'package:miko/providers/downlooad.dart';
import 'package:miko/src/ui/widgets/delete_confirm_sheet.dart';
import 'package:miko/src/ui/widgets/download_list_item.dart';

class DownloadScreen extends ConsumerWidget {
  const DownloadScreen({super.key});

  // status priority: lower = higher priority (shows first)
  static const Map<TaskStatus, int> _statusOrder = {
    TaskStatus.running: 0,
    TaskStatus.queued: 1,
    TaskStatus.paused: 2,
    TaskStatus.failed: 3,
    TaskStatus.canceled: 4,
    TaskStatus.complete: 5,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordsMap = ref.watch(downloadNotifierProvider);
    final records = recordsMap.values.toList();

    records.sort((a, b) {
      final sa = _statusOrder[a.status] ?? 99;
      final sb = _statusOrder[b.status] ?? 99;
      if (sa != sb) return sa.compareTo(sb);
      // stable tiebreaker: createdAt ascending (older first)
      return a.createdAt.compareTo(b.createdAt);
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Icon(
            Icons.cloud_download,
            color: const Color(0xFF00C853),
            size: 28,
          ),
        ),
        title: const Text(
          'Download',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddDialog(context, ref),
          ),
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
        ],
      ),
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
      child: records.isEmpty
        ? Center(child: _buildEmptyState(context))
              : ListView.separated(
                  key: const ValueKey('list'),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  itemCount: records.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, idx) {
                    final r = records[idx];
                    return DownloadListItem(
                      record: r,
                      onDelete: () =>
                          _confirmDelete(context, ref, r.task?.id ?? r.taskId),
                      onCancel: () {
                        ref
                            .read(downloadNotifierProvider.notifier)
                            .cancel(r.taskId);
                      },
                      onPause: () {
                        ref
                            .read(downloadNotifierProvider.notifier)
                            .pause(r.taskId);
                      },
                      onResume: () {
                        ref
                            .read(downloadNotifierProvider.notifier)
                            .resume(r.taskId);
                      },
                      onRetry: () {
                        final task = r.task;
                        if (task != null) {
                          ref
                              .read(downloadNotifierProvider.notifier)
                              .enqueue(task);
                        }
                      },
                    );
                  },
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF00C853),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => _showAddDialog(context, ref),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Future<void> _showAddDialog(BuildContext ctx, WidgetRef ref) async {
    final urlCtrl = TextEditingController();
    final filenameCtrl = TextEditingController();
    final dirCtrl = TextEditingController();

    final result = await showDialog<bool>(
      context: ctx,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF16161A),
          title: const Text('Add Download'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: urlCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'URL',
                  hintText: 'https://...',
                  filled: true,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: filenameCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Filename (optional)',
                  filled: true,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: dirCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Directory (optional)',
                  filled: true,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (urlCtrl.text.trim().isEmpty) return;
                Navigator.of(context).pop(true);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );

    if (result == true) {
      final url = urlCtrl.text.trim();
      final filename = filenameCtrl.text.trim();
      final dir = dirCtrl.text.trim();

      final t = DownloadTask(
        url: url,
        filename: filename.isNotEmpty ? filename : url,
        directory: dir,
      );
      await ref.read(downloadNotifierProvider.notifier).enqueue(t);
    }
  }

  Future<void> _confirmDelete(
    BuildContext ctx,
    WidgetRef ref,
    String taskId,
  ) async {
    final confirmed = await showModalBottomSheet<bool>(
      context: ctx,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => DeleteConfirmSheet(taskId: taskId),
    );
    if (confirmed == true) {
      // delete fully (store + file if possible)
      await ref
          .read(downloadNotifierProvider.notifier)
          .deleteCompletely(taskId);
  // The DownloadNotifier updates its own state; no direct external
  // mutation of notifier.state is allowed. Rely on the notifier's
  // internal delete logic and state updates.
    }
  }

    Widget _buildEmptyState(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(
          'assets/Lottie/no_schedule.json', // Placeholder, replace with your Lottie animation
          repeat: true,
          height: 150,
          width: 150,
        ),
        const SizedBox(height: 24),
        const Text(
          'No Download Yet ',
          style: TextStyle(
            color: Color(0xFF1ED760),
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.0),
          child: Text(
            'Sorry, there is no Download Why You not addTask now',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ),
      ],
    );
  }

}
