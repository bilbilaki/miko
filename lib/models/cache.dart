import 'dart:async';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';



class _PersistentEntry {
  final String value;
  final DateTime expiry;
  final DateTime lastAccess; // for LRU
  _PersistentEntry(this.value, this.expiry, this.lastAccess);

  Map<String, dynamic> toJson() => {
    'value': value,
    'expiry': expiry.toIso8601String(),
    'lastAccess': lastAccess.toIso8601String(),
  };

  static _PersistentEntry fromJson(Map map) => _PersistentEntry(
    map['value'] as String,
    DateTime.parse(map['expiry'] as String),
    DateTime.parse(map['lastAccess'] as String),
  );
}

class PersistentTranslationCache {
  final String boxName;
  final Duration ttl;
  final int maxEntries;
  Box<dynamic>? _box;
  final Map<String, Future<String>> _inFlight = {};

  PersistentTranslationCache({
    this.boxName = 'translation_cache_box',
    this.ttl = const Duration(days: 30),
    this.maxEntries = 1000,
  });

  Future<void> init() async {
    // initialize Hive (call once in app startup)
    await Hive.initFlutter(); // uses path_provider internally
    _box = await Hive.openBox(boxName);
  }

  String _makeKey(String text, String targetLanguage) {
    final bytes = utf8.encode('$targetLanguage|${text.trim()}');
    return sha256.convert(bytes).toString();
  }

  Future<String?> _getFromBox(String key) async {
    if (_box == null) await init();
    final raw = _box!.get(key);
    if (raw == null) return null;
    final entry = _PersistentEntry.fromJson(Map<String, dynamic>.from(raw));
    if (DateTime.now().isAfter(entry.expiry)) {
      await _box!.delete(key);
      return null;
    }
    // update lastAccess
    final updated = _PersistentEntry(entry.value, entry.expiry, DateTime.now());
    await _box!.put(key, updated.toJson());
    return entry.value;
  }

  Future<void> _putToBox(String key, String value) async {
    if (_box == null) await init();
    final expiry = DateTime.now().add(ttl);
    final entry = _PersistentEntry(value, expiry, DateTime.now());
    await _box!.put(key, entry.toJson());
    await _maybeEvict();
  }

  Future<void> _maybeEvict() async {
    if (_box == null) return;
    final keys = _box!.keys.cast<String>().toList();
    if (keys.length <= maxEntries) return;
    // build list of entries with lastAccess
    final List<MapEntry<String, DateTime>> list = [];
    for (var k in keys) {
      final raw = _box!.get(k);
      if (raw == null) continue;
      final entry = _PersistentEntry.fromJson(Map<String, dynamic>.from(raw));
      list.add(MapEntry(k, entry.lastAccess));
    }
    // sort ascending by lastAccess (oldest first), evict oldest
    list.sort((a, b) => a.value.compareTo(b.value));
    final toRemove = list.take(keys.length - maxEntries).map((e) => e.key);
    for (var k in toRemove) {
      await _box!.delete(k);
    }
  }

  Future<String> runOrGet(
    String text,
    String targetLanguage,
    Future<String> Function() fetch,
  ) async {
    final key = _makeKey(text, targetLanguage);

    // check in-flight map
    if (_inFlight.containsKey(key)) {
      return _inFlight[key]!;
    }

    // try persistent cache
    final cached = await _getFromBox(key);
    if (cached != null) return cached;

    // start fetch and dedupe
    final future = fetch()
        .whenComplete(() {
          _inFlight.remove(key);
        })
        .then((result) async {
          await _putToBox(key, result);
          return result;
        });

    _inFlight[key] = future;
    return future;
  }

  Future<void> clearAll() async {
    if (_box == null) await init();
    await _box!.clear();
  }

  Future<void> remove(String text, String targetLanguage) async {
    if (_box == null) await init();
    final key = _makeKey(text, targetLanguage);
    await _box!.delete(key);
  }
}
