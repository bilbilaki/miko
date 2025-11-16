import 'dart:async';
import 'dart:io';

import 'package:miko/configs/consts2.dart';
import 'package:miko/models/local_library/content_item.dart';
import 'package:miko/models/local_library/directory_entry.dart';
import 'package:miko/models/local_library/episode.dart';
import 'package:miko/models/local_library/metadata.dart';
import 'package:miko/models/local_library/movie.dart';
import 'package:miko/models/local_library/music.dart';
import 'package:miko/models/local_library/music_video.dart';
import 'package:miko/models/local_library/photo.dart';
import 'package:miko/models/local_library/tv_series.dart';
import 'package:miko/models/local_library/season.dart';
import 'package:miko/models/local_library/fetched_data.dart';
import 'package:tmdb_api/tmdb_api.dart';

class LocalScanService {
  LocalScanService();

  // State
  bool _isScanning = false;
  bool _cancelRequested = false;
  int _totalCandidates = 0;
  int _processed = 0;

  final _movieResults = <Movie>[];
  final _tvResults = <TvSeries>[];
  final _musicResults = <Music>[];
  final _musicVideoResults = <MusicVideo>[];
  final _photoResults = <Photo>[];
  
  final _progressController = StreamController<double>.broadcast();
  final _statusController = StreamController<String>.broadcast();
  final _movieResultsController = StreamController<List<Movie>>.broadcast();
  final _tvResultsController = StreamController<List<TvSeries>>.broadcast();
  final _musicResultsController = StreamController<List<Music>>.broadcast();
  final _musicVideoResultsController = StreamController<List<MusicVideo>>.broadcast();
  final _photoResultsController = StreamController<List<Photo>>.broadcast();

  // Public streams
  Stream<double> get progressStream => _progressController.stream;
  Stream<String> get statusStream => _statusController.stream;
  Stream<List<Movie>> get movieResultsStream => _movieResultsController.stream;
  Stream<List<TvSeries>> get tvResultsStream => _tvResultsController.stream;
  Stream<List<Music>> get musicResultsStream => _musicResultsController.stream;
  Stream<List<MusicVideo>> get musicVideoResultsStream => _musicVideoResultsController.stream;
  Stream<List<Photo>> get photoResultsStream => _photoResultsController.stream;

  bool get isScanning => _isScanning;
  double get progress => _totalCandidates == 0 ? 0 : _processed / _totalCandidates;
  List<Movie> get movieResults => List.unmodifiable(_movieResults);
  List<TvSeries> get tvResults => List.unmodifiable(_tvResults);
  List<Music> get musicResults => List.unmodifiable(_musicResults);
  List<MusicVideo> get musicVideoResults => List.unmodifiable(_musicVideoResults);
  List<Photo> get photoResults => List.unmodifiable(_photoResults);
  int get totalCandidates => _totalCandidates;
  int get processed => _processed;

  Future<void> startScan(String rootDir, ContentType contentType) async {
    if (_isScanning) return;
    _isScanning = true;
    _cancelRequested = false;
    _clearResults();
    _processed = 0;
    _totalCandidates = 0;

    _statusController.add('Scanning ${_contentTypeLabel(contentType)} files...');

    final candidates = await _collectCandidates(rootDir, contentType);
    _totalCandidates = candidates.length;
    _emitProgress();

    if (candidates.isEmpty) {
      _isScanning = false;
      _statusController.add('No media files found');
      return;
    }

    _statusController.add('Processing ${candidates.length} ${_contentTypeLabel(contentType)} files...');

    // Route to appropriate scanner based on content type
    switch (contentType) {
      case ContentType.movie:
        await _scanMovies(candidates);
        break;
      case ContentType.tvSeries:
        await _scanTvSeries(candidates);
        // Also scan loose TV files in the root directory
        await _scanLooseTvFiles(rootDir);
        break;
      case ContentType.music:
        await _scanMusic(candidates);
        break;
      case ContentType.musicVideo:
        await _scanMusicVideos(candidates);
        break;
      case ContentType.photo:
        await _scanPhotos(candidates);
        break;
      case ContentType.mixed:
        await _scanMixedContent(candidates);
        break;
    }

    _isScanning = false;
    _statusController.add(_cancelRequested ? 'Scan cancelled' : 'Scan complete');
  }

