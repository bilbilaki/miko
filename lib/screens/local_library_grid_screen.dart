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
import 'package:miko/services/local_metadata_manager.dart';
import 'package:miko/services/user_data_service.dart';
import 'package:miko/showcases/model.dart' as model;
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
                _MoviesTab(scanIndex: index, indexService: _indexService),
                _SeriesTab(scanIndex: index, indexService: _indexService),
                _MusicTab(indexService: _indexService),
                _PhotosTab(indexService: _indexService),
                _MixedTab(indexService: _indexService),
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
      return const Center(child: CircularProgressIndicator());
    }

    return builder(context, library);
  }
}

class _MoviesTab extends StatelessWidget {
  final LocalScanIndex scanIndex;
  final LocalScanIndexService indexService;

  const _MoviesTab({required this.scanIndex, required this.indexService});

  @override
  Widget build(BuildContext context) {
    return _TabScaffold(
      builder: (context, library) {
        final movies = library.movieResults;
        if (movies.isEmpty) {
          return const Center(child: Text('Please first go and add content'));
        }

        return MasonryGridView.count(
          padding: const EdgeInsets.all(12.0),
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final movie = movies[index];
            final cachedEntry = _resolveMovieMetadata(scanIndex, movie);
            final tmdbTitle = movie.fetchedData.title ?? cachedEntry?.tmdbTitle;
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
              indexService: indexService,
            );
          },
        );
      },
    );
  }
}

class _SeriesTab extends StatelessWidget {
  final LocalScanIndex scanIndex;
  final LocalScanIndexService indexService;

  const _SeriesTab({required this.scanIndex, required this.indexService});

  @override
  Widget build(BuildContext context) {
    return _TabScaffold(
      builder: (context, library) {
        final seriesList = library.tvResults;
        if (seriesList.isEmpty) {
          return const Center(child: Text('Please first go and add content'));
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
            final cachedEntry = _resolveSeriesMetadata(scanIndex, series);
            final tmdbTitle =
                series.fetchedData.title ?? cachedEntry?.tmdbTitle;
            final posterPath =
                series.fetchedData.posterPath ?? cachedEntry?.tmdbPosterPath;

            return _MediaTile(
              tvSeries: series,
              movie: null,
              title: tmdbTitle ?? series.name,
              subtitle: '$seasonCount season(s) · $episodeCount episode(s)',
              posterPath: posterPath,
              height: index % 4 == 0
                  ? 230
                  : (index % 4 == 1 ? 210 : (index % 4 == 2 ? 250 : 220)),
              indexService: indexService,
            );
          },
        );
      },
    );
  }
}

class _MusicTab extends StatelessWidget {
  final LocalScanIndexService indexService;
  const _MusicTab({required this.indexService});

  @override
  Widget build(BuildContext context) {
    return _TabScaffold(
      builder: (context, library) {
        final albums = library.musicResults;
        if (albums.isEmpty) {
          return const Center(child: Text('Please first go and add content'));
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
              indexService: indexService,
            );
          },
        );
      },
    );
  }
}

class _PhotosTab extends StatelessWidget {
  final LocalScanIndexService indexService;
  const _PhotosTab({required this.indexService});

  @override
  Widget build(BuildContext context) {
    return _TabScaffold(
      builder: (context, library) {
        final collections = library.photoResults;
        if (collections.isEmpty) {
          return const Center(child: Text('Please first go and add content'));
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
              height: index % 5 == 0
                  ? 180
                  : (index % 5 == 1
                        ? 200
                        : (index % 5 == 2
                              ? 190
                              : (index % 5 == 3 ? 210 : 185))),
              indexService: indexService,
            );
          },
        );
      },
    );
  }
}

class _MixedTab extends StatelessWidget {
  final LocalScanIndexService indexService;
  const _MixedTab({required this.indexService});

