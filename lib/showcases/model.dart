
class TvShow {
  final bool adult;
  final String? backdropPath;
  final List<int> genreIds;
  final List<Genre>? genres;
  final int id;
  final List<String> originCountry;
  final String originalLanguage;
  final String originalName;
  final String overview;
  final double popularity;
  final String? posterPath;
  final String? firstAirDate;
  final String? lastAirDate;
  final String name;
  final double voteAverage;
  final int voteCount;
  final List<Creator>? createdBy;
  final List<int>? episodeRunTime;
  final String? homepage;
  final bool? inProduction;
  final List<String>? languages;
  final Episode? lastEpisodeToAir;
  final Episode? nextEpisodeToAir;
  final List<Network>? networks;
  final int? numberOfEpisodes;
  final int? numberOfSeasons;
  final List<ProductionCompany>? productionCompanies;
  final List<ProductionCountry>? productionCountries;
  final List<Season>? seasons;
  final List<SpokenLanguage>? spokenLanguages;
  final String? status;
  final String? tagline;
  final String? type;

  TvShow({
    required this.adult,
    this.backdropPath,
    required this.genreIds,
    this.genres,
    required this.id,
    required this.originCountry,
    required this.originalLanguage,
    required this.originalName,
    required this.overview,
    required this.popularity,
    this.posterPath,
    this.firstAirDate,
    this.lastAirDate,
    required this.name,
    required this.voteAverage,
    required this.voteCount,
    this.createdBy,
    this.episodeRunTime,
    this.homepage,
    this.inProduction,
    this.languages,
    this.lastEpisodeToAir,
    this.nextEpisodeToAir,
    this.networks,
    this.numberOfEpisodes,
    this.numberOfSeasons,
    this.productionCompanies,
    this.productionCountries,
    this.seasons,
    this.spokenLanguages,
    this.status,
    this.tagline,
    this.type,
  });

  factory TvShow.fromJson(Map<String, dynamic> json) {
    return TvShow(
      adult: json['adult'],
      backdropPath: json['backdrop_path'],
        genreIds:
          json['genre_ids'] != null ? List<int>.from(json['genre_ids']) : [],
      genres: json['genres'] != null
          ? List<Genre>.from(json['genres'].map((x) => Genre.fromJson(x)))
          : null,
      id: json['id'],
      originCountry: List<String>.from(json['origin_country']),
      originalLanguage: json['original_language'],
      originalName: json['original_name'],
      overview: json['overview'],
      popularity: (json['popularity']),
      posterPath: json['poster_path'],
      firstAirDate: json['first_air_date'],
      lastAirDate: json['last_air_date'],
      name: json['name'],
      voteAverage: (json['vote_average']),
      voteCount: json['vote_count'],
      createdBy: json['created_by'] != null
          ? List<Creator>.from(
              json['created_by'].map((x) => Creator.fromJson(x)))
          : null,
      episodeRunTime: json['episode_run_time'] != null
          ? List<int>.from(json['episode_run_time'])
          : null,
      homepage: json['homepage'],
      inProduction: json['in_production'],
      languages: json['languages'] != null
          ? List<String>.from(json['languages'])
          : null,
      lastEpisodeToAir: json['last_episode_to_air'] != null
          ? Episode.fromJson(json['last_episode_to_air'])
          : null,
      nextEpisodeToAir: json['next_episode_to_air'] != null
          ? Episode.fromJson(json['next_episode_to_air'])
          : null,
      networks: json['networks'] != null
          ? List<Network>.from(json['networks'].map((x) => Network.fromJson(x)))
          : null,
      numberOfEpisodes: json['number_of_episodes'],
      numberOfSeasons: json['number_of_seasons'],
      productionCompanies: json['production_companies'] != null
          ? List<ProductionCompany>.from(json['production_companies']
              .map((x) => ProductionCompany.fromJson(x)))
          : null,
      productionCountries: json['production_countries'] != null
          ? List<ProductionCountry>.from(json['production_countries']
              .map((x) => ProductionCountry.fromJson(x)))
          : null,
      seasons: json['seasons'] != null
          ? List<Season>.from(json['seasons'].map((x) => Season.fromJson(x)))
          : null,
      spokenLanguages: json['spoken_languages'] != null
          ? List<SpokenLanguage>.from(
              json['spoken_languages'].map((x) => SpokenLanguage.fromJson(x)))
          : null,
      status: json['status'],
      tagline: json['tagline'],
      type: json['type'],
    );
  }

  String get fullPosterPath => posterPath != null
      ? 'https://inosdb.worker-inosuke.workers.dev/w500$posterPath'
      : 'https://inosdb.worker-inosuke.workers.dev/w500$posterPath';

  String get fullBackdropPath => backdropPath != null
      ? 'https://inosdb.worker-inosuke.workers.dev/w780$backdropPath'
      : 'https://inosdb.worker-inosuke.workers.dev/w780$backdropPath';

  String get year {
    if (firstAirDate == null || firstAirDate!.isEmpty) {
      return 'TBA';
    }
    return firstAirDate!.substring(0, 4);
  }

  String get formattedRating => voteAverage.toStringAsFixed(1);

  String get originCountryText =>
      originCountry.isNotEmpty ? originCountry.join(', ') : 'Unknown';