  void cancel() {
    _cancelRequested = true;
  }

  void dispose() {
    _progressController.close();
    _statusController.close();
    _movieResultsController.close();
    _tvResultsController.close();
    _musicResultsController.close();
    _musicVideoResultsController.close();
    _photoResultsController.close();
  }

  void _clearResults() {
    _movieResults.clear();
    _tvResults.clear();
    _musicResults.clear();
    _musicVideoResults.clear();
    _photoResults.clear();
  }

  String _contentTypeLabel(ContentType type) {
    switch (type) {
      case ContentType.movie:
        return 'Movie';
      case ContentType.tvSeries:
        return 'TV Series';
      case ContentType.music:
        return 'Music';
      case ContentType.musicVideo:
        return 'Music Video';
      case ContentType.photo:
        return 'Photo';
      case ContentType.mixed:
        return 'Mixed';
    }
  }

  Future<void> _scanMovies(List<String> candidates) async {
    final videoExts = <String>{'.mp4', '.mkv', '.avi', '.mov', '.m4v', '.webm'};

    for (final path in candidates) {
      if (_cancelRequested) break;

      final file = File(path);
      final ext = file.path.split('.').last.toLowerCase();
      if (!videoExts.contains('.$ext')) continue;

      final parsed = _parseMediaFromFilename(path);
      final metadata = await Metadata.fromFile(file);
      final movieName = parsed.name.isEmpty ? 'Unknown Movie' : parsed.name;
      final moviePath = file.parent.path;

      var movie = _movieResults.firstWhere(
        (m) => m.path == moviePath && m.name == movieName,
        orElse: () => Movie(
          path: moviePath,
          parentPath: Directory(moviePath).parent.path,
          name: movieName,
          movieItems: [],
        ),
      );

      final movieItem = MovieItem(
        path: path,
        parentPath: file.parent.path,
        name: file.uri.pathSegments.last,
        metadata: metadata,
      );

      if (!_movieResults.contains(movie)) {
        _movieResults.add(movie.copyWith(movieItems: [movieItem]));
      } else {
        final index = _movieResults.indexOf(movie);
        _movieResults[index] = movie.copyWith(
          movieItems: [...movie.movieItems, movieItem],
        );
      }

      _processed++;
      if (_processed % 5 == 0) {
        _movieResultsController.add(List.unmodifiable(_movieResults));
      }
      _emitProgress();
      await Future.delayed(const Duration(milliseconds: 1));
    }

    _movieResultsController.add(List.unmodifiable(_movieResults));
  }

