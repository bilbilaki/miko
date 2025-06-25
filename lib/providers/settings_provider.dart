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
  // The SettingsService constructor calls _init() which loads preferences
  // and potentially fetches initial models if implemented there.
  return UserDataService();
});

// --- Derived Providers for Specific Settings ---
// These rebuild only when the specific value changes, potentially more efficient
// Provides the list of model IDs fetched via the custom URL in SettingsService
// final showAdultProvider = Provider<bool>((ref) {
//   final settingsService = ref.watch(settingsServiceProvider);
//   return settingsService.showAdult;
// });

// final themeModeProvider = Provider<ThemeMode>((ref) {
//   final settingsService = ref.watch(settingsServiceProvider);
//   return settingsService.themeMode;
// });

// final gridSizeProvider = Provider<int>((ref) {
//   final settingsService = ref.watch(settingsServiceProvider);
//   return settingsService.gridSize;
// });

// final downloaderPackageProvider = Provider<String>((ref) {
//   final settingsService = ref.watch(settingsServiceProvider);
//   return settingsService.downloaderPackage;
// });

// final externalPlayerPackageProvider = Provider<String>((ref) {
//   final settingsService = ref.watch(settingsServiceProvider);
//   return settingsService.externalPlayerPackage;
// });

// final defaultPageProvider = Provider<String>((ref) {
//   final settingsService = ref.watch(settingsServiceProvider);
//   return settingsService.defaultPage;
// });
final rightSidebarCollapsedProvider = StateProvider<bool>((ref) => false);
final sidebarCollapsedProvider = StateProvider<bool>((ref) => false);