  String get formattedRuntime {
    if ( episodeRunTime!.isEmpty) {
      return 'Unknown';
    }

    final avgRuntime =
        episodeRunTime!.reduce((a, b) => a + b) / episodeRunTime!.length;
    final hours = avgRuntime ~/ 60;
    final minutes = avgRuntime.toInt() % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  String get formattedStatus {
    if (status == null) return 'Unknown';

    switch (status) {
      case 'Returning Series':
        return 'Currently Airing';
      case 'Ended':
        return 'Ended';
      case 'Canceled':
        return 'Canceled';
      case 'In Production':
        return 'In Production';
      default:
        return status!;
    }
  }

  String get airDateRange {
    if (firstAirDate == null) return 'TBA';

    final start = firstAirDate!;
    final end = inProduction == true ? 'Present' : (lastAirDate );

    return '$start - $end';
  }

  List<String> get genreNames {
    if (genres != null) {
      return genres!.map((genre) => genre.name).toList();
    } else if (genreIds.isNotEmpty) {
      return genreIds.map((id) => _getGenreName(id)).toList();
    }
    return ['Unknown'];
  }

  String _getGenreName(int genreId) {
    final Map<int, String> genres = {
      10759: 'Action & Adventure',
      16: 'Animation',
      35: 'Comedy',
      80: 'Crime',
      99: 'Documentary',
      18: 'Drama',
      10751: 'Family',
      10762: 'Kids',
      9648: 'Mystery',
      10763: 'News',
      10764: 'Reality',
      10765: 'Sci-Fi & Fantasy',
      10766: 'Soap',
      10767: 'Talk',
      10768: 'War & Politics',
      37: 'Western',
    };

    return genres[genreId] ?? 'No Info About Genres Exist!!';
  }
}

class Season {
  final String? airDate;
  final int episodeCount;
  final int id;
  final String name;
  final String? overview;
  final String? posterPath;
  final int seasonNumber;
  final double voteAverage;

  Season({
   required this.airDate,
    required this.episodeCount,
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
    required this.seasonNumber,
    required this.voteAverage,
  });

  factory Season.fromJson(Map<String, dynamic> json) {
    return Season(
      airDate: json['air_date'],
      episodeCount: json['episode_count'],
      id: json['id'] ,
      name: json['name'] ,
      overview: json['overview'],
      posterPath: json['poster_path'],
      seasonNumber: json['season_number'] ,
      voteAverage: (json['vote_average']).toDouble(),
    );
  }

  String get fullPosterPath => posterPath != null
      ? 'https://inosdb.worker-inosuke.workers.dev/w500$posterPath'
      : 'https://inosdb.worker-inosuke.workers.dev/w500$posterPath';

  String get formattedAirDate {
    if (airDate == null || airDate!.isEmpty) return 'TBA';
    return airDate!;
  }

  String get year {
    if (airDate == null || airDate!.isEmpty) return 'TBA';
    if (airDate!.length < 4) return airDate!;
    return airDate!.substring(0, 4);
  }
}

class Episode {
  final int id;
  final String name;
  final String overview;
  final double voteAverage;
  final int voteCount;
  final String? airDate;
  final int episodeNumber;
  final String episodeType;
  final String? productionCode;
  final int? runtime;
  final int seasonNumber;
  final int showId;
  final String? stillPath;

  Episode({
    required this.id,
    required this.name,
    required this.overview,
    required this.voteAverage,
    required this.voteCount,
   required this.airDate,
    required this.episodeNumber,
    required this.episodeType,
   required this.productionCode,
   required this.runtime,
    required this.seasonNumber,
    required this.showId,
   required this.stillPath,
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      id: json['id'],
      name: json['name'],
      overview: json['overview'],
      voteAverage: (json['vote_average']).toDouble(),
      voteCount: json['vote_count'],
      airDate: json['air_date'],
      episodeNumber: json['episode_number'],
      episodeType: json['episode_type'] ,
      productionCode: json['production_code'],
      runtime: json['runtime'],
      seasonNumber: json['season_number'],
      showId: json['show_id'],
      stillPath: json['still_path'],
    );
  }

  String get fullStillPath => stillPath != null
      ? 'https://inosdb.worker-inosuke.workers.dev/w500$stillPath'
      : 'https://inosdb.worker-inosuke.workers.dev/w500$stillPath';

  String get formattedAirDate {
    if (airDate == null || airDate!.isEmpty) return 'TBA';
    return airDate!;
  }

  String get formattedEpisodeType {
    switch (episodeType) {
      case 'finale':
        return 'Season Finale';
      case 'mid_season':
        return 'Mid-Season';
      case 'premiere':
        return 'Season Premiere';
      case 'special':
        return 'Special';
      default:
        return 'Standard';
    }
  }

  String get formattedRuntime {
    if (runtime == null) return 'No Info About Runtime Exist';

    final hours = runtime! ~/ 60;
    final minutes = runtime! % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}

class Creator {
  final int id;
  final String creditId;
  final String name;
  final String originalName;
  final int gender;
  final String? profilePath;

  Creator({
    required this.id,
    required this.creditId,
    required this.name,
    required this.originalName,
    required this.gender,
    this.profilePath,
  });

  factory Creator.fromJson(Map<String, dynamic> json) {
    return Creator(
      id: json['id'],
      creditId: json['credit_id'],
      name: json['name'],
      originalName: json['original_name'],
      gender: json['gender'],
      profilePath: json['profile_path'],
    );
  }

  String get fullProfilePath => profilePath != null
      ? 'https://inosdb.worker-inosuke.workers.dev/w500$profilePath'
      : 'https://inosdb.worker-inosuke.workers.dev/w500$profilePath';

  String get genderText {
    switch (gender) {
      case 1:
        return 'Female';
      case 2:
        return 'Male';
      default:
        return 'Not specified';
    }
  }
}

class Network {
  final int id;
  final String? logoPath;
  final String name;
  final String originCountry;

  Network({
    required this.id,
    required this.logoPath,
    required this.name,
    required this.originCountry,
  });

  factory Network.fromJson(Map<String, dynamic> json) {
    return Network(
      id: json['id'],
      logoPath: json['logo_path'],
      name: json['name'],
      originCountry: json['origin_country'],
    );
  }

  String get fullLogoPath => logoPath != null
      ? 'https://inosdb.worker-inosuke.workers.dev/w500$logoPath'
      : 'https://inosdb.worker-inosuke.workers.dev/w300$logoPath';
}

class Genre {
  final int id;
  final String name;