  Future<void> _scanTvSeries(List<String> candidates) async {
    final videoExts = <String>{'.mp4', '.mkv', '.avi', '.mov', '.m4v', '.webm'};

    for (final path in candidates) {
      if (_cancelRequested) break;

      final file = File(path);
      final ext = file.path.split('.').last.toLowerCase();
      if (!videoExts.contains('.$ext')) continue;

      final parsed = _parseMediaFromFilename(path);
      final metadata = await Metadata.fromFile(file);

      if (!parsed.isTv) continue;

      // Episodes are directly in the series folder (no season subfolder)
      final seriesPath = file.parent.path;
      final seriesFolderName = seriesPath.split(Platform.pathSeparator).last;
      final normalizedSeriesName = _normalizeFolderNameForTmdb(seriesFolderName);

      var series = _tvResults.firstWhere(
        (s) => s.path == seriesPath,
        orElse: () {
          final newSeries = TvSeries(
            path: seriesPath,
            parentPath: Directory(seriesPath).parent.path,
            name: normalizedSeriesName,
          );
          _tvResults.add(newSeries);
          return newSeries;
        },
      );

      final seasonNum = parsed.season ?? 1;
      var season = series.seasons.firstWhere(
        (s) => s.seasonNumber == seasonNum,
        orElse: () => Season(
          path: seriesPath,
          parentPath: Directory(seriesPath).parent.path,
          seasonNumber: seasonNum,
          seriesId: series.id,
          seriesName: series.name,
        ),
      );

      final episodeNum = parsed.episode ?? 1;
      final episode = Episode(
        seasonNumber: seasonNum,
        episodeNumber: episodeNum,
        name: file.uri.pathSegments.last,
        path: path,
        parentPath: file.parent.path,
        metadata: metadata,
        tvSeriesId: series.id,
        tvSeriesName: series.name,
      );

      final updatedEpisodes = [...season.episodes, episode];
      final updatedSeason = season.copyWith(episodes: updatedEpisodes);

      final seasonIndex = series.seasons.indexWhere((s) => s.seasonNumber == seasonNum);
      final updatedSeasons = List<Season>.from(series.seasons);

      if (seasonIndex >= 0) {
        updatedSeasons[seasonIndex] = updatedSeason;
      } else {
        updatedSeasons.add(updatedSeason);
      }

      final seriesIndex = _tvResults.indexWhere((s) => s.path == seriesPath);
      _tvResults[seriesIndex] = series.copyWith(seasons: updatedSeasons);

      _processed++;
      if (_processed % 5 == 0) {
        _tvResultsController.add(List.unmodifiable(_tvResults));
      }
      _emitProgress();
      await Future.delayed(const Duration(milliseconds: 1));
    }

    _tvResultsController.add(List.unmodifiable(_tvResults));
  }

  Future<void> _scanLooseTvFiles(String rootDir) async {
    final videoExts = <String>{'.mp4', '.mkv', '.avi', '.mov', '.m4v', '.webm'};
    final dir = Directory(rootDir);
    
    if (!await dir.exists()) return;

    // Get only files directly in the root directory (not in subdirectories)
    await for (final entity in dir.list(followLinks: false)) {
      if (_cancelRequested) break;
      
      if (entity is! File) continue;

      final file = entity;
      final ext = file.path.split('.').last.toLowerCase();
      if (!videoExts.contains('.$ext')) continue;

      final parsed = _parseMediaFromFilename(file.path);
      final metadata = await Metadata.fromFile(file);

      if (!parsed.isTv) continue;

      // Use parsed series name as the virtual series folder name, normalized
      final normalizedSeriesName = _normalizeFolderNameForTmdb(parsed.name);
      
      // Virtual series path (doesn't exist, but used as identifier)
      final virtualSeriesPath = '${dir.path}${Platform.pathSeparator}[VIRTUAL] $normalizedSeriesName';

      var series = _tvResults.firstWhere(
        (s) => s.path == virtualSeriesPath,
        orElse: () {
          final newSeries = TvSeries(
            path: virtualSeriesPath,
            parentPath: dir.path,
            name: normalizedSeriesName,
          );
          _tvResults.add(newSeries);
          return newSeries;
        },
      );

      final seasonNum = parsed.season ?? 1;
      var season = series.seasons.firstWhere(
        (s) => s.seasonNumber == seasonNum,
        orElse: () => Season(
          path: virtualSeriesPath,
          parentPath: dir.path,
          seasonNumber: seasonNum,
          seriesId: series.id,
          seriesName: series.name,
        ),
      );

      final episodeNum = parsed.episode ?? 1;
      final episode = Episode(
        seasonNumber: seasonNum,
        episodeNumber: episodeNum,
        name: file.uri.pathSegments.last,
        path: file.path, // Actual file path in base folder
        parentPath: dir.path,
        metadata: metadata,
        tvSeriesId: series.id,
        tvSeriesName: series.name,
      );

      final updatedEpisodes = [...season.episodes, episode];
      final updatedSeason = season.copyWith(episodes: updatedEpisodes);

      final seasonIndex = series.seasons.indexWhere((s) => s.seasonNumber == seasonNum);
      final updatedSeasons = List<Season>.from(series.seasons);

      if (seasonIndex >= 0) {
        updatedSeasons[seasonIndex] = updatedSeason;
      } else {
        updatedSeasons.add(updatedSeason);
      }

      final seriesIndex = _tvResults.indexWhere((s) => s.path == virtualSeriesPath);
      _tvResults[seriesIndex] = series.copyWith(seasons: updatedSeasons);

      _processed++;
      if (_processed % 5 == 0) {
        _tvResultsController.add(List.unmodifiable(_tvResults));
      }
      _emitProgress();
      await Future.delayed(const Duration(milliseconds: 1));
    }

    _tvResultsController.add(List.unmodifiable(_tvResults));
  }

