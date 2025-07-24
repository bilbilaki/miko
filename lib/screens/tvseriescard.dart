// lib/widgets/tv_series_card.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:miko/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart'; // For HapticFeedback

// Import specific aliased models
import '../models/tv_series_anime.dart' as AnimeSeriesModels; // My core CSV models
import '../showcases/model.dart' as TmdbApiModels; // TMDB API movie/TV models

// My custom detail pages (ensure these paths are correct in your project)
import '../showcases/movie_detail_page_copy.dart'; // User's MovieDetailPage
import '../showcases/tv_detail_page_anime.dart'; // User's TvShowDetailPageAnime
import '../screens/video_player_wplaylist_screen.dart'; // My player screen
import '../services/user_data_service.dart'; // UserDataService

// Assuming AppColors and AppColors2 exist from your broader project
import '../utils/colors.dart';

// Haptic feedback utility
// Ensure these functions are globally accessible or in a utility file
// If you have these defined already in `miko/utils/utils.dart`, remove these duplicates.
void triggerVibration() {
  HapticFeedback.lightImpact(); // Or HapticFeedback.mediumImpact() / HapticFeedback.vibrate()
}
void tVmedium() => triggerVibration(); // User's alias
void tVClick() => triggerVibration(); // User's alias


class EpisodeTileNew extends StatelessWidget {
  final String seriesname; // Name of the TV Series/Anime
  final AnimeSeriesModels.Season season;
  final AnimeSeriesModels.Episode episode;
  final int id; // TMDB ID of the TV Series/Anime

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
    // Watch UserDataService for updates to watched status
    final userDataService = Provider.of<UserDataService>(context);

    // Check if the episode is watched, this will update on change
    bool isEpisodeWatched = userDataService.isWatchedEpisode(seriesname, id, episode, season);

    void playEpisode(BuildContext context, String url) async {
      // Mark episode as watched in UserDataService
      await userDataService.toggleIsWatchedLink(
          id, season.seasonNumber, episode.episodeNumber, url);
      triggerVibration(); // Vibrate on play

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
            playlist: season.episodes, // Pass the whole list of episodes for the season
            initialIndex: initialIndex,
            url: url,
          ),
        ),
      );
    }

    // Create a display title: "E01: Episode Name" or just "Episode 1" if no name
    final displayTitle = 'Episode ${episode.episodeNumber}';
    //${episode.episodeName != null && episode.episodeName!.isNotEmpty ? ': ${episode.episodeName}' : 
    

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
                  displayTitle,
                  style: const TextStyle(
                      color: AppColors.primaryText, fontSize: 14, fontWeight: FontWeight.w500),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                // Optionally show the SxxExx identifier below if different
                if (episode.episodeIdentifier != displayTitle) // If display title is simple number, show identifier
                  Text(
                    episode.episodeIdentifier,
                    style: const TextStyle(color: AppColors.secondaryText, fontSize: 11),
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
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      minimumSize: const Size(45, 28),
                      textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      elevation: 1,
                    ),
                    child: Text(
                      isEpisodeWatched ? "${quality.toUpperCase()} (Watched)" : quality.toUpperCase(),
                    ),
                  );
                }).toList(),
              ),
            )
          else
            // Show something if no qualities are found for this episode
            const Text(
              'No links',
              style: TextStyle(color: AppColors.secondaryText, fontSize: 12, fontStyle: FontStyle.italic),
            ),
        ],
      ),
    );
  }
}

class MovieCard extends StatelessWidget {
  // CRITICAL CHANGE: Type changed from `og.Movie` (AnimeSeriesModels.Movie from tv_series_anime.dart)
  // to `TmdbApiModels.Movie` (from showcases/model.dart) to align with MovieProvider.
  final TmdbApiModels.Movie movie;
  final String typec; // Pass `typec` (e.g., "movie") for internal logic or clarity
  const MovieCard({required this.typec, required this.movie, super.key});

