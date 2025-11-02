// lib/screens/tv_series_grid_screen.dart
import 'dart:async';
import 'dart:io'; // Added for Platform.isAndroid

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:miko/providers/god_proovider.dart';
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
import 'package:miko/widgets/movie_card_widget.dart';
import 'package:provider/provider.dart';
// Ensure correct provider import
import 'package:miko/utils/colors.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shimmer/shimmer.dart';

// Added for shimmer effect

// ignore: must_be_immutable
class AnimeGridScreen extends StatefulWidget {
   String typec;

   AnimeGridScreen({super.key, required this.typec});

  @override
  State<AnimeGridScreen> createState() => AnimeGridScreenState();
}

class AnimeGridScreenState extends State<AnimeGridScreen> {
   double? gridCrossAxisCount = 3.0; // Default grid size
ScrollController custroller= ScrollController();
  // Haptic feedback function

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: 
        
        NotificationListener<ScrollNotification>(
          // Listen for scroll events for vibration
          onNotification: (ScrollNotification notification) {
            if (Platform.isAndroid) {
              if (notification is ScrollStartNotification) {
                triggerVibration(); // Vibrate when scroll starts
              }
            }
            return false; // Continue to bubble up the notification
          },
        
            // Added GestureDetector for general touch/drag vibration
            //  onTapDown: (_) => triggerVibration(), // Vibrate on touch/tap down
            //        onPanDown: (_) => triggerVibration(), // Vibrate on pan/drag down
            child: GestureDetector(child: 
            
            Stack(
              children: [
                if (widget.typec == "movie")
                  Consumer<MovieProvider>(
                    builder: (context, movieProvider, child) {
                      return _buildBody0(context, movieProvider, widget.typec,
                          triggerVibration, custroller);
                    },
                  )
                  else if (widget.typec == "anime")
                  Consumer<AnimeProvider>(
                      builder: (context, seriesProvider, child) {
                    // Optional: Keep DynamicBackground if desired
                    return _buildBody0(context, seriesProvider, widget.typec,
                        triggerVibration,custroller);
                  })
                else if (widget.typec == "tvseries")
                  Consumer<TvSeriesProvider>(
                      builder: (context, seriesProvider, child) {
                    // Optional: Keep DynamicBackground if desired
                    return _buildBody0(context, seriesProvider, widget.typec,
                        triggerVibration,custroller);
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
      
     ) );
  }

   mo.MovieService _movieService = mo.MovieService();

  bool _isLoading2 = false;
   ScrollController _scrollController = ScrollController();

  // Search fields
   TextEditingController _searchController2 = TextEditingController();

   ScrollController _searchScrollController2 = ScrollController();

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
    _searchScrollController2.dispose(); // Dispose the correct controller
    _searchController2.removeListener(onSearchChanged2);
    //  _searchController2.dispose();
    _debounce?.cancel();

    _scrollController.dispose();

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
    _debounce = Timer( Duration(milliseconds: 100), () async {
     String query = _searchController2.text.trim();
      if (query != _currentQuery2) {
        _currentQuery2 = query;
        _searchPage2 = 1;
        _searchResponse = null;
        if (_currentQuery2.isNotEmpty) {
          setState(() {
            _isLoading2 = true;
            _error2 = null;
          });
         await fetchMultiSearch();
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
    MultiSearchResponse   response = await _movieService.multiSearch(
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
            //  ),
          );
        }
        break;
      case MediaType.tv:
        if (result is MultiSearchTV) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TvShowDetailPageAnime(
                tvShow: mo.TvShow(
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
                // ),
              ));
        }
        break;
    }
  }

  void showSearchOverlay(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape:  RoundedRectangleBorder(
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
                     BorderRadius.vertical(top: Radius.circular(25)),
              ),
              child: Column(
                children: [
                  // Search Header
                  Padding(
                    padding:  EdgeInsets.all(16.0),
                    child: TextField(
                      controller: _searchController2,
                      decoration: InputDecoration(
                        hintText: 'Search TV Shows...',
                        prefixIcon:  Icon(Icons.search),
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
                              width: double.infinity, height: 12, color: Colors.white),
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
      return  Center(child: Text('Start typing to search...'));
    }

    if (_searchResponse != null && _searchResponse!.results.isEmpty) {
      // Corrected null check
      return Center(child: Text('No results found for "$_currentQuery2".'));
    }

    final results = _searchResponse!.results;

    return ListView.builder(
      controller: _searchScrollController2, // Use the correct controller here
      padding:  EdgeInsets.all(8.0),
      itemCount: results.length + (_isFetchingMore2 ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == results.length && _isFetchingMore2) {
          return  Center(
              child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator()));
        }

        MultiSearchResult result = results[index];
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
        MultiSearchMovie movie = result as MultiSearchMovie;
        imagePath = movie.posterPath;
        title = movie.title;
        subtitle = 'Movie • ${movie.releaseDate}';
        break;
      case MediaType.tv:
        MultiSearchTV tv = result as MultiSearchTV;
        imagePath = tv.posterPath;
        title = tv.name;
        subtitle = 'TV Show • ${tv.firstAirDate}';
        break;
      case MediaType.person:
        MultiSearchPerson person = result as MultiSearchPerson;
        imagePath = person.profilePath;
        title = person.name;
        subtitle = 'Person • ${person.knownForDepartment}';
        break;
    }

     String posterUrl = imagePath != null
        ? 'https://db.inosuke.sbs/t/p/w500$imagePath'
        : 'https://db.inosuke.sbs/t/p/w500$imagePath';

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
                      filterQuality: FilterQuality.high,
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
                      fadeInDuration:  Duration(milliseconds: 200),
                      fadeOutDuration:  Duration(milliseconds: 100),
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
    BuildContext context, seriesProvider, typec, VoidCallback vibrateCallback, ScrollController custroller) {
  var status = seriesProvider.status;
  var userData = Provider.of<UserDataService>(context);

  int gridSize = userData.gridSize.toInt();
  if (status == LoadingStatus.loading) {
    // Show loading indicator initially or while loading
    return 

    
    Center(
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

  var seriesList = seriesProvider.filteredAndSortedContent;
    return   MasonryGridView.count(
    padding: const EdgeInsets.all(3.0),
    crossAxisCount: 1 * gridSize, // Adjust number of
    mainAxisSpacing: 1.05,
    controller: ScrollController(keepScrollOffset: true),
    shrinkWrap: true,
    physics: const BouncingScrollPhysics(),
    crossAxisSpacing: 1.1,
  //  cacheExtent: 100,
    itemCount: seriesList.length,
    itemBuilder: (context, index) {
      var series = seriesList[index];
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
