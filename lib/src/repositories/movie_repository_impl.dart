import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:miko/src/core/hive_manager.dart';
import 'package:miko/src/models/movie/movie_credits.dart';
import 'package:miko/src/models/movie/movie_detail.dart';
import 'package:miko/src/repositories/movie_repository.dart';
import 'package:miko/src/models/movie/movie_list_response.dart';


class MovieRepositoryImpl implements MovieRepository {
  final Dio _dio;
  final HiveBoxManager _hive;
  final String? apiKey;
  final Duration defaultTtl;

  MovieRepositoryImpl(this._dio, this._hive, {this.apiKey, this.defaultTtl = const Duration(minutes: 30)});

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

  Future<MovieListResponse> _fetchList(String path, {int page = 1, bool forceRefresh = false}) async {
    final params = {'page': page};
    final key = _cacheKey(path, params);
    if (!forceRefresh) {
      final cached = await _getCached(key);
      if (cached != null) {
        return MovieListResponse.fromJson(cached);
      }
    }

    final query = Map<String, dynamic>.from(params);
    if (apiKey != null && apiKey!.isNotEmpty) query['api_key'] = apiKey;
    final res = await _dio.get(path, queryParameters: query);
    final data = (res.data as Map<String, dynamic>);
    await _saveCache(key, data);
    return MovieListResponse.fromJson(data);
  }

  @override
  Future<MovieListResponse> getNowPlaying({int page = 1, bool forceRefresh = false}) => _fetchList('/movie/now_playing', page: page, forceRefresh: forceRefresh);

  @override
  Future<MovieListResponse> getPopular({int page = 1, bool forceRefresh = false}) => _fetchList('/movie/popular', page: page, forceRefresh: forceRefresh);

  @override
  Future<MovieListResponse> getTopRated({int page = 1, bool forceRefresh = false}) => _fetchList('/movie/top_rated', page: page, forceRefresh: forceRefresh);

  @override
  Future<MovieListResponse> getUpcoming({int page = 1, bool forceRefresh = false}) => _fetchList('/movie/upcoming', page: page, forceRefresh: forceRefresh);

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
  Future<MovieDetail?> getMovieDetail(int movieId, {bool forceRefresh = false}) async {
    final raw = await _fetchRaw('/movie/$movieId', params: {'append_to_response': 'videos,images,credits,release_dates,external_ids'}, forceRefresh: forceRefresh);
    return MovieDetail.fromJson(raw);
  }

  @override
  Future<MovieCredits?> getMovieCredits(int movieId, {bool forceRefresh = false}) async {
    final raw = await _fetchRaw('/movie/$movieId/credits', forceRefresh: forceRefresh);
    return MovieCredits.fromJson(raw);
  }
}