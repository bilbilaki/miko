import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import 'package:miko/src/core/dio_provider.dart';
import 'package:miko/src/core/hive_manager.dart';

import 'package:miko/src/repositories/tv_repository.dart';
import 'package:miko/src/repositories/tv_repository_impl.dart';

import 'package:miko/src/models/tv/tv_lists.dart';
import 'package:miko/src/models/tv/tv_show_detail.dart';
import 'package:miko/src/models/tv/tv_credits.dart';

// Repository provider
final tvRepositoryProvider = Provider<TvRepository>((ref) {
  final Dio dio = ref.read(dioProvider);
  final hive = ref.read(hiveManagerProvider);
  const apiKey = String.fromEnvironment('TMDB_API_KEY', defaultValue: '');
  return TvRepositoryImpl(dio, hive, apiKey: apiKey);
});

// Popular TV
class TvPopularNotifier extends FamilyAsyncNotifier<TvListResponse, int> {
  @override
  Future<TvListResponse> build(int page) async {
    final repo = ref.read(tvRepositoryProvider);
    return repo.getPopular(page: page);
  }
}

final tvPopularProvider = AsyncNotifierProvider.family<TvPopularNotifier, TvListResponse, int>(TvPopularNotifier.new);

// Top Rated TV
class TvTopRatedNotifier extends FamilyAsyncNotifier<TvListResponse, int> {
  @override
  Future<TvListResponse> build(int page) async {
    final repo = ref.read(tvRepositoryProvider);
    return repo.getTopRated(page: page);
  }
}

final tvTopRatedProvider = AsyncNotifierProvider.family<TvTopRatedNotifier, TvListResponse, int>(TvTopRatedNotifier.new);

// On The Air
class TvOnTheAirNotifier extends FamilyAsyncNotifier<TvListResponse, int> {
  @override
  Future<TvListResponse> build(int page) async {
    final repo = ref.read(tvRepositoryProvider);
    return repo.getOnTheAir(page: page);
  }
}

final tvOnTheAirProvider = AsyncNotifierProvider.family<TvOnTheAirNotifier, TvListResponse, int>(TvOnTheAirNotifier.new);

// Airing Today
class TvAiringTodayNotifier extends FamilyAsyncNotifier<TvListResponse, int> {
  @override
  Future<TvListResponse> build(int page) async {
    final repo = ref.read(tvRepositoryProvider);
    return repo.getAiringToday(page: page);
  }
}

final tvAiringTodayProvider = AsyncNotifierProvider.family<TvAiringTodayNotifier, TvListResponse, int>(TvAiringTodayNotifier.new);

// TV Detail
class TvDetailNotifier extends FamilyAsyncNotifier<TvShowDetail, int> {
  @override
  Future<TvShowDetail> build(int tvId) async {
    final repo = ref.read(tvRepositoryProvider);
    final detail = await repo.getTvShowDetail(tvId);
    if (detail == null) throw Exception('TV show detail not found');
    return detail;
  }
}

final tvDetailProvider = AsyncNotifierProvider.family<TvDetailNotifier, TvShowDetail, int>(TvDetailNotifier.new);

// TV Credits
class TvCreditsNotifier extends FamilyAsyncNotifier<TvCreditsResponse, int> {
  @override
  Future<TvCreditsResponse> build(int tvId) async {
    final repo = ref.read(tvRepositoryProvider);
    final credits = await repo.getTvCredits(tvId);
    if (credits == null) throw Exception('TV credits not found');
    return credits;
  }
}

final tvCreditsProvider = AsyncNotifierProvider.family<TvCreditsNotifier, TvCreditsResponse, int>(TvCreditsNotifier.new);