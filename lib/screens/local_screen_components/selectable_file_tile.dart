import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/local_provider.dart';

/// File tile with selection support for file explorer
class SelectableFileTile extends StatelessWidget {
  final FileSystemEntity entity;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const SelectableFileTile({
    super.key,
    required this.entity,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<LocalProvider>(
      builder: (context, provider, child) {
        final isDirectory = entity is Directory;
        final fileName = entity.path.split('/').last;
        final isSelected = provider.isFileSelected(entity.path);
        final isSelectionMode = provider.hasSelection;

        return ListTile(
          selected: isSelected,
          leading: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Checkbox when in selection mode
              if (isSelectionMode)
                Checkbox(
                  value: isSelected,
                  onChanged: (_) => provider.toggleFileSelection(entity.path),
                )
              else
                Icon(
                  isDirectory ? Icons.folder : Icons.insert_drive_file,
                  color: isDirectory ? Colors.amber : null,
                ),
            ],
          ),
          title: Text(fileName),
          subtitle: !isDirectory ? _buildFileSubtitle() : null,
          trailing: isDirectory 
              ? const Icon(Icons.chevron_right)
              : null,
          onTap: () {
            if (isSelectionMode) {
              provider.toggleFileSelection(entity.path);
            } else {
              onTap?.call();
            }
          },
          onLongPress: () {
            if (!isSelectionMode) {
              provider.toggleFileSelection(entity.path);
            }
            onLongPress?.call();
          },
        );
      },
    );
  }

  Widget _buildFileSubtitle() {
    return FutureBuilder<FileStat>(
      future: entity.stat(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Text('');
        }

        final stat = snapshot.data!;
        final size = _formatBytes(stat.size);
        final modified = _formatDate(stat.modified);

        return Text(
          '$size • $modified',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        );
      },
    );
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    }
  }
}