  @override
  Widget build(BuildContext context) {
    // TMDB API service is not necessary here if movie object is already complete
    final posterUrl = movie.fullPosterPath;
    final releaseYear = movie.releaseDate.toString() ?? 'N/A';
    final userDataService = Provider.of<UserDataService>(context);

    // Watch UserDataService for updates to favorite/watchlist status
    bool isFavorite = userDataService.isFavoriteMovie(movie.id);
    bool isInWatchlist = userDataService.isOnWatchlistMovie(movie.id);

    return InkWell(
      onTap: () {
        tVClick(); // Vibrate on tap given user's existing aliases
        // Navigate directly to MovieDetailPage, assuming `movie` object is fully populated by provider.
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MovieDetailPage(movie: movie), // Pass the full movie object
          ),
        );
      },
      child: Card(
        color: AppColors2.blackbackground, // Make card transparent, container handles bg
        elevation: 0,
        margin: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 1.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 2 / 3, // Common poster aspect ratio
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
                            errorWidget: (context, url, error) => Container(
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
                      mainAxisSize: MainAxisSize.min, // Ensure row only takes needed space
                      children: [
                        // Favorite Button
                        IconButton(
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? const Color.fromARGB(255, 255, 17, 0) : Colors.white,
                            size: 20,
                          ),
                          onPressed: () async {
                            tVClick();
                            await userDataService.toggleFavoriteMovie(movie.id);
                            // The Consumer in the parent widget will rebuild this card automatically.
                          },
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.black.withOpacity(0.5), // Cute backdrop
                            padding: const EdgeInsets.all(4.0),
                            minimumSize: Size.zero, // Make button fit icon size
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                        const SizedBox(width: 4.0),
                        // Watchlist Button
                        IconButton(
                          icon: Icon(
                            isInWatchlist ? Icons.bookmark : Icons.bookmark_border,
                            color: isInWatchlist ? const Color.fromARGB(255, 65, 220, 38) : Colors.white,
                            size: 20,
                          ),
                          onPressed: () async {
                            tVClick();
                            await userDataService.toggleWatchlistMovie(movie.id);
                            // The Consumer will rebuild this card.
                          },
                          style: IconButton.styleFrom(
                            backgroundColor: AppColors2.onSurface.withOpacity(0.5), // Cute backdrop
                            padding: const EdgeInsets.all(0.5),
                            minimumSize: Size.zero, // Make button fit icon size
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      const SizedBox(width: 2),
                      Expanded( // Use Expanded to prevent overflow for long text
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
                  const SizedBox(height: 2.0),
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
        ),
      ),
    );
  }
}

class AnimeSeriesCard extends StatelessWidget {
  // Using AnimeSeriesModels.TvSeriesAnime as intended for local CSV data
  final AnimeSeriesModels.TvSeriesAnime series;
  final String typec; // Will be "anime" or "tvseries"
  const AnimeSeriesCard({required this.series, required this.typec, super.key});

  @override
  Widget build(BuildContext context) {
    // TMDB API service is not strictly necessary here, model from provider is sufficient
    final posterUrl = series.fullPosterUrl;
    final userDataService = Provider.of<UserDataService>(context);

    // Safely get the year (user logic re-applied)
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

    // Watch UserDataService for updates to favorite/watchlist status
    bool isFavorite = userDataService.isFavoriteAnime(series.tmdbId);
    bool isInWatchlist = userDataService.isOnWatchlistAnime(series.tmdbId);

    return InkWell(
      onTap: () {
        tVClick(); // Vibrate on tap
        // Navigate to TvShowDetailPageAnime,
        // converting AnimeSeriesModels.TvSeriesAnime to TmdbApiModels.TvShow
        // The `typec` parameter correctly indicates "anime" or "series" to the detail page.
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TvShowDetailPageAnime(
              tvShow: AppModelConverters().toTmdbTvSeries(series), // Convert to expected model
              typec: typec, // Pass the original type (anime/tvseries)
            ),
          ),
        );
      },
      child: Card(
        color: Colors.transparent, // Make card transparent
        elevation: 0,
        margin: EdgeInsets.zero, // No external margin, layout handles spacing
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
                      color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.3),
                      child: posterUrl != null
                          ? CachedNetworkImage(
                              imageUrl: posterUrl,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 1,
                                  color: AppColors.accentColor,
                                ),
                              ),
                              errorWidget: (context, url, error) => const Center(
                                child: Icon(
                                  Icons.image_not_supported_outlined,
                                  color: AppColors.secondaryText,
                                  size: 30,
                                ),
                              ),
                              fadeInDuration: const Duration(milliseconds: 300),
                              fadeOutDuration: const Duration(milliseconds: 100),
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
                      mainAxisSize: MainAxisSize.min, // Ensure row only takes needed space
                      children: [
                        // Favorite Button
                        IconButton(
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : Colors.white,
                            size: 20,
                          ),
                          onPressed: () async {
                            tVClick();
                            await userDataService.toggleFavoriteAnime(series.tmdbId);
                            // The Consumer in the parent will rebuild this card.
                          },
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.black.withOpacity(0.5), // Cute backdrop
                            padding: const EdgeInsets.all(0.0), // Tiny padding as per user
                            minimumSize: Size.zero, // Make button fit icon size
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                        const SizedBox(width: 10.0), // Increased spacing for more padding
                        // Watchlist Button
                        IconButton(
                          icon: Icon(
                            isInWatchlist ? Icons.bookmark : Icons.bookmark_border,
                            color: isInWatchlist ? Colors.green : Colors.white,
                            size: 20,
                          ),
                          onPressed: () async {
                            tVClick();
                            await userDataService.toggleWatchlistAnime(series.tmdbId);
                            // The Consumer will rebuild this card.
                          },
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.black.withOpacity(0.5), // Cute backdrop
                            padding: const EdgeInsets.all(0.5), // Small padding as per user
                            minimumSize: Size.zero, // Make button fit icon size
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
                      const Icon(Icons.star, color: Colors.amber, size: 13),
                      const SizedBox(width: 4),
                      Expanded( // Use expanded to prevent overflow
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
      ),
    );
  }
}