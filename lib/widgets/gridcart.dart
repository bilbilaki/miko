// Can be in its own file, e.g., 'interactive_video_card.dart'

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:miko/screens/grid.dart';
import 'package:miko/utils/utils.dart';

import '../screens/video_player_screen.dart'; // We will create this next

class InteractiveVideoCard extends StatefulWidget {
  final Scene scene;
  const InteractiveVideoCard({required this.scene, super.key});

  @override
  State<InteractiveVideoCard> createState() => _InteractiveVideoCardState();
}

class _InteractiveVideoCardState extends State<InteractiveVideoCard> {
  // Use media_kit Player
  bool _isPlayingPreview = false;
  late final Player player = Player();
  // Create a [VideoController] instance from `package:media_kit_video`.
  late final VideoController controller = VideoController(player);

  @override
  void initState() {
    super.initState();
    // Create a player instance.
    // Mute the preview video and set it to loop.
    player.setVolume(30.0);
    // Open the preview URL but don't start playing yet.
    // _startPreview();
  }

  @override
  void dispose() {
    // IMPORTANT: Dispose the player to free up resources.
    tVheavy();
    player.dispose();
    super.dispose();
  }

  void _startPreview() async {
    tVheavy();
    await player.open(Media(widget.scene.preview), play: false);

    if (mounted) {
      setState(() => _isPlayingPreview = true);
      player.play();
    }
  }

  void _stopPreview() async {
    tVheavy();
    if (mounted) {
      await player.pause();

      // Optional: Rewind the video to the beginning
      setState(() => _isPlayingPreview = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // We use both GestureDetector and MouseRegion to handle mobile and web/desktop.
    return GestureDetector(
      // On tap, navigate to the full-screen player.
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => VideoPlayerScreen(
              videoUrl: widget.scene.stream,
            ),
          ),
        );
      },
      // On long press, start the preview (for touch devices).
      onLongPressStart: (_) {
        tVmedium();
        _startPreview();
      },
      // When long press ends, stop the preview.
      onLongPressEnd: (_) {
        tVmedium();

        _stopPreview();
      },
      onLongPressCancel: () {
        tVmedium();

        _stopPreview();
      },
      child: MouseRegion(
        // On hover, start the preview (for mouse devices).
        onEnter: (_) => _startPreview(),
        // When hover ends, stop the preview.
        onExit: (_) => _stopPreview(),
        child: Card(
          //   elevation: _isPlayingPreview ? 12 : 2, // More elevation when active
          //      margin: EdgeInsets.zero,
          clipBehavior: Clip
              .antiAlias, // Ensures the video stays within the card's rounded corners
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          ),
          child: AspectRatio(
              aspectRatio: 2 / 3,
              // Use a ternary operator to switch between the video and the image
              child: SizedBox(
                child: _isPlayingPreview
                    ? Video(
                        controller: controller,
                        fit: BoxFit.cover,
                        controls: null,
                      )
                    : Stack(
                        fit: StackFit.expand,
                        children: [
                          CachedNetworkImage(
                            imageUrl: widget.scene.screenshot,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                Container(color: const Color.fromARGB(255, 0, 0, 0)),
                            errorWidget: (context, url, error) => const Center(
                              child: Icon(Icons.no_adult_content),
                            ),
                          ),
                          // Optional: Add a subtle play icon over the poster
                        ],
                      ),
              )),
        ),
      ),
    );
  }
}