  Future<void> _scanMusic(List<String> candidates) async {
    final audioExts = <String>{'.mp3', '.flac', '.wav', '.m4a', '.aac', '.ogg'};

    for (final path in candidates) {
      if (_cancelRequested) break;

      final file = File(path);
      final ext = file.path.split('.').last.toLowerCase();
      if (!audioExts.contains('.$ext')) continue;

      final metadata = await Metadata.fromFile(file);
      
      // Get the immediate parent folder as album
      final albumPath = file.parent.path;
      final albumName = albumPath.split(Platform.pathSeparator).last;

      var music = _musicResults.firstWhere(
        (m) => m.path == albumPath,
        orElse: () => Music(
          path: albumPath,
          parentPath: Directory(albumPath).parent.path,
          name: albumName,
          musicItems: [],
        ),
      );

      final musicItem = MusicItem(
        path: path,
        parentPath: albumPath,
        name: file.uri.pathSegments.last,
        metadata: metadata,
      );

      if (!_musicResults.contains(music)) {
        _musicResults.add(music.copyWith(musicItems: [musicItem]));
      } else {
        final index = _musicResults.indexOf(music);
        _musicResults[index] = music.copyWith(
          musicItems: [...music.musicItems, musicItem],
        );
      }

      _processed++;
      if (_processed % 5 == 0) {
        _musicResultsController.add(List.unmodifiable(_musicResults));
      }
      _emitProgress();
      await Future.delayed(const Duration(milliseconds: 1));
    }

    _musicResultsController.add(List.unmodifiable(_musicResults));
  }

  Future<void> _scanMusicVideos(List<String> candidates) async {
    final videoExts = <String>{'.mp4', '.mkv', '.avi', '.mov', '.m4v', '.webm'};

    for (final path in candidates) {
      if (_cancelRequested) break;

      final file = File(path);
      final ext = file.path.split('.').last.toLowerCase();
      if (!videoExts.contains('.$ext')) continue;

      final metadata = await Metadata.fromFile(file);
      final videoName = file.parent.path.split(Platform.pathSeparator).last;
      final videoPath = file.parent.path;

      var musicVideo = _musicVideoResults.firstWhere(
        (m) => m.path == videoPath && m.name == videoName,
        orElse: () => MusicVideo(
          path: videoPath,
          parentPath: Directory(videoPath).parent.path,
          name: videoName,
        ),
      );

      final musicVideoItem = MusicVideoItem(
        path: path,
        parentPath: file.parent.path,
        name: file.uri.pathSegments.last,
        metadata: metadata,
      );

      if (!_musicVideoResults.contains(musicVideo)) {
        _musicVideoResults.add(musicVideo.copyWith(musicVideoItems: [musicVideoItem]));
      } else {
        final index = _musicVideoResults.indexOf(musicVideo);
        _musicVideoResults[index] = musicVideo.copyWith(
          musicVideoItems: [...musicVideo.musicVideoItems, musicVideoItem],
        );
      }

      _processed++;
      if (_processed % 5 == 0) {
        _musicVideoResultsController.add(List.unmodifiable(_musicVideoResults));
      }
      _emitProgress();
      await Future.delayed(const Duration(milliseconds: 1));
    }

    _musicVideoResultsController.add(List.unmodifiable(_musicVideoResults));
  }

