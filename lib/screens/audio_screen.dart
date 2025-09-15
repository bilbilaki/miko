import 'package:flutter/material.dart';

import 'package:miko/providers/audio_provider.dart';
import 'package:miko/providers/transcribe_provider.dart' show TranscriptionProviderSegmental;
import 'package:miko/screens/library_screen.dart';
import 'package:miko/screens/liked_songs_screen.dart';
import 'package:miko/services/audio_player.dart';
import 'package:miko/services/transcribe_persist_service.dart';
import 'package:miko/services/transcript_manager.dart';
import 'package:miko/services/transcription_service.dart';
import 'package:miko/services/user_data_service.dart';
import 'package:miko/widgets/audio/mini_player.dart';
import 'package:provider/provider.dart';

class AudioPlayer extends StatelessWidget {

   AudioPlayer({super.key});
UserDataService userDataService=UserDataService();
  @override
  Widget build(BuildContext context) {
    // We create instances of services here

    final audioPlayerService = AudioPlayerService();
    final fileScannerService = FileScannerService(userDataService.perfs);
    // New services
    final transcriptionService = TranscriptionService();
    final transcriptionCacheService = TranscriptionCacheService(userDataService.perfs);

    return MultiProvider(
      providers: [
        // --- Existing Providers ---
        ChangeNotifierProvider(create: (_) => AppSettingsProvider(userDataService.perfs)),
        ChangeNotifierProvider(
          create: (_) =>
              AudioFilesProvider(fileScannerService)..loadAudioFiles(),
        ),
        ChangeNotifierProvider(
          create: (_) => LikedSongsProvider(userDataService.perfs)..loadLikedSongs(),
        ),
        ChangeNotifierProvider(
          create: (context) => PlaylistProvider(
            audioPlayerService,
            context.read<AppSettingsProvider>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => PlaybackStateProvider(
            audioPlayerService,
            context.read<PlaylistProvider>(),
          ),
        ),

        // --- New Transcription Providers ---
        ChangeNotifierProvider(
          create: (_) =>
              TranscriptionProviderSegmental(service: transcriptionService),
        ),
        ChangeNotifierProxyProvider<
          PlaylistProvider,
          TranscriptionCacheProvider
        >(
          create: (context) => TranscriptionCacheProvider(
            transcriptionCacheService,
            context.read<PlaylistProvider>(),
          ),
          update: (_, playlistProvider, previousCacheProvider) =>
              TranscriptionCacheProvider(
                transcriptionCacheService,
                playlistProvider,
              ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: const Color(0xFF121212),
          colorScheme: const ColorScheme.dark(
            primary: Colors.greenAccent,
            secondary: Colors.tealAccent,
            surface: Color(0xFF1E1E1E),
            onSurface: Colors.white,
          ),
          textTheme: const TextTheme(
            titleLarge: TextStyle(fontWeight: FontWeight.bold),
            bodyMedium: TextStyle(color: Colors.white70),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    LibraryScreen(),
    LikedSongsScreen(),
    // Add more screens here for playlists, search etc.
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: _widgetOptions,
            ),
          ),
          // Conditionally show the MiniPlayer
          Consumer<PlaybackStateProvider>(
            builder: (context, playbackState, child) {
              return Visibility(
                visible: playbackState.currentSong != null,
                child: const MiniPlayer(),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.library_music),
            label: 'Library',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Liked'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Theme.of(context).colorScheme.surface,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.white54,
      ),
    );
  }
}
