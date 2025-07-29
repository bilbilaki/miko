// TODO Implement this library.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miko/jackett/models/search_params.dart';
import 'package:miko/jackett/providers/jackett_providers.dart';

class SearchForm extends ConsumerStatefulWidget {
  const SearchForm({super.key});

  @override
  ConsumerState<SearchForm> createState() => _SearchFormState();
}

class _SearchFormState extends ConsumerState<SearchForm> {
  final _formKey = GlobalKey<FormState>();
  final _queryController = TextEditingController();
  var _searchType = SearchType.search;

  void _performSearch() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final params = SearchParams(
        type: _searchType,
        query: _queryController.text,
      );
      // TODO: Add more specific params based on search type
      ref.read(searchProvider.notifier).performSearch(params);
    }
  }

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchProvider);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DropdownButtonFormField<SearchType>(
            value: _searchType,
            onChanged: (value) => setState(() => _searchType = value!),
            items: SearchType.values
                .map((type) => DropdownMenuItem(
                      value: type,
                      child: Text(type.name[0].toUpperCase() + type.name.substring(1)),
                    ))
                .toList(),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Search Type',
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _queryController,
            decoration: const InputDecoration(
              labelText: 'Search Query',
              border: OutlineInputBorder(),
            ),
            validator: (value) => value!.isEmpty ? 'Query cannot be empty' : null,
            onFieldSubmitted: (_) => _performSearch(),
          ),
          const SizedBox(height: 16),
          // Placeholder for more advanced fields
          // e.g., year, imdbid, etc. based on _searchType
          ElevatedButton.icon(
            onPressed: searchState.isLoading ? null : _performSearch,
            icon: searchState.isLoading
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.search),
            label: const Text('Search'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          )
        ],
      ),
    );
  }
}