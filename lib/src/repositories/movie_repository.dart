import 'package:miko/src/models/movie/movie_credits.dart';
import 'package:miko/src/models/movie/movie_detail.dart';
import 'package:miko/src/models/movie/movie_list_response.dart';

abstract class MovieRepository {
  Future<MovieListResponse> getNowPlaying({int page = 1, bool forceRefresh = false});
  Future<MovieListResponse> getPopular({int page = 1, bool forceRefresh = false});
  Future<MovieListResponse> getTopRated({int page = 1, bool forceRefresh = false});
  Future<MovieListResponse> getUpcoming({int page = 1, bool forceRefresh = false});

  Future<MovieDetail?> getMovieDetail(int movieId, {bool forceRefresh = false});
  Future<MovieCredits?> getMovieCredits(int movieId, {bool forceRefresh = false});
}