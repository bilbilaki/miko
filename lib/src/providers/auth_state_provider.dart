import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miko/src/repositories/auth_repository.dart';
import 'package:miko/src/core/hive_manager.dart';
import 'package:miko/src/models/auth/session.dart';
import 'package:miko/src/models/auth/guest_session.dart';

import 'auth_providers.dart';

final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>(
  (ref) {
    final repo = ref.read(authRepositoryProvider);
    final hive = ref.read(hiveManagerProvider);
    return AuthStateNotifier(repo, hive);
  },
);

class AuthState {
  final String? sessionId;
  final bool loggedIn;
  final bool isGuest;

  AuthState({this.sessionId, required this.loggedIn, this.isGuest = false});

  AuthState copyWith({String? sessionId, bool? loggedIn, bool? isGuest}) {
    return AuthState(
      sessionId: sessionId ?? this.sessionId,
      loggedIn: loggedIn ?? this.loggedIn,
      isGuest: isGuest ?? this.isGuest,
    );
  }
}

class AuthStateNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repo;
  final HiveBoxManager _hive;

  AuthStateNotifier(this._repo, this._hive) : super(AuthState(loggedIn: false, isGuest: false)) {
    _load();
  }

  Future<void> _load() async {
    final saved = _hive.getJson('auth/session');
    if (saved != null && saved['session_id'] != null) {
      state = AuthState(sessionId: saved['session_id'] as String, loggedIn: true, isGuest: saved['is_guest'] == true);
    }
  }

  Future<void> signInGuest() async {
    final GuestSession? gs = await _repo.createGuestSession();
    if (gs != null) {
      await _hive.putJson('auth/session', {'session_id': gs.guestSessionId, 'expires_at': gs.expiresAt, 'is_guest': true});
      state = AuthState(sessionId: gs.guestSessionId, loggedIn: true, isGuest: true);
    } else {
      throw Exception('Guest session failed');
    }
  }

  Future<void> signInWithRequestToken(String requestToken) async {
    final SessionResponse? res = await _repo.createSession(requestToken);
    if (res != null) {
      await _hive.putJson('auth/session', {'session_id': res.sessionId, 'is_guest': false});
      state = AuthState(sessionId: res.sessionId, loggedIn: true, isGuest: false);
    } else {
      throw Exception('Session creation failed');
    }
  }

  Future<void> signOut() async {
    await _hive.putJson('auth/session', {'session_id': null});
    state = AuthState(sessionId: null, loggedIn: false, isGuest: false);
  }
}