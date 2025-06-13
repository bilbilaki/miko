import 'dart:async';
import 'package:flutter/material.dart';
import '../showcases/model.dart';

typedef FetchResultsCallback = Future<void> Function({bool loadMore});
typedef ResultTapCallback = void Function(MultiSearchResult);

class SearchOverlay extends StatefulWidget {
  final TextEditingController searchController;
  final ScrollController resultScrollController;
  final FetchResultsCallback fetchResults;
  final MultiSearchResponse? searchResponse;
  final bool isLoading;
  final bool isFetchingMore;
  final String? error;
  final ResultTapCallback onResultTap;

  const SearchOverlay({
    super.key,
    required this.searchController,
    required this.resultScrollController,
    required this.fetchResults,
    required this.searchResponse,
    required this.isLoading,
    required this.isFetchingMore,
    required this.error,
    required this.onResultTap,
  });

  @override
  State<SearchOverlay> createState() => _SearchOverlayState();
}

class _SearchOverlayState extends State<SearchOverlay> {
  Timer? _debounce;
  String _currentQuery = '';

  @override
  void initState() {
    super.initState();
    widget.searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    widget.searchController.removeListener(_onSearchChanged);
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      final query = widget.searchController.text;
      if (query != _currentQuery) {
        _currentQuery = query;
        if (_currentQuery.isNotEmpty) {
          widget.fetchResults();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: GestureDetector(
        onTap: () => _showSearchOverlay(context),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
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
    );
  }

  void _showSearchOverlay(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (context, controller) {
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
                      controller: widget.searchController,
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            widget.searchController.clear();
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: _buildBody(),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBody() {
    if (widget.isLoading && (widget.searchResponse == null || widget.searchResponse!.results.isEmpty)) {
      return const Center(child: CircularProgressIndicator());
    }
    if (widget.error != null) {
      return Center(child: Text('Error: ${widget.error}'));
    }
    if (widget.searchResponse == null) {
      return const Center(child: Text('Start typing to search...'));
    }
    final results = widget.searchResponse!.results;
    return ListView.builder(
      controller: widget.resultScrollController,
      padding: const EdgeInsets.all(8.0),
      itemCount: results.length + (widget.isFetchingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == results.length && widget.isFetchingMore) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          );
        }
        final result = results[index];
        return _buildMultiSearchResultCard(context, result);
      },
    );
  }

  Widget _buildMultiSearchResultCard(BuildContext context, MultiSearchResult result) {
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
    final posterUrl = imagePath != null
        ? 'https://inosdb.worker-inosuke.workers.dev/w500$imagePath'
        : '';
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => widget.onResultTap(result),
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
                    child: Icon(
                      result.mediaType == MediaType.movie
                          ? Icons.movie_outlined
                          : result.mediaType == MediaType.tv
                              ? Icons.tv_outlined
                              : Icons.person_outline,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
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