  Future<void> _scanPhotos(List<String> candidates) async {
    final imageExts = <String>{'.jpg', '.jpeg', '.png', '.gif', '.webp', '.bmp'};

    for (final path in candidates) {
      if (_cancelRequested) break;

      final file = File(path);
      final ext = file.path.split('.').last.toLowerCase();
      if (!imageExts.contains('.$ext')) continue;

      final metadata = await Metadata.fromFile(file);
      final collectionName = file.parent.path.split(Platform.pathSeparator).last;
      final collectionPath = file.parent.path;

      var photo = _photoResults.firstWhere(
        (p) => p.path == collectionPath && p.name == collectionName,
        orElse: () => Photo(
          path: collectionPath,
          parentPath: Directory(collectionPath).parent.path,
          name: collectionName,
        ),
      );

      final photoItem = PhotoItem(
        path: path,
        parentPath: file.parent.path,
        name: file.uri.pathSegments.last,
        metadata: metadata,
      );

      if (!_photoResults.contains(photo)) {
        _photoResults.add(photo.copyWith(photoItems: [photoItem]));
      } else {
        final index = _photoResults.indexOf(photo);
        _photoResults[index] = photo.copyWith(
          photoItems: [...photo.photoItems, photoItem],
        );
      }

      _processed++;
      if (_processed % 5 == 0) {
        _photoResultsController.add(List.unmodifiable(_photoResults));
      }
      _emitProgress();
      await Future.delayed(const Duration(milliseconds: 1));
    }

    _photoResultsController.add(List.unmodifiable(_photoResults));
  }

  Future<void> _scanMixedContent(List<String> candidates) async {
    final videoExts = <String>{'.mp4', '.mkv', '.avi', '.mov', '.m4v', '.webm'};
    final audioExts = <String>{'.mp3', '.flac', '.wav', '.m4a', '.aac', '.ogg'};
    final imageExts = <String>{'.jpg', '.jpeg', '.png', '.gif', '.webp', '.bmp'};

    // Create containers for mixed content (one per type)
    final mixedVideos = MusicVideo(
      path: 'mixed-videos',
      parentPath: '',
      name: 'Mixed Videos',
      musicVideoItems: [],
    );
    
    final mixedAudio = Music(
      path: 'mixed-audio',
      parentPath: '',
      name: 'Mixed Audio',
      musicItems: [],
    );
    
    final mixedPhotos = Photo(
      path: 'mixed-photos',
      parentPath: '',
      name: 'Mixed Photos',
      photoItems: [],
    );

    for (final path in candidates) {
      if (_cancelRequested) break;

      final file = File(path);
      final ext = file.path.split('.').last.toLowerCase();
      final metadata = await Metadata.fromFile(file);
      final fileName = file.uri.pathSegments.last;

      if (videoExts.contains('.$ext')) {
        // Add as video item
        final videoItem = MusicVideoItem(
          path: path,
          parentPath: file.parent.path,
          name: fileName,
          metadata: metadata,
        );
        mixedVideos.musicVideoItems.add(videoItem);
      } else if (audioExts.contains('.$ext')) {
        // Add as audio item
        final audioItem = MusicItem(
          path: path,
          parentPath: file.parent.path,
          name: fileName,
          metadata: metadata,
        );
        mixedAudio.musicItems.add(audioItem);
      } else if (imageExts.contains('.$ext')) {
        // Add as photo item
        final photoItem = PhotoItem(
          path: path,
          parentPath: file.parent.path,
          name: fileName,
          metadata: metadata,
        );
        mixedPhotos.photoItems.add(photoItem);
      }

      _processed++;
      if (_processed % 5 == 0) {
        if (mixedVideos.musicVideoItems.isNotEmpty) {
          _musicVideoResults.clear();
          _musicVideoResults.add(mixedVideos);
          _musicVideoResultsController.add(List.unmodifiable(_musicVideoResults));
        }
        if (mixedAudio.musicItems.isNotEmpty) {
          _musicResults.clear();
          _musicResults.add(mixedAudio);
          _musicResultsController.add(List.unmodifiable(_musicResults));
        }
        if (mixedPhotos.photoItems.isNotEmpty) {
          _photoResults.clear();
          _photoResults.add(mixedPhotos);
          _photoResultsController.add(List.unmodifiable(_photoResults));
        }
      }
      _emitProgress();
      await Future.delayed(const Duration(milliseconds: 1));
    }

    // Final update
    if (mixedVideos.musicVideoItems.isNotEmpty) {
      _musicVideoResults.clear();
      _musicVideoResults.add(mixedVideos);
      _musicVideoResultsController.add(List.unmodifiable(_musicVideoResults));
    }
    if (mixedAudio.musicItems.isNotEmpty) {
      _musicResults.clear();
      _musicResults.add(mixedAudio);
      _musicResultsController.add(List.unmodifiable(_musicResults));
    }
    if (mixedPhotos.photoItems.isNotEmpty) {
      _photoResults.clear();
      _photoResults.add(mixedPhotos);
      _photoResultsController.add(List.unmodifiable(_photoResults));
    }
  }