  Genre({
    required this.id,
    required this.name,
  });

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}

class ProductionCompany {
  final int id;
  final String? logoPath;
  final String name;
  final String originCountry;

  ProductionCompany({
    required this.id,
    required this.logoPath,
    required this.name,
    required this.originCountry,
  });

  factory ProductionCompany.fromJson(Map<String, dynamic> json) {
    return ProductionCompany(
      id: json['id'],
      logoPath: json['logo_path'],
      name: json['name'] ,
      originCountry: json['origin_country'],
    );
  }

  String get fullLogoPath => logoPath != null
      ? 'https://inosdb.worker-inosuke.workers.dev/w500$logoPath'
      : 'https://inosdb.worker-inosuke.workers.dev/w500$logoPath';
}

class ProductionCountry {
  final String iso31661;
  final String name;

  ProductionCountry({
    required this.iso31661,
    required this.name,
  });

  factory ProductionCountry.fromJson(Map<String, dynamic> json) {
    return ProductionCountry(
      iso31661: json['iso_3166_1'],
      name: json['name'],
    );
  }
}

class SpokenLanguage {
  final String englishName;
  final String iso6391;
  final String name;

  SpokenLanguage({
    required this.englishName,
    required this.iso6391,
    required this.name,
  });

  factory SpokenLanguage.fromJson(Map<String, dynamic> json) {
    return SpokenLanguage(
      englishName: json['english_name'],
      iso6391: json['iso_639_1'],
      name: json['name'],
    );
  }
}

class TvShowResponse {
  final int page;
  final List<TvShow> results;
  final int totalPages;
  final int totalResults;

