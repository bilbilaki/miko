import 'package:miko/src/models/auth/guest_session.dart';
import 'package:miko/src/models/auth/session.dart';
import 'package:miko/src/models/auth/account.dart';
import 'package:miko/src/models/auth/account_states.dart';
import 'package:miko/src/models/misc/rating_response.dart';

abstract class AuthRepository {
  Future<GuestSession?> createGuestSession();
  Future<SessionResponse?> createSession(String requestToken);
  Future<AccountDetails?> getAccountDetails({required String sessionId});
  Future<AccountStates?> getAccountStates(String mediaType, int mediaId, {required String sessionId});
  Future<RatingResponse?> rateMovie(int movieId, double value, {String? sessionId, String? guestSessionId});
}