  @override
  Widget build(BuildContext context) {
    return _TabScaffold(
      builder: (context, library) {
        final mixedItems = <_MixedDisplayItem>[];

        // Collect from music (audio)
        for (final Music album in library.musicResults) {
          for (final item in album.musicItems) {
            mixedItems.add(
              _MixedDisplayItem(label: item.name, typeLabel: 'Audio'),
            );
          }
        }

        // Collect from music videos (video)
        for (final MusicVideo mv in library.musicVideoResults) {
          for (final item in mv.musicVideoItems) {
            mixedItems.add(
              _MixedDisplayItem(label: item.name, typeLabel: 'Video'),
            );
          }
        }

        // Collect from photos (images)
        for (final Photo collection in library.photoResults) {
          for (final item in collection.photoItems) {
            mixedItems.add(
              _MixedDisplayItem(label: item.name, typeLabel: 'Photo'),
            );
          }
        }

        if (mixedItems.isEmpty) {
          return const Center(child: Text('Please first go and add content'));
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
              height: index % 6 == 0
                  ? 195
                  : (index % 6 == 1
                        ? 215
                        : (index % 6 == 2
                              ? 185
                              : (index % 6 == 3
                                    ? 205
                                    : (index % 6 == 4 ? 200 : 190)))),
              indexService: indexService,
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
  final LocalScanIndexService indexService;

  const _MediaTile({
    required this.title,
    required this.subtitle,
    this.posterPath,
    this.height = 220,
    this.tvSeries,
    this.movie,
    required this.indexService,
  });

  @override
  State<_MediaTile> createState() => _MediaTileState();
}

class _MediaTileState extends State<_MediaTile> {
  final MovieService _movieService = MovieService();
  late final LocalMetadataManager _metadataManager;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _metadataManager = LocalMetadataManager(widget.indexService, _movieService);
  }

  String get _typec => widget.movie != null
      ? 'movie'
      : widget.tvSeries != null
      ? 'tvseries'
      : 'unknown';

  Future<void> _handleTap(BuildContext context) async {
    if (_typec == 'movie' && widget.movie != null) {
      final movieId = widget.movie!.fetchedData.tmdbId;
      final helperModel = HelperModel(movies: [widget.movie!], episodes: null);

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
            builder: (_) =>
                MovieDetailPage(id: movieId, helperModel: helperModel),
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
      final helperModel = HelperModel(movies: null, episodes: episodes);

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

  Future<void> _showFixMatchDialog() async {
    final TextEditingController searchController = TextEditingController();
    searchController.text = widget.title;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Fix Match'),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: searchController,
                  decoration: const InputDecoration(
                    labelText: 'Search TMDB',
                    suffixIcon: Icon(Icons.search),
                  ),
                  onSubmitted: (query) {
                    Navigator.pop(context, query);
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, searchController.text),
              child: const Text('Search'),
            ),
          ],
        );
      },
    ).then((query) async {
      if (query != null && query is String && query.isNotEmpty) {
        _performSearch(query);
      }
    });
  }