  TvShowResponse({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory TvShowResponse.fromJson(Map<String, dynamic> json) {
    return TvShowResponse(
      page: json['page'] ?? 1,
      results: (json['results'] as List?)
              ?.map((show) => TvShow.fromJson(show))
              .toList() ??
          [],
      totalPages: json['total_pages'],
      totalResults: json['total_results'],
    );
  }
}

class SeasonDetails {
  final String? id;
  final String? airDate;
  final List<Episode> episodes;

  SeasonDetails({
    this.id,
    this.airDate,
    required this.episodes,
  });

  factory SeasonDetails.fromJson(Map<String, dynamic> json) {
    return SeasonDetails(
      id: json['_id'],
      airDate: json['air_date'],
      episodes: (json['episodes'] as List)
          .map((episode) => Episode.fromJson(episode))
          .toList(),
    );
  }
}

//class Episode {
//   final String airDate;
//   final int episodeNumber;
//   final String episodeType;
//   final int id;
//   final String name;
//   final String overview;
//   final int runtime;
//   final int seasonNumber;
//   final int showId;
//   final String? stillPath;
//   final double voteAverage;
//   final int voteCount;
//   final List<CrewMember> crew;
//   final List<GuestStar> guestStars;

//   Episode({
//     required this.airDate,
//     required this.episodeNumber,
//     required this.episodeType,
//     required this.id,
//     required this.name,
//     required this.overview,
//     required this.runtime,
//     required this.seasonNumber,
//     required this.showId,
//     this.stillPath,
//     required this.voteAverage,
//     required this.voteCount,
//     required this.crew,
//     required this.guestStars,
//   });

//   factory Episode.fromJson(Map<String, dynamic> json) {
//     return Episode(
//       airDate: json['air_date'],
//       episodeNumber: json['episode_number'],
//       episodeType: json['episode_type'],
//       id: json['id'],
//       name: json['name'],
//       overview: json['overview'],
//       runtime: json['runtime'],
//       seasonNumber: json['season_number'],
//       showId: json['show_id'],
//       stillPath: json['still_path'],
//       voteAverage: json['vote_average'].toDouble(),
//       voteCount: json['vote_count'],
//       crew: (json['crew'] as List)
//           .map((crew) => CrewMember.fromJson(crew))
//           .toList(),
//       guestStars: (json['guest_stars'] as List)
//           .map((star) => GuestStar.fromJson(star))
//           .toList(),
//     );
//   }
// }

class CrewMember {
  final String job;
  final String department;
  final String creditId;
  final int id;
  final String name;
  final String? profilePath;

  CrewMember({
    required this.job,
    required this.department,
    required this.creditId,
    required this.id,
    required this.name,
   required this.profilePath,
  });

  factory CrewMember.fromJson(Map<String, dynamic> json) {
    return CrewMember(
      job: json['job'],
      department: json['department'],
      creditId: json['credit_id'],
      id: json['id'],
      name: json['name'],
      profilePath: json['profile_path'],
    );
  }
}

class GuestStar {
  final String character;
  final int id;
  final String name;
  final String? profilePath;

  GuestStar({
    required this.character,
    required this.id,
    required this.name,
   required this.profilePath,
  });

  factory GuestStar.fromJson(Map<String, dynamic> json) {
    return GuestStar(
      character: json['character'],
      id: json['id'],
      name: json['name'],
      profilePath: json['profile_path'],
    );
  }
}

class YoutubeVideoForSeries {
  final int id;
  final List<VideoForSeries> results;

  YoutubeVideoForSeries({required this.id, required this.results});

  factory YoutubeVideoForSeries.fromJson(Map<String, dynamic> json) {
    return YoutubeVideoForSeries(
      id: json['id'],
      results: (json['results'] as List)
          .map((video) => VideoForSeries.fromJson(video))
          .toList(),
    );
  }
}

class VideoForSeries {
  final String? language;
  final String? country;
  final String name;
  final String key;
  final String publishedAt;
  final String site;
  final int size;
  final String type;
  final bool official;
  final String id;

  VideoForSeries({
    this.language,
    this.country,
    required this.name,
    required this.key,
    required this.publishedAt,
    required this.site,
    required this.size,
    required this.type,
    required this.official,
    required this.id,
  });

  factory VideoForSeries.fromJson(Map<String, dynamic> json) {
    return VideoForSeries(
      language: json['iso_639_1'],
      country: json['iso_3166_1'],
      name: json['name'],
      key: json['key'],
      publishedAt: json['published_at'],
      site: json['site'],
      size: json['size'],
      type: json['type'],
      official: json['official'],
      id: json['id'],
    );
  }

  // Helper method to get YouTube URL
  String get youtubeUrl => 'https://www.youtube.com/watch?v=$key';
}

class EpisodeDetails {
  final String airDate;
  final int episodeNumber;
  final String episodeType;
  final int id;
  final String name;
  final String overview;
  final int? runtime;
  final int seasonNumber;
  final String? stillPath;
  final double voteAverage;
  final int voteCount;
  final List<CrewMember> crew;
  final List<GuestStar> guestStars;

  EpisodeDetails({
    required this.airDate,
    required this.episodeNumber,
    required this.episodeType,
    required this.id,
    required this.name,
    required this.overview,
    required this.runtime,
    required this.seasonNumber,
    required this.stillPath,
    required this.voteAverage,
    required this.voteCount,
    required this.crew,
    required this.guestStars,
  });

  factory EpisodeDetails.fromJson(Map<String, dynamic> json) {
    return EpisodeDetails(
      airDate: json['air_date'],
      episodeNumber: json['episode_number'],
      episodeType: json['episode_type'],
      id: json['id'],
      name: json['name'],
      overview: json['overview'],
      runtime: json['runtime'],
      seasonNumber: json['season_number'],
      stillPath: json['still_path'],
      voteAverage: json['vote_average']?.toDouble(),
      voteCount: json['vote_count'],
      crew: (json['crew'] as List?)
              ?.map((crewJson) => CrewMember.fromJson(crewJson))
              .toList() ??
          [],
      guestStars: (json['guest_stars'] as List?)
              ?.map((guestStarJson) => GuestStar.fromJson(guestStarJson))
              .toList() ??
          [],
    );
  }
}

class TVSearchResult {
  final int id;
  final String name;
  final String originalName;
  final String? overview;
  final String? backdropPath;
  final String? posterPath;
  final List<int> genreIds;
  final List<String> originCountry;
  final String originalLanguage;
  final bool adult;
  final double popularity;
  final String? firstAirDate;
  final double voteAverage;
  final int voteCount;

  TVSearchResult({
    required this.id,
    required this.name,
    required this.originalName,
    this.overview,
    this.backdropPath,
    this.posterPath,
    this.genreIds = const [],
    this.originCountry = const [],
    required this.originalLanguage,
    this.adult = false,
    this.popularity = 0.0,
    this.firstAirDate,
    this.voteAverage = 0.0,
    this.voteCount = 0,
  });

  factory TVSearchResult.fromJson(Map<String, dynamic> json) {
    return TVSearchResult(
      id: json['id'],
      name: json['name'] ,
      originalName: json['original_name'],
      overview: json['overview'],
      backdropPath: json['backdrop_path'],
      posterPath: json['poster_path'],
      genreIds: List<int>.from(json['genre_ids'] ),
      originCountry: List<String>.from(json['origin_country'] ),
      originalLanguage: json['original_language'] ,
      adult: json['adult'] ?? false,
      popularity: json['popularity']?.toDouble(),
      firstAirDate: json['first_air_date'],
      voteAverage: json['vote_average']?.toDouble() ,
      voteCount: json['vote_count'] ?? 0,
    );
  }

  // Convenience methods
  String get formattedFirstAirDate {
    if (firstAirDate == null) return 'Unknown';
    try {
      final date = DateTime.parse(firstAirDate!);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return firstAirDate!;
    }
  }

  String get truncatedOverview {
    if (overview == null) return 'No overview available';
    return overview!.length > 200
        ? '${overview!.substring(0, 200)}...'
        : overview!;
  }
}

class TVSearchResponse {
  final int page;
  final List<TVSearchResult> results;
  final int totalPages;
  final int totalResults;

  TVSearchResponse({
    required this.page,
    required this.results,
    this.totalPages = 0,
    this.totalResults = 0,
  });

  factory TVSearchResponse.fromJson(Map<String, dynamic> json) {
    return TVSearchResponse(
      page: json['page'] ?? 1,
      results: (json['results'] as List?)
              ?.map((tvJson) => TVSearchResult.fromJson(tvJson))
              .toList() ??
          [],
      totalPages: json['total_pages'] ?? 0,
      totalResults: json['total_results'] ?? 0,
    );
  }
}

class TVCredits {
  final List<Cast> cast;
  final List<Crew> crew;

  TVCredits({
    required this.cast,
    required this.crew,
  });

  factory TVCredits.fromJson(Map<String, dynamic> json) {
    return TVCredits(
      cast: (json['cast'] as List?)
              ?.map((castJson) => Cast.fromJson(castJson))
              .toList() ??
          [],
      crew: (json['crew'] as List?)
              ?.map((crewJson) => Crew.fromJson(crewJson))
              .toList() ??
          [],
    );
  }
}

class TVCast {
  final int id;
  final String name;
  final String originalName;
  final String profilePath;
  final String character;
  final int order;
  final String creditId;
  final String knownForDepartment;
  final int gender;
  final bool adult;
  final double popularity;

  TVCast({
    required this.id,
    required this.name,
    required this.originalName,
    required this.profilePath,
    required this.character,
    required this.order,
    required this.creditId,
    required this.knownForDepartment,
    required this.gender,
    required this.adult,
    required this.popularity,
  });

  factory TVCast.fromJson(Map<String, dynamic> json) {
    return TVCast(
      id: json['id'],
      name: json['name'] ,
      originalName: json['original_name'],
      profilePath: json['profile_path'],
      character: json['character'],
      order: json['order'],
      creditId: json['credit_id'],
      knownForDepartment: json['known_for_department'] ,
      gender: json['gender'] ?? 0,
      adult: json['adult'] ?? false,
      popularity: json['popularity']?.toDouble() ?? 0.0,
    );
  }

  String get profileImageUrl {
    return profilePath != null
        ? 'https://inosdb.worker-inosuke.workers.dev/w500$profilePath'
        : 'https://inosdb.worker-inosuke.workers.dev/w500$profilePath';
  }

  String get genderString {
    switch (gender) {
      case 1:
        return 'Female';
      case 2:
        return 'Male';
      default:
        return 'Unknown';
    }
  }
}

class TVCrew {
  final int id;
  final String name;
  final String originalName;
  final String? profilePath;
  final String department;
  final String job;
  final String creditId;
  final int gender;
  final bool adult;
  final double popularity;

  TVCrew({
    required this.id,
    required this.name,
    required this.originalName,
    this.profilePath,
    required this.department,
    required this.job,
    required this.creditId,
    required this.gender,
    required this.adult,
    required this.popularity,
  });

  factory TVCrew.fromJson(Map<String, dynamic> json) {
    return TVCrew(
      id: json['id'],
      name: json['name'] ?? json['name'],
      originalName: json['original_name'] ?? json['original_name'],
      profilePath: json['profile_path'],
      department: json['department'],
      job: json['job'],
      creditId: json['credit_id'],
      gender: json['gender'],
      adult: json['adult'] ?? false,
      popularity: json['popularity']?.toDouble(),
    );
  }

  String get profileImageUrl {
    return profilePath != null
        ? 'https://inosdb.worker-inosuke.workers.dev/w500$profilePath'
        : 'https://inosdb.worker-inosuke.workers.dev/w500$profilePath';
  }
}


// class Genre {
//   final int id;
//   final String name;

//   Genre({
//     required this.id,
//     required this.name,
//   });

//   factory Genre.fromJson(Map<String, dynamic> json) {
//     return Genre(
//       id: json['id'] ?? 0,
//       name: json['name'] ?? '',
//     );
//   }
// }

class Person {
  final bool adult;
  final List<String>? alsoKnownAs;
  final String? biography;
  final String? birthday;
  final String? deathday;
  final int gender;
  final String? homepage;
  final int id;
  final String? imdbId;
  final String knownForDepartment;
  final String name;
  final String? placeOfBirth;
  final double popularity;
  final String? profilePath;

  Person({
    required this.adult,
    this.alsoKnownAs,
    this.biography,
    this.birthday,
    this.deathday,
    required this.gender,
    this.homepage,
    required this.id,
    this.imdbId,
    required this.knownForDepartment,
    required this.name,
    this.placeOfBirth,
    required this.popularity,
    this.profilePath,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      adult: json['adult'] ?? false,
      alsoKnownAs: json['also_known_as'] != null
          ? List<String>.from(json['also_known_as'])
          : null,
      biography: json['biography'],
      birthday: json['birthday'],
      deathday: json['deathday'],
      gender: json['gender'] ?? 0,
      homepage: json['homepage'],
      id: json['id'] ?? 0,
      imdbId: json['imdb_id'],
      knownForDepartment: json['known_for_department'] ?? '',
      name: json['name'] ?? '',
      placeOfBirth: json['place_of_birth'],
      popularity: (json['popularity'] ?? 0.0).toDouble(),
      profilePath: json['profile_path'],
    );
  }

  String get fullProfilePath => profilePath != null
      ? 'https://inosdb.worker-inosuke.workers.dev/w500$profilePath'
      : 'https://inosdb.worker-inosuke.workers.dev/w500$profilePath';

  String get genderText {
    switch (gender) {
      case 1:
        return 'Female';
      case 2:
        return 'Male';
      default:
        return 'Not specified';
    }
  }

  String get formattedBirthday {
    if (birthday == null) return 'Unknown';

    final parts = birthday!.split('-');
    if (parts.length != 3) return birthday!;

    final year = parts[0];
    final month = _getMonthName(int.parse(parts[1]));
    final day = int.parse(parts[2]);

    return '$month $day, $year';
  }

  String get age {
    if (birthday == null) return 'Unknown';

    final birthDate = DateTime.parse(birthday!);
    final today = DateTime.now();

    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }

    if (deathday != null) {
      final deathDate = DateTime.parse(deathday!);
      age = deathDate.year - birthDate.year;
      if (deathDate.month < birthDate.month ||
          (deathDate.month == birthDate.month &&
              deathDate.day < birthDate.day)) {
        age--;
      }
      return '$age (Deceased)';
    }

    return '$age years old';
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }
}

class Cast {
   final int id;
  final String name;
  final String originalName;
  final String profilePath;
  final String character;
  final int order;
  final String creditId;
  final String knownForDepartment;
  final int gender;
  final bool adult;
  final double popularity;

