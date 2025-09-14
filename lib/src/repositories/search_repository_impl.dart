import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:miko/src/core/hive_manager.dart';
import 'package:miko/src/models/search/search_multi_response.dart';
import 'package:miko/src/repositories/search_repository.dart';

class SearchRepositoryImpl implements SearchRepository {
  final Dio _dio;
  final HiveBoxManager _hive;
  final String? apiKey;
  final Duration defaultTtl;

  SearchRepositoryImpl(this._dio, this._hive, {this.apiKey, this.defaultTtl = const Duration(minutes: 30)});

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

  @override
  Future<SearchMultiResponse> searchMulti(String query, {int page = 1, bool forceRefresh = false}) async {
    final path = '/search/multi';
    final params = {'query': query, 'page': page};
    final key = _cacheKey(path, params);
    if (!forceRefresh) {
      final cached = await _getCached(key);
      if (cached != null) return SearchMultiResponse.fromJson(cached);
    }

    final queryParams = Map<String, dynamic>.from(params);
    if (apiKey != null && apiKey!.isNotEmpty) queryParams['api_key'] = apiKey;
    final res = await _dio.get(path, queryParameters: queryParams);
    final data = (res.data as Map<String, dynamic>);
    await _saveCache(key, data);
    return SearchMultiResponse.fromJson(data);
  }
}