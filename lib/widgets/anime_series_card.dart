// lib/widgets/tv_series_card.dart

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:miko/providers/god_proovider.dart' as ss;
import 'package:miko/screens/anime_grid_screen.dart';
import 'package:miko/showcases/movie_service.dart';
import 'package:miko/showcases/tv_detail_page_anime.dart';
//import 'package:myapp/screens/anime_details_screen.dart';
import 'package:miko/utils/colors.dart'; // Assuming AppColors exists
import 'package:intl/intl.dart'; // For date formatting
import 'package:miko/services/user_data_service.dart';
//import 'package:myapp/screens/settings_screen.dart';
import 'package:provider/provider.dart';
import '../showcases/model.dart'; // For accessing UserDataService
import 'package:miko/showcases/model.dart' as mmd;
import 'package:miko/showcases/movie_detail_page_copy.dart';

//import 'package:myapp/screens/video_player_screen.dart'; // Your player screen

import '../screens/video_player_wplaylist_screen.dart';

class EpisodeTileNew extends StatelessWidget {
  // The 'season' property should be of type ss.Season, not a generic 'dynamic' or 'String'
  final String seriesname;
  final ss.Season season;
  final ss.Episode episode;
  final int id; // This is the TvseriesId

  const EpisodeTileNew({
    required this.seriesname,
    required this.episode,
    required this.season,
    required this.id,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final availableQualities = episode.getAvailableQualityUrls();
    final userDataService =
        Provider.of<UserDataService>(context, listen: false);

    void playEpisode(BuildContext context, url) async {
      // Find the index of the current episode within its season's list
      final int initialIndex = season.episodes.indexOf(episode);

      // Navigate to the player with the full context
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VideoPlayerScreen(
            seriesname: seriesname,
            tvSeriesId: id,
            season: season,
            playlist: season.episodes,
            initialIndex: initialIndex,
            url: url,
            //  episode: episode
          ),
        ),
      );
    }

