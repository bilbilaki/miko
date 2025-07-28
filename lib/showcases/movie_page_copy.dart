import 'dart:async';
import 'package:flutter/material.dart';
import 'package:miko/providers/god_proovider.dart' as mm;
import 'package:miko/showcases/movie_detail_page_copy.dart';
import 'package:miko/showcases/tv_detail_page_anime.dart';
//import '../widgets/search_overlay.dart';
import 'model.dart' as mmmm;
import 'movie_service.dart';
import 'person_detail_page.dart';

class MoviePage1 extends StatefulWidget {
  const MoviePage1({super.key});

  @override
  State<MoviePage1> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage1> {
  final MovieService _movieService = MovieService();
  final TmdbApiService _tmdbService = TmdbApiService();

  final List<mmmm.Movie> _movies = [];
  int _currentPage = 1;
  int _totalPages = 1;
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';
  int _currentPage2 = 1;
  int _totalPages2 = 1;
  bool _isLoading2 = false;
  final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollController2 = ScrollController();

  // Search fields
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _searchController2 = TextEditingController();

  final ScrollController _searchScrollController = ScrollController();
  final ScrollController _searchScrollController2 = ScrollController();

  Timer? _debounce;
  mmmm.MultiSearchResponse? _searchResponse;
  bool _isFetchingMore2 = false;
  String? _error2;
  String _currentQuery2 = '';
  int _searchPage2 = 1;
  int _searchTotalPages2 = 1;
  @override
  void initState() {
    super.initState();
    _loadMovies();
    _scrollController.addListener(_scrollListener);
    _searchScrollController.addListener(_searchScrollListener);
    _searchController.addListener(_onSearchChanged);

    _searchScrollController2.addListener(_scrollListener2);
    _searchController2.addListener(_onSearchChanged2);
    _scrollController2.addListener(_scrollListener2);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchScrollController.dispose();
    _movieService.dispose();
    _searchController.removeListener(_onSearchChanged);
    _searchController2.removeListener(_onSearchChanged2);
    _searchController2.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      if (!_isLoading && _currentPage < _totalPages) {
        _loadMoreMovies();
      }
    }
  }

