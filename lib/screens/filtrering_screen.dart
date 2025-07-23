import 'package:flutter/material.dart';
import 'package:miko/models/advancedfiltering.dart';
import 'package:provider/provider.dart';

class ContentFilterBottomSheet<T extends ContentProvider<dynamic>> extends StatefulWidget {
  final T provider;

  const ContentFilterBottomSheet({Key? key, required this.provider}) : super(key: key);

  @override
  _ContentFilterBottomSheetState<T> createState() => _ContentFilterBottomSheetState<T>();
}

class _ContentFilterBottomSheetState<T extends ContentProvider<dynamic>> extends State<ContentFilterBottomSheet<T>> {
  late ContentFilterState _tempFilters;
  late Set<String> _allGenres;
  late Set<String> _allLanguages;
  late Set<String> _allCountries; // Only for movies

  // Sliders range bounds
  static const double _minVoteRange = 0.0;
  static const double _maxVoteRange = 10.0;
  static const int _minRuntimeRange = 0;
  static const int _maxRuntimeRange = 600; // Assuming max runtime of 10 hours

  @override
  void initState() {
    super.initState();
    _tempFilters = widget.provider.activeFilters.copyWith(); // Create a local mutable copy
    _allGenres = widget.provider.allAvailableGenres;
    _allLanguages = widget.provider.allAvailableLanguages;
    _allCountries = widget.provider.allAvailableCountries;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 20,
        left: 20,
        right: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filters & Sort',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const Divider(),
          _buildSectionTitle('Genres'),
          _buildChipFilter(_allGenres, _tempFilters.genres, (selectedGenres) {
            setState(() {
              _tempFilters = _tempFilters.copyWith(genres: selectedGenres);
            });
          }),
          const SizedBox(height: 16),
          _buildSectionTitle('Languages'),
          _buildChipFilter(_allLanguages, _tempFilters.languages, (selectedLanguages) {
            setState(() {
              _tempFilters = _tempFilters.copyWith(languages: selectedLanguages);
            });
          }),
          if (T == MovieProvider) ...[
            const SizedBox(height: 16),
            _buildSectionTitle('Production Countries'),
            _buildChipFilter(_allCountries, _tempFilters.countries, (selectedCountries) {
              setState(() {
                _tempFilters = _tempFilters.copyWith(countries: selectedCountries);
              });
            }),
          ],
          const SizedBox(height: 16),
          _buildSectionTitle('Vote Average'),
          RangeSlider(
            values: RangeValues(_tempFilters.minVoteAverage, _tempFilters.maxVoteAverage),
            min: _minVoteRange,
            max: _maxVoteRange,
            divisions: 20, // 0.5 increments
            labels: RangeLabels(
              _tempFilters.minVoteAverage.toStringAsFixed(1),
              _tempFilters.maxVoteAverage.toStringAsFixed(1),
            ),
            onChanged: (RangeValues newValues) {
              setState(() {
                _tempFilters = _tempFilters.copyWith(
                  minVoteAverage: newValues.start,
                  maxVoteAverage: newValues.end,
                );
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
                'Range: ${_tempFilters.minVoteAverage.toStringAsFixed(1)} - ${_tempFilters.maxVoteAverage.toStringAsFixed(1)}'),
          ),
          const SizedBox(height: 16),
          _buildSectionTitle('Runtime (minutes)'),
          RangeSlider(
            values: RangeValues(
              (_tempFilters.minRuntime ?? _minRuntimeRange).toDouble(),
              (_tempFilters.maxRuntime ?? _maxRuntimeRange).toDouble(),
            ),
            min: _minRuntimeRange.toDouble(),
            max: _maxRuntimeRange.toDouble(),
            divisions: _maxRuntimeRange ~/ 10, // 10 minute increments
            labels: RangeLabels(
              (_tempFilters.minRuntime ?? _minRuntimeRange).toString(),
              (_tempFilters.maxRuntime ?? _maxRuntimeRange).toString(),
            ),
            onChanged: (RangeValues newValues) {
              setState(() {
                _tempFilters = _tempFilters.copyWith(
                  minRuntime: newValues.start.round(),
                  maxRuntime: newValues.end.round(),
                );
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
                'Range: ${_tempFilters.minRuntime ?? 'Any'} - ${_tempFilters.maxRuntime ?? 'Any'} minutes'),
          ),
          const SizedBox(height: 16),
          _buildSectionTitle('Release/Air Date'),
          Row(
            children: [
              Expanded(
                child: _buildDateInput(
                  context,
                  'Start Date',
                  _tempFilters.startDate,
                  (date) {
                    setState(() {
                      _tempFilters = _tempFilters.copyWith(startDate: date);
                    });
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildDateInput(
                  context,
                  'End Date',
                  _tempFilters.endDate,
                  (date) {
                    setState(() {
                      _tempFilters = _tempFilters.copyWith(endDate: date);
                    });
                  },
                ),
              ),
            ],
          ),
          // Clear dates
          if (_tempFilters.startDate != null || _tempFilters.endDate != null)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  setState(() {
                    _tempFilters = _tempFilters.copyWith(startDate: null, endDate: null);
                  });
                },
                child: const Text('Clear Dates'),
              ),
            ),
          const SizedBox(height: 16),
          _buildSectionTitle('Sort By'),
          DropdownButton<SortBy>(
            isExpanded: true,
            value: _tempFilters.sortBy,
            onChanged: (SortBy? newValue) {
              if (newValue != null) {
                setState(() {
                  _tempFilters = _tempFilters.copyWith(sortBy: newValue);
                });
              }
            },
            items: SortBy.values.map((SortBy sort) {
              String name = sort.toString().split('.').last;
              name = name.replaceAllMapped(RegExp(r'([A-Z])'), (match) => ' ${match.group(1)}');
              return DropdownMenuItem<SortBy>(
                value: sort,
                child: Text(name.replaceFirst(' ', '')),
              );
            }).toList(),
          ),
          Row(
            children: [
              Text('Ascending Order'),
              Switch(
                value: _tempFilters.isAscending,
                onChanged: (bool newValue) {
                  setState(() {
                    _tempFilters = _tempFilters.copyWith(isAscending: newValue);
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    widget.provider.applyFiltersAndSort(ContentFilterState.initial());
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Reset'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    widget.provider.applyFiltersAndSort(_tempFilters);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Apply Filters'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildChipFilter(
      Set<String> allOptions, Set<String> selectedOptions, ValueChanged<Set<String>> onChanged) {
    if (allOptions.isEmpty) {
      return const Text('No options available.', style: TextStyle(fontStyle: FontStyle.italic));
    }
    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: allOptions.map((option) {
        final isSelected = selectedOptions.contains(option);
        return FilterChip(
          label: Text(option),
          selected: isSelected,
          onSelected: (bool selected) {
            final newSelectedOptions = Set<String>.from(selectedOptions);
            if (selected) {
              newSelectedOptions.add(option);
            } else {
              newSelectedOptions.remove(option);
            }
            onChanged(newSelectedOptions);
          },
          selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
          checkmarkColor: Theme.of(context).colorScheme.primary,
        );
      }).toList(),
    );
  }

  Widget _buildDateInput(
      BuildContext context, String label, DateTime? currentDate, ValueChanged<DateTime?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        InkWell(
          onTap: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: currentDate ?? DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (picked != null && picked != currentDate) {
              onChanged(picked);
            }
          },
          child: InputDecorator(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              isDense: true,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(currentDate == null ? 'Select Date' : '${currentDate.toLocal().year}-${currentDate.toLocal().month.toString().padLeft(2, '0')}-${currentDate.toLocal().day.toString().padLeft(2, '0')}'),
                Icon(Icons.calendar_today, size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// --- Part 4: Connecting Everything (Example Screen) ---

// This is a minimal example of how you might integrate the filter UI.
// You'll replace `MovieListPage` (or create similar for TvSeries/Anime) with your actual list screen.

class MovieListPage extends StatelessWidget {
  const MovieListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final movieProvider = context.watch<MovieProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true, // Allow bottom sheet to cover full screen if needed
                builder: (context) => ContentFilterBottomSheet<MovieProvider>(
                  provider: movieProvider,
                ),
              );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search movies...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: (query) {
                movieProvider.searchMovies(query);
              },
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Display Active Filters Summary
          Consumer<MovieProvider>(
            builder: (context, provider, child) {
              final activeFilters = provider.activeFilters;
              final List<Widget> filterChips = [];

              if (!activeFilters.isClear) {
                if (activeFilters.genres.isNotEmpty) {
                  filterChips.add(_buildActiveFilterChip(
                    'Genres: ${activeFilters.genres.join(', ')}',
                    () => provider.applyFiltersAndSort(
                        activeFilters.copyWith(genres: {})),
                  ));
                }
                if (activeFilters.languages.isNotEmpty) {
                  filterChips.add(_buildActiveFilterChip(
                    'Languages: ${activeFilters.languages.join(', ')}',
                    () => provider.applyFiltersAndSort(
                        activeFilters.copyWith(languages: {})),
                  ));
                }
                if (activeFilters.countries.isNotEmpty) {
                  filterChips.add(_buildActiveFilterChip(
                    'Countries: ${activeFilters.countries.join(', ')}',
                    () => provider.applyFiltersAndSort(
                        activeFilters.copyWith(countries: {})),
                  ));
                }
                if (activeFilters.minVoteAverage > ContentFilterState.initial().minVoteAverage ||
                    activeFilters.maxVoteAverage < ContentFilterState.initial().maxVoteAverage) {
                  filterChips.add(_buildActiveFilterChip(
                    'Vote: ${activeFilters.minVoteAverage.toStringAsFixed(1)}-${activeFilters.maxVoteAverage.toStringAsFixed(1)}',
                    () => provider.applyFiltersAndSort(activeFilters.copyWith(
                          minVoteAverage: ContentFilterState.initial().minVoteAverage,
                          maxVoteAverage: ContentFilterState.initial().maxVoteAverage,
                        )),
                  ));
                }
                if (activeFilters.minRuntime != null || activeFilters.maxRuntime != null) {
                  filterChips.add(_buildActiveFilterChip(
                    'Runtime: ${activeFilters.minRuntime ?? 'Any'}-${activeFilters.maxRuntime ?? 'Any'} min',
                    () => provider.applyFiltersAndSort(
                        activeFilters.copyWith(minRuntime: null, maxRuntime: null)),
                  ));
                }
                if (activeFilters.startDate != null || activeFilters.endDate != null) {
                  String dateRange = '';
                  if (activeFilters.startDate != null)
                    dateRange +=
                        'From: ${activeFilters.startDate!.toLocal().year}-${activeFilters.startDate!.toLocal().month.toString().padLeft(2, '0')}-${activeFilters.startDate!.toLocal().day.toString().padLeft(2, '0')}';
                  if (activeFilters.endDate != null)
                    dateRange +=
                        ' To: ${activeFilters.endDate!.toLocal().year}-${activeFilters.endDate!.toLocal().month.toString().padLeft(2, '0')}-${activeFilters.endDate!.toLocal().day.toString().padLeft(2, '0')}';
                  filterChips.add(_buildActiveFilterChip(
                    'Date: $dateRange',
                    () => provider.applyFiltersAndSort(
                        activeFilters.copyWith(startDate: null, endDate: null)),
                  ));
                }

                // Sorting info (not a filter to remove)
                String sortLabel = 'Sort by: ${activeFilters.sortBy.toString().split('.').last.replaceAllMapped(RegExp(r'([A-Z])'), (match) => ' ${match.group(1)}').trim()} (${activeFilters.isAscending ? 'Asc' : 'Desc'})';
                filterChips.add(Chip(label: Text(sortLabel)));
              }

              if (filterChips.isEmpty && provider.searchQuery.isEmpty) {
                return const SizedBox.shrink(); // No filters or search query, hide
              }

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: [
                    if (provider.searchQuery.isNotEmpty)
                      _buildActiveFilterChip(
                        'Search: "${provider.searchQuery}"',
                            () {
                          provider.updateSearchQuery('');
                        },
                      ),
                    ...filterChips,
                    if (!activeFilters.isClear)
                      ActionChip(
                        label: const Text('Clear All Filters'),
                        avatar: const Icon(Icons.clear_all),
                        onPressed: () {
                          provider.applyFiltersAndSort(ContentFilterState.initial());
                        },
                      ),
                  ],
                ),
              );
            },
          ),
          Expanded(
            child: movieProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : movieProvider.hasError
                    ? Center(child: Text('Error: ${movieProvider.errorMessage}'))
                    : movieProvider.filteredAndSortedContent.isEmpty
                        ? const Center(child: Text('No movies found matching criteria.'))
                        : ListView.builder(
                            itemCount: movieProvider.filteredAndSortedContent.length,
                            itemBuilder: (context, index) {
                              final movie = movieProvider.filteredAndSortedContent[index];
                              return ListTile(
                                leading: movie.getPosterUrl() != null
                                    ? Image.network(movie.getPosterUrl()!, height: 60, width: 40, fit: BoxFit.cover)
                                    : null,
                                title: Text(movie.title),
                                subtitle: Text(
                                    'Rating: ${movie.voteAverage.toStringAsFixed(1)} | Year: ${movie.releaseDate?.year ?? 'N/A'}'),
                                // Add more details or navigate to a detail page
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveFilterChip(String label, VoidCallback onDelete) {
    return Chip(
      label: Text(label),
      onDeleted: onDelete,
      deleteIcon: const Icon(Icons.cancel),
    );
  }
}
