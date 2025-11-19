import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:miko/app_keeper.dart';
import 'package:miko/configs/consts2.dart';
import 'package:miko/models/cache.dart';
import 'package:miko/providers/csv_detail_process_provider.dart';
import 'package:miko/providers/local_library_provider.dart';
import 'package:miko/providers/god_proovider.dart';
import 'package:miko/providers/local_provider.dart';
import 'package:miko/providers/settings_provider.dart';
import 'package:miko/screens/dl.dart';

import 'package:miko/services/user_data_service.dart'; // Import UserDataService
import 'package:miko/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:media_kit/media_kit.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as pr;
import 'package:tmdb_api/tmdb_api.dart';
final persistentCache = PersistentTranslationCache(ttl: Duration(days: 365), maxEntries: 5000);
final downloadManager = DownloadListManager();
TMDB tmdb = TMDB(ApiKeys(tmdbapiv3, tmdbapitokensc));
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

  // Initialize a single AppDataManager instance after Hive has been initialized
await persistentCache.init(); // at app startup
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
        ChangeNotifierProvider(create: (context) => LocalProvider()),
        ChangeNotifierProvider(create: (context) => LocalLibraryProvider()),


        ChangeNotifierProvider(
          create: (context) => UserDataService(),
        ), // Add UserDataService
        ChangeNotifierProvider(create: (_) => ProcessingProvider()),

        ChangeNotifierProvider(create: (_) => TextToolProvider()),
      ],

   child:    pr.ProviderScope(
  overrides: [
      // Provide the already-initialized instance so the app uses the same AppDataManager
              // movieProvider.overrideWith((ref)=> MovieProvider()),
              // tvSeriesProvider.overrideWith((ref)=> TvSeriesProvider()),
              // animeProvider.overrideWith((ref)=> AnimeProvider()),
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
  }

  @override
  Widget build(BuildContext context, pr.WidgetRef ref) {
    
    tmdb = TMDB(ApiKeys(tmdbapiv3, tmdbapitokensc),baseUrl: UserDataService().tmdbBaseUrl);
    // Scroll to the bottom after receiving a new message
    loading(context);

    return  MaterialApp(
      debugShowCheckedModeBanner: false,
        
        theme: AppThemes.netflixDarkTheme,

        home: SplashScreen(),
    
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

    debugPrint("Navigating to DataLoadingScreen...");
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const DataLoadingScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Lottie.asset("assets/splashlogo/data.json")),
    );
  }
}

class DataLoadingScreen extends StatefulWidget {
  const DataLoadingScreen({super.key});

  @override
  State<DataLoadingScreen> createState() => _DataLoadingScreenState();
}

class _DataLoadingScreenState extends State<DataLoadingScreen> {
  late AnimeProvider _animeProvider;
  late MovieProvider _movieProvider;
  late TvSeriesProvider _tvSeriesProvider;

  int _animeCount = 0;
  int _animeEpisodeCount = 0;
  int _movieCount = 0;
  int _tvSeriesCount = 0;
  int _tvEpisodeCount = 0;

  bool _animeLoaded = false;
  bool _movieLoaded = false;
  bool _tvSeriesLoaded = false;
  
  Timer? _pollTimer;
  bool _loadingStarted = false;

