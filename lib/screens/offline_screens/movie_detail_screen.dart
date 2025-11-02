// lib/screens/tv_series_grid_screen.dart
// Added for Platform.isAndroid

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:miko/providers/god_proovider.dart';
import 'package:miko/screens/video_player_wplaylist_screen.dart';
import 'package:miko/services/user_data_service.dart';
import 'package:miko/utils/utils.dart';
//import 'package:miko/showcases/tv_detail_page_anime.dart';
import 'package:provider/provider.dart';
// Ensure correct provider import
import 'package:miko/utils/colors.dart';

class MovieDetailsScreen extends StatelessWidget {
   int movieId;
   String typec;
   MovieDetailsScreen(
      {required this.typec, required this.movieId, super.key});

  // Helper function for haptic feedback

  // --- Function to show Trailer Selection Dialog ---

  @override
  Widget build(BuildContext context) {
    // Find the movie using the provider
    var movie = Provider.of<MovieProvider>(context, listen: false)
        .getMovieById(movieId);

    // Fetch UserDataService
    var userDataService = Provider.of<UserDataService>(context);
    bool isFavorite = userDataService.isFavoriteMovie(movieId);

    if (movie == null) {
      return Scaffold(
        backgroundColor: AppColors.primaryBackground,
        appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
        body: const Center(
          child: Text('Movie not found!',
              style: TextStyle(color: AppColors.secondaryText)),
        ),
      );
    }
// NotificationListener<ScrollNotification>(
//         onNotification: (ScrollNotification scrollInfo) {
//           if (scrollInfo is ScrollUpdateNotification) {
//             _triggerHapticFeedback(); // Haptic feedback on scroll drag
//           }
//           return false;
//         },
//         child:
    String? backdropUrl = movie.getBackdropUrl();
    String? posterUrl = movie.getPosterUrl();
    List<String>? downloadLinks = movie.getDownloadLinksList();
    bool isInWatchlist = userDataService.isOnWatchlistMovie(movieId);
    bool isWatched = userDataService.isWatchedEpisode(
        movieId, movieId, movieId, downloadLinks.toString());
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0, // Height of the backdrop
            pinned: true, // Keep AppBar visible when scrolling up
            backgroundColor: const Color.fromARGB(255, 71, 43, 91),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                movie.title,
                style: const TextStyle(
                    color: AppColors.primaryText,
                    fontSize: 16.0,
                    shadows: [Shadow(blurRadius: 4, color: Colors.black54)]),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              centerTitle: false, // Align title to start
              titlePadding:
                  const EdgeInsets.only(left: 60, bottom: 16), // Adjust padding
              background: backdropUrl != null
                  ? Stack(fit: StackFit.expand, children: [
                      CachedNetworkImage(
                        filterQuality: FilterQuality.high,
                        imageUrl: backdropUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 1,
                            color: AppColors.accentColor,
                          ),
                        ),
                        errorWidget: (context, url, error) => Center(
                          child: posterUrl != null
                              ? CachedNetworkImage(
                                  filterQuality: FilterQuality.high,
                                  imageUrl: posterUrl,
                                  fit: BoxFit.contain, // Fallback to poster
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 1,
                                      color: AppColors.accentColor,
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Center(
                                    child: Icon(
                                      Icons.image_not_supported_outlined,
                                      color: AppColors.secondaryText,
                                      size: 30,
                                    ),
                                  ),
                                  fadeInDuration:
                                      const Duration(milliseconds: 300),
                                  fadeOutDuration:
                                      const Duration(milliseconds: 100),
                                )
                              : const Icon(Icons.movie_outlined,
                                  size: 100, color: AppColors.secondaryText),
                        ),
                        fadeInDuration: const Duration(milliseconds: 300),
                        fadeOutDuration: const Duration(milliseconds: 100),
                      ),
                      // Add a gradient overlay for better title readability
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.2),
                                AppColors.primaryBackground.withOpacity(0.9),
                                AppColors.primaryBackground,
                              ],
                              stops: const [
                                0.0,
                                0.5,
                                0.9,
                                1.0
                              ]),
                        ),
                      ),
                      // Add the Positioned widget for favorite, rating, and watchlist
                      Positioned(
                        top: 8.0,
                        right: 8.0,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Favorite
                            IconButton(
                              icon: Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isFavorite ? Colors.red : Colors.white,
                                size: 20,
                              ),
                              onPressed: () async {
                                await userDataService
                                    .toggleFavoriteMovie(movieId);
                                tVClick();
                                // Show snackbar feedback
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      isFavorite
                                          ? 'Removed from Favorites'
                                          : 'Added to Favorites',
                                    ),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              },
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.black.withOpacity(0.5),
                                padding: const EdgeInsets.all(4.0),
                              ),
                            ),
                            const SizedBox(width: 4),
                            // Rating bubble
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6.0, vertical: 4.0),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: Text(
                                '${movie.voteAverage.toStringAsFixed(1)}/10', // Display rating
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryText,
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),

                            IconButton(
                              icon: Icon(
                                isInWatchlist
                                    ? Icons.bookmark
                                    : Icons.bookmark_border,
                                color:
                                    isInWatchlist ? Colors.green : Colors.white,
                                size: 20,
                              ),
                              onPressed: () async {
                                await userDataService
                                    .toggleWatchlistMovie(movieId);
                                tVClick();
                                // Show snackbar feedback
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      isInWatchlist
                                          ? 'Removed from Watchlist'
                                          : 'Added to Watchlist',
                                    ),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              },
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.black.withOpacity(0.5),
                                padding: const EdgeInsets.all(4.0),
                              ),
                            ),
                          ],
                        ),
                      )
                    ])
                  : Container(
                      color: AppColors.secondaryBackground,
                      child: Center(
                          child: Text(movie.title,
                              style: const TextStyle(
                                  color: AppColors.primaryText,
                                  fontSize: 24)))),
            ),
            // Optional: Add subtle border when pinned
            bottom: PreferredSize(
                // Add this code to get bottom border
                preferredSize:
                    const Size.fromHeight(1.0), // Creates the border size
                child: Container(
                  // Creates the border container
                  color: AppColors.dividerColor.withOpacity(0.5),
                  height: 1.0,
                )),
          ),

          // --- Movie Content Below AppBar ---
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Title and Basic Info Row ---
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    // Small Poster on the side
                    SizedBox(
                      width: 100,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: posterUrl != null
                            ? CachedNetworkImage(
                                filterQuality: FilterQuality.high,
                                imageUrl: posterUrl,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 1,
                                    color: AppColors.accentColor,
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Center(
                                  child: Icon(
                                    Icons.image_not_supported_outlined,
                                    color: AppColors.secondaryText,
                                    size: 30,
                                  ),
                                ),
                                fadeInDuration:
                                    const Duration(milliseconds: 200),
                                fadeOutDuration:
                                    const Duration(milliseconds: 100),
                              )
                            : const Center(
                                child: Icon(
                                  Icons.tv_off_outlined,
                                  color: AppColors.secondaryText,
                                  size: 40,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(movie.title,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              // color: Colors.white,
                              letterSpacing: 1.5,
                              height: 1.2,
                              shadows: [
                                Shadow(
                                  offset: Offset(2, 2),
                                  blurRadius: 8,
                                  color: Colors.black.withOpacity(0.8),
                                ),
                                Shadow(
                                  offset: Offset(-1, -1),
                                  blurRadius: 4,
                                  color: Colors.purple.withOpacity(0.3),
                                ),
                                Shadow(
                                  offset: Offset(0, 0),
                                  blurRadius: 20,
                                  color: Colors.cyan.withOpacity(0.4),
                                ),
                              ],
                              foreground: Paint()
                                ..shader = const LinearGradient(
                                  colors: [
                                    Color(0xFFFF6B6B),
                                    Color(0xFF4ECDC4),
                                    Color(0xFF45B7D1),
                                    Color(0xFF96CEB4),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ).createShader(
                                    const Rect.fromLTWH(0, 0, 300, 100)),
                            )),
                        ...[
                          const SizedBox(height: 4),
                          Text(
                            movie.tagline!,
                            style: const TextStyle(
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                                color: AppColors.secondaryText),
                          ),
                        ],
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today,
                                size: 16, color: AppColors.secondaryText),
                            const SizedBox(width: 4),
                            Text(
                                movie.releaseDate != null
                                    ? DateFormat('yyyy')
                                        .format(movie.releaseDate!)
                                    : 'N/A',
                                style: const TextStyle(
                                    color: AppColors.secondaryText)),
                            const SizedBox(width: 10),
                            if (movie.runtime != null) ...[
                              const Icon(Icons.timer_outlined,
                                  size: 16, color: AppColors.secondaryText),
                              const SizedBox(width: 4),
                              Text('${movie.runtime} min',
                                  style: const TextStyle(
                                      color: AppColors.secondaryText)),
                            ]
                          ],
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          // Display Genres as chips
                          spacing: 6.0,
                          runSpacing: 4.0,
                          children: movie.genres
                              .map((genre) => Chip(
                                    label: Text(genre,
                                        style: const TextStyle(fontSize: 11)),
                                    backgroundColor: AppColors.chipBackground,
                                    labelStyle: const TextStyle(
                                        color: AppColors.chipText),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 0),
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ))
                              .toList(),
                        )
                      ],
                    ))
                  ]),
                  const SizedBox(height: 24),

                  // --- Play and Download Buttons ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.play_arrow),
                        label: Text(
                          isWatched ? 'Played Before' : 'Play',
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accentColor,
                            foregroundColor: AppColors.primaryText,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 12)),
                        onPressed: downloadLinks.isEmpty
                            ? null // Disable if no links
                            : () {
                                _showDownloadLinkSelection(
                                    context, downloadLinks);
                                tVClick();
                              },
                      ),
                      // ElevatedButton.icon(
                      //   icon: const Icon(Icons.download_outlined),
                      //   label: const Text('Download'),
                      //   style: ElevatedButton.styleFrom(
                      //       backgroundColor: AppColors
                      //           .secondaryBackground, // Different style
                      //       foregroundColor: AppColors.primaryText,
                      //       padding: const EdgeInsets.symmetric(
                      //           horizontal: 25, vertical: 12)),
                      //   onPressed: () async {
                      //     ScaffoldMessenger.of(context).showSnackBar(
                      //         const SnackBar(
                      //             content:
                      //                 Text('Download not implemented yet.'),
                      //             duration: Duration(seconds: 2)));
                      //   },

                      // ),
                    ],
                  ),
                  // --- Overview / Synopsis ---
                  const Text('Overview',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryText)),
                  const SizedBox(height: 8),
                  Text(
                    movie.overview,
                    style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.secondaryText,
                        height: 1.4),
                  ),
                  const SizedBox(height: 24),

                  // --- Additional Details (Optional) ---
                  _buildDetailSection('Keywords', movie.keywords.join(', ')),
                  _buildDetailSection('Production Countries',
                      movie.productionCountries.join(', ')),

                  const SizedBox(height: 50), // Add some padding at the bottom
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper to build sections for additional details
  Widget _buildDetailSection(String title, String content) {
    if (content.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryText)),
          const SizedBox(height: 6),
          Text(content,
              style: const TextStyle(
                  fontSize: 13, color: AppColors.secondaryText)),
        ],
      ),
    );
  }

  // --- Function to show Download Link Selection Dialog ---
  void _showDownloadLinkSelection(
      BuildContext context, List<String> links) async {
    var userDataService =
        Provider.of<UserDataService>(context, listen: false);

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return SimpleDialog(
          title: const Text('Select Quality / Source'),
          titleTextStyle: const TextStyle(
              color: AppColors.primaryText,
              fontSize: 18,
              fontWeight: FontWeight.bold),
          backgroundColor: AppColors.secondaryBackground,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          children: links.map((link) {
            // Try to guess quality from URL (very basic)
            String qualityGuess = "Unknown";
            if (link.contains('1080p')) {
              qualityGuess = "1080p ";
            } else if (link.contains('720p'))
              qualityGuess = "720p ";
            else if (link.contains('480p'))
              qualityGuess = "480p ";
            else if (link.contains('BluRay'))
              qualityGuess += " BluRay ";
            else if (link.contains('HEVC') || link.contains('x265'))
              qualityGuess += " HEVC ";
            else if (link.contains('x264')) qualityGuess += " x264";

            return SimpleDialogOption(
              onPressed: () async {
                Navigator.pop(dialogContext); // Close the dialog
                userDataService.toggleIsWatchedLink(
                    movieId, movieId, movieId, links.toString());
                tVClick();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => VideoPlayerScreen(
                      videoName: '$movieId',
                      source: link,
                      videoUrl: link),
                  ),
                );
              },
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
              child: Text(
                '$qualityGuess - ${Uri.parse(link).host}', // Show quality guess and domain
                style:
                    const TextStyle(color: AppColors.primaryText, fontSize: 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
