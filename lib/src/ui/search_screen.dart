// File: lib/src/ui/search_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miko/src/consts.dart';
import 'package:miko/src/providers/search_providers.dart';
import 'package:miko/src/providers/trending_providers.dart';
import 'package:miko/src/ui/search/search_bar_widget.dart';
import 'package:miko/src/ui/search/search_top_item.dart';
import 'package:miko/src/ui/search/sort_filter_screen.dart';
import 'package:miko/src/ui/widgets/episode_grid_item.dart';
import 'package:lottie/lottie.dart'; // For 404 animation
import 'package:miko/src/ui/anime_detail_screen.dart'; // Import for navigation to detail

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _currentQuery = '';
  bool _showResults = false;

  void _onQueryChanged(String query) {
    setState(() {
      _currentQuery = query;
      if (query.isNotEmpty) {
        _showResults = true;
      } else {
        _showResults = false;
      }
    });
  }

  void _onKeyPress(String char) {
    // Toggle case if shift is active (not implemented yet)
    // String charToAppend = _isShiftActive ? char.toUpperCase() : char.toLowerCase();
    String charToAppend = char.toLowerCase(); // For now, always lowercase
    _searchController.text += charToAppend;
    _onQueryChanged(_searchController.text);
    // If a character is pressed, deactivate shift for next character
    // if (_isShiftActive) setState(() => _isShiftActive = false);

  }

  void _onDelete() {
    if (_searchController.text.isNotEmpty) {
      _searchController.text = _searchController.text.substring(0, _searchController.text.length - 1);
      _onQueryChanged(_searchController.text);
    }
  }

  void _onSpace() {
    _searchController.text += ' ';
    _onQueryChanged(_searchController.text);
  }

  void _onShift() {
    // TODO: Implement shift for capitalization
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Shift key pressed (not implemented)')));
  }

  void _onNumbers() {
    // TODO: Implement number/symbol keyboard
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Numbers key pressed (not implemented)')));
  }

  void _openFilterScreen() async {
    final result = await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute(builder: (_) => const SortFilterScreen()),
    );
    if (result != null) {
      // TODO: Apply filters to search query
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Filters applied: $result')),
      );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topSearchesAsync = ref.watch(trendingMoviesDayProvider); // Using trending movies as "Top Searches"
    final searchResultsAsync = _currentQuery.isNotEmpty
        ? ref.watch(searchMultiProvider({'query': _currentQuery, 'page': 1}))
        : null;

    return Scaffold(
      backgroundColor: const Color(0xFF0D0F10),
      appBar: AppBar(
        toolbarHeight: 0, // Hide the default AppBar
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          SearchBarWidget(
            controller: _searchController,
            onChanged: _onQueryChanged,
            onClear: () {
              _searchController.clear();
              _onQueryChanged('');
            },
            onFilterTap: _openFilterScreen,
            autofocus: true,
          ),
          Expanded(
            child: _showResults
                ? (searchResultsAsync?.when(
                      data: (response) {
                        if (response.results.isEmpty) {
                          return _buildNotFoundState();
                        }
                        return RefreshIndicator(
                          onRefresh: () async {
                            ref.invalidate(searchMultiProvider({'query': _currentQuery, 'page': 1}));
                            await ref.read(searchMultiProvider({'query': _currentQuery, 'page': 1}).future);
                          },
                          child: GridView.builder(
                            padding: const EdgeInsets.all(16),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 0.75,
                            ),
                            itemCount: response.results.length,
                            itemBuilder: (context, index) {
                              final item = response.results[index];
                              if (item.posterPath == null || (item.voteAverage == null && item.popularity == null)) {
                                return const SizedBox.shrink();
                              }
                              return EpisodeGridItem(
                                imageUrl: '$tmdbImageBaseUrlc/t/p/w500${item.posterPath}',
                                title: item.title ?? item.name ?? 'N/A',
                                episodeInfo: item.mediaType == 'tv'
                                    ? 'TV Series (${item.firstAirDate?.substring(0,4) ?? 'N/A'})'
                                    : 'Movie (${item.releaseDate?.substring(0,4) ?? 'N/A'})',
                                rating: item.voteAverage != null ? item.voteAverage!.toStringAsFixed(1) : (item.popularity ?? 0.0).toStringAsFixed(1),
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => AnimeDetailScreen(animeId: item.id, mediaType: item.mediaType ?? 'movie')));
                                },
                              );
                            },
                          ),
                        );
                      },
                      loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFF1ED760))),
                      error: (err, stack) => Center(child: Text('Error: $err', style: const TextStyle(color: Colors.red))),
                    ) ??
                    const SizedBox.shrink()) // If query is empty, this is null
                : topSearchesAsync.when(
                    data: (response) {
                      final items = response.results.take(4).toList(); // Show top 4 for initial view
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                            child: Text(
                              'Top Searches',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: items.length,
                              itemBuilder: (context, index) {
                                final item = items[index];
                                if (item.posterPath == null) return const SizedBox.shrink();
                                return SearchTopItem(
                                  imageUrl: '$tmdbImageBaseUrlc/t/p/w200${item.posterPath}',
                                  title: item.title ?? item.name ?? 'N/A',
                                  subtitle: item.releaseDate ?? item.firstAirDate ?? item.mediaType ?? 'N/A',
                                  onTap: () {
                                    _searchController.text = item.title ?? item.name ?? '';
                                    _onQueryChanged(_searchController.text);
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
                    loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFF1ED760))),
                    error: (err, stack) => Center(child: Text('Error loading top searches: $err', style: const TextStyle(color: Colors.red))),
                  ),
          ),
        
        ],
      ),
    );
  }

  Widget _buildNotFoundState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(
          'assets/Lottie/404_not_found.json', // Path to your Lottie animation
          repeat: true,
          height: 150,
          width: 150,
        ),
        const SizedBox(height: 24),
        const Text(
          'Not Found',
          style: TextStyle(
            color: Color(0xFF1ED760),
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.0),
          child: Text(
            'Sorry, the keyword you entered could not be found. Try to check again or search with other keywords.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ),
      ],
    );
  }
}