  Future<List<String>> _collectCandidates(String rootDir, ContentType contentType) async {
    final files = <String>[];
    final dir = Directory(rootDir);
    if (!await dir.exists()) return files;

    // Determine file extensions based on content type
    final exts = <String>{};
    switch (contentType) {
      case ContentType.movie:
      case ContentType.tvSeries:
        exts.addAll({'.mp4', '.mkv', '.avi', '.mov', '.m4v', '.webm'});
        break;
      case ContentType.music:
        exts.addAll({'.mp3', '.flac', '.wav', '.m4a', '.aac', '.ogg'});
        break;
      case ContentType.musicVideo:
        exts.addAll({'.mp4', '.mkv', '.avi', '.mov', '.m4v', '.webm'});
        break;
      case ContentType.photo:
        exts.addAll({'.jpg', '.jpeg', '.png', '.gif', '.webp', '.bmp'});
        break;
      case ContentType.mixed:
        exts.addAll({
          '.mp4', '.mkv', '.avi', '.mov', '.m4v', '.webm',
          '.mp3', '.flac', '.wav', '.m4a', '.aac', '.ogg',
          '.jpg', '.jpeg', '.png', '.gif', '.webp', '.bmp'
        });
        break;
    }

    await for (final entity in dir.list(recursive: true, followLinks: false)) {
      if (_cancelRequested) break;
      if (entity is File) {
        final ext = entity.path.split('.').last.toLowerCase();
        if (exts.contains('.$ext')) {
          files.add(entity.path);
        }
      }
    }
    return files;
  }

