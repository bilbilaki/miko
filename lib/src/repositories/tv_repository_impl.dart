import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:miko/src/core/hive_manager.dart';
import 'package:miko/src/models/tv/tv_lists.dart';
import 'package:miko/src/models/tv/tv_show_detail.dart';
import 'package:miko/src/models/tv/tv_credits.dart';
import 'package:miko/src/repositories/tv_repository.dart';

class TvRepositoryImpl implements TvRepository {
  final Dio _dio;
  final HiveBoxManager _hive;
  final String? apiKey;
  final Duration defaultTtl;

  TvRepositoryImpl(this._dio, this._hive, {this.apiKey, this.defaultTtl = const Duration(minutes: 30)});

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

  Future<TvListResponse> _fetchList(String path, {int page = 1, bool forceRefresh = false}) async {
    final params = {'page': page};
    final key = _cacheKey(path, params);
    if (!forceRefresh) {
      final cached = await _getCached(key);
      if (cached != null) {
        return TvListResponse.fromJson(cached);
      }
    }

    final query = Map<String, dynamic>.from(params);
    if (apiKey != null && apiKey!.isNotEmpty) query['api_key'] = apiKey;
    final res = await _dio.get(path, queryParameters: query);
    final data = (res.data as Map<String, dynamic>);
    await _saveCache(key, data);
    return TvListResponse.fromJson(data);
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
  Future<TvListResponse> getPopular({int page = 1, bool forceRefresh = false}) => _fetchList('/tv/popular', page: page, forceRefresh: forceRefresh);

  @override
  Future<TvListResponse> getTopRated({int page = 1, bool forceRefresh = false}) => _fetchList('/tv/top_rated', page: page, forceRefresh: forceRefresh);

  @override
  Future<TvListResponse> getOnTheAir({int page = 1, bool forceRefresh = false}) => _fetchList('/tv/on_the_air', page: page, forceRefresh: forceRefresh);

  @override
  Future<TvListResponse> getAiringToday({int page = 1, bool forceRefresh = false}) => _fetchList('/tv/airing_today', page: page, forceRefresh: forceRefresh);

  @override
  Future<TvShowDetail?> getTvShowDetail(int tvId, {bool forceRefresh = false}) async {
    final raw = await _fetchRaw('/tv/$tvId', params: {
      'append_to_response': 'videos,images,credits,external_ids,content_ratings,translations'
    }, forceRefresh: forceRefresh);
    return TvShowDetail.fromJson(raw);
  }

  @override
  Future<TvCreditsResponse?> getTvCredits(int tvId, {bool forceRefresh = false}) async {
    final raw = await _fetchRaw('/tv/$tvId/credits', forceRefresh: forceRefresh);
    return TvCreditsResponse.fromJson(raw);
  }
}