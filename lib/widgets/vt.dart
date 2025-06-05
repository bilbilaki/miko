// main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:miko/screens/video_player_screen.dart';

class TileWidget extends StatefulWidget {
  final String imageUrl;
  final String videoUrl;
  final String streamUrl;
  final int n;
  const TileWidget(
      {super.key,
      required this.imageUrl,
      required this.videoUrl,
      required this.streamUrl,
      required this.n});

  @override
  State<TileWidget> createState() => _TileWidgetState();
}

class _TileWidgetState extends State<TileWidget> {
  late final Player player = Player();
  // Create a [VideoController] instance from `package:media_kit_video`.
  late final VideoController controller = VideoController(player);
  bool _hovering = false;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {});

    // Open the video URL.
    player.open(
      Media(Uri.decodeComponent(widget.videoUrl)),
      play: true,
    );
    // We delay initialize until first hover to save resources:
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  Future<void> _initVideo() async {
    if (!_initialized) {
      setState(() => _initialized = true);
    }
  }

  void _onHoverEnter(PointerEnterEvent _) async {
    _hovering = true;
    await _initVideo();
    player.play();
    setState(() {});
  }

  void _onHoverExit(PointerExitEvent _) {
    _hovering = false;
    player.pause();
    setState(() {});
    player.dispose();
    super.dispose();
  }

  void _onTap() {
     Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => VideoPlayerScreen(videoUrl: widget.streamUrl,), // Pass movie ID
                ));
  
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: _onHoverEnter,
      onExit: _onHoverExit,
      child: GestureDetector(
        onTap: _onTap,
        child: Container(
          color: Colors.grey[900],
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Stack(
              children: [
                // 1) Default: Image
                AnimatedOpacity(
                  opacity: _hovering ? 0 : 1,
                  duration: const Duration(milliseconds: 200),
                  child: Image.network(
                    widget.imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
                // 2) On hover: Video
                if (_initialized)
                  AnimatedOpacity(
                    opacity: _hovering ? 1 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Video(controller: controller,
                    controls: null,
                    filterQuality: FilterQuality.high
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 3) Detail page (when a tile is clicked)
