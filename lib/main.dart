import 'dart:async';

import 'package:app_links/app_links.dart';

import 'package:flutter/material.dart';
import 'package:miko/app_keeper.dart';
import 'package:miko/jackett/models/jackett_config.dart';
import 'package:miko/jackett/services/config_service.dart';
import 'package:miko/mycore/settings_service.dart';
import 'package:miko/providers/ai_chat_provider.dart';

import 'package:miko/providers/csv_detail_process_provider.dart';
import 'package:miko/providers/god_proovider.dart';
import 'package:miko/providers/settings_provider.dart';
import 'package:miko/services/user_data_service.dart'; // Import UserDataService
import 'package:miko/showcases/movie_detail_page_copy.dart';
import 'package:miko/showcases/movie_service.dart';
import 'package:miko/showcases/tv_detail_page_anime.dart';
import 'package:miko/utils/colors.dart';
import 'package:miko/yt-dlp/providers/settings_provider.dart';
import 'package:miko/yt-dlp/services/ytdlp_downloader_service.dart';
import 'package:provider/provider.dart';
import 'package:media_kit/media_kit.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as pr;
import 'package:hive_flutter/hive_flutter.dart' as h;
import 'dart:async';

import 'package:fl_lib/fl_lib.dart' as f;
import 'package:flutter/material.dart';
import 'package:miko/box/core/util/sync.dart';
import 'package:miko/box/data/model/chat/history/hive_adapter.dart';
import 'package:miko/box/data/res/build_data.dart';
import 'package:miko/box/data/res/openai.dart';
import 'package:miko/box/data/store/all.dart';
import 'package:miko/box/hive/hive_registrar.g.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:logging/logging.dart';

// This function must be a top-level function.
Future<void> main() async {


//await h.Hive.initFlutter();

  // Register all your adapters
  // IMPORTANT: Call this before the app runs
// 2. Create a provider so Riverpod can access the key
  _runInZone(() async {
    await _initApp();
    final settingsService = await StorageSettingsService.init();

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
 
    //ChangeNotifierProvider(
        //    create: (context) =>
        //        TMDBApiService()), // Initialize AnimeProvider directly
    //     ChangeNotifierProvider(
    //         create: (context) =>
    //             ad.MovieProvider()), // Initialize MovieProvider directly
    //     ChangeNotifierProvider(create: (context) => ad.TvSeriesProvider()),
        ChangeNotifierProvider(
            create: (context) => UserDataService()), // Add UserDataService
        ChangeNotifierProvider(create: (_) => ProcessingProvider()),

        ChangeNotifierProvider(create: (_) => TextToolProvider()),
        ChangeNotifierProvider(
            create: (context) => FloatingButtonVisibilityNotifier()),
      
ChangeNotifierProvider<StorageSettingsService>.value(
      value: settingsService,
    ),],

     child: const MyApp(), // Use const if MyApp is stateless
    ),
  );}  );}

void _runInZone(void Function() body) {
  final zoneSpec = ZoneSpecification(
    print: (_, parent, zone, line) => parent.print(zone, line),
  );

  runZonedGuarded(
    body,
    (e, s) => print('[ZONE] $e\n$s'),
    zoneSpecification: zoneSpec,
  );
}

Future<void> _initApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();

  await f.Paths.init(BuildData.name);
  await _initDb();

  _setupLogger();
  _initAppComponents();
}

Future<void> _initDb() async {
  await Hive.initFlutter();
  Hive.registerAdapters();
  // You are trying to register DateTimeAdapter (typeId 4) for type DateTime
  // but there is already a TypeAdapter for this type: DateTimeWithTimezoneAdapter (typeId 18).
  // Note that DateTimeAdapter will have no effect as DateTimeWithTimezoneAdapter takes precedence.
  // If you want to override the existing adapter, the typeIds must match.
  // Hive.registerAdapter(DateTimeAdapter()); // 4
  Hive.registerAdapter(ChatCompletionMessageToolCallAdapter()); // 9
  Hive.registerAdapter(ChatCompletionMessageFunctionCallAdapter()); // 10
    await f.PrefStore.shared.init();
  await Stores.init();
      await h.Hive.initFlutter();

    h.Hive.registerAdapter(JackettConfigAdapter());

  await h.Hive.openBox<JackettConfig>(ConfigService.boxName);

final container = pr.ProviderContainer();
  await container.read(ytdlpDownloaderServiceProvider).initialize();
  await container.read(settingsProvider.notifier).loadSettings();

}

