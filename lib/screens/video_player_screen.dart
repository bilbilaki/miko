// lib/screens/video_player_screen.dart
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart'; // Required.
import 'package:media_kit_video/media_kit_video.dart'; // Required.
import 'dart:async';

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;
  final List? playlistitem;
  const VideoPlayerScreen({required this.videoUrl,this.playlistitem, super.key});

  @override
  State<VideoPlayerScreen> createState() => VideoPlayerScreenState();
}

class VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late final Player player = Player();
  late final VideoController controller = VideoController(player);

  bool isPiPEnabled = false;

  double subtitleSize = 32.0;
  Color subtitleColor = const Color.fromARGB(255, 238, 230, 5);
  bool showSubtitleControls = false;
  Timer? _hideTimer;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {});

    player.open(Media(Uri.decodeComponent(widget.videoUrl)),
        play: true); 

    player.stream.error.listen((error) {
      debugPrint('Player error: $error');
    });
  }


  String currentQuality = 'Auto';
  final List<String> qualityOptions = ['Auto', '1080p', '720p', '480p', '360p'];

  void _showSubtitleControls() {
    setState(() {
      showSubtitleControls = true;
    });

    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          showSubtitleControls = false;
        });
      }
    });
  }

  @override
  void dispose(){
    _hideTimer?.cancel();

 player.dispose();
    super.dispose();
  }
    final List<BoxFit> _fitOptions = [
    BoxFit.contain, // Standard
    BoxFit.cover,   // Fill/Crop
    BoxFit.fill,    // Stretch
    BoxFit.fitWidth,
    BoxFit.fitHeight,
  ];
  int _currentFitIndex = 0;
  BoxFit get _currentFit => _fitOptions[_currentFitIndex];
  // Map to hold icons for each fit mode for better UX
  final Map<BoxFit, IconData> _fitIcons = {
    BoxFit.contain: Icons.fullscreen_exit,
    BoxFit.cover: Icons.fullscreen,
    BoxFit.fill: Icons.photo_size_select_large,
    BoxFit.fitWidth: Icons.swap_horiz,
    BoxFit.fitHeight: Icons.swap_vert,
  };
  void _cycleBoxFit() {
    setState(() {
      _currentFitIndex = (_currentFitIndex + 1) % _fitOptions.length;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [],
      ),
      backgroundColor: Colors.black, 
      body: Stack(
        children: [
          Video(
            controller: controller,
            controls: AdaptiveVideoControls,
            fit: BoxFit.fill,
            filterQuality: FilterQuality.high,
            wakelock: true,
            subtitleViewConfiguration:  SubtitleViewConfiguration(
              visible: true,
              style: TextStyle(
                height: 1.4,
                fontSize: subtitleSize,
                letterSpacing: 0.0,
                wordSpacing: 0.0,
                color: subtitleColor,
                fontWeight: FontWeight.w700,
                backgroundColor: const Color(0xaa000000),
              ),
              padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 24.0),
            ),
          ),
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (showSubtitleControls)
                    Container(
                      width: 200,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: [
                          const Icon(Icons.text_fields,
                              color: Colors.white, size: 20),
                          Expanded(
                            child: Slider(
                              value: subtitleSize,
                              min: 16.0,
                              max: 48.0,
                              onChanged: (value) {
                                setState(() {
                                  subtitleSize = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                                     IconButton(
                  icon: Icon(_fitIcons[_currentFit] ?? Icons.aspect_ratio, color: Colors.white),
                  tooltip: 'Change display mode',
                  onPressed: _cycleBoxFit,
                ),
                  IconButton(
                    icon: const Icon(Icons.picture_in_picture_outlined,
                        color: Colors.white),
                    onPressed: () {
                      setState(() {
                        isPiPEnabled = !isPiPEnabled;
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings, color: Colors.white),
                    onPressed: _showSubtitleControls,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
