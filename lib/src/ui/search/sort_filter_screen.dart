import 'package:flutter/material.dart';

class SortFilterScreen extends StatefulWidget {
  const SortFilterScreen({super.key});

  @override
  State<SortFilterScreen> createState() => _SortFilterScreenState();
}

class _SortFilterScreenState extends State<SortFilterScreen> {
  String _selectedSort = 'Popularity';
  String _selectedCategory = 'Movie';
  String _selectedRegion = 'All';
  Set<String> _selectedGenres = {'Action'};
  String _selectedReleaseYear = 'All';

  final List<String> _sortOptions = ['Popularity', 'Latest Release'];
  final List<String> _categories = ['Episode', 'Movie'];
  final List<String> _regions = ['All', 'Japan', 'Chinese', 'Others'];
  final List<String> _genres = [
    'All', 'Action', 'Slice of Life', 'Magic', 'Sci-Fi', 'Mystery',
    'Comedy', 'Romance', 'Drama', 'Adventure', 'Fantasy', 'Horror',
    'Thriller', 'Animation', 'Documentary', 'Family', 'History',
  ];
  final List<String> _releaseYears = ['All', '2022', '2021', '2020', '2019', '2018', 'Oldest'];


  Widget _buildSectionTitle(String title, {VoidCallback? onSeeAll}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          if (onSeeAll != null)
            TextButton(
              onPressed: onSeeAll,
              child: Text(
                'See all',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildChoiceChips(
      List<String> options,
      Set<String> selected, {
        bool allowMultiple = false,
        required ValueChanged<String> onSelected,
      }) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: options.map((option) {
        final isSelected = selected.contains(option);
        return ChoiceChip(
          label: Text(option),
          selected: isSelected,
          onSelected: (bool selectedValue) {
            onSelected(option);
          },
          selectedColor: Theme.of(context).colorScheme.primary,
          backgroundColor: Colors.grey.shade800,
          labelStyle: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
            fontWeight: FontWeight.w500,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey.shade700,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSingleChoiceChips(
      List<String> options,
      String selected, {
        required ValueChanged<String> onSelected,
      }) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: options.map((option) {
        final isSelected = selected == option;
        return ChoiceChip(
          label: Text(option),
          selected: isSelected,
          onSelected: (bool selectedValue) {
            if (selectedValue) {
              onSelected(option);
            }
          },
          selectedColor: Theme.of(context).colorScheme.primary,
          backgroundColor: Colors.grey.shade800,
          labelStyle: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
            fontWeight: FontWeight.w500,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey.shade700,
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0F10),
      appBar: AppBar(
        title: const Text('Sort & Filter'),
        centerTitle: true,
        backgroundColor: const Color(0xFF0D0F10),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz),
            onPressed: () {
              // TODO: Implement more options for sort/filter
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Sort'),
                  _buildSingleChoiceChips(
                    _sortOptions,
                    _selectedSort,
                    onSelected: (value) => setState(() => _selectedSort = value),
                  ),
                  _buildSectionTitle('Categories'),
                  _buildSingleChoiceChips(
                    _categories,
                    _selectedCategory,
                    onSelected: (value) => setState(() => _selectedCategory = value),
                  ),
                  _buildSectionTitle('Region'),
                  _buildSingleChoiceChips(
                    _regions,
                    _selectedRegion,
                    onSelected: (value) => setState(() => _selectedRegion = value),
                  ),
                  _buildSectionTitle('Genre', onSeeAll: () {
                    // TODO: Navigate to a full genre selection screen
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('See all genres functionality')),
                    );
                  }),
                  _buildChoiceChips(
                    _genres,
                    _selectedGenres,
                    allowMultiple: true,
                    onSelected: (value) {
                      setState(() {
                        if (_selectedGenres.contains(value)) {
                          _selectedGenres.remove(value);
                        } else {
                          _selectedGenres.add(value);
                        }
                      });
                    },
                  ),
                  _buildSectionTitle('Release Year', onSeeAll: () {
                    // TODO: Navigate to a full release year selection screen
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('See all release years functionality')),
                    );
                  }),
                  _buildSingleChoiceChips(
                    _releaseYears,
                    _selectedReleaseYear,
                    onSelected: (value) => setState(() => _selectedReleaseYear = value),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white70,
                      side: const BorderSide(color: Colors.white10),
                      backgroundColor: Colors.grey.shade800,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () {
                      setState(() {
                        _selectedSort = 'Popularity';
                        _selectedCategory = 'Movie';
                        _selectedRegion = 'All';
                        _selectedGenres = {'All'};
                        _selectedReleaseYear = 'All';
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Filters reset')),
                      );
                    },
                    child: const Text('Reset', style: TextStyle(color: Colors.white70)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () {
                      // TODO: Apply filters and return to search results
                      Navigator.of(context).pop({
                        'sort': _selectedSort,
                        'category': _selectedCategory,
                        'region': _selectedRegion,
                        'genres': _selectedGenres.toList(),
                        'releaseYear': _selectedReleaseYear,
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Filters applied')),
                      );
                    },
                    child: const Text('Apply'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}