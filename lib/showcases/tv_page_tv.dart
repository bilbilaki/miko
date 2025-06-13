import 'dart:async';

import 'package:flutter/material.dart';
import 'package:miko/services/user_data_service.dart';
import 'package:miko/showcases/movie_detail_page.dart';
import 'package:miko/showcases/person_detail_page.dart';
import 'package:miko/showcases/tv_detail_page_tv.dart';
import 'package:provider/provider.dart';
import 'model.dart';
import 'movie_service.dart';
import '../providers/tv_series_provider.dart';

class TvShowPageTV extends StatefulWidget {
  const TvShowPageTV({super.key});

  @override
  State<TvShowPageTV> createState() => _TvShowPageState();
}

class _TvShowPageState extends State<TvShowPageTV> {
  final MovieService _movieService = MovieService();
  final TmdbApiService _tmdbService = TmdbApiService();

  final List<TvShow> _tvShows = [];
  int _currentPage = 1;
  int _totalPages = 1;
  bool _isLoading = false;
  bool _hasError = false;
  int _currentPage2 = 1;
  int _totalPages2 = 1;
  bool _isLoading2 = false;
  bool _hasError2 = false;
  String _errorMessage = '';
  String _errorMessage2 = '';
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController2 = ScrollController();
  final TextEditingController _searchController2 = TextEditingController();

  Timer? _debounce;

  MultiSearchResponse? _searchResponse;
  String? _error;
  String? _error2;

  final String _currentQuery = '';
  String _currentQuery2 = '';

  final bool _isFetchingMore = false;
  bool _isFetchingMore2 = false;

