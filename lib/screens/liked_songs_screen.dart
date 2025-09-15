// lib/ui/liked_songs_screen.dart
import 'package:flutter/material.dart';

import 'package:miko/providers/audio_provider.dart';
import 'package:miko/screens/now_playing.dart';
import 'package:miko/widgets/audio/song_list_tile.dart';
import 'package:provider/provider.dart';

class LikedSongsScreen extends StatelessWidget {
  const LikedSongsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final likedSongsProvider = Provider.of<LikedSongsProvider>(context);
    final playlistProvider = Provider.of<PlaylistProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Liked Songs'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: likedSongsProvider.likedSongs.isEmpty
          ? const Center(child: Text('You haven\'t liked any songs yet.'))
          : ListView.builder(
              itemCount: likedSongsProvider.likedSongs.length,
              itemBuilder: (context, index) {
                final song = likedSongsProvider.likedSongs[index];
                return SongListTile(
                  song: song,
                  onTap: () {
                    // Start playing from the liked songs list
                    playlistProvider.setPlaylist(
                        likedSongsProvider.likedSongs, index);
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => const NowPlayingScreen(),
                    ));
                  },
                );
              },
            ),
    );
  }
}