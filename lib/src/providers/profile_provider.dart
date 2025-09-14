import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miko/src/core/hive_manager.dart';
import 'package:miko/src/models/appmodels/profile_model.dart';

final profileProvider = StateNotifierProvider<ProfileNotifier, UserProfile?>((ref) {
  final hive = ref.read(hiveManagerProvider);
  return ProfileNotifier(hive);
});

class ProfileNotifier extends StateNotifier<UserProfile?> {
  final HiveBoxManager _hive;
  ProfileNotifier(this._hive) : super(null) {
    _load();
  }

  void _load() {
    final data = _hive.getJson('user/profile');
    if (data != null) {
      state = UserProfile.fromJson(data);
    }
  }

  Future<void> save(UserProfile profile) async {
    state = profile;
    await _hive.putJson('user/profile', profile.toJson());
  }

  Future<void> clear() async {
    state = null;
    await _hive.putJson('user/profile', {});
  }
}