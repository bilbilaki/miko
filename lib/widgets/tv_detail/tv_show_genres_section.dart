import 'package:flutter/material.dart';
import 'package:miko/showcases/model.dart';

/// Widget for displaying TV show genres
class TvShowGenresSection extends StatelessWidget {
  final List<Genre> genres;

  const TvShowGenresSection({
    super.key,
    required this.genres,
  });

  @override
  Widget build(BuildContext context) {
    if (genres.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Genres', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: genres
              .map(
                (genre) => Chip(
                  label: Text(genre.name),
                  backgroundColor: Colors.grey[800],
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
