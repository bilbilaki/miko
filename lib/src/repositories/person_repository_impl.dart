import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:miko/src/core/hive_manager.dart';
import 'package:miko/src/models/person/person_detail.dart';
import 'package:miko/src/models/person/combined_credit.dart';
import 'package:miko/src/repositories/person_repository.dart';

class PersonRepositoryImpl implements PersonRepository {
  final Dio _dio;
  final HiveBoxManager _hive;
  final String? apiKey;
  final Duration defaultTtl;

  PersonRepositoryImpl(this._dio, this._hive, {this.apiKey, this.defaultTtl = const Duration(minutes: 30)});

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
  Future<PersonDetail?> getPersonDetail(int personId, {bool forceRefresh = false}) async {
    final raw = await _fetchRaw('/person/$personId', params: {'append_to_response': 'external_ids,images'}, forceRefresh: forceRefresh);
    return PersonDetail.fromJson(raw);
  }

  @override
  Future<PersonCredits?> getPersonCredits(int personId, {bool forceRefresh = false}) async {
    final raw = await _fetchRaw('/person/$personId/combined_credits', forceRefresh: forceRefresh);
    return PersonCredits.fromJson(raw);
  }
}