  Future<void> _performSearch(String query) async {
    try {
      final response = await _movieService.multiSearch(query: query);
      if (!mounted) return;

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Results for "$query"'),
            content: SizedBox(
              width: double.maxFinite,
              height: 400,
              child: ListView.builder(
                itemCount: response.results.length,
                itemBuilder: (context, index) {
                  final result = response.results[index];
                  String title = result.name;
                  String? date;
                  String? poster;

                  if (result is model.MultiSearchMovie) {
                    title = result.title;
                    date = result.releaseDate;
                    poster = result.posterPath;
                  } else if (result is model.MultiSearchTV) {
                    title = result.name;
                    date = result.firstAirDate;
                    poster = result.posterPath;
                  }

                  return ListTile(
                    leading: poster != null
                        ? CachedNetworkImage(
                            imageUrl: 'https://image.tmdb.org/t/p/w92$poster',
                            width: 40,
                            fit: BoxFit.cover,
                            errorWidget: (_, __, ___) =>
                                const Icon(Icons.movie),
                          )
                        : const Icon(Icons.movie),
                    title: Text(title),
                    subtitle: Text(date ?? 'Unknown Date'),
                    onTap: () {
                      Navigator.pop(context, result);
                    },
                  );
                },
              ),
            ),
          );
        },
      ).then((result) async {
        if (result != null && result is model.MultiSearchResult) {
          await _updateMatch(result);
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Search failed: $e')));
    }
  }

  Future<void> _updateMatch(model.MultiSearchResult result) async {
    String? rootDir;
    ContentType? contentType;

    if (widget.movie != null) {
      rootDir = widget.movie!.parentPath;
      contentType = ContentType.movie;
    } else if (widget.tvSeries != null) {
      // For TV Series, we might need to update all episodes or just the series entry?
      // The index is per file.
      // But we group by series.
      // We should update all files in this series.
      // This is tricky. `upsertTmdbMetadata` updates one entry.
      // I should probably iterate over all episodes.

      // For now, let's just update the first one to see if it works,
      // or better, update all.
      rootDir = widget.tvSeries!.parentPath;
      contentType = ContentType.tvSeries;
    }

    if (rootDir != null && contentType != null) {
      final paths = widget.movie != null
          ? widget.movie!.movieItems.map((e) => e.path)
          : widget.tvSeries!.seasons.expand(
              (s) => s.episodes.map((e) => e.path),
            );

      for (final p in paths) {
        await widget.indexService.upsertTmdbMetadata(
          rootDir: rootDir,
          contentType: contentType,
          path: p,
          tmdbId: result.id,
          tmdbTitle: result.name,
          tmdbOriginalTitle: result.originalName,
          tmdbPosterPath: result.posterPath,
          tmdbBackdropPath: result.backdropPath,
          tmdbOverview: (result is model.MultiSearchMovie)
              ? result.overview
              : (result is model.MultiSearchTV)
              ? result.overview
              : null,
          tmdbYear: (result is model.MultiSearchMovie)
              ? result.releaseDate
              : (result is model.MultiSearchTV)
              ? result.firstAirDate
              : null,
          tmdbMediaType: (result is model.MultiSearchMovie) ? 'movie' : 'tv',
          persistImmediately: true,
        );
      }

      // Trigger download metadata
      // We can just pick one entry to download metadata for, since it's per ID.
      // But `downloadMetadata` takes an entry.
      // Let's create a dummy entry or fetch one.
      final firstPath = paths.first;
      final entry = await widget.indexService.getCachedEntry(
        rootDir: rootDir,
        contentType: contentType,
        path: firstPath,
      );

      if (entry != null) {
        await _metadataManager.downloadMetadata(entry);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Match updated. Please refresh.')),
      );

      // Force refresh UI?
      // The parent `FutureBuilder` needs to rebuild.
      // We can't easily trigger that from here without a callback.
      // But `LocalLibraryProvider` might update if we re-scan? No.
      // `LocalScanIndexService` updates the disk.
      // We need to reload the index in the parent.
    }
  }

  Future<void> _addToFavorites() async {
    final userData = Provider.of<UserDataService>(context, listen: false);
    // We need a valid TMDB ID.
    int? tmdbId;

    if (widget.movie != null) {
      tmdbId = widget.movie!.fetchedData.tmdbId;
      if (tmdbId != null) {
        await userData.toggleFavoriteMovie(tmdbId);
        final isFav = userData.isFavoriteMovie(tmdbId);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isFav ? 'Added to Favorites' : 'Removed from Favorites',
            ),
          ),
        );
      }
    } else if (widget.tvSeries != null) {
      tmdbId = widget.tvSeries!.fetchedData.tmdbId;
      if (tmdbId != null) {
        await userData.toggleFavoriteTvSeries(tmdbId);
        final isFav = userData.isFavoriteTvSeries(tmdbId);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isFav ? 'Added to Favorites' : 'Removed from Favorites',
            ),
          ),
        );
      }
    }

    if (tmdbId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cannot add to favorites: Missing TMDB ID'),
        ),
      );
    }
  }

  Future<void> _addToWatchlist() async {
    final userData = Provider.of<UserDataService>(context, listen: false);
    int? tmdbId;

    if (widget.movie != null) {
      tmdbId = widget.movie!.fetchedData.tmdbId;
      if (tmdbId != null) {
        await userData.toggleWatchlistMovie(tmdbId);
        final isWatch = userData.isOnWatchlistMovie(tmdbId);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isWatch ? 'Added to Watchlist' : 'Removed from Watchlist',
            ),
          ),
        );
      }
    } else if (widget.tvSeries != null) {
      tmdbId = widget.tvSeries!.fetchedData.tmdbId;
      if (tmdbId != null) {
        await userData.toggleWatchlistTvSeries(tmdbId);
        final isWatch = userData.isOnWatchlistTvSeries(tmdbId);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isWatch ? 'Added to Watchlist' : 'Removed from Watchlist',
            ),
          ),
        );
      }
    }

    if (tmdbId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cannot add to watchlist: Missing TMDB ID'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      transform: Matrix4.identity()..scale(_isPressed ? 0.97 : 1.0),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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
                                placeholder: (context, url) =>
                                    _PosterPlaceholder(theme: theme),
                                errorWidget: (context, url, error) =>
                                    _PosterPlaceholder(theme: theme),
                              )
                            : _PosterPlaceholder(theme: theme),
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: PopupMenuButton<String>(
                          icon: const Icon(
                            Icons.more_vert,
                            color: Colors.white,
                          ),
                          onSelected: (value) {
                            switch (value) {
                              case 'fix_match':
                                _showFixMatchDialog();
                                break;
                              case 'favorites':
                                _addToFavorites();
                                break;
                              case 'watchlist':
                                _addToWatchlist();
                                break;
                              case 'download_metadata':
                                // Trigger download
                                break;
                            }
                          },
                          itemBuilder: (BuildContext context) {
                            return [
                              const PopupMenuItem(
                                value: 'fix_match',
                                child: Text('Fix Match'),
                              ),
                              const PopupMenuItem(
                                value: 'favorites',
                                child: Text('Toggle Favorites'),
                              ),
                              const PopupMenuItem(
                                value: 'watchlist',
                                child: Text('Toggle Watchlist'),
                              ),
                            ];
                          },
                        ),
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

LocalScanIndexEntry? _resolveMovieMetadata(LocalScanIndex index, Movie movie) {
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
