import 'dart:io';
import 'package:flutter/material.dart';
import '../widgets/audio/lyrics_view.dart';
import 'package:miko/models/audio.dart';
import 'package:miko/providers/audio_provider.dart';
import 'package:provider/provider.dart';

class NowPlayingScreen extends StatefulWidget {
  const NowPlayingScreen({super.key});

  @override
  State<NowPlayingScreen> createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text("Now Playing"),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Playing'),
            Tab(text: 'Lyrics'),
          ],
          indicatorColor: Theme.of(context).colorScheme.primary,
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF414345), Color(0xFF121212)],
          ),
        ),
        child: SafeArea(
          child: TabBarView(
            controller: _tabController,
            children: [
              // Tab 1: Player UI
              const PlayerView(),
              // Tab 2: Lyrics UI
              LyricsView(tabController: _tabController),
            ],
          ),
        ),
      ),
    );
  }
}

// --- Extracted the original player UI into a private widget ---

class PlayerView extends StatelessWidget {
  const PlayerView();

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  Widget buildAlbumArt(AudioFileModel song, BuildContext context) {
    final albumArtUrl = song.albumArtUrl;
    Widget image;

    if (albumArtUrl == null) {
      image = Image.asset('assets/demo.png', fit: BoxFit.cover);
    } else if (albumArtUrl.startsWith('http')) {
      image = Image.network(albumArtUrl, fit: BoxFit.cover);
    } else if (albumArtUrl.startsWith('assets/')) {
      image = Image.asset(albumArtUrl, fit: BoxFit.cover);
    } else {
      image = Image.file(File(albumArtUrl), fit: BoxFit.cover);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: AspectRatio(aspectRatio: 1, child: image),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlaybackStateProvider>(
      builder: (context, playbackState, _) {
        final song = playbackState.currentSong;
        if (song == null) {
          return const Center(child: Text('No song selected.'));
        }

        return Padding(
          padding: const EdgeInsets.only(
            top: 16.0,
          ), // Add padding to avoid overlap with TabBar
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              buildAlbumArt(song, context),
              const SizedBox(height: 32),
              Text(
                song.title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                song.artist,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: Colors.white70),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              _buildSeekBar(context, playbackState),
              const SizedBox(height: 16),
              _buildControls(context),
              const SizedBox(height: 16),
              _buildExtraControls(context, song),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSeekBar(
    BuildContext context,
    PlaybackStateProvider playbackState,
  ) {
    final playlistProvider = context.read<PlaylistProvider>();
    double sliderValue = playbackState.currentPosition.inMilliseconds
        .toDouble();
    double maxSliderValue = playbackState.totalDuration.inMilliseconds
        .toDouble();
    if (sliderValue > maxSliderValue) {
      sliderValue = maxSliderValue;
    }

    return Column(
      children: [
        Slider(
          value: sliderValue,
          max: maxSliderValue > 0 ? maxSliderValue : 1.0,
          onChanged: (value) {
            playlistProvider.seek(value);
          },
          activeColor: Theme.of(context).colorScheme.primary,
          inactiveColor: Colors.white30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(_formatDuration(playbackState.currentPosition)),
            Text(_formatDuration(playbackState.totalDuration)),
          ],
        ),
      ],
    );
  }

  Widget _buildControls(BuildContext context) {
    final playlistProvider = context.read<PlaylistProvider>();
    final playbackState = context.watch<PlaybackStateProvider>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: const Icon(Icons.skip_previous, size: 36),
          onPressed: playlistProvider.playPrevious,
        ),
        IconButton(
          icon: Icon(
            playbackState.isPlaying
                ? Icons.pause_circle_filled
                : Icons.play_circle_filled,
            size: 72,
            color: Theme.of(context).colorScheme.primary,
          ),
          onPressed: playlistProvider.togglePlayPause,
        ),
        IconButton(
          icon: const Icon(Icons.skip_next, size: 36),
          onPressed: playlistProvider.playNext,
        ),
      ],
    );
  }

  Widget _buildExtraControls(BuildContext context, AudioFileModel song) {
    final settingsProvider = context.watch<AppSettingsProvider>();
    final likedSongsProvider = context.watch<LikedSongsProvider>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
          icon: const Icon(Icons.replay),
          onPressed: () => context.read<PlaylistProvider>().replayCurrentSong(),
        ),
        IconButton(
          icon: Icon(
            settingsProvider.shuffleMode == ShuffleMode.on
                ? Icons.shuffle_on
                : Icons.shuffle,
            color: settingsProvider.shuffleMode == ShuffleMode.on
                ? Theme.of(context).colorScheme.primary
                : Colors.white,
          ),
          onPressed: () => settingsProvider.toggleShuffleMode(),
        ),
        IconButton(
          icon: Icon(
            likedSongsProvider.isLiked(song)
                ? Icons.favorite
                : Icons.favorite_border,
            color: likedSongsProvider.isLiked(song)
                ? Colors.redAccent
                : Colors.white,
          ),
          onPressed: () => likedSongsProvider.toggleLike(song),
        ),
        IconButton(
          icon: Icon(
            _getLoopIcon(settingsProvider.loopMode),
            color: settingsProvider.loopMode != LoopMode.off
                ? Theme.of(context).colorScheme.primary
                : Colors.white,
          ),
          onPressed: () => settingsProvider.toggleLoopMode(),
        ),
      ],
    );
  }

  IconData _getLoopIcon(LoopMode mode) {
    switch (mode) {
      case LoopMode.off:
        return Icons.repeat;
      case LoopMode.all:
        return Icons.repeat;
      case LoopMode.one:
        return Icons.repeat_one;
    }
  }
}
