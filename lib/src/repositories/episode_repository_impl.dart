import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:miko/src/core/hive_manager.dart';
import 'package:miko/src/models/episode/episode_detail.dart';
import 'package:miko/src/repositories/episode_repository.dart';

class EpisodeRepositoryImpl implements EpisodeRepository {
  final Dio _dio;
  final HiveBoxManager _hive;
  final String? apiKey;
  final Duration defaultTtl;

  EpisodeRepositoryImpl(this._dio, this._hive, {this.apiKey, this.defaultTtl = const Duration(minutes: 30)});

  String _cacheKey(String prefix, Map<String, dynamic> params) {
    final sorted = Map<String, dynamic>.from(params)..removeWhere((k, v) => v == null);
    final keyBody = jsonEncode(sorted);
    return '$prefix::$keyBody';
  }

  Future<Map<String, dynamic>?> _getCached(String key, {Duration? ttl}) async {
    return _hive.getJson(key, maxAge: ttl ?? defaultTtl);
  }

  Future<void> _saveCache(String key, Map<String, dynamic> value) async {
    await _hive.putJson(key, value);
  }

  Future<Map<String, dynamic>> _fetchRaw(String path, {Map<String, dynamic>? params, bool forceRefresh = false}) async {
    final key = _cacheKey(path, params ?? {});
    if (!forceRefresh) {
      final cached = await _getCached(key);
      if (cached != null) return cached;
    }
    final query = Map<String, dynamic>.from(params ?? {});
    if (apiKey != null && apiKey!.isNotEmpty) query['api_key'] = apiKey;
    final res = await _dio.get(path, queryParameters: query);
    final data = (res.data as Map<String, dynamic>);
    await _saveCache(key, data);
    return data;
  }

  @override
  Future<EpisodeDetail?> getEpisodeDetail(int tvId, int seasonNumber, int episodeNumber, {bool forceRefresh = false}) async {
    final path = '/tv/$tvId/season/$seasonNumber/episode/$episodeNumber';
    final raw = await _fetchRaw(path, params: {'append_to_response': 'credits,images'}, forceRefresh: forceRefresh);
    return EpisodeDetail.fromJson(raw);
  }
}