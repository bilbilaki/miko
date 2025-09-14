// lib/ui/delete_confirm_sheet.dart
// (Delete confirmation sheet now calls provider/store to delete and cancels active download if running)

import 'package:flutter/material.dart';
import 'package:miko/models/download.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miko/providers/downlooad.dart';

class DeleteConfirmSheet extends ConsumerWidget {
  final String taskId;
  const DeleteConfirmSheet({required this.taskId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final record = ref.watch(downloadNotifierProvider)[taskId];

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF16161A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 36),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white12,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Delete',
            style: TextStyle(
              color: Color(0xFFFF4D4D),
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Are you sure you want to delete this download?',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          if (record != null)
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    color: Colors.black,
                    width: 72,
                    height: 72,
                    child: record.task?.metaData != null
                        ? Image.network(
                            record.task!.metaData!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                const Icon(Icons.movie),
                          )
                        : const Icon(Icons.movie, color: Colors.white54),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        record.task?.filename ?? record.taskId,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        record.status.name,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          const SizedBox(height: 22),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white24),
                    backgroundColor: const Color(0xFF1C1C1F),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    // If running or queued, request cancel first
                    ref.read(downloadNotifierProvider.notifier).cancel(taskId);
                    await DownloadStore.instance.delete(taskId);
                    // remove from notifier state
                    final notifier = ref.read(
                      downloadNotifierProvider.notifier,
                    );
                    final current = ref.read(downloadNotifierProvider);
                    final newMap = Map<String, DownloadRecord>.from(current)
                      ..remove(taskId);
                    notifier.state = newMap;
                    Navigator.of(context).pop(true);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00C853),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'Yes, Delete',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
