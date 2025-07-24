// lib/widgets/unified_search_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'package:miko/providers/god_proovider.dart'; // Assuming this is the correct import; removed duplicate with 'as tsa'
import 'package:provider/provider.dart';

import 'package:miko/utils/colors.dart';
import 'package:miko/widgets/anime_series_card.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'dart:async'; // Import for Timer (debouncing)

// Assuming LoadingStatus enum exists in the provider
// enum LoadingStatus { initial, loading, loaded, error }

class UnifiedSearchBottomSheet extends StatefulWidget {
  final String? initialQuery;

  const UnifiedSearchBottomSheet({this.initialQuery, super.key});

  @override
  State<UnifiedSearchBottomSheet> createState() => _UnifiedSearchBottomSheetState();
}

class _UnifiedSearchBottomSheetState extends State<UnifiedSearchBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  Timer? _debounce;
  String _currentQuery = '';
  bool _isLoading = false;

  late MovieProvider _movieProvider;
  late TvSeriesProvider _tvProvider;
  late AnimeProvider _animeProvider;

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.initialQuery ?? '';
    _currentQuery = widget.initialQuery ?? '';
    _searchController.addListener(_onSearchChanged);

    _initializeProviders();
  }

  void _initializeProviders() {
    _movieProvider = Provider.of<MovieProvider>(context, listen: false);
    _tvProvider = Provider.of<TvSeriesProvider>(context, listen: false);
    _animeProvider = Provider.of<AnimeProvider>(context, listen: false);

    _loadData().then((_) {
      if (_currentQuery.isNotEmpty) {
        _performSearch(_currentQuery, immediate: true);
      }
      _searchFocusNode.requestFocus();
    });
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    // Add any necessary data loading here if required

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _searchFocusNode.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () { // Increased to 300ms for better debouncing
      if (_searchController.text != _currentQuery) {
        _performSearch(_searchController.text);
      }
    });
  }

  void _performSearch(String query, {bool immediate = false}) {
    if (!mounted) return;

    setState(() {
      _currentQuery = query;
    });

    _movieProvider.searchMovies(query);
    _tvProvider.searchAnime(query); // Assuming this is correct; adjust if method name differs
    _animeProvider.searchAnime(query);
  }

  void _clearAllSearches() {
    _movieProvider.searchMovies('');
    _tvProvider.searchAnime('');
    _animeProvider.searchAnime('');
  }

  void _clearInputAndSearch() {
    setState(() {
      _currentQuery = '';
      _isLoading = false;
    });
    _searchController.clear();
    _clearAllSearches();
  }

  @override
  Widget build(BuildContext context) {
    final movieProvider = context.watch<MovieProvider>();
    final tvProvider = context.watch<TvSeriesProvider>();
    final animeProvider = context.watch<AnimeProvider>();

    // Combine all results
    final List<dynamic> allResults = [
      ...movieProvider.filteredAndSortedContent,
      ...tvProvider.filteredAndSortedContent,
      ...animeProvider.filteredAndSortedContent,
    ];

    // Sort results by name
    allResults.sort((a, b) {
      String nameA = _getItemName(a);
      String nameB = _getItemName(b);
      return nameA.toLowerCase().compareTo(nameB.toLowerCase());
    });

    // Determine loading state
    final bool isLoading = _isLoading ||
        movieProvider.status == LoadingStatus.loading ||
        animeProvider.status == LoadingStatus.loading ||
        tvProvider.status == LoadingStatus.loading;

    final bool hasResults = allResults.isNotEmpty;
    final bool hasSearched = _currentQuery.isNotEmpty;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.primaryBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Drag handle for bottom sheet
            Container(
              width: 40,
              height: 5,
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.secondaryText.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            // Search Bar
            Container(
              color: AppColors.secondaryBackground.withOpacity(0.95),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.iconColor), // Changed to close for bottom sheet
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      focusNode: _searchFocusNode,
                      style: const TextStyle(color: AppColors.primaryText, fontSize: 18),
                      cursorColor: AppColors.accentColor,
                      decoration: InputDecoration(
                        hintText: 'Search Movies, TV & Anime...',
                        hintStyle: TextStyle(color: AppColors.secondaryText.withOpacity(0.7)),
                        border: InputBorder.none,
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, color: AppColors.secondaryText),
                                onPressed: _clearInputAndSearch,
                              )
                            : null,
                      ),
                      onSubmitted: (query) => _performSearch(query, immediate: true),
                    ),
                  ),
                ],
              ),
            ),
            // Results Area
            Expanded(
              child: _buildResultsArea(isLoading, hasSearched, hasResults, allResults),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsArea(bool isLoading, bool hasSearched, bool hasResults, List<dynamic> results) {
    if (isLoading && !hasResults) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.accentColor),
      );
    }

    if (!hasSearched) {
      return const Center(
        child: Text(
          'Start typing to search...',
          style: TextStyle(color: AppColors.secondaryText),
        ),
      );
    }

    if (!isLoading && !hasResults && hasSearched) {
      return Center(
        child: Text(
          'No results found for "$_currentQuery"',
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.secondaryText),
        ),
      );
    }

    // Display results in a grid
    return MasonryGridView.count(
      padding: const EdgeInsets.all(8.0),
      crossAxisCount: 3,
      mainAxisSpacing: 8.0,
      crossAxisSpacing: 8.0,
      itemCount: results.length,
      itemBuilder: (context, index) {
        final item = results[index];
        return _buildItemCard(item);
      },
    );
  }

  Widget _buildItemCard(dynamic item) {
    if (item is Movie) {
      return MovieCard(
        movie: item,
        typec: "movie",
      );
    } else if (item is TvSeriesAnime) {
      return AnimeSeriesCard(
        series: item,
        typec: "anime",
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  String _getItemName(dynamic item) {
    if (item is Movie) {
      return item.title;
    } else if (item is TvSeriesAnime) {
      return item.name;
    }
    return '';
  }
}

// Usage example in another widget:
