import 'package:flutter/material.dart';

/// Widget for displaying movie overview with translation support
class MovieOverviewSection extends StatelessWidget {
  final String overview;
  final VoidCallback onTranslate;
  final VoidCallback? onLongPress;
  final bool isTranslating;
  final bool isTranslated;

  const MovieOverviewSection({
    super.key,
    required this.overview,
    required this.onTranslate,
    this.onLongPress,
    this.isTranslating = false,
    this.isTranslated = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Row(
          children: [
            Text(
              'Overview',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(width: 8),
            IconButton(
              iconSize: 20.0,
              icon: isTranslating
                  ? SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Icon(
                      Icons.auto_awesome,
                      color: isTranslated ? Colors.cyan : Colors.white70,
                    ),
              tooltip: isTranslated ? 'Show original' : 'Translate overview',
              onPressed: onTranslate,
              onLongPress: onLongPress,
              style: IconButton.styleFrom(
                backgroundColor: Colors.black.withValues(alpha: 0.3),
                padding: const EdgeInsets.all(4.0),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SelectableText(
          overview.isEmpty ? 'No overview available.' : overview,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
