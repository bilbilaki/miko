// lib/screens/home_screen.dart
import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:miko/models/movie.dart' as og;
import 'package:miko/showcases/model.dart';
import 'package:miko/showcases/movie_detail_page.dart';
import 'package:miko/showcases/movie_service.dart';
import 'package:miko/showcases/person_detail_page.dart';
import 'package:miko/showcases/tv_detail_page.dart';
import 'package:provider/provider.dart';
import 'package:miko/providers/movie_provider.dart';
import 'package:miko/utils/colors.dart';
// Use Staggered Grid View for potentially better layout
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
//import 'package:miko/utils/dynamic_background.dart'; // For dynamic background
import 'package:miko/services/user_data_service.dart';

import '../widgets/anime_series_card.dart';
import 'video_player_screen.dart';

enum SortMode { type, name, date }

enum ViewMode { grid, list }


// class _GridItem {
//   final dynamic entity;
//   final String name;
//   final bool isFolder;

//   _GridItem(this.entity)
//       : name =
//             entity is FileSystemEntity ? p.basename(entity.path) : entity.name,
//         isFolder = entity is Directory;
// }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SortMode _sortMode = SortMode.name;
  bool _sortAscending = true;
  double _gridCrossAxisCount = 3.0; // Default grid size
  ViewMode _viewMode = ViewMode.grid;

// List<_GridItem> _getSortedItems(MovieProvider provider) {
//   final items = [
//     ...provider.movies.map((f) => _GridItem(f)),
//     // ...provider.movies.map((f) => _GridItem(f)),
//     // ...provider.audios.map((f) => _GridItem(f)), // Added audios
//     // ...provider.images.map((f) => _GridItem(f)), // Added images
//     // ...provider.documents.map((f) => _GridItem(f)), // Added documents
//   ];

//   items.sort((a, b) {
//     int comparison;
//     switch (_sortMode) {
//       case SortMode.name:
//         comparison = a.name.toLowerCase().compareTo(b.name.toLowerCase());
//         break;
//       case SortMode.date:
//         // For date, newer comes first if descending, older comes first if ascending
//         comparison = b.entity.statSync().modified.compareTo(
//               a.entity.statSync().modified,
//             );
//         break;
//       case SortMode.type:
//       // Sort folders first, then files by type, then by name
//         if (a.isFolder && !b.isFolder) {
//           comparison = -1; // 'a' (folder) comes before 'b' (file)
//         } else if (!a.isFolder && b.isFolder) {
//           comparison = 1; // 'a' (file) comes after 'b' (folder)
//         } else {
//           // Both are files or both are folders; sort by file extension then by name
//           String typeA =
//               a.isFolder ? 'folder' : p.extension(a!.entity.path).toLowerCase();
//           String typeB =
//               b.isFolder ? 'folder' : p.extension(b.entity.path).toLowerCase();
//           comparison = typeA.compareTo(typeB);
//           if (comparison == 0) {
//             comparison = a.name.toLowerCase().compareTo(b.name.toLowerCase());
//           }
//         }
//         break;
//     }
//     return _sortAscending
//         ? comparison
//         : -comparison; // Apply ascending/descending order
//   });

//   return items;
// }

// --- UI FOR GRID SIZE SLIDER ---
  /// Shows a dialog to adjust the number of columns in grid view.
  void _showSizeSliderDialog() {
    showDialog(
        context: context,
        builder: (context) {
          // Use a StatefulBuilder so only the slider dialog rebuilds on drag,
          // without rebuilding the entire LocalScreen.
          return StatefulBuilder(
            builder: (context, setDialogState) {
              return AlertDialog(
                title: const Text("Adjust Item Size"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Columns: ${_gridCrossAxisCount.toInt()}"),
                    Slider(
                      value: _gridCrossAxisCount,
                      min: 2, // Minimum 2 columns (for larger items)
                      max: 8, // Maximum 8 columns (for smaller items)
                      divisions: 6, // 8 - 2 = 6 steps for integer values
                      label: _gridCrossAxisCount.toInt().toString(),
                      onChanged: (newValue) {
                        // Update both the dialog's state and the main screen's state
                        setDialogState(() {
                          setState(() {
                            _gridCrossAxisCount = newValue;
                          });
                        });
                      },
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("Done"),
                  ),
                ],
              );
            },
          );
        });
  }

