import 'dart:io'; // Import for Platform check
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for HapticFeedback
import 'package:miko/providers/god_proovider.dart' as ss;
import 'package:miko/services/user_data_service.dart';
import 'package:miko/showcases/anime_detail_header.dart';
import 'package:miko/showcases/anime_detail_utils.dart';
import 'package:miko/showcases/recommendations_page.dart';
import 'package:miko/utils/ai_translator.dart';
import 'package:miko/utils/utils.dart' hide ShareItem;
import 'package:miko/widgets/episode_tile_widget.dart';
import 'package:share_plus/share_plus.dart';
import '../widgets/anime_series_card.dart'; // Keep if used elsewhere
import 'anime_detail_app_bar.dart';
import 'anime_episode_widgets.dart';
import 'anime_recommendations.dart';
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

// Imported extracted widgets and utilities
import 'package:miko/showcases/mixins/translation_mixin.dart';
import 'package:miko/showcases/utils/haptic_helper.dart';
import 'package:miko/showcases/utils/detail_page_navigation.dart';
import 'package:miko/widgets/tv_detail/tv_show_stat_card.dart';
import 'package:miko/widgets/tv_detail/tv_show_genres_section.dart';
import 'package:miko/widgets/tv_detail/tv_show_creators_section.dart';

// ignore: must_be_immutable
class TvShowDetailPageAnime extends StatefulWidget {
  var tvShow;
  String typec;
  TvShowDetailPageAnime({super.key, required this.tvShow, required this.typec});

  @override
  State<TvShowDetailPageAnime> createState() => _TvShowDetailPageAnimeState();
}

