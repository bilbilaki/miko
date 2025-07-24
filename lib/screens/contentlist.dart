// lib/screens/content_list_screen.dart
import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For HapticFeedback
import 'package:miko/models/advancedfiltering.dart';
import 'package:miko/screens/filtrering_screen.dart';
import 'package:miko/screens/tvseriescard.dart';
import 'package:miko/showcases/person_detail_page.dart' as TmdbApiModels;
import 'package:miko/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shimmer/shimmer.dart';

// My imports
import '../providers/anime_provider.dart' hide MovieProvider, TvSeriesProvider, AnimeProvider; // Includes TvSeriesProvider indirectly
import '../utils/colors.dart'; // Assuming AppColors and AppColors2 exist
import '../services/user_data_service.dart'; // User data service
import '../showcases/model.dart' as TmdbApiModels; // For TmdbApiModels.Movie, TmdbApiModels.TvShow, MultiSearch
import '../models/tv_series_anime.dart' as AnimeSeriesModels; // For AnimeSeriesModels.TvSeriesAnime, AnimeSeriesModels.Episode, AnimeSeriesModels.Season

// My custom detail pages (ensure these paths are correct in your project)
import '../showcases/movie_detail_page_copy.dart'; // User's MovieDetailPage
import '../showcases/tv_detail_page_anime.dart'; // User's TvShowDetailPageAnime
import 'package:miko/showcases/movie_service.dart'; // For MultiSearch API

// --- Haptic Feedback Utility ---
// Ensure these functions are globally accessible or in a utility file
// If you have these defined already in `miko/utils/utils.dart`, remove these duplicates.
void triggerVibration() {
  if (Platform.isAndroid || Platform.isIOS) {
    HapticFeedback.lightImpact(); // Or HapticFeedback.mediumImpact() / HapticFeedback.vibrate()
  }
}
void tVmedium() => triggerVibration(); // User's alias
void tVClick() => triggerVibration(); // User's alias

// Global instance for search overlay to debounce.
// In a real app, this search logic might be better encapsulated in a separate search page.
final MovieService _movieService = MovieService(); // Assume MovieService is a singleton/di.

class ContentListScreen<T extends ContentProvider<dynamic>> extends StatefulWidget {
  final String typec; // "movie", "series", "anime"
  final String title; // Title for the app bar

  const ContentListScreen({super.key, required this.typec, required this.title});

  @override
  State<ContentListScreen<T>> createState() => _ContentListScreenState<T>();
}

class _ContentListScreenState<T extends ContentProvider<dynamic>> extends State<ContentListScreen<T>> {
  late ScrollController _scrollController;
  late ScrollController _searchScrollController;
  late TextEditingController _searchController;
  Timer? _debounce;

  TmdbApiModels.MultiSearchResponse? _searchResponse;
  bool _isFetchingMore = false;
  String? _error;
  String _currentQuery = '';
  int _searchPage = 1;
  int _searchTotalPages = 1;
  bool _isLoadingSearch = false;

  // View mode state
  bool _isGridView = true; // Default to grid view
  late double _gridCrossAxisCount; // Default grid size, loaded from UserDataService

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _searchScrollController = ScrollController();
    _searchController = TextEditingController();

    _searchScrollController.addListener(_searchScrollListener);
    _searchController.addListener(_onSearchChanged);

