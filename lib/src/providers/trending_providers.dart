import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import 'package:miko/src/core/dio_provider.dart';
import 'package:miko/src/core/hive_manager.dart';
import 'package:miko/src/repositories/trending_repository.dart';
import 'package:miko/src/repositories/trending_repository_impl.dart';
import 'package:miko/src/models/misc/trending_response.dart';

// Repository provider
final trendingRepositoryProvider = Provider<TrendingRepository>((ref) {
  final Dio dio = ref.read(dioProvider);
  final hive = ref.read(hiveManagerProvider);
  const apiKey = String.fromEnvironment('TMDB_API_KEY', defaultValue: '');
  return TrendingRepositoryImpl(dio, hive, apiKey: apiKey);
});

// Trending movies for the header (e.g., daily)
final trendingMoviesDayProvider = FutureProvider<TrendingResponse>((ref) async {
  final repo = ref.read(trendingRepositoryProvider);
  return repo.getTrendingMovies(timeWindow: 'day', page: 1);
});

// Top rated movies for "Top Hits Anime" (e.g., weekly trending movies)
final topRatedMoviesProvider = FutureProvider<TrendingResponse>((ref) async {
  final repo = ref.read(trendingRepositoryProvider);
  return repo.getTrendingMovies(timeWindow: 'week', page: 1); 
});

// TV Airing Today for "New Episode Releases" (e.g., daily trending TV)
final tvAiringTodayHomeProvider = FutureProvider<TrendingResponse>((ref) async {
  final repo = ref.read(trendingRepositoryProvider);
  return repo.getTrendingTv(timeWindow: 'day', page: 1); 
});