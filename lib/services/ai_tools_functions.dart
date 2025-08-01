part of 'ai_chat_service.dart';


// Assume Movie is a class with properties: id, title, overview, releaseDate, voteAverage, fullPosterPath
class MovieToolRes {
  final int id;
  final String fullPosterPath;
  final String title;
  final String overview;
  final String releaseDate;
  final double voteAverage;

  MovieToolRes({
    required this.id,
    required this.fullPosterPath,
    required this.title,
    required this.overview,
    required this.releaseDate,
    required this.voteAverage,
  });
}

// --- Function to generate the list of maps ---
List<Map<String, dynamic>> getMovieListAsMap(MovieResponse movies) {
  return movies.results.map((movie) {
    return {
      'id': movie.id,
      'posterPath': movie.fullPosterPath,
      'title': movie.title,
      'overview': movie.overview,
      'release_date': movie.releaseDate,
      'vote_average': movie.voteAverage,
    };
  }).toList();
}
List<Map<String, dynamic>> getTVListAsMap(TvShowResponse movies) {
  return movies.results.map((movie) {
    return {
      'id': movie.id,
      'posterPath': movie.fullPosterPath,
      'title': movie.name,
      'overview': movie.overview,
      'release_date': movie.firstAirDate,
      'vote_average': movie.voteAverage,
    };
  }).toList();
}
List<Map<String, dynamic>> _simplifyCastListMovie(List<Cast> castList) {
  return castList.map((cast) {
    return {
      'id': cast.id,
      'name': cast.name,
      'character': cast.character,
      'profile_path': cast.profilePath,
    };
  }).toList();
}

List<Map<String, dynamic>> _simplifyCrewListMovie(List<Crew> crewList) {
  return crewList.map((crew) {
    return {
      'id': crew.id,
      'name': crew.name,
      'job': crew.job,
      'department': crew.department,
      'profile_path': crew.profilePath,
    };
  }).toList();
}
// --- Function to show the popup ---
List<Map<String, dynamic>> _simplifyCastList(List<TVCast> castList) {
  return castList.map((cast) {
    return {
      'id': cast.id,
      'name': cast.name,
      'character': cast.character,
      'profile_path': cast.profilePath,
    };
  }).toList();
}

List<Map<String, dynamic>> _simplifyCrewList(List<TVCrew> crewList) {
  return crewList.map((crew) {
    return {
      'id': crew.id,
      'name': crew.name,
      'job': crew.job,
      'department': crew.department,
      'profile_path': crew.profilePath,
    };
  }).toList();
}

List<Map<String, dynamic>> _simplifyEpisodeCrewList(List<CrewMember> crewList) {
  return crewList.map((crew) {
    return {
      'id': crew.id,
      'name': crew.name,
      'job': crew.job,
      'department': crew.department,
      'profile_path': crew.profilePath,
    };
  }).toList();
}

List<Map<String, dynamic>> _simplifyGuestStarList(List<GuestStar> guestStarsList) {
  return guestStarsList.map((guest) {
    return {
      'id': guest.id,
      'name': guest.name,
      'character': guest.character,
      'profile_path': guest.profilePath,
    };
  }).toList();
}

Future<Map<String, dynamic>> performWebSearch(String query) async {
  final url = Uri.https('api.duckduckgo.com', '/', {
    'q': query,
    'format': 'json',
  });

  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final topics = data['RelatedTopics'] as List<dynamic>;
    final results = topics
        .map((e) => e['Text'] ?? '')
        .where((t) => t.isNotEmpty)
        .join('\n');

    return {
      "query": query,
      "result": results,
    };
  } else {
    throw Exception('DuckDuckGo request failed: ${response.statusCode}');
  }
}