    // Initialize grid size from UserDataService
    _gridCrossAxisCount = Provider.of<UserDataService>(context, listen: false).gridSize;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchScrollController.dispose();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce?.cancel();
    _movieService.dispose(); // Dispose TMDB movie service if not managed by DI
    super.dispose();
  }

  void _searchScrollListener() async {
    if (_searchScrollController.position.pixels >=
        _searchScrollController.position.maxScrollExtent * 0.7) {
      if (!_isFetchingMore && _searchPage < _searchTotalPages) {
        _searchPage++;
        await fetchMultiSearch(loadMore: true);
      }
    }
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      final query = _searchController.text.trim();
      if (query != _currentQuery) {
        _currentQuery = query;
        _searchPage = 1;
        _searchResponse = null; // Clear previous search results for new query
        if (_currentQuery.isNotEmpty) {
          setState(() {
            _isLoadingSearch = true;
            _error = null;
          });
          fetchMultiSearch();
        } else {
          setState(() {
            _searchResponse = null;
            _isLoadingSearch = false;
            _error = null;
          });
        }
      }
    });
  }

  Future<void> fetchMultiSearch({bool loadMore = false}) async {
    if (_currentQuery.isEmpty || _isFetchingMore) return;
    setState(() {
      if (loadMore) {
        _isFetchingMore = true;
      } else {
        _isLoadingSearch = true;
      }
      _error = null;
    });
    try {
      final response = await _movieService.multiSearch(
        query: _currentQuery,
        page: _searchPage,
      );
      if (mounted) {
        setState(() {
          if (loadMore) {
            _searchResponse?.results.addAll(response.results);
            _searchResponse = TmdbApiModels.MultiSearchResponse(
              page: response.page,
              results: _searchResponse?.results ?? response.results,
              totalPages: response.totalPages,
              totalResults: response.totalResults,
            );
          } else {
            _searchResponse = response;
            _searchTotalPages = response.totalPages;
          }
          if (loadMore) {
            _isFetchingMore = false;
          } else {
            _isLoadingSearch = false;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          if (loadMore) {
            _isFetchingMore = false;
          } else {
            _isLoadingSearch = false;
          }
        });
      }
    }
  }

  // --- Search Overlay Logic (for TMDB API Search) ---
  void _showSearchOverlay() {
    triggerVibration();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        // Use a separate StatefulBuilder for the modal bottom sheet
        // This ensures the modal content rebuilds independently of the main screen
        return StatefulBuilder(
          builder: (BuildContext modalContext, StateSetter modalSetState) {
            return DraggableScrollableSheet(
              initialChildSize: 0.9,
              minChildSize: 0.8,
              maxChildSize: 0.95,
              expand: false,
              builder: (_, controller2) {
                // Ensure _searchScrollController is correctly associated with this draggable sheet's scroll view
                _searchScrollController = controller2;
                return Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search TMDB...', // Clarify this search is for TMDB
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                modalSetState(() {});
                                triggerVibration();
                              },
                            ),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                          ),
                          onChanged: (value) {
                            modalSetState(() {}); // Rebuild modal on text change
                            _onSearchChanged(); // This triggers the debounced TMDB API search
                            triggerVibration();
                          },
                        ),
                      ),
                      Expanded(
                        child: _buildSearchResultsBody(modalContext),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildSearchResultsBody(BuildContext context) {
    if (_isLoadingSearch) {
      return Center(
        child: Shimmer.fromColors(
          baseColor: AppColors.secondaryBackground.withOpacity(0.5),
          highlightColor: AppColors.secondaryBackground.withOpacity(0.1),
          child: ListView.builder(
            itemCount: 5,
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
                            Container(width: double.infinity, height: 16, color: Colors.white),
                            const SizedBox(height: 8),
                            Container(width: 150, height: 12, color: Colors.white),
                            const SizedBox(height: 8),
                            Container(width: double.infinity, height: 12, color: Colors.white),
                            const SizedBox(height: 4),
                            Container(width: double.infinity, height: 12, color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    if (_error != null) {
      return Center(child: Text('Error: $_error'));
    }

    if (_searchResponse == null) {
      return const Center(child: Text('Start typing to search...'));
    }

    if (_searchResponse!.results.isEmpty) {
      return Center(child: Text('No results found for "$_currentQuery".'));
    }

    final results = _searchResponse!.results;

    return ListView.builder(
      controller: _searchScrollController,
      padding: const EdgeInsets.all(8.0),
      itemCount: results.length + (_isFetchingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == results.length && _isFetchingMore) {
          return const Center(
              child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator()));
        }

        final result = results[index];
        return _buildMultiSearchResultCard(context, result);
      },
    );
  }

  Widget _buildMultiSearchResultCard(BuildContext context, TmdbApiModels.MultiSearchResult result) {
    String? imagePath;
    String title = '';
    String subtitle = '';

    switch (result.mediaType) {
      case TmdbApiModels.MediaType.movie:
        final movie = result as TmdbApiModels.MultiSearchMovie;
        imagePath = movie.posterPath;
        title = movie.title;
        subtitle = 'Movie • ${movie.releaseDate}';
        break;
      case TmdbApiModels.MediaType.tv:
        final tv = result as TmdbApiModels.MultiSearchTV;
        imagePath = tv.posterPath;
        title = tv.name;
        subtitle = 'TV Show • ${tv.firstAirDate}';
        break;
      case TmdbApiModels.MediaType.person:
        final person = result as TmdbApiModels.MultiSearchPerson;
        imagePath = person.profilePath;
        title = person.name;
        subtitle = 'Person • ${person.knownForDepartment}';
        break;
    }

    final String posterUrl = imagePath != null
        ? 'https://image.tmdb.org/t/p/w200$imagePath' // Use a standard TMDB image base URL
        : '';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          triggerVibration();
          Navigator.pop(context); // Close search overlay first
          switch (result.mediaType) {
            case TmdbApiModels.MediaType.movie:
              if (result is TmdbApiModels.MultiSearchMovie) {
                // Navigate to the user's MovieDetailPage, which expects TmdbApiModels.Movie
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MovieDetailPage(
                      movie: TmdbApiModels.Movie(
                        id: result.id,
                        title: result.title,
                        originalTitle: result.originalTitle,
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
                        video: result.video, tagline: null, runtime: null,
                      ),
                    ),
                  ),
                );
              }
              break;
            case TmdbApiModels.MediaType.tv:
              if (result is TmdbApiModels.MultiSearchTV) {
                // Navigate to the user's TvShowDetailPageAnime, which expects TmdbApiModels.TvShow
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TvShowDetailPageAnime(
                      tvShow: TmdbApiModels.TvShow(
                        id: result.id,
                        name: result.name,
                        originalName: result.originalName,
                        posterPath: result.posterPath,
                        backdropPath: result.backdropPath,
                        adult: result.adult,
                        genreIds: result.genreIds,
                        originCountry: result.originCountry, // This is List<String>
                        originalLanguage: result.originalLanguage.toString(),
                        overview: result.overview.toString(),
                        popularity: result.popularity,
                        voteAverage: result.voteAverage,
                        voteCount: result.voteCount,
                        firstAirDate: result.firstAirDate,
                      //  runtime: null, status: null, tagline: null, trailerKey: null,
                      ),
                      typec: "series", // `typec` can be "series" or "anime" depending on what TvShowDetailPageAnime expects for non-movie content
                    ),
                  ),
                );
              }
              break;
            case TmdbApiModels.MediaType.person:
              if (result is TmdbApiModels.MultiSearchPerson) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TmdbApiModels.PersonDetailPage(
                          personId: result.id,
                          initialName: result.name,
                          initialProfilePath: result.profilePath)),
                );
              }
              break;
          }
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 100,
              height: 150,
              child: posterUrl.isNotEmpty
                  ? CachedNetworkImage(
                imageUrl: posterUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 1,
                      color: AppColors.accentColor,
                    )),
                errorWidget: (context, url, error) => _buildErrorWidget(result.mediaType),
                fadeInDuration: const Duration(milliseconds: 200),
                fadeOutDuration: const Duration(milliseconds: 100),
              )
                  : _buildErrorWidget(result.mediaType),
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
                    Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(height: 8),
                    Text(
                      result.mediaType == TmdbApiModels.MediaType.movie
                          ? (result as TmdbApiModels.MultiSearchMovie).overview ?? ''
                          : result.mediaType == TmdbApiModels.MediaType.tv
                          ? (result as TmdbApiModels.MultiSearchTV).overview ?? ''
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

  Widget _buildErrorWidget(TmdbApiModels.MediaType mediaType) {
    IconData icon;
    switch (mediaType) {
      case TmdbApiModels.MediaType.movie:
        icon = Icons.movie_outlined;
        break;
      case TmdbApiModels.MediaType.tv:
        icon = Icons.tv_outlined;
        break;
      case TmdbApiModels.MediaType.person:
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

  @override
  Widget build(BuildContext context) {
    // Determine the correct provider based on typec
    T provider;
    if (widget.typec == "movie") {
      provider = context.watch<MovieProvider>() as T;
    } else if (widget.typec == "anime") {
      provider = context.watch<AnimeProvider>() as T;
    } else if (widget.typec == "tvseries") {
      provider = context.watch<TvSeriesProvider>() as T;
    } else {
      throw Exception("Invalid content type: ${widget.typec}");
    }

    final userData = Provider.of<UserDataService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.search), // Separate button for TMDB search overlay
            onPressed: _showSearchOverlay,
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              triggerVibration();
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => ContentFilterBottomSheet<T>(
                  provider: provider,
                ),
              );
            },
          ),
          // Toggle between List and Grid View
          IconButton(
            icon: Icon(_isGridView ? Icons.view_list : Icons.grid_on),
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
                triggerVibration();
              });
            },
          ),
        ],
        // The existing search bar for *local* content filtering/searching
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search local data...', // Clarify this is for local content
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                prefixIcon: const Icon(Icons.search), // Redundant icon if using parent's
              ),
              onChanged: (query) {
                provider.updateSearchQuery(query); // This updates the provider's *local* search
              },
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          if (_isGridView) // Show slider only in grid view
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  const Text('Grid Size:'),
                  Expanded(
                    child: Slider(
                      value: _gridCrossAxisCount,
                      min: 2,
                      max: 6,
                      divisions: 4, // Allows 2, 3, 4, 5, 6 columns
                      label: _gridCrossAxisCount.round().toString(),
                      onChanged: (double newValue) {
                        setState(() {
                          _gridCrossAxisCount = newValue;
                        });
                       // userData.gridSize = newValue; // Persist grid size
                        triggerVibration();
                      },
                    ),
                  ),
                ],
              ),
            ),
          // Display Active Filters Summary (re-used logic from previous response)
          Consumer<T>(
            builder: (context, currentProvider, child) {
              final activeFilters = currentProvider.activeFilters;
              final List<Widget> filterChips = [];

              if (!activeFilters.isClear) {
                if (activeFilters.genres.isNotEmpty) {
                  filterChips.add(_buildActiveFilterChip(
                    'Genres: ${activeFilters.genres.join(', ')}',
                        () => currentProvider.applyFiltersAndSort(activeFilters.copyWith(genres: {})),
                  ));
                }
                if (activeFilters.languages.isNotEmpty) {
                  filterChips.add(_buildActiveFilterChip(
                    'Languages: ${activeFilters.languages.join(', ')}',
                        () => currentProvider.applyFiltersAndSort(activeFilters.copyWith(languages: {})),
                  ));
                }
                if (currentProvider is MovieProvider && activeFilters.countries.isNotEmpty) {
                  filterChips.add(_buildActiveFilterChip(
                    'Countries: ${activeFilters.countries.join(', ')}',
                        () => currentProvider.applyFiltersAndSort(activeFilters.copyWith(countries: {})),
                  ));
                }
                if (activeFilters.minVoteAverage > ContentFilterState.initial().minVoteAverage ||
                    activeFilters.maxVoteAverage < ContentFilterState.initial().maxVoteAverage) {
                  filterChips.add(_buildActiveFilterChip(
                    'Vote: ${activeFilters.minVoteAverage.toStringAsFixed(1)}-${activeFilters.maxVoteAverage.toStringAsFixed(1)}',
                        () => currentProvider.applyFiltersAndSort(activeFilters.copyWith(
                      minVoteAverage: ContentFilterState.initial().minVoteAverage,
                      maxVoteAverage: ContentFilterState.initial().maxVoteAverage,
                    )),
                  ));
                }
                if (activeFilters.minRuntime != null || activeFilters.maxRuntime != null) {
                  filterChips.add(_buildActiveFilterChip(
                    'Runtime: ${activeFilters.minRuntime ?? 'Any'}-${activeFilters.maxRuntime ?? 'Any'} min',
                        () => currentProvider.applyFiltersAndSort(activeFilters.copyWith(minRuntime: null, maxRuntime: null)),
                  ));
                }
                if (activeFilters.startDate != null || activeFilters.endDate != null) {
                  String dateRange = '';
                  if (activeFilters.startDate != null)
                    dateRange += 'From: ${activeFilters.startDate!.toLocal().year}-${activeFilters.startDate!.toLocal().month.toString().padLeft(2, '0')}-${activeFilters.startDate!.toLocal().day.toString().padLeft(2, '0')}';
                  if (activeFilters.endDate != null)
                    dateRange += ' To: ${activeFilters.endDate!.toLocal().year}-${activeFilters.endDate!.toLocal().month.toString().padLeft(2, '0')}-${activeFilters.endDate!.toLocal().day.toString().padLeft(2, '0')}';
                  filterChips.add(_buildActiveFilterChip(
                    'Date: $dateRange',
                        () => currentProvider.applyFiltersAndSort(activeFilters.copyWith(startDate: null, endDate: null)),
                  ));
                }

                String sortLabel = 'Sort by: ${activeFilters.sortBy.toString().split('.').last.replaceAllMapped(RegExp(r'([A-Z])'), (match) => ' ${match.group(1)}').trim()} (${activeFilters.isAscending ? 'Asc' : 'Desc'})';
                filterChips.add(Chip(label: Text(sortLabel)));
              }

              if (filterChips.isEmpty && currentProvider.searchQuery.isEmpty) {
                return const SizedBox.shrink();
              }

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: [
                    if (currentProvider.searchQuery.isNotEmpty)
                      _buildActiveFilterChip(
                        'Search: "${currentProvider.searchQuery}"',
                            () { currentProvider.updateSearchQuery(''); },
                      ),
                    ...filterChips,
                    if (!activeFilters.isClear)
                      ActionChip(
                        label: const Text('Clear All Filters'),
                        avatar: const Icon(Icons.clear_all),
                        onPressed: () { currentProvider.applyFiltersAndSort(ContentFilterState.initial()); },
                      ),
                  ],
                ),
              );
            },
          ),
          Expanded(
            child: provider.filteredAndSortedContent.isNotEmpty && provider.filteredAndSortedContent.length < 10
                ? Shimmer.fromColors(
              baseColor: AppColors.secondaryBackground.withOpacity(0.5),
              highlightColor: AppColors.secondaryBackground.withOpacity(0.1),
              child: _isGridView
                  ? MasonryGridView.count(
                padding: const EdgeInsets.all(5.0),
                crossAxisCount: _gridCrossAxisCount.toInt(),
                mainAxisSpacing: 0.5,
                crossAxisSpacing: 0.5,
                itemCount: 10, // Placeholder shimmer items
                itemBuilder: (context, index) {
                  return Container(
                    height: index % 2 == 0 ? 200 : 250,
                    color: Colors.white,
                  );
                },
              )
                  : ListView.builder(
                itemCount: 5, // Placeholder shimmer items for list view
                itemBuilder: (context, index) => Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    leading: Container(width: 50, height: 75, color: Colors.white),
                    title: Container(width: double.infinity, height: 16, color: Colors.white),
                    subtitle: Container(width: 100, height: 12, color: Colors.white),
                  ),
                ),
              ),
            )
                : provider != provider
                ? Center(child: Text('Error: '))
                : provider.filteredAndSortedContent.isEmpty
                ? const Center(child: Text('No content found matching criteria.'))
                : _isGridView
                ? MasonryGridView.count(
              padding: const EdgeInsets.all(5.0),
              crossAxisCount: _gridCrossAxisCount.toInt().clamp(2,6), // Clamp for safety
              mainAxisSpacing: 1.5,
              crossAxisSpacing: 1.5,
              itemCount: provider.filteredAndSortedContent.length,
              itemBuilder: (context, index) {
                final item = provider.filteredAndSortedContent[index];
                if (widget.typec == 'movie') {
                  return MovieCard(
                    movie: item as TmdbApiModels.Movie,
                    typec: widget.typec,
                  );
                } else {
                  return AnimeSeriesCard(
                    series: item as AnimeSeriesModels.TvSeriesAnime,
                    typec: widget.typec,
                  );
                }
              },
            )
                : ListView.builder(
              controller: _scrollController,
              itemCount: provider.filteredAndSortedContent.length,
              itemBuilder: (context, index)   {
                final item = provider.filteredAndSortedContent[index];
                if (widget.typec == 'movie')  {
                  final movie = item as AnimeSeriesModels.Movie;
                   cn()async{
                dn()async{
                  final tmdbmovie = await AppModelConverters().toTmdbMovie(movie);
                  return tmdbmovie;
                }  
                // return tmdbmovie;
                   
                   final finalmovie = await dn();
                    return MovieListTile(movie: finalmovie!);
                  }
                  return FutureBuilder<MovieListTile>(
                    future: cn(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return snapshot.data!;
                      }
                    },
                  );
                  // return MovieListTile(movie:  tmdbmovie );
               } 
              //     return MovieListTile(movie: movie);
//                } else {
                  final series = item as AnimeSeriesModels.TvSeriesAnime;
                  return TvSeriesAnimeListTile(series: series);
                }
  //            },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveFilterChip(String label, VoidCallback onDelete) {
    return Chip(label: Text(label), onDeleted: onDelete, deleteIcon: const Icon(Icons.cancel));
  }
}

