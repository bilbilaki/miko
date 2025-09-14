import 'package:miko/src/models/search/search_multi_response.dart';

abstract class SearchRepository {
  Future<SearchMultiResponse> searchMulti(String query, {int page = 1, bool forceRefresh = false});
}