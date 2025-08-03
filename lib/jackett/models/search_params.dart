enum SearchType {
  search('search'),
  tv('tvsearch'),
  movie('movie'),
  music('music'),
  book('book');

  final String value;
  const SearchType(this.value);
}

class SearchParams {
  final Map<String, String> _params = {};

  static const Map<SearchType, Set<String>> _allowedParams = {
    SearchType.search: {'q'},
    SearchType.tv: {
      'q', 'season', 'ep', 'imdbid', 'tvdbid', 'rid', 'tmdbid',
      'tvmazeid', 'traktid', 'doubanid', 'year', 'genre'
    },
    SearchType.movie: {'q', 'imdbid', 'tmdbid', 'traktid', 'doubanid', 'year', 'genre'},
    SearchType.music: {'q', 'album', 'artist', 'label', 'track', 'year', 'genre'},
    SearchType.book: {'q', 'title', 'author', 'publisher', 'year', 'genre'},
  };

  final SearchType type;

  SearchParams({
    required this.type,
    String? query,
    List<int>? categories,
    Map<String, dynamic>? extras,
  }) {
    _params['t'] = type.value;
    if (query != null && query.isNotEmpty) _params['q'] = query;
    if (categories != null && categories.isNotEmpty) {
      _params['cat'] = categories.join(',');
    }

    if (extras != null) {
      for (final entry in extras.entries) {
        add(entry.key, entry.value);
      }
    }
  }

  void add(String key, dynamic value) {
    if (!_allowedParams[type]!.contains(key)) {
      throw ArgumentError("Parameter '$key' is not allowed for type '${type.name}'");
    }

    if (value != null) {
      final stringValue = value.toString();
      if (stringValue.isNotEmpty) {
        _params[key] = stringValue;
      }
    }
  }

  Map<String, String> toMap() => Map.unmodifiable(_params);
}