  Cast({
    required this.adult,
    required this.gender,
    required this.id,
    required this.knownForDepartment,
    required this.name,
    required this.originalName,
    required this.popularity,
    required this.profilePath,
   // required this.castId,
    required this.character,
    required this.creditId,
    required this.order,
  });

  factory Cast.fromJson(Map<String, dynamic> json) {
    return Cast(
      adult: json['adult'] ?? false,
      gender: json['gender'] ?? 0,
      id: json['id'] ?? 0,
      knownForDepartment: json['known_for_department'] ?? '',
      name: json['name'] ?? '',
      originalName: json['original_name'] ?? '',
      popularity: (json['popularity'] ?? 0.0).toDouble(),
      profilePath: json['profile_path'],
     // castId: json['cast_id'] ?? 0,
      character: json['character'] ?? '',
      creditId: json['credit_id'] ?? '',
      order: json['order'] ?? 0,
    );
  }

  String get fullProfilePath => profilePath != null
      ? 'https://inosdb.worker-inosuke.workers.dev/w500$profilePath'
      : 'https://inosdb.worker-inosuke.workers.dev/w500$profilePath';

  String get genderText {
    switch (gender) {
      case 1:
        return 'Female';
      case 2:
        return 'Male';
      default:
        return 'Not specified';
    }
  }
}

class Crew {
  final bool adult;
  final int gender;
  final int id;
  final String knownForDepartment;
  final String name;
  final String originalName;
  final double popularity;
  final String? profilePath;
  final String creditId;
  final String department;
  final String job;

