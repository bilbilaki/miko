import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miko/app_keeper.dart';
import 'utils/colors.dart';
class Xmiko extends ConsumerWidget {
  // Use ConsumerWidget
  Xmiko({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Add WidgetRef
    // Watch the theme mode provider
    final themeMode = ThemeData.dark;
    //settingsService.themeMode;
    // final gridSize =
    // final downloaderPackage = ref.watch(downloaderPackageProvider);
    // final externalPlayerPackage = ref.watch(externalPlayerPackageProvider);
    // final defaultPage = ref.watch(defaultPageProvider);

    return MaterialApp(
      //themeMode: themeMode, // Set theme mode dynamically
      // Define Light Theme
      theme: AppThemes.netflixDarkTheme,

      // Define Dark Theme
      darkTheme: AppThemes.netflixDarkTheme,
      // Define Fantasy Theme
      highContrastDarkTheme: AppThemes.netflixDarkTheme,
      // Home Page
      home: const AppKeeper(),
      debugShowCheckedModeBanner: false,
    );
  }
}