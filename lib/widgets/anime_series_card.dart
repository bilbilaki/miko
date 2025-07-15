// lib/widgets/tv_series_card.dart

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:miko/models/tv_series_anime.dart' as og;
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
import 'package:miko/models/tv_series_anime.dart' as ss;

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
            playlist: season
                .episodes, // Pass the whole list of episodes for the season
            initialIndex: initialIndex,
            url: url,
          ),
        ),
      );
    }

    // Create a display title: "E01: Episode Name" or just "Episode 1" if no name
    // Since we removed tmdbTitle, we'll rely on season/episode numbers.
    final displayTitle = 'Episode ${episode.episodeNumber}'; // Simple display
    // Or use the identifier: final displayTitle = episode.episodeIdentifier;
    bool isInWatchlist =
        userDataService.isWatchedEpisode(seriesname, id, episode, season);
    return Padding(
      // Add padding instead of using Card margin for better control with dividers
      padding: const EdgeInsets.symmetric(
          vertical: 8.0, horizontal: 16.0), // Adjust padding as needed
      child: Row(
        children: [
          // Episode Number/Identifier
          Expanded(
            flex: 3, // Give reasonable space to title/identifier
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayTitle, // Use the generated display title
                  style: const TextStyle(
                      color: AppColors.primaryText,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                  maxLines: 2, // Allow wrapping
                  overflow: TextOverflow.ellipsis,
                ),
                // Optionally show the SxxExx identifier below if different
                if (episode.episodeIdentifier != displayTitle)
                  Text(
                    episode.episodeIdentifier,
                    style: const TextStyle(
                        color: AppColors.secondaryText, fontSize: 11),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Quality Buttons
          if (availableQualities.isNotEmpty)
            Expanded(
              flex: 4,
              child: Wrap(
                alignment: WrapAlignment.end,
                spacing: 6.0,
                runSpacing: 4.0,
                children: availableQualities.entries.map<Widget>((entry) {
                  final quality = entry.key;
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
                        borderRadius: BorderRadius.circular(6),
                      ),
                      elevation: 1,
                    ),
                    child: Text(
                      isInWatchlist
                          ? "${quality.toUpperCase()} (Watched)"
                          : quality.toUpperCase(),
                    ),
                  );
                }).toList(),
              ),
            )
          else
            // Show something if no qualities are found for this episode
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
  final  movie;
  final typec;
  const MovieCard({required this.typec, required this.movie, super.key});

  @override
  Widget build(BuildContext context) {
    final MovieService mmm = MovieService();

    final posterUrl = movie.getPosterUrl();
    final releaseYear = movie.releaseDate?.year.toString() ?? 'N/A';
    final userDataService = Provider.of<UserDataService>(context);
    // Check if the movie is in Favorites or Watchlist
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
                    ), // Pass movie ID
                  ),
                );
              } else {
                // Navigate to Movie Details Screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        MovieDetailPage(movie: nms), // Pass movie ID
                  ),
                );
                //context.go('/movie/${movie.id}');
              }
            },
            child: Card(
                color: AppColors2
                    .blackbackground, // Make card transparent, container handles bg
                elevation: 0,
                margin:
                    const EdgeInsets.symmetric(vertical: 1.0, horizontal: 1.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Movie Poster using CachedNetworkImage with Buttons
                    AspectRatio(
                      aspectRatio: 2 / 3,

                      // Common poster aspect ratio
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: posterUrl != null
                                ? CachedNetworkImage(
                                    imageUrl: posterUrl,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(
                                      color: AppColors2.onSurface,
                                      child: const Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: AppColors2.accentColor,
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                      color: AppColors2.onSecondary,
                                      child: const Center(
                                        child: Icon(
                                          Icons.error_outline,
                                          color: AppColors2.error,
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(
                                    // Placeholder if no poster
                                    color: AppColors2.onBackground,
                                    child: const Center(
                                      child: Icon(
                                        Icons.movie_filter_outlined,
                                        color: AppColors2.error,
                                        size: 40,
                                      ),
                                    ),
                                  ),
                          ),
                          // Positioned buttons on top of the poster
                          Positioned(
                            top: 8.0,
                            right: 8.0,
                            child: Row(
                              children: [
                                // Favorite Button
                                IconButton(
                                  icon: Icon(
                                    isFavorite
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: isFavorite
                                        ? const Color.fromARGB(255, 255, 17, 0)
                                        : Colors.white,
                                    size: 20,
                                  ),
                                  onPressed: () async {
                                    await userDataService
                                        .toggleFavoriteMovie(movie.id);
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
                                    backgroundColor: Colors.black
                                        .withOpacity(0.5), // Cute backdrop
                                    padding: const EdgeInsets.all(4.0),
                                  ),
                                ),
                                const SizedBox(width: 4.0),
                                // Watchlist Button
                                IconButton(
                                  icon: Icon(
                                    isInWatchlist
                                        ? Icons.bookmark
                                        : Icons.bookmark_border,
                                    color: isInWatchlist
                                        ? const Color.fromARGB(255, 65, 220, 38)
                                        : Colors.white,
                                    size: 20,
                                  ),
                                  onPressed: () async {
                                    await userDataService
                                        .toggleWatchlistMovie(movie.id);
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
                                    backgroundColor: AppColors2.onSurface
                                        .withOpacity(0.5), // Cute backdrop
                                    padding: const EdgeInsets.all(0.5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8.0),

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
                              fontWeight: FontWeight.w500,
                              fontSize: 14.0,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2.0),
                          Row(
                            children: [
                              const Icon(Icons.star,
                                  color: Colors.amber, size: 14),
                              const SizedBox(width: 2),
                              Text(
                                '${movie.voteAverage.toStringAsFixed(1)} • $releaseYear',
                                style: const TextStyle(
                                  color: AppColors2.tinytext,
                                  fontSize: 12.0,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          const SizedBox(height: 2.0),
                          // Additional Info: Runtime, Language, Popularity
                          Text(
                            'Runtime: ${movie.runtime != null ? "${movie.runtime} min" : 'N/A'}',
                            style: const TextStyle(
                              color: AppColors2.tinytext,
                              fontSize: 10.0,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2.0),
                          Text(
                            'Language: ${movie.originalLanguage.toUpperCase()}',
                            style: const TextStyle(
                              color: AppColors2.tinytext,
                              fontSize: 10.0,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2.0),
                          Text(
                            'Popularity: ${movie.popularity.toStringAsFixed(1)}',
                            style: const TextStyle(
                              color: AppColors2.tinytext,
                              fontSize: 10.0,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 2.0), // Space below card
                  ],
                )),
          );
        });
  }
}

class AnimeSeriesCard extends StatelessWidget {
  final og.TvSeriesAnime series;
  final String typec;
  const AnimeSeriesCard({required this.series, required this.typec, super.key});

  @override
  Widget build(BuildContext context) {
    final posterUrl = series.fullPosterUrl;
    final userDataService = Provider.of<UserDataService>(context);
    final MovieService mmm = MovieService();
    // Safely get the year
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

    // Check if the series is in Favorites or Watchlist
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
                      ), // Pass movie ID
                    ),
                  );
                } else {
                  // Navigate to Movie Details Screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TvShowDetailPageAnime(
                          tvShow: nms, typec: typec), // Pass movie ID
                    ),
                  );
                  //context.go('/movie/${movie.id}');
                }
              },
              child: Card(
                color: Colors.transparent,
                elevation: 0,
                margin: EdgeInsets.zero,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AspectRatio(
                      aspectRatio: 2 / 3,
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6.0),
                            child: Container(
                              color: const Color.fromARGB(255, 0, 0, 0)
                                  .withOpacity(0.3),
                              child: posterUrl != null
                                  ? CachedNetworkImage(
                                      imageUrl: posterUrl,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          const Center(
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
                                  : const Center(
                                      child: Icon(
                                        Icons.tv_off_outlined,
                                        color: AppColors.secondaryText,
                                        size: 40,
                                      ),
                                    ),
                            ),
                          ),
                          // Positioned buttons on top of the poster
                          Positioned(
                            top: 3.0,
                            right: 3.0,
                            child: Row(
                              children: [
                                // Favorite Button
                                IconButton(
                                  icon: Icon(
                                    isFavorite
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color:
                                        isFavorite ? Colors.red : Colors.white,
                                    size: 20,
                                  ),
                                  onPressed: () async {
                                    await userDataService
                                        .toggleFavoriteAnime(series.tmdbId);
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
                                    backgroundColor: Colors.black
                                        .withOpacity(0.5), // Cute backdrop
                                    padding: const EdgeInsets.all(0.0),
                                  ),
                                ),
                                const SizedBox(width: 10.0),
                                // Watchlist Button
                                IconButton(
                                  icon: Icon(
                                    isInWatchlist
                                        ? Icons.bookmark
                                        : Icons.bookmark_border,
                                    color: isInWatchlist
                                        ? Colors.green
                                        : Colors.white,
                                    size: 20,
                                  ),
                                  onPressed: () async {
                                    await userDataService
                                        .toggleWatchlistAnime(series.tmdbId);
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
                                    backgroundColor: Colors.black
                                        .withOpacity(0.5), // Cute backdrop
                                    padding: const EdgeInsets.all(0.5),
                                  ),
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
                              fontWeight: FontWeight.w600,
                              fontSize: 13.0,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2.0),
                          // Rating and Year
                          Row(
                            children: [
                              const Icon(Icons.star,
                                  color: Colors.amber, size: 13),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  '${series.voteAverage.toStringAsFixed(1)} • $displayYear',
                                  style: const TextStyle(
                                    color: AppColors.secondaryText,
                                    fontSize: 11.5,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2.0),
                          // Additional Info: Episodes, Seasons, Language
                          Text(
                            'Seasons: ${series.numberOfSeasons ?? 'N/A'} • Episodes: ${series.numberOfEpisodes ?? 'N/A'}',
                            style: const TextStyle(
                              color: Color.fromARGB(255, 186, 179, 179),
                              fontSize: 10.0,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2.0),
                          Text(
                            'Language: ${series.originalLanguage.toUpperCase()}',
                            style: const TextStyle(
                              color: AppColors.secondaryText,
                              fontSize: 10.0,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ));
        });
  }
}
