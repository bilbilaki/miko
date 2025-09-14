// lib/src/ui/collection_detail_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miko/providers/collection_provider.dart';
import 'package:miko/src/models/appmodels/collection.dart';


class CollectionDetailPage extends ConsumerWidget {
  final String collectionId;
  const CollectionDetailPage({Key? key, required this.collectionId})
    : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collections = ref.watch(collectionsNotifierProvider);
    final collection = collections.firstWhere(
      (c) => c.id == collectionId,
      orElse: () => Collection(
        id: collectionId,
        name: 'Unknown',
        items: [],
        createdAt: 0,
        updatedAt: 0,
      ),
    );

    return Scaffold(
      appBar: AppBar(title: Text(collection.name)),
      body: collection.items.isEmpty
          ? const Center(child: Text('No items in this collection'))
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: collection.items.length,
              itemBuilder: (context, index) {
                final item = collection.items[index];
                return ListTile(
                  leading: item.posterPath != null
                      ? Image.network(item.posterPath!, width: 56, fit: BoxFit.cover)
                      : const Icon(Icons.movie),
                  title: Text(item.name),
                  subtitle: Text(
                    'Votes: ${item.voteCount}\n${item.overview ?? ''}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  isThreeLine: true,
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: () async {
                      await ref
                          .read(collectionsNotifierProvider.notifier)
                          .removeItem(collectionId, item.id);
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showAddItemDialog(context, ref, collection),
      ),
    );
  }

  Future<void> _showAddItemDialog(
    BuildContext context,
    WidgetRef ref,
    Collection collection,
  ) async {
    final idController = TextEditingController();
    final nameController = TextEditingController();
    final posterController = TextEditingController();
    final voteController = TextEditingController();

    final res = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Item to Collection'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: idController,
                decoration: const InputDecoration(labelText: 'ID (int)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: posterController,
                decoration: const InputDecoration(
                  labelText: 'Poster URL (optional)',
                ),
              ),
              TextField(
                controller: voteController,
                decoration: const InputDecoration(
                  labelText: 'Vote Count (optional)',
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Add'),
          ),
        ],
      ),
    );

    if (res != true) return;

    final id = int.tryParse(idController.text.trim());
    final name = nameController.text.trim();
    if (id == null || name.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('ID and Name are required')));
      return;
    }
    final poster = posterController.text.trim().isEmpty
        ? null
        : posterController.text.trim();
    final vote = int.tryParse(voteController.text.trim()) ?? 0;

    final item = CollectionItem(
      id: id,
      name: name,
      posterPath: poster,
      voteCount: vote,
      overview: null,
    );
    await ref
        .read(collectionsNotifierProvider.notifier)
        .addItem(collection.id, item);
  }
}
