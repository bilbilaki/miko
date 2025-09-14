import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:miko/src/consts.dart';
import 'package:miko/src/providers/movie_providers.dart';
import 'package:miko/src/providers/trending_providers.dart';
import 'package:miko/src/providers/tv_providers.dart' show tvRepositoryProvider;

import 'package:miko/src/ui/widgets/movie_card.dart';
import 'package:miko/src/ui/widgets/header_carousel.dart';
import 'package:miko/src/ui/top_hits_anime_screen.dart';
import 'package:miko/src/ui/new_episode_releases_screen.dart';
import 'package:miko/src/ui/search_screen.dart';
import 'package:miko/src/ui/notification_screen.dart';
import 'package:miko/showcases/movie_detail_page_copy.dart';
import 'package:miko/showcases/tv_detail_page_anime.dart';
import 'package:miko/showcases/movie_service.dart';

import 'package:miko/utils/colors.dart';
import 'package:miko/utils/seeded_shuffle.dart';
import 'package:miko/utils/utils.dart';
import 'package:tmdb_api/tmdb_api.dart';
late HeaderMediaType typeh;
final sessionRandomProvider = Provider<Random>((ref) {
  final r = Random(DateTime.now().millisecondsSinceEpoch);
  final link = ref.keepAlive();
  return r;
});

int _randInRange(Random r, int min, int maxInclusive) {
  if (maxInclusive < min) return min;
  return min + r.nextInt(maxInclusive - min + 1);
}

// Choose a random page per section (stable this session)
final popularPageProvider = Provider<int>((ref) {
  final r = ref.watch(sessionRandomProvider);
  return _randInRange(r, 1, 3);
});
final upcomingPageProvider = Provider<int>((ref) {
  final r = ref.watch(sessionRandomProvider);
  return _randInRange(r, 1, 3);
});
final trendingTvPageProvider = Provider<int>((ref) {
  final r = ref.watch(sessionRandomProvider);
  return _randInRange(r, 1, 3);
});
final newEpisodesPageProvider = Provider<int>((ref) {
  final r = ref.watch(sessionRandomProvider);
  return _randInRange(r, 1, 3);
});

// Use the existing family providers with randomized pages
final popularMoviesProvider = FutureProvider.autoDispose((ref) async {
  final page = ref.read(popularPageProvider);
  final repo = ref.read(movieRepositoryProvider);
  return await repo.getPopular(page: page);
});

final upcomingMoviesProvider = FutureProvider.autoDispose((ref) async {
  final page = ref.read(upcomingPageProvider);
  final repo = ref.read(movieRepositoryProvider);
  return await repo.getUpcoming(page: page);
});

// If you have discover, wire it here. For now, keep upcoming as placeholder
final discoverMoviesProvider = FutureProvider.autoDispose((ref) async {
  final repo = ref.read(movieRepositoryProvider);
  return await repo.getUpcoming(page: 1);
});

final trendingTvProvider = FutureProvider.autoDispose((ref) async {
  final page = ref.read(trendingTvPageProvider);
  final repo = ref.read(tvRepositoryProvider);
  return await repo.getOnTheAir(page: page);
});

class DashboardScreen extends ConsumerWidget {
  DashboardScreen({super.key});

  final MovieService _movieService = MovieService();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trendingMovies = ref.watch(trendingMoviesDayProvider);
    final topRatedMovies = ref.watch(topRatedMoviesProvider);
    final newEpisodeReleases = ref.watch(tvAiringTodayHomeProvider);
    final popularMovies = ref.watch(popularMoviesProvider);
    final upcomingMovies = ref.watch(upcomingMoviesProvider);
    final discoverMovies = ref.watch(discoverMoviesProvider);
    final trendingTv = ref.watch(trendingTvProvider);

