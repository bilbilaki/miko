// File: lib/src/providers/movie_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import 'package:miko/src/core/dio_provider.dart';
import 'package:miko/src/core/hive_manager.dart';
import 'package:miko/src/models/movie/movie_credits.dart';

import 'package:miko/src/repositories/movie_repository.dart';
import 'package:miko/src/repositories/movie_repository_impl.dart';

import 'package:miko/src/models/movie/movie_list_response.dart';
import 'package:miko/src/models/movie/movie_detail.dart';

// Repository provider
final movieRepositoryProvider = Provider<MovieRepository>((ref) {
 final Dio dio = ref.read(dioProvider);
 final hive = ref.read(hiveManagerProvider);
 const apiKey = String.fromEnvironment('TMDB_API_KEY', defaultValue: '');
 return MovieRepositoryImpl(dio, hive, apiKey: apiKey);
});

// Now Playing
class NowPlayingNotifier extends FamilyAsyncNotifier<MovieListResponse, int> {
 @override
 Future<MovieListResponse> build(int page) async {
 final repo = ref.read(movieRepositoryProvider);
 return repo.getNowPlaying(page: page);
 }
}

final nowPlayingProvider = AsyncNotifierProvider.family<NowPlayingNotifier, MovieListResponse, int>(NowPlayingNotifier.new);

// Popular
class PopularNotifier extends FamilyAsyncNotifier<MovieListResponse, int> {
 @override
 Future<MovieListResponse> build(int page) async {
 final repo = ref.read(movieRepositoryProvider);
 return repo.getPopular(page: page);
 }
}

final popularProvider = AsyncNotifierProvider.family<PopularNotifier, MovieListResponse, int>(PopularNotifier.new);

// Top Rated
class TopRatedNotifier extends FamilyAsyncNotifier<MovieListResponse, int> {
 @override
 Future<MovieListResponse> build(int page) async {
 final repo = ref.read(movieRepositoryProvider);
 return repo.getTopRated(page: page);
 }
}

final topRatedProvider = AsyncNotifierProvider.family<TopRatedNotifier, MovieListResponse, int>(TopRatedNotifier.new);

// Upcoming
class UpcomingNotifier extends FamilyAsyncNotifier<MovieListResponse, int> {
 @override
 Future<MovieListResponse> build(int page) async {
 final repo = ref.read(movieRepositoryProvider);
 return repo.getUpcoming(page: page);
 }
}

final upcomingProvider = AsyncNotifierProvider.family<UpcomingNotifier, MovieListResponse, int>(UpcomingNotifier.new);

// Movie Detail
class MovieDetailNotifier extends FamilyAsyncNotifier<MovieDetail, int> {
 @override
 Future<MovieDetail> build(int movieId) async {
 final repo = ref.read(movieRepositoryProvider);
 final detail = await repo.getMovieDetail(movieId);
 if (detail == null) throw Exception('Movie detail not found');
 return detail;
 }
}

final movieDetailProvider = AsyncNotifierProvider.family<MovieDetailNotifier, MovieDetail, int>(MovieDetailNotifier.new);

// Movie Credits
class MovieCreditsNotifier extends FamilyAsyncNotifier<MovieCredits, int> {
 @override
 Future<MovieCredits> build(int movieId) async {
 final repo = ref.read(movieRepositoryProvider);
 final credits = await repo.getMovieCredits(movieId);
 if (credits == null) throw Exception('Movie credits not found');
 return credits;
 }
}

final movieCreditsProvider = AsyncNotifierProvider.family<MovieCreditsNotifier, MovieCredits, int>(MovieCreditsNotifier.new);