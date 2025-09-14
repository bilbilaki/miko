import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as pr;
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:miko/showcases/movie_detail_page_copy.dart';
import 'package:miko/showcases/tv_detail_page_anime.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';

// Your API models and service
import 'package:miko/showcases/model.dart' as m;
import 'package:miko/showcases/movie_service.dart';

// Local providers (immediate cache/fallback)
import 'package:miko/providers/god_proovider.dart'; // Movie, TvSeriesAnime, movieProvider, tvSeriesProvider, animeProvider
import 'package:miko/services/user_data_service.dart';
import 'package:miko/utils/colors.dart'; // AppColors, AppColors2
// import your existing local cards if you still want to show local fallback
import 'package:miko/widgets/anime_series_card.dart';

final movieServiceProvider = pr.Provider<MovieService>((ref) => MovieService());

// Helper to build full TMDB poster URL from a posterPath
String? _tmdbPoster(String? posterPath) =>
    (posterPath != null && posterPath.isNotEmpty)
        ? 'https://image.tmdb.org/t/p/w500$posterPath'
        : null;

// A small wrapper so we know whether an API item is movie, tvseries, or anime
class ApiItem {
  final String typec; // 'movie' | 'tvseries' | 'anime'
  final Object model; // m.Movie or m.TvShow
  ApiItem({required this.typec, required this.model});
}

class WatchlistScreen extends pr.ConsumerWidget {
  const WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context, pr.WidgetRef ref) {
    final userData = context.watch<UserDataService>();

    // Local providers for instant fallback
    final moviesLocal = ref.read(movieProvider);
    final tvLocal = ref.read(tvSeriesProvider);
    final animeLocal = ref.read(animeProvider);

    final List<Movie> localMovies = userData.watchlistMovieIds
        .map((id) => moviesLocal.getMovieById(id))
        .whereType<Movie>()
        .toList();

    final List<TvSeriesAnime> localTvSeries = userData.watchlistTvSeriesIds
        .map((id) => tvLocal.getAnimeByTmdbId(id))
        .whereType<TvSeriesAnime>()
        .toList();

    final List<TvSeriesAnime> localAnime = userData.watchlistAnimeIds
        .map((id) => animeLocal.getAnimeByTmdbId(id))
        .whereType<TvSeriesAnime>()
        .toList();

    final localAll = _sortedLocal([...localMovies, ...localTvSeries, ...localAnime]);

    final movieService = MovieService();

    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      body: FutureBuilder<List<ApiItem>>(
        future: _fetchWatchlistApi(movieService, userData),
        builder: (context, snapshot) {
          // When API data is ready, show it; otherwise fallback to local while loading
          final bool apiReady = snapshot.connectionState == ConnectionState.done && snapshot.hasData;
          final items = apiReady ? _sortedApi(snapshot.data!) : null;

          if (!apiReady && localAll.isEmpty) {
            return const Center(
              child: SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white70),
              ),
            );
          }

          if (apiReady && items!.isEmpty || (!apiReady && localAll.isEmpty)) {
            return const Center(
              child: Text(
                'Your watchlist is empty.',
                style: TextStyle(color: Color.fromARGB(255, 234, 234, 234)),
              ),
            );
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              int crossAxisCount = 3;
              if (width >= 1600) {
                crossAxisCount = 8;
              } else if (width >= 1200) {
                crossAxisCount = 6;
              } else if (width >= 800) {
                crossAxisCount = 4;
              } else if (width <= 380) {
                crossAxisCount = 2;
              }

              if (apiReady) {
                return MasonryGridView.count(
                  padding: const EdgeInsets.all(8.0),
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                  itemCount: items!.length,
                  itemBuilder: (context, index) {
                    final ai = items[index];
                    if (ai.model is m.Movie) {
                      return MovieCardApi(typec: 'movie', movie: ai.model as m.Movie);
                    } else if (ai.model is m.TvShow) {
                      return AnimeSeriesCardApi(typec: ai.typec, series: ai.model as m.TvShow);
                    }
                    return const SizedBox.shrink();
                  },
                );
              }

              // local fallback
              return MasonryGridView.count(
                padding: const EdgeInsets.all(8.0),
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
                itemCount: localAll.length,
                itemBuilder: (context, index) {
                  final item = localAll[index];
                  if (item is Movie) {
                    return MovieCard(movie: item, typec: 'movie');
                  } else if (item is TvSeriesAnime) {
                    final typec = (item.type.toLowerCase() == 'anime') ? 'anime' : 'tvseries';
                    return AnimeSeriesCard(series: item, typec: typec);
                  }
                  return const SizedBox.shrink();
                },
              );
            },
          );
        },
      ),
    );
  }
}

