import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:miko/src/core/hive_manager.dart';
import 'package:miko/src/models/auth/guest_session.dart';
import 'package:miko/src/models/auth/session.dart';
import 'package:miko/src/models/auth/account.dart';
import 'package:miko/src/models/auth/account_states.dart';
import 'package:miko/src/models/misc/rating_response.dart';
import 'package:miko/src/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final Dio _dio;
  final HiveBoxManager _hive;
  final String? apiKey;
  final Duration defaultTtl;

  AuthRepositoryImpl(this._dio, this._hive, {this.apiKey, this.defaultTtl = const Duration(minutes: 30)});

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
  Future<GuestSession?> createGuestSession() async {
    final path = '/authentication/guest_session/new';
    final query = <String, dynamic>{};
    if (apiKey != null && apiKey!.isNotEmpty) query['api_key'] = apiKey;
    final res = await _dio.get(path, queryParameters: query);
    return GuestSession.fromJson(res.data as Map<String, dynamic>);
  }

  @override
  Future<SessionResponse?> createSession(String requestToken) async {
    final path = '/authentication/session/new';
    final query = <String, dynamic>{};
    if (apiKey != null && apiKey!.isNotEmpty) query['api_key'] = apiKey;
    final res = await _dio.post(path, queryParameters: query, data: {'request_token': requestToken});
    return SessionResponse.fromJson(res.data as Map<String, dynamic>);
  }

  @override
  Future<AccountDetails?> getAccountDetails({required String sessionId}) async {
    final path = '/account';
    final query = <String, dynamic>{};
    if (apiKey != null && apiKey!.isNotEmpty) query['api_key'] = apiKey;
    query['session_id'] = sessionId;
    final res = await _dio.get(path, queryParameters: query);
    return AccountDetails.fromJson(res.data as Map<String, dynamic>);
  }

  @override
  Future<AccountStates?> getAccountStates(String mediaType, int mediaId, {required String sessionId}) async {
    final path = '/$mediaType/$mediaId/account_states';
    final query = <String, dynamic>{};
    if (apiKey != null && apiKey!.isNotEmpty) query['api_key'] = apiKey;
    query['session_id'] = sessionId;
    final res = await _dio.get(path, queryParameters: query);
    return AccountStates.fromJson(res.data as Map<String, dynamic>);
  }

  @override
  Future<RatingResponse?> rateMovie(int movieId, double value, {String? sessionId, String? guestSessionId}) async {
    final path = '/movie/$movieId/rating';
    final query = <String, dynamic>{};
    if (apiKey != null && apiKey!.isNotEmpty) query['api_key'] = apiKey;
    if (sessionId != null) query['session_id'] = sessionId;
    if (guestSessionId != null) query['guest_session_id'] = guestSessionId;
    final res = await _dio.post(path, queryParameters: query, data: {'value': value});
    return RatingResponse.fromJson(res.data as Map<String, dynamic>);
  }
}