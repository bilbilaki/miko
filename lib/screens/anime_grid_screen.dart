// lib/screens/tv_series_grid_screen.dart
import 'dart:async';
import 'dart:io'; // Added for Platform.isAndroid

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


import 'package:miko/providers/god_proovider.dart';
import 'package:miko/screens/video_player_screen.dart';
import 'package:miko/services/user_data_service.dart';
import 'package:miko/showcases/model.dart';
import 'package:miko/showcases/model.dart' as mo;
import 'package:miko/showcases/movie_detail_page_copy.dart';
import 'package:miko/showcases/movie_service.dart' as mo;
import 'package:miko/showcases/person_detail_page.dart';
import 'package:miko/showcases/tv_detail_page_anime.dart';
import 'package:miko/utils/utils.dart';
//import 'package:miko/showcases/tv_detail_page_anime.dart';
import 'package:miko/widgets/anime_series_card.dart';
import 'package:provider/provider.dart';
 // Ensure correct provider import
import 'package:miko/utils/colors.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shimmer/shimmer.dart';

import '../providers/god_proovider.dart' as ss; // Added for shimmer effect

class AnimeGridScreen extends StatefulWidget {
  final String typec;

  const AnimeGridScreen({super.key, required this.typec});

  @override
  State<AnimeGridScreen> createState() => AnimeGridScreenState();
}

class AnimeGridScreenState extends State<AnimeGridScreen> {
  late double? gridCrossAxisCount = 3.0; // Default grid size

