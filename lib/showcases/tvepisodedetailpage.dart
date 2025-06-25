// --- episode_detail_page.dart ---
import 'package:flutter/material.dart';
import 'package:miko/models/tv_series_anime.dart' as ses;
import 'package:miko/screens/video_player_screen.dart';
import 'package:miko/services/user_data_service.dart';
import 'package:miko/utils/colors.dart' show AppColors, AppColors2;
import 'package:provider/provider.dart';
import 'model.dart';
import 'movie_service.dart';
import 'person_detail_page.dart'; // For navigating to crew/guest star details
import '../providers/tv_series_provider.dart';

class TVEpisodeDetailPage extends StatefulWidget {
  final int tvShowId;
  final int seasonNumber;
  final int episodeNumber;
  final String episodeName; // For AppBar title
  final MovieService movieService;

  const TVEpisodeDetailPage({
    super.key,
    required this.tvShowId,
    required this.seasonNumber,
    required this.episodeNumber,
    required this.episodeName,
    required this.movieService,
  });

  @override
  State<TVEpisodeDetailPage> createState() => _TVEpisodeDetailPageState();
}

class _TVEpisodeDetailPageState extends State<TVEpisodeDetailPage> {
  late Future<EpisodeDetails> _episodeDetailsFuture;
  TvSeriesProvider seriesProvider = TvSeriesProvider();

  // final EpisodeAnime episode =

  @override
  void initState() {
    super.initState();
    _episodeDetailsFuture = widget.movieService.getTvShowEpisodeDetails(
      tvShowId: widget.tvShowId,
      seasonNumber: widget.seasonNumber,
      episodeNumber: widget.episodeNumber,
    );
  }