  Crew({
    required this.adult,
    required this.gender,
    required this.id,
    required this.knownForDepartment,
    required this.name,
    required this.originalName,
    required this.popularity,
    this.profilePath,
    required this.creditId,
    required this.department,
    required this.job,
  });

  factory Crew.fromJson(Map<String, dynamic> json) {
    return Crew(
      adult: json['adult'] ?? false,
      gender: json['gender'] ?? 0,
      id: json['id'] ?? 0,
      knownForDepartment: json['known_for_department'] ?? '',
      name: json['name'] ?? '',
      originalName: json['original_name'] ?? '',
      popularity: (json['popularity'] ?? 0.0).toDouble(),
      profilePath: json['profile_path'],
      creditId: json['credit_id'] ?? '',
      department: json['department'] ?? '',
      job: json['job'] ?? '',
    );
  }

  String get fullProfilePath => profilePath != null
      ? 'https://inosdb.worker-inosuke.workers.dev/w500$profilePath'
      : 'https://inosdb.worker-inosuke.workers.dev/w500$profilePath';
}

class MovieCredits {
  final int id;
  final List<Cast> cast;
  final List<Crew> crew;

  MovieCredits({
    required this.id,
    required this.cast,
    required this.crew,
  });

  factory MovieCredits.fromJson(Map<String, dynamic> json) {
    return MovieCredits(
      id: json['id'] ?? 0,
      cast: (json['cast'] as List?)
              ?.map((castMember) => Cast.fromJson(castMember))
              .toList() ??
          [],
      crew: (json['crew'] as List?)
              ?.map((crewMember) => Crew.fromJson(crewMember))
              .toList() ??
          [],
    );
  }

  // Get directors from crew
  List<Crew> get directors {
    return crew.where((crewMember) => crewMember.job == 'Director').toList();
  }

  // Get writers from crew (Screenplay, Writer, etc.)
  List<Crew> get writers {
    return crew
        .where((crewMember) =>
            crewMember.department == 'Writing' ||
            crewMember.job == 'Screenplay' ||
            crewMember.job == 'Writer' ||
            crewMember.job == 'Story')
        .toList();
  }

  // Get producers from crew
  List<Crew> get producers {
    return crew
        .where((crewMember) =>
            crewMember.department == 'Production' &&
            (crewMember.job == 'Producer' ||
                crewMember.job == 'Executive Producer'))
        .toList();
  }
}

// class ProductionCompany {
//   final int id;
//   final String? logoPath;
//   final String name;
//   final String originCountry;

//   ProductionCompany({
//     required this.id,
//     this.logoPath,
//     required this.name,
//     required this.originCountry,
//   });

//   factory ProductionCompany.fromJson(Map<String, dynamic> json) {
//     return ProductionCompany(
//       id: json['id'] ?? 0,
//       logoPath: json['logo_path'],
//       name: json['name'] ?? '',
//       originCountry: json['origin_country'] ?? '',
//     );
//   }

//   String get fullLogoPath => logoPath != null
//       ? 'https://inosdb.worker-inosuke.workers.dev/w500$logoPath'
//       : 'https://inosdb.worker-inosuke.workers.dev/w500$logoPath';
// }

// class ProductionCountry {
//   final String iso31661;
//   final String name;

//   ProductionCountry({
//     required this.iso31661,
//     required this.name,
//   });

//   factory ProductionCountry.fromJson(Map<String, dynamic> json) {
//     return ProductionCountry(
//       iso31661: json['iso_3166_1'] ?? '',
//       name: json['name'] ?? '',
//     );
//   }
// }

// class SpokenLanguage {
//   final String englishName;
//   final String iso6391;
//   final String name;

//   SpokenLanguage({
//     required this.englishName,
//     required this.iso6391,
//     required this.name,
//   });

//   factory SpokenLanguage.fromJson(Map<String, dynamic> json) {
//     return SpokenLanguage(
//       englishName: json['english_name'] ?? '',
//       iso6391: json['iso_639_1'] ?? '',
//       name: json['name'] ?? '',
//     );
//   }
// }

class Movie {
  final bool adult;
  final String? backdropPath;
  final List<int> genreIds;
  final List<Genre>? genres;
  final int id;
  final String originalLanguage;
  final String originalTitle;
  final String overview;
  final double popularity;
  final String? posterPath;
  final String releaseDate;
  final String title;
  final bool video;
  final double voteAverage;
  final int voteCount;

  // Additional fields from detailed response
  final String? belongsToCollection;
  final int? budget;
  final String? homepage;
  final String? imdbId;
  final List<String>? originCountry;
  final List<ProductionCompany>? productionCompanies;
  final List<ProductionCountry>? productionCountries;
  final int? revenue;
  final int? runtime;
  final List<SpokenLanguage>? spokenLanguages;
  final String? status;
  final String? tagline;
  final List<Keyword> keywords;
  // Flag to indicate if this is a detailed movie object
  final bool hasDetails;

