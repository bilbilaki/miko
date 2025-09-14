// lib/src/ui/anime_detail_screen.dart
// Updated to handle both movies and TV series based on mediaType, fixing crashes.
// Integrated MovieDetail, TvShowDetail, and EpisodeRepository for synced data.
// Added episode details fetching using EpisodeRepositoryImpl.
// Ensured UI displays items correctly without crashes (e.g., null checks for media type).

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miko/src/consts.dart';
import 'package:miko/src/providers/episode_providers.dart';
import 'package:miko/src/providers/movie_providers.dart';
import 'package:miko/src/providers/tv_providers.dart';
import 'package:miko/src/models/tv/tv_show_detail.dart';
import 'package:miko/src/models/movie/movie_detail.dart';
import 'package:miko/src/models/episode/episode_detail.dart';
import 'package:miko/src/ui/widgets/episode_horizontal_card.dart';
import 'package:miko/src/ui/widgets/share_bottom_sheet.dart';

// Providers for movie detail
final movieDetailProvider = FutureProvider.family<MovieDetail?, int>((
  ref,
  movieId,
) async {
  final repo = ref.read(movieRepositoryProvider);
  return await repo.getMovieDetail(movieId);
});

// Provider for episode list (stub for episodes)
final episodesProvider =
    FutureProvider.family<List<EpisodeDetail>?, (int, int)>((
      ref,
      params,
    ) async {
      final repo = ref.read(episodeRepositoryProvider);
      // Fetch multiple episodes for a season
      final episodeList = <EpisodeDetail>[];
      for (int ep = 1; ep <= 10; ep++) {
        // Limit to 10 for demo
        final epDetail = await repo.getEpisodeDetail(params.$1, params.$2, ep);
        if (epDetail != null) episodeList.add(epDetail);
      }
      return episodeList;
    });

class AnimeDetailScreen extends ConsumerStatefulWidget {
  final int animeId;
  final String mediaType;
  final String? initialSeason;

  const AnimeDetailScreen({
    super.key,
    required this.animeId,
    required this.mediaType,
    this.initialSeason,
  });

  @override
  ConsumerState<AnimeDetailScreen> createState() => _AnimeDetailScreenState();
}