  void _navigateToPersonDetail(int personId, String name, String? profilePath) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PersonDetailPage(
          personId: personId,
          initialName: name,
          initialProfilePath: profilePath,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final anime = seriesProvider.getAnimeByTmdbId(widget.tvShowId);
    // final EpisodeAnime episode;

    List<ses.Season> seasons = anime!.seasons;
    final s = seasons[widget.seasonNumber];
    late final ses.Episode episode =
        s.episodes.firstWhere((e) => e.episodeNumber == widget.episodeNumber);
    final availableQualities = episode.getAvailableQualityUrls();
    final userDataService = Provider.of<UserDataService>(context);
    // final status = seriesProvider.status;
    // seriesProvider.loadTvSeriesAnimeData();
    // final seriesList = seriesProvider.seriesForDisplay;

    void playVideo(BuildContext context, String url) async {
      await userDataService.toggleIsWatchedLink(
          widget.tvShowId,
          widget.episodeNumber,
          widget.seasonNumber,
          availableQualities.toString());

      // URL encode the video URL to make it safe for use in the path
      final encodedUrl = Uri.encodeComponent(url);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => VideoPlayerScreen(videoUrl: url), // Pass movie ID
          ));
    }

    // Create a display title: "E01: Episode Name" or just "Episode 1" if no name
    // Since we removed tmdbTitle, we'll rely on season/episode numbers.
    final displayTitle = 'Episode ${episode.episodeNumber}'; // Simple display
    // Or use the identifier: final displayTitle = episode.episodeIdentifier;
    bool isInWatchlist = userDataService.isWatchedEpisode(
        widget.tvShowId,
        widget.episodeNumber,
        widget.seasonNumber,
        availableQualities.toString());

    return Scaffold(
      body: FutureBuilder<EpisodeDetails>(
        future: _episodeDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final episode = snapshot.data!;
            final String fullStillPath = episode.stillPath != null
                ? 'https://image.tmdb.org/t/p/w500${episode.stillPath}' // Larger still
                : 'https://image.tmdb.org/t/p/w500${episode.stillPath}';

            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 250.0,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      'S${episode.seasonNumber} E${episode.episodeNumber}: ${episode.name}',
                      style: const TextStyle(fontSize: 16, shadows: [
                        Shadow(blurRadius: 5, color: Colors.black)
                      ]),
                    ),
                    background: Image.network(
                      fullStillPath,
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, s) => Container(
                          color: Colors.grey[800],
                          child: Center(
                              child: Icon(Icons.broken_image,
                                  color: Colors.white54, size: 50))),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Air Date: ${episode.airDate}',
                                style: Theme.of(context).textTheme.titleSmall),
                            Container(
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
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Quality Buttons
                            if (availableQualities.isNotEmpty)
                              Expanded(
                                flex:
                                    4, // Give slightly more space for buttons maybe
                                child: Wrap(
                                  alignment: WrapAlignment
                                      .end, // Align buttons to the right
                                  spacing:
                                      6.0, // Horizontal space between buttons
                                  runSpacing: 4.0, // Vertical space if wraps
                                  children:
                                      availableQualities.entries.map((entry) {
                                    final quality = entry.key;
                                    final url = entry.value;
                                    return ElevatedButton(
                                      onPressed: () => playVideo(context, url),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors2
                                            .watchlistActive
                                            .withOpacity(0.7), // Button color
                                        foregroundColor: AppColors2
                                            .primaryText, // Text color
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 5), // Adjusted padding
                                        minimumSize: const Size(
                                            45, 28), // Ensure minimum size
                                        textStyle: const TextStyle(
                                            fontSize: 11,
                                            fontWeight:
                                                FontWeight.bold), // Adjust font
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        elevation: 1, // Slight elevation
                                      ),
                                      child: Text(isInWatchlist
                                          ? quality.toUpperCase() +
                                              '' +
                                              '' "Watched this Episode" ''
                                          : quality.toUpperCase()),
                                      // Uppercase quality (e.g., 1080P)
                                    );
                                  }).toList(),
                                ),
                              )
                            else
                              // Show something if no qualities are found for this episode
                              const Text(
                                'No links',
                                style: TextStyle(
                                    color: AppColors2.secondaryText,
                                    fontSize: 12,
                                    fontStyle: FontStyle.italic),
                              ),

                            if (episode.runtime != null)
                              Text('Runtime: ${episode.runtime} min',
                                  style:
                                      Theme.of(context).textTheme.titleSmall),
                          ],
                        ),
                        if (episode.voteAverage > 0) ...[
                          const SizedBox(height: 8),
                          Row(children: [
                            const Icon(Icons.star,
                                color: Colors.amber, size: 18),
                            const SizedBox(width: 4),
                            Text(
                                '${episode.voteAverage.toStringAsFixed(1)} (${episode.voteCount} votes)',
                                style: Theme.of(context).textTheme.titleSmall),
                          ]),
                        ],
                        const SizedBox(height: 16),
                        Text('Overview',
                            style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 8),
                        Text(episode.overview.isEmpty
                            ? 'No overview available.'
                            : episode.overview),

                        if (episode.guestStars.isNotEmpty) ...[
                          const SizedBox(height: 24),
                          Text('Guest Stars',
                              style: Theme.of(context).textTheme.titleLarge),
                          const SizedBox(height: 12),
                          _buildPersonList(context, episode.guestStars, true),
                        ],

                        if (episode.crew.isNotEmpty) ...[
                          const SizedBox(height: 24),
                          Text('Crew',
                              style: Theme.of(context).textTheme.titleLarge),
                          const SizedBox(height: 12),
                          _buildPersonList(context, episode.crew, false),
                        ],
                        const SizedBox(height: 20), // Bottom padding
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: Text('Episode details not found.'));
          }
        },
      ),
    );
  }

  Widget _buildPersonList(
      BuildContext context, List<dynamic> people, bool isGuestStar) {
    return SizedBox(
      height: 180, // Adjust as needed
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: people.length,
        itemBuilder: (context, index) {
          final person = people[index];
          String name = '';
          String? profilePath;
          String? role = ''; // Character for guest star, job for crew

          if (isGuestStar && person is GuestStar) {
            name = person.name;
            profilePath = person.profilePath;
            role = person.character;
          } else if (!isGuestStar && person is CrewMember) {
            name = person.name;
            profilePath = person.profilePath;
            role = person.job;
          }

          final String fullProfileUrl = profilePath != null
              ? 'https://inosdb.worker-inosuke.workers.dev/w500$profilePath'
              : 'https://inosdb.worker-inosuke.workers.dev/w500$profilePath';
          return GestureDetector(
            onTap: () => _navigateToPersonDetail(person.id, name, profilePath),
            child: Container(
              width: 100,
              margin: const EdgeInsets.only(right: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 3,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        fullProfileUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) => Container(
                            color: Colors.grey[700],
                            child: const Center(
                                child: Icon(Icons.person_outline))),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(name,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 12)),
                  if (role.isNotEmpty)
                    Text(role,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style:
                            TextStyle(fontSize: 10, color: Colors.grey[400])),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
// --- END OF EpisodeDetailPage.dart ---
