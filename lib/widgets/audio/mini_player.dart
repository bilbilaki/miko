import 'dart:io';
import 'package:flutter/material.dart';
import 'package:miko/providers/audio_provider.dart';
import 'package:miko/screens/now_playing.dart';
import 'package:provider/provider.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final playbackState = context.watch<PlaybackStateProvider>();
    final playlistProvider = context.read<PlaylistProvider>();
    final song = playbackState.currentSong;

    if (song == null) {
      return const SizedBox.shrink();
    }

    // Smooth progress indicator
    final double progress =
        (playbackState.currentPosition.inMilliseconds > 0 &&
            playbackState.totalDuration.inMilliseconds > 0)
        ? playbackState.currentPosition.inMilliseconds /
              playbackState.totalDuration.inMilliseconds
        : 0.0;

    return GestureDetector(
      onTap: () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const NowPlayingScreen()));
      },
      child: Container(
        height: 65,
        color: const Color(0xFF2A2A2A),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child:
                        song.albumArtUrl != null && song.albumArtUrl!.isNotEmpty
                        ? Image.file(File(song.albumArtUrl!), fit: BoxFit.cover)
                        : Image.asset('assets/demo.png', fit: BoxFit.cover),
                  ),
                ),
                title: Text(
                  song.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  song.artist,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: IconButton(
                  icon: Icon(
                    playbackState.isPlaying ? Icons.pause : Icons.play_arrow,
                    size: 32,
                  ),
                  onPressed: playlistProvider.togglePlayPause,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              ),
            ),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[700],
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary,
              ),
              minHeight: 2.5,
            ),
          ],
        ),
      ),
    );
  }
}
