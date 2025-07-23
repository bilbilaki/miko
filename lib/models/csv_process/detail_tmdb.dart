
// Helper function to format lists, similar to the Python script
String _formatList(List<dynamic>? items, {int limit = 10}) {
  if (items == null || items.isEmpty) return '';
  items = items.take(limit).toList();
  return items
      .map((item) {
        if (item is String) return item;
        if (item['name'] != null) return item['name'];
        return '';
      })
      .where((s) => s.isNotEmpty)
      .join(', ');
}

// Helper for videos, targeting YouTube trailers
String _formatVideos(List<dynamic>? videos) {
  if (videos == null || videos.isEmpty) return '';
  final trailer = videos.firstWhere(
      (v) => v['type'] == 'Trailer' && v['site'] == 'YouTube',
      orElse: () => null);
  return trailer != null ? trailer['name'] : '';
}

class MediaData {
  final String tmdbId;
  final String seriesName; // The original name from the input file
  final String status;
  final String releaseDate;
  final String runtime;
  final String overview;
  final String voteAverage;
  final String voteCount;
  final String genres;
  final String keywords;
  final String originalName;
  final String posterPath;
  final String backdropPath;
  final String popularity;
  final String originalLanguage;
  final String type;
  final String numberOfEpisodes;
  final String numberOfSeasons;
  final String homepage;
  final String cast;
  final String crew;
  final String videos;

  MediaData({
    required this.tmdbId,
    required this.seriesName,
    required this.status,
    required this.releaseDate,
    required this.runtime,
    required this.overview,
    required this.voteAverage,
    required this.voteCount,
    required this.genres,
    required this.keywords,
    required this.originalName,
    required this.posterPath,
    required this.backdropPath,
    required this.popularity,
    required this.originalLanguage,
    required this.type,
    required this.numberOfEpisodes,
    required this.numberOfSeasons,
    required this.homepage,
    required this.cast,
    required this.crew,
    required this.videos,
  });

  // Factory constructor to create an instance from TMDB API response
  factory MediaData.fromTmdb(Map details, String inputName, String mediaType) {
    final credits = details['credits'] ?? {};
    final keywordsData = details['keywords'] ?? {};

    // For TV shows, keywords are in a 'results' list. For movies, a 'keywords' list.
    final keywordsList = keywordsData['results'] ?? keywordsData['keywords'];

    return MediaData(
      tmdbId: (details['id'] ?? '').toString(),
      seriesName: inputName,
      status: details['status'] ?? '',
      releaseDate: details['first_air_date'] ?? details['release_date'] ?? '',
      runtime: (mediaType == 'tv'
              ? (details['episode_run_time'] as List?)?.firstOrNull ?? 0
              : details['runtime'] ?? 0)
          .toString(),
      overview: (details['overview'] ?? '').length > 500
          ? '${(details['overview'] ?? '').substring(0, 500)}...'
          : details['overview'] ?? '',
      voteAverage: (details['vote_average'] ?? 0.0).toString(),
      voteCount: (details['vote_count'] ?? 0).toString(),
      genres: _formatList(details['genres']),
      keywords: _formatList(keywordsList),
      originalName: details['original_name'] ?? details['original_title'] ?? '',
      posterPath: details['poster_path'] ?? '',
      backdropPath: details['backdrop_path'] ?? '',
      popularity: (details['popularity'] ?? 0.0).toString(),
      originalLanguage: details['original_language'] ?? '',
      type: mediaType.toUpperCase(),
      numberOfEpisodes: (details['number_of_episodes'] ?? 0).toString(),
      numberOfSeasons: (details['number_of_seasons'] ?? 0).toString(),
      homepage: details['homepage'] ?? '',
      cast: _formatList(credits['cast'], limit: 3),
      crew: _formatList(
          credits['crew']
              ?.where(
                  (c) => ['Director', 'Writer', 'Creator'].contains(c['job']))
              .toList(),
          limit: 3),
      videos: _formatVideos(details['videos']?['results']),
    );
  }

  // Method to convert the data to a list of strings for CSV writing
  List<String> toCsvRow() {
    return [
      tmdbId,
      seriesName,
      status,
      releaseDate,
      runtime,
      overview,
      voteAverage,
      voteCount,
      genres,
      keywords,
      originalName,
      posterPath,
      backdropPath,
      popularity,
      originalLanguage,
      type,
      numberOfEpisodes,
      numberOfSeasons,
      homepage,
      cast,
      crew,
      videos
    ];
  }

  static List<String> getCsvHeaders() {
    return [
      "TMDB_ID",
      "SERIES",
      "STATUS",
      "RELEASE_DATE",
      "RUNTIME",
      "OVERVIEW",
      "Vote_Average",
      "Vote_Count",
      "Genres",
      "Keywords",
      "original_name",
      "poster_path",
      "backdrop_path",
      "popularity",
      "original_language",
      "type",
      "number_of_episodes",
      "number_of_seasons",
      "homepage",
      "Cast",
      "Crew",
      "Videos"
    ];
  }
}