  Movie({
    required this.adult,
    this.backdropPath,
    required this.genreIds,
    this.genres,
    required this.id,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    this.posterPath,
    required this.releaseDate,
    required this.title,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
    this.belongsToCollection,
    this.budget,
    this.homepage,
    this.imdbId,
    this.originCountry,
    this.productionCompanies,
    this.productionCountries,
    this.revenue,
    this.runtime,
    this.spokenLanguages,
    this.status,
    this.tagline,
    this.hasDetails = false,
    this.keywords = const [],
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    // Check if this is a detailed response
    final bool hasDetails =
        json.containsKey('runtime') || json.containsKey('genres');
    var parsedKeywords = <Keyword>[];
    if (json['keywords'] != null && json['keywords']['keywords'] != null) {
      parsedKeywords = (json['keywords']['keywords'] as List)
          .map((k) => Keyword.fromJson(k))
          .toList();
    } else if (json['keywords'] is List) {
      // На случай, если структура другая
      parsedKeywords =
          (json['keywords'] as List).map((k) => Keyword.fromJson(k)).toList();
    }
    return Movie(
      adult: json['adult'] ?? false,
      backdropPath: json['backdrop_path'],
      // Handle both list formats (genre_ids from list and genres from detailed)
      genreIds: json.containsKey('genre_ids')
          ? List<int>.from(json['genre_ids'] ?? [])
          : (json.containsKey('genres')
              ? (json['genres'] as List?)
                      ?.map((genre) => genre['id'] as int)
                      .toList() ??
                  []
              : []),
      genres: json.containsKey('genres')
          ? (json['genres'] as List?)
              ?.map((genre) => Genre.fromJson(genre))
              .toList()
          : null,

      id: json['id'] ?? 0,
      originalLanguage: json['original_language'] ?? '',
      originalTitle: json['original_title'] ?? '',
      overview: json['overview'] ?? '',
      popularity: (json['popularity'] ?? 0.0).toDouble(),
      posterPath: json['poster_path'],
      releaseDate: json['release_date'] ?? '',
      title: json['title'] ?? '',
      video: json['video'] ?? false,
      voteAverage: (json['vote_average'] ?? 0.0).toDouble(),
      voteCount: json['vote_count'] ?? 0,

      // Additional fields from detailed response
      belongsToCollection: json['belongs_to_collection']?.toString(),
      budget: json['budget'],
      homepage: json['homepage'],
      imdbId: json['imdb_id'],
      originCountry: json.containsKey('origin_country')
          ? List<String>.from(json['origin_country'] ?? [])
          : null,
      productionCompanies: json.containsKey('production_companies')
          ? (json['production_companies'] as List?)
              ?.map((company) => ProductionCompany.fromJson(company))
              .toList()
          : null,
      productionCountries: json.containsKey('production_countries')
          ? (json['production_countries'] as List?)
              ?.map((country) => ProductionCountry.fromJson(country))
              .toList()
          : null,
      revenue: json['revenue'],
      runtime: json['runtime'],
      spokenLanguages: json.containsKey('spoken_languages')
          ? (json['spoken_languages'] as List?)
              ?.map((language) => SpokenLanguage.fromJson(language))
              .toList()
          : null,
      status: json['status'],
      tagline: json['tagline'],
      hasDetails: hasDetails,
      keywords: parsedKeywords
    );
  }

  String get fullPosterPath => posterPath != null
      ? 'https://inosdb.worker-inosuke.workers.dev/w500$posterPath'
      : 'https://inosdb.worker-inosuke.workers.dev/w500$posterPath';

  String get fullBackdropPath => backdropPath != null
      ? 'https://inosdb.worker-inosuke.workers.dev/w780$backdropPath'
      : 'https://inosdb.worker-inosuke.workers.dev/w780$backdropPath';

  String get formattedRuntime {
    if (runtime == null || runtime == 0) return 'N/A';
    final hours = runtime! ~/ 60;
    final minutes = runtime! % 60;
    return hours > 0 ? '${hours}h ${minutes}m' : '${minutes}m';
  }

  String get formattedBudget {
    if (budget == null || budget == 0) return 'N/A';
    return '\$${(budget! / 1000000).toStringAsFixed(1)}M';
  }

  String get formattedRevenue {
    if (revenue == null || revenue == 0) return 'N/A';
    return '\$${(revenue! / 1000000).toStringAsFixed(1)}M';
  }

  String get genresText {
    if (genres == null || genres!.isEmpty) return 'N/A';
    return genres!.map((genre) => genre.name).join(', ');
  }
}

class MovieResponse {
  final int page;
  final List<Movie> results;
  final int totalPages;
  final int totalResults;

