import 'package:miko/src/models/movie/list_details.dart';
import 'package:miko/src/models/auth/list_action_response.dart';

abstract class ListRepository {
  Future<MovieListDetails?> getListDetails(int listId, {bool forceRefresh = false});
  Future<ListActionResponse?> addItemToList(int listId, int mediaId, {required String sessionId});
  Future<ListActionResponse?> removeItemFromList(int listId, int mediaId, {required String sessionId});
  Future<ListActionResponse?> createList(String name, String description, {String language = 'en', required String sessionId});
}