void _setupLogger() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    f.DebugProvider.addLog(record);
    print(record);
    if (record.error != null) print(record.error);
    if (record.stackTrace != null) print(record.stackTrace);
  });
}

Future<void> _initAppComponents() async {
  f.UserApi.init();

  final sets = Stores.setting;
  final windowStateProp = sets.windowState;
  final windowState = windowStateProp.fetch();
  await f.SystemUIs.initDesktopWindow(
    hideTitleBar: sets.hideTitleBar.get(),
    size: windowState?.size,
    position: windowState?.position,
    listener: f.WindowStateListener(windowStateProp),
  );

  Cfg.applyClient();
  Cfg.updateModels();

  //  BakSync.instance.init();
  //  BakSync.instance.sync();

  //if (Stores.setting.joinBeta.get()) AppUpdate.chan = AppUpdateChan.beta;

  Stores.trash.autoDelete();
}

// ignore: must_be_immutable
class MyApp extends pr.ConsumerWidget {
  const MyApp({super.key});

  void loading(context) async {
    Provider.of<MovieProvider>(context, listen: false);
    Provider.of<TvSeriesProvider>(context, listen: false);
    Provider.of<AnimeProvider>(context, listen: false);

  }

  @override
  Widget build(BuildContext context, pr.WidgetRef ref) {
    // Scroll to the bottom after receiving a new message
    loading(context);

    return pr.ProviderScope(
      overrides: [
        settingsServiceProvider.overrideWith((ref) => settingsService),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
                  theme: AppThemes.netflixDarkTheme,
                  
                   home:  SplashScreen2(ref),

    ));
  }
}

class SplashScreen2 extends StatefulWidget {
  const SplashScreen2(pr.WidgetRef ref, {super.key});

  @override
  State<SplashScreen2> createState() => _SplashScreen2State();
}

class _SplashScreen2State extends State<SplashScreen2> {
    StreamSubscription? _sub;
    late final AppLinks _appLinks ;
 late  final Stream<Uri> _uriStream;

  @override
  void initState() {
    super.initState();
    debugPrint("Splash screen initialized");
        _initDeepLinking();

    _navigateToHome();
  }
 void _initDeepLinking() async {
    _appLinks = AppLinks();
    _uriStream = _appLinks.uriLinkStream;

    // Listen for incoming links (hot start)
    _uriStream.listen((Uri uri) {
      _handleDeepLink(uri);
    });

    // Check for cold start deep link
    final initialUri = await _appLinks.getInitialLink();
    if (initialUri != null) {
      _handleDeepLink(initialUri);
    }
  }

    void _handleDeepLink(Uri uri) async {
    final path = uri.path;
    final idStr = uri.queryParameters['id'];
    final id = int.tryParse(idStr ?? '');



    if (path == 'miko/movie' && id != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => MovieDetailPage(id: id),
        ),
      );
    } else     if (path == 'miko/series' && id != null) {
        final MovieService _movieService = MovieService();
        final tvs = await _movieService.getTvShowDetails(tvShowId: id);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => TvShowDetailPageAnime(tvShow: tvs,typec: "tvseries",),
        ),
      );
    }
  }
  Future<void> _navigateToHome() async {
    debugPrint("Waiting for 5 seconds before navigation...");
    await Future.delayed(const Duration(seconds: 5));
    if (!mounted) return;

    debugPrint("Navigating to home screen...");
    Navigator.of(
      context,
    ).pushReplacement(
        MaterialPageRoute(builder: (context) =>  SplashScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container());
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen( {super.key});

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
    ).pushReplacement(
        MaterialPageRoute(builder: (context) => const AppKeeper()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Lottie.asset("assets/splashlogo/data.json")),
    );
  }
}
