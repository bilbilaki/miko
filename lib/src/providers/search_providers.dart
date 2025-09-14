import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import 'package:miko/src/core/dio_provider.dart';
import 'package:miko/src/core/hive_manager.dart';

import 'package:miko/src/repositories/search_repository.dart';
import 'package:miko/src/repositories/search_repository_impl.dart';

import 'package:miko/src/models/search/search_multi_response.dart';

// Repository provider
final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  final Dio dio = ref.read(dioProvider);
  final hive = ref.read(hiveManagerProvider);
  const apiKey = String.fromEnvironment('TMDB_API_KEY', defaultValue: '');
  return SearchRepositoryImpl(dio, hive, apiKey: apiKey);
});

// Search multi
class SearchMultiNotifier extends FamilyAsyncNotifier<SearchMultiResponse, Map<String, dynamic> > {
  @override
  Future<SearchMultiResponse> build(Map<String, dynamic> args) async {
    // args: {'query': String, 'page': int}
    final repo = ref.read(searchRepositoryProvider);
    final query = args['query'] as String;
    final page = args['page'] as int? ?? 1;
    return repo.searchMulti(query, page: page);
  }
}

final searchMultiProvider = AsyncNotifierProvider.family<SearchMultiNotifier, SearchMultiResponse, Map<String, dynamic>>(SearchMultiNotifier.new);