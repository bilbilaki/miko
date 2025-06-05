

// main.dart
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';


class DetailPage extends StatelessWidget {
  const DetailPage({super.key});
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    final imageUrl = args['image']!;
    final videoUrl = args['video']!;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Image.network(imageUrl, fit: BoxFit.cover),
          ),
          Expanded(
            flex: 3,
            child: VideoPlayerDetail(url: videoUrl),
          )
        ],
      ),
    );
  }
}

/// A simple full‐controller video player for the detail page

class VideoPlayerDetail extends StatefulWidget {
  final String url;
  const VideoPlayerDetail({super.key, required this.url});
  @override
  State<VideoPlayerDetail> createState() => _VideoPlayerDetailState();
}

class _VideoPlayerDetailState extends State<VideoPlayerDetail> {
  late final Player player = Player();
  // Create a [VideoController] instance from `package:media_kit_video`.
  late final VideoController controller = VideoController(player);
  @override
  void initState() {
    super.initState();
    player.open(
      Media(Uri.decodeComponent(widget.url)),
      play: true,
    );
    setState(() {});
    player.play();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Video(
        controller: controller,
        controls: null,
                    filterQuality: FilterQuality.high
      )
    ]);
  }
}