// --- New List Tile Widgets for Movies/TV/Anime ---
class MovieListTile extends StatelessWidget {
  final TmdbApiModels.Movie movie;
  const MovieListTile({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final posterUrl = movie.fullPosterPath;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 4,
      child: InkWell(
        onTap: () {
          triggerVibration();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MovieDetailPage(movie: movie), // Navigate to MovieDetailPage directly
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                // ignore: unnecessary_null_comparison
                child: posterUrl != null
                    ? CachedNetworkImage(
                  imageUrl: posterUrl,
                  height: 100,
                  width: 70,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    height: 100, width: 70, color: Colors.grey[800],
                    child: const Center(child: CircularProgressIndicator(strokeWidth: 1)),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 100, width: 70, color: Colors.grey[700],
                    child: const Icon(Icons.movie_outlined, color: Colors.white70),
                  ),
                )
                    : Container(
                  height: 100,
                  width: 70,
                  color: Colors.grey[700],
                  child: const Icon(Icons.movie_outlined, color: Colors.white70),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Rating: ${movie.voteAverage.toStringAsFixed(1)} | Year: ${movie.releaseDate}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      movie.overview,
                      style: const TextStyle(color: Colors.grey),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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

class TvSeriesAnimeListTile extends StatelessWidget {
  final AnimeSeriesModels.TvSeriesAnime series;
  const TvSeriesAnimeListTile({super.key, required this.series});

  @override
  Widget build(BuildContext context) {
    final posterUrl = series.fullPosterUrl;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 4,
      child: InkWell(
        onTap: () {
          triggerVibration();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TvShowDetailPageAnime(
                tvShow: AppModelConverters().toTmdbTvSeries(series), // Convert to TmdbApiModels.TvShow
                typec: 'series', // Pass correct typec
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: posterUrl != null
                    ? CachedNetworkImage(
                  imageUrl: posterUrl,
                  height: 100,
                  width: 70,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    height: 100, width: 70, color: Colors.grey[800],
                    child: const Center(child: CircularProgressIndicator(strokeWidth: 1)),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 100, width: 70, color: Colors.grey[700],
                    child: const Icon(Icons.tv_outlined, color: Colors.white70),
                  ),
                )
                    : Container(
                  height: 100,
                  width: 70,
                  color: Colors.grey[700],
                  child: const Icon(Icons.tv_outlined, color: Colors.white70),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      series.name,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Rating: ${series.voteAverage.toStringAsFixed(1)} | Year: ${series.firstAirDate?.year ?? 'N/A'}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      series.overview,
                      style: const TextStyle(color: Colors.grey),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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