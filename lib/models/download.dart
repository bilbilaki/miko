// lib/services/download_store.dart
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:miko/models/download_task.dart';

/// Simple SharedPreferences-backed store that saves both the DownloadTask and
/// associated metadata (status/progress/filePath/expectedFileSize/createdAt).
final class DownloadStore {
  DownloadStore._();
  static final instance = DownloadStore._();

  static const String _prefsKey = 'miko_downloads_v2';

  SharedPreferences? _prefs;
  // in-memory cache: id -> stored map
  Map<String, Map<String, dynamic>> _cache = {};

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
    final raw = _prefs!.getString(_prefsKey);
    if (raw == null) {
      _cache = {};
      return;
    }
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      final map = <String, Map<String, dynamic>>{};
      decoded.forEach((k, v) {
        if (v is Map) {
          map[k] = Map<String, dynamic>.from(v);
        } else if (v is String) {
          try {
            final inner = jsonDecode(v);
            if (inner is Map) map[k] = Map<String, dynamic>.from(inner);
          } catch (_) {}
        }
      });
      _cache = map;
    } catch (_) {
      _cache = {};
    }
  }

  // Raw entry structure:
  // {
  //   'task': <DownloadTask.toJson()>,
  //   'status': 'queued' | 'running' | 'paused' | 'complete' | 'canceled' | 'failed'
  //   'progress': 0.0,
  //   'filePath': '/storage/.../file.mp4' or null,
  //   'expectedFileSize': 12345 or null,
  //   'createdAt': millisecondsSinceEpoch
  // }

  Future<void> putTask(
    DownloadTask task, {
    TaskStatus status = TaskStatus.queued,
    double progress = 0.0,
    String? filePath,
    int? expectedFileSize,
  }) async {
    if (_prefs == null) await init();
    final createdAtMillis =
        task.createdAt?.millisecondsSinceEpoch ??
        DateTime.now().millisecondsSinceEpoch;
    _cache[task.id] = {
      'task': task.toJson(),
      'status': status.name,
      'progress': progress,
      'filePath': filePath,
      'expectedFileSize': expectedFileSize,
      'createdAt': createdAtMillis,
    };
    await _persist();
  }

  Future<void> updateStatus(
    String id, {
    TaskStatus? status,
    double? progress,
    String? filePath,
    int? expectedFileSize,
  }) async {
    if (_prefs == null) await init();
    final entry = _cache[id];
    if (entry == null) return;
    if (status != null) entry['status'] = status.name;
    if (progress != null) entry['progress'] = progress;
    if (filePath != null) entry['filePath'] = filePath;
    if (expectedFileSize != null) entry['expectedFileSize'] = expectedFileSize;
    await _persist();
  }

  Future<DownloadTask?> fetch(String id) async {
    if (_prefs == null) await init();
    final entry = _cache[id];
    if (entry == null) return null;
    final taskMap = entry['task'];
    if (taskMap == null) return null;
    try {
      return DownloadTask.fromJson(Map<String, dynamic>.from(taskMap));
    } catch (_) {
      return null;
    }
  }

  Future<bool> delete(String id) async {
    if (_prefs == null) await init();
    if (!_cache.containsKey(id)) return false;
    _cache.remove(id);
    await _persist();
    return true;
  }

  /// Return the raw entries map (id -> entry map)
  Future<Map<String, Map<String, dynamic>>> fetchAllRaw() async {
    if (_prefs == null) await init();
    // Return a copy
    return Map<String, Map<String, dynamic>>.fromEntries(
      _cache.entries.map(
        (e) => MapEntry(e.key, Map<String, dynamic>.from(e.value)),
      ),
    );
  }

  /// Return all DownloadTask objects (ignoring metadata)
  Future<Map<String, DownloadTask>> fetchAllTasks() async {
    if (_prefs == null) await init();
    final out = <String, DownloadTask>{};
    for (final entry in _cache.entries) {
      final taskMap = entry.value['task'];
      if (taskMap == null) continue;
      try {
        out[entry.key] = DownloadTask.fromJson(
          Map<String, dynamic>.from(taskMap),
        );
      } catch (_) {}
    }
    return out;
  }

  Future<void> _persist() async {
    if (_prefs == null) await init();
    try {
      await _prefs!.setString(_prefsKey, jsonEncode(_cache));
    } catch (_) {
      // ignore persistence failure
    }
  }
}
