// lib/src/hive/hive_box_manager.dart
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miko/src/hive/hive_registrar.g.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:miko/src/models/appmodels/collection.dart';


final hiveManagerProvider = Provider<HiveBoxManager>((ref) => HiveBoxManager());

class HiveBoxManager {
  bool _initialized = false;


  Future<void> init({String? path}) async {
    if (_initialized) return;
    if (path != null) {
      await Hive.initFlutter(path);

    } else {
      await Hive.initFlutter();

    }

    try {
      // register adapters - generated build must include adapters and registrar
      // ignore: avoid_dynamic_calls
      Hive.registerAdapters();
    } catch (_) {
      // adapters already registered is fine
    }

    // Some generated setups produce multiple adapter outputs or miss
    // registering the app-level Collection adapters (from freezed).
    // Register them explicitly to ensure the runtime type _Collection
    // has a matching adapter.

    // open needed boxes
    await Future.wait([
      Hive.openBox<String>('cache_box'), // generic JSON cache storage
      Hive.openBox('account_box'),
      Hive.openBox('downloads'),
      // collections box to store user collections
      Hive.openBox<Collection>('collections_box'),


      // Hive.openBox<FavoriteItem>('favorites_box'),
      //       Hive.openBox<WatchedTracker>('watched_tracker_box'),
      // Hive.openBox<WatchProgress>('watch_progress_box'),
      // Hive.openBox<WatchlistItem>('watchlist_box')


    ]);

    _initialized = true;
  }
Box<Collection> get collectionBox => Hive.box<Collection>('collections_box');
  Box<String> get cacheBox => Hive.box<String>('cache_box');
  Future<void> clearCache() async {
    await cacheBox.clear();
  }

  // generic helpers
  Future<void> putJson(String key, Map<String, dynamic> jsonMap) async {
    final envelope = {
      'ts': DateTime.now().toUtc().millisecondsSinceEpoch,
      'data': jsonMap,
    };
    await cacheBox.put(key, jsonEncode(envelope));
  }

  Map<String, dynamic>? getJson(String key, {Duration? maxAge}) {
    final raw = cacheBox.get(key);
    if (raw == null) return null;
    final envelope = jsonDecode(raw) as Map<String, dynamic>;
    final ts = envelope['ts'] as int?;
    final data = envelope['data'] as Map<String, dynamic>?;
    if (ts == null || data == null) return null;
    if (maxAge != null) {
      final age = DateTime.now().toUtc().millisecondsSinceEpoch - ts;
      if (age > maxAge.inMilliseconds) {
        return null;
      }
    }
    return data;
  }

  // Collections APIs (persisted in 'collections_box')
  Box<Collection> get collectionsBox => Hive.box<Collection>('collections_box');

  List<Collection> getAllCollections() {
    return collectionsBox.values.toList();
  }

  Collection? getCollection(String id) {
    return collectionsBox.get(id);
  }

  Future<void> createCollection(Collection collection) async {
    await collectionsBox.put(collection.id, collection);
  }

  Future<void> deleteCollection(String id) async {
    await collectionsBox.delete(id);
  }

  Future<void> updateCollection(Collection collection) async {
    await collectionsBox.put(collection.id, collection);
  }

  Future<void> addItemToCollection(
    String collectionId,
    CollectionItem item,
  ) async {
    final col = collectionsBox.get(collectionId);
    if (col == null) return;
    final exists = col.items.any((i) => i.id == item.id);
    if (exists) return; // avoid duplicates
    final updated = col.copyWith(
      items: [...col.items, item],
      updatedAt: DateTime.now().toUtc().millisecondsSinceEpoch,
    );
    await collectionsBox.put(collectionId, updated);
  }

  Future<void> removeItemFromCollection(String collectionId, int itemId) async {
    final col = collectionsBox.get(collectionId);
    if (col == null) return;
    final updatedItems = col.items.where((i) => i.id != itemId).toList();
    final updated = col.copyWith(
      items: updatedItems,
      updatedAt: DateTime.now().toUtc().millisecondsSinceEpoch,
    );
    await collectionsBox.put(collectionId, updated);
  }
}
