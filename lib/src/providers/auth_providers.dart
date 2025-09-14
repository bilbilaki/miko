import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import 'package:miko/src/core/dio_provider.dart';
import 'package:miko/src/core/hive_manager.dart';

import 'package:miko/src/repositories/auth_repository.dart';
import 'package:miko/src/repositories/auth_repository_impl.dart';

import 'package:miko/src/models/auth/guest_session.dart';
import 'package:miko/src/models/auth/session.dart';
import 'package:miko/src/models/auth/account.dart';
import 'package:miko/src/models/auth/account_states.dart';
import 'package:miko/src/models/misc/rating_response.dart';

// Repository provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final Dio dio = ref.read(dioProvider);
  final hive = ref.read(hiveManagerProvider);
  const apiKey = String.fromEnvironment('TMDB_API_KEY', defaultValue: '');
  return AuthRepositoryImpl(dio, hive, apiKey: apiKey);
});

// Create guest session
final guestSessionProvider = FutureProvider<GuestSession?>((ref) async {
  final repo = ref.read(authRepositoryProvider);
  return repo.createGuestSession();
});

// Create session from request token
final createSessionProvider = Provider.family<Future<SessionResponse?>, String>((ref, requestToken) {
  final repo = ref.read(authRepositoryProvider);
  return repo.createSession(requestToken);
});

// Account details
class AccountDetailsNotifier extends FamilyAsyncNotifier<AccountDetails, String> {
  @override
  Future<AccountDetails> build(String sessionId) async {
    final repo = ref.read(authRepositoryProvider);
    final details = await repo.getAccountDetails(sessionId: sessionId);
    if (details == null) throw Exception('Account not found');
    return details;
  }
}

final accountDetailsProvider = AsyncNotifierProvider.family<AccountDetailsNotifier, AccountDetails, String>(AccountDetailsNotifier.new);

// Account states for a media item
final accountStatesProvider = Provider.family<Future<AccountStates?>, Map<String, dynamic>>((ref, args) {
  // args: {'mediaType': String, 'mediaId': int, 'sessionId': String}
  final repo = ref.read(authRepositoryProvider);
  return repo.getAccountStates(args['mediaType'] as String, args['mediaId'] as int, sessionId: args['sessionId'] as String);
});

// Rate movie
final rateMovieProvider = Provider.family<Future<RatingResponse?>, Map<String, dynamic>>((ref, args) {
  // args: {'movieId': int, 'value': double, 'sessionId': String? , 'guestSessionId': String?}
  final repo = ref.read(authRepositoryProvider);
  return repo.rateMovie(
    args['movieId'] as int,
    (args['value'] as num).toDouble(),
    sessionId: args['sessionId'] as String?,
    guestSessionId: args['guestSessionId'] as String?,
  );
});