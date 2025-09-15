// lib/ui/library_screen.dart
import 'package:flutter/material.dart';
import 'package:miko/providers/audio_provider.dart';
import 'package:miko/screens/now_playing.dart';
import 'package:miko/widgets/audio/song_list_tile.dart';
import 'package:provider/provider.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final audioFilesProvider = Provider.of<AudioFilesProvider>(context);
    final playlistProvider = Provider.of<PlaylistProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Library'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: audioFilesProvider.allAudioFiles.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No music found.'),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.folder_open),
                    label: const Text('Scan for Music'),
                    onPressed: () => audioFilesProvider.scanAndImportAudioFiles(context),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: audioFilesProvider.allAudioFiles.length,
              itemBuilder: (context, index) {
                final song = audioFilesProvider.allAudioFiles[index];
                return SongListTile(
                  song: song,
                  onTap: () {
                    // Start playing from the full library list
                    playlistProvider.setPlaylist(
                        audioFilesProvider.allAudioFiles, index);
                    // Navigate to Now Playing screen
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => const NowPlayingScreen(),
                    ));
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => audioFilesProvider.scanAndImportAudioFiles(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}