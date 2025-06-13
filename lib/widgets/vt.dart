// import 'dart:io' show Platform;
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:media_kit/media_kit.dart';
// import 'package:media_kit_video/media_kit_video.dart';
// import 'package:miko/screens/video_player_screen.dart';
// import 'package:miko/widgets/v.dart';

// /// 2) Tile widget

// class PosterGridWithPreview extends StatefulWidget {
//   final List<Map<String, Object>> items;
//   const PosterGridWithPreview({required this.items, super.key});

//   @override
//   State<PosterGridWithPreview> createState() => _PosterGridWithPreviewState();
// }

// class _PosterGridWithPreviewState extends State<PosterGridWithPreview> {
//   int? previewingIndex;
//   late final Player player = Player();
//   // Create a [VideoController] instance from `package:media_kit_video`.
//   late final VideoController controller = VideoController(player);

//   @override
//   void initState() {
//     super.initState();
//     // Move permission check to after widget is fully initialized
//     WidgetsBinding.instance.addPostFrameCallback((_) {});

//     // Open the video URL.

//     // Add error handling
//     player.stream.error.listen((error) {
//       debugPrint('Player error: $error');
//       // You might want to show a snackbar or dialog here
//     });
//   }

//   @override
//   void dispose() {
//     _stopAndDispose();
//     super.dispose();
//   }

//   void _startPreview(int idx, String videoUrl) async {
//     if (previewingIndex == idx) return;
//     _stopAndDispose();
//     setState(() {
//       previewingIndex = idx;
//       player.open(Media(Uri.decodeComponent(videoUrl)),
//           play: true); // Start playing immediately
//     });
//     player!.play();
//     setState(() {});
//   }

//   void _stopAndDispose() {
//     player?.pause();
//     player?.dispose();
//     previewingIndex = null;
//   }

//   bool get _isMobile => !kIsWeb && (Platform.isAndroid || Platform.isIOS);

//   @override
//   Widget build(BuildContext context) {
//     return MasonryGridView.count(
//       crossAxisCount: 3,
//       mainAxisSpacing: 4,
//       crossAxisSpacing: 4,
//       itemCount: widget.items.length,
//       itemBuilder: (ctx, idx) {
//         final it = widget.items[idx];
//         return _GridPosterTile(
//           n: it['n'] as int,
//           imageUrl: it['image'] as String,
//           previewUrl: it['preview'] as String,
//           streamUrl: it['stream'] as String,
//           isPreviewing: previewingIndex == idx,
//           controller: controller,
//           onHoverStart: () {
//             if (!_isMobile) _startPreview(idx, it['preview'] as String);
//           },
//           onHoverEnd: () {
//             if (!_isMobile) _stopAndDispose();
//           },
//           onTap: () {
//             if (_isMobile) {
//               HapticFeedback.mediumImpact();
//               _startPreview(idx, it['preview'] as String);
//             } else {
//               // On desktop, go to player immediately.
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => VideoPlayerScreen(
//                         videoUrl: it['stream']
//                             .toString()), // Use it['stream'] as the video URL
//                   ));
//             }
//           },
//           onTapPoster: () {
//             Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => VideoPlayerScreen(
//                       videoUrl: it['stream']
//                           .toString()), // Use it['stream'] as the video URL
//                 ));
//           },
//         );
//       },
//     );
//   }
// }

// class _GridPosterTile extends StatelessWidget {
//   final int n;
//   final String imageUrl;
//   final String previewUrl;
//   final String streamUrl;
//   final bool isPreviewing;
//   final VideoController controller;
//   final VoidCallback onHoverStart;
//   final VoidCallback onHoverEnd;
//   final VoidCallback onTap;
//   final VoidCallback onTapPoster;

//   const _GridPosterTile({
//     required this.n,
//     required this.imageUrl,
//     required this.previewUrl,
//     required this.streamUrl,
//     required this.isPreviewing,
//     required this.controller,
//     required this.onHoverStart,
//     required this.onHoverEnd,
//     required this.onTap,
//     required this.onTapPoster,
//   });

//   @override
//   Widget build(BuildContext context) {
//     Widget poster = GestureDetector(
//       onTap: onTapPoster,
//       child: Image.network(
//         imageUrl,
//         fit: BoxFit.cover,
//         width: double.infinity,
//         height: 170,
//         errorBuilder: (c, e, s) => Container(
//           color: Colors.grey[800],
//           height: 170,
//         ),
//       ),
//     );

//     Widget previewWidget= VideoPlayerDetail( url: previewUrl);

//     Widget tileContent = Stack(
//       fit: StackFit.passthrough,
//       alignment: Alignment.center,
//       children: [
//         previewWidget,
//         if (!isPreviewing) const SizedBox(), // For hit test
//       ],
//     );

//     return MouseRegion(
//       onEnter: (_) => onHoverStart(),
//       onExit: (_) => onHoverEnd(),
//       child: GestureDetector(
//         onTap: onTap,
//         child: tileContent,
//       ),
//     );
//   }
// }

// /// 2) Tile widget
