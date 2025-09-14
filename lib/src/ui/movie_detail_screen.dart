import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miko/src/providers/movie_providers.dart';
import 'package:miko/src/models/movie/movie_detail.dart';

class MovieDetailScreen extends ConsumerWidget {
  final int movieId;
  const MovieDetailScreen({required this.movieId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(movieDetailProvider(movieId));
    return Scaffold(
      appBar: AppBar(),
      body: async.when(
        data: (MovieDetail detail) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (detail.posterPath != null || detail.backdropPath != null)
                  Center(
                    child: AspectRatio(
                      aspectRatio: 2 / 3,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          detail.posterPath != null
                              ? 'https://db.inosuke.sbst/p/w500${detail.posterPath}'
                              : 'https://db.inosuke.sbst/p/w780${detail.backdropPath}',
                          fit: BoxFit.cover,
                          errorBuilder: (context, err, st) => const ColoredBox(color: Colors.black12),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 12),
                Text(detail.title, style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                if (detail.tagline != null) Text(detail.tagline!, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    if (detail.releaseDate != null) Text('Released: ${detail.releaseDate}'),
                    const SizedBox(width: 16),
                    if (detail.runtime != null) Text('Runtime: ${detail.runtime} min'),
                    const SizedBox(width: 16),
                    if (detail.voteAverage != null) Chip(label: Text('${detail.voteAverage} ★')),
                  ],
                ),
                const SizedBox(height: 16),
                if (detail.overview != null) Text(detail.overview!),
                const SizedBox(height: 24),
                if ((detail.productionCompanies ?? []).isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Production', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: detail.productionCompanies!
                            .map((c) => Chip(label: Text(c.name)))
                            .toList(),
                      ),
                    ],
                  ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }
}