    bool isInWatchlist = userDataService.isWatchedEpisode(
        seriesname, id, episode.episodeNumber, season.seasonNumber);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Episode ${episode.episodeNumber}',
                  style: const TextStyle(
                      color: AppColors.primaryText,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (episode.episodeIdentifier !=
                    'Episode ${episode.episodeNumber}')
                  Text(
                    episode.episodeIdentifier,
                    style: const TextStyle(
                        color: AppColors.secondaryText, fontSize: 11),
                  ),
              ],
            ),
          ),
          // --- ADDED THIS: The watched icon ---
          if (isInWatchlist)
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Icon(
                Icons.check_circle,
                color: AppColors.accentColor,
                size: 18.0,
              ),
            ),

          const SizedBox(width: 12),

          if (availableQualities.isNotEmpty)
            Expanded(
              flex: 4,
              child: Wrap(
                alignment: WrapAlignment.end,
                spacing: 6.0,
                runSpacing: 4.0,
                children: availableQualities.entries.map<Widget>((entry) {
                  final url = entry.value;
                  return ElevatedButton(
                    onPressed: () => playEpisode(context, url),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentColor.withOpacity(0.7),
                      foregroundColor: AppColors.primaryText,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      minimumSize: const Size(45, 28),
                      textStyle: const TextStyle(
                          fontSize: 11, fontWeight: FontWeight.bold),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                      elevation: 1,
                    ),
                    child: Text(entry.key.toUpperCase()),
                  );
                }).toList(),
              ),
            )
          else
            const Text(
              'No links',
              style: TextStyle(
                  color: AppColors.secondaryText,
                  fontSize: 12,
                  fontStyle: FontStyle.italic),
            ),
        ],
      ),
    );
  }
}

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
                  builder: (_) => MovieDetailsScreen(
                    movieId: movie.id,
                    typec: "movie",
                  ),
                ),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MovieDetailPage(id: nms.id),
                ),
              );
            }
          },
          child: Card(
            color: Colors.transparent, // Maintain transparent card background
            elevation: 0,
            margin: const EdgeInsets.symmetric(
                vertical: 4.0, horizontal: 4.0), // Slightly more margin
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
                            10.0), // Consistent border radius
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors2.onBackground.withOpacity(
                                0.6), // Subtle background for image
                          ),
                          child: posterUrl != null && posterUrl.isNotEmpty
                              ? CachedNetworkImage(
                                filterQuality: FilterQuality.high,
                                  imageUrl: posterUrl,
                                  fit: BoxFit.cover,
                                  fadeInDuration:
                                      const Duration(milliseconds: 300),
                                  fadeOutDuration:
                                      const Duration(milliseconds: 100),
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
                                await userDataService
                                    .toggleFavoriteMovie(movie.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      isFavorite
                                          ? 'Removed from Favorites'
                                          : 'Added to Favorites',
                                      style:
                                          const TextStyle(color: Colors.white),
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
                                await userDataService
                                    .toggleWatchlistMovie(movie.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      isInWatchlist
                                          ? 'Removed from Watchlist'
                                          : 'Added to Watchlist',
                                      style:
                                          const TextStyle(color: Colors.white),
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
                        style: const TextStyle(
                          color: AppColors2.onPrimary,
                          fontWeight:
                              FontWeight.bold, // Slightly bolder for title
                          fontSize: 14.0,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(
                          height: 4.0), // More space before rating/year
                      Row(
                        children: [
                          const Icon(Icons.star_rounded,
                              color: Colors.amber,
                              size: 14), // Rounded star icon
                          const SizedBox(width: 4), // Consistent spacing
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
                            const SizedBox(height: 4.0),
                            Text(
                              'Runtime: ${movie.runtime} min',
                              style: const TextStyle(
                                color: AppColors2.tinytext,
                                fontSize: 10.5, // Consistent font size
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      if (
                          movie.originalLanguage.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4.0),
                            Text(
                              'Language: ${movie.originalLanguage.toUpperCase()}',
                              style: const TextStyle(
                                color: AppColors2.tinytext,
                                fontSize: 10.5,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      if (movie.popularity > 0)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4.0),
                            Text(
                              'Popularity: ${movie.popularity.toStringAsFixed(1)}',
                              style: const TextStyle(
                                color: AppColors2.tinytext,
                                fontSize: 10.5,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
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
            child: Icon(
              icon,
              color: color,
              size: 18,
            ),
          ),
        ),
      ),
    );
  }
}

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
                  builder: (_) => TvShowDetailPageAnime(
                    tvShow: nms,
                    typec: typec,
                  ),
                ),
              );
            }
          },
          child: Card(
            color: Colors.transparent,
            elevation: 0,
            margin: EdgeInsets.zero,
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
                            8.0), // Slightly larger radius
                        child: Container(
                          color: const Color.fromARGB(255, 0, 0, 0)
                              .withOpacity(0.4),
                          child: posterUrl != null && posterUrl.isNotEmpty
                              ? CachedNetworkImage(
                                filterQuality: FilterQuality.high,
                                  imageUrl: posterUrl,
                                  fit: BoxFit.cover,
                                  fadeInDuration:
                                      const Duration(milliseconds: 300),
                                  fadeOutDuration:
                                      const Duration(milliseconds: 100),
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
                                await userDataService
                                    .toggleFavoriteAnime(series.tmdbId);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      isFavorite
                                          ? 'Removed from Favorites'
                                          : 'Added to Favorites',
                                      style:
                                          const TextStyle(color: Colors.white),
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
                                await userDataService
                                    .toggleWatchlistAnime(series.tmdbId);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      isInWatchlist
                                          ? 'Removed from Watchlist'
                                          : 'Added to Watchlist',
                                      style:
                                          const TextStyle(color: Colors.white),
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
                const SizedBox(height: 8.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        series.name,
                        style: const TextStyle(
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
                          const Icon(Icons.star_rounded,
                              color: Colors.amber, size: 14),
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
                            Text(
                              'Seasons: ${series.numberOfSeasons} • Episodes: ${series.numberOfEpisodes}',
                              style: const TextStyle(
                                color: AppColors.secondaryText,
                                fontSize: 10.5,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      if (
                          series.originalLanguage.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4.0),
                            Text(
                              'Language: ${series.originalLanguage.toUpperCase()}',
                              style: const TextStyle(
                                color: AppColors.secondaryText,
                                fontSize: 10.5,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
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
        border: Border.all(
          color: color.withOpacity(0.5),
          width: 0.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Icon(
              icon,
              color: color,
              size: 18,
            ),
          ),
        ),
      ),
    );
  }
}
