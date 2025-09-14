import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:miko/src/core/hive_manager.dart';
import 'package:miko/src/models/misc/trending_response.dart';
import 'package:miko/src/repositories/trending_repository.dart';

class TrendingRepositoryImpl implements TrendingRepository {
  final Dio _dio;
  final HiveBoxManager _hive;
  final String? apiKey;
  final Duration defaultTtl;

  TrendingRepositoryImpl(this._dio, this._hive, {this.apiKey, this.defaultTtl = const Duration(minutes: 30)});

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

  Future<TrendingResponse> _fetchTrending(String mediaType, String timeWindow, {int page = 1, bool forceRefresh = false}) async {
    final path = '/trending/$mediaType/$timeWindow';
    final params = {'page': page};
    final key = _cacheKey(path, params);
    if (!forceRefresh) {
      final cached = await _getCached(key);
      if (cached != null) {
        return TrendingResponse.fromJson(cached);
      }
    }

    final query = Map<String, dynamic>.from(params);
    if (apiKey != null && apiKey!.isNotEmpty) query['api_key'] = apiKey;
    final res = await _dio.get(path, queryParameters: query);
    final data = (res.data as Map<String, dynamic>);
    await _saveCache(key, data);
    return TrendingResponse.fromJson(data);
  }

  @override
  Future<TrendingResponse> getTrendingAll({String timeWindow = 'day', int page = 1, bool forceRefresh = false}) {
    return _fetchTrending('all', timeWindow, page: page, forceRefresh: forceRefresh);
  }

  @override
  Future<TrendingResponse> getTrendingMovies({String timeWindow = 'day', int page = 1, bool forceRefresh = false}) {
    return _fetchTrending('movie', timeWindow, page: page, forceRefresh: forceRefresh);
  }

  @override
  Future<TrendingResponse> getTrendingTv({String timeWindow = 'day', int page = 1, bool forceRefresh = false}) {
    return _fetchTrending('tv', timeWindow, page: page, forceRefresh: forceRefresh);
  }
}