// File: lib/src/core/dio_provider.dart

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miko/src/consts.dart';

final dioProvider = Provider<Dio>((ref) {
 final options = BaseOptions(
      baseUrl: 'https://db.inosuke.sbs/3',
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      responseType: ResponseType.json,
      followRedirects: true,
      // Let Dio give you the body even on 4xx to see TMDB messages
      validateStatus: (status) => status != null && status < 500,
      receiveDataWhenStatusError: true,
      headers: {
        'Accept': 'application/json',
        // DO NOT set Authorization here for TMDB proxy.
      },
    );

    final dio = Dio(options);

    // Remove any app/global Authorization header for the proxy host ONLY
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (options.uri.host == 'db.inosuke.sbs') {
            options.headers.remove('Authorization'); // critical
          }
          handler.next(options);
        },
      ),
    );

    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
        ),
      );
    }

    return dio;
  });