// lib/screens/tv_series_grid_screen.dart
import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:miko/models/tv_series_anime.dart';
import 'package:miko/models/tv_series_anime.dart' as ss;
import 'package:miko/services/user_data_service.dart';
import 'package:miko/showcases/model.dart';
import 'package:miko/showcases/movie_detail_page_copy.dart';
import 'package:miko/showcases/movie_service.dart' show MovieService;
import 'package:miko/showcases/person_detail_page.dart';
import 'package:miko/showcases/tv_detail_page.dart';
//import 'package:miko/showcases/tv_detail_page_anime.dart';
import 'package:miko/widgets/anime_series_card.dart';
import 'package:provider/provider.dart';
import 'package:miko/providers/anime_provider.dart'; // Ensure correct provider import
import 'package:miko/utils/colors.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

//import 'package:myapp/utils/dynamic_background.dart'; // Keep if using
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

class AnimeGridScreen extends StatefulWidget {
  const AnimeGridScreen({super.key});

  @override
  State<AnimeGridScreen> createState() => _AnimeGridScreenState();
}

class _AnimeGridScreenState extends State<AnimeGridScreen> {
  SortMode _sortMode = SortMode.name;
  bool _sortAscending = true;
 late double? gridCrossAxisCount = 3.0; // Default grid size
  ViewMode _viewMode = ViewMode.grid;

