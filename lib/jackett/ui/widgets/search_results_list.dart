// TODO Implement this library.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miko/jackett/providers/jackett_providers.dart';
import 'package:miko/jackett/ui/widgets/search_result_tile.dart';

class SearchResultsList extends ConsumerWidget {
  const SearchResultsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(searchProvider);

    return searchState.when(
      data: (results) {
        if (results.isEmpty) {
          return const Center(child: Text('No results found. Try a different search.'));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: results.length,
          itemBuilder: (context, index) {
            return SearchResultTile(item: results[index]);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
            children: [
               Icon(Icons.error_outline, color: Theme.of(context).colorScheme.error, size: 48),
               const SizedBox(height: 16),
               Text(
                'An error occurred',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}