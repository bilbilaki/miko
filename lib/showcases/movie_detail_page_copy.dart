import 'dart:io' show Platform;
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:miko/providers/god_proovider.dart' show MovieProvider;
import 'package:miko/showcases/cast_page.dart';
import 'package:miko/showcases/recommendations_page.dart';
import 'package:miko/utils/utils.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:miko/services/user_data_service.dart';
import 'package:miko/showcases/movies_by_keyword_screen.dart';
import 'package:miko/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../screens/video_player_screen.dart';
import 'model.dart';
import 'movie_service.dart';
import 'person_detail_page.dart';
class FadeIn extends StatefulWidget {
  final Widget child;
  final Duration duration;
  const FadeIn({Key? key, required this.child, this.duration = const Duration(milliseconds: 300)}) : super(key: key);

  @override
  _FadeInState createState() => _FadeInState();
}

class _FadeInState extends State<FadeIn> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(opacity: _animation, child: widget.child);
  }
}

class MovieDetailPage extends StatefulWidget {
  final Movie movie;

  const MovieDetailPage({super.key, required this.movie});

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  final MovieService _movieService = MovieService();
  late Future<Map<String, dynamic>> _movieDataFuture;
  MovieResponse? recommendations;
  List<Keyword> _movieKeywords = [];

  // Helper for haptic feedback
  void _performHapticFeedback() {
    if (Platform.isAndroid) {
      // Provides a subtle vibration
      HapticFeedback.lightImpact;
    }
  }

  @override
  void initState() {
    super.initState();
    _loadMovieData();
  }

  @override
  void dispose() {
    _movieService.dispose();
    super.dispose();
  }

