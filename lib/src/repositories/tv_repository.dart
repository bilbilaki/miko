import 'package:miko/src/models/tv/tv_lists.dart';
import 'package:miko/src/models/tv/tv_show_detail.dart';
import 'package:miko/src/models/tv/tv_credits.dart';

abstract class TvRepository {
  Future<TvListResponse> getPopular({int page = 1, bool forceRefresh = false});
  Future<TvListResponse> getTopRated({int page = 1, bool forceRefresh = false});
  Future<TvListResponse> getOnTheAir({int page = 1, bool forceRefresh = false});
  Future<TvListResponse> getAiringToday({int page = 1, bool forceRefresh = false});

  Future<TvShowDetail?> getTvShowDetail(int tvId, {bool forceRefresh = false});
  Future<TvCreditsResponse?> getTvCredits(int tvId, {bool forceRefresh = false});
}