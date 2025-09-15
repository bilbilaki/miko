// lib/ui/widgets/song_list_tile.dart
import 'package:flutter/material.dart';
import 'package:miko/models/audio.dart';
import 'package:miko/screens/now_playing.dart';

class SongListTile extends StatelessWidget {
  final AudioFileModel song;
  final VoidCallback onTap;

  const SongListTile({super.key, required this.song, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(4.0),
        child: SizedBox(width: 50, height: 50, child: PlayerView().buildAlbumArt(song,context)),
      ),
      title: Text(song.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white)),
      subtitle: Text(song.artist,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70)),
      onTap: onTap,
      trailing: IconButton(
        icon: const Icon(Icons.more_vert, color: Colors.white70),
        onPressed: () {
          // TODO: Implement options menu (add to playlist, etc.)
        },
      ),
    );
  }
}