class _TvShowDetailPageAnimeState extends State<TvShowDetailPageAnime>
    with SingleTickerProviderStateMixin, TranslationMixin {
  final MovieService _movieService = MovieService();
  late Future<Map<String, dynamic>> _tvShowDataFuture;
  final ScrollController _seasonsScrollController = ScrollController();

  late TabController _tabController;
  TvShowResponse? recommendations;
  TvShow? _detailedTvShow; // Store the fully loaded TvShow object
  bool tr = false;
  String oveview = '';
  // Futures for tab-specific data
  Future<TVCredits>? creditsFuture;
  Future<YoutubeVideoForSeries>? _videosFuture;

  final List<Tab> _tabs = [
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
    _seasonsScrollController.dispose();
    super.dispose();
  }

  void _loadTvShowBaseDetails() {
    _tvShowDataFuture = _movieService.getTvShowDetailsWithRecommendations(
      tvShowId: widget.tvShow.id,
    );
    _tvShowDataFuture
        .then((data) {
          if (mounted && data['details'] != null) {
            TvShow loadedShow = data['details'] as TvShow;
            setState(() {
              _detailedTvShow = loadedShow;
              creditsFuture = _movieService.getTVCredits(tvId: loadedShow.id);
              _videosFuture = _movieService.getTvShowVideos(
                tvShowId: loadedShow.id,
              );
            });
          }
        })
        .catchError((e) {
          debugPrint("Error loading base TV Show details: $e");
        });
  }

  void _navigateToPersonDetail(int personId, String name, String? profilePath) {
    HapticHelper.performHapticFeedback();
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
    HapticHelper.performHapticFeedback();
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Could not launch $urlString')));
      }
    }
  }

  void loader() async {
    if (tr == false) {
      oveview = widget.tvShow.overview;
    }
  }

  @override
  Widget build(BuildContext context) {
    loader();
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: _tvShowDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              _detailedTvShow == null) {
            return _buildLoadingView(
              widget.tvShow,
            ); // Use initial basic tvShow for loading view
          } else if (snapshot.hasError && _detailedTvShow == null) {
            return _buildErrorView(
              context,
              "An unexpected error occurred.",
              widget.tvShow,
            );
          } else if (snapshot.hasData || _detailedTvShow != null) {
            if (snapshot.hasData) {
              _detailedTvShow = snapshot.data!['details'] as TvShow?;
              recommendations =
                  snapshot.data!['recommendations'] as TvShowResponse?;
            }
            if (_detailedTvShow == null) {
              return _buildErrorView(
                context,
                "Failed to load show details.",
                widget.tvShow,
              );
            }
            return _buildDetailView(context, _detailedTvShow!);
          } else {
            return _buildErrorView(
              context,
              "An unexpected error occurred.",
              widget.tvShow,
            );
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
    BuildContext context,
    String errorMessage,
    TvShow basicTvShow,
  ) {
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
                    const Icon(
                      Icons.error_outline,
                      size: 60,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading TV show details',
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      errorMessage,
                      textAlign: TextAlign.center,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        HapticHelper.performHapticFeedback();
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
    BuildContext context,
    TvShow tvShow,
    bool isBackgroundOnly,
  ) {
    if (isBackgroundOnly) {
      return CustomScrollView(
        slivers: [
          AnimeDetailAppBar(
            tvShow: tvShow,
            onTranslateTitle: () async {
              tVClick();
              gentranslate();
            },
            overview: oveview,
          ),
          SliverToBoxAdapter(
            child: AnimeDetailHeader(
              tvShow: tvShow,
              showShimmer: true,
              onTranslate: () async {
                tVClick();
                // toggle: if already translated, revert to original by clearing translated text
                await toggleTitleTranslation(tvShow.name);
                if (translatedTitle != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Title translated'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                }
              },
              isTranslating: isTranslating,
            ),
          ), // pass true for shimmer
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
          HapticHelper.performSelectionClick();
        }
        return false;
      },
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            AnimeDetailAppBar(
              tvShow: tvShow,
              onTranslateTitle: () async {
                tVClick();
                gentranslate();
              },
              overview: oveview,
            ),
            SliverToBoxAdapter(
              child: AnimeDetailHeader(
                tvShow: tvShow,
                showShimmer: false,
                onTranslate: () async {
                  tVClick();
                  // toggle: if already translated, revert to original by clearing translated text
                  await toggleTitleTranslation(tvShow.name);
                  if (translatedTitle != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Title translated'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  }
                },
                isTranslating: isTranslating,
              ),
            ),
            SliverPersistentHeader(
              delegate: SliverAppBarDelegate(
                TabBar(
                  controller: _tabController,
                  tabs: _tabs,
                  isScrollable: true,
                  indicatorColor: Theme.of(context).colorScheme.secondary,
                  labelColor: Theme.of(context).colorScheme.secondary,
                  unselectedLabelColor: Colors.grey,
                  onTap: (index) {
                    HapticHelper.performHapticFeedback();
                  },
                ),
              ),
              pinned: true,
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          physics: PageScrollPhysics(),
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

  Widget _buildOverviewTab(BuildContext context, TvShow tvShow) {
    var userDataService = Provider.of<UserDataService>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Overview', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          IconButton(
            iconSize: 20.0,
            icon: const Icon(Icons.assistant),
            tooltip: 'translate overview',
            onPressed: () async {
              tVClick();
              gentranslate();
            },
            onLongPress: () {
              showTextInputDialog(context, userDataService);
            },
          ),
          Text(
            oveview == '' ? 'No overview available.' : oveview,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),

          if (tvShow.genres != null && tvShow.genres!.isNotEmpty)
            TvShowGenresSection(genres: tvShow.genres!),

          if (tvShow.createdBy != null && tvShow.createdBy!.isNotEmpty)
            TvShowCreatorsSection(
              creators: tvShow.createdBy!,
              onCreatorTap: _navigateToPersonDetail,
            ),

          // Last and Next Episode
          if (tvShow.nextEpisodeToAir != null) ...[
            Text(
              'Next Episode to Air',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
EpisodeCardWidget(
              
              
               episode: tvShow.lastEpisodeToAir!, tvShowId: tvShow.id, isNext: false, onTap:  () {
          HapticHelper.performHapticFeedback();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EpisodeDetailPage(
                tvShowId: tvShow.id,
                seasonNumber: tvShow.lastEpisodeToAir!.seasonNumber,
                episodeNumber: tvShow.lastEpisodeToAir!.episodeNumber,
                episodeName: tvShow.lastEpisodeToAir!.name,
                movieService: _movieService,
              ),
            ),
          );
        },
            ),            const SizedBox(height: 24),
          ],
          if (tvShow.lastEpisodeToAir != null) ...[
            Text(
              'Last Episode Aired',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            EpisodeCardWidget(
              
              
               episode: tvShow.lastEpisodeToAir!, tvShowId: tvShow.id, isNext: false, onTap:  () {
          HapticHelper.performHapticFeedback();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EpisodeDetailPage(
                tvShowId: tvShow.id,
                seasonNumber: tvShow.lastEpisodeToAir!.seasonNumber,
                episodeNumber: tvShow.lastEpisodeToAir!.episodeNumber,
                episodeName: tvShow.lastEpisodeToAir!.name,
                movieService: _movieService,
              ),
            ),
          );
        },
            ),
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
                  var network = tvShow.networks![index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: SizedBox(
                      width: 250, // Adjust width as needed
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (network.logoPath != null)
                            CachedNetworkImage(
                              filterQuality: FilterQuality.high,
                              imageUrl:
                                  'https://image.tmdb.org/t/p/h60${network.logoPath}',
                              height: 100,
                              fit: BoxFit.contain,
                              placeholder: (context, url) => Shimmer.fromColors(
                                baseColor: Colors.grey[800]!,
                                highlightColor: Colors.grey[700]!,
                                child: Container(
                                  color: Colors.black,
                                  height: 30,
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.tv, color: Colors.grey[600]),
                            )
                          else
                            Text(
                              network.name,
                              style: TextStyle(color: Colors.white70),
                            ),
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
            Text(
              'Show Statistics',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if (tvShow.numberOfSeasons != null)
                  Expanded(
                    child: TvShowStatCard(
                      title: 'Seasons',
                      value: tvShow.numberOfSeasons.toString(),
                      icon: Icons.movie_filter_outlined,
                    ),
                  ),
                if (tvShow.numberOfSeasons != null &&
                    tvShow.numberOfEpisodes != null)
                  const SizedBox(width: 16),
                if (tvShow.numberOfEpisodes != null)
                  Expanded(
                    child: TvShowStatCard(
                      title: 'Episodes',
                      value: tvShow.numberOfEpisodes.toString(),
                      icon: Icons.list_alt_outlined,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 24),
          ],

          RecommendationsSectionWidget(
            recommendations: recommendations,
            onShowAllPressed: () {
              HapticHelper.performHapticFeedback();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => RecommendationsPage(
                    movieId: widget.tvShow.id,
                    movieTitle: widget.tvShow.name,
                    typec: widget.typec,
                  ),
                ),
              );
            },
            onRecommendationTapped: () {
              HapticHelper.performHapticFeedback();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => TvShowDetailPageAnime(
                    tvShow: tvShow,
                    typec: widget.typec,
                  ),
                ),
              );
            },
            recommendationsM: null,
          ),
        ],
      ),
    );
  }

  Widget _buildSeasonsTab(BuildContext context, TvShow tvShow) {
    if (tvShow.seasons == null || tvShow.seasons!.isEmpty) {
      return const Center(child: Text('No seasons information available.'));
    }

    List<Season> sortedSeasons = List<Season>.from(tvShow.seasons!)
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
              HapticHelper.performHapticFeedback();
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
                    filterQuality: FilterQuality.high,
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
                        Text(
                          season.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${season.episodeCount} episodes \u2022 Air Date: ${season.formattedAirDate}',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 14,
                          ),
                        ),
                        if (season.voteAverage > 0) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 20,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                season.voteAverage.toStringAsFixed(1),
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 8),
                        if (season.overview != null &&
                            season.overview!.isNotEmpty)
                          Text(
                            season.overview!,
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 15),
                          ),
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
    var creditsFuture = _movieService.getTVCredits(tvId: tvShowId);
    return FutureBuilder<TVCredits>(
      future: creditsFuture,
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
                      color: Colors.black,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: double.infinity,
                      height: 8,
                      color: Colors.black,
                    ),
                  ],
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error loading cast: ${snapshot.error}'));
        } else if (snapshot.hasData && snapshot.data!.cast.isNotEmpty) {
          List<TVCast> cast = snapshot.data!.cast
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
              TVCast member = cast[index];
              return GestureDetector(
                onTap: () => _navigateToPersonDetail(
                  member.id,
                  member.name,
                  member.profilePath,
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          filterQuality: FilterQuality.high,
                          imageUrl: member.profileImageUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Shimmer.fromColors(
                            baseColor: Colors.grey[800]!,
                            highlightColor: Colors.grey[700]!,
                            child: Container(color: Colors.black),
                          ),
                          // errorWidget: (context, url, error) => const Center(
                          //   child: Icon(
                          //     Icons.person,
                          //     color: AppColors.secondaryText,
                          //     size: 30,
                          //   ),
                          //),
                          fadeInDuration: const Duration(milliseconds: 200),
                          fadeOutDuration: const Duration(milliseconds: 100),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      member.name,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      member.character,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                    ),
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
                        color: Colors.black,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                          height: 16,
                          width: double.infinity,
                          color: Colors.black,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 12.0,
                          right: 12.0,
                          bottom: 12.0,
                        ),
                        child: Container(
                          height: 12,
                          width: 100,
                          color: Colors.black,
                        ),
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
          List<VideoForSeries> videos = snapshot.data!.results
              .where((v) => v.site.toLowerCase() == 'youtube')
              .toList();
          if (videos.isEmpty) {
            return const Center(child: Text('No YouTube videos available.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: videos.length,
            itemBuilder: (context, index) {
              VideoForSeries video = videos[index];
              String thumbnailUrl =
                  'https://linod.worker-inosuke.workers.dev/youtube/${video.key}/hqdefault.jpg';
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
                            filterQuality: FilterQuality.high,
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
                                  Icons.play_circle_fill,
                                  size: 50,
                                  color: AppColors.secondaryText,
                                ),
                              ),
                            ),
                            fadeInDuration: const Duration(milliseconds: 200),
                            fadeOutDuration: const Duration(milliseconds: 100),
                          ),
                          Icon(
                            Icons.play_circle_fill,
                            color: Colors.white.withOpacity(0.8),
                            size: 60,
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          video.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 12.0,
                          right: 12.0,
                          bottom: 12.0,
                        ),
                        child: Text(
                          video.type,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[400],
                          ),
                        ),
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
    BuildContext context,
    List<ss.Season> seasons,
    int TvseriesId,
  ) {
    bool defaultExpansion = seasons.length == 1;

    return SizedBox(
      height: 700, // Adjust as needed
      child: ListView.builder(
        controller: _seasonsScrollController,
        shrinkWrap: false,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: seasons.length,
        itemBuilder: (context, index) {
          ss.Season season = seasons[index];

          return Card(
            elevation: 1,
            margin: const EdgeInsets.symmetric(vertical: 6.0),
            color: AppColors.secondaryBackground.withOpacity(
              0.4,
            ), // Slightly transparent background
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            clipBehavior:
                Clip.antiAlias, // Ensures content respects border radius
            child: ExpansionTile(
              key: PageStorageKey(
                'season_${season.seasonNumber}',
              ), // Maintain expansion state
              title: Text(
                'Season ${season.seasonNumber}',
                style: const TextStyle(
                  color: Color.fromARGB(255, 255, 228, 108),
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              subtitle: Text(
                '${season.episodes.length} Episode${season.episodes.length == 1 ? '' : 's'}',
                style: const TextStyle(
                  color: Color.fromARGB(255, 157, 241, 59),
                  fontSize: 12,
                ),
              ),
              iconColor:
                  AppColors.accentColor, // Use accent color for expand icon
              collapsedIconColor: AppColors.secondaryText,
              initiallyExpanded: defaultExpansion || season.seasonNumber == 1,
              childrenPadding: const EdgeInsets.only(
                bottom: 8.0,
                left: 4,
                right: 4,
              ),
              children: ListTile.divideTiles(
                context: context,
                color: AppColors.dividerColor.withOpacity(0.3),
                tiles: season.episodes
                    .map(
                      (episode) => EpisodeTileNew(
                        seriesname: widget.tvShow.name,
                        episode: episode,
                        season: season,
                        id: TvseriesId,
                      ),
                    )
                    .toList(),
              ).toList(),
            ),
          );
        },
      ),
    );
  }


  void gentranslate() async {
    MovieTvTranslator translator = MovieTvTranslator();
    debugPrint(oveview);
    String translatedOverView = await translator.translateTextForMoviesAndTV(
      oveview,
    );
    debugPrint(translatedOverView);
    debugPrint(oveview);
    setState(() {
      tr = true;
      oveview = translatedOverView;

      debugPrint(oveview);
    });
  }
}