  void _scrollListener2() {
    if (_scrollController2.position.pixels >=
        _scrollController2.position.maxScrollExtent * 0.8) {
      if (!_isLoading2 && _currentPage2 < _totalPages2) {
        _loadMoreMovies2();
      }
    }
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

  Future<void> _loadMovies() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    try {
      final response = await _tmdbService.discoverMovies(page: _currentPage);
      setState(() {
        _movies.addAll(response.results);
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

  Future<void> _loadMovies2() async {
    if (_isLoading2) return;
    setState(() {
      _isLoading2 = true;
    });
    try {
      final response = await _tmdbService.discoverMovies(page: _currentPage2);
      setState(() {
        _movies.addAll(response.results);
        _totalPages2 = response.totalPages;
        _isLoading2 = false;
      });
    } catch (e) {
      setState(() {
        _isLoading2 = false;
      });
    }
  }

  Future<void> _loadMoreMovies() async {
    _currentPage++;
    await _loadMovies();
  }

  Future<void> _refreshMovies() async {
    setState(() {
      _movies.clear();
      _currentPage = 1;
    });
    await _loadMovies();
  }

  Future<void> _loadMoreMovies2() async {
    _currentPage2++;
    await _loadMovies2();
  }

  Future<void> _navigateToMovieDetail(mmmm.Movie movie) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieDetailPage(id: movie.id),
      ),
    );
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 2), () {
      final query2 = _searchController2.text;
      if (query2 != _currentQuery2) {
        _currentQuery2 = query2;
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
            _searchResponse = mmmm.MultiSearchResponse(
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

  void _navigateToDetailPage(mmmm.MultiSearchResult result) {
    switch (result.mediaType) {
      case mmmm.MediaType.movie:
        if (result is mmmm.MultiSearchMovie) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MovieDetailPage(
              //  movie: mmmm.Movie(
                  id: result.id,
                  // title: result.name,
                  // originalTitle: result.originalName,
                  // posterPath: result.posterPath,
                  // backdropPath: result.backdropPath,
                  // adult: result.adult,
                  // genreIds: result.genreIds,
                  // originalLanguage: result.originalLanguage.toString(),
                  // overview: result.overview.toString(),
                  // popularity: result.popularity,
                  // voteAverage: result.voteAverage,
                  // voteCount: result.voteCount,
                  // releaseDate: result.releaseDate.toString(),
                  // video: result.video,
                  // Add other necessary fields from the multi search result
                ),
              ),
        //    ),
          );
        }
        break;
      case mmmm.MediaType.tv:
        if (result is mmmm.MultiSearchTV) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TvShowDetailPageAnime(
               tvShow: mmmm.TvShow(
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
      case mmmm.MediaType.person:
        if (result is mmmm.MultiSearchPerson) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PersonDetailPage(
                  personId: result.id,
              )
            ),
          );
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular Movies'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshMovies,
          ),
        ],
      ),
      body: Stack(
        children: [
          _hasError
              ? _buildErrorWidget()
              : RefreshIndicator(
                  onRefresh: _refreshMovies,
                  child: _buildMovieGrid(),
                ),
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

    if (_error2 != null) {
      return Center(child: Text('Error: $_error2'));
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
      BuildContext context, mmmm.MultiSearchResult result) {
    String? imagePath;
    String title = '';
    String subtitle = '';

    switch (result.mediaType) {
      case mmmm.MediaType.movie:
        final movie = result as mmmm.MultiSearchMovie;
        imagePath = movie.posterPath;
        title = movie.title;
        subtitle = 'Movie • ${movie.releaseDate}';
        break;
      case mmmm.MediaType.tv:
        final tv = result as mmmm.MultiSearchTV;
        imagePath = tv.posterPath;
        title = tv.name;
        subtitle = 'TV Show • ${tv.firstAirDate}';
        break;
      case mmmm.MediaType.person:
        final person = result as mmmm.MultiSearchPerson;
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
                        child: Icon(result.mediaType == mmmm.MediaType.movie
                            ? Icons.movie_outlined
                            : result.mediaType == mmmm.MediaType.tv
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
                      result.mediaType == mmmm.MediaType.movie
                          ? (result as mmmm.MultiSearchMovie).overview ?? ''
                          : result.mediaType == mmmm.MediaType.tv
                              ? (result as mmmm.MultiSearchTV).overview ?? ''
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

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 60, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            'Error loading movies',
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
            onPressed: _refreshMovies,
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieGrid() {
    mm.MovieProvider movieProvider = mm.MovieProvider();
    final listmovies = movieProvider.filteredAndSortedContent;
    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount:
          listmovies.length + (_isLoading && listmovies.isNotEmpty ? 2 : 0),
      itemBuilder: (context, index) {
        if (index >= listmovies.length) {
          return const Center(child: CircularProgressIndicator());
        }

        final movie = listmovies[index];

        Future<mmmm.Movie> movieToMovie(movie) async {
          movie = await _movieService.getMovieDetails(
              movieId: listmovies[index].id);
          return movie;
        }

        final mmovie = movieToMovie(movie);
        // return _buildMovieCard(mmovie);
        return FutureBuilder<mmmm.Movie>(
          future: movieToMovie(mmovie),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: \\${snapshot.error}'));
            } else if (snapshot.hasData) {
              return _buildMovieCard(snapshot.data!);
            } else {
              return const SizedBox.shrink();
            }
          },
        );
      },
    );
  }

  Widget _buildMovieCard(movie) {
    return Hero(
      tag: 'movie-${movie.id}',
      child: GestureDetector(
        onTap: () => _navigateToMovieDetail(movie),
        child: Card(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                        movie.fullPosterPath,
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
                    // gradient overlay
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // release year
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
                          movie.releaseDate.isNotEmpty
                              ? movie.releaseDate.substring(0, 4)
                              : 'TBA',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    if (movie.adult)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            '18+',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.star,
                                color: Colors.amber, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              movie.voteAverage.toStringAsFixed(1),
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        if (movie.genreIds.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(4)),
                            child: Text(
                              _getGenreName(movie.genreIds.first),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 10),
                            ),
                          ),
                      ],
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

  // Helper method to get genre name from ID
  String _getGenreName(int genreId) {
    final Map<int, String> genres = {
      28: 'Action',
      12: 'Adventure',
      16: 'Animation',
      35: 'Comedy',
      80: 'Crime',
      99: 'Documentary',
      18: 'Drama',
      10751: 'Family',
      14: 'Fantasy',
      36: 'History',
      27: 'Horror',
      10402: 'Music',
      9648: 'Mystery',
      10749: 'Romance',
      878: 'Sci-Fi',
      10770: 'TV Movie',
      53: 'Thriller',
      10752: 'War',
      37: 'Western',
    };
    return genres[genreId] ?? 'Unknown';
  }
}
