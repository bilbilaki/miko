// lib/widgets/tv_series_card.dart

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:miko/providers/god_proovider.dart' as ss;
import 'package:miko/screens/anime_grid_screen.dart';
import 'package:miko/screens/offline_screens/anime_detail_screen.dart';
import 'package:miko/showcases/movie_service.dart';
import 'package:miko/showcases/tv_detail_page_anime.dart';
//import 'package:myapp/screens/anime_details_screen.dart';
import 'package:miko/utils/colors.dart'; // Assuming AppColors exists
import 'package:intl/intl.dart'; // For date formatting
import 'package:miko/services/user_data_service.dart';
import 'package:miko/utils/utils.dart';
//import 'package:myapp/screens/settings_screen.dart';
import 'package:provider/provider.dart';
import '../showcases/model.dart'; // For accessing UserDataService



class AnimeSeriesCard extends StatelessWidget {
  final ss.TvSeriesAnime series;
  final String typec;
  const AnimeSeriesCard({required this.series, required this.typec, super.key});

  @override
  Widget build(BuildContext context) {
    final posterUrl = series.fullPosterUrl;
    final userDataService = Provider.of<UserDataService>(context, listen: true);
    final MovieService mmm = MovieService();

    String displayYear = 'N/A';
    if (series.firstAirDate != null) {
      try {
        displayYear = DateFormat('yyyy').format(series.firstAirDate!);
      } catch (_) {
        displayYear = series.firstAirDate!.toString().split('-').first;
      }
    } else if (series.tmdbId == 0) {
      displayYear = "Info Missing";
    }

    bool isFavorite = userDataService.isFavoriteAnime(series.tmdbId);
    bool isInWatchlist = userDataService.isOnWatchlistAnime(series.tmdbId);

    return FutureBuilder<TvShow>(
      future: mmm.tmtm(series.tmdbId),
      builder: (context, snapshot) {
        TvShow? nms = snapshot.data;
        return InkWell(
          onTap: () {
            tVmedium();
            if (nms == null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AnimeDetailsScreen(
                    typec: typec,
                    tvSeriesId: series.tmdbId,
                  ),
                ),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      TvShowDetailPageAnime(tvShow: nms, typec: typec),
                ),
              );
            }
          },
          child: Card(
            color: Colors.transparent,
            elevation: 0,
            margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
            clipBehavior:
                Clip.antiAlias, // Ensures content respects card boundaries
            child: Column(
              mainAxisSize: MainAxisSize.min,
              //   crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 2 / 3,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(
                          8.0,
                        ), // Slightly larger radius
                        child: Container(
                          color: const Color.fromARGB(
                            255,
                            0,
                            0,
                            0,
                          ).withOpacity(0.4),
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
                                        color: AppColors.accentColor
                                            .withOpacity(0.8),
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Center(
                                        child: Icon(
                                          Icons.broken_image_outlined,
                                          color: AppColors.secondaryText,
                                          size: 36,
                                        ),
                                      ),
                                )
                              : const Center(
                                  child: Icon(
                                    Icons.image_not_supported_outlined,
                                    color: AppColors.secondaryText,
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
                                await userDataService.toggleFavoriteAnime(
                                  series.tmdbId,
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
                                await userDataService.toggleWatchlistAnime(
                                  series.tmdbId,
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
                //     const SizedBox(height: 8.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        series.name,
                        style: GoogleFonts.lato(
                          // Using Lato from Google Fonts
                          color: AppColors.primaryText,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4.0),
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: Colors.amber,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              '${series.voteAverage.toStringAsFixed(1)} • $displayYear',
                              style: const TextStyle(
                                color: AppColors.secondaryText,
                                fontSize: 12.0,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      if (series.numberOfSeasons != null &&
                          series.numberOfEpisodes != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4.0),
                            RichText(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Seasons: ',
                                    style: TextStyle(
                                      color: Colors.green, // Key color
                                      fontSize: 10.5,
                                      fontWeight:
                                          FontWeight.bold, // Make key bolder
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        '${series.numberOfSeasons} • Episodes: ${series.numberOfEpisodes}',
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
                      if (series.originalLanguage.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4.0),
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
                                        '${series.originalLanguage.toUpperCase()}',
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
        color: Colors.black.withOpacity(0.6),
        shape: BoxShape.circle,
        border: Border.all(color: color.withOpacity(0.5), width: 0.5),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Icon(icon, color: color, size: 18),
          ),
        ),
      ),
    );
  }
}