  @override
  void initState() {
    super.initState();
    _loadTvShows();
    _scrollController.addListener(_scrollListener);
    _scrollController2.addListener(_scrollListener2);
    _searchController.addListener(_onSearchChanged);
    _searchController2.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _movieService.dispose();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      if (!_isLoading && _currentPage < _totalPages) {
        _loadMoreTvShows();
      }
    }
  }

  void _scrollListener2() {
    if (_scrollController2.position.pixels >=
        _scrollController2.position.maxScrollExtent * 0.8) {
      if (!_isLoading2 && _currentPage2 < _totalPages2) {
        _loadMoreTvShows2();
      }
    }
  }

  Future<void> _loadTvShows() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final response = await _tmdbService.discoverTvShows(page: _currentPage);

      setState(() {
        _tvShows.addAll(response.results);
        _totalPages = response.totalPages;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _loadTvShows2() async {
    if (_isLoading2) return;

    setState(() {
      _isLoading2 = true;
      _hasError2 = false;
    });

    try {
      final response = await _tmdbService.discoverTvShows(page: _currentPage2);

      setState(() {
        _tvShows.addAll(response.results);
        _totalPages2 = response.totalPages;
        _isLoading2 = false;
      });
    } catch (e) {
      setState(() {
        _hasError2 = true;
        _errorMessage2 = e.toString();
        _isLoading2 = false;
      });
    }
  }

  Future<void> _loadMoreTvShows2() async {
    _currentPage2++;
    await _loadTvShows2();
  }

  Future<void> _loadMoreTvShows() async {
    _currentPage++;
    await _loadTvShows();
  }

  Future<void> _refreshTvShows() async {
    setState(() {
      _tvShows.clear();
      _currentPage = 1;
    });
    await _loadTvShows();
  }

  Future<void> _navigateToTvShowDetail(TvShow tvShow) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TvShowDetailPageTV(tvShow: tvShow),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular TV Shows'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshTvShows,
          ),
        ],
      ),
      body: Stack(
        children: [
          // Existing body content
          _hasError
              ? _buildErrorWidget()
              : RefreshIndicator(
                  onRefresh: _refreshTvShows,
                  child: _buildTvShowGrid(),
                ),

          // Search Overlay
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
      ),
    );
  }

  void _showSearchOverlay() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          // Listen to changes in the search controller and update overlay state
          _searchController2.removeListener(_onSearchChanged);
          _searchController2.addListener(() {
            setModalState(() {}); // Rebuild overlay on text change
            _onSearchChanged();
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
                          onPressed: () {
                            _searchController2.clear();
                            setModalState(() {});
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onChanged: (value) {
                        setModalState(() {});
                        _onSearchChanged();
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

    if (_error != null) {
      return Center(child: Text('Error: $_error'));
    }

    if (_searchResponse == null) {
      return const Center(child: Text('Start typing to search...'));
    }

    if (_searchResponse == null || _searchResponse!.results.isEmpty) {
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

  // List<TvShow> _searchResults = [];

  // Future<void> _performSearch(String query) async {
  //   if (query.isEmpty) {
  //     setState(() {
  //       _searchResults = [];
  //     });
  //     return;
  //   }

  //   try {
  //     final response = await _tmdbService.searchTvShows(query: query);
  //     setState(() {
  //       _searchResults = response.results;
  //     });
  //   } catch (e) {
  //     // Handle error
  //     debugPrint('Search error: $e');
  //   }
  // }

  void _onSearchChanged() async {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 200), () {
      if (_searchController2.text != _currentQuery2) {
        _currentQuery2 = _searchController2.text;
        _currentPage2 = 1;
        _searchResponse = null;
        if (_currentQuery2.isNotEmpty) {
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

  Future<void> _fetchMultiSearch({bool loadMore2 = false}) async {
    if (_currentQuery2.isEmpty || _isFetchingMore2) return;

    setState(() {
      if (loadMore2) {
        _isFetchingMore2 = true;
      } else {
        _isLoading2 = true;
      }
      _error = null;
    });

    try {
      final response = await _movieService.multiSearch(
        query: _currentQuery2,
        page: _currentPage2,
      );

      if (mounted) {
        setState(() {
          if (loadMore2) {
            _searchResponse?.results.addAll(response.results);
            _searchResponse = MultiSearchResponse(
              page: response.page,
              results: _searchResponse?.results ?? response.results,
              totalPages: response.totalPages,
              totalResults: response.totalResults,
            );
          } else {
            _searchResponse = response;
          }

          if (loadMore2) {
            _isFetchingMore2 = false;
          } else {
            _isLoading2 = false;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          if (loadMore2) {
            _isFetchingMore2 = false;
          } else {
            _isLoading2 = false;
          }
        });
      }
    }
  }

  // void _onScroll() {
  //   if (_scrollController.position.pixels >=
  //           _scrollController.position.maxScrollExtent - 200 &&
  //       !_isFetchingMore &&
  //       _searchResponse != null &&
  //       _currentPage < _searchResponse!.totalPages) {
  //     _currentPage++;
  //     _fetchMultiSearch(loadMore: true);
  //   }
  // }

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
              builder: (context) => TvShowDetailPageTV(
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

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 60, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            'Error loading TV shows',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            _errorMessage,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _refreshTvShows,
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildTvShowGrid() {
    late TvSeriesProvider seriesProvider = TvSeriesProvider();
    final status = seriesProvider.status;
    final userData = Provider.of<UserDataService>(context);
    final seriesList = seriesProvider.seriesForDisplay;

    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
      ),
      itemCount:
          seriesList.length + (_isLoading && seriesList.isNotEmpty ? 2 : 0),
      itemBuilder: (context, index) {
        if (index >= _tvShows.length) {
          return const Center(child: CircularProgressIndicator());
        }
        final tvShow = _tvShows[index];

        Future<TvShow> tvToTv(TvShow tvShow) async {
          tvShow = await _movieService.getTvShowDetails(
              tvShowId: seriesList[index].tmdbId);
          return tvShow;
        }

        return FutureBuilder<TvShow>(
          future: tvToTv(tvShow),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: \\${snapshot.error}'));
            } else if (snapshot.hasData) {
              return _buildTvShowCard(snapshot.data!);
            } else {
              return const SizedBox.shrink();
            }
          },
        );
      },
    );
  }

  Widget _buildTvShowCard(TvShow tvShow) {
    return Hero(
      tag: 'tvshow-${tvShow.id}',
      child: GestureDetector(
        onTap: () => _navigateToTvShowDetail(tvShow),
        child: Card(
          elevation: 20,
          shadowColor: Colors.black54,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(12)),
                      child: Image.network(
                        tvShow.fullPosterPath,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[800],
                            child: const Center(
                              child: Icon(Icons.broken_image, size: 50),
                            ),
                          );
                        },
                      ),
                    ),
                    // Add a gradient overlay at the bottom for better text visibility
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.8),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Add year indicator
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          tvShow.year,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    // Add country indicator
                    if (tvShow.originCountry == tvShow.originCountry)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            tvShow.originCountry.first,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    // Add rating at the bottom
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getRatingColor(tvShow.voteAverage),
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star,
                                color: Colors.white, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              tvShow.formattedRating,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Add genre at the bottom left
                    if (tvShow.genreIds == tvShow.genreNames)
                      Positioned(
                        bottom: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getGenreColor(tvShow.genreIds.first),
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            _getTvGenreName(tvShow.genreIds.first),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tvShow.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (tvShow.firstAirDate != null)
                      Text(
                        'First aired: ${tvShow.firstAirDate}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[400],
                        ),
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

  Color _getRatingColor(double rating) {
    if (rating >= 8.0) {
      return Colors.green;
    } else if (rating >= 6.0) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  Color _getGenreColor(int genreId) {
    final Map<int, Color> genreColors = {
      10759: Colors.orange, // Action & Adventure
      16: Colors.blue, // Animation
      35: Colors.pink, // Comedy
      80: Colors.red, // Crime
      99: Colors.teal, // Documentary
      18: Colors.purple, // Drama
      10751: Colors.green, // Family
      10762: Colors.amber, // Kids
      9648: Colors.indigo, // Mystery
      10763: Colors.blue, // News
      10764: Colors.cyan, // Reality
      10765: Colors.deepPurple, // Sci-Fi & Fantasy
      10766: Colors.pink, // Soap
      10767: Colors.brown, // Talk
      10768: Colors.blueGrey, // War & Politics
      37: Colors.amber, // Western
    };

    return genreColors[genreId] ?? Colors.grey;
  }

  // Helper method to get TV genre name from ID
  String _getTvGenreName(int genreId) {
    final Map<int, String> genres = {
      10759: 'Action & Adventure',
      16: 'Animation',
      35: 'Comedy',
      80: 'Crime',
      99: 'Documentary',
      18: 'Drama',
      10751: 'Family',
      10762: 'Kids',
      9648: 'Mystery',
      10763: 'News',
      10764: 'Reality',
      10765: 'Sci-Fi & Fantasy',
      10766: 'Soap',
      10767: 'Talk',
      10768: 'War & Politics',
      37: 'Western',
    };

    return genres[genreId] ?? 'Unknown';
  }
}
