import 'package:miko/src/models/misc/trending_response.dart';

abstract class TrendingRepository {
  Future<TrendingResponse> getTrendingAll({String timeWindow = 'day', int page = 1, bool forceRefresh = false});
  Future<TrendingResponse> getTrendingMovies({String timeWindow = 'day', int page = 1, bool forceRefresh = false});
  Future<TrendingResponse> getTrendingTv({String timeWindow = 'day', int page = 1, bool forceRefresh = false});
}