import 'package:flutter/material.dart';
import 'package:miko/models/local_library/directory_entry.dart';
import 'package:miko/providers/local_library_provider.dart';
import 'package:miko/models/local_library/movie.dart';
import 'package:miko/models/local_library/tv_series.dart';
import 'package:miko/models/local_library/music.dart';
import 'package:miko/models/local_library/music_video.dart';
import 'package:miko/models/local_library/photo.dart';
import 'package:miko/services/user_data_service.dart';
import 'package:provider/provider.dart';

class LocalScanPage extends StatefulWidget {
  const LocalScanPage({super.key});

  @override
  State<LocalScanPage> createState() => _LocalScanPageState();
}

class _LocalScanPageState extends State<LocalScanPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _startScan(ContentType contentType) async {
    final userDataService = context.read<UserDataService>();
    
    List<String> paths = [];
    switch (contentType) {
      case ContentType.movie:
        paths = userDataService.moviesLibraryPaths;
        break;
      case ContentType.tvSeries:
        paths = userDataService.seriesLibraryPaths;
        break;
      case ContentType.music:
        paths = userDataService.musicLibraryPaths;
        break;
      case ContentType.musicVideo:
        paths = userDataService.musicVideoLibraryPaths;
        break;
      case ContentType.photo:
        paths = userDataService.photoLibraryPaths;
        break;
      case ContentType.mixed:
        // For mixed content, scan all library paths
        paths = [
          ...userDataService.mixedLibraryPaths,
        ];
        break;
    }