class FavoritesScreen extends pr.ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, pr.WidgetRef ref) {
    final userData = context.watch<UserDataService>();

    // Local providers for instant fallback
    final moviesLocal = ref.read(movieProvider);
    final tvLocal = ref.read(tvSeriesProvider);
    final animeLocal = ref.read(animeProvider);

    final List<Movie> localMovies = userData.favoriteMovieIds
        .map((id) => moviesLocal.getMovieById(id))
        .whereType<Movie>()
        .toList();

    final List<TvSeriesAnime> localTvSeries = userData.favoriteTvSeriesIds
        .map((id) => tvLocal.getAnimeByTmdbId(id))
        .whereType<TvSeriesAnime>()
        .toList();

    final List<TvSeriesAnime> localAnime = userData.favoriteAnimeIds
        .map((id) => animeLocal.getAnimeByTmdbId(id))
        .whereType<TvSeriesAnime>()
        .toList();

    final localAll = _sortedLocal([...localMovies, ...localTvSeries, ...localAnime]);

    final movieService = MovieService();

    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      body: FutureBuilder<List<ApiItem>>(
        future: _fetchFavoritesApi(movieService, userData),
        builder: (context, snapshot) {
          final bool apiReady = snapshot.connectionState == ConnectionState.done && snapshot.hasData;
          final items = apiReady ? _sortedApi(snapshot.data!) : null;

          if (!apiReady && localAll.isEmpty) {
            return const Center(
              child: SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white70),
              ),
            );
          }

          if (apiReady && items!.isEmpty || (!apiReady && localAll.isEmpty)) {
            return const Center(
              child: Text(
                'No items added to favorites yet.',
                style: TextStyle(color: Color.fromARGB(255, 230, 225, 225)),
              ),
            );
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              int crossAxisCount = 3;
              if (width >= 1600) {
                crossAxisCount = 8;
              } else if (width >= 1200) {
                crossAxisCount = 6;
              } else if (width >= 800) {
                crossAxisCount = 4;
              } else if (width <= 380) {
                crossAxisCount = 2;
              }

              if (apiReady) {
                return MasonryGridView.count(
                  padding: const EdgeInsets.all(8.0),
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                  itemCount: items!.length,
                  itemBuilder: (context, index) {
                    final ai = items[index];
                    if (ai.model is m.Movie) {
                      return MovieCardApi(typec: 'movie', movie: ai.model as m.Movie);
                    } else if (ai.model is m.TvShow) {
                      return AnimeSeriesCardApi(typec: ai.typec, series: ai.model as m.TvShow);
                    }
                    return const SizedBox.shrink();
                  },
                );
              }

              // local fallback
              return MasonryGridView.count(
                padding: const EdgeInsets.all(8.0),
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
                itemCount: localAll.length,
                itemBuilder: (context, index) {
                  final item = localAll[index];
                  if (item is Movie) {
                    return MovieCard(movie: item, typec: 'movie');
                  } else if (item is TvSeriesAnime) {
                    final typec = (item.type.toLowerCase() == 'anime') ? 'anime' : 'tvseries';
                    return AnimeSeriesCard(series: item, typec: typec);
                  }
                  return const SizedBox.shrink();
                },
              );
            },
          );
        },
      ),
    );
  }
}

// --------- API fetching (await) ----------

Future<List<ApiItem>> _fetchWatchlistApi(MovieService service, UserDataService user) async {
  final futures = <Future<List<ApiItem>>>[
    _fetchMovies(service, user.watchlistMovieIds),
    _fetchTvShows(service, user.watchlistTvSeriesIds, 'tvseries'),
    _fetchTvShows(service, user.watchlistAnimeIds, 'anime'),
  ];
  final parts = await Future.wait(futures);
  return parts.expand((e) => e).toList();
}

