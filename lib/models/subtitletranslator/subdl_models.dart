// SubDL Models
class SubDLSearchRequest {
  final String apiKey;
  final String? filmName;
  final String? fileName;
  final String? sdId;
  final String? imdbId;
  final String? tmdbId;
  final int? seasonNumber;
  final int? episodeNumber;
  final String? type;
  final int? year;
  final String? languages;
  final int? subsPerPage;
  final bool? comment;
  final bool? releases;
  final bool? hi;
  final bool? fullSeason;

  const SubDLSearchRequest({
    required this.apiKey,
    this.filmName,
    this.fileName,
    this.sdId,
    this.imdbId,
    this.tmdbId,
    this.seasonNumber,
    this.episodeNumber,
    this.type,
    this.year,
    this.languages,
    this.subsPerPage,
    this.comment,
    this.releases,
    this.hi,
    this.fullSeason,
  });

  Map<String, String> toQueryParameters() {
    final params = <String, String>{
      'api_key': apiKey,
    };

    if (filmName != null) params['film_name'] = filmName!;
    if (fileName != null) params['file_name'] = fileName!;
    if (sdId != null) params['sd_id'] = sdId!;
    if (imdbId != null) params['imdb_id'] = imdbId!;
    if (tmdbId != null) params['tmdb_id'] = tmdbId!;
    if (seasonNumber != null) params['season_number'] = seasonNumber.toString();
    if (episodeNumber != null) params['episode_number'] = episodeNumber.toString();
    if (type != null) params['type'] = type!;
    if (year != null) params['year'] = year.toString();
    if (languages != null) params['languages'] = languages!;
    if (subsPerPage != null) params['subs_per_page'] = subsPerPage.toString();
    if (comment == true) params['comment'] = '1';
    if (releases == true) params['releases'] = '1';
    if (hi == true) params['hi'] = '1';
    if (fullSeason == true) params['full_season'] = '1';

    return params;
  }
}

class SubDLMovie {
  final String? imdbId;
  final int? tmdbId;
  final String? type;
  final String name;
  final int? sdId;
  final String? firstAirDate;
  final int? year;

  const SubDLMovie({
    this.imdbId,
    this.tmdbId,
    this.type,
    required this.name,
    this.sdId,
    this.firstAirDate,
    this.year,
  });

  factory SubDLMovie.fromJson(Map<String, dynamic> json) {
    return SubDLMovie(
      imdbId: json['imdb_id'] as String?,
      tmdbId: json['tmdb_id'] as int?,
      type: json['type'] as String?,
      name: json['name'] as String? ?? '',
      sdId: json['sd_id'] as int?,
      firstAirDate: json['first_air_date'] as String?,
      year: json['year'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imdb_id': imdbId,
      'tmdb_id': tmdbId,
      'type': type,
      'name': name,
      'sd_id': sdId,
      'first_air_date': firstAirDate,
      'year': year,
    };
  }
}

class SubDLSubtitle {
  final String? subtitleId;
  final String? language;
  final String? releaseName;
  final String? author;
  final String? url;
  final String? downloadUrl;

  const SubDLSubtitle({
    this.subtitleId,
    this.language,
    this.releaseName,
    this.author,
    this.url,
    this.downloadUrl,
  });

  factory SubDLSubtitle.fromJson(Map<String, dynamic> json) {
    return SubDLSubtitle(
      subtitleId: json['subtitle_id'] as String?,
      language: json['language'] as String?,
      releaseName: json['release_name'] as String?,
      author: json['author'] as String?,
      url: json['url'] as String?,
      downloadUrl: json['download_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subtitle_id': subtitleId,
      'language': language,
      'release_name': releaseName,
      'author': author,
      'url': url,
      'download_url': downloadUrl,
    };
  }

  SubDLSubtitle copyWith({
    String? subtitleId,
    String? language,
    String? releaseName,
    String? author,
    String? url,
    String? downloadUrl,
  }) {
    return SubDLSubtitle(
      subtitleId: subtitleId ?? this.subtitleId,
      language: language ?? this.language,
      releaseName: releaseName ?? this.releaseName,
      author: author ?? this.author,
      url: url ?? this.url,
      downloadUrl: downloadUrl ?? this.downloadUrl,
    );
  }
}

class SubDLSearchResponse {
  final bool status;
  final List<SubDLMovie> results;
  final List<SubDLSubtitle> subtitles;
  final String? error;

  const SubDLSearchResponse({
    required this.status,
    this.results = const [],
    this.subtitles = const [],
    this.error,
  });

  factory SubDLSearchResponse.fromJson(Map<String, dynamic> json) {
    return SubDLSearchResponse(
      status: json['status'] as bool? ?? false,
      results: (json['results'] as List<dynamic>?)
              ?.map((e) => SubDLMovie.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      subtitles: (json['subtitles'] as List<dynamic>?)
              ?.map((e) => SubDLSubtitle.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      error: json['error'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'results': results.map((e) => e.toJson()).toList(),
      'subtitles': subtitles.map((e) => e.toJson()).toList(),
      'error': error,
    };
  }
}