    if (paths.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No library paths configured for ${_getContentTypeLabel(contentType)}')),
      );
      return;
    }

    // Scan each path for this content type
    for (final path in paths) {
      await context.read<LocalLibraryProvider>().startScan(path, contentType);
    }
  }

  String _getContentTypeLabel(ContentType type) {
    switch (type) {
      case ContentType.movie:
        return 'Movies';
      case ContentType.tvSeries:
        return 'TV Series';
      case ContentType.music:
        return 'Music';
      case ContentType.musicVideo:
        return 'Music Videos';
      case ContentType.photo:
        return 'Photos';
      case ContentType.mixed:
        return 'Mixed';
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<LocalLibraryProvider>();
    final theme = Theme.of(context);
    final userDataService = context.watch<UserDataService>();
    final tmdbBase = userDataService.tmdbBaseUrl;
    final hasAnyLibraryPath =
      userDataService.moviesLibraryPaths.isNotEmpty ||
      userDataService.seriesLibraryPaths.isNotEmpty ||
      userDataService.musicLibraryPaths.isNotEmpty ||
      userDataService.musicVideoLibraryPaths.isNotEmpty ||
      userDataService.photoLibraryPaths.isNotEmpty ||
      userDataService.mixedLibraryPaths.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Local Library Scan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select content type to scan:', style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: (!hasAnyLibraryPath || p.isScanning || p.isFetchingMetadata)
                  ? null
                  : () async {
                      await context
                          .read<LocalLibraryProvider>()
                          .scanAllAndFetchMetadata(userDataService);
                    },
              icon: const Icon(Icons.library_add_check),
              label: const Text('Scan All & Fetch TMDB'),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: p.isScanning ? null : () => _startScan(ContentType.movie),
                  icon: const Icon(Icons.movie),
                  label: const Text('Movies'),
                ),
                ElevatedButton.icon(
                  onPressed: p.isScanning ? null : () => _startScan(ContentType.tvSeries),
                  icon: const Icon(Icons.tv),
                  label: const Text('TV Series'),
                ),
                ElevatedButton.icon(
                  onPressed: p.isScanning ? null : () => _startScan(ContentType.music),
                  icon: const Icon(Icons.music_note),
                  label: const Text('Music'),
                ),
                ElevatedButton.icon(
                  onPressed: p.isScanning ? null : () => _startScan(ContentType.musicVideo),
                  icon: const Icon(Icons.music_video),
                  label: const Text('Music Videos'),
                ),
                ElevatedButton.icon(
                  onPressed: p.isScanning ? null : () => _startScan(ContentType.photo),
                  icon: const Icon(Icons.photo),
                  label: const Text('Photos'),
                ),
                ElevatedButton.icon(
                  onPressed: p.isScanning ? null : () => _startScan(ContentType.mixed),
                  icon: const Icon(Icons.folder_open),
                  label: const Text('Mixed Content'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if ((p.movieResults.isNotEmpty || p.tvResults.isNotEmpty) && !p.isScanning)
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: ElevatedButton.icon(
                  onPressed: p.isFetchingMetadata
                      ? null
                      : () async {
                          await context
                              .read<LocalLibraryProvider>()
                              .fetchTmdbMetadata();
                        },
                  icon: p.isFetchingMetadata
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.cloud_download),
                  label: Text(
                    p.isFetchingMetadata
                        ? 'Fetching Metadata...'
                        : 'Fetch TMDB Metadata',
                  ),
                ),
              ),
            if (p.isScanning)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(p.status, style: theme.textTheme.bodyMedium),
                      OutlinedButton.icon(
                        onPressed: p.cancel,
                        icon: const Icon(Icons.stop),
                        label: const Text('Cancel'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: p.progress == 0 ? null : p.progress,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${(p.progress * 100).clamp(0, 100).toStringAsFixed(0)}%  •  ${p.processed}/${p.totalCandidates} processed',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              )
            else if (p.progress > 0)
              Text(
                'Last scan: ${(p.progress * 100).clamp(0, 100).toStringAsFixed(0)}% complete',
                style: theme.textTheme.bodySmall,
              ),
            const SizedBox(height: 12),
            Expanded(
              child: (p.movieResults.isEmpty &&
                      p.tvResults.isEmpty &&
                      p.musicResults.isEmpty &&
                      p.musicVideoResults.isEmpty &&
                      p.photoResults.isEmpty)
                  ? Center(
                      child: Text(
                        p.isScanning ? 'Scanning…' : 'No results yet',
                        style: theme.textTheme.bodyMedium,
                      ),
                    )
                  : ListView(
                      children: [
                        if (p.movieResults.isNotEmpty) ...[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Movies (${p.movieResults.length})', style: theme.textTheme.titleMedium),
                          ),
                          ...p.movieResults.map((movie) => _buildMovieCard(context, movie, tmdbBase)),
                        ],
                        if (p.tvResults.isNotEmpty) ...[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('TV Series (${p.tvResults.length})', style: theme.textTheme.titleMedium),
                          ),
                          ...p.tvResults.map((series) => _buildSeriesCard(context, series, tmdbBase)),
                        ],
                        if (p.musicResults.isNotEmpty) ...[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Music (${p.musicResults.length})', style: theme.textTheme.titleMedium),
                          ),
                          ...p.musicResults.map((album) => _buildMusicCard(context, album)),
                        ],
                        if (p.musicVideoResults.isNotEmpty) ...[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Music Videos (${p.musicVideoResults.length})', style: theme.textTheme.titleMedium),
                          ),
                          ...p.musicVideoResults.map((mv) => _buildMusicVideoCard(context, mv)),
                        ],
                        if (p.photoResults.isNotEmpty) ...[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Photos (${p.photoResults.length})', style: theme.textTheme.titleMedium),
                          ),
                          ...p.photoResults.map((photo) => _buildPhotoCard(context, photo)),
                        ],
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMovieCard(BuildContext context, Movie movie, String tmdbBase) {
    final poster = movie.fetchedData.posterPath;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ExpansionTile(
        leading: poster == null
            ? const Icon(Icons.movie, size: 40)
            : Image.network(
                '$tmdbBase/t/p/w92$poster',
                width: 40,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
              ),
        title: Text(movie.fetchedData.title ?? movie.name),
        subtitle: Text('${movie.movieItems.length} file(s) • ${movie.fetchedData.year ?? ''}'),
        children: [
          ...movie.movieItems.map((item) => ListTile(
                dense: true,
                leading: const Icon(Icons.videocam, size: 20),
                title: Text(item.name),
                subtitle: Text(item.metadata.sizeReadable),
              )),
        ],
      ),
    );
  }

  Widget _buildSeriesCard(BuildContext context, TvSeries series, String tmdbBase) {
    final poster = series.fetchedData.posterPath;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ExpansionTile(
        leading: poster == null
            ? const Icon(Icons.tv, size: 40)
            : Image.network(
                '$tmdbBase/t/p/w92$poster',
                width: 40,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
              ),
        title: Text(series.fetchedData.title ?? series.name),
        subtitle: Text('${series.seasons.length} season(s) • ${series.fetchedData.year ?? ''}'),
        children: [
          ...series.seasons.map((season) => ExpansionTile(
                dense: true,
                leading: const Icon(Icons.folder, size: 20),
                title: Text(season.name ?? 'Season ${season.seasonNumber}'),
                subtitle: Text('${season.episodes.length} episode(s)'),
                children: [
                  ...season.episodes.map((ep) => ListTile(
                        dense: true,
                        leading: const Icon(Icons.play_circle_outline, size: 18),
                        title: Text(ep.name),
                        subtitle: Text(ep.metadata.sizeReadable),
                      )),
                ],
              )),
        ],
      ),
    );
  }

  Widget _buildMusicCard(BuildContext context, Music album) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ExpansionTile(
        leading: const Icon(Icons.album, size: 40),
        title: Text(album.name),
        subtitle: Text('${album.musicItems.length} track(s)'),
        children: [
          ...album.musicItems.map((item) => ListTile(
                dense: true,
                leading: const Icon(Icons.music_note, size: 20),
                title: Text(item.name),
                subtitle: Text(item.metadata.sizeReadable),
              )),
        ],
      ),
    );
  }

  Widget _buildMusicVideoCard(BuildContext context, MusicVideo video) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ExpansionTile(
        leading: const Icon(Icons.music_video, size: 40),
        title: Text(video.name),
        subtitle: Text('${video.musicVideoItems.length} video(s)'),
        children: [
          ...video.musicVideoItems.map((item) => ListTile(
                dense: true,
                leading: const Icon(Icons.videocam, size: 20),
                title: Text(item.name),
                subtitle: Text(item.metadata.sizeReadable),
              )),
        ],
      ),
    );
  }

  Widget _buildPhotoCard(BuildContext context, Photo collection) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ExpansionTile(
        leading: const Icon(Icons.photo_library, size: 40),
        title: Text(collection.name),
        subtitle: Text('${collection.photoItems.length} photo(s)'),
        children: [
          ...collection.photoItems.map((item) => ListTile(
                dense: true,
                leading: const Icon(Icons.image, size: 20),
                title: Text(item.name),
                subtitle: Text(item.metadata.sizeReadable),
              )),
        ],
      ),
    );
  }
}