Future<List<ApiItem>> _fetchFavoritesApi(MovieService service, UserDataService user) async {
  final futures = <Future<List<ApiItem>>>[
    _fetchMovies(service, user.favoriteMovieIds),
    _fetchTvShows(service, user.favoriteTvSeriesIds, 'tvseries'),
    _fetchTvShows(service, user.favoriteAnimeIds, 'anime'),
  ];
  final parts = await Future.wait(futures);
  return parts.expand((e) => e).toList();
}

Future<List<ApiItem>> _fetchMovies(MovieService service, List<int> ids) async {
  if (ids.isEmpty) return [];
  final list = await Future.wait(ids.map((id) => service.getMovieDetails(movieId: id)));
  return list.whereType<m.Movie>().map((mv) => ApiItem(typec: 'movie', model: mv)).toList();
}

Future<List<ApiItem>> _fetchTvShows(MovieService service, List<int> ids, String typec) async {
  if (ids.isEmpty) return [];
  final list = await Future.wait(ids.map((id) => service.getTvShowDetails(tvShowId: id)));
  return list.whereType<m.TvShow>().map((tv) => ApiItem(typec: typec, model: tv)).toList();
}

// --------- Sorting helpers ----------

List<Object> _sortedLocal(List<Object> list) {
  list.sort((a, b) {
    String nameA = a is Movie ? a.title : (a as TvSeriesAnime).name;
    String nameB = b is Movie ? b.title : (b as TvSeriesAnime).name;
    return nameA.toLowerCase().compareTo(nameB.toLowerCase());
  });
  return list;
}

List<ApiItem> _sortedApi(List<ApiItem> list) {
  list.sort((a, b) {
    String nameA = _apiName(a);
    String nameB = _apiName(b);
    return nameA.toLowerCase().compareTo(nameB.toLowerCase());
  });
  return list;
}

String _apiName(ApiItem ai) {
  if (ai.model is m.Movie) {
    final mv = ai.model as m.Movie;
    final title = (tryGet(mv, 'title') ?? tryGet(mv, 'originalTitle') ?? '').toString();
    return title;
  } else {
    final tv = ai.model as m.TvShow;
    final name = (tryGet(tv, 'name') ?? tryGet(tv, 'originalName') ?? '').toString();
    return name;
  }
}

// defensive read to avoid breaking if model fields differ slightly
dynamic tryGet(Object obj, String field) {
  try {
    final value = (obj as dynamic);
    return value.toJson != null ? (value as dynamic) : value;
  } catch (_) {}
  try {
    return (obj as dynamic).__getattr__(field);
  } catch (_) {}
  try {
    return (obj as dynamic).toJson()[field];
  } catch (_) {}
  try {
    return (obj as dynamic)[field];
  } catch (_) {}
  try {
    return (obj as dynamic).noSuchMethod(Invocation.getter(Symbol(field)));
  } catch (_) {}
  try {
    return (obj as dynamic).$field;
  } catch (_) {}
  // simple property access
  try {
    return (obj as dynamic).toMap()[field];
  } catch (_) {}
  try {
    return (obj as dynamic).title; // fallback trials
  } catch (_) {}
  return null;
}

// ========== CLONE WIDGETS THAT ACCEPT API MODELS ==========

// Movie (API) card clone
class MovieCardApi extends StatelessWidget {
  final m.Movie movie;
  final String typec; // expect 'movie'
  const MovieCardApi({super.key, required this.typec, required this.movie});