  MovieResponse({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory MovieResponse.fromJson(Map<String, dynamic> json) {
    return MovieResponse(
      page: json['page'] ?? 1,
      results: (json['results'] as List?)
              ?.map((movie) => Movie.fromJson(movie))
              .toList() ??
          [],
      totalPages: json['total_pages'] ?? 0,
      totalResults: json['total_results'] ?? 0,
    );
  }
}

class SearchResponse {
  final int page;
  final List<Movie> results;
  final int totalPages;
  final int totalResults;
  final String releaseDate;

  SearchResponse({
    required this.page,
    required this.results,
    this.totalPages = 0,
    this.totalResults = 0,
    this.releaseDate = "4:20",
  });

  factory SearchResponse.fromJson(Map<String, dynamic> json) {
    return SearchResponse(
      page: json['page'] ?? 1,
      results: (json['results'] as List?)
              ?.map((movieJson) => Movie.fromJson(movieJson))
              .toList() ??
          [],
      totalPages: json['total_pages'] ?? 1,
      totalResults: json['total_results'] ?? 0,
    );
  }
}

enum MediaType { movie, tv, person }

abstract class MultiSearchResult {
  final int id;
  final String name;
  final String originalName;
  final MediaType mediaType;
  final bool adult;
  final double popularity;
  final String? profilePath;
  final String? posterPath;
  final String? backdropPath;

  MultiSearchResult({
    required this.id,
    required this.name,
    required this.originalName,
    required this.mediaType,
    required this.adult,
    required this.popularity,
    this.profilePath,
    this.posterPath,
    this.backdropPath,
  });
}

class MultiSearchMovie extends MultiSearchResult {
  final String title;
  final String originalTitle;
  final String? overview;
  final String? releaseDate;
  final List<int> genreIds;
  final double voteAverage;
  final int voteCount;
  final bool video;
  final String? originalLanguage;

  MultiSearchMovie({
    required super.id,
    required super.name,
    required super.originalName,
    required super.mediaType,
    required super.adult,
    required super.popularity,
    super.posterPath,
    super.backdropPath,
    required this.title,
    required this.originalTitle,
    this.overview,
    this.releaseDate,
    this.genreIds = const [],
    this.voteAverage = 0.0,
    this.voteCount = 0,
    this.video = false,
    this.originalLanguage,
  });

  factory MultiSearchMovie.fromJson(Map<String, dynamic> json) {
    return MultiSearchMovie(
      id: json['id'],
      name: json['title'] ?? json['name'] ?? '',
      originalName: json['original_title'] ?? json['original_name'] ?? '',
      mediaType: MediaType.movie,
      adult: json['adult'] ?? false,
      popularity: json['popularity']?.toDouble() ?? 0.0,
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'],
      title: json['title'] ?? '',
      originalTitle: json['original_title'] ?? '',
      overview: json['overview'],
      releaseDate: json['release_date'],
      genreIds: List<int>.from(json['genre_ids'] ?? []),
      voteAverage: json['vote_average']?.toDouble() ?? 0.0,
      voteCount: json['vote_count'] ?? 0,
      video: json['video'] ?? false,
      originalLanguage: json['original_language'],
    );
  }
}

class MultiSearchTV extends MultiSearchResult {
  final String? overview;
  final String? firstAirDate;
  final List<int> genreIds;
  final double voteAverage;
  final int voteCount;
  final List<String> originCountry;
  final String? originalLanguage;
  final bool video;

  MultiSearchTV({
    required super.id,
    required super.name,
    required super.originalName,
    required super.mediaType,
    required super.adult,
    required super.popularity,
    super.posterPath,
    super.backdropPath,
    this.overview,
    this.firstAirDate,
    this.genreIds = const [],
    this.voteAverage = 0.0,
    this.voteCount = 0,
    this.originCountry = const [],
    this.originalLanguage,
        this.video = false,

  });

  factory MultiSearchTV.fromJson(Map<String, dynamic> json) {
    return MultiSearchTV(
      id: json['id'],
      name: json['name'] ?? '',
      originalName: json['original_name'] ?? '',
      mediaType: MediaType.tv,
      adult: json['adult'] ?? false,
      popularity: json['popularity']?.toDouble() ?? 0.0,
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'],
      overview: json['overview'],
      firstAirDate: json['first_air_date'],
      genreIds: List<int>.from(json['genre_ids'] ?? []),
      voteAverage: json['vote_average']?.toDouble() ?? 0.0,
      voteCount: json['vote_count'] ?? 0,
      originCountry: List<String>.from(json['origin_country'] ?? []),
      originalLanguage: json['original_language'],
            video: json['video'] ?? false,

    );
  }
}

class MultiSearchPerson extends MultiSearchResult {
  final int? gender;
  final String? knownForDepartment;
  final List<dynamic> knownFor;

  MultiSearchPerson({
    required super.id,
    required super.name,
    required super.originalName,
    required super.mediaType,
    required super.adult,
    required super.popularity,
    super.profilePath,
    this.gender,
    this.knownForDepartment,
    this.knownFor = const [],
  });

  factory MultiSearchPerson.fromJson(Map<String, dynamic> json) {
    return MultiSearchPerson(
      id: json['id'],
      name: json['name'] ?? '',
      originalName: json['original_name'] ?? '',
      mediaType: MediaType.person,
      adult: json['adult'] ?? false,
      popularity: json['popularity']?.toDouble() ?? 0.0,
      profilePath: json['profile_path'],
      gender: json['gender'],
      knownForDepartment: json['known_for_department'],
      knownFor: json['known_for'] ?? [],
    );
  }
}

class MultiSearchResponse {
  final int page;
  final List<MultiSearchResult> results;
  final int totalPages;
  final int totalResults;

  MultiSearchResponse({
    required this.page,
    required this.results,
    this.totalPages = 0,
    this.totalResults = 0,
  });

  factory MultiSearchResponse.fromJson(Map<String, dynamic> json) {
    return MultiSearchResponse(
      page: json['page'] ?? 1,
      results: (json['results'] as List?)?.map((result) {
            switch (result['media_type']) {
              case 'movie':
                return MultiSearchMovie.fromJson(result);
              case 'tv':
                return MultiSearchTV.fromJson(result);
              case 'person':
                return MultiSearchPerson.fromJson(result);
              default:
                throw Exception('Unknown media type');
            }
          }).toList() ??
          [],
      totalPages: json['total_pages'] ?? 0,
      totalResults: json['total_results'] ?? 0,
    );
  }
}

class Keyword {
  final int id;
  final String name;

  Keyword({
    required this.id,
    required this.name,
  });

  factory Keyword.fromJson(Map<String, dynamic> json) {
    return Keyword(
      id: json['id'],
      name: json['name'],
    );
  }
}

class KeywordSearchResponse {
  final int page;
  final List<Keyword> results;
  final int totalPages;
  final int totalResults;

  KeywordSearchResponse({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory KeywordSearchResponse.fromJson(Map<String, dynamic> json) {
    return KeywordSearchResponse(
      page: json['page'] ?? 1,
      results: (json['results'] as List?)
              ?.map((keywordJson) => Keyword.fromJson(keywordJson))
              .toList() ??
          [],
      totalPages: json['total_pages'] ?? 0,
      totalResults: json['total_results'] ?? 0,
    );
  }
}

class KeywordMoviesResponse {
  final int id;
  final int page;
  final List<Movie> results;
  final int totalPages;
  final int totalResults;

  KeywordMoviesResponse({
    required this.id,
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory KeywordMoviesResponse.fromJson(Map<String, dynamic> json) {
    return KeywordMoviesResponse(
      id: json['id'],
      page: json['page'] ?? 1,
      results: (json['results'] as List?)
              ?.map((movieJson) => Movie.fromJson(movieJson))
              .toList() ??
          [],
      totalPages: json['total_pages'] ?? 0,
      totalResults: json['total_results'] ?? 0,
    );
  }
}