    return MaterialApp(
      theme: AppThemes.netflixDarkTheme,
      home: Scaffold(
        backgroundColor: const Color(0xFF0D0F10),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 360.0,
              floating: false,
              pinned: true,
              backgroundColor: const Color(0xFF0D0F10),
              flexibleSpace: const HeaderCarousel(),
            ),
            SliverToBoxAdapter(child: const SizedBox(height: 20)),

            // Top Hits Anime (Weekly trending movies)
            SliverToBoxAdapter(
              child: _buildSectionHeader(context, 'Top Hits Anime', () {
                tVClick();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const TopHitsAnimeScreen(HeaderMediaType.movie)),
                );
              }),
            ),
            SliverToBoxAdapter(
              child: topRatedMovies.when(
                data: (response) {
                  final seed = ref.read(sessionRandomProvider).nextInt(1 << 31);
                  final items = seededShuffle(
                    response.results,
                    seed ^ 0xA11CE1,
                  );
                  return SizedBox(
                    height: 220,
                    child: ListView.builder(
                      key: const PageStorageKey('top_hits_anime'),
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      scrollDirection: Axis.horizontal,
                      cacheExtent: 320,
                      itemCount: min(items.length, 10),
                      itemBuilder: (context, index) {
                        final item = items[index];
                        if (item.posterPath == null ||
                            (item.voteAverage == null &&
                                item.popularity == null)) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: EdgeInsets.only(
                            right: index == min(items.length, 10) - 1
                                ? 16.0
                                : 12.0,
                          ),
                          child: MovieCard(
                            imageUrl:
                                '$tmdbImageBaseUrlc/t/p/w500${item.posterPath}',
                            title: item.title ?? item.name ?? 'N/A',
                            rating: item.voteAverage != null
                                ? item.voteAverage!.toStringAsFixed(1)
                                : (item.popularity ?? 0.0).toStringAsFixed(1),
                            indexNumber: index + 1,
                            width: 130,
                            height: 180,
                            small: false,
                            onTap: () {
                              tVClick();
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => MovieDetailPage(id: item.id),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(color: Color(0xFF1ED760)),
                ),
                error: (err, stack) => Center(
                  child: Text(
                    'Error loading top hits: $err',
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(child: const SizedBox(height: 22)),

            // New Episode Releases (TV daily)
            SliverToBoxAdapter(
              child: _buildSectionHeader(context, 'New Episode Releases', () {
                tVClick();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const NewEpisodeReleasesScreen(),
                  ),
                );
              }),
            ),
            SliverToBoxAdapter(
              child: newEpisodeReleases.when(
                data: (response) {
                  final seed = ref.read(sessionRandomProvider).nextInt(1 << 31);
                  final items = seededShuffle(
                    response.results,
                    seed ^ 0xBEE123,
                  );
                  return SizedBox(
                    height: 180,
                    child: ListView.builder(
                      key: const PageStorageKey('new_episode_releases'),
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      scrollDirection: Axis.horizontal,
                      cacheExtent: 300,
                      itemCount: min(items.length, 10),
                      itemBuilder: (context, index) {
                        final item = items[index];
                        if (item.posterPath == null ||
                            (item.voteAverage == null &&
                                item.popularity == null)) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: EdgeInsets.only(
                            right: index == min(items.length, 10) - 1
                                ? 16.0
                                : 12.0,
                          ),
                          child: MovieCard(
                            imageUrl:
                                '$tmdbImageBaseUrlc/t/p/w500${item.posterPath}',
                            title: item.title ?? item.name ?? 'N/A',
                            rating: item.voteAverage != null
                                ? item.voteAverage!.toStringAsFixed(1)
                                : (item.popularity ?? 0.0).toStringAsFixed(1),
                            indexNumber: index + 1,
                            width: 120,
                            height: 140,
                            small: true,
                            onTap: () async {
                              tVClick();
                              final show = await _movieService.getTvShowDetails(
                                tvShowId: item.id,
                              );
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => TvShowDetailPageAnime(
                                    tvShow: show,
                                    typec: 'tvseries',
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(color: Color(0xFF1ED760)),
                ),
                error: (err, stack) => Center(
                  child: Text(
                    'Error loading new releases: $err',
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ),

            // Another "Top Hits Anime" using trendingMovies (daily)
            SliverToBoxAdapter(
              child: _buildSectionHeader(context, 'Top Hits Anime', () {
                tVClick();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const TopHitsAnimeScreen(HeaderMediaType.movie)),
                );
              }),
            ),
            SliverToBoxAdapter(
              child: trendingMovies.when(
                data: (response) {
                  final seed = ref.read(sessionRandomProvider).nextInt(1 << 31);
                  final items = seededShuffle(
                    response.results,
                    seed ^ 0xC0FFEE,
                  );
                  return SizedBox(
                    height: 220,
                    child: ListView.builder(
                      key: const PageStorageKey('trending_movies'),
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      scrollDirection: Axis.horizontal,
                      cacheExtent: 320,
                      itemCount: min(items.length, 10),
                      itemBuilder: (context, index) {
                        final item = items[index];
                        if (item.posterPath == null ||
                            (item.voteAverage == null &&
                                item.popularity == null)) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: EdgeInsets.only(
                            right: index == min(items.length, 10) - 1
                                ? 16.0
                                : 12.0,
                          ),
                          child: MovieCard(
                            imageUrl:
                                '$tmdbImageBaseUrlc/t/p/w500${item.posterPath}',
                            title: item.title ?? item.name ?? 'N/A',
                            rating: item.voteAverage != null
                                ? item.voteAverage!.toStringAsFixed(1)
                                : (item.popularity ?? 0.0).toStringAsFixed(1),
                            indexNumber: index + 1,
                            width: 130,
                            height: 180,
                            small: false,
                            onTap: () {
                              tVClick();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => MovieDetailPage(id: item.id),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(color: Color(0xFF1ED760)),
                ),
                error: (err, stack) => Center(
                  child: Text(
                    'Error loading trending: $err',
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(child: const SizedBox(height: 22)),

            // Popular Movies (random page)
            SliverToBoxAdapter(
              child: _buildSectionHeader(context, 'Popular Movies', () {
                tVClick();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const NewEpisodeReleasesScreen(),
                  ),
                );
              }),
            ),
            SliverToBoxAdapter(
              child: popularMovies.when(
                data: (response) {
                  final seed = ref.read(sessionRandomProvider).nextInt(1 << 31);
                  final items = seededShuffle(
                    response.results,
                    seed ^ 0xDADA55,
                  );
                  return SizedBox(
                    height: 220,
                    child: ListView.builder(
                      key: const PageStorageKey('popular_movies'),
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      scrollDirection: Axis.horizontal,
                      cacheExtent: 320,
                      itemCount: min(items.length, 10),
                      itemBuilder: (context, index) {
                        final item = items[index];
                        if (item.posterPath == null) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: EdgeInsets.only(
                            right: index == min(items.length, 10) - 1
                                ? 16.0
                                : 12.0,
                          ),
                          child: MovieCard(
                            imageUrl:
                                '$tmdbImageBaseUrlc/t/p/w500${item.posterPath}',
                            title: item.title ?? 'N/A',
                            rating: (item.voteAverage ?? 0.0).toStringAsFixed(
                              1,
                            ),
                            indexNumber: index + 1,
                            width: 130,
                            height: 180,
                            small: false,
                            onTap: () {
                              tVClick();
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => MovieDetailPage(id: item.id),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(color: Color(0xFF1ED760)),
                ),
                error: (err, stack) => Center(
                  child: Text(
                    'Error loading popular: $err',
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(child: const SizedBox(height: 22)),

            // Upcoming Movies (random page)
            SliverToBoxAdapter(
              child: _buildSectionHeader(context, 'Upcoming Movies', () {
                tVClick();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const NewEpisodeReleasesScreen(),
                  ),
                );
              }),
            ),
            SliverToBoxAdapter(
              child: upcomingMovies.when(
                data: (response) {
                  final seed = ref.read(sessionRandomProvider).nextInt(1 << 31);
                  final items = seededShuffle(
                    response.results,
                    seed ^ 0xFEED42,
                  );
                  return SizedBox(
                    height: 220,
                    child: ListView.builder(
                      key: const PageStorageKey('upcoming_movies'),
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      scrollDirection: Axis.horizontal,
                      cacheExtent: 320,
                      itemCount: min(items.length, 10),
                      itemBuilder: (context, index) {
                        final item = items[index];
                        if (item.posterPath == null) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: EdgeInsets.only(
                            right: index == min(items.length, 10) - 1
                                ? 16.0
                                : 12.0,
                          ),
                          child: MovieCard(
                            imageUrl:
                                '$tmdbImageBaseUrlc/t/p/w500${item.posterPath}',
                            title: item.title ?? 'N/A',
                            rating: (item.voteAverage ?? 0.0).toStringAsFixed(
                              1,
                            ),
                            indexNumber: index + 1,
                            width: 130,
                            height: 180,
                            small: false,
                            onTap: () {
                              tVClick();
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => MovieDetailPage(id: item.id),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(color: Color(0xFF1ED760)),
                ),
                error: (err, stack) => Center(
                  child: Text(
                    'Error loading upcoming: $err',
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(child: const SizedBox(height: 22)),

            // Discover Movies (placeholder wired to upcoming)
            SliverToBoxAdapter(
              child: _buildSectionHeader(context, 'Discover Movies', () {
                tVClick();
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => const SearchScreen()));
              }),
            ),
            SliverToBoxAdapter(
              child: discoverMovies.when(
                data: (response) {
                  final seed = ref.read(sessionRandomProvider).nextInt(1 << 31);
                  final items = seededShuffle(
                    response.results,
                    seed ^ 0x123456,
                  );
                  return SizedBox(
                    height: 220,
                    child: ListView.builder(
                      key: const PageStorageKey('discover_movies'),
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      scrollDirection: Axis.horizontal,
                      cacheExtent: 320,
                      itemCount: min(items.length, 10),
                      itemBuilder: (context, index) {
                        final item = items[index];
                        if (item.posterPath == null) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: EdgeInsets.only(
                            right: index == min(items.length, 10) - 1
                                ? 16.0
                                : 12.0,
                          ),
                          child: MovieCard(
                            imageUrl:
                                '$tmdbImageBaseUrlc/t/p/w500${item.posterPath}',
                            title: item.title ?? 'N/A',
                            rating: (item.voteAverage ?? 0.0).toStringAsFixed(
                              1,
                            ),
                            indexNumber: index + 1,
                            width: 130,
                            height: 180,
                            small: false,
                            onTap: () {
                              tVClick();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => MovieDetailPage(id: item.id),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(color: Color(0xFF1ED760)),
                ),
                error: (err, stack) => Center(
                  child: Text(
                    'Error loading discover: $err',
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(child: const SizedBox(height: 22)),

            // Trending TV Series (random page)
            SliverToBoxAdapter(
              child: _buildSectionHeader(context, 'Trending TV Series', () {
                tVClick();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const TopHitsAnimeScreen(HeaderMediaType.tv)),
                );
              }),
            ),
            SliverToBoxAdapter(
              child: trendingTv.when(
                data: (response) {
                  final seed = ref.read(sessionRandomProvider).nextInt(1 << 31);
                  final items = seededShuffle(
                    response.results,
                    seed ^ 0x77AA11,
                  );
                  return SizedBox(
                    height: 180,
                    child: ListView.builder(
                      key: const PageStorageKey('trending_tv'),
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      scrollDirection: Axis.horizontal,
                      cacheExtent: 300,
                      itemCount: min(items.length, 10),
                      itemBuilder: (context, index) {
                        final item = items[index];
                        if (item.posterPath == null) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: EdgeInsets.only(
                            right: index == min(items.length, 10) - 1
                                ? 16.0
                                : 12.0,
                          ),
                          child: MovieCard(
                            imageUrl:
                                '$tmdbImageBaseUrlc/t/p/w500${item.posterPath}',
                            title: item.name ?? 'N/A',
                            rating: (item.voteAverage ?? 0.0).toStringAsFixed(
                              1,
                            ),
                            indexNumber: index + 1,
                            width: 120,
                            height: 140,
                            small: true,
                            onTap: () async {
                              tVClick();
                              final show = await _movieService.getTvShowDetails(
                                tvShowId: item.id,
                              );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => TvShowDetailPageAnime(
                                    tvShow: show,
                                    typec: 'tvseries',
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(color: Color(0xFF1ED760)),
                ),
                error: (err, stack) => Center(
                  child: Text(
                    'Error loading trending TV: $err',
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(child: const SizedBox(height: 40)),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    VoidCallback onSeeAll,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 8.0),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          const Spacer(),
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
}