  @override
  Widget build(BuildContext context) {
    final posterUrl = _tmdbPoster(_safeString(movie, 'posterPath'));
    final releaseYear = _extractYear(_safeString(movie, 'releaseDate'));
    final userDataService = Provider.of<UserDataService>(context, listen: true);

    final int id = _safeInt(movie, 'id') ?? 0;
    final double voteAverage = _safeDouble(movie, 'voteAverage') ?? 0.0;
    final int? runtime = _safeInt(movie, 'runtime'); // might be null
    final String originalLanguage =
        (_safeString(movie, 'originalLanguage') ?? '').toUpperCase();
    final double popularity = _safeDouble(movie, 'popularity') ?? 0.0;
    final String title = _safeString(movie, 'title') ??
        _safeString(movie, 'originalTitle') ??
        'Unknown';

    bool isFavorite = userDataService.isFavoriteMovie(id);
    bool isInWatchlist = userDataService.isOnWatchlistMovie(id);

    return InkWell(
      onTap: () {
        // Adjust routing to your project pages
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MovieDetailPage(id: id,),
          ),
        );
      },
      child: Card(
        color: Colors.transparent,
        elevation: 0,
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 2 / 3,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors2.onBackgroundLight.withOpacity(0.6),
                      ),
                      child: (posterUrl != null && posterUrl.isNotEmpty)
                          ? CachedNetworkImage(
                              filterQuality: FilterQuality.high,
                              imageUrl: posterUrl,
                              fit: BoxFit.cover,
                              fadeInDuration: const Duration(milliseconds: 300),
                              fadeOutDuration: const Duration(milliseconds: 100),
                              placeholder: (context, url) => Center(
                                child: SizedBox(
                                  width: 28,
                                  height: 28,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: AppColors2.accentColor.withOpacity(0.8),
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => const Center(
                                child: Icon(
                                  Icons.broken_image_outlined,
                                  color: AppColors2.tinytext,
                                  size: 36,
                                ),
                              ),
                            )
                          : const Center(
                              child: Icon(
                                Icons.movie_filter_outlined,
                                color: AppColors2.tinytext,
                                size: 40,
                              ),
                            ),
                    ),
                  ),
                  Positioned(
                    top: 8.0,
                    right: 8.0,
                    child: Row(
                      children: [
                        _actionBtn(
                          context: context,
                          isToggled: isFavorite,
                          icon: isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.redAccent : Colors.white70,
                          onPressed: () async {
                            await userDataService.toggleFavoriteMovie(id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  isFavorite ? 'Removed from Favorites' : 'Added to Favorites',
                                  style: const TextStyle(color: Colors.white),
                                ),
                                backgroundColor:
                                    isFavorite ? Colors.red.shade700 : Colors.green.shade700,
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 8.0),
                        _actionBtn(
                          context: context,
                          isToggled: isInWatchlist,
                          icon: isInWatchlist ? Icons.bookmark : Icons.bookmark_border,
                          color: isInWatchlist ? Colors.lightGreenAccent : Colors.white70,
                          onPressed: () async {
                            await userDataService.toggleWatchlistMovie(id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  isInWatchlist ? 'Removed from Watchlist' : 'Added to Watchlist',
                                  style: const TextStyle(color: Colors.white),
                                ),
                                backgroundColor:
                                    isInWatchlist ? Colors.red.shade700 : Colors.green.shade700,
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.lato(
                      color: AppColors2.onPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4.0),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: Colors.amber, size: 14),
                      Expanded(
                        child: Text(
                          '${voteAverage.toStringAsFixed(1)} • $releaseYear',
                          style: const TextStyle(color: AppColors2.tinytext, fontSize: 12.0),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (runtime != null && runtime > 0)
                    RichText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Runtime: ',
                            style: TextStyle(color: Colors.green, fontSize: 10.5, fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: '$runtime min',
                            style: const TextStyle(color: Colors.blue, fontSize: 10.5),
                          ),
                        ],
                      ),
                    ),
                  if (originalLanguage.isNotEmpty)
                    RichText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Language: ',
                            style: TextStyle(color: Colors.green, fontSize: 10.5, fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: originalLanguage,
                            style: const TextStyle(color: Colors.blue, fontSize: 10.5),
                          ),
                        ],
                      ),
                    ),
                  if (popularity > 0)
                    RichText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Popularity: ',
                            style: TextStyle(color: Colors.green, fontSize: 10.5, fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: popularity.toStringAsFixed(1),
                            style: const TextStyle(color: Colors.blue, fontSize: 10.5),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionBtn({
    required BuildContext context,
    required bool isToggled,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        shape: BoxShape.circle,
        border: Border.all(color: color.withOpacity(0.5), width: 0.5),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Icon(icon, color: color, size: 18),
          ),
        ),
      ),
    );
  }
}

