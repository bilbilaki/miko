import 'dart:io' show Platform;
import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:miko/main.dart';

import 'package:miko/providers/god_proovider.dart' show MovieProvider;
import 'package:miko/screens/anime_grid_screen.dart';
import 'package:miko/screens/dl.dart';
import 'package:miko/screens/offline_screens/movie_detail_screen.dart';
import 'package:miko/screens/video_player_wplaylist_screen.dart';
import 'package:miko/showcases/anime_recommendations.dart';
import 'package:miko/showcases/cast_page.dart';
import 'package:miko/showcases/recommendations_page.dart';
import 'package:miko/utils/ai_translator.dart';
import 'package:miko/utils/utils.dart';
import 'package:miko/widgets/movie_links_box.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:miko/services/user_data_service.dart';
import 'package:miko/showcases/movies_by_keyword_screen.dart';
import 'package:miko/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'anime_detail_utils.dart';
import 'model.dart';
import 'movie_service.dart';
import 'person_detail_page.dart';
import 'package:share_plus/share_plus.dart';

// Imported extracted widgets
import 'package:miko/widgets/movie_detail/fade_in_widget.dart';
import 'package:miko/widgets/movie_detail/movie_detail_loading_view.dart';
import 'package:miko/widgets/movie_detail/movie_info_card.dart';
import 'package:miko/widgets/movie_detail/movie_tagline.dart';
import 'package:miko/widgets/movie_detail/movie_keywords_section.dart';
import 'package:miko/widgets/movie_detail/external_links_section.dart';
import 'package:miko/widgets/movie_detail/production_companies_section.dart';
import 'package:miko/widgets/movie_detail/production_countries_section.dart';
import 'package:miko/widgets/movie_detail/spoken_languages_section.dart';
import 'package:miko/widgets/movie_detail/movie_overview_section.dart';
import 'package:miko/widgets/movie_detail/movie_action_buttons.dart';
import 'package:miko/widgets/movie_detail/movie_basic_info.dart';
import 'package:miko/widgets/movie_detail/movie_cast_section.dart';
import 'package:miko/widgets/movie_detail/movie_directors_section.dart';
import 'package:miko/widgets/movie_detail/movie_crew_chip_section.dart';
import 'package:miko/showcases/mixins/translation_mixin.dart';
import 'package:miko/showcases/utils/haptic_helper.dart';
import 'package:miko/showcases/utils/detail_page_navigation.dart';

// ignore: must_be_immutable
class MovieDetailPage extends StatefulWidget {
   int id;

   MovieDetailPage({super.key, required this.id});

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> with TranslationMixin {
   MovieService _movieService = MovieService();
  late Future<Map<String, dynamic>> _movieDataFuture;
  MovieResponse? recommendations;
  List<Keyword> _movieKeywords = [];
  late Movie movie;
  List<String> downloadLinks = [''];
  bool tr = false;

  // Helper for haptic feedback
  void _performHapticFeedback() {
    HapticHelper.performHapticFeedback();
  }
  
String oveview='';
  @override
  void initState() {
    super.initState();
    _loadMovieData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _loadMovieData() async {
    _movieDataFuture =
        _movieService.getMovieDetailsWithCredits(movieId: widget.id);
Movie _movie = await _movieService.getMovieDetails(movieId: widget.id);
    _movieDataFuture.then((_) {
      if (mounted) {
        setState(() async {
          movie = _movie;
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var userDataService = Provider.of<UserDataService>(context);
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: _movieDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingView();
          } else if (snapshot.hasError) {
            return _buildRetryableView(context, userDataService);
          } else if (snapshot.hasData) {
            Movie detailedMovie = snapshot.data!['details'] as Movie;
            MovieCredits credits = snapshot.data!['credits'] as MovieCredits;
            recommendations =
                snapshot.data!['recommendations'] as MovieResponse;

            _movieKeywords = detailedMovie.keywords;

            return _buildDetailView(
                context, detailedMovie, credits, userDataService);
          } else {
            return _buildRetryableView(context, userDataService);
          }
        },
      ),
    );
  }

  int _retryCount = 0;
  Widget _buildRetryableView(context, userDataService) {
    if (_retryCount < 3) {
      _retryCount++;
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          _loadMovieData();
        });
      });
      return _buildLoadingView();
    } else {
      return _buildErrorView(context,
          "Error when We Try to Load Data From TMDB!!", userDataService);
    }
  }

  Widget _buildLoadingView() {
    return const MovieDetailLoadingView();
  }

  Widget _buildErrorView(
      BuildContext context, String errorMessage, userDataService) {
    return Column(
      children: [
        Expanded(
          child: _buildDetailView(context, movie, null, userDataService,
              showDetailedInfo: false),
        ),
        Container(
          color: Colors.black87,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.red),
                  const SizedBox(height: 16),
                  SelectableText('Error loading movie details',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(color: Colors.white)),
                  const SizedBox(height: 8),
                  SelectableText(errorMessage,
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.white70)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      _performHapticFeedback();
                      setState(() {
                        _loadMovieData();
                      });
                    },
                    child: const Text('Try Again'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      _performHapticFeedback();
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => MovieDetailsScreen(
                          movieId: widget.id,
                          typec: "movie",
                        ),
                      ));
                    },
                    child: const Text('Try Loading using old interface'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _performHapticFeedback();
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => MovieDetailsScreen(
                          movieId: widget.id,
                          typec: "movie",
                        ),
                      ));
                    },
                    child: const Text('Try Loading using old interface'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailView(
      BuildContext context, Movie movie, MovieCredits? credits, userDataService,
      {bool showDetailedInfo = true}) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (Platform.isAndroid && scrollInfo is ScrollUpdateNotification) {
          if (scrollInfo.scrollDelta != null && scrollInfo.scrollDelta! != 0) {
            _performHapticFeedback();
          }
        }
        return false;
      },
      child: CustomScrollView(
        slivers: [
          _buildAppBar(context, movie, userDataService),
          SliverToBoxAdapter(
            child: _buildMovieDetails(
                context, movie, credits, showDetailedInfo, userDataService),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, Movie movie, userDataService) {
    bool isFavorite = userDataService.isFavoriteMovie(movie.id);
    //final movieM = Provider.of<MovieProvider>(context, listen: false)
    // .getMovieById(movie.id);
    String backdropUrl = movie.fullBackdropPath;
    String posterUrl = movie.fullPosterPath;
    // if (movieM != null){
    //  movieM!.getDownloadLinksList();}
    bool isInWatchlist = userDataService.isOnWatchlistMovie(movie.id);

    return SliverAppBar(
      expandedHeight: 600,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(translatedTitle ?? movie.title,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              // color: Colors.white,
              letterSpacing: 1.5,
              height: 1.2,
              shadows: [
                Shadow(
                  offset: const Offset(2, 2),
                  blurRadius: 8,
                  color: Colors.black.withOpacity(0.8),
                ),
                Shadow(
                  offset: const Offset(-1, -1),
                  blurRadius: 4,
                  color: Colors.purple.withOpacity(0.3),
                ),
                Shadow(
                  offset: const Offset(0, 0),
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
                ).createShader(const Rect.fromLTWH(0, 0, 300, 100)),
            )),
        background: Stack(fit: StackFit.expand, children: [
          backdropUrl.isNotEmpty
              ? CachedNetworkImage(
                  filterQuality: FilterQuality.high,
                  imageUrl: backdropUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(
                          strokeWidth: 1, color: AppColors.accentColor)),
                  errorWidget: (context, url, error) =>
                      // Custom fallback logic: try poster if backdrop fails
                      posterUrl.isNotEmpty
                          ? CachedNetworkImage(
                              filterQuality: FilterQuality.high,
                              imageUrl: posterUrl,
                              fit: BoxFit.contain,
                              placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator(
                                      strokeWidth: 1,
                                      color: AppColors.accentColor)),
                              errorWidget: (context, url, error) =>
                                  const Center(
                                child: Icon(
                                    Icons
                                        .image_not_supported_outlined, // Standardized icon
                                    size: 100,
                                    color: AppColors.secondaryText),
                              ),
                              fadeInDuration: const Duration(milliseconds: 200),
                              fadeOutDuration:
                                  const Duration(milliseconds: 100),
                            )
                          : const Center(
                              child: Icon(
                                  Icons
                                      .image_not_supported_outlined, // Standardized icon
                                  size: 100,
                                  color: AppColors.secondaryText),
                            ),
                  fadeInDuration: const Duration(milliseconds: 200),
                  fadeOutDuration: const Duration(milliseconds: 100),
                )
              : const Center(
                  child: Icon(
                      Icons.image_not_supported_outlined, // Standardized icon
                      size: 100,
                      color: AppColors.secondaryText)),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.2),
                    AppColors.primaryBackground.withOpacity(0.9),
                    AppColors.primaryBackground,
                  ],
                  stops: const [
                    0.0,
                    0.5,
                    0.9,
                    1.0
                  ]),
            ),
          ),
         
          Positioned(
            top: 8.0,
            right: 8.0,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.white,
                    size: 20,
                  ),
                  onPressed: () async {
                    _performHapticFeedback();
                    await userDataService.toggleFavoriteMovie(movie.id);
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
                    backgroundColor: Colors.black.withOpacity(0.5),
                    padding: const EdgeInsets.all(4.0),
                  ),
                ),
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Text(
                    '${movie.voteAverage.toStringAsFixed(1)}/10',
                    style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryText,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                IconButton(
                  icon: Icon(
                    isInWatchlist ? Icons.bookmark : Icons.bookmark_border,
                    color: isInWatchlist ? Colors.green : Colors.white,
                    size: 20,
                  ),
                  onPressed: () async {
                    _performHapticFeedback();
                    await userDataService.toggleWatchlistMovie(movie.id);
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
                    backgroundColor: Colors.black.withOpacity(0.5),
                    padding: const EdgeInsets.all(4.0),
                  ),
                ),
                const SizedBox(width: 4),
                IconButton(
                  icon: Icon(
                    Icons.share,
                    color: Colors.purpleAccent,
                    size: 20,
                  ),
                  onPressed: () async {
                    _performHapticFeedback();
                    var myItem = ShareItem(
                      name: movie.title,
                      vote: movie.voteAverage,
                      releaseDate: movie.releaseDate,
                      overview: movie.overview,
                      posterUrl: movie.fullPosterPath,
                      internalUrl:
                          'https://inosuke.page.link/miko/movie${movie.id}', // Replace with a real URL
                    );
                     String shareContent = '''
Check out this: ${myItem.name}
Rating: ${myItem.vote}
Release Date: ${myItem.releaseDate}
Overview: ${oveview}
Open in miko by click on ${myItem.internalUrl}
''';
                    SharePlus.instance.share(ShareParams(text: shareContent));

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Share item ...'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.black.withOpacity(0.5),
                    padding: const EdgeInsets.all(4.0),
                  ),
                ),
              ],
            ),
          )
        ]),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(
          color: AppColors.dividerColor.withOpacity(0.5),
          height: 1.0,
        ),
      ),
    );
  }

  void dllink(BuildContext context) async{
    var mmovie = Provider.of<MovieProvider>(context, listen: false)
        .getMovieById(widget.id);
    if (mmovie != null) {
      final downloadLink = mmovie.getDownloadLinksList();
      downloadLinks = downloadLink;
     if (tr== false){
      oveview = movie.overview; }
    }
  }

  Widget _buildMovieDetails(BuildContext context, Movie movie,
      MovieCredits? credits, bool showDetailedInfo, userDataService) {
    dllink(context);
    bool isWatched = userDataService.isWatchedEpisode(
        widget.id, widget.id, widget.id, widget.id);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showDetailedInfo &&
              movie.tagline != null &&
              movie.tagline!.isNotEmpty)
            MovieTagline(tagline: movie.tagline!),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: 'movie-${movie.id}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    width: 120,
                    height: 180,
                    child: movie.fullPosterPath.isNotEmpty
                        ? CachedNetworkImage(
                            filterQuality: FilterQuality.high,
                            imageUrl: movie.fullPosterPath,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(
                                    strokeWidth: 1,
                                    color: AppColors.accentColor)),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey[800],
                              child: const Center(
                                child: Icon(
                                    Icons
                                        .image_not_supported_outlined, // Standardized icon
                                    size: 30,
                                    color: AppColors.secondaryText),
                              ),
                            ),
                            fadeInDuration: const Duration(milliseconds: 300),
                            fadeOutDuration: const Duration(milliseconds: 100),
                          )
                        : Container(
                            color: Colors.grey[800],
                            child: const Center(
                              child: Icon(
                                  Icons
                                      .image_not_supported_outlined, // Standardized icon
                                  size: 30,
                                  color: AppColors.secondaryText),
                            ),
                          ),
                  ),
                ),
              ),
                          const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SelectableText(
                     translatedTitle?? movie.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Release Date: ${movie.releaseDate}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 20),
                        const SizedBox(width: 4),
                        Text(
                          '${movie.voteAverage.toStringAsFixed(1)} (${movie.voteCount} votes)',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                                       IconButton(
                          icon: isTranslating
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Icon(
                                  Icons.auto_awesome,
                                  color: Colors.white,
                                  size: 20,
                                ),
                          onPressed: () async {
                            _performHapticFeedback();
                            // toggle: if already translated, revert to original by clearing translated text
                            await toggleTitleTranslation(movie.title);
                            if (translatedTitle != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Title translated'),
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
                    if (showDetailedInfo && movie.runtime != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: [
                            const Icon(Icons.access_time, size: 20),
                            const SizedBox(width: 4),
                            Text(
                              movie.formattedRuntime,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 8),
                    if (showDetailedInfo && movie.genres!.isNotEmpty)
                      Text(
                        'Genres: ${movie.genresText}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      )
                    else
                      Text(
                        'Original Language: ${movie.originalLanguage.toUpperCase()}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                  ],
                ),
              ),
            ],
          ),
          if (showDetailedInfo &&
              credits != null &&
              credits.directors.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              'Director${credits.directors.length > 1 ? 's' : ''}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            MovieActionButtons(
              downloadLinks: downloadLinks,
              isWatched: isWatched,
              onPlayPressed: () {
                _performHapticFeedback();
                showDownloadLinkSelection(context, downloadLinks, movie.id, movie.title);
              },
              onDownloadPressed: () {
                _performHapticFeedback();
                showDownloadLinkSelection(context, downloadLinks, movie.id, movie.title, isForPlay: false);
              },
            ),
            const SizedBox(height: 4),
            Text(
              credits.directors.map((director) => director.name).join(', '),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],

      
              
          MovieOverviewSection(
            overview: oveview,
            onTranslate: () async {
              tVClick();
              gentranslate();
            },
            onLongPress: () {
              showTextInputDialog(context, userDataService);
            },
          ),
          if (showDetailedInfo && _movieKeywords.isNotEmpty)
            MovieKeywordsSection(
              keywords: _movieKeywords,
              movieService: _movieService,
            ),
          if (showDetailedInfo &&
              credits != null &&
              credits.cast.isNotEmpty)
            MovieCastSection(
              cast: credits.cast,
              movieId: movie.id,
              movieTitle: movie.title,
            ),
          if (showDetailedInfo && credits != null) ...[
            if (credits.directors.isNotEmpty)
              MovieDirectorsSection(directors: credits.directors),
            if (credits.writers.isNotEmpty)
              MovieCrewChipSection(
                title: 'Writing',
                crewMembers: credits.writers,
              ),
            if (credits.producers.isNotEmpty)
              MovieCrewChipSection(
                title: 'Production',
                crewMembers: credits.producers,
                maxDisplay: 5,
                onSeeAll: () {
                  _performHapticFeedback();
                },
              ),
          ],
          if (showDetailedInfo) ...[
            if (movie.productionCompanies != null &&
                movie.productionCompanies!.isNotEmpty)
              ProductionCompaniesSection(companies: movie.productionCompanies!),
            if (movie.productionCountries != null &&
                movie.productionCountries!.isNotEmpty)
              ProductionCountriesSection(countries: movie.productionCountries!),
            if (movie.budget != null || movie.revenue != null) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  if (movie.budget != null && movie.budget! > 0) ...[
                    Expanded(
                      child: MovieInfoCard(
                        title: 'Budget',
                        value: movie.formattedBudget,
                        icon: Icons.attach_money,
                      ),
                    ),
                    if (movie.revenue != null && movie.revenue! > 0)
                      const SizedBox(width: 16),
                  ],
                  if (movie.revenue != null && movie.revenue! > 0)
                    Expanded(
                      child: MovieInfoCard(
                        title: 'Revenue',
                        value: movie.formattedRevenue,
                        icon: Icons.trending_up,
                      ),
                    ),
                ],
              ),
            ],
            if (movie.spokenLanguages != null &&
                movie.spokenLanguages!.isNotEmpty)
              SpokenLanguagesSection(languages: movie.spokenLanguages!),
            ExternalLinksSection(
              homepage: movie.homepage,
              imdbId: movie.imdbId,
            ),
          ],
          const SizedBox(height: 32),
          RecommendationsSectionWidget( recommendations: null, onShowAllPressed: () {
                    _performHapticFeedback();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecommendationsPage(
                          movieId: widget.id,
                          movieTitle: movie.title,
                          typec: "movie",
                        ),
                      ),
                    );
                  }, onRecommendationTapped: () {
        _performHapticFeedback();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetailPage(id: movie.id),
          ),
        );
      }, recommendationsM: recommendations,),
        ],
      ),
    );
  }


  
  void gentranslate() async {
  MovieTvTranslator translator = MovieTvTranslator();
  debugPrint(oveview);
String translatedOverView = await translator.translateTextForMoviesAndTV(oveview);
debugPrint(translatedOverView);
  debugPrint(oveview);
  setState(() {  
    tr = true;
        oveview = translatedOverView;
  

  debugPrint(oveview);
  });
  }
  }