  // Haptic feedback function

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: NotificationListener<ScrollNotification>(
          // Listen for scroll events for vibration
          onNotification: (ScrollNotification notification) {
            if (Platform.isAndroid) {
              if (notification is ScrollStartNotification) {
                triggerVibration(); // Vibrate when scroll starts
              }
            }
            return false; // Continue to bubble up the notification
          },
          child: GestureDetector(
            // Added GestureDetector for general touch/drag vibration
            onTapDown: (_) => triggerVibration(), // Vibrate on touch/tap down
            //        onPanDown: (_) => triggerVibration(), // Vibrate on pan/drag down
            child: Stack(
              children: [
                if (widget.typec == "movie")
                  Consumer<MovieProvider>(
                    builder: (context, movieProvider, child) {
                      return _buildBody0(context, movieProvider, widget.typec,
                          triggerVibration);
                    },
                  )
                else if (widget.typec == "anime")
                  Consumer<AnimeProvider>(
                      builder: (context, seriesProvider, child) {
                    // Optional: Keep DynamicBackground if desired
                    return _buildBody0(context, seriesProvider, widget.typec,
                        triggerVibration);
                  })
                else if (widget.typec == "tvseries")
                  Consumer<TvSeriesProvider>(
                      builder: (context, seriesProvider, child) {
                    // Optional: Keep DynamicBackground if desired
                    return _buildBody0(context, seriesProvider, widget.typec,
                        triggerVibration);
                  }),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      showSearchOverlay(context);
                      triggerVibration(); // Vibrate on search bar tap
                    },
                    child: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search),
                          const SizedBox(width: 16),
                          Text(
                            'Search',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  final mo.MovieService _movieService = mo.MovieService();

  bool _isLoading2 = false;
  final ScrollController _scrollController = ScrollController();

  // Search fields
  final TextEditingController _searchController2 = TextEditingController();

  final ScrollController _searchScrollController2 = ScrollController();

  Timer? _debounce;
  MultiSearchResponse? _searchResponse;
  bool _isFetchingMore2 = false;
  String? _error2;
  String _currentQuery2 = '';
  int _searchPage2 = 1;
  int _searchTotalPages2 = 1;
  @override
  void initState() {
    super.initState();

    _searchScrollController2.addListener(
        _searchScrollListener); // Corrected scroll controller for search results

    _searchController2.addListener(onSearchChanged2);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchScrollController2.dispose(); // Dispose the correct controller
    _movieService.dispose();
    _searchController2.removeListener(onSearchChanged2);
    _searchController2.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _searchScrollListener() async {
    if (_searchScrollController2.position.pixels >=
        _searchScrollController2.position.maxScrollExtent * 0.7) {
      if (!_isFetchingMore2 && _searchPage2 < _searchTotalPages2) {
        _searchPage2++;
        await fetchMultiSearch(loadMore: true);
      }
    }
  }

  void onSearchChanged2() async {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 100), () {
      final query = _searchController2.text.trim();
      if (query != _currentQuery2) {
        _currentQuery2 = query;
        _searchPage2 = 1;
        _searchResponse = null;
        if (_currentQuery2.isNotEmpty) {
          setState(() {
            _isLoading2 = true;
            _error2 = null;
          });
          fetchMultiSearch();
        } else {
          setState(() {
            _isLoading2 = false;
            _searchResponse = null;
            _error2 = null;
          });
        }
      }
    });
  }

  Future<void> fetchMultiSearch({bool loadMore = false}) async {
    if (_currentQuery2.isEmpty || _isFetchingMore2) return;
    setState(() {
      if (loadMore) {
        _isFetchingMore2 = true;
      } else {
        _isLoading2 = true;
      }
      _error2 = null;
    });
    try {
      final response = await _movieService.multiSearch(
        query: _currentQuery2,
        page: _searchPage2,
      );
      if (mounted) {
        setState(() {
          if (loadMore) {
            _searchResponse?.results.addAll(response.results);
            _searchResponse = MultiSearchResponse(
              page: response.page,
              results: _searchResponse?.results ?? response.results,
              totalPages: response.totalPages,
              totalResults: response.totalResults,
            );
          } else {
            _searchResponse = response;
            _searchTotalPages2 = response.totalPages;
          }
          if (loadMore) {
            _isFetchingMore2 = false;
          } else {
            _isLoading2 = false;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error2 = e.toString();
          if (loadMore) {
            _isFetchingMore2 = false;
          } else {
            _isLoading2 = false;
          }
        });
      }
    }
  }

  void navigateToDetailPage(MultiSearchResult result) {
    tVmedium(); // Vibrate on navigation
    switch (result.mediaType) {
      case MediaType.movie:
        if (result is MultiSearchMovie) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MovieDetailPage(
                movie: mo.Movie(
                  id: result.id,
                  title: result.name,
                  originalTitle: result.originalName,
                  posterPath: result.posterPath,
                  backdropPath: result.backdropPath,
                  adult: result.adult,
                  genreIds: result.genreIds,
                  originalLanguage: result.originalLanguage.toString(),
                  overview: result.overview.toString(),
                  popularity: result.popularity,
                  voteAverage: result.voteAverage,
                  voteCount: result.voteCount,
                  releaseDate: result.releaseDate.toString(),
                  video: result.video,
                  // Add other necessary fields from the multi search result
                ),
              ),
            ),
          );
        }
        break;
      case MediaType.tv:
        if (result is MultiSearchTV) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TvShowDetailPageAnime(
                tvShow: TvShow(
                  id: result.id,
                  name: result.name,
                  originalName: result.originalName,
                  posterPath: result.posterPath,
                  backdropPath: result.backdropPath,
                  adult: result.adult,
                  genreIds: result.genreIds,
                  originCountry: result.originCountry,
                  originalLanguage: result.originalLanguage.toString(),
                  overview: result.overview.toString(),
                  popularity: result.popularity,
                  voteAverage: result.voteAverage,
                  voteCount: result.voteCount,
                  // Add other necessary fields from the multi search result
                ),
                typec: "tvseries",
              ),
            ),
          );
        }
        break;
      case MediaType.person:
        if (result is MultiSearchPerson) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PersonDetailPage(
                  personId: result.id,
                  initialName: result.name,
                  initialProfilePath: result.profilePath),
            ),
          );
        }
        break;
    }
  }

  void showSearchOverlay(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          // Listen to changes in the search controller and update overlay state
          //  _searchController2.removeListener(onSearchChanged2);
          _searchController2.addListener(() {
            setModalState(() {}); // Rebuild overlay on text change
            onSearchChanged2();
          });
          return DraggableScrollableSheet(
            initialChildSize: 0.9,
            minChildSize: 0.8,
            maxChildSize: 0.95,
            builder: (context, controller2) => Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(25)),
              ),
              child: Column(
                children: [
                  // Search Header
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: _searchController2,
                      decoration: InputDecoration(
                        hintText: 'Search TV Shows...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () async {
                            // Vibrate on clear
                            _searchController2.clear();
                            setModalState(() {});
                            triggerVibration();
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onChanged: (value) async {
                        setModalState(() {});
                        onSearchChanged2();
                        triggerVibration(); // Vibrate on typing
                      },
                    ),
                  ),

                  // Search Results
                  Expanded(
                    child: _buildBody(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading2) {
      return Center(
          child: Shimmer.fromColors(
        // Shimmer effect for loading search body
        baseColor: AppColors.secondaryBackground.withOpacity(0.5),
        highlightColor: AppColors.secondaryBackground.withOpacity(0.1),
        child: ListView.builder(
          itemCount: 5, // Show a few shimmer items
          itemBuilder: (context, index) => Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            clipBehavior: Clip.antiAlias,
            child: SizedBox(
              height: 150,
              child: Row(
                children: [
                  Container(width: 100, height: 150, color: Colors.white),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              width: double.infinity,
                              height: 16,
                              color: Colors.white),
                          const SizedBox(height: 8),
                          Container(
                              width: 150, height: 12, color: Colors.white),
                          const SizedBox(height: 8),
                          Container(
                              width: double.infinity,
                              height: 12,
                              color: Colors.white),
                          const SizedBox(height: 4),
                          Container(
                              width: double.infinity,
                              height: 12,
                              color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ));
    }

    if (_error2 != null) {
      return Center(child: Text('Error: $_error2'));
    }

    if (_searchResponse == null) {
      return const Center(child: Text('Start typing to search...'));
    }

    if (_searchResponse != null && _searchResponse!.results.isEmpty) {
      // Corrected null check
      return Center(child: Text('No results found for "$_currentQuery2".'));
    }

    final results = _searchResponse!.results;

    return ListView.builder(
      controller: _searchScrollController2, // Use the correct controller here
      padding: const EdgeInsets.all(8.0),
      itemCount: results.length + (_isFetchingMore2 ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == results.length && _isFetchingMore2) {
          return const Center(
              child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator()));
        }

        final result = results[index];
        return _buildMultiSearchResultCard(context, result, triggerVibration);
      },
    );
  }

  Widget _buildMultiSearchResultCard(BuildContext context,
      MultiSearchResult result, VoidCallback vibrateCallback) {
    String? imagePath;
    String title = '';
    String subtitle = '';

    switch (result.mediaType) {
      case MediaType.movie:
        final movie = result as MultiSearchMovie;
        imagePath = movie.posterPath;
        title = movie.title;
        subtitle = 'Movie • ${movie.releaseDate}';
        break;
      case MediaType.tv:
        final tv = result as MultiSearchTV;
        imagePath = tv.posterPath;
        title = tv.name;
        subtitle = 'TV Show • ${tv.firstAirDate}';
        break;
      case MediaType.person:
        final person = result as MultiSearchPerson;
        imagePath = person.profilePath;
        title = person.name;
        subtitle = 'Person • ${person.knownForDepartment}';
        break;
    }

    final String posterUrl = imagePath != null
        ? 'https://inosdb.worker-inosuke.workers.dev/w500$imagePath'
        : 'https://inosdb.worker-inosuke.workers.dev/w500$imagePath';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          navigateToDetailPage(result);
          vibrateCallback(); // Vibrate on card tap
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 100,
              height: 150,
              child: posterUrl.isNotEmpty // check if posterUrl is not empty
                  ? CachedNetworkImage(
                      imageUrl: posterUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 1,
                          color: AppColors.accentColor,
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                          _buildErrorWidget(result.mediaType),
                      fadeInDuration: const Duration(milliseconds: 200),
                      fadeOutDuration: const Duration(milliseconds: 100),
                    )
                  : _buildErrorWidget(
                      result.mediaType), // show error if posterUrl is empty
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    Text(subtitle,
                        style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(height: 8),
                    Text(
                      result.mediaType == MediaType.movie
                          ? (result as MultiSearchMovie).overview ?? ''
                          : result.mediaType == MediaType.tv
                              ? (result as MultiSearchTV).overview ?? ''
                              : '',
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget(MediaType mediaType) {
    IconData icon;
    switch (mediaType) {
      case MediaType.movie:
        icon = Icons.movie_outlined;
        break;
      case MediaType.tv:
        icon = Icons.tv_outlined;
        break;
      case MediaType.person:
        icon = Icons.person_outline;
        break;
    }
    return Container(
      color: Colors.grey[700],
      child: Center(
        child: Icon(
          icon,
          color: AppColors.secondaryText,
          size: 30,
        ),
      ),
    );
  }
}

Widget _buildBody0(
    BuildContext context, seriesProvider, typec, VoidCallback vibrateCallback) {
  final status = seriesProvider.status;
  final userData = Provider.of<UserDataService>(context);

  final gridSize = userData.gridSize.toInt();
  if (status == LoadingStatus.loading) {
    // Show loading indicator initially or while loading
    return Center(
      child: Shimmer.fromColors(
        // Shimmer effect for main grid loading
        baseColor: AppColors.secondaryBackground.withOpacity(0.5),
        highlightColor: AppColors.secondaryBackground.withOpacity(0.1),
        child: MasonryGridView.count(
          padding: const EdgeInsets.all(5.0),
          crossAxisCount: 3,
          mainAxisSpacing: 0.5,
          crossAxisSpacing: 0.5,
          itemCount: 10, // Show a few shimmer items
          itemBuilder: (context, index) {
            return Container(
              height: index % 2 == 0
                  ? 200
                  : 250, // Vary height for staggered effect
              color: Colors.white,
            );
          },
        ),
      ),
    );
  }

  final seriesList = seriesProvider.filteredAndSortedContent;
  return MasonryGridView.count(
    padding: const EdgeInsets.all(5.0),
    crossAxisCount: 1 * gridSize, // Adjust number of
    mainAxisSpacing: 1.5,
    controller: ScrollController(keepScrollOffset: true),
    shrinkWrap: true,
    physics: const BouncingScrollPhysics(),
    crossAxisSpacing: 1.5,
    cacheExtent: 100,
    itemCount: seriesList.length,
    itemBuilder: (context, index) {
      final series = seriesList[index];
      return GestureDetector(
        // Wrap card for tap vibration if the card itself does not handle
        onTap: () {
          tVmedium();
          // Assuming AnimeSeriesCard has its own navigation logic
          // If not, you'd add navigation here.
        },
        child: typec == "movie"
            ? MovieCard(
                movie: series,
                typec: typec,
              )
            : AnimeSeriesCard(series: series, typec: typec),
      );
    },
  );
}

class AnimeDetailsScreen extends StatelessWidget {
  final int tvSeriesId; // Use TMDB ID to fetch from map
  final String typec;
  AnimeDetailsScreen(
      {required this.tvSeriesId, required this.typec, super.key});
  final ScrollController _seasonsScrollController = ScrollController();

  // Haptic feedback function instance for this class

  @override
  Widget build(BuildContext context) {
    // Fetch the specific series using the ID directly from the provider's map/list
    // No 'listen: false' needed if the UI should rebuild if the underlying data changes (unlikely here)
    final series = typec == "anime"
        ? Provider.of<AnimeProvider>(context).getAnimeByTmdbId(tvSeriesId)
        : Provider.of<TvSeriesProvider>(context).getAnimeByTmdbId(tvSeriesId);
    final userDataService = Provider.of<UserDataService>(context);
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
    final backdropUrl = series.fullBackdropUrl;
    final posterUrl = series.fullPosterUrl;
    final releaseYear = series.firstAirDate != null
        ? DateFormat('yyyy').format(series.firstAirDate!)
        : 'N/A';
    bool isFavorite = userDataService.isFavoriteAnime(series.tmdbId);
    bool isInWatchlist = userDataService.isOnWatchlistAnime(series.tmdbId);
    // Format runtime if available
    final runtimeString = series.runtime != null && series.runtime! > 0
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
          final season = seasons[index];

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

class MovieDetailsScreen extends StatelessWidget {
  final int movieId;
  final String typec;
  const MovieDetailsScreen(
      {required this.typec, required this.movieId, super.key});

  // Helper function for haptic feedback

  // --- Function to show Trailer Selection Dialog ---

  @override
  Widget build(BuildContext context) {
    // Find the movie using the provider
    final movie = Provider.of<MovieProvider>(context, listen: false)
        .getMovieById(movieId);

    // Fetch UserDataService
    final userDataService = Provider.of<UserDataService>(context);
    bool isFavorite = userDataService.isFavoriteMovie(movieId);

    if (movie == null) {
      return Scaffold(
        backgroundColor: AppColors.primaryBackground,
        appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
        body: const Center(
          child: Text('Movie not found!',
              style: TextStyle(color: AppColors.secondaryText)),
        ),
      );
    }
// NotificationListener<ScrollNotification>(
//         onNotification: (ScrollNotification scrollInfo) {
//           if (scrollInfo is ScrollUpdateNotification) {
//             _triggerHapticFeedback(); // Haptic feedback on scroll drag
//           }
//           return false;
//         },
//         child:
    final backdropUrl = movie.getBackdropUrl();
    final posterUrl = movie.getPosterUrl();
    final downloadLinks = movie.getDownloadLinksList();
    bool isInWatchlist = userDataService.isOnWatchlistMovie(movieId);
    bool isWatched = userDataService.isWatchedEpisode(
        movieId, movieId, movieId, downloadLinks.toString());
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0, // Height of the backdrop
            pinned: true, // Keep AppBar visible when scrolling up
            backgroundColor: const Color.fromARGB(255, 71, 43, 91),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                movie.title,
                style: const TextStyle(
                    color: AppColors.primaryText,
                    fontSize: 16.0,
                    shadows: [Shadow(blurRadius: 4, color: Colors.black54)]),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              centerTitle: false, // Align title to start
              titlePadding:
                  const EdgeInsets.only(left: 60, bottom: 16), // Adjust padding
              background: backdropUrl != null
                  ? Stack(fit: StackFit.expand, children: [
                      CachedNetworkImage(
                        imageUrl: backdropUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 1,
                            color: AppColors.accentColor,
                          ),
                        ),
                        errorWidget: (context, url, error) => Center(
                          child: posterUrl != null
                              ? CachedNetworkImage(
                                  imageUrl: posterUrl,
                                  fit: BoxFit.contain, // Fallback to poster
                                  placeholder: (context, url) => const Center(
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
                              : const Icon(Icons.movie_outlined,
                                  size: 100, color: AppColors.secondaryText),
                        ),
                        fadeInDuration: const Duration(milliseconds: 300),
                        fadeOutDuration: const Duration(milliseconds: 100),
                      ),
                      // Add a gradient overlay for better title readability
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
                      // Add the Positioned widget for favorite, rating, and watchlist
                      Positioned(
                        top: 8.0,
                        right: 8.0,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Favorite
                            IconButton(
                              icon: Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isFavorite ? Colors.red : Colors.white,
                                size: 20,
                              ),
                              onPressed: () async {
                                await userDataService
                                    .toggleFavoriteMovie(movieId);
                                tVClick();
                                // Show snackbar feedback
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
                            // Rating bubble
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6.0, vertical: 4.0),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: Text(
                                '${movie.voteAverage.toStringAsFixed(1)}/10', // Display rating
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
                                isInWatchlist
                                    ? Icons.bookmark
                                    : Icons.bookmark_border,
                                color:
                                    isInWatchlist ? Colors.green : Colors.white,
                                size: 20,
                              ),
                              onPressed: () async {
                                await userDataService
                                    .toggleWatchlistMovie(movieId);
                                tVClick();
                                // Show snackbar feedback
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
                    ])
                  : Container(
                      color: AppColors.secondaryBackground,
                      child: Center(
                          child: Text(movie.title,
                              style: const TextStyle(
                                  color: AppColors.primaryText,
                                  fontSize: 24)))),
            ),
            // Optional: Add subtle border when pinned
            bottom: PreferredSize(
                // Add this code to get bottom border
                preferredSize:
                    const Size.fromHeight(1.0), // Creates the border size
                child: Container(
                  // Creates the border container
                  color: AppColors.dividerColor.withOpacity(0.5),
                  height: 1.0,
                )),
          ),

          // --- Movie Content Below AppBar ---
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Title and Basic Info Row ---
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    // Small Poster on the side
                    SizedBox(
                      width: 100,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
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
                                errorWidget: (context, url, error) =>
                                    const Center(
                                  child: Icon(
                                    Icons.image_not_supported_outlined,
                                    color: AppColors.secondaryText,
                                    size: 30,
                                  ),
                                ),
                                fadeInDuration:
                                    const Duration(milliseconds: 200),
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
                    const SizedBox(width: 16),

                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(movie.title,
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
                        ...[
                          const SizedBox(height: 4),
                          Text(
                            movie.tagline!,
                            style: const TextStyle(
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                                color: AppColors.secondaryText),
                          ),
                        ],
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today,
                                size: 16, color: AppColors.secondaryText),
                            const SizedBox(width: 4),
                            Text(
                                movie.releaseDate != null
                                    ? DateFormat('yyyy')
                                        .format(movie.releaseDate!)
                                    : 'N/A',
                                style: const TextStyle(
                                    color: AppColors.secondaryText)),
                            const SizedBox(width: 10),
                            if (movie.runtime != null) ...[
                              const Icon(Icons.timer_outlined,
                                  size: 16, color: AppColors.secondaryText),
                              const SizedBox(width: 4),
                              Text('${movie.runtime} min',
                                  style: const TextStyle(
                                      color: AppColors.secondaryText)),
                            ]
                          ],
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          // Display Genres as chips
                          spacing: 6.0,
                          runSpacing: 4.0,
                          children: movie.genres
                              .map((genre) => Chip(
                                    label: Text(genre,
                                        style: const TextStyle(fontSize: 11)),
                                    backgroundColor: AppColors.chipBackground,
                                    labelStyle: const TextStyle(
                                        color: AppColors.chipText),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 0),
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ))
                              .toList(),
                        )
                      ],
                    ))
                  ]),
                  const SizedBox(height: 24),

                  // --- Play and Download Buttons ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.play_arrow),
                        label: Text(
                          isWatched ? 'Played Before' : 'Play',
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accentColor,
                            foregroundColor: AppColors.primaryText,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 12)),
                        onPressed: downloadLinks.isEmpty
                            ? null // Disable if no links
                            : () {
                                _showDownloadLinkSelection(
                                    context, downloadLinks);
                                tVClick();
                              },
                      ),
                      // ElevatedButton.icon(
                      //   icon: const Icon(Icons.download_outlined),
                      //   label: const Text('Download'),
                      //   style: ElevatedButton.styleFrom(
                      //       backgroundColor: AppColors
                      //           .secondaryBackground, // Different style
                      //       foregroundColor: AppColors.primaryText,
                      //       padding: const EdgeInsets.symmetric(
                      //           horizontal: 25, vertical: 12)),
                      //   onPressed: () async {
                      //     ScaffoldMessenger.of(context).showSnackBar(
                      //         const SnackBar(
                      //             content:
                      //                 Text('Download not implemented yet.'),
                      //             duration: Duration(seconds: 2)));
                      //   },

                      // ),
                    ],
                  ),
                  // --- Overview / Synopsis ---
                  const Text('Overview',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryText)),
                  const SizedBox(height: 8),
                  Text(
                    movie.overview,
                    style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.secondaryText,
                        height: 1.4),
                  ),
                  const SizedBox(height: 24),

                  // --- Additional Details (Optional) ---
                  _buildDetailSection('Keywords', movie.keywords.join(', ')),
                  _buildDetailSection('Production Countries',
                      movie.productionCountries.join(', ')),

                  const SizedBox(height: 50), // Add some padding at the bottom
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper to build sections for additional details
  Widget _buildDetailSection(String title, String content) {
    if (content.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryText)),
          const SizedBox(height: 6),
          Text(content,
              style: const TextStyle(
                  fontSize: 13, color: AppColors.secondaryText)),
        ],
      ),
    );
  }

  // --- Function to show Download Link Selection Dialog ---
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
            if (link.contains('1080p')) {
              qualityGuess = "1080p ";
            } else if (link.contains('720p'))
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
                Navigator.pop(dialogContext); // Close the dialog
                userDataService.toggleIsWatchedLink(
                    movieId, movieId, movieId, links.toString());
                tVClick();
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
}