  // List<_GridItem> _getSortedItems(AnimeProvider provider) {
  //   final items = [
  //     ...provider.animeseriesForDisplay.map((f) => _GridItem(f)),
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
  //         comparison = b.entity.statSync().modified.compareTo(a.entity.statSync().modified);
  //         break;
  //       case SortMode.type:
  //       default:
  //         // Sort folders first, then files by type, then by name
  //         if (a.isFolder && !b.isFolder) {
  //           comparison = -1; // 'a' (folder) comes before 'b' (file)
  //         } else if (!a.isFolder && b.isFolder) {
  //           comparison = 1; // 'a' (file) comes after 'b' (folder)
  //         } else {
  //           // Both are files or both are folders; sort by file extension then by name
  //           String typeA = a.isFolder ? 'folder' : p.extension(a.entity.path).toLowerCase();
  //           String typeB = b.isFolder ? 'folder' : p.extension(b.entity.path).toLowerCase();
  //           comparison = typeA.compareTo(typeB);
  //           if (comparison == 0) {
  //             comparison = a.name.toLowerCase().compareTo(b.name.toLowerCase());
  //           }
  //         }
  //         break;
  //     }
  //     return _sortAscending ? comparison : -comparison; // Apply ascending/descending order
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
                  Text("Columns: ${gridCrossAxisCount!.toInt()}"),
                  Slider(
                    value: gridCrossAxisCount!.toDouble(),
                    min: 2, // Minimum 2 columns (for larger items)
                    max: 8, // Maximum 8 columns (for smaller items)
                    divisions: 6, // 8 - 2 = 6 steps for integer values
                    label: gridCrossAxisCount!.toInt().toString(),
                    onChanged: (newValue) {
                      // Update both the dialog's state and the main screen's state
                      setDialogState(() {
                        setState(() {
                          gridCrossAxisCount = newValue;
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
      },
    );
  }

// Supporting enums and classes

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Scaffold(
            appBar: AppBar(
              title: Text("Esil Movie"),
              // Show back button if not at the root of the external path
              actions: [
                // --- View Mode Toggle ---
                IconButton(
                  icon: Icon(_viewMode == ViewMode.grid
                      ? Icons.view_list
                      : Icons.grid_view),
                  tooltip: "Toggle View",
                  onPressed: () => setState(() => _viewMode =
                      _viewMode == ViewMode.grid
                          ? ViewMode.list
                          : ViewMode.grid),
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
                        value: SortMode.type, child: Text("Sort by Type")),
                    PopupMenuItem(
                        value: SortMode.name, child: Text("Sort by Name")),
                    PopupMenuItem(
                        value: SortMode.date, child: Text("Sort by Date")),
                  ],
                ),
                // --- Change Root Folder Button ---
              ],
            ),
            body: Stack(
              children: [
                Consumer<AnimeProvider>(
                    builder: (context, seriesProvider, child) {
                  // Optional: Keep DynamicBackground if desired
                  return _buildBody0(context, seriesProvider);
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
              builder: (context) => MovieDetailPage1(
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
            initialChildSize: 0.9,
            minChildSize: 0.5,
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
}

Widget _buildBody0(BuildContext context, AnimeProvider seriesProvider) {
  final status = seriesProvider.status;
  final userData = Provider.of<UserDataService>(context);

  final gridSize = userData.gridSize.toInt();
  if (status == LoadingStatus.loading) {
    // Show loading indicator initially or while loading
    return const Center(
        child: CircularProgressIndicator(color: AppColors2.accentColor));
  }

  // if (seriesProvider.hasError) {
  //   return Center(
  //       child: Padding(
  //     padding: const EdgeInsets.all(20.0),
  //     child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
  //       const Icon(Icons.error_outline, color: AppColors2.error, size: 50),
  //       const SizedBox(height: 10),
  //       Text(
  //         'Error loading TV Series: ${seriesProvider.errorMessage ?? 'Unknown error'}',
  //         textAlign: TextAlign.center,
  //         style: const TextStyle(color: AppColors2.error2),
  //       ),
  //       const SizedBox(height: 20),
  //       ElevatedButton(
  //         // Reload all data on retry
  //         onPressed: () => seriesProvider.loadAnimeData(),
  //         style:
  //             ElevatedButton.styleFrom(backgroundColor: AppColors2.extracolor9),
  //         child:
  //             const Text('Retry', style: TextStyle(color: AppColors2.error2)),
  //       )
  //     ]),
  //   ));
  // }

  // Get the list to display (handles search results automatically)
  final seriesList = seriesProvider.animeseriesForDisplay;
  return MasonryGridView.count(
    padding: const EdgeInsets.all(5.0),
    crossAxisCount: 1*gridSize, // Adjust number of
    mainAxisSpacing: 1.5,
    controller: ScrollController(keepScrollOffset: true),
    shrinkWrap: true,
    physics: const BouncingScrollPhysics(),
    crossAxisSpacing: 1.5,
    cacheExtent: 100,
    itemCount: seriesList.length,
    itemBuilder: (context, index) {
      final series = seriesList[index];
      return AnimeSeriesCard(series: series);
    },
  );
}

class AnimeDetailsScreen extends StatelessWidget {
  final int tvSeriesId; // Use TMDB ID to fetch from map

  AnimeDetailsScreen({required this.tvSeriesId, super.key});
  final ScrollController _seasonsScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    // Fetch the specific series using the ID directly from the provider's map/list
    // No 'listen: false' needed if the UI should rebuild if the underlying data changes (unlikely here)
    final series =
        Provider.of<AnimeProvider>(context).getAnimeByTmdbId(tvSeriesId);
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
            expandedHeight: 250.0,
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
              backdropUrl!=null? CachedNetworkImage(
                            imageUrl: backdropUrl,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                Container(color: AppColors.secondaryBackground),
                            errorWidget: (context, url, error) => Container(
                                color: AppColors.secondaryBackground,
                                child: const Icon(Icons.broken_image,
                                    color: AppColors.secondaryText, size: 60)),
                          ) :
                          Container(
                            // Fallback color if no backdrop
                            color: AppColors.secondaryBackground,
                            child: posterUrl !=
                                    null // Try poster as fallback background
                                ? CachedNetworkImage(
                                    imageUrl: posterUrl,
                                    fit: BoxFit.contain,
                                    alignment: Alignment.center)
                                : const Center(
                                    child: Icon(Icons.tv,
                                        size: 100,
                                        color: AppColors.secondaryText)),
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
                          child: posterUrl!=null? CachedNetworkImage(
                                    imageUrl: posterUrl,
                                    fit: BoxFit.cover,
                                    height: 165,
                                    placeholder: (_, __) => Container(
                                      height: 165,
                                      width: 110,
                                      color: AppColors.secondaryBackground,
                                    ),
                                    errorWidget: (_, __, ___) => const SizedBox(
                                      height: 165,
                                      width: 110,
                                      child: Icon(Icons.error),
                                    ),
                                  ) :
                                  Container(
                                    height: 165,
                                    width: 110,
                                    decoration: BoxDecoration(
                                      color: AppColors.secondaryBackground,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.tv,
                                      size: 50,
                                      color: AppColors.secondaryText,
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
                            Text(
                              series.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    color: AppColors.primaryText,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            if (series.originalName.isNotEmpty &&
                                series.originalName.toLowerCase() !=
                                    series.name.toLowerCase())
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
                    child: _buildSeasonsList(
                        context, series.seasons, series.tmdbId, series.name),
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
            color: AppColors.secondaryText,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  // Widget _buildSeasonsList(BuildContext context, List<Season> seasons, id) {
  //   final defaultExpansion = seasons.length == 1;
  //   return ListView.builder(
  //     shrinkWrap: true,
  //     physics: const NeverScrollableScrollPhysics(),
  //     itemCount: seasons.length,
  //     itemBuilder: (ctx, i) {
  //       final s = seasons[i];
  //       return Card(
  //         elevation: 1,
  //         margin: const EdgeInsets.symmetric(vertical: 6.0),
  //         color: AppColors.secondaryBackground.withOpacity(0.4),
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(8),
  //         ),
  //         clipBehavior: Clip.antiAlias,
  //         child: ExpansionTile(
  //           key: PageStorageKey('season_${s.seasonNumber}'),
  //           title: Text(
  //             'Season ${s.seasonNumber}',
  //             style: const TextStyle(
  //               color: AppColors.primaryText,
  //               fontWeight: FontWeight.w600,
  //               fontSize: 16,
  //             ),
  //           ),
  //           subtitle: Text(
  //             '${s.episodes.length} Episode${s.episodes.length == 1 ? '' : 's'}',
  //             style: const TextStyle(
  //               color: AppColors.secondaryText,
  //               fontSize: 12,
  //             ),
  //           ),
  //           iconColor: AppColors.accentColor,
  //           collapsedIconColor: AppColors.secondaryText,
  //           initiallyExpanded: defaultExpansion || s.seasonNumber == 1,
  //           childrenPadding:
  //               const EdgeInsets.only(bottom: 8, left: 4, right: 4),
  //           children: ListTile.divideTiles(
  //             context: ctx,
  //             color: AppColors.dividerColor.withOpacity(0.3),
  //             tiles:
  //                 s.episodes.map((e) => AnimeEpisodeTile(episode: e, season: s,id: id,)).toList(),
  //           ).toList(),
  //         ),
  //       );
  //     },
  //   );
  // }
  Widget _buildSeasonsList(BuildContext context, List<ss.Season> seasons,
      int TvseriesId, String name) {
    bool defaultExpansion = seasons.length == 1;
    return SizedBox(
        height: 500, // Adjust as needed
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
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
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
                    bottom: 8.0,
                    left: 4,
                    right: 4), // Padding for episode tiles
                // Remove default dividers and use padding/margin on EpisodeTile instead
                // children: season.episodes.map((episode) => EpisodeTile(episode: episode)).toList(),

                children: ListTile.divideTiles(
                  // Add subtle dividers between episodes
                  context: context,
                  color: AppColors.dividerColor.withOpacity(0.3),
                  tiles: season.episodes
                      .map((episode) => EpisodeTileNew(
                            seriesname: name,
                            episode: episode,
                            season: season,
                            id: TvseriesId,
                          ))
                      .toList(),
                ).toList(),
              ),
            );
          },
        ));
  }
}