  @override
  void initState() {
    super.initState();
    _animeProvider = Provider.of<AnimeProvider>(context, listen: false);
    _movieProvider = Provider.of<MovieProvider>(context, listen: false);
    _tvSeriesProvider = Provider.of<TvSeriesProvider>(context, listen: false);

    // Add listeners to providers for real-time updates
    _animeProvider.addListener(_updateCounts);
    _movieProvider.addListener(_updateCounts);
    _tvSeriesProvider.addListener(_updateCounts);

    // Also poll frequently to catch any updates we might miss
    _pollTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      _updateCounts();
    });

    // Get initial state
    _updateCounts();

    _startLoading();
  }

  void _updateCounts() {
    if (mounted) {
      setState(() {
        _animeCount = _animeProvider.masterList.length;
        _animeEpisodeCount = _getTotalAnimeEpisodes();
        _movieCount = _movieProvider.masterList.length;
        _tvSeriesCount = _tvSeriesProvider.masterList.length;
        _tvEpisodeCount = _getTotalTvEpisodes();

        _animeLoaded = _animeProvider.isInitialized;
        _movieLoaded = _movieProvider.isInitialized;
        _tvSeriesLoaded = _tvSeriesProvider.isInitialized;

        // Debug prints
        if (!_loadingStarted || (_animeCount > 0 || _movieCount > 0 || _tvSeriesCount > 0)) {
          debugPrint("Anime: $_animeCount series, $_animeEpisodeCount episodes (loaded: $_animeLoaded)");
          debugPrint("Movies: $_movieCount (loaded: $_movieLoaded)");
          debugPrint("TV Series: $_tvSeriesCount series, $_tvEpisodeCount episodes (loaded: $_tvSeriesLoaded)");
        }
      });
    }
  }

  void _startLoading() async {
    debugPrint("Starting data load...");
    debugPrint("Initial state - Anime initialized: ${_animeProvider.isInitialized}, TV initialized: ${_tvSeriesProvider.isInitialized}, Movies initialized: ${_movieProvider.isInitialized}");
    debugPrint("Initial status - Anime: ${_animeProvider.status}, TV: ${_tvSeriesProvider.status}, Movies: ${_movieProvider.status}");
    
    _loadingStarted = true;
    
    // Wait for all providers to reach 'loaded' status
    // The providers are singletons and already started loading in their constructors
    while (!mounted || 
           _animeProvider.status != LoadingStatus.loaded ||
           _movieProvider.status != LoadingStatus.loaded ||
           _tvSeriesProvider.status != LoadingStatus.loaded) {
      if (!mounted) return;
      
      // Update counts during loading
      _updateCounts();
      
      // Check every 100ms
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Break if there's an error
      if (_animeProvider.status == LoadingStatus.error ||
          _movieProvider.status == LoadingStatus.error ||
          _tvSeriesProvider.status == LoadingStatus.error) {
        debugPrint("Error loading data!");
        break;
      }
    }

    // Stop the polling timer
    _pollTimer?.cancel();

    debugPrint("All data loaded!");
    debugPrint("Final counts - Anime: ${_animeProvider.masterList.length}, Movies: ${_movieProvider.masterList.length}, TV Series: ${_tvSeriesProvider.masterList.length}");

    // Final update to ensure we have the latest counts
    _updateCounts();

    // Wait 2 seconds to let user see the final counts
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Navigate to main app
    debugPrint("Data loading complete. Navigating to StartPage...");
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const StartPage()),
    );
  }

  int _getTotalAnimeEpisodes() {
    int totalEpisodes = 0;
    for (final anime in _animeProvider.masterList) {
      for (final season in anime.seasons) {
        totalEpisodes += season.episodes.length;
      }
    }
    return totalEpisodes;
  }

  int _getTotalTvEpisodes() {
    int totalEpisodes = 0;
    for (final series in _tvSeriesProvider.masterList) {
      for (final season in series.seasons) {
        totalEpisodes += season.episodes.length;
      }
    }
    return totalEpisodes;
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _animeProvider.removeListener(_updateCounts);
    _movieProvider.removeListener(_updateCounts);
    _tvSeriesProvider.removeListener(_updateCounts);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool allLoaded = _animeLoaded && _movieLoaded && _tvSeriesLoaded;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.black,
              Colors.grey[900]!,
              Colors.black,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Title
              Text(
                'Loading Content',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Please wait while we load your media library...',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[400],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 60),

              // Anime Loading Card
              _buildLoadingCard(
                title: 'Anime Series',
                icon: Icons.movie_filter,
                count: _animeCount,
                episodeCount: _animeEpisodeCount,
                isLoaded: _animeLoaded,
                color: Colors.red,
              ),
              const SizedBox(height: 20),

              // Movies Loading Card
              _buildLoadingCard(
                title: 'Movies',
                icon: Icons.local_movies,
                count: _movieCount,
                episodeCount: null,
                isLoaded: _movieLoaded,
                color: Colors.blue,
              ),
              const SizedBox(height: 20),

              // TV Series Loading Card
              _buildLoadingCard(
                title: 'TV Series',
                icon: Icons.tv,
                count: _tvSeriesCount,
                episodeCount: _tvEpisodeCount,
                isLoaded: _tvSeriesLoaded,
                color: Colors.green,
              ),
              const SizedBox(height: 60),

              // Overall Progress
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  children: [
                    LinearProgressIndicator(
                      value: allLoaded ? 1.0 : null,
                      backgroundColor: Colors.grey[800],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        allLoaded ? Colors.green : Colors.red,
                      ),
                      minHeight: 8,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      allLoaded
                          ? 'Loading Complete!'
                          : 'Loading data from CSV files...',
                      style: TextStyle(
                        fontSize: 16,
                        color: allLoaded ? Colors.green : Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingCard({
    required String title,
    required IconData icon,
    required int count,
    required int? episodeCount,
    required bool isLoaded,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[900]?.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isLoaded ? color : Colors.grey[700]!,
          width: 2,
        ),
        boxShadow: [
          if (isLoaded)
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 2,
            ),
        ],
      ),
      child: Row(
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 32,
            ),
          ),
          const SizedBox(width: 20),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$count ${count == 1 ? 'item' : 'items'}',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                if (episodeCount != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    '$episodeCount episodes',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Status Indicator
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isLoaded ? Colors.green : Colors.orange,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isLoaded ? Icons.check : Icons.hourglass_empty,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
