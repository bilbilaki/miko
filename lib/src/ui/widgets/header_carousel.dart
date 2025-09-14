import 'dart:async';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:miko/utils/colors.dart';
import 'package:miko/src/providers/trending_providers.dart';
import 'package:miko/src/ui/search_screen.dart';
import 'package:miko/src/ui/notification_screen.dart';
import 'package:miko/showcases/movie_detail_page_copy.dart';
import 'package:miko/showcases/tv_detail_page_anime.dart';
import 'package:miko/showcases/movie_service.dart';
import 'package:miko/src/consts.dart';
import 'package:miko/utils/utils.dart';

enum HeaderMediaType { movie, tv }

class _HeaderItem {
  final int id;
  final String? title;
  final String? name;
  final String? backdropPath;
  final HeaderMediaType type;

  _HeaderItem({
    required this.id,
    this.title,
    this.name,
    this.backdropPath,
    required this.type,
  });
}

class HeaderCarousel extends ConsumerStatefulWidget {
  const HeaderCarousel({super.key});

  @override
  ConsumerState<HeaderCarousel> createState() => _HeaderCarouselState();
}

class _HeaderCarouselState extends ConsumerState<HeaderCarousel> {
  final _pageCtrl = PageController();
  Timer? _autoTimer;
  final _movieService = MovieService();

  @override
  void initState() {
    super.initState();
    _autoTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted) return;
      if (_pageCtrl.hasClients) {
        final next = (_pageCtrl.page?.round() ?? 0) + 1;
        _pageCtrl.animateToPage(
          next,
          duration: const Duration(milliseconds: 450),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _autoTimer?.cancel();
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final moviesAsync = ref.watch(trendingMoviesDayProvider);
    final tvAsync = ref.watch(tvAiringTodayHomeProvider);

    return Stack(
      fit: StackFit.expand,
      children: [
        moviesAsync.when(
          data: (movieRes) {
            final movies = movieRes.results;
            final tvs = tvAsync.asData?.value.results ?? [];

            // Interleave movies and tv for variety
            final maxCount = min(5, max(movies.length, tvs.length));
            final items = <_HeaderItem>[];
            for (var i = 0; i < maxCount; i++) {
              if (i < movies.length) {
                items.add(
                  _HeaderItem(
                    id: movies[i].id,
                    title: movies[i].title,
                    backdropPath: movies[i].backdropPath,
                    type: HeaderMediaType.movie,
                  ),
                );
              }
              if (i < tvs.length) {
                items.add(
                  _HeaderItem(
                    id: tvs[i].id,
                    name: tvs[i].name,
                    backdropPath: tvs[i].backdropPath,
                    type: HeaderMediaType.tv,
                  ),
                );
              }
            }

            if (items.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFF1ED760)),
              );
            }

            return PageView.builder(
              controller: _pageCtrl,
              allowImplicitScrolling: true,
              itemBuilder: (_, index) {
                final item = items[index % items.length];
                final imageUrl = item.backdropPath != null
                    ? '$tmdbImageBaseUrlc/t/p/w780${item.backdropPath}'
                    : null;

                return GestureDetector(
                  onTap: () async {
                    tVClick();
                    if (item.type == HeaderMediaType.movie) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MovieDetailPage(id: item.id),
                        ),
                      );
                    } else if (item.type == HeaderMediaType.tv) {
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
                    }
                    else{
                      
                    }
                  },
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (imageUrl != null)
                        CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.high,
                          fadeInDuration: const Duration(milliseconds: 300),
                          fadeOutDuration: const Duration(milliseconds: 120),
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
                        ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.28),
                              Colors.black.withOpacity(0.65),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                      Positioned(
                        top: MediaQuery.of(context).padding.top + 12,
                        left: 16,
                        right: 16,
                        child: Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: const BoxDecoration(
                                color: Color(0xFF0BFF7A),
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.ac_unit,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () {
                                tVClick();
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const SearchScreen(),
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.search,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 6),
                            IconButton(
                              onPressed: () {
                                tVClick();
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const NotificationScreen(),
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.notifications_none,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        left: 16,
                        right: 16,
                        bottom: 18,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title ?? item.name ?? 'Featured',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              item.type == HeaderMediaType.movie
                                  ? 'Movie'
                                  : 'TV Series',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.85),
                                fontSize: 13,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 14),
                            Row(
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () {
                                    tVmedium();
                                  },
                                  icon: const Icon(Icons.play_arrow, size: 18),
                                  label: const Text('Play'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF1ED760),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 18,
                                      vertical: 10,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    textStyle: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                OutlinedButton.icon(
                                  onPressed: () {
                                    tVClick();
                                  },
                                  icon: const Icon(Icons.add, size: 18),
                                  label: const Text('My List'),
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                      color: Colors.white.withOpacity(0.12),
                                    ),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 10,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    textStyle: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(color: Color(0xFF1ED760)),
          ),
          error: (e, st) => Center(
            child: Text(
              'Error loading header: $e',
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }
}
