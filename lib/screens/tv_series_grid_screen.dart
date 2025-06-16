// lib/screens/tv_series_grid_screen.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:miko/models/tv_series.dart' as ot;
//import 'package:miko/models/tv_series.dart';
import 'package:miko/services/user_data_service.dart';
import 'package:miko/showcases/model.dart';
import 'package:miko/showcases/movie_detail_page_copy.dart';
import 'package:miko/showcases/movie_service.dart';
import 'package:miko/showcases/person_detail_page.dart';
import 'package:miko/showcases/tv_detail_page.dart';
import 'package:provider/provider.dart';
import 'package:miko/providers/tv_series_provider.dart'; // Ensure correct provider import
import 'package:miko/utils/colors.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:miko/widgets/tv_series_card.dart';
//import 'package:myapp/utils/dynamic_background.dart'; // Keep if using

// Simplified StateLESS Widget as lazy loading is removed
class TvSeriesGridScreen extends StatefulWidget {
   const TvSeriesGridScreen({super.key});

  @override
  State<TvSeriesGridScreen> createState() => _TvSeriesGridScreenState();
}

class _TvSeriesGridScreenState extends State<TvSeriesGridScreen> {
  @override
  Widget build(BuildContext context) {
   return Stack(
      children: [ Consumer<TvSeriesProvider>(
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
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
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
                    'Search TV Shows',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
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
  Widget _buildBody0(BuildContext context, TvSeriesProvider seriesProvider) {
    final userData = Provider.of<UserDataService>(context);

    final gridSize = userData.gridSize.toInt();
    if (seriesProvider.status == ot.LoadingStatus.loading) {
      // Show loading indicator initially or while loading
      return const Center(
          child: CircularProgressIndicator(color: AppColors2.accentColor));
    }

   else if (seriesProvider.status== ot.LoadingStatus.error) {
      return Center(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.error_outline, color: AppColors2.error, size: 50),
          const SizedBox(height: 10),
          Text(
            'Error loading TV Series: ${seriesProvider.errorMessage ?? 'Unknown error'}',
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors2.error),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            // Reload all data on retry
            onPressed: () => seriesProvider.loadTvSeriesData(),
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors2.accentColor),
            child: const Text('Retry',
                style: TextStyle(color: AppColors2.error2)),
          )
        ]),
      ));
    }

    // Get the list to display (handles search results automatically)


    return MasonryGridView.count(
       padding: const EdgeInsets.all(5.0),
      crossAxisCount: 1*gridSize, // Adjust number of 
      mainAxisSpacing: 1.5,
      controller: ScrollController(keepScrollOffset: true),
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      crossAxisSpacing: 1.5,
      cacheExtent: 100,
      itemCount: seriesProvider.seriesForDisplay.length, // Directly use the list length
      itemBuilder: (context, index) {
        final series = seriesProvider.seriesForDisplay[index];
           return TvSeriesCard(series: series);
      },
    );
  }