  _Parsed _parseMediaFromFilename(String filePath) {
    final fileName = filePath.split(Platform.pathSeparator).last;
    final noExt = fileName.replaceAll(RegExp(r'\.[^.]*$'), '');

    // Common TV patterns: S01E02, 1x02, Season 1 Episode 2, Ep 12
    final sxe = RegExp(r'[sS](\d{1,2})[ ._-]?[eE](\d{1,3})').firstMatch(noExt);
    final x = RegExp(r'(\d{1,2})x(\d{1,3})').firstMatch(noExt);

    // Year pattern
    final y = RegExp(r'(19|20)\d{2}').firstMatch(noExt);
    String? year = y?.group(0);

    bool isTv = false;
    int? season;
    int? episode;

    if (sxe != null) {
      isTv = true;
      season = int.tryParse(sxe.group(1)!);
      episode = int.tryParse(sxe.group(2)!);
    } else if (x != null) {
      isTv = true;
      season = int.tryParse(x.group(1)!);
      episode = int.tryParse(x.group(2)!);
    }

    // Try to extract season and episode using helper functions
    if (isTv && season == null) {
      final seasonStr = _extractSeason(filePath);
      if (seasonStr != null) {
        season = int.tryParse(seasonStr.replaceAll(RegExp(r'[^\d]'), ''));
      }
    }

    if (isTv && episode == null) {
      final episodeStr = _extractEpisodeNumber(filePath);
      if (episodeStr != null) {
        episode = int.tryParse(episodeStr.replaceAll(RegExp(r'[^\d]'), ''));
      }
    }

    // Try to extract a clean title by removing common tokens
    var name = noExt
        .replaceAll(RegExp(r'[._]'), ' ')
        .replaceAll(RegExp(r'\b(1080p|720p|480p|x264|x265|Bluray|WEBRip|WEB-DL|HEVC|H264|H265|AAC|DVDRip)\b', caseSensitive: false), '')
        .replaceAll(RegExp(r'[\[\(].*?[\]\)]'), '')
        .trim();

    // Remove season/episode tokens from name
    name = name
        .replaceAll(RegExp(r'[sS](\d{1,2})[ ._-]?[eE](\d{1,3})'), '')
        .replaceAll(RegExp(r'(\d{1,2})x(\d{1,3})'), '')
        .trim();

    // If year exists, keep it separate and remove from name tail
    if (year != null) {
      name = name.replaceAll(year, '').trim();
    }

    // Collapse multiple spaces
    name = name.replaceAll(RegExp(r'\s+'), ' ').trim();

    // For TV shows, try to extract series name using helper function
    if (isTv && episode != null) {
      final episodeId = 'E${episode.toString().padLeft(2, '0')}';
      final extractedName = _extractSeriesName(filePath, episodeId);
      if (extractedName != null && extractedName.isNotEmpty) {
        name = extractedName;
      }
    }

    return _Parsed(name: name, isTv: isTv, season: season, episode: episode, year: year);
  }

  

  // --- Series Helpers (Unchanged) ---
  String? _extractQuality(String url) {
    final match = RegExp(
      r'(1080p|720p|540p|480p|Dubbed)',
      caseSensitive: false,
    ).firstMatch(url);
    return match?.group(1);
  }

  String? _extractSeason(String url) {
    final match = RegExp(r'/S(\d+)/', caseSensitive: false).firstMatch(url);
    if (match != null) {
      return 'S${int.parse(match.group(1)!).toString().padLeft(2, '0')}';
    }
    return null;
  }

  String? _extractEpisodeNumber(String url) {
    final filename = url.split('/').last;
    RegExpMatch? match;

    match = RegExp(r'S\d+E(\d+)', caseSensitive: false).firstMatch(filename);
    if (match != null) {
      return 'E${int.parse(match.group(1)!).toString().padLeft(2, '0')}';
    }

    match = RegExp(
      r'Ep(?:isode)?\.?(\d+)',
      caseSensitive: false,
    ).firstMatch(filename);
    if (match != null) {
      return 'E${int.parse(match.group(1)!).toString().padLeft(2, '0')}';
    }

    match = RegExp(r'(?<!\d)(?<!p)[._-](\d{2,3})[._-]').firstMatch(filename);
    if (match != null) {
      return 'E${int.parse(match.group(1)!).toString().padLeft(2, '0')}';
    }

    match = RegExp(r'\.(\d{2,3})\.').firstMatch(filename);
    if (match != null && !_isQualityString(match.group(0)!)) {
      return 'E${int.parse(match.group(1)!).toString().padLeft(2, '0')}';
    }

    return null;
  }

  String? _extractSeriesName(String url, String episodeId) {
    final filename = Uri.decodeComponent(url.split('/').last);
    final stopIndex = filename.indexOf(episodeId.split('E')[0]);
    if (stopIndex != -1) {
      return filename.substring(0, stopIndex).replaceAll('.', ' ').trim();
    }
    return null;
  }

  bool _isQualityString(String text) => RegExp(r'\d+p').hasMatch(text);

