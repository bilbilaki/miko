// lib/src/providers/collections_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miko/src/core/hive_manager.dart';
import 'package:miko/src/models/appmodels/collection.dart';
import 'package:uuid/uuid.dart';

final collectionsNotifierProvider =
    StateNotifierProvider<CollectionsNotifier, List<Collection>>((ref) {
      final manager = ref.read(hiveManagerProvider);
      return CollectionsNotifier(manager);
    });

class CollectionsNotifier extends StateNotifier<List<Collection>> {
  final HiveBoxManager _hive;

  CollectionsNotifier(this._hive) : super([]) {
    _load();
  }

  Future<void> _load() async {
    final all = _hive.getAllCollections();
    state = all;
  }

  Future<void> reload() async {
    await _load();
  }

  Future<void> createCollection({
    required String name,
    String? coverPath,
  }) async {
    final id = const Uuid().v4();
    final now = DateTime.now().toUtc().millisecondsSinceEpoch;
    final collection = Collection(
      id: id,
      name: name,
      coverPath: coverPath,
      items: [],
      createdAt: now,
      updatedAt: now,
    );
    await _hive.createCollection(collection);
    state = [...state, collection];
  }

  Future<void> deleteCollection(String id) async {
    await _hive.deleteCollection(id);
    state = state.where((c) => c.id != id).toList();
  }

  Future<void> addItem(String collectionId, CollectionItem item) async {
    await _hive.addItemToCollection(collectionId, item);
    await _load();
  }

  Future<void> removeItem(String collectionId, int itemId) async {
    await _hive.removeItemFromCollection(collectionId, itemId);
    await _load();
  }

  Future<void> renameCollection(String collectionId, String newName) async {
    final col = _hive.getCollection(collectionId);
    if (col == null) return;
    final updated = col.copyWith(
      name: newName,
      updatedAt: DateTime.now().toUtc().millisecondsSinceEpoch,
    );
    await _hive.updateCollection(updated);
    await _load();
  }
}