// TV/Anime (API) card clone
class AnimeSeriesCardApi extends StatelessWidget {
  final m.TvShow series;
  final String typec; // 'anime' | 'tvseries'
  const AnimeSeriesCardApi({super.key, required this.series, required this.typec});

  @override
  Widget build(BuildContext context) {
    final userDataService = Provider.of<UserDataService>(context, listen: true);

    final int id = _safeInt(series, 'id') ?? 0;
    final String name = _safeString(series, 'name') ??
        _safeString(series, 'originalName') ??
        'Unknown';
    final String? posterUrl = _tmdbPoster(_safeString(series, 'posterPath'));
    final String displayYear = _extractYear(_safeString(series, 'firstAirDate'));
    final double voteAverage = _safeDouble(series, 'voteAverage') ?? 0.0;
    final int? numberOfSeasons = _safeInt(series, 'numberOfSeasons');
    final int? numberOfEpisodes = _safeInt(series, 'numberOfEpisodes');
    final String originalLanguage =
        (_safeString(series, 'originalLanguage') ?? '').toUpperCase();

    // Original code uses anime toggles for both tv/anime. Keeping same behavior.
    final bool isFavorite = userDataService.isFavoriteAnime(id);
    final bool isInWatchlist = userDataService.isOnWatchlistAnime(id);

    return InkWell(
      onTap: () {
        // Route based on typec
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TvShowDetailPageAnime(typec: typec, tvShow: series),
          ),
        );
      },
      child: Card(
        color: Colors.transparent,
        elevation: 0,
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AspectRatio(
              aspectRatio: 2 / 3,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Container(
                      color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.4),
                      child: (posterUrl != null && posterUrl.isNotEmpty)
                          ? CachedNetworkImage(
                              filterQuality: FilterQuality.high,
                              imageUrl: posterUrl,
                              fit: BoxFit.cover,
                              fadeInDuration: const Duration(milliseconds: 300),
                              fadeOutDuration: const Duration(milliseconds: 100),
                              placeholder: (context, url) => Center(
                                child: SizedBox(
                                  width: 28,
                                  height: 28,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: AppColors.accentColor.withOpacity(0.8),
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => const Center(
                                child: Icon(
                                  Icons.broken_image_outlined,
                                  color: AppColors.secondaryText,
                                  size: 36,
                                ),
                              ),
                            )
                          : const Center(
                              child: Icon(
                                Icons.image_not_supported_outlined,
                                color: AppColors.secondaryText,
                                size: 40,
                              ),
                            ),
                    ),
                  ),
                  Positioned(
                    top: 8.0,
                    right: 8.0,
                    child: Row(
                      children: [
                        _actionBtn(
                          context: context,
                          isToggled: isFavorite,
                          icon: isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.redAccent : Colors.white70,
                          onPressed: () async {
                            await userDataService.toggleFavoriteAnime(id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  isFavorite ? 'Removed from Favorites' : 'Added to Favorites',
                                  style: const TextStyle(color: Colors.white),
                                ),
                                backgroundColor:
                                    isFavorite ? Colors.red.shade700 : Colors.green.shade700,
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 8.0),
                        _actionBtn(
                          context: context,
                          isToggled: isInWatchlist,
                          icon: isInWatchlist ? Icons.bookmark : Icons.bookmark_border,
                          color: isInWatchlist ? Colors.lightGreenAccent : Colors.white70,
                          onPressed: () async {
                            await userDataService.toggleWatchlistAnime(id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  isInWatchlist ? 'Removed from Watchlist' : 'Added to Watchlist',
                                  style: const TextStyle(color: Colors.white),
                                ),
                                backgroundColor:
                                    isInWatchlist ? Colors.red.shade700 : Colors.green.shade700,
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.lato(
                      color: AppColors.primaryText,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4.0),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: Colors.amber, size: 14),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${voteAverage.toStringAsFixed(1)} • $displayYear',
                          style: const TextStyle(color: AppColors.secondaryText, fontSize: 12.0),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (numberOfSeasons != null && numberOfEpisodes != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4.0),
                        RichText(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                text: 'Seasons: ',
                                style: TextStyle(color: Colors.green, fontSize: 10.5, fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: '$numberOfSeasons • Episodes: $numberOfEpisodes',
                                style: const TextStyle(color: Colors.blue, fontSize: 10.5),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  if (originalLanguage.isNotEmpty)
                    RichText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Language: ',
                            style: TextStyle(color: Colors.green, fontSize: 10.5, fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: originalLanguage,
                            style: const TextStyle(color: Colors.blue, fontSize: 10.5),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionBtn({
    required BuildContext context,
    required bool isToggled,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        shape: BoxShape.circle,
        border: Border.all(color: color.withOpacity(0.5), width: 0.5),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Icon(icon, color: color, size: 18),
          ),
        ),
      ),
    );
  }
}

// ---------- Safe access helpers for API models ----------

String? _safeString(Object obj, String field) {
  try {
    final val = (obj as dynamic).toJson?[field] ?? (obj as dynamic)[field];
    if (val is String) return val;
  } catch (_) {}
  try {
    final val = (obj as dynamic).toJson?[field];
    if (val is String) return val;
  } catch (_) {}
  try {
    final val = (obj as dynamic).$field;
    if (val is String) return val;
  } catch (_) {}
  try {
    final val = (obj as dynamic).toMap?[field];
    if (val is String) return val;
  } catch (_) {}
  try {
    final direct = (obj as dynamic);
    final v = (direct as dynamic).noSuchMethod(Invocation.getter(Symbol(field)));
    if (v is String) return v;
  } catch (_) {}
  try {
    final v = (obj as dynamic).posterPath;
    if (field == 'posterPath' && v is String) return v;
  } catch (_) {}
  try {
    final v = (obj as dynamic).title;
    if (field == 'title' && v is String) return v;
  } catch (_) {}
  try {
    final v = (obj as dynamic).originalTitle;
    if (field == 'originalTitle' && v is String) return v;
  } catch (_) {}
  try {
    final v = (obj as dynamic).name;
    if (field == 'name' && v is String) return v;
  } catch (_) {}
  try {
    final v = (obj as dynamic).originalName;
    if (field == 'originalName' && v is String) return v;
  } catch (_) {}
  try {
    final v = (obj as dynamic).releaseDate;
    if (field == 'releaseDate' && v is String) return v;
  } catch (_) {}
  try {
    final v = (obj as dynamic).firstAirDate;
    if (field == 'firstAirDate' && v is String) return v;
  } catch (_) {}
  try {
    final v = (obj as dynamic).originalLanguage;
    if (field == 'originalLanguage' && v is String) return v;
  } catch (_) {}
  return null;
}

int? _safeInt(Object obj, String field) {
  try {
    final v = (obj as dynamic).toJson?[field];
    if (v is int) return v;
    if (v is num) return v.toInt();
  } catch (_) {}
  try {
    final v = (obj as dynamic).id;
    if (field == 'id' && v is int) return v;
  } catch (_) {}
  try {
    final v = (obj as dynamic).numberOfSeasons;
    if (field == 'numberOfSeasons' && v is int) return v;
  } catch (_) {}
  try {
    final v = (obj as dynamic).numberOfEpisodes;
    if (field == 'numberOfEpisodes' && v is int) return v;
  } catch (_) {}
  try {
    final v = (obj as dynamic).runtime;
    if (field == 'runtime') {
      if (v is int) return v;
      if (v is num) return v.toInt();
    }
  } catch (_) {}
  return null;
}

double? _safeDouble(Object obj, String field) {
  try {
    final v = (obj as dynamic).toJson?[field];
    if (v is double) return v;
    if (v is num) return v.toDouble();
  } catch (_) {}
  try {
    final v = (obj as dynamic).voteAverage;
    if (field == 'voteAverage') {
      if (v is double) return v;
      if (v is num) return v.toDouble();
    }
  } catch (_) {}
  try {
    final v = (obj as dynamic).popularity;
    if (field == 'popularity') {
      if (v is double) return v;
      if (v is num) return v.toDouble();
    }
  } catch (_) {}
  return null;
}

String _extractYear(String? dateStr) {
  if (dateStr == null || dateStr.isEmpty) return 'N/A';
  try {
    final dt = DateTime.tryParse(dateStr);
    if (dt != null) {
      return dt.year.toString();
    }
  } catch (_) {}
  return 'N/A';
}