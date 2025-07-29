enum SearchType { search, tv, movie, music, book }

class SearchParams {
  final Map<String, String> _params = {};

  SearchParams({
    required SearchType type,
    String? query,
    List<int>? categories,
  }) {
    _params['t'] = type.name;
    if (query != null && query.isNotEmpty) _params['q'] = query;
    if (categories != null && categories.isNotEmpty) {
      _params['cat'] = categories.join(',');
    }
  }

  void add(String key, dynamic value) {
    if (value != null) {
      final stringValue = value.toString();
      if (stringValue.isNotEmpty) {
        _params[key] = stringValue;
      }
    }
  }

  Map<String, String> toMap() => Map.unmodifiable(_params);
}