  /// Normalize folder names for TMDB matching
  /// Examples:
  /// - The.Quintessential.Quintuplets => The-Quintessential-Quintuplets
  /// - The Quintessential Quintuplets => The-Quintessential-Quintuplets
  /// - The Quintessential Quintuplets 2012 => The-Quintessential-Quintuplets
  /// - The Quintessential Quintuplets 720p => The-Quintessential-Quintuplets
  /// - Narnia: Aslan Came Back => Narnia-Aslan-Came-Back
  /// - Spider-Man => Spider-Man (unchanged)
  String _normalizeFolderNameForTmdb(String folderName) {
    var normalized = folderName;
    
    // Remove single quotes (apostrophes)
    normalized = normalized.replaceAll("'", '');
    
    // Replace colons with hyphens
    normalized = normalized.replaceAll(':', '-');
    
    // Replace dots and spaces with hyphens
    normalized = normalized.replaceAll(RegExp(r'[.\s]+'), '-');
    
    // Remove year patterns (1900-2099)
    normalized = normalized.replaceAll(RegExp(r'-(?:19|20)\d{2}(?=-|$)'), '');
    
    // Remove quality patterns (720p, 1080p, bluray, webrip, etc.)
    normalized = normalized.replaceAll(
      RegExp(r'-(?:480p|720p|1080p|2160p|4k|bluray|webrip|web-dl|dvdrip|hdtv|bdrip|x264|x265|hevc)(?=-|$)', caseSensitive: false),
      ''
    );
    
    // Remove resolution patterns (1920x1080, etc.)
    normalized = normalized.replaceAll(RegExp(r'-\d{3,4}x\d{3,4}(?=-|$)'), '');
    
    // Clean up multiple consecutive hyphens
    normalized = normalized.replaceAll(RegExp(r'-+'), '-');
    
    // Remove leading/trailing hyphens
    normalized = normalized.trim();
    if (normalized.startsWith('-')) {
      normalized = normalized.substring(1);
    }
    if (normalized.endsWith('-')) {
      normalized = normalized.substring(0, normalized.length - 1);
    }
    
    return normalized;
  }

  Future<Movie> _matchMovieWithTmdb(TMDB tmdb, Movie movie, String? year) async {
    final resp = await tmdb.v3.search.queryMovies(movie.name);
    if (resp['results'] != null && resp['results'].isNotEmpty) {
      Map<String, dynamic> best;
      if (year != null) {
        best = ((resp['results'] as List).cast<Map<String, dynamic>>().firstWhere(
          (m) => (m['release_date'] as String?)?.startsWith(year) == true,
          orElse: () => (resp['results'] as List).first as Map<String, dynamic>,
        ));
      } else {
        best = (resp['results'] as List).first as Map<String, dynamic>;
      }
      return movie.copyWith(
        fetchedData: FetchedData(
          tmdbId: best['id'] as int?,
          title: best['title'] as String?,
          originalTitle: best['original_title'] as String?,
          posterPath: best['poster_path'] as String?,
          backdropPath: best['backdrop_path'] as String?,
          overview: best['overview'] as String?,
          year: (best['release_date'] as String?)?.split('-').first,
        ),
      );
    }
    return movie;
  }

  Future<TvSeries> _matchTvWithTmdb(TMDB tmdb, TvSeries series, String? year) async {
    final resp = await tmdb.v3.search.queryTvShows(series.name);
    if (resp['results'] != null && resp['results'].isNotEmpty) {
      final best = (resp['results'] as List).first as Map<String, dynamic>;
      return series.copyWith(
        fetchedData: FetchedData(
          tmdbId: best['id'] as int?,
          title: best['name'] as String?,
          originalTitle: best['original_name'] as String?,
          posterPath: best['poster_path'] as String?,
          backdropPath: best['backdrop_path'] as String?,
          overview: best['overview'] as String?,
          year: (best['first_air_date'] as String?)?.split('-').first,
        ),
      );
    }
    return series;
  }

  void _emitProgress() {
    final p = progress;
    _progressController.add(p.isNaN ? 0.0 : p);
  }
}

class _Parsed {
  final String name;
  final bool isTv;
  final int? season;
  final int? episode;
  final String? year;

  _Parsed({required this.name, required this.isTv, this.season, this.episode, this.year});
}