// Remove imports for dummy data, VideoCard, StatusBar, ChipBar if not used

  // @override
  // Widget build(BuildContext context) {
  //   // Listen to MovieProvider changes
  //   return Consumer<MovieProvider>(
  //     builder: (context, movieProvider, child) {
  //       return _buildBody(context, movieProvider);
  //     },
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return Material(
        child: Scaffold(
            appBar: AppBar(
                title: Text("Esil Movie"),
                // Show back button if not at the root of the external path
                actions: [
                  IconButton(
                    icon: const Icon(Icons.home_sharp),
                    onPressed: () {
                      Navigator.of(
                        context,
                      ).push(MaterialPageRoute(builder: (_) => HomeScreen()));
                    },
                  ),
                  // --- View Mode Togg]le ---
                  IconButton(
                    icon: Icon(
                      _viewMode == ViewMode.grid
                          ? Icons.view_list
                          : Icons.grid_view,
                    ),
                    tooltip: "Toggle View",
                    onPressed: () => setState(
                      () => _viewMode = _viewMode == ViewMode.grid
                          ? ViewMode.list
                          : ViewMode.grid,
                    ),
                  ),
                  // --- Size Adjustment Button (only shown in grid view) ---
                  if (_viewMode == ViewMode.grid)
                    IconButton(
                      icon: const Icon(Icons.view_quilt_outlined),
                      tooltip: "Adjust Size",
                      onPressed: _showSizeSliderDialog,
                    ),
                  // --- Sorting Menu ---
                  PopupMenuButton<SortMode>(
                    icon: Icon(Icons.sort),
                    tooltip: "Sort by",
                    onSelected: (mode) {
                      // If same sort mode is selected, toggle ascending/descending
                      if (_sortMode == mode) {
                        setState(() => _sortAscending = !_sortAscending);
                      } else {
                        // Otherwise, set new sort mode and reset to ascending
                        setState(() {
                          _sortMode = mode;
                          _sortAscending = true;
                        });
                      }
                    },
                    itemBuilder: (context) => const [
                      PopupMenuItem(
                        value: SortMode.type,
                        child: Text("Sort by Type"),
                      ),
                      PopupMenuItem(
                        value: SortMode.name,
                        child: Text("Sort by Name"),
                      ),
                      PopupMenuItem(
                        value: SortMode.date,
                        child: Text("Sort by Date"),
                      ),
                    ],
                  ),
                ]),
            body: Stack(
              children: [
                Consumer<MovieProvider>(
                    builder: (context, movieProvider, child) {
                  return _buildBody0(context, movieProvider);
                }),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _showSearchOverlay,
                    child: Container(
                      padding: const EdgeInsets.all(16),
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
            )));
  }

  final MovieService _movieService = MovieService();

  bool _isLoading2 = false;
  final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollController2 = ScrollController();

  // Search fields
  final TextEditingController _searchController2 = TextEditingController();

  final ScrollController _searchScrollController = ScrollController();
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
    // _loadMovies();
    // _scrollController.addListener(_scrollListener);
    _searchScrollController.addListener(_searchScrollListener);

    _searchController2.addListener(_onSearchChanged2);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchScrollController.dispose();
    _movieService.dispose();
    _searchController2.removeListener(_onSearchChanged2);
    _searchController2.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _searchScrollListener() {
    if (_searchScrollController2.position.pixels >=
        _searchScrollController2.position.maxScrollExtent * 0.8) {
      if (!_isFetchingMore2 && _searchPage2 < _searchTotalPages2) {
        _searchPage2++;
        _fetchMultiSearch(loadMore: true);
      }
    }
  }

  void _onSearchChanged2() async {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 200), () {
      final query = _searchController2.text;
      if (query != _currentQuery2) {
        _currentQuery2 = query;
        _searchPage2 = 1;
        _searchResponse = null;
        if (_currentQuery2.isNotEmpty) {
          setState(() {
            _isLoading2 = true;
            _error2 = null;
          });
          _fetchMultiSearch();
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

  Future<void> _fetchMultiSearch({bool loadMore = false}) async {
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

  void _navigateToDetailPage(MultiSearchResult result) {
    switch (result.mediaType) {
      case MediaType.movie:
        if (result is MultiSearchMovie) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MovieDetailPage(
                movie: Movie(
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
              builder: (context) => TvShowDetailPage(
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

  void _showSearchOverlay() async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          // Listen to changes in the search controller and update overlay state
          _searchController2.removeListener(_onSearchChanged2);
          _searchController2.addListener(() {
            setModalState(() {}); // Rebuild overlay on text change
            _onSearchChanged2();
          });
          return DraggableScrollableSheet(
            initialChildSize: 0.6,
            minChildSize: 0.25,
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
                            _searchController2.clear();
                            setModalState(() {});
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onChanged: (value) async {
                        setModalState(() {});
                        _onSearchChanged2();
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
      return const Center(child: CircularProgressIndicator());
    }

    if (_error2 != null) {
      return Center(child: Text('Error: $_error2'));
    }

    if (_searchResponse == null) {
      return const Center(child: Text('Start typing to search...'));
    }

    if (_searchResponse == null && _searchResponse!.results.isEmpty) {
      return Center(child: Text('No results found for "$_currentQuery2".'));
    }

    final results = _searchResponse!.results;

    return ListView.builder(
      controller: _scrollController2,
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
        return _buildMultiSearchResultCard(context, result);
      },
    );
  }

  Widget _buildMultiSearchResultCard(
      BuildContext context, MultiSearchResult result) {
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
        onTap: () => _navigateToDetailPage(result),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 100,
              height: 150,
              child: Image.network(
                posterUrl,
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => Container(
                    color: Colors.grey[700],
                    child: Center(
                        child: Icon(result.mediaType == MediaType.movie
                            ? Icons.movie_outlined
                            : result.mediaType == MediaType.tv
                                ? Icons.tv_outlined
                                : Icons.person_outline))),
              ),
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

  Widget _buildBody0(BuildContext context, MovieProvider movieProvider) {
    final userData = Provider.of<UserDataService>(context);

    final gridSize = userData.gridSize.toInt();

    if (movieProvider.isIdeling || movieProvider.isLooaded) {
      return MasonryGridView.count(
          padding: const EdgeInsets.all(5.0),
          crossAxisCount: 1 * gridSize, // Adjust number of
          mainAxisSpacing: 0.5,
          controller: ScrollController(keepScrollOffset: true),
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          crossAxisSpacing: 0.5,
          cacheExtent: 100,
          // Start of Selection
          itemCount: movieProvider.movies.length,
          itemBuilder: (context, index) {
            final movie = movieProvider.movies[index];
            return MovieCard(movie: movie);
          });
    } else if (movieProvider.isLoading) {
      return const Center(
          child: CircularProgressIndicator(color: AppColors2.accentColor));
    }
    return Center(
        // child: Padding(
        //     padding: const EdgeInsets.all(1.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Icon(Icons.error_outline, color: Colors.red, size: 50),
      const SizedBox(height: 10),
      Text(
        'Error loading movies: ${movieProvider.errorMessage}',
        textAlign: TextAlign.center,
        style: const TextStyle(color: AppColors2.error),
      ),
      const SizedBox(height: 16),
    ]));
  }
}

class MovieDetailsScreen extends StatelessWidget {
  final int movieId;

  const MovieDetailsScreen({required this.movieId, super.key});

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
                titlePadding: const EdgeInsets.only(
                    left: 60, bottom: 16), // Adjust padding
                background: backdropUrl!=null
                    ? Stack(fit: StackFit.expand, children: [
                          CachedNetworkImage(
                            imageUrl: backdropUrl,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                Container(color: AppColors.secondaryBackground),
                            errorWidget: (context, url, error) => Container(
                                color: const Color.fromARGB(255, 33, 33, 33),
                                child: posterUrl!=null? CachedNetworkImage(
                                            imageUrl: posterUrl,
                                            fit: BoxFit
                                                .contain) // Fallback to poster
                                        :
                                        const Icon(Icons.movie_outlined,
                                            size: 100,
                                            color: AppColors.secondaryText)),
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
                                    AppColors.primaryBackground
                                        .withOpacity(0.9),
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
                                    color:
                                        isFavorite ? Colors.red : Colors.white,
                                    size: 20,
                                  ),
                                  onPressed: () async {
                                    await userDataService
                                        .toggleFavoriteMovie(movieId);
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
                                    backgroundColor:
                                        Colors.black.withOpacity(0.5),
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
                                // Watchlist - Movies don't typically have a watchlist concept like TV series episodes
                                // but we can add a bookmark icon if desired for general tracking.
                                // For now, let's omit the watchlist icon for movies unless specifically needed.
                                // If you want it, uncomment and adapt the logic from AnimeDetailsScreen.
                                IconButton(
                                  icon: Icon(
                                    isInWatchlist
                                        ? Icons.bookmark
                                        : Icons.bookmark_border,
                                    color: isInWatchlist
                                        ? Colors.green
                                        : Colors.white,
                                    size: 20,
                                  ),
                                  onPressed: () async {
                                    await userDataService
                                        .toggleWatchlistMovie(movieId);
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
                                    backgroundColor:
                                        Colors.black.withOpacity(0.5),
                                    padding: const EdgeInsets.all(4.0),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ]) :
                        Container(
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
                  ))),

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
                    if (posterUrl != null)
                      SizedBox(
                          width: 100,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedNetworkImage(
                                  imageUrl: posterUrl, fit: BoxFit.cover)))
                    else
                      Container(
                          width: 100,
                          height: 150,
                          color: AppColors.secondaryBackground),

                    const SizedBox(width: 16),

                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Text(
                            movie.title,
                            style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryText),
                          ),
                          if (movie.tagline != null &&
                              movie.tagline!.isNotEmpty) ...[
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
                          ),
                        ]))
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
                            : () => _showDownloadLinkSelection(
                                context, downloadLinks),
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.download_outlined),
                        label: const Text('Download'),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors
                                .secondaryBackground, // Different style
                            foregroundColor: AppColors.primaryText,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 12)),
                        onPressed: () async {
                          _realDownloadinglink(context, downloadLinks);

                          // openStore: false

                          // TODO: Implement actual download logic
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Download not implemented yet.'),
                                  duration: Duration(seconds: 2)));
                        },
                      ),
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
                // Navigate to the Video Player Screen
                // final encodedUrl = Uri.encodeComponent(link);
                userDataService.toggleIsWatchedLink(
                    movieId, movieId, movieId, links.toString());
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

  void _realDownloadinglink(BuildContext context, List<String> links) {
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
              qualityGuess = "1080p";
            } else if (link.contains('720p'))
              qualityGuess = "720p";
            else if (link.contains('480p'))
              qualityGuess = "480p";
            else if (link.contains('BluRay'))
              qualityGuess += " BluRay";
            else if (link.contains('HEVC') || link.contains('x265'))
              qualityGuess += " HEVC";
            else if (link.contains('x264')) qualityGuess += " x264";

            return SimpleDialogOption(
              onPressed: () {
                Navigator.pop(dialogContext); // Close the dialog
                // Navigate to the Video Player Screen
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
