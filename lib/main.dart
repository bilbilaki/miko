import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:miko/app_keeper.dart';
import 'package:miko/providers/app_data_provider.dart';
import 'package:miko/providers/csv_detail_process_provider.dart';
import 'package:miko/providers/god_proovider.dart';
import 'package:miko/providers/settings_provider.dart';
import 'package:miko/services/user_data_service.dart'; // Import UserDataService
import 'package:miko/src/core/hive_manager.dart';
import 'package:miko/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:media_kit/media_kit.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as pr;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  final hiveManager = HiveBoxManager();
  await hiveManager.init();

  // Initialize a single AppDataManager instance after Hive has been initialized
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AnimeProvider(),
        ), // Initialize AnimeProvider directly
        ChangeNotifierProvider(
          create: (context) => MovieProvider(),
        ), // Initialize MovieProvider directly
        ChangeNotifierProvider(create: (context) => TvSeriesProvider()),

        ChangeNotifierProvider(
          create: (context) => UserDataService(),
        ), // Add UserDataService
        ChangeNotifierProvider(create: (_) => ProcessingProvider()),

        ChangeNotifierProvider(create: (_) => TextToolProvider()),
      ],

   child:    pr.ProviderScope(
  overrides: [
      hiveManagerProvider.overrideWithValue(hiveManager),
      // Provide the already-initialized instance so the app uses the same AppDataManager
              movieProvider.overrideWith((ref)=> MovieProvider()),
              tvSeriesProvider.overrideWith((ref)=> TvSeriesProvider()),
              animeProvider.overrideWith((ref)=> AnimeProvider()),
//              tvSeriesUnisqueseriesNameChangeNotifierProvider.overrideWith((ref)=> tvSe)

        settingsServiceProvider.overrideWith((ref) => settingsService),
  
      ],
      child:  MyApp(), // Use const if MyApp is stateless
    ),
  ));
}

// ignore: must_be_immutable
class MyApp extends pr.ConsumerWidget {
  MyApp({super.key});

  void loading(context) {
    Provider.of<MovieProvider>(context, listen: false);
    Provider.of<TvSeriesProvider>(context, listen: false);
    Provider.of<AnimeProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context, pr.WidgetRef ref) {
    // Scroll to the bottom after receiving a new message
    loading(context);

    return  MaterialApp(
        theme: AppThemes.netflixDarkTheme,

        home: SplashScreen2(ref),
    
    );
  }
}

class SplashScreen2 extends StatefulWidget {
  const SplashScreen2(pr.WidgetRef ref, {super.key});

  @override
  State<SplashScreen2> createState() => _SplashScreen2State();
}

class _SplashScreen2State extends State<SplashScreen2> {
  @override
  void initState() {
    super.initState();
    debugPrint("Splash screen initialized");

    _navigateToHome();
  }
  // Check for cold start deep link

  Future<void> _navigateToHome() async {
    debugPrint("Waiting for 5 seconds before navigation...");
    await Future.delayed(const Duration(seconds: 5));
    if (!mounted) return;

    debugPrint("Navigating to home screen...");
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (context) => SplashScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container());
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
    await Future.delayed(const Duration(seconds: 5));
    if (!mounted) return;

    debugPrint("Navigating to home screen...");
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const StartPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Lottie.asset("assets/splashlogo/data.json")),
    );
  }
}
