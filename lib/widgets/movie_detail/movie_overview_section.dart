import 'package:flutter/material.dart';
import 'package:miko/services/user_data_service.dart';
import 'package:miko/showcases/anime_detail_utils.dart';

/// Widget for displaying movie overview with translation support
class MovieOverviewSection extends StatelessWidget {
  final String overview;
  final VoidCallback onTranslate;
  final VoidCallback? onLongPress;

  const MovieOverviewSection({
    Key? key,
    required this.overview,
    required this.onTranslate,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(
          'Overview',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        IconButton(
          iconSize: 20.0,
          icon: const Icon(Icons.assistant),
          tooltip: 'translate overview',
          onPressed: onTranslate,
          onLongPress: onLongPress,
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
