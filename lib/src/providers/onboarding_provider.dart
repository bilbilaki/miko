import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miko/src/core/hive_manager.dart';

final onboardingStatusProvider = FutureProvider<bool>((ref) async {
  final hive = ref.read(hiveManagerProvider);
  final data = hive.getJson('onboarding/status');
  // If stored and seen true => true, otherwise false
  if (data == null) return false;
  return data['seen'] == true;
});

final onboardingControllerProvider = Provider<OnboardingController>((ref) {
  final hive = ref.read(hiveManagerProvider);
  return OnboardingController(hive);
});

class OnboardingController {
  final HiveBoxManager _hive;
  OnboardingController(this._hive);

  Future<void> markSeen() async {
    await _hive.putJson('onboarding/status', {'seen': true});
  }

  Future<void> saveInterests(List<String> interests) async {
    await _hive.putJson('onboarding/interests', {'interests': interests});
  }

  Future<List<String>?> loadInterests() async {
    final data = _hive.getJson('onboarding/interests');
    if (data == null) return null;
    final list = data['interests'];
    if (list is List) return List<String>.from(list);
    return null;
  }
}