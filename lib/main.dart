import 'dart:io';

import 'package:flutter/material.dart';
import 'package:media_cache_manager/media_cache_manager.dart';
import 'package:miko/app_keeper.dart';
import 'package:miko/providers/anime_provider.dart';
import 'package:miko/providers/csv_detail_process_provider.dart';
import 'package:miko/providers/loca_provider.dart';
import 'package:miko/providers/settings_provider.dart';
import 'package:miko/services/user_data_service.dart'; // Import UserDataService
import 'package:miko/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:media_kit/media_kit.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as pr;

import 'package:sqflite_common_ffi/sqflite_ffi.dart' as ffi;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

 MediaKit.ensureInitialized();
  await MediaCacheManager.instance.init();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    ffi.sqfliteFfiInit();
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) =>
                AnimeProvider()), // Initialize AnimeProvider directly
        ChangeNotifierProvider(
            create: (context) =>
                MovieProvider()), // Initialize MovieProvider directly
        ChangeNotifierProvider(create: (context) => TvSeriesProvider()),

        ChangeNotifierProvider(
            create: (context) => UserDataService()), // Add UserDataService
        ChangeNotifierProvider(create: (_) => LocalProvider()),
        ChangeNotifierProvider(create: (_) => 
ProcessingProvider()),
ChangeNotifierProvider(create: (_) => TextToolProvider()),
      
      ],
      child: MyApp(), // Use const if MyApp is stateless
    ),
  );
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<MovieProvider>(context, listen: false);
    Provider.of<TvSeriesProvider>(context, listen: false);
    Provider.of<AnimeProvider>(context, listen: false);
    return pr.ProviderScope(
      overrides: [
        settingsServiceProvider.overrideWith((ref) => settingsService),
      ],
      child:
          MaterialApp(theme: AppThemes.netflixDarkTheme, home: SplashScreen()),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    debugPrint("Splash screen initialized");

    _navigateToHome();
  }

  Future<void> _navigateToHome() async {
    debugPrint("Waiting for 5 seconds before navigation...");
    await Future.delayed(Duration(seconds: 5));
    if (!mounted) return;

    debugPrint("Navigating to home screen...");
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (context) => AppKeeper()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Lottie.asset("assets/splashlogo/data.json")),
    );
  }
}

// class MyApp extends StatelessWidget {
//   MyApp({super.key}); // Make const
//   late MovieProvider _movieProvider;
//   late TvSeriesProvider _tvProvider;
//   late AnimeProvider _animeProvider;
//   @override
//   Widget build(BuildContext context) {
//     _movieProvider = Provider.of<MovieProvider>(context, listen: false);
//     _tvProvider = Provider.of<TvSeriesProvider>(context, listen: false);
//     _animeProvider = Provider.of<AnimeProvider>(context, listen: false);
//     // Wrap with the DrawerState Provider
//     return ChangeNotifierProvider(
//         create: (context) => DrawerState(),
//         child: MaterialApp.router(
//           theme: AppThemes.darkTheme,
//           darkTheme: AppThemes.darkTheme,
//           themeMode: ThemeMode.dark, // Follows system theme
//           debugShowCheckedModeBanner: false,
//           routerConfig: router,
//         ));
//   }
// }


//TODO  build some functions for a little get random sorting item to app 
//TODO  build functions for get all episodes of series to player and player shoould can play next and pervius episodes without need to close and save that in played item history