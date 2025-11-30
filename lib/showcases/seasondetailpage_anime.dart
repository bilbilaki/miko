// --- season_detail_page.dart ---
import 'package:flutter/material.dart';
import 'package:miko/showcases/episodedetailpage.dart';
import 'package:miko/utils/ai_translator.dart';
import 'model.dart';
import 'movie_service.dart';
// For navigation

class SeasonDetailPageAnime extends StatefulWidget {
  final int tvShowId;
  final int seasonNumber;
  final String seasonName;
  final String? posterPath;
  final MovieService movieService;
  final typec;

  const SeasonDetailPageAnime({
    super.key,
    required this.tvShowId,
    required this.seasonNumber,
    required this.seasonName,
    this.posterPath,
    required this.movieService,
    required this.typec,
  });

  @override
  State<SeasonDetailPageAnime> createState() => _SeasonDetailPageAnimeState();
}

class _SeasonDetailPageAnimeState extends State<SeasonDetailPageAnime> {
  late Future<SeasonDetails> _seasonDetailsFuture;
final Map<int, String?> _translatedOverviews = {};
  final Map<int, bool> _isTranslatingMap = {};
  final _translator = MovieTvTranslator();
Future<void> _translateOverviewForEpisode(int key, String original) async {
    setState(() => _isTranslatingMap[key] = true);
    try {
      final translated = await _translator.translateTextForMoviesAndTV(
        original,context
      );
      setState(() => _translatedOverviews[key] = translated);
    } finally {
      setState(() => _isTranslatingMap[key] = false);
    }
  }
  @override
  void initState() {
    super.initState();
    _seasonDetailsFuture = widget.movieService.getTvShowSeasonDetails(
      tvShowId: widget.tvShowId,
      seasonNumber: widget.seasonNumber,
    );
  }

  @override
  Widget build(BuildContext context) {
    final String fullPosterPath = widget.posterPath != null
        ? 'https://db.inosuke.sbs/t/p/w500${widget.posterPath}'
        : 'https://db.inosuke.sbs/t/p/w500${widget.posterPath}';

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(widget.seasonName,
                  style: const TextStyle(
                      shadows: [Shadow(blurRadius: 5, color: Colors.black)])),
              background: widget.posterPath != null
                  ? Image.network(fullPosterPath,
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, s) => Container(
                          color: Colors.grey[800],
                          child: Center(
                              child: Icon(Icons.broken_image,
                                  color: Colors.white54, size: 50))))
                  : Container(
                      color: Colors.grey[800],
                      child: Center(
                          child: Icon(Icons.tv_outlined,
                              color: Colors.white54, size: 80))),
            ),
          ),
          FutureBuilder<SeasonDetails>(
            future: _seasonDetailsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()));
              } else if (snapshot.hasError) {
                return SliverFillRemaining(
                    child: Center(child: Text('Error: ${snapshot.error}')));
              } else if (snapshot.hasData &&
                  snapshot.data!.episodes.isNotEmpty) {
                final episodes = snapshot.data!.episodes
                  ..sort((a, b) => a.episodeNumber.compareTo(b.episodeNumber));
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final episode = episodes[index];
                      return _buildEpisodeListItem(context, episode);
                    },
                    childCount: episodes.length,
                  ),
                );
              } else {
                return const SliverFillRemaining(
                    child: Center(
                        child: Text('No episodes found for this season.')));
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEpisodeListItem(BuildContext context, Episode episode) {
    final int key = episode.id;
    final bool isTranslating = _isTranslatingMap[key] == true;
    final String? translated = _translatedOverviews[key];

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EpisodeDetailPage(
                tvShowId: widget
                    .tvShowId, // or episode.showId if available and correct
                seasonNumber: episode.seasonNumber,
                episodeNumber: episode.episodeNumber,
                episodeName: episode.name,
                movieService: widget.movieService,
             //   typec: widget.typec,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (episode.stillPath != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.network(
                    episode.fullStillPath,
                    width: 120,
                    height: 67.5, // 16:9 aspect ratio
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => Container(
                        width: 120,
                        height: 67.5,
                        color: Colors.grey[700],
                        child: const Center(
                            child: Icon(Icons.hide_image_outlined))),
                  ),
                ),
              if (episode.stillPath != null) const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'E${episode.episodeNumber}: ${episode.name}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Air Date: ${episode.formattedAirDate}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                    ),
                    if (episode.voteAverage > 0) ...[
                      const SizedBox(height: 4),
                      Row(children: [
                        const Icon(Icons.star_border,
                            color: Colors.amber, size: 14),
                        const SizedBox(width: 4),
                        Text(episode.voteAverage.toStringAsFixed(1),
                            style: const TextStyle(fontSize: 12)),
                      ]),
                    ],
                    const SizedBox(height: 6),


IconButton(
  icon: isTranslating
    ? SizedBox(width:16, height:16, child: CircularProgressIndicator(strokeWidth:1, color: Colors.white))
    : Icon(Icons.auto_awesome, color: Colors.white, size:16),
  onPressed: () async {
    // toggle off if already translated
    if (translated != null) {
      setState(() => _translatedOverviews.remove(key));
      return;
    }
    await _translateOverviewForEpisode(key, episode.overview);
    if (_translatedOverviews[key] != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Overview translated'), duration: Duration(seconds:1)));
    }
  },
//  style: IconButton.styleFrom(backgroundColor: Colors.black.withValues(alpha:0.5), padding: const EdgeInsets.all(1.0)),
),


                    SizedBox(height: 6),
                    if (episode.overview.isNotEmpty)
                      Text(
                        translated ?? episode.overview,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 13),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// --- END OF SeasonDetailPage.dart ---