class _AnimeDetailScreenState extends ConsumerState<AnimeDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedSeason = 1;
  bool _showFullOverview = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    if (widget.mediaType == 'tv' && widget.initialSeason != null) {
      final seasonNum = int.tryParse(
        widget.initialSeason!.replaceAll('Season ', ''),
      );
      if (seasonNum != null) {
        _selectedSeason = seasonNum;
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showShareBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const ShareBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.mediaType == 'movie') {
      final movieDetailAsync = ref.watch(movieDetailProvider(widget.animeId));
      return Scaffold(
        backgroundColor: const Color(0xFF0D0F10),
        body: movieDetailAsync.when(
          data: (MovieDetail? detail) {
            if (detail == null)
              return const Center(
                child: Text(
                  'No movie data',
                  style: TextStyle(color: Colors.red),
                ),
              );
            final imageUrl = detail.backdropPath != null
                ? '$tmdbImageBaseUrlc/t/p/w780${detail.backdropPath}'
                : detail.posterPath != null
                ? '$tmdbImageBaseUrlc/t/p/w780${detail.posterPath}'
                : 'https://via.placeholder.com/780x440.png?text=No+Image';

            String genresText = (detail.genres ?? [])
                .map((g) => g.name)
                .join(', ');
            if (genresText.isEmpty) genresText = 'N/A';

            String year = 'N/A';
            if (detail.releaseDate != null && detail.releaseDate!.length >= 4) {
              year = detail.releaseDate!.substring(0, 4);
            }

            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 280.0,
                  floating: true,
                  pinned: true,
                  backgroundColor: const Color(0xFF0D0F10),
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(
                        Icons.bookmark_border,
                        color: Colors.white,
                      ),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: _showShareBottomSheet,
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                color: Colors.grey.shade900,
                                child: const Center(
                                  child: Icon(
                                    Icons.broken_image,
                                    color: Colors.white54,
                                  ),
                                ),
                              ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.3),
                                Colors.black.withOpacity(0.8),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            detail.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 18,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                detail.voteAverage?.toStringAsFixed(1) ?? 'N/A',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.chevron_right,
                                color: Colors.white70,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                year,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.play_circle_fill,
                                    size: 24,
                                  ),
                                  label: const Text('Play'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    foregroundColor: Colors.black,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    textStyle: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.download, size: 24),
                                  label: const Text('Download'),
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                      color: Colors.white.withOpacity(0.12),
                                    ),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    textStyle: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Genre: $genresText. ${detail.overview ?? 'No overview available.'}',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.85),
                              fontSize: 13,
                            ),
                            maxLines: _showFullOverview ? 100 : 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (detail.overview != null &&
                              detail.overview!.length > 100)
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    _showFullOverview = !_showFullOverview;
                                  });
                                },
                                child: Text(
                                  _showFullOverview ? 'View Less' : 'View More',
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                                ),
                              ),
                            ),
                          const SizedBox(height: 16),
                          const Text(
                            'Related Movies', // Or cast from MovieCredits if needed
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          // TODO: Add related movies list
                          const SizedBox(height: 16),
                          TabBar(
                            controller: _tabController,
                            indicatorColor: Theme.of(
                              context,
                            ).colorScheme.primary,
                            labelColor: Theme.of(context).colorScheme.primary,
                            unselectedLabelColor: Colors.white70,
                            labelStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                            tabs: const [
                              Tab(text: 'More Like This'),
                              Tab(text: 'Comments (29.5K)'),
                            ],
                          ),
                          SizedBox(
                            height: 300,
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                _buildMoreLikeThisTab(),
                                _buildCommentsTab(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
                ),
              ],
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(color: Color(0xFF1ED760)),
          ),
          error: (err, stack) => Center(
            child: Text(
              'Error loading movie detail: $err',
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ),
      );
    } else if (widget.mediaType == 'tv') {
      // Original TV logic with episode fixes
      final animeDetailAsync = ref.watch(tvDetailProvider(widget.animeId));
      final episodesAsync = ref.watch(
        episodesProvider((widget.animeId, _selectedSeason)),
      );

      return Scaffold(
        backgroundColor: const Color(0xFF0D0F10),
        body: animeDetailAsync.when(
          data: (TvShowDetail detail) {
            final imageUrl = detail.backdropPath != null
                ? '$tmdbImageBaseUrlc/t/p/w780${detail.backdropPath}'
                : detail.posterPath != null
                ? '$tmdbImageBaseUrlc/t/p/w780${detail.posterPath}'
                : 'https://via.placeholder.com/780x440.png?text=No+Image';

            String genresText = (detail.genres ?? [])
                .map((g) => g.name)
                .join(', ');
            if (genresText.isEmpty) genresText = 'N/A';

            String year = 'N/A';
            if (detail.firstAirDate != null &&
                detail.firstAirDate!.length >= 4) {
              year = detail.firstAirDate!.substring(0, 4);
            }

            String country = (detail.originCountry ?? []).isNotEmpty
                ? detail.originCountry!.first
                : 'N/A';

            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 280.0,
                  floating: true,
                  pinned: true,
                  backgroundColor: const Color(0xFF0D0F10),
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(
                        Icons.bookmark_border,
                        color: Colors.white,
                      ),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: _showShareBottomSheet,
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                color: Colors.grey.shade900,
                                child: const Center(
                                  child: Icon(
                                    Icons.broken_image,
                                    color: Colors.white54,
                                  ),
                                ),
                              ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.3),
                                Colors.black.withOpacity(0.8),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            detail.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 18,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                detail.voteAverage?.toStringAsFixed(1) ?? 'N/A',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.chevron_right,
                                color: Colors.white70,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                year,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade700,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  '13+', // Placeholder
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                country,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.play_circle_fill,
                                    size: 24,
                                  ),
                                  label: const Text('Play'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    foregroundColor: Colors.black,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    textStyle: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.download, size: 24),
                                  label: const Text('Download'),
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                      color: Colors.white.withOpacity(0.12),
                                    ),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    textStyle: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Genre: $genresText. ${detail.overview ?? 'No overview available.'}',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.85),
                              fontSize: 13,
                            ),
                            maxLines: _showFullOverview ? 100 : 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (detail.overview != null &&
                              detail.overview!.length > 100)
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    _showFullOverview = !_showFullOverview;
                                  });
                                },
                                child: Text(
                                  _showFullOverview ? 'View Less' : 'View More',
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                                ),
                              ),
                            ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Episodes',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              DropdownButton<int>(
                                value: _selectedSeason,
                                dropdownColor: Colors.grey.shade900,
                                icon: const Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.white,
                                ),
                                underline: const SizedBox.shrink(),
                                onChanged: (int? newValue) {
                                  if (newValue != null) {
                                    setState(() {
                                      _selectedSeason = newValue;
                                    });
                                  }
                                },
                                items: (detail.seasons ?? [])
                                    .map(
                                      (s) => DropdownMenuItem<int>(
                                        value: s.seasonNumber,
                                        child: Text(
                                          'Season ${s.seasonNumber}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 130,
                            child: episodesAsync.when(
                              data: (episodes) {
                                return ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: episodes?.length ?? 0,
                                  itemBuilder: (context, index) {
                                    final episode = episodes![index];
                                    return EpisodeHorizontalCard(
                                      imageUrl:
                                          '$tmdbImageBaseUrlc/t/p/w200${episode.stillPath}',
                                      episodeNumber:
                                          'Episode ${episode.episodeNumber}',
                                      isPlaying: index == 0,
                                      onTap: () {},
                                    );
                                  },
                                );
                              },
                              loading: () => const Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xFF1ED760),
                                ),
                              ),
                              error: (err, stack) => Center(
                                child: Text(
                                  'Error loading episodes: $err',
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TabBar(
                            controller: _tabController,
                            indicatorColor: Theme.of(
                              context,
                            ).colorScheme.primary,
                            labelColor: Theme.of(context).colorScheme.primary,
                            unselectedLabelColor: Colors.white70,
                            labelStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                            tabs: const [
                              Tab(text: 'More Like This'),
                              Tab(text: 'Comments (29.5K)'),
                            ],
                          ),
                          SizedBox(
                            height: 300,
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                _buildMoreLikeThisTab(),
                                _buildCommentsTab(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
                ),
              ],
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(color: Color(0xFF1ED760)),
          ),
          error: (err, stack) => Center(
            child: Text(
              'Error loading anime detail: $err',
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ),
      );
    }
    return const Scaffold(
      body: Center(
        child: Text(
          'Unsupported media type',
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  }

  Widget _buildMoreLikeThisTab() {
    // Placeholder for recommendations
    final dummyRecommendations = List.generate(
      5,
      (i) => {
        'title': 'Rec $i',
        'imageUrl': '$tmdbImageBaseUrlc/t/p/w200/placeholder.jpg',
      },
    );
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: dummyRecommendations.length,
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      itemBuilder: (context, index) {
        final item = dummyRecommendations[index];
        return Container(
          width: 130,
          margin: const EdgeInsets.only(right: 12),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  item['imageUrl']!,
                  width: 130,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                item['title']!,
                style: const TextStyle(color: Colors.white, fontSize: 13),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCommentsTab() {
    // Placeholder comments
    final dummyComments = List.generate(
      2,
      (i) => {
        'author': 'User $i',
        'comment': 'Comment $i',
        'time': '$i days ago',
      },
    );
    return ListView.builder(
      itemCount: dummyComments.length,
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      itemBuilder: (context, index) {
        final comment = dummyComments[index];
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(radius: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    comment['author']!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    comment['comment']!,
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    comment['time']!,
                    style: const TextStyle(color: Colors.white60, fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
