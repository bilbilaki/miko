import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:miko/providers/god_proovider.dart' as ss;
import 'package:miko/screens/anime_grid_screen.dart';
import 'package:miko/screens/offline_screens/movie_detail_screen.dart';
import 'package:miko/showcases/movie_service.dart';
//import 'package:myapp/screens/anime_details_screen.dart';
import 'package:miko/utils/colors.dart'; // Assuming AppColors exists
// For date formatting
import 'package:miko/services/user_data_service.dart';
//import 'package:myapp/screens/settings_screen.dart';
import 'package:provider/provider.dart';
// For accessing UserDataService
import 'package:miko/showcases/model.dart' as mmd;
import 'package:miko/showcases/movie_detail_page_copy.dart';

class MovieCard extends StatelessWidget {
  final ss.Movie movie;
  final String
  typec; // Changed to String for clarity, though it might be dynamic
  const MovieCard({required this.typec, required this.movie, super.key});

  @override
  Widget build(BuildContext context) {
    final MovieService mmm = MovieService();

    final posterUrl = movie.getPosterUrl();
    final releaseYear = movie.releaseDate?.year.toString() ?? 'N/A';
    final userDataService = Provider.of<UserDataService>(context, listen: true);
    bool isFavorite = userDataService.isFavoriteMovie(movie.id);
    bool isInWatchlist = userDataService.isOnWatchlistMovie(movie.id);

    return FutureBuilder<mmd.Movie>(
      future: mmm.mtm(movie.id),
      builder: (context, snapshot) {
        mmd.Movie? nms = snapshot.data;
        return InkWell(
          onTap: () {
            if (nms == null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      MovieDetailsScreen(movieId: movie.id, typec: "movie"),
                ),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => MovieDetailPage(id: nms.id)),
              );
            }
          },
          child: Card(
            color: Colors.transparent, // Maintain transparent card background
            elevation: 0,
            margin: const EdgeInsets.symmetric(
              vertical: 4.0,
              horizontal: 4.0,
            ), // Slightly more margin
            clipBehavior:
                Clip.antiAlias, // Ensures content respects card boundaries
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 2 / 3,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(
                          10.0,
                        ), // Consistent border radius
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors2.onBackgroundLight.withOpacity(
                              0.6,
                            ), // Subtle background for image
                          ),
                          child: posterUrl != null && posterUrl.isNotEmpty
                              ? CachedNetworkImage(
                                  filterQuality: FilterQuality.high,
                                  imageUrl: posterUrl,
                                  fit: BoxFit.cover,
                                  fadeInDuration: const Duration(
                                    milliseconds: 300,
                                  ),
                                  fadeOutDuration: const Duration(
                                    milliseconds: 100,
                                  ),
                                  placeholder: (context, url) => Center(
                                    child: SizedBox(
                                      width: 28,
                                      height: 28,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        color: AppColors2.accentColor
                                            .withOpacity(0.8),
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Center(
                                        child: Icon(
                                          Icons.broken_image_outlined,
                                          color: AppColors2.tinytext,
                                          size: 36,
                                        ),
                                      ),
                                )
                              : const Center(
                                  child: Icon(
                                    Icons.movie_filter_outlined,
                                    color: AppColors2.tinytext,
                                    size: 40,
                                  ),
                                ),
                        ),
                      ),
                      Positioned(
                        top: 8.0,
                        right: 8.0,
                        child: Row(
                          children: [
                            _buildActionButton(
                              context: context,
                              isToggled: isFavorite,
                              icon: isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFavorite
                                  ? Colors.redAccent
                                  : Colors.white70,
                              onPressed: () async {
                                await userDataService.toggleFavoriteMovie(
                                  movie.id,
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      isFavorite
                                          ? 'Removed from Favorites'
                                          : 'Added to Favorites',
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    backgroundColor: isFavorite
                                        ? Colors.red.shade700
                                        : Colors.green.shade700,
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 8.0),
                            _buildActionButton(
                              context: context,
                              isToggled: isInWatchlist,
                              icon: isInWatchlist
                                  ? Icons.bookmark
                                  : Icons.bookmark_border,
                              color: isInWatchlist
                                  ? Colors.lightGreenAccent
                                  : Colors.white70,
                              onPressed: () async {
                                await userDataService.toggleWatchlistMovie(
                                  movie.id,
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      isInWatchlist
                                          ? 'Removed from Watchlist'
                                          : 'Added to Watchlist',
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    backgroundColor: isInWatchlist
                                        ? Colors.red.shade700
                                        : Colors.green.shade700,
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8.0), // Space between image and text
                // Movie Info
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        movie.title,
                        style: GoogleFonts.lato(
                          // Using Lato from Google Fonts
                          color: AppColors2.onPrimary,
                          fontWeight:
                              FontWeight.bold, // Slightly bolder for title
                          fontSize: 14.0,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(
                        height: 4.0,
                      ), // More space before rating/year
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: Colors.amber,
                            size: 14,
                          ), // Rounded star icon
                          // const SizedBox(width: 4), // Consistent spacing
                          Expanded(
                            child: Text(
                              '${movie.voteAverage.toStringAsFixed(1)} • $releaseYear',
                              style: const TextStyle(
                                color: AppColors2.tinytext,
                                fontSize: 12.0,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      if (movie.runtime != null && movie.runtime! > 0)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // const SizedBox(height: 4.0),
                            RichText(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Runtime: ',
                                    style: TextStyle(
                                      color: Colors.green, // Key color
                                      fontSize: 10.5,
                                      fontWeight:
                                          FontWeight.bold, // Make key bolder
                                    ),
                                  ),
                                  TextSpan(
                                    text: '${movie.runtime} min',
                                    style: TextStyle(
                                      color: Colors.blue, // Value color
                                      fontSize: 10.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      if (movie.originalLanguage.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // const SizedBox(height: 4.0),
                            RichText(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Language: ',
                                    style: TextStyle(
                                      color: Colors.green, // Key color
                                      fontSize: 10.5,
                                      fontWeight:
                                          FontWeight.bold, // Make key bolder
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        '${movie.originalLanguage.toUpperCase()}',
                                    style: TextStyle(
                                      color: Colors.blue, // Value color
                                      fontSize: 10.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      if (movie.popularity > 0)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // const SizedBox(height: 4.0),
                            RichText(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Popularity: ',
                                    style: TextStyle(
                                      color: Colors.green, // Key color
                                      fontSize: 10.5,
                                      fontWeight:
                                          FontWeight.bold, // Make key bolder
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        '${movie.popularity.toStringAsFixed(1)}',
                                    style: TextStyle(
                                      color: Colors.blue, // Value color
                                      fontSize: 10.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required bool isToggled,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6), // Darker, well-defined background
        shape: BoxShape.circle,
        border: Border.all(
          color: color.withOpacity(0.5), // Subtle border based on icon color
          width: 0.5,
        ),
      ),
      child: Material(
        color: Colors.transparent, // Necessary for InkWell's ripple effect
        child: InkWell(
          borderRadius: BorderRadius.circular(20), // Circular ripple
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(6.0), // Consistent padding
            child: Icon(icon, color: color, size: 18),
          ),
        ),
      ),
    );
  }
}
