import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:miko/models/local_library/directory_entry.dart';
import 'package:miko/models/local_library/episode.dart';
import 'package:miko/models/local_library/local_scan_index.dart';
import 'package:miko/models/local_library/movie.dart';
import 'package:miko/models/local_library/music.dart';
import 'package:miko/models/local_library/music_video.dart';
import 'package:miko/models/local_library/photo.dart';
import 'package:miko/models/local_library/tv_series.dart';
import 'package:miko/providers/local_library_provider.dart';
import 'package:miko/showcases/movie_service.dart';
import 'package:miko/services/local_scan_index_service.dart';
import 'package:provider/provider.dart';

import '../models/local_library/helper_model.dart';
import '../showcases/movie_detail_page_copy.dart';
import '../showcases/tv_detail_page_anime.dart';
import '../utils/utils.dart';
import 'offline_screens/anime_detail_screen.dart';
import 'offline_screens/movie_detail_screen.dart';

/// Screen that shows locally scanned library content in a tabbed grid view.
///
/// Tabs:
///  - Movies
///  - Series (episodes with season/episode numbers)
///  - Music
///  - Photos
///  - Mixed (all media types together)
///
/// This screen uses cached data from [LocalLibraryProvider] – it does not
/// trigger a new scan. Make sure you have run a scan first from the
/// local scan page.
class LocalLibraryGridScreen extends StatefulWidget {
  const LocalLibraryGridScreen({super.key});

  @override
  State<LocalLibraryGridScreen> createState() => _LocalLibraryGridScreenState();
}

class _LocalLibraryGridScreenState extends State<LocalLibraryGridScreen> {
  final LocalScanIndexService _indexService = const LocalScanIndexService();
  late Future<LocalScanIndex> _indexFuture;

