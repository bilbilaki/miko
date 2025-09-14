import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MovieCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String rating;
  final int indexNumber;
  final double width;
  final double height;
  final bool small;
  final VoidCallback? onTap; // Added onTap

  const MovieCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.rating,
    required this.indexNumber,
    this.width = 140,
    this.height = 190,
    this.small = false,
    this.onTap, // Initialize onTap
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(12);
    return GestureDetector( // Using GestureDetector for onTap
      onTap: onTap,
      child: SizedBox(
        width: width,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: width,
                  height: height,
                  decoration: BoxDecoration(
                    borderRadius: borderRadius,
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(imageUrl),
                      fit: BoxFit.cover,
                      onError: (error, stackTrace) => const Center(child: Icon(Icons.broken_image, color: Colors.white54)),
                    ),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black54, blurRadius: 6, offset: Offset(0, 3))
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Flexible(
                  child: Text(
                    title,
                    maxLines: small ? 1 : 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            // rating badge
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF1ED760),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, size: 12, color: Colors.black),
                    const SizedBox(width: 6),
                    Text(
                      rating,
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
            // large index number
            Positioned(
              bottom: small ? 28 : 40,
              left: 6,
              child: Text(
                indexNumber.toString(),
                style: TextStyle(
                  color: Colors.white.withOpacity(0.08),
                  fontSize: small ? 52 : 72,
                  fontWeight: FontWeight.bold,
                  height: 0.9,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}