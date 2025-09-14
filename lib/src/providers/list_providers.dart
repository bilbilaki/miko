import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import 'package:miko/src/core/dio_provider.dart';
import 'package:miko/src/core/hive_manager.dart';

import 'package:miko/src/repositories/list_repository.dart';
import 'package:miko/src/repositories/list_repository_impl.dart';

import 'package:miko/src/models/movie/list_details.dart';
import 'package:miko/src/models/auth/list_action_response.dart';

// Repository provider
final listRepositoryProvider = Provider<ListRepository>((ref) {
  final Dio dio = ref.read(dioProvider);
  final hive = ref.read(hiveManagerProvider);
  const apiKey = String.fromEnvironment('TMDB_API_KEY', defaultValue: '');
  return ListRepositoryImpl(dio, hive, apiKey: apiKey);
});

// Get list details
class ListDetailsNotifier extends FamilyAsyncNotifier<MovieListDetails, int> {
  @override
  Future<MovieListDetails> build(int listId) async {
    final repo = ref.read(listRepositoryProvider);
    final details = await repo.getListDetails(listId);
    if (details == null) throw Exception('List not found');
    return details;
  }
}

final listDetailsProvider = AsyncNotifierProvider.family<ListDetailsNotifier, MovieListDetails, int>(ListDetailsNotifier.new);

// Add item action (returns ListActionResponse)
final addItemToListProvider = Provider.family<Future<ListActionResponse?>, Map<String, dynamic>>((ref, args) {
  // args: {'listId': int, 'mediaId': int, 'sessionId': String}
  final repo = ref.read(listRepositoryProvider);
  return repo.addItemToList(args['listId'] as int, args['mediaId'] as int, sessionId: args['sessionId'] as String);
});

// Remove item action
final removeItemFromListProvider = Provider.family<Future<ListActionResponse?>, Map<String, dynamic>>((ref, args) {
  // args: {'listId': int, 'mediaId': int, 'sessionId': String}
  final repo = ref.read(listRepositoryProvider);
  return repo.removeItemFromList(args['listId'] as int, args['mediaId'] as int, sessionId: args['sessionId'] as String);
});

// Create list action
final createListProvider = Provider.family<Future<ListActionResponse?>, Map<String, dynamic>>((ref, args) {
  // args: {'name': String, 'description': String, 'language': String?, 'sessionId': String}
  final repo = ref.read(listRepositoryProvider);
  return repo.createList(
    args['name'] as String,
    args['description'] as String,
    language: args['language'] as String? ?? 'en',
    sessionId: args['sessionId'] as String,
  );
});