  @override
  void initState() {
    super.initState();
    _indexFuture = _indexService.load();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Local Library'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(icon: Icon(Icons.movie), text: 'Movies'),
              Tab(icon: Icon(Icons.tv), text: 'Series'),
              Tab(icon: Icon(Icons.music_note), text: 'Music'),
              Tab(icon: Icon(Icons.photo), text: 'Photos'),
              Tab(icon: Icon(Icons.folder_open), text: 'Mixed'),
            ],
          ),
        ),
        body: FutureBuilder<LocalScanIndex>(
          future: _indexFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            final index = snapshot.data ?? LocalScanIndex();
            return TabBarView(
              children: [
                _MoviesTab(scanIndex: index),
                _SeriesTab(scanIndex: index),
                const _MusicTab(),
                const _PhotosTab(),
                const _MixedTab(),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Base widget to handle empty & loading states for a tab.
class _TabScaffold extends StatelessWidget {
  final Widget Function(BuildContext, LocalLibraryProvider) builder;

  const _TabScaffold({required this.builder});

  @override
  Widget build(BuildContext context) {
    final library = context.watch<LocalLibraryProvider>();

    // If currently scanning and nothing yet, show a loading indicator.
    if (library.isScanning &&
        library.movieResults.isEmpty &&
        library.tvResults.isEmpty &&
        library.musicResults.isEmpty &&
        library.musicVideoResults.isEmpty &&
        library.photoResults.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return builder(context, library);
  }
}

class _MoviesTab extends StatelessWidget {
  final LocalScanIndex scanIndex;

  const _MoviesTab({required this.scanIndex});

  @override
  Widget build(BuildContext context) {
    return _TabScaffold(
      builder: (context, library) {
        final movies = library.movieResults;
        if (movies.isEmpty) {
          return const Center(
            child: Text('Please first go and add content'),
          );
        }

        return MasonryGridView.count(
          padding: const EdgeInsets.all(12.0),
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final movie = movies[index];
            final cachedEntry =
              _resolveMovieMetadata(scanIndex, movie);
            final tmdbTitle =
              movie.fetchedData.title ?? cachedEntry?.tmdbTitle;
            final posterPath =
              movie.fetchedData.posterPath ?? cachedEntry?.tmdbPosterPath;
            
            return _MediaTile(
              movie: movie,
              tvSeries: null,
              title: tmdbTitle ?? movie.name,
              subtitle: movie.movieItems.isNotEmpty
                  ? '${movie.movieItems.length} file(s)'
                  : 'Movie',
              posterPath: posterPath,
              height: index % 3 == 0 ? 220 : (index % 3 == 1 ? 240 : 210),
            );
          },
        );
      },
    );
  }
}

class _SeriesTab extends StatelessWidget {
  final LocalScanIndex scanIndex;

  const _SeriesTab({required this.scanIndex});

  @override
  Widget build(BuildContext context) {
    return _TabScaffold(
      builder: (context, library) {
        final seriesList = library.tvResults;
        if (seriesList.isEmpty) {
          return const Center(
            child: Text('Please first go and add content'),
          );
        }

        return MasonryGridView.count(
          padding: const EdgeInsets.all(12.0),
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          itemCount: seriesList.length,
          itemBuilder: (context, index) {
            final series = seriesList[index];
            final seasonCount = series.seasons.length;
            final episodeCount = series.seasons.fold<int>(
              0,
              (sum, s) => sum + s.episodes.length,
            );
            final cachedEntry =
              _resolveSeriesMetadata(scanIndex, series);
            final tmdbTitle =
              series.fetchedData.title ?? cachedEntry?.tmdbTitle;
            final posterPath =
              series.fetchedData.posterPath ?? cachedEntry?.tmdbPosterPath;

            return _MediaTile(
              tvSeries: series,
              movie: null,
              title: tmdbTitle ?? series.name,
              subtitle: '${seasonCount} season(s) · ${episodeCount} episode(s)',
              posterPath: posterPath,
              height: index % 4 == 0 ? 230 : (index % 4 == 1 ? 210 : (index % 4 == 2 ? 250 : 220)),
            );
          },
        );
      },
    );
  }
}

class _MusicTab extends StatelessWidget {
  const _MusicTab();

  @override
  Widget build(BuildContext context) {
    return _TabScaffold(
      builder: (context, library) {
        final albums = library.musicResults;
        if (albums.isEmpty) {
          return const Center(
            child: Text('Please first go and add content'),
          );
        }

        return MasonryGridView.count(
          padding: const EdgeInsets.all(12.0),
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          itemCount: albums.length,
          itemBuilder: (context, index) {
            final album = albums[index];
            return _MediaTile(
              movie: null,
              tvSeries: null,
              title: album.name,
              subtitle: album.musicItems.isNotEmpty
                  ? '${album.musicItems.length} track(s)'
                  : 'Album',
              height: index % 3 == 0 ? 200 : (index % 3 == 1 ? 190 : 210),
            );
          },
        );
      },
    );
  }
}

class _PhotosTab extends StatelessWidget {
  const _PhotosTab();

  @override
  Widget build(BuildContext context) {
    return _TabScaffold(
      builder: (context, library) {
        final collections = library.photoResults;
        if (collections.isEmpty) {
          return const Center(
            child: Text('Please first go and add content'),
          );
        }

        return MasonryGridView.count(
          padding: const EdgeInsets.all(12.0),
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          itemCount: collections.length,
          itemBuilder: (context, index) {
            final collection = collections[index];
            return _MediaTile(
              movie: null,
              tvSeries: null,
              title: collection.name,
              subtitle: collection.photoItems.isNotEmpty
                  ? '${collection.photoItems.length} photo(s)'
                  : 'Photos',
              height: index % 5 == 0 ? 180 : (index % 5 == 1 ? 200 : (index % 5 == 2 ? 190 : (index % 5 == 3 ? 210 : 185))),
            );
          },
        );
      },
    );
  }
}

class _MixedTab extends StatelessWidget {
  const _MixedTab();

  @override
  Widget build(BuildContext context) {
    return _TabScaffold(
      builder: (context, library) {
        final mixedItems = <_MixedDisplayItem>[];

        // Collect from music (audio)
        for (final Music album in library.musicResults) {
          for (final item in album.musicItems) {
            mixedItems.add(
              _MixedDisplayItem(
                label: item.name,
                typeLabel: 'Audio',
              ),
            );
          }
        }

        // Collect from music videos (video)
        for (final MusicVideo mv in library.musicVideoResults) {
          for (final item in mv.musicVideoItems) {
            mixedItems.add(
              _MixedDisplayItem(
                label: item.name,
                typeLabel: 'Video',
              ),
            );
          }
        }

        // Collect from photos (images)
        for (final Photo collection in library.photoResults) {
          for (final item in collection.photoItems) {
            mixedItems.add(
              _MixedDisplayItem(
                label: item.name,
                typeLabel: 'Photo',
              ),
            );
          }
        }

        if (mixedItems.isEmpty) {
          return const Center(
            child: Text('Please first go and add content'),
          );
        }

        return MasonryGridView.count(
          padding: const EdgeInsets.all(12.0),
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          itemCount: mixedItems.length,
          itemBuilder: (context, index) {
            final item = mixedItems[index];
            return _MediaTile(
              tvSeries: null,
              movie: null,
              title: item.label,
              subtitle: item.typeLabel,
              height: index % 6 == 0 ? 195 : (index % 6 == 1 ? 215 : (index % 6 == 2 ? 185 : (index % 6 == 3 ? 205 : (index % 6 == 4 ? 200 : 190)))),
            );
          },
        );
      },
    );
  }
}

class _MediaTile extends StatefulWidget {
  final String title;
  final String subtitle;
  final String? posterPath;
  final double height;
  final TvSeries? tvSeries;
  final Movie? movie;

  const _MediaTile({
    required this.title,
    required this.subtitle,
    this.posterPath,
    this.height = 220,
    this.tvSeries,
    this.movie,
  });

  @override
  State<_MediaTile> createState() => _MediaTileState();
}

class _MediaTileState extends State<_MediaTile> {
  final MovieService _movieService = MovieService();
  bool _isPressed = false;

  String get _typec => widget.movie != null
      ? 'movie'
      : widget.tvSeries != null
          ? 'tvseries'
          : 'unknown';

  Future<void> _handleTap(BuildContext context) async {
    if (_typec == 'movie' && widget.movie != null) {
      final movieId = widget.movie!.fetchedData.tmdbId;
      final helperModel = HelperModel(
        movies: [widget.movie!],
        episodes: null,
      );

      if (movieId == null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MovieDetailsScreen(
              movieId: widget.movie!.fetchedData.tmdbId ?? 0,
              typec: 'movie',
              helperModel: helperModel,
            ),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MovieDetailPage(
              id: movieId,
              helperModel: helperModel,
            ),
          ),
        );
      }
      return;
    }

    if (_typec == 'tvseries' && widget.tvSeries != null) {
      tVmedium();
      final tvId = widget.tvSeries!.fetchedData.tmdbId;
        final List<Episode> episodes = widget.tvSeries!.seasons
          .expand((season) => season.episodes)
          .toList();
      final helperModel = HelperModel(
        movies: null,
        episodes: episodes,
      );

      if (tvId == null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AnimeDetailsScreen(
              typec: _typec,
              tvSeriesId: widget.tvSeries!.fetchedData.tmdbId ?? 0,
              helperModel: helperModel,
            ),
          ),
        );
      } else {
        final tvShow = await _movieService.getTvShowDetails(tvShowId: tvId);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TvShowDetailPageAnime(
              tvShow: tvShow,
              typec: _typec,
              helperModel: helperModel,
            ),
          ),
        );
      }
    }
  }

  void _handleHighlight(bool value) {
    setState(() => _isPressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      transform: Matrix4.identity()
        ..scale(_isPressed ? 0.97 : 1.0),
      decoration: BoxDecoration(
        boxShadow: _isPressed
            ? [
                BoxShadow(
                  color: theme.colorScheme.primary.withValues(alpha: 0.35),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
      ),
      child: Card(
        elevation: 0,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        child: InkWell(
          onTap: (_typec == 'unknown') ? null : () => _handleTap(context),
          onHighlightChanged: _handleHighlight,
          splashColor: theme.colorScheme.primary.withValues(alpha: 0.2),
          highlightColor: theme.colorScheme.primary.withValues(alpha: 0.1),
          child: SizedBox(
            height: widget.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: widget.posterPath != null
                            ? CachedNetworkImage(
                                imageUrl:
                                    'https://db.inosuke.sbs/t/p/w500${widget.posterPath}',
                                fit: BoxFit.cover,
                                placeholder: (context, url) => _PosterPlaceholder(theme: theme),
                                errorWidget: (context, url, error) => _PosterPlaceholder(theme: theme),
                              )
                            : _PosterPlaceholder(theme: theme),
                      ),
                      Positioned(
                        left: 10,
                        right: 10,
                        bottom: 10,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.55),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.08),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                widget.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.subtitle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PosterPlaceholder extends StatelessWidget {
  final ThemeData theme;

  const _PosterPlaceholder({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.surfaceContainerHighest,
            theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.7),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.movie_outlined,
          size: 48,
          color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
        ),
      ),
    );
  }
}

class _MixedDisplayItem {
  final String label;
  final String typeLabel;

  _MixedDisplayItem({required this.label, required this.typeLabel});
}

LocalScanIndexEntry? _resolveMovieMetadata(
  LocalScanIndex index,
  Movie movie,
) {
  return _resolveMetadataEntry(
    index,
    movie.parentPath,
    ContentType.movie,
    movie.movieItems.map((item) => item.path),
  );
}

LocalScanIndexEntry? _resolveSeriesMetadata(
  LocalScanIndex index,
  TvSeries series,
) {
  final episodePaths = series.seasons.expand(
    (season) => season.episodes.map((episode) => episode.path),
  );
  return _resolveMetadataEntry(
    index,
    series.parentPath,
    ContentType.tvSeries,
    episodePaths,
  );
}

LocalScanIndexEntry? _resolveMetadataEntry(
  LocalScanIndex index,
  String rootDir,
  ContentType contentType,
  Iterable<String> candidatePaths,
) {
  for (final path in candidatePaths) {
    final key = LocalScanIndex.makeKey(rootDir, contentType.name, path);
    final entry = index.entries[key];
    if (entry != null && entry.tmdbId != null) {
      return entry;
    }
  }
  return null;
}