  void _loadMovieData() {
    _movieDataFuture =
        _movieService.getMovieDetailsWithCredits(movieId: widget.movie.id);
    _movieDataFuture.then((_) {
      if (mounted) {
        setState(() {});
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
  final userDataService = Provider.of<UserDataService>(context);

    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: _movieDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingView();
          } else if (snapshot.hasError) {
            return _buildRetryableView(context,userDataService);
          } else if (snapshot.hasData) {
            final detailedMovie = snapshot.data!['details'] as Movie;
            final credits = snapshot.data!['credits'] as MovieCredits;
            recommendations =
                snapshot.data!['recommendations'] as MovieResponse;

            _movieKeywords = detailedMovie.keywords;

            return _buildDetailView(context, detailedMovie, credits,userDataService);
          } else {
            return _buildRetryableView(context,userDataService);
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
      return _buildErrorView(
          context, "Error when We Try to Load Data From TMDB!!",userDataService);
    }
  }

  Widget _buildLoadingView() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[850]!,
      highlightColor: Colors.grey[800]!,
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Container(
                height: 20,
                width: 150,
                color: Colors.white, // Placeholder for title
              ),
              background: Container(
                  color: Colors.white), // Placeholder for background image
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 120,
                        height: 180,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                height: 20,
                                width: double.infinity,
                                color: Colors.white),
                            const SizedBox(height: 8),
                            Container(
                                height: 16, width: 150, color: Colors.white),
                            const SizedBox(height: 8),
                            Container(
                                height: 16, width: 100, color: Colors.white),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Container(height: 24, width: 200, color: Colors.white),
                  const SizedBox(height: 8),
                  Container(
                      height: 16, width: double.infinity, color: Colors.white),
                  const SizedBox(height: 8),
                  Container(
                      height: 16, width: double.infinity, color: Colors.white),
                  const SizedBox(height: 8),
                  Container(height: 16, width: 250, color: Colors.white),
                  const SizedBox(height: 24),
                  Container(height: 24, width: 150, color: Colors.white),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 180,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5, // Mock number of cast members
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: Column(
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                                height: 14, width: 80, color: Colors.white),
                            const SizedBox(height: 4),
                            Container(
                                height: 12, width: 60, color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, String errorMessage,userDataService) {
    return Column(
      children: [
        _buildDetailView(context, widget.movie, null,userDataService, showDetailedInfo: false),
        Expanded(
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailView(
      BuildContext context, Movie movie, MovieCredits? credits,userDataService,
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
          _buildAppBar(context, movie,userDataService),
          SliverToBoxAdapter(
            child:
                _buildMovieDetails(context, movie, credits, showDetailedInfo,userDataService),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, Movie movie, userDataService) {
    bool isFavorite = userDataService.isFavoriteMovie(movie.id);
    final movieM = Provider.of<MovieProvider>(context, listen: false)
        .getMovieById(movie.id);
    final backdropUrl = movie.fullBackdropPath;
    final posterUrl = movie.fullPosterPath;
    movieM!.getDownloadLinksList();
    bool isInWatchlist = userDataService.isOnWatchlistMovie(movie.id);

    return SliverAppBar(
      expandedHeight: 600,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(movie.title,
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
                  imageUrl: backdropUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(
                          strokeWidth: 1, color: AppColors.accentColor)),
                  errorWidget: (context, url, error) =>
                      // Custom fallback logic: try poster if backdrop fails
                      posterUrl.isNotEmpty
                          ? CachedNetworkImage(
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

  Widget _buildMovieDetails(BuildContext context, Movie movie,
      MovieCredits? credits, bool showDetailedInfo,userDataService) {
    final mmovie = Provider.of<MovieProvider>(context, listen: false)
        .getMovieById(widget.movie.id);
        final downloadLinks = mmovie!.getDownloadLinksList();

    bool isWatched = userDataService.isWatchedEpisode(widget.movie.id,
        widget.movie.id, widget.movie.id, downloadLinks.toString());

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showDetailedInfo &&
              movie.tagline != null &&
              movie.tagline!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text('"${movie.tagline}"',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withOpacity(0.85),
                    letterSpacing: 0.8,
                    height: 1.4,
                    decorationStyle: GoogleFonts.dmSerifText().decorationStyle,
                    fontStyle: FontStyle.italic,
                    shadows: [
                      Shadow(
                        offset: const Offset(1, 1),
                        blurRadius: 4,
                        color: Colors.black.withOpacity(0.6),
                      ),
                      Shadow(
                        offset: const Offset(0, 0),
                        blurRadius: 8,
                        color: Colors.blue.withOpacity(0.2),
                      ),
                    ],
                  )),
            ),
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
                      movie.title,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                (mmovie== mmovie)
                    ? ElevatedButton.icon(
                        icon: const Icon(Icons.play_arrow),
                        label: Text(
                          isWatched ? 'Played Before' : 'Play',
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accentColor,
                            foregroundColor: AppColors.primaryText,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 12)),
                        onPressed: () {
                          _performHapticFeedback();
                          _showDownloadLinkSelection(
                              context, downloadLinks);
                          //   downloadLinks.toString());
                        },
                      )
                    : const SizedBox(height: 4),
                const Text("No Playing Link Exist"),
                // ElevatedButton.icon(
                //   icon: const Icon(Icons.download_outlined),
                //   label: const Text('Download'),
                //   style: ElevatedButton.styleFrom(
                //       backgroundColor: AppColors.secondaryBackground,
                //       foregroundColor: AppColors.primaryText,
                //       padding: const EdgeInsets.symmetric(
                //           horizontal: 25, vertical: 12)),
                //   onPressed: () async {
                //     _performHapticFeedback();
                //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                //         content: Text('Download not implemented yet.'),
                //         duration: Duration(seconds: 2)));
                //   },
                // ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              credits.directors.map((director) => director.name).join(', '),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
          const SizedBox(height: 24),
          Text(
            'Overview',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          SelectableText(
            movie.overview.isEmpty ? 'No overview available.' : movie.overview,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (showDetailedInfo && _movieKeywords.isNotEmpty)
            _buildKeywordsSection(context, _movieKeywords),
          if (showDetailedInfo &&
              credits != null &&
              credits.cast.isNotEmpty) ...[
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Cast',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                TextButton(
                  onPressed: () {
                                        _performHapticFeedback();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CastPage(
                          movieId: movie.id,
                          movieTitle: movie.title,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    'See all ${credits.cast.length}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 180,
              child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (Platform.isAndroid &&
                      scrollInfo is ScrollUpdateNotification) {
                    if (scrollInfo.scrollDelta != null &&
                        scrollInfo.scrollDelta! != 0) {
                      _performHapticFeedback();
                    }
                  }
                  return false;
                },
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: credits.cast.length,
                  itemBuilder: (context, index) {
                    final castMember = credits.cast[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: GestureDetector(
                        onTap: () {
                          _performHapticFeedback();
                          _navigateToPersonDetail(castMember.id,
                              castMember.name, castMember.profilePath);
                        },
                        child: SizedBox(
                          width: 130,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Hero(
                                tag: 'person-${castMember.id}',
                                child: Material(
                                  elevation: 4,
                                  borderRadius: BorderRadius.circular(8),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: SizedBox(
                                      width: 100,
                                      height: 100,
                                      child: castMember.profilePath != null
                                          ? CachedNetworkImage(
                                              imageUrl:
                                                  castMember.fullProfilePath,
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) =>
                                                  const Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                              strokeWidth: 1,
                                                              color: AppColors
                                                                  .accentColor)),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Container(
                                                color: Colors.grey[800],
                                                child: const Center(
                                                  child: Icon(
                                                      Icons
                                                          .image_not_supported_outlined, // Standardized icon
                                                      size: 40,
                                                      color: AppColors
                                                          .secondaryText),
                                                ),
                                              ),
                                              fadeInDuration: const Duration(
                                                  milliseconds: 200),
                                              fadeOutDuration: const Duration(
                                                  milliseconds: 100),
                                            )
                                          : Container(
                                              color: Colors.grey[800],
                                              child: const Center(
                                                child: Icon(
                                                    Icons
                                                        .image_not_supported_outlined, // Standardized icon
                                                    size: 40,
                                                    color: AppColors
                                                        .secondaryText),
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                castMember.name,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                castMember.character,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[400],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
          if (showDetailedInfo && credits != null) ...[
            if (credits.directors.isNotEmpty) ...[
              const SizedBox(height: 24),
              Text(
                'Directors',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 140,
                child: NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (Platform.isAndroid &&
                        scrollInfo is ScrollUpdateNotification) {
                      if (scrollInfo.scrollDelta != null &&
                          scrollInfo.scrollDelta! != 0) {
                        _performHapticFeedback();
                      }
                    }
                    return false;
                  },
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: credits.directors.length,
                    itemBuilder: (context, index) {
                      final director = credits.directors[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: GestureDetector(
                          onTap: () {
                            _performHapticFeedback();
                            _navigateToPersonDetail(director.id, director.name,
                                director.profilePath);
                          },
                          child: SizedBox(
                            width: 90,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Material(
                                  elevation: 4,
                                  shape: const CircleBorder(),
                                  clipBehavior: Clip.antiAlias,
                                  child: SizedBox(
                                    width: 80,
                                    height: 80,
                                    child: director.profilePath != null
                                        ? CachedNetworkImage(
                                            imageUrl: director.fullProfilePath,
                                            fit: BoxFit.cover,
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    CircleAvatar(
                                              radius: 40,
                                              backgroundImage: imageProvider,
                                            ),
                                            placeholder: (context, url) =>
                                                const Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                            strokeWidth: 1,
                                                            color: AppColors
                                                                .accentColor)),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Center(
                                              child: CircleAvatar(
                                                radius: 40,
                                                backgroundColor: Colors.grey,
                                                child: Icon(
                                                    Icons
                                                        .image_not_supported_outlined, // Standardized icon
                                                    size: 40,
                                                    color: AppColors
                                                        .secondaryText),
                                              ),
                                            ),
                                            fadeInDuration: const Duration(
                                                milliseconds: 300),
                                            fadeOutDuration: const Duration(
                                                milliseconds: 100),
                                          )
                                        : const CircleAvatar(
                                            radius: 40,
                                            backgroundColor: Colors.grey,
                                            child: Icon(
                                                Icons
                                                    .image_not_supported_outlined, // Standardized icon
                                                size: 40,
                                                color: AppColors.secondaryText),
                                          ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  director.name,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Director',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey[400],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
            if (credits.writers.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                'Writing',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: credits.writers.map((writer) {
                  return GestureDetector(
                    onTap: () {
                      _performHapticFeedback();
                      _navigateToPersonDetail(
                          writer.id, writer.name, writer.profilePath);
                    },
                    child: Chip(
                      avatar: writer.profilePath != null
                          ? CachedNetworkImage(
                              imageUrl: writer.fullProfilePath,
                              imageBuilder: (context, imageProvider) =>
                                  CircleAvatar(
                                backgroundImage: imageProvider,
                              ),
                              placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator(
                                      strokeWidth: 1,
                                      color: AppColors.accentColor)),
                              errorWidget: (context, url, error) =>
                                  const Center(
                                child: Icon(
                                    Icons
                                        .image_not_supported_outlined, // Standardized icon
                                    size: 16,
                                    color: AppColors.secondaryText),
                              ),
                              fadeInDuration: const Duration(milliseconds: 200),
                              fadeOutDuration:
                                  const Duration(milliseconds: 100),
                            )
                          : const CircleAvatar(
                              child: Icon(
                                  Icons
                                      .image_not_supported_outlined, // Standardized icon
                                  size: 16,
                                  color: AppColors.secondaryText),
                            ),
                      label: Text('${writer.name} (${writer.job})'),
                      backgroundColor: Colors.grey[800],
                      labelStyle: const TextStyle(color: AppColors.primaryText),
                    ),
                  );
                }).toList(),
              ),
            ],
            if (credits.producers.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                'Production',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: credits.producers.take(5).map((producer) {
                  return GestureDetector(
                    onTap: () {
                      _performHapticFeedback();
                      _navigateToPersonDetail(
                          producer.id, producer.name, producer.profilePath);
                    },
                    child: Chip(
                      avatar: producer.profilePath != null
                          ? CachedNetworkImage(
                              imageUrl: producer.fullProfilePath,
                              imageBuilder: (context, imageProvider) =>
                                  CircleAvatar(
                                backgroundImage: imageProvider,
                              ),
                              placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator(
                                      strokeWidth: 1,
                                      color: AppColors.accentColor)),
                              errorWidget: (context, url, error) =>
                                  const Center(
                                child: Icon(
                                    Icons
                                        .image_not_supported_outlined, // Standardized icon
                                    size: 16,
                                    color: AppColors.secondaryText),
                              ),
                              fadeInDuration: const Duration(milliseconds: 200),
                              fadeOutDuration:
                                  const Duration(milliseconds: 100),
                            )
                          : const CircleAvatar(
                              child: Icon(
                                  Icons
                                      .image_not_supported_outlined, // Standardized icon
                                  size: 16,
                                  color: AppColors.secondaryText),
                            ),
                      label: Text('${producer.name} (${producer.job})'),
                      backgroundColor: Colors.grey[800],
                      labelStyle: const TextStyle(color: AppColors.primaryText),
                    ),
                  );
                }).toList(),
              ),
              if (credits.producers.length > 5)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      _performHapticFeedback();
                    },
                    child: Text(
                      'See all ${credits.producers.length} producers',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                ),
            ],
          ],
          if (showDetailedInfo) ...[
            if (movie.productionCompanies != null &&
                movie.productionCompanies!.isNotEmpty) ...[
              const SizedBox(height: 24),
              Text(
                'Production Companies',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 80,
                child: NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (Platform.isAndroid &&
                        scrollInfo is ScrollUpdateNotification) {
                      if (scrollInfo.scrollDelta != null &&
                          scrollInfo.scrollDelta! != 0) {
                        _performHapticFeedback();
                      }
                    }
                    return false;
                  },
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: movie.productionCompanies!.length,
                    itemBuilder: (context, index) {
                      final company = movie.productionCompanies![index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (company.logoPath != null)
                              SizedBox(
                                height: 40,
                                width: 80,
                                child: CachedNetworkImage(
                                  imageUrl: company.fullLogoPath,
                                  fit: BoxFit.contain,
                                  placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator(
                                          strokeWidth: 1,
                                          color: AppColors.accentColor)),
                                  errorWidget: (context, url, error) =>
                                      const Center(
                                    // Standardized icon
                                    child: Icon(
                                        Icons.image_not_supported_outlined,
                                        size: 30,
                                        color: AppColors.secondaryText),
                                  ),
                                  fadeInDuration:
                                      const Duration(milliseconds: 200),
                                  fadeOutDuration:
                                      const Duration(milliseconds: 100),
                                ),
                              )
                            else
                              const SizedBox(
                                // Changed from Container with Text to SizedBox with Icon for consistency
                                height: 40,
                                width: 80,
                                child: Center(
                                  child: Icon(
                                      Icons
                                          .image_not_supported_outlined, // Standardized icon
                                      size: 30,
                                      color: AppColors.secondaryText),
                                ),
                              ),
                            const SizedBox(height: 4),
                            SizedBox(
                              width: 80,
                              child: Text(
                                company.name,
                                style: const TextStyle(
                                    fontSize: 10, color: AppColors.primaryText),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
            if (movie.productionCountries != null &&
                movie.productionCountries!.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                'Production Countries',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Wrap(
                spacing: 8,
                children: movie.productionCountries!.map((country) {
                  return Chip(
                    label: Text(country.name),
                    backgroundColor: Colors.grey[800],
                    labelStyle: const TextStyle(color: AppColors.primaryText),
                  );
                }).toList(),
              ),
            ],
            if (movie.budget != null || movie.revenue != null) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  if (movie.budget != null && movie.budget! > 0) ...[
                    Expanded(
                      child: _buildInfoCard(
                        context,
                        'Budget',
                        movie.formattedBudget,
                        Icons.attach_money,
                      ),
                    ),
                    if (movie.revenue != null && movie.revenue! > 0)
                      const SizedBox(width: 16),
                  ],
                  if (movie.revenue != null && movie.revenue! > 0)
                    Expanded(
                      child: _buildInfoCard(
                        context,
                        'Revenue',
                        movie.formattedRevenue,
                        Icons.trending_up,
                      ),
                    ),
                ],
              ),
            ],
            if (movie.spokenLanguages != null &&
                movie.spokenLanguages!.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                'Spoken Languages',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Wrap(
                spacing: 8,
                children: movie.spokenLanguages!.map((language) {
                  return Chip(
                    label: Text(language.englishName),
                    backgroundColor: Colors.grey[800],
                    labelStyle: const TextStyle(color: AppColors.primaryText),
                  );
                }).toList(),
              ),
            ],
            if (movie.homepage != null && movie.homepage!.isNotEmpty ||
                movie.imdbId != null) ...[
              const SizedBox(height: 24),
              Text(
                'External Links',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 16,
                children: [
                  if (movie.homepage != null && movie.homepage!.isNotEmpty)
                    OutlinedButton.icon(
                      icon: const Icon(Icons.language),
                      label: const Text('Official Website'),
                      onPressed: () async{
                        // TODO: Launch URL (would need url_launcher package)
                        // import 'package:url_launcher/url_launcher.dart';
                         if (await canLaunchUrl(Uri.parse(movie.homepage!))) {
                           await launchUrl(Uri.parse(movie.homepage!));
                         }
                      },
                    ),
                  if (movie.imdbId != null)
                    OutlinedButton.icon(
                      icon: const Icon(Icons.movie),
                      label: const Text('IMDb'),
                      onPressed: () async{
                        // TODO: Launch IMDb URL
                         final imdbUrl = 'https://www.imdb.com/title/${movie.imdbId}/';
                         if (await canLaunchUrl(Uri.parse(imdbUrl))) {
                           await launchUrl(Uri.parse(imdbUrl));
                         }
                      },
                    ),
                ],
              ),
            ],
          ],
          const SizedBox(height: 32),
          _buildRecommendationsSection(context),
        ],
      ),
    );
  }
  void _showDownloadLinkSelection(
      BuildContext context, List<String> links) async {
    final userDataService =
        Provider.of<UserDataService>(context, listen: false);

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return SimpleDialog(
          title: const Text('Select Quality / Source'),
          titleTextStyle: const TextStyle(
              color: AppColors.primaryText,
              fontSize: 18,
              fontWeight: FontWeight.bold),
          backgroundColor: AppColors.secondaryBackground,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          children: links.map((link) {
            // Try to guess quality from URL (very basic)
            String qualityGuess = "Unknown";
            if (link.contains('1080p')) 
              qualityGuess = "1080p ";
             else if (link.contains('720p'))
              qualityGuess = "720p ";
            else if (link.contains('480p'))
              qualityGuess = "480p ";
            else if (link.contains('BluRay'))
              qualityGuess += " BluRay ";
            else if (link.contains('HEVC') || link.contains('x265'))
              qualityGuess += " HEVC ";
            else if (link.contains('x264')) qualityGuess += " x264";

            return SimpleDialogOption(
              onPressed: () async {
                tVmedium(); // Haptic feedback on dialog option tap
                Navigator.pop(dialogContext); // Close the dialog
                userDataService.toggleIsWatchedLink(
                    widget.movie.id, widget.movie.id,widget.movie.id, links.toString());
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => VideoPlayerScreen(videoUrl: link),
                  ),
                );
              },
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
              child: Text(
                '$qualityGuess - ${Uri.parse(link).host}', // Show quality guess and domain
                style:
                    const TextStyle(color: AppColors.primaryText, fontSize: 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
        );
      },
    );
  }


  Widget _buildKeywordsSection(BuildContext context, List<Keyword> keywords) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(
          'Keywords',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: keywords.map((keyword) {
            return ActionChip(
              label: Text(keyword.name),
              backgroundColor: Colors.grey[800],
              labelStyle: const TextStyle(color: Colors.white70),
              onPressed: () {
                _performHapticFeedback();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MoviesByKeywordScreen(
                      keywordId: keyword.id,
                      keywordName: keyword.name,
                      movieService: _movieService,
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  void _navigateToPersonDetail(int personId, String name, String? profilePath) {
    _performHapticFeedback();
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

  Widget _buildRecommendationsSection(BuildContext context) {
    if (recommendations == null || recommendations!.results.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recommendations',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              if (recommendations!.results.length > 10)
                TextButton(
                  onPressed: () {
                        _performHapticFeedback();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecommendationsPage(
                          movieId: widget.movie.id,
                          movieTitle: widget.movie.title,
                          typec: "movie",
                        ),
                      ),
                    );},
                  child: Text(
                    'See All',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 230,
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (Platform.isAndroid &&
                  scrollInfo is ScrollUpdateNotification) {
                if (scrollInfo.scrollDelta != null &&
                    scrollInfo.scrollDelta! != 0) {
                  _performHapticFeedback();
                }
              }
              return false;
            },
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              scrollDirection: Axis.horizontal,
              itemCount: recommendations!.results.length > 10
                  ? 10
                  : recommendations!.results.length,
              itemBuilder: (context, index) {
                final movie = recommendations!.results[index];
                return _buildRecommendationCard(context, movie);
              },
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildRecommendationCard(BuildContext context, Movie movie) {
    return GestureDetector(
      onTap: () {
        _performHapticFeedback();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetailPage(movie: movie),
          ),
        );
      },
      child: Container(
        width: 130,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'movie-recommendation-${movie.id}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Stack(
                  children: [
                    movie.fullPosterPath.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: movie.fullPosterPath,
                            height: 170,
                            width: 130,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(
                                    strokeWidth: 1,
                                    color: AppColors.accentColor)),
                            errorWidget: (context, url, error) => Container(
                              height: 170,
                              width: 130,
                              color: Colors.grey[800],
                              child: const Center(
                                child: Icon(
                                    Icons
                                        .image_not_supported_outlined, // Standardized icon
                                    size: 40,
                                    color: AppColors.secondaryText),
                              ),
                            ),
                            fadeInDuration: const Duration(milliseconds: 300),
                            fadeOutDuration: const Duration(milliseconds: 100),
                          )
                        : Container(
                            height: 170,
                            width: 130,
                            color: Colors.grey[800],
                            child: const Center(
                              child: Icon(
                                  Icons
                                      .image_not_supported_outlined, // Standardized icon
                                  size: 40,
                                  color: AppColors.secondaryText),
                            ),
                          ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: _getRatingColor(movie.voteAverage),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star,
                                color: Colors.white, size: 12),
                            const SizedBox(width: 2),
                            Text(
                              movie.voteAverage.toStringAsFixed(1),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              movie.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
            ),
            if (movie.releaseDate.isNotEmpty && movie.releaseDate.length >= 4)
              Text(
                movie.releaseDate.substring(0, 4),
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[400],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getRatingColor(double rating) {
    if (rating >= 7.5) {
      return Colors.green.shade700;
    } else if (rating >= 5.0) {
      return Colors.orange.shade700;
    } else if (rating > 0.0) {
      return Colors.red.shade700;
    }
    return Colors.grey.shade700;
  }

  Widget _buildInfoCard(
      BuildContext context, String title, String value, IconData icon) {
    return Card(
      color: Colors.grey[
          850], // Shimmer is used for the overall loading state, not individual static cards.
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Icon(icon,
                size: 28, color: Theme.of(context).colorScheme.secondary),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.white70),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold, color: AppColors.primaryText),
            ),
          ],
        ),
      ),
    );
  }
}
