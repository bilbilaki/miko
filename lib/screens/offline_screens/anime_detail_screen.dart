// lib/screens/tv_series_grid_screen.dart
// Added for Platform.isAndroid

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:miko/providers/god_proovider.dart';
import 'package:miko/services/user_data_service.dart';
import 'package:miko/utils/utils.dart';
//import 'package:miko/showcases/tv_detail_page_anime.dart';
import 'package:miko/widgets/episode_tile_widget.dart';
import 'package:provider/provider.dart';
// Ensure correct provider import
import 'package:miko/utils/colors.dart';

import '../../providers/god_proovider.dart' as ss; // Added for shimmer effect
class AnimeDetailsScreen extends StatelessWidget {
   int tvSeriesId; // Use TMDB ID to fetch from map
   String typec;
  AnimeDetailsScreen(
      {required this.tvSeriesId, required this.typec, super.key});
   ScrollController _seasonsScrollController = ScrollController();

  // Haptic feedback function instance for this class

  @override
  Widget build(BuildContext context) {
    // Fetch the specific series using the ID directly from the provider's map/list
    // No 'listen: false' needed if the UI should rebuild if the underlying data changes (unlikely here)
    var series = typec == "anime"
        ? Provider.of<AnimeProvider>(context).getAnimeByTmdbId(tvSeriesId)
        : Provider.of<TvSeriesProvider>(context).getAnimeByTmdbId(tvSeriesId);
    var userDataService = Provider.of<UserDataService>(context);
    if (series == null) {
      // Handle case where series with the ID isn't found (shouldn't happen if navigation is correct)
      return Scaffold(
        backgroundColor: AppColors.primaryBackground,
        appBar: AppBar(
          title: const Text('Not Found'),
          backgroundColor: AppColors.secondaryBackground,
          iconTheme: const IconThemeData(
              color: AppColors.primaryText), // Ensure back button is visible
          titleTextStyle:
              const TextStyle(color: AppColors.primaryText, fontSize: 20),
        ),
        body: const Center(
          child: Text(
            'TV Series details not found.',
            style: TextStyle(color: AppColors.secondaryText),
          ),
        ),
      );
    }

    // Use data directly from the `series` object loaded from CSV
    String? backdropUrl = series.fullBackdropUrl;
    String? posterUrl = series.fullPosterUrl;
    final releaseYear = series.firstAirDate != null
        ? DateFormat('yyyy').format(series.firstAirDate!)
        : 'N/A';
    bool isFavorite = userDataService.isFavoriteAnime(series.tmdbId);
    bool isInWatchlist = userDataService.isOnWatchlistAnime(series.tmdbId);
    // Format runtime if available
    String? runtimeString = series.runtime != null && series.runtime! > 0
        ? '${series.runtime} min/ep'
        : 'N/A';

    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      body: CustomScrollView(
        slivers: <Widget>[
          // --- App Bar with Backdrop ---
          SliverAppBar(
            expandedHeight: 500.0,
            pinned: true,
            stretch: true, // Optional: Allows overscroll stretch effect
            backgroundColor: AppColors.primaryBackground, // Base color
            iconTheme: const IconThemeData(
                color: AppColors.primaryText), // Ensure icons are visible
            centerTitle: false,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1.0),
              child: Container(
                color:
                    const Color.fromARGB(255, 255, 255, 255).withOpacity(0.5),
                height: 1.0,
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  backdropUrl != null
                      ? CachedNetworkImage(
                          filterQuality: FilterQuality.high,
                          imageUrl: backdropUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              Container(color: AppColors.secondaryBackground),
                          errorWidget: (context, url, error) => Container(
                              color: AppColors.secondaryBackground,
                              child: const Icon(Icons.broken_image,
                                  color: AppColors.secondaryText, size: 60)),
                          fadeInDuration: const Duration(milliseconds: 300),
                          fadeOutDuration: const Duration(milliseconds: 100),
                        )
                      : Container(
                          // Fallback color if no backdrop
                          color: AppColors.secondaryBackground,
                          child: posterUrl !=
                                  null // Try poster as fallback background
                              ? CachedNetworkImage(
                                  filterQuality: FilterQuality.high,
                                  imageUrl: posterUrl,
                                  fit: BoxFit.contain,
                                  alignment: Alignment.center,
                                  placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator(
                                          strokeWidth: 1,
                                          color: AppColors.accentColor)),
                                  errorWidget: (context, url, error) =>
                                      const Center(
                                          child: Icon(Icons.tv_off_outlined,
                                              color: AppColors.secondaryText,
                                              size: 40)),
                                  fadeInDuration:
                                      const Duration(milliseconds: 300),
                                  fadeOutDuration:
                                      const Duration(milliseconds: 100),
                                )
                              : const Center(
                                  child: Icon(Icons.tv_off_outlined,
                                      size: 40,
                                      color: AppColors
                                          .secondaryText)), // Changed to tv_off_outlined
                        ),
                  // Gradient overlay for text readability
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.2),
                          AppColors.primaryBackground.withOpacity(0.8),
                          AppColors.primaryBackground,
                        ],
                        stops: const [
                          0.0,
                          0.5,
                          0.9,
                          1.0
                        ], // Adjust stops for desired effect
                      ),
                    ),
                  ),
                  // Positioned widget moved inside the Stack
                  Positioned(
                    top: 8.0,
                    right: 8.0,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Favorite
                        IconButton(
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : Colors.white,
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
                            triggerVibration(); // Vibrate on favorite tap
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
                            '${series.voteAverage.toStringAsFixed(1)} (${series.voteCount})',
                            style: const TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryText,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        // Watchlist
                        IconButton(
                          icon: Icon(
                            isInWatchlist
                                ? Icons.bookmark
                                : Icons.bookmark_border,
                            color: isInWatchlist ? Colors.green : Colors.white,
                            size: 20,
                          ),
                          onPressed: () {
                            userDataService.toggleWatchlistAnime(series.tmdbId);
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
                            triggerVibration(); // Vibrate on watchlist tap
                          },
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.black.withOpacity(0.5),
                            padding: const EdgeInsets.all(4.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // --- Main Content Area ---
          SliverList(
            delegate: SliverChildListDelegate(
              [
                // --- Basic Info Section (Poster & Core Details) ---
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Poster
                      SizedBox(
                        width: 110,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: posterUrl != null
                              ? CachedNetworkImage(
                                  filterQuality: FilterQuality.high,
                                  imageUrl: posterUrl,
                                  fit: BoxFit.cover,
                                  height: 190,
                                  width: 130,
                                  placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator(
                                          strokeWidth: 1,
                                          color: AppColors.accentColor)),
                                  errorWidget: (context, url, error) =>
                                      const SizedBox(
                                          height: 190,
                                          width: 130,
                                          child: Icon(
                                            Icons.image_not_supported_outlined,
                                            color: AppColors.secondaryText,
                                            size: 30,
                                          )),
                                  fadeInDuration:
                                      const Duration(milliseconds: 200),
                                  fadeOutDuration:
                                      const Duration(milliseconds: 100),
                                )
                              : Container(
                                  height: 190,
                                  width: 130,
                                  decoration: BoxDecoration(
                                    color: AppColors.secondaryBackground,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons
                                          .tv_off_outlined, // Changed to tv_off_outlined
                                      size: 40, // Changed size
                                      color: AppColors.secondaryText,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Core Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(series.name,
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
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                series.originalName,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontStyle: FontStyle.italic,
                                  color: AppColors.secondaryText,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            // small info chips
                            Wrap(
                              spacing: 6,
                              runSpacing: 4,
                              children: [
                                _buildInfoChip(Icons.calendar_today,
                                    releaseYear, Colors.white),
                                _buildInfoChip(
                                    Icons.timer, runtimeString, Colors.white),
                                _buildInfoChip(
                                    Icons.check, series.status, Colors.green),
                              ],
                            ),
                            const SizedBox(height: 8),
                            // genres
                            Wrap(
                              spacing: 6.0,
                              runSpacing: 4.0,
                              children: series.genres
                                  .map((g) => Chip(
                                        label: Text(g),
                                        backgroundColor:
                                            AppColors.chipBackground,
                                        labelStyle: const TextStyle(
                                            fontSize: 11,
                                            color: AppColors.chipText),
                                        visualDensity: VisualDensity.compact,
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ))
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // --- Overview ---
                if (series.overview.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Text('Overview',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                                color: AppColors.primaryText,
                                fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 0),
                    child: Text(
                      series.overview,
                      style: const TextStyle(
                          color: AppColors.secondaryText,
                          fontSize: 14,
                          height: 1.5),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // --- Keywords (Optional) ---
                if (series.keywords.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Text('Keywords',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                                color: AppColors.primaryText,
                                fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 0),
                    child: Wrap(
                      spacing: 6.0,
                      runSpacing: 4.0,
                      children: series.keywords
                          .map((keyword) => Chip(
                                label: Text(keyword),
                                backgroundColor: AppColors.secondaryBackground
                                    .withOpacity(0.7),
                                labelStyle: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.secondaryText),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                visualDensity: VisualDensity.compact,
                              ))
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // --- Seasons and Episodes Section ---
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Text('Episodes',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.primaryText,
                          fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 8),
                if (series.seasons.isEmpty)
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Text(
                      'No episode information found for this series in the database.',
                      style: TextStyle(
                          color: AppColors.secondaryText,
                          fontStyle: FontStyle.italic),
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 0),
                    child: _buildSeasonsList(context, series.seasons,
                        series.tmdbId, series.name, triggerVibration),
                  ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

// ========== PRIVATE HELPERS ================
  Widget _buildInfoChip(IconData icon, String text, Color iconColor) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: iconColor),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            color: Color.fromARGB(255, 190, 190, 190),
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildSeasonsList(BuildContext context, List<ss.Season> seasons,
      int tvseriesId, String name, VoidCallback vibrateCallback) {
    bool defaultExpansion = seasons.length == 1;
    return SizedBox(
      height: 700, // Adjust as needed
      child: ListView.builder(
        controller: _seasonsScrollController,
        shrinkWrap: false,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: seasons.length,
        itemBuilder: (context, index) {
          var season = seasons[index];

          // Use ExpansionTile for collapsable seasons
          return Card(
            // Wrap ExpansionTile in a Card for better visual separation and Shimmer if needed conceptually
            elevation: 1,
            margin: const EdgeInsets.symmetric(vertical: 6.0),
            color: AppColors.secondaryBackground
                .withOpacity(0.4), // Slightly transparent background
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            clipBehavior:
                Clip.antiAlias, // Ensures content respects border radius
            child: ExpansionTile(
              key: PageStorageKey(
                  'season_${season.seasonNumber}'), // Maintain expansion state
              title: Text(
                'Season ${season.seasonNumber}',
                style: const TextStyle(
                    color: Color.fromARGB(255, 240, 199, 88),
                    fontWeight: FontWeight.w600,
                    fontSize: 16),
              ),
              subtitle: Text(
                '${season.episodes.length} Episode${season.episodes.length == 1 ? '' : 's'}',
                style: const TextStyle(
                    color: Color.fromARGB(255, 199, 199, 199), fontSize: 12),
              ),
              iconColor:
                  AppColors.accentColor, // Use accent color for expand icon
              collapsedIconColor: AppColors.secondaryText,
              // Expand first season or if only one season exists
              initiallyExpanded: defaultExpansion ||
                  season.seasonNumber ==
                      1, // Keep first season expanded usually
              onExpansionChanged: (isExpanded) {
                if (isExpanded) {
                  vibrateCallback(); // Vibrate on expand
                }
              },
              childrenPadding:
                  const EdgeInsets.only(bottom: 8.0, left: 4, right: 4),

              children: ListTile.divideTiles(
                // Add subtle dividers between episodes
                context: context,
                color: AppColors.dividerColor.withOpacity(0.3),
                tiles: season.episodes
                    .map((episode) => GestureDetector(
                          // Wrap EpisodeTileNew for tap vibration
                          onTap: () {
                            vibrateCallback();
                          },
                          child: EpisodeTileNew(
                            seriesname: name,
                            episode: episode,
                            season: season,
                            id: tvseriesId,
                          ),
                        ))
                    .toList(),
              ).toList(),
            ),
          );
        },
      ),
    );
  }
}
