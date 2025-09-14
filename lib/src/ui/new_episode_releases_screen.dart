// TODO Implement this library.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miko/src/consts.dart';
import 'package:miko/src/providers/trending_providers.dart';
import 'package:miko/src/ui/widgets/episode_grid_item.dart';

class NewEpisodeReleasesScreen extends ConsumerWidget {
  const NewEpisodeReleasesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newReleasesAsync = ref.watch(tvAiringTodayHomeProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0F10),
      appBar: AppBar(
        title: const Text('New Episode Releases'),
        centerTitle: true,
        backgroundColor: const Color(0xFF0D0F10),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Navigate to search screen or implement search functionality
            },
          ),
        ],
      ),
      body: newReleasesAsync.when(
        data: (response) {
          final items = response.results;
          if (items.isEmpty) {
            return const Center(
              child: Text('No new episode releases found.', style: TextStyle(color: Colors.white70)),
            );
          }
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(tvAiringTodayHomeProvider);
              await ref.read(tvAiringTodayHomeProvider.future);
            },
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.75, // Adjust as needed
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                if (item.posterPath == null || (item.voteAverage == null && item.popularity == null)) {
                  return const SizedBox.shrink(); // Skip items without necessary data
                }

                // Placeholder for episode info. In a real app, this would come from specific episode data.
                final String episodeInfo = 'Episode ${10 + index}'; // Example placeholder

                return EpisodeGridItem(
                  imageUrl: '$tmdbImageBaseUrlc/t/p/w500${item.posterPath}',
                  title: item.name ?? 'Unknown Show',
                  episodeInfo: episodeInfo,
                  rating: item.voteAverage != null ? item.voteAverage!.toStringAsFixed(1) : (item.popularity ?? 0.0).toStringAsFixed(1),
                  onTap: () {
                    // TODO: Navigate to episode detail screen
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Tapped on ${item.name}, $episodeInfo')),
                    );
                  },
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFF1ED760))),
        error: (err, stack) => Center(child: Text('Error loading new releases: $err', style: const TextStyle(color: Colors.red))),
      ),
    );
  }
}