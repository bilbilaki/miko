import 'dart:io'; // Import for Platform check
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for HapticFeedback
import 'package:miko/providers/god_proovider.dart' as ss;
import 'package:miko/services/user_data_service.dart';
import 'package:miko/showcases/recommendations_page.dart';
import '../widgets/anime_series_card.dart'; // Keep if used elsewhere
import 'seasondetailpage_anime.dart';
import 'package:miko/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'model.dart' hide Episode;
import 'model.dart' as m;
import 'movie_service.dart';
import 'person_detail_page.dart';
import 'episodedetailpage.dart';
import 'package:shimmer/shimmer.dart'; // Import Shimmer

class TvShowDetailPageAnime extends StatefulWidget {
  final tvShow;
  final typec;
  const TvShowDetailPageAnime(
      {super.key, required this.tvShow, required this.typec});

  @override
  State<TvShowDetailPageAnime> createState() => _TvShowDetailPageAnimeState();
}

class _TvShowDetailPageAnimeState extends State<TvShowDetailPageAnime>
    with SingleTickerProviderStateMixin {
  final MovieService _movieService = MovieService();
  late Future<Map<String, dynamic>> _tvShowDataFuture;
  final ScrollController _seasonsScrollController = ScrollController();

  late TabController _tabController;
  TvShowResponse? recommendations;
  TvShow? _detailedTvShow; // Store the fully loaded TvShow object

  // Futures for tab-specific data
  Future<TVCredits>? _creditsFuture;
  Future<YoutubeVideoForSeries>? _videosFuture;

  final List<Tab> _tabs = const [
    Tab(text: 'OVERVIEW'),
    Tab(text: 'List of Episodes'),
    Tab(text: 'SEASONS'),
    Tab(text: 'CAST'),
    Tab(text: 'VIDEOS'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _loadTvShowBaseDetails();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _movieService.dispose();
    _seasonsScrollController.dispose();
    super.dispose();
  }

  void _loadTvShowBaseDetails() {
    _tvShowDataFuture = _movieService.getTvShowDetailsWithRecommendations(
        tvShowId: widget.tvShow.id);
    _tvShowDataFuture.then((data) {
      if (mounted && data['details'] != null) {
        final loadedShow = data['details'] as TvShow;
        setState(() {
          _detailedTvShow = loadedShow;
          _creditsFuture = _movieService.getTVCredits(tvId: loadedShow.id);
          _videosFuture =
              _movieService.getTvShowVideos(tvShowId: loadedShow.id);
        });
      }
    }).catchError((e) {
      debugPrint("Error loading base TV Show details: $e");
    });
  }

  void _navigateToPersonDetail(int personId, String name, String? profilePath) {
    if (Platform.isAndroid) HapticFeedback.lightImpact();
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

  Future<void> _launchUrl(String urlString) async {
    if (Platform.isAndroid) HapticFeedback.lightImpact();
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch $urlString')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: _tvShowDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              _detailedTvShow == null) {
            return _buildLoadingView(
                widget.tvShow); // Use initial basic tvShow for loading view
          } else if (snapshot.hasError && _detailedTvShow == null) {
            return _buildErrorView(
                context, "An unexpected error occurred.", widget.tvShow);
          } else if (snapshot.hasData || _detailedTvShow != null) {
            if (snapshot.hasData) {
              _detailedTvShow = snapshot.data!['details'] as TvShow?;
              recommendations =
                  snapshot.data!['recommendations'] as TvShowResponse?;
            }
            if (_detailedTvShow == null) {
              return _buildErrorView(
                  context, "Failed to load show details.", widget.tvShow);
            }
            return _buildDetailView(context, _detailedTvShow!);
          } else {
            return _buildErrorView(
                context, "An unexpected error occurred.", widget.tvShow);
          }
        },
      ),
    );
  }

  Widget _buildLoadingView(TvShow basicTvShow) {
    return Stack(
      children: [
        _buildScaffoldContent(context, basicTvShow, true),
        Positioned.fill(
          child: Container(
            color: Colors.black54,
            child: const Center(child: CircularProgressIndicator()),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorView(
      BuildContext context, String errorMessage, TvShow basicTvShow) {
    return Stack(
      children: [
        _buildScaffoldContent(context, basicTvShow, true),
        Positioned.fill(
          child: Container(
            color: Colors.black87,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 60, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('Error loading TV show details',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(color: Colors.white)),
                    const SizedBox(height: 8),
                    Text(errorMessage,
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.white70)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        if (Platform.isAndroid) HapticFeedback.lightImpact();
                        setState(() {
                          _detailedTvShow = null;
                          recommendations = null;
                          _loadTvShowBaseDetails();
                        });
                      },
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScaffoldContent(
      BuildContext context, TvShow tvShow, bool isBackgroundOnly) {
    if (isBackgroundOnly) {
      return CustomScrollView(
        slivers: [
          _buildAppBar(context, tvShow),
          SliverToBoxAdapter(
              child: _buildTvShowHeader(
                  context, tvShow, true)), // pass true for shimmer
        ],
      );
    }
    return _buildDetailView(context, tvShow);
  }

  Widget _buildDetailView(BuildContext context, TvShow tvShow) {
    final series = widget.typec == "anime"
        ? Provider.of<ss.AnimeProvider>(context).getAnimeByTmdbId(tvShow.id)
        : Provider.of<ss.TvSeriesProvider>(context).getAnimeByTmdbId(tvShow.id);
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (Platform.isAndroid && scrollInfo is ScrollUpdateNotification) {
          // Trigger a subtle haptic feedback on scroll
          HapticFeedback.selectionClick();
        }
        return false;
      },
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            _buildAppBar(context, tvShow),
            SliverToBoxAdapter(
                child: _buildTvShowHeader(context, tvShow, false)),
            SliverPersistentHeader(
              delegate: _SliverAppBarDelegate(
                TabBar(
                  controller: _tabController,
                  tabs: _tabs,
                  isScrollable: true,
                  indicatorColor: Theme.of(context).colorScheme.secondary,
                  labelColor: Theme.of(context).colorScheme.secondary,
                  unselectedLabelColor: Colors.grey,
                  onTap: (index) {
                    if (Platform.isAndroid) HapticFeedback.lightImpact();
                  },
                ),
              ),
              pinned: true,
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildOverviewTab(context, tvShow),
            (series == null)
                ? Center(child: Text("No content exist"))
                : _buildSeasonsList(context, series.seasons, series.tmdbId),
            _buildSeasonsTab(context, tvShow),
            _buildCastTab(context, tvShow.id),
            _buildVideosTab(context, tvShow.id),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, TvShow tvShow) {
    int tvSeriesId = tvShow.id;
    final userDataService = Provider.of<UserDataService>(context);
    final backdropUrl = tvShow.fullBackdropPath;
    final posterUrl = tvShow.fullPosterPath; // Used as fallback image
    bool isFavorite = userDataService.isFavoriteAnime(tvSeriesId);
    bool isInWatchlist = userDataService.isOnWatchlistAnime(tvSeriesId);

    return SliverAppBar(
        expandedHeight: 600,
        pinned: true,
        flexibleSpace: FlexibleSpaceBar(
          title: Text(tvShow.name,
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
                  ..shader = LinearGradient(
                    colors: [
                      Color(0xFFFF6B6B),
                      Color(0xFF4ECDC4),
                      Color(0xFF45B7D1),
                      Color(0xFF96CEB4),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(Rect.fromLTWH(0, 0, 300, 100)),
              )),
          background: Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Backdrop Image
                CachedNetworkImage(
                  imageUrl: backdropUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: AppColors.secondaryBackground,
                    child: Center(
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[800]!,
                        highlightColor: Colors.grey[700]!,
                        child: const Icon(Icons.image,
                            size: 80, color: Colors.white12),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: AppColors.secondaryBackground,
                    child: posterUrl.isNotEmpty // Try poster as fallback
                        ? CachedNetworkImage(
                            imageUrl: posterUrl,
                            fit: BoxFit.contain,
                            alignment: Alignment.center,
                            placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 1,
                                color: AppColors.accentColor,
                              ),
                            ),
                            errorWidget: (context, url, error) => Center(
                              child: Icon(
                                Icons.tv_off_outlined,
                                color: AppColors.secondaryText,
                                size: 40,
                              ),
                            ),
                            fadeInDuration: const Duration(milliseconds: 300),
                            fadeOutDuration: const Duration(milliseconds: 100),
                          )
                        : const Center(
                            child: Icon(Icons.tv_off_outlined,
                                color: AppColors.secondaryText, size: 40)),
                  ),
                  fadeInDuration: const Duration(milliseconds: 300),
                  fadeOutDuration: const Duration(milliseconds: 100),
                ),
                // Gradient overlay for text readability
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
                          if (Platform.isAndroid) HapticFeedback.lightImpact();
                          await userDataService.toggleFavoriteAnime(tvSeriesId);
                          if (mounted) {
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
                          }
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
                          '${tvShow.voteAverage.toStringAsFixed(1)} (${tvShow.voteCount})',
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
                        onPressed: () async {
                          if (Platform.isAndroid) HapticFeedback.lightImpact();
                          await userDataService
                              .toggleWatchlistAnime(tvSeriesId);
                          if (mounted) {
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
                          }
                        },
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.black.withOpacity(0.5),
                          padding: const EdgeInsets.all(4.0),
                        ),
                      ),
                    ],
                  ),
                ),
                if (tvShow.tagline != null && tvShow.tagline!.isNotEmpty)
                  Positioned(
                    bottom: 60,
                    left: 16,
                    right: 16,
                    child: Text(
                      '"${tvShow.tagline!}"',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                        fontSize: 14,
                        shadows: [
                          Shadow(
                              blurRadius: 5.0,
                              color: Colors.black,
                              offset: Offset(1.0, 1.0)),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ));
  }

  Widget _buildTvShowHeader(
      BuildContext context, TvShow tvShow, bool showShimmer) {
    Widget posterWidget = tvShow.fullPosterPath.isNotEmpty
        ? CachedNetworkImage(
            imageUrl: tvShow.fullPosterPath,
            fit: BoxFit.cover,
            placeholder: (context, url) => showShimmer
                ? Shimmer.fromColors(
                    baseColor: Colors.grey[800]!,
                    highlightColor: Colors.grey[700]!,
                    child: Container(color: Colors.black),
                  )
                : const Center(
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
            fadeInDuration: const Duration(milliseconds: 200),
            fadeOutDuration: const Duration(milliseconds: 100),
          )
        : const Center(
            child: Icon(Icons.tv_off_outlined,
                color: AppColors.secondaryText, size: 40),
          );

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: 'tvshow-${tvShow.id}',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 120,
                height: 180,
                child: posterWidget,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tvShow.name,
                    style: Theme.of(context).textTheme.titleLarge),
                if (tvShow.originalName != tvShow.name)
                  Text('(${tvShow.originalName})',
                      style: TextStyle(color: Colors.grey[400], fontSize: 14)),
                const SizedBox(height: 8),
                Row(children: [
                  const Icon(Icons.star, color: Colors.amber, size: 20),
                  const SizedBox(width: 4),
                  Text(
                      '${tvShow.voteAverage.toStringAsFixed(1)} (${tvShow.voteCount} votes)',
                      style: Theme.of(context).textTheme.bodyMedium),
                ]),
                const SizedBox(height: 8),
                Row(children: [
                  const Icon(Icons.calendar_today, size: 16),
                  const SizedBox(width: 4),
                  Expanded(
                      child: Text(tvShow.airDateRange,
                          style: Theme.of(context).textTheme.bodyMedium)),
                ]),
                const SizedBox(height: 8),
                if (tvShow.episodeRunTime != null &&
                    tvShow.episodeRunTime!.isNotEmpty)
                  Row(children: [
                    const Icon(Icons.timer, size: 16),
                    const SizedBox(width: 4),
                    Text('Avg. Episode: ${tvShow.formattedRuntime}',
                        style: Theme.of(context).textTheme.bodyMedium),
                  ]),
                const SizedBox(height: 8),
                if (tvShow.originCountry.isNotEmpty)
                  Row(children: [
                    const Icon(Icons.flag_outlined, size: 16),
                    const SizedBox(width: 4),
                    Expanded(
                        child: Text(tvShow.originCountryText,
                            style: Theme.of(context).textTheme.bodyMedium)),
                  ]),
                const SizedBox(height: 8),
                if (tvShow.status != null)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(tvShow.status!),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(tvShow.formattedStatus,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab(BuildContext context, TvShow tvShow) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Overview', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
              tvShow.overview.isEmpty
                  ? 'No overview available.'
                  : tvShow.overview,
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 24),

          if (tvShow.genres != null && tvShow.genres!.isNotEmpty) ...[
            Text('Genres', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Wrap(
                spacing: 8,
                runSpacing: 8,
                children: tvShow.genres!
                    .map((genre) => Chip(
                        label: Text(genre.name),
                        backgroundColor: Colors.grey[800]))
                    .toList()),
            const SizedBox(height: 24),
          ],

          if (tvShow.createdBy != null && tvShow.createdBy!.isNotEmpty) ...[
            Text('Created by', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: tvShow.createdBy!.length,
                itemBuilder: (context, index) {
                  final creator = tvShow.createdBy![index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: GestureDetector(
                      onTap: () => _navigateToPersonDetail(
                          creator.id, creator.name, creator.profilePath),
                      child: SizedBox(
                        width: 90,
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              child: creator.profilePath != null
                                  ? CachedNetworkImage(
                                      imageUrl: creator.fullProfilePath,
                                      fit: BoxFit.cover,
                                      width: 80,
                                      height: 80,
                                      imageBuilder: (context, imageProvider) =>
                                          CircleAvatar(
                                              backgroundImage: imageProvider,
                                              radius: 40),
                                      placeholder: (context, url) =>
                                          CircularProgressIndicator(
                                              strokeWidth: 1,
                                              color: AppColors.accentColor),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.person,
                                              size: 40,
                                              color: AppColors.secondaryText),
                                      fadeInDuration:
                                          const Duration(milliseconds: 300),
                                      fadeOutDuration:
                                          const Duration(milliseconds: 100),
                                    )
                                  : const Icon(Icons.person,
                                      size: 40, color: AppColors.secondaryText),
                            ),
                            const SizedBox(height: 8),
                            Text(creator.name,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 12)),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Last and Next Episode
          if (tvShow.nextEpisodeToAir != null) ...[
            Text('Next Episode to Air',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            _buildEpisodeCard(
                context, tvShow.id, tvShow.nextEpisodeToAir!, true),
            const SizedBox(height: 24),
          ],
          if (tvShow.lastEpisodeToAir != null) ...[
            Text('Last Episode Aired',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            _buildEpisodeCard(
                context, tvShow.id, tvShow.lastEpisodeToAir!, false),
            const SizedBox(height: 24),
          ],

          if (tvShow.networks != null && tvShow.networks!.isNotEmpty) ...[
            Text('Networks', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            // TODO: Add actual network display code here if needed
            SizedBox(
              height: 150, // Example height
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: tvShow.networks!.length,
                itemBuilder: (context, index) {
                  final network = tvShow.networks![index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: SizedBox(
                      width: 250, // Adjust width as needed
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (network.logoPath != null)
                            CachedNetworkImage(
                              imageUrl:
                                  'https://image.tmdb.org/t/p/h60${network.logoPath}',
                              height: 100,
                              fit: BoxFit.contain,
                              placeholder: (context, url) => Shimmer.fromColors(
                                baseColor: Colors.grey[800]!,
                                highlightColor: Colors.grey[700]!,
                                child:
                                    Container(color: Colors.black, height: 30),
                              ),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.tv, color: Colors.grey[600]),
                            )
                          else
                            Text(network.name,
                                style: TextStyle(color: Colors.white70)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
          ],

          if (tvShow.numberOfSeasons != null ||
              tvShow.numberOfEpisodes != null) ...[
            Text('Show Statistics',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if (tvShow.numberOfSeasons != null)
                  Expanded(
                      child: _buildStatCard(
                          context,
                          'Seasons',
                          tvShow.numberOfSeasons.toString(),
                          Icons.movie_filter_outlined)),
                if (tvShow.numberOfSeasons != null &&
                    tvShow.numberOfEpisodes != null)
                  const SizedBox(width: 16),
                if (tvShow.numberOfEpisodes != null)
                  Expanded(
                      child: _buildStatCard(
                          context,
                          'Episodes',
                          tvShow.numberOfEpisodes.toString(),
                          Icons.list_alt_outlined)),
              ],
            ),
            const SizedBox(height: 24),
          ],

          _buildRecommendationsSection(context, tvShow),
        ],
      ),
    );
  }

  Widget _buildSeasonsTab(BuildContext context, TvShow tvShow) {
    if (tvShow.seasons == null || tvShow.seasons!.isEmpty) {
      return const Center(child: Text('No seasons information available.'));
    }

    final sortedSeasons = List<Season>.from(tvShow.seasons!)
      ..sort((a, b) => a.seasonNumber.compareTo(b.seasonNumber));
    return ListView.builder(
      shrinkWrap: false,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      itemCount: sortedSeasons.length,
      itemBuilder: (context, index) {
        final season = sortedSeasons[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16.0),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              if (Platform.isAndroid) HapticFeedback.lightImpact();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SeasonDetailPageAnime(
                    tvShowId: tvShow.id,
                    seasonNumber: season.seasonNumber,
                    seasonName: season.name,
                    posterPath: season.posterPath,
                    movieService: _movieService,
                    typec: widget.typec,
                  ),
                ),
              );
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 200,
                  height: 300,
                  child: CachedNetworkImage(
                    imageUrl: season.fullPosterPath,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey[800]!,
                      highlightColor: Colors.grey[700]!,
                      child: Container(color: Colors.black),
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
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(season.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 4),
                        Text(
                            '${season.episodeCount} episodes \u2022 Air Date: ${season.formattedAirDate}',
                            style: TextStyle(
                                color: Colors.grey[400], fontSize: 14)),
                        if (season.voteAverage > 0) ...[
                          const SizedBox(height: 4),
                          Row(children: [
                            const Icon(Icons.star,
                                color: Colors.amber, size: 20),
                            const SizedBox(width: 4),
                            Text(season.voteAverage.toStringAsFixed(1),
                                style: const TextStyle(fontSize: 16)),
                          ]),
                        ],
                        const SizedBox(height: 8),
                        if (season.overview != null &&
                            season.overview!.isNotEmpty)
                          Text(season.overview!,
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 15)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCastTab(BuildContext context, int tvShowId) {
    _creditsFuture ??= _movieService.getTVCredits(tvId: tvShowId);
    return FutureBuilder<TVCredits>(
      future: _creditsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.6,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: 9, // Show a few shimmer items
            itemBuilder: (context, index) {
              return Shimmer.fromColors(
                baseColor: Colors.grey[800]!,
                highlightColor: Colors.grey[700]!,
                child: Column(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Container(color: Colors.black),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                        width: double.infinity,
                        height: 10,
                        color: Colors.black),
                    const SizedBox(height: 4),
                    Container(
                        width: double.infinity, height: 8, color: Colors.black),
                  ],
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error loading cast: ${snapshot.error}'));
        } else if (snapshot.hasData && snapshot.data!.cast.isNotEmpty) {
          final cast = snapshot.data!.cast
            ..sort((a, b) => a.order.compareTo(b.order));
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.6,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: cast.length,
            itemBuilder: (context, index) {
              final member = cast[index];
              return GestureDetector(
                onTap: () => _navigateToPersonDetail(
                    member.id, member.name, member.profilePath),
                child: Column(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: member.profileImageUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Shimmer.fromColors(
                            baseColor: Colors.grey[800]!,
                            highlightColor: Colors.grey[700]!,
                            child: Container(color: Colors.black),
                          ),
                          errorWidget: (context, url, error) => const Center(
                            child: Icon(
                              Icons.person,
                              color: AppColors.secondaryText,
                              size: 30,
                            ),
                          ),
                          fadeInDuration: const Duration(milliseconds: 200),
                          fadeOutDuration: const Duration(milliseconds: 100),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(member.name,
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(member.character,
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style:
                            TextStyle(fontSize: 14, color: Colors.grey[400])),
                  ],
                ),
              );
            },
          );
        } else {
          return const Center(child: Text('No cast information available.'));
        }
      },
    );
  }

  Widget _buildVideosTab(BuildContext context, int tvShowId) {
    _videosFuture ??= _movieService.getTvShowVideos(tvShowId: tvShowId);
    return FutureBuilder<YoutubeVideoForSeries>(
      future: _videosFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: 3, // Show a few shimmer items
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                clipBehavior: Clip.antiAlias,
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[800]!,
                  highlightColor: Colors.grey[700]!,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          height: 500,
                          width: double.infinity,
                          color: Colors.black),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                            height: 16,
                            width: double.infinity,
                            color: Colors.black),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 12.0, right: 12.0, bottom: 12.0),
                        child: Container(
                            height: 12, width: 100, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error loading videos: ${snapshot.error}'));
        } else if (snapshot.hasData && snapshot.data!.results.isNotEmpty) {
          final videos = snapshot.data!.results
              .where((v) => v.site.toLowerCase() == 'youtube')
              .toList();
          if (videos.isEmpty) {
            return const Center(child: Text('No YouTube videos available.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: videos.length,
            itemBuilder: (context, index) {
              final video = videos[index];
              final thumbnailUrl =
                  'https://img.youtube.com/vi/${video.key}/hqdefault.jpg';
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () => _launchUrl(video.youtubeUrl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          CachedNetworkImage(
                            imageUrl: thumbnailUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 500,
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: Colors.grey[800]!,
                              highlightColor: Colors.grey[700]!,
                              child: Container(color: Colors.black),
                            ),
                            errorWidget: (context, url, error) => Container(
                              height: 500,
                              color: Colors.grey[800],
                              child: const Center(
                                child: Icon(Icons.play_circle_fill,
                                    size: 50, color: AppColors.secondaryText),
                              ),
                            ),
                            fadeInDuration: const Duration(milliseconds: 200),
                            fadeOutDuration: const Duration(milliseconds: 100),
                          ),
                          Icon(Icons.play_circle_fill,
                              color: Colors.white.withOpacity(0.8), size: 60),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(video.name,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 12.0, right: 12.0, bottom: 12.0),
                        child: Text(video.type,
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[400])),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else {
          return const Center(child: Text('No videos available.'));
        }
      },
    );
  }

  Widget _buildSeasonsList(
      BuildContext context, List<ss.Season> seasons, int TvseriesId) {
    bool defaultExpansion = seasons.length == 1;

    return SizedBox(
      height: 700, // Adjust as needed
      child: ListView.builder(
        controller: _seasonsScrollController,
        shrinkWrap: false,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: seasons.length,
        itemBuilder: (context, index) {
          final season = seasons[index];

          // ...existing ExpansionTile code...
          // Use ExpansionTile for collapsable seasons
          return Card(
            // Wrap ExpansionTile in a Card for better visual separation
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
                    color: AppColors.primaryText,
                    fontWeight: FontWeight.w600,
                    fontSize: 16),
              ),
              subtitle: Text(
                '${season.episodes.length} Episode${season.episodes.length == 1 ? '' : 's'}',
                style: const TextStyle(
                    color: AppColors.secondaryText, fontSize: 12),
              ),
              iconColor:
                  AppColors.accentColor, // Use accent color for expand icon
              collapsedIconColor: AppColors.secondaryText,
              // Expand first season or if only one season exists
              initiallyExpanded: defaultExpansion ||
                  season.seasonNumber ==
                      1, // Keep first season expanded usually
              childrenPadding: const EdgeInsets.only(
                  bottom: 8.0, left: 4, right: 4), // Padding for episode tiles
              // Remove default dividers and use padding/margin on EpisodeTile instead
              // children: season.episodes.map((episode) => EpisodeTile(episode: episode)).toList(),

              children: ListTile.divideTiles(
                // Add subtle dividers between episodes
                context: context,
                color: AppColors.dividerColor.withOpacity(0.3),
                tiles: season.episodes
                    .map((episode) => EpisodeTileNew(
                          seriesname: widget.tvShow.name,
                          episode: episode,
                          season: season,
                          id: TvseriesId,
                        ))
                    .toList(),
              ).toList(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEpisodeCard(
      BuildContext context, int tvShowId, m.Episode episode, bool isNext) {
    return Card(
      color: isNext
          ? Theme.of(context).colorScheme.secondary.withOpacity(0.1)
          : Colors.grey[850],
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          if (Platform.isAndroid) HapticFeedback.lightImpact();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EpisodeDetailPage(
                tvShowId: tvShowId,
                seasonNumber: episode.seasonNumber,
                episodeNumber: episode.episodeNumber,
                episodeName: episode.name,
                movieService: _movieService,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                      color: isNext
                          ? Theme.of(context).colorScheme.secondary
                          : Colors.grey[700],
                      borderRadius: BorderRadius.circular(4)),
                  child: Text(
                    'S${episode.seasonNumber} | E${episode.episodeNumber}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
                const SizedBox(width: 8),
                if (episode.episodeType != 'standard')
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getEpisodeTypeColor(episode.episodeType),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      episode.episodeType.replaceAll('_', ' ').toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ]),
              const SizedBox(height: 12),
              Text(episode.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 8),
              Text('Air date: ${episode.formattedAirDate}',
                  style: TextStyle(
                      color: isNext
                          ? Theme.of(context)
                              .colorScheme
                              .secondary
                              .withOpacity(0.8)
                          : Colors.grey[400],
                      fontSize: 14)),
              if (episode.runtime != null) ...[
                const SizedBox(height: 4),
                Text('Runtime: ${episode.formattedRuntime}',
                    style: TextStyle(color: Colors.grey[400], fontSize: 14)),
              ],
              const SizedBox(height: 12),
              if (episode.stillPath != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: episode.fullStillPath,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 500,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey[800]!,
                      highlightColor: Colors.grey[700]!,
                      child: Container(color: Colors.black),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 500,
                      color: Colors.grey[800],
                      child: const Center(
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          color: AppColors.secondaryText,
                          size: 30,
                        ),
                      ),
                    ),
                    fadeInDuration: const Duration(milliseconds: 300),
                    fadeOutDuration: const Duration(milliseconds: 100),
                  ),
                ),
              const SizedBox(height: 12),
              Text(episode.overview,
                  style: const TextStyle(fontSize: 14),
                  maxLines: 6,
                  overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
      BuildContext context, String title, String value, IconData icon) {
    return Card(
      color: Colors.grey[850],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon,
                size: 30, color: Theme.of(context).colorScheme.secondary),
            const SizedBox(height: 8),
            Text(title, style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 4),
            Text(value,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Returning Series':
        return Colors.green;
      case 'Ended':
        return Colors.orange;
      case 'Canceled':
        return Colors.red;
      case 'In Production':
        return Colors.blue;
      case 'Pilot':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  Color _getEpisodeTypeColor(String episodeType) {
    switch (episodeType) {
      case 'finale':
        return Colors.red.shade700;
      case 'mid_season':
        return Colors.orange.shade700;
      case 'premiere':
        return Colors.green.shade700;
      default:
        return Colors.blueGrey.shade700; // Standard or other
    }
  }

  Widget _buildRecommendationsSection(BuildContext context, tvshowitemm) {
    if (recommendations == null || recommendations!.results.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 24.0, bottom: 12.0),
          child: Text('Recommended Shows',
              style: Theme.of(context).textTheme.titleLarge),
        ),
        TextButton(
          onPressed: () {
            if (Platform.isAndroid) HapticFeedback.lightImpact();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      RecommendationsPage( movieId: widget.tvShow.id, movieTitle: widget.tvShow.name,typec: widget.typec,)),
            );
          },
          child: Text("Show All Recommends"),
        ),
        SizedBox(
          height: 230,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: recommendations!.results.length > 15
                ? 10
                : recommendations!.results.length,
            itemBuilder: (context, index) {
              final tvShow = recommendations!.results[index];
              return _buildRecommendationCard(context, tvShow);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendationCard(BuildContext context, TvShow tvShow) {
    return GestureDetector(
      onTap: () {
        if (Platform.isAndroid) HapticFeedback.lightImpact();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  TvShowDetailPageAnime(tvShow: tvShow, typec: widget.typec)),
        );
      },
      child: Container(
        width: 130,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'tv-recommendation-${tvShow.id}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: tvShow.fullPosterPath,
                      height: 170,
                      width: 130,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: Colors.grey[800]!,
                        highlightColor: Colors.grey[700]!,
                        child: Container(
                            color: Colors.black, height: 170, width: 130),
                      ),
                      errorWidget: (context, url, error) => Container(
                        height: 170,
                        width: 130,
                        color: Colors.grey[800],
                        child: const Center(
                          child: Icon(
                            Icons.tv_off_outlined,
                            color: AppColors.secondaryText,
                            size: 30,
                          ),
                        ),
                      ),
                      fadeInDuration: const Duration(milliseconds: 300),
                      fadeOutDuration: const Duration(milliseconds: 100),
                    ),
                    if (tvShow.voteAverage > 0)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: _getRatingColor(tvShow.voteAverage),
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8)),
                          ),
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            const Icon(Icons.star,
                                color: Colors.white, size: 12),
                            const SizedBox(width: 2),
                            Text(tvShow.voteAverage.toStringAsFixed(1),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold)),
                          ]),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(tvShow.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            if (tvShow.firstAirDate != null && tvShow.firstAirDate!.isNotEmpty)
              Text(tvShow.year,
                  style: TextStyle(fontSize: 11, color: Colors.grey[400])),
          ],
        ),
      ),
    );
  }

  Color _getRatingColor(double rating) {
    if (rating >= 7.5) return Colors.green.shade700;
    if (rating >= 5.0) return Colors.orange.shade700;
    if (rating > 0) return Colors.red.shade700;
    return Colors.blueGrey.shade700;
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;
  _SliverAppBarDelegate(this._tabBar);
  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
        color: Theme.of(context).scaffoldBackgroundColor, child: _tabBar);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) => false;
}

// Assuming EpisodeTileNew is defined elsewhere and might need haptic feedback on its own InkWell/GestureDector
// If not provided, you should add a tap callback to it inside buildSeasonsList
// Example of how EpisodeTileNew might look (simplified):
// class EpisodeTileNew extends StatelessWidget {
//   final String seriesname;
//   final Episode episode;
//   final ss.Season season;
//   final int id;
//   final VoidCallback? onTap; // Add this callback for haptic feedback

//   const EpisodeTileNew({
//     Key? key,
//     required this.seriesname,
//     required this.episode,
//     required this.season,
//     required this.id,
//     this.onTap, // Initialize it
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         onTap?.call(); // Call the passed onTap callback
//         // Add navigation logic here if needed
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => EpisodeDetailPage(
//               tvShowId: id,
//               seasonNumber: episode.seasonNumber,
//               episodeNumber: episode.episodeNumber,
//               episodeName: episode.name,
//               // Pass movieService if needed
//               movieService:
//                   MovieService(), // Assuming MovieService can be instantiated
//             ),
//           ),
//         );
//       },
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(
//               width: 100,
//               height: 70,
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(4),
//                 child: CachedNetworkImage(
//                   imageUrl: episode.fullStillPath,
//                   fit: BoxFit.cover,
//                   placeholder: (context, url) => Shimmer.fromColors(
//                     baseColor: Colors.grey[800]!,
//                     highlightColor: Colors.grey[700]!,
//                     child: Container(color: Colors.black),
//                   ),
//                   errorWidget: (context, url, error) => const Center(
//                     child: Icon(
//                       Icons.movie,
//                       color: AppColors.secondaryText,
//                       size: 20,
//                     ),
//                   ),
//                   fadeInDuration: const Duration(milliseconds: 300),
//                   fadeOutDuration: const Duration(milliseconds: 100),
//                 ),
//               ),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'E${episode.episodeNumber}: ${episode.name}',
//                     style: const TextStyle(
//                         fontWeight: FontWeight.bold, fontSize: 13),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     'Air date: ${episode.formattedAirDate}',
//                     style: TextStyle(fontSize: 11, color: Colors.grey[400]),
//                   ),
//                   if (episode.runtime != null)
//                     Text(
//                       'Runtime: ${episode.formattedRuntime}',
//                       style: TextStyle(fontSize: 11, color: Colors.grey[400]),
//                     ),
//                   const SizedBox(height: 4),
//                   if (episode.voteAverage > 0)
//                     Row(
//                       children: [
//                         const Icon(Icons.star, color: Colors.amber, size: 12),
//                         const SizedBox(width: 4),
//                         Text(
//                           episode.voteAverage.toStringAsFixed(1),
//                           style: const TextStyle(fontSize: 11),
//                         ),
//                       ],
//                     ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
