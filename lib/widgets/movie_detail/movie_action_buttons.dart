import 'package:flutter/material.dart';
import 'package:miko/utils/colors.dart';

/// Widget for displaying Play and Download action buttons
class MovieActionButtons extends StatelessWidget {
  final List<String> downloadLinks;
  final bool isWatched;
  final VoidCallback onPlayPressed;
  final VoidCallback onDownloadPressed;

  const MovieActionButtons({
    super.key,
    required this.downloadLinks,
    required this.isWatched,
    required this.onPlayPressed,
    required this.onDownloadPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (downloadLinks != [''])
          ElevatedButton.icon(
            icon: Icon(isWatched ? Icons.done : Icons.play_arrow),
            label: const Text('Play'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentColor,
              foregroundColor: AppColors.primaryText,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            ),
            onPressed: onPlayPressed,
          )
        else
          const Text("No Playing Link Exist"),
        const SizedBox(width: 10),
        if (downloadLinks != [''])
          ElevatedButton.icon(
            icon: Icon(isWatched ? Icons.done : Icons.download),
            label: const Text('Download'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 0, 241, 32),
              foregroundColor: const Color.fromARGB(255, 0, 0, 0),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            ),
            onPressed: onDownloadPressed,
          )
        else
          const SizedBox(),
      ],
    );
  }
}