Future<Map<String, dynamic>> getMovieRecommendationsToolWrapper(
    {required int movieId,
    int? page,
    String? language,
    required bool isMovie}) async {
  if (isMovie) {
    final MovieResponse movieResponse =
        await _movieService.getMovieRecommendations(
      movieId: movieId,
      page: page ?? 1,
      language: language ?? 'en-US',
    );

    final simplifiedResults = movieResponse.results.map((movie) {
      return {
        'id': movie.id,
        'title': movie.title,
        'overview': movie.overview,
        'release_date': movie.releaseDate,
        'vote_average': movie.voteAverage,
      };
    }).toList();

    return {
      "source_movie_id": movieId,
      "page": movieResponse.page,
      "total_pages": movieResponse.totalPages,
      "recommendations": simplifiedResults,
    };
  }else {
  final  TvShowResponse tvResponse = await  _movieService.getTvShowRecommendations(
     tvShowId: movieId, page :page??1,language:language?? 'en-US'); 
     final simplifiedResults = tvResponse.results.map((movie) {
      return {
        'id': movie.id,
        'title': movie.name,
        'overview': movie.overview,
        'release_date': movie.firstAirDate,
        'vote_average': movie.voteAverage,
      };
    }).toList();
 return {
      "source_movie_id": movieId,
      "page": tvResponse.page,
      "total_pages": tvResponse.totalPages,
      "recommendations": simplifiedResults,
    };
  }
}
Future<Map<String, dynamic>> getPopularToolWrapper(String language, int? page , bool isMovie) async{

if (isMovie) {
final  request = await _movieService.getPopularMovies(language: language, page: page??1);

    final simplifiedResults = getMovieListAsMap(request);
    return {
      "source_language": language,
      "page": request.page,
      "total_pages": request.totalPages,
      "popular_list": simplifiedResults,
    };
 }else {
  final  TvShowResponse request = await  _movieService.getPopularTvShows(
      page :page??1,language:language); 
     final simplifiedResults = request.results.map((movie) {
      return {
        'id': movie.id,
        'title': movie.name,
        'overview': movie.overview,
        'release_date': movie.firstAirDate,
        'vote_average': movie.voteAverage,
      };
    }).toList();
  return {
      "source_language": language,
      "page": request.page,
      "total_pages": request.totalPages,
      "popular_list": simplifiedResults,
    };
  }
}

Future<Map<String, dynamic>> getMovieCreditsToolWrapper({
  required int movieId,
  String? language,
}) async {
  final MovieCredits movieCredits = await _movieService.getMovieCredits(
    movieId: movieId,
    language: language ?? 'en-US',
  );

  final simplifiedCast = _simplifyCastListMovie(movieCredits.cast);
  final simplifiedCrew = _simplifyCrewListMovie(movieCredits.crew);

  return {
    "movie_id": movieCredits.id,
    "cast": simplifiedCast,
    "crew": simplifiedCrew,
  };
}

// --- Wrapper for getPersonDetails ---
Future<Map<String, dynamic>> getPersonDetailsToolWrapper({
  required int personId,
  String? language,
}) async {
  final Person personDetails = await _movieService.getPersonDetails(
    personId: personId,
    language: language ?? 'en-US',
  );

  return {
    "person_id": personDetails.id,
    "name": personDetails.name,
    "biography": personDetails.biography,
    "birthday": personDetails.birthday,
    "place_of_birth": personDetails.placeOfBirth,
    "profile_path": personDetails.profilePath,
    "known_for_department": personDetails.knownForDepartment,
    "popularity": personDetails.popularity,
    "also_known_as": personDetails.alsoKnownAs,
  };
}

// --- Wrapper for getTvShowEpisodeDetails ---
Future<Map<String, dynamic>> getTvShowEpisodeDetailsToolWrapper({
  required int tvShowId,
  required int seasonNumber,
  required int episodeNumber,
  String? language,
}) async {
  final EpisodeDetails episodeDetails = await _movieService.getTvShowEpisodeDetails(
    tvShowId: tvShowId,
    seasonNumber: seasonNumber,
    episodeNumber: episodeNumber,
    language: language ?? 'en-US',
  );

  final simplifiedCrew = _simplifyEpisodeCrewList(episodeDetails.crew);
  final simplifiedGuestStars = _simplifyGuestStarList(episodeDetails.guestStars);

  return {
    "tv_show_id": tvShowId,
    "season_number": seasonNumber,
    "episode_number": episodeNumber,
    "episode_details": {
      'id': episodeDetails.id,
      'name': episodeDetails.name,
      'overview': episodeDetails.overview,
      'air_date': episodeDetails.airDate,
      'runtime': episodeDetails.runtime,
      'vote_average': episodeDetails.voteAverage,
      'vote_count': episodeDetails.voteCount,
      'still_path': episodeDetails.stillPath,
      'episode_type': episodeDetails.episodeType,
      // Add any other relevant base Episode fields here
    },
    "crew": simplifiedCrew,
    "guest_stars": simplifiedGuestStars,
  };
}

// --- Wrapper for getTVCredits ---
Future<Map<String, dynamic>> getTVCreditsToolWrapper({
  required int tvId,
  String? language,
}) async {
  final TVCredits tvCredits = await _movieService.getTVCredits(
    tvId: tvId,
    language: language ?? 'en-US',
  );

  final simplifiedCast = _simplifyCastList(tvCredits.cast);
  final simplifiedCrew = _simplifyCrewList(tvCredits.crew);

  return {
    "tv_id": tvId,
    "cast": simplifiedCast,
    "crew": simplifiedCrew,
  };
}