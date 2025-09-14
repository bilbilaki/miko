import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/user_data_service.dart';
final container = ProviderContainer();
final settingsService = container.read(settingsServiceProvider);
final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) async {
  debugPrint('Initializing SharedPreferences');
  return await SharedPreferences.getInstance();
});
final setsettingsService = settingsServiceProvider.overrideWith(
  (ref) => settingsService,
);

final settingsServiceProvider = ChangeNotifierProvider<UserDataService>((ref) {
  return UserDataService();
});

final rightSidebarCollapsedProvider = StateProvider<bool>((ref) => true);
final sidebarCollapsedProvider = StateProvider<bool>((ref) => true);




// class FloatingButtonVisibilityNotifier extends ChangeNotifier {
//   bool _isVisible = true; // Default to visible

//   bool get isVisible => _isVisible;

//   void show() {
//     if (!_isVisible) {
//       _isVisible = true;
//       notifyListeners(); // Notify widgets that are listening
//     }
//   }

//   void hide() {
//     if (_isVisible) {
//       _isVisible = false;
//       notifyListeners(); // Notify widgets that are listening
//     }
//   }
// }