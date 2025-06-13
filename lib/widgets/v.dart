// // main.dart
// import 'package:flutter/material.dart';
// import 'package:media_kit/media_kit.dart';
// import 'package:media_kit_video/media_kit_video.dart';

// /// A simple full‐controller video player for the detail page

// class VideoPlayerDetail extends StatefulWidget {
//   final String url;
//   const VideoPlayerDetail({super.key, required this.url});
//   @override
//   State<VideoPlayerDetail> createState() => _VideoPlayerDetailState();
// }

// class _VideoPlayerDetailState extends State<VideoPlayerDetail> {
//   late final Player player = Player();
//   // Create a [VideoController] instance from `package:media_kit_video`.
//   late final VideoController controller = VideoController(player);
//   @override
//   void initState() {
//     super.initState();
//     player.open(
//       Media(Uri.decodeComponent(widget.url)),
//       play: true,
//     );
//     setState(() {});
//     player.play();
//   }

//   @override
//   void dispose() {
//     player.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(children: [
//       Video(
//           controller: controller,
//           controls: null,
//           filterQuality: FilterQuality.high)
//     ]);
//   }
// }

// class ParallaxRecipe extends StatelessWidget {
//   const ParallaxRecipe({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           for (final location in locations)
//             LocationListItem(
//               imageUrl: location.imageUrl,
//               name: location.name,
//               country: location.place,
//             ),
//         ],
//       ),
//     );
//   }
// }

// @immutable
// class LocationListItem extends StatelessWidget {
//   const LocationListItem({
//     super.key,
//     required this.imageUrl,
//     required this.name,
//     required this.country,
//   });

//   final String imageUrl;
//   final String name;
//   final String country;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//       child: AspectRatio(
//         aspectRatio: 16 / 9,
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(16),
//           child: Stack(
//             children: [
//               _buildParallaxBackground(context),
//               _buildGradient(),
//               _buildTitleAndSubtitle(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildParallaxBackground(BuildContext context) {
//     return Positioned.fill(child: Image.network(imageUrl, fit: BoxFit.cover));
//   }

//   Widget _buildGradient() {
//     return Positioned.fill(
//       child: DecoratedBox(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Colors.transparent, Colors.black.withValues(alpha: 0.7)],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             stops: const [0.6, 0.95],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTitleAndSubtitle() {
//     return Positioned(
//       left: 20,
//       bottom: 20,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             name,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           Text(
//             country,
//             style: const TextStyle(color: Colors.white, fontSize: 14),
//           ),
//         ],
//       ),
//     );
//   }

//  Widget _buildParallaxBackground(BuildContext context) {
//     return Flow(
//       delegate: ParallaxFlowDelegate(),
//       children: [Image.network(imageUrl, fit: BoxFit.cover)],
//     );
//   }
// }
// class ParallaxFlowDelegate extends FlowDelegate {
//   ParallaxFlowDelegate();

//   @override
//   BoxConstraints getConstraintsForChild(int i, BoxConstraints constraints) {
//     // TODO: We'll add more to this later.
//   }

//   @override
//   void paintChildren(FlowPaintingContext context) {
//     // TODO: We'll add more to this later.
//   }

//   @override
//   bool shouldRepaint(covariant FlowDelegate oldDelegate) {
//     // TODO: We'll add more to this later.
//     return true;
//   }
// }
