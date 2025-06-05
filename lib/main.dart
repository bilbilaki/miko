import 'package:flutter/material.dart';
import 'package:media_cache_manager/media_cache_manager.dart';
import 'package:miko/app.dart';
import 'package:miko/providers/anime_provider.dart';
import 'package:miko/providers/settings_provider.dart';
import 'package:miko/services/user_data_service.dart'; // Import UserDataService
import 'package:miko/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:miko/app_shell.dart';
import 'package:miko/providers/movie_provider.dart';
import 'package:miko/providers/tv_series_provider.dart';
import 'package:media_kit/media_kit.dart';
import 'router.dart';
import 'package:tmdb_flutter/tmdb_flutter.dart';
import 'constants.dart' as c;
import 'package:lottie/lottie.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as pr;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  MediaKit.ensureInitialized();
  await MediaCacheManager.instance.init();
  // Hive.registerAdapter(MovieAdapter()); // Remove or comment out if this was for the old model
  TmdbFlutter.init(apiKey: c.AppConstants.tmdbapikey);

  // Initialize Hive and register adapters

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => DrawerState()),
        ChangeNotifierProvider(
            create: (context) =>
                AnimeProvider()), // Initialize AnimeProvider directly
        ChangeNotifierProvider(
            create: (context) =>
                MovieProvider()), // Initialize MovieProvider directly
        ChangeNotifierProvider(create: (context) => TvSeriesProvider()),

        ChangeNotifierProvider(
            create: (context) => UserDataService()), // Add UserDataService

        ChangeNotifierProvider(create: (_) => SearchProvider()),
        ChangeNotifierProvider(create: (_) => TitleDetailsProvider()),
      ],
      child: MyApp(), // Use const if MyApp is stateless
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  late MovieProvider _movieProvider;
  late TvSeriesProvider _tvProvider;
  late AnimeProvider _animeProvider;

  @override
  Widget build(BuildContext context) {
    _movieProvider = Provider.of<MovieProvider>(context, listen: false);
    _tvProvider = Provider.of<TvSeriesProvider>(context, listen: false);
    _animeProvider = Provider.of<AnimeProvider>(context, listen: false);
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
    await Future.delayed(const Duration(seconds: 5));
    if (!mounted) return;

    debugPrint("Navigating to home screen...");
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (context) => Xmiko()));
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
