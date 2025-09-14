import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:miko/src/core/hive_manager.dart';
import 'package:miko/src/models/movie/list_details.dart';
import 'package:miko/src/models/auth/list_action_response.dart';
import 'package:miko/src/repositories/list_repository.dart';

class ListRepositoryImpl implements ListRepository {
  final Dio _dio;
  final HiveBoxManager _hive;
  final String? apiKey;
  final Duration defaultTtl;

  ListRepositoryImpl(this._dio, this._hive, {this.apiKey, this.defaultTtl = const Duration(minutes: 30)});

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
  Future<MovieListDetails?> getListDetails(int listId, {bool forceRefresh = false}) async {
    final raw = await _fetchRaw('/list/$listId', forceRefresh: forceRefresh);
    return MovieListDetails.fromJson(raw);
  }

  @override
  Future<ListActionResponse?> addItemToList(int listId, int mediaId, {required String sessionId}) async {
    final path = '/list/$listId/add_item';
    final query = <String, dynamic>{};
    if (apiKey != null && apiKey!.isNotEmpty) query['api_key'] = apiKey;
    query['session_id'] = sessionId;
    final res = await _dio.post(path, queryParameters: query, data: {'media_id': mediaId});
    return ListActionResponse.fromJson(res.data as Map<String, dynamic>);
  }

  @override
  Future<ListActionResponse?> removeItemFromList(int listId, int mediaId, {required String sessionId}) async {
    final path = '/list/$listId/remove_item';
    final query = <String, dynamic>{};
    if (apiKey != null && apiKey!.isNotEmpty) query['api_key'] = apiKey;
    query['session_id'] = sessionId;
    final res = await _dio.post(path, queryParameters: query, data: {'media_id': mediaId});
    return ListActionResponse.fromJson(res.data as Map<String, dynamic>);
  }

  @override
  Future<ListActionResponse?> createList(String name, String description, {String language = 'en', required String sessionId}) async {
    final path = '/list';
    final query = <String, dynamic>{};
    if (apiKey != null && apiKey!.isNotEmpty) query['api_key'] = apiKey;
    query['session_id'] = sessionId;
    final body = {'name': name, 'description': description, 'iso_639_1': language};
    final res = await _dio.post(path, queryParameters: query, data: body);
    return ListActionResponse.fromJson(res.data as Map<String, dynamic>);
  }
}