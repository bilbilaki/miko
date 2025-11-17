import 'dart:async';

import 'package:flutter/material.dart';
import 'package:miko/models/local_library/directory_entry.dart';
import 'package:miko/services/local_scan_service.dart';
import 'package:miko/models/local_library/movie.dart';
import 'package:miko/models/local_library/tv_series.dart';
import 'package:miko/models/local_library/music.dart';
import 'package:miko/models/local_library/music_video.dart';
import 'package:miko/models/local_library/photo.dart';
import 'package:miko/services/user_data_service.dart';

class LocalLibraryProvider extends ChangeNotifier {
  final LocalScanService _service;

  LocalLibraryProvider({LocalScanService? service}) : _service = service ?? LocalScanService() {
    _subs.add(_service.progressStream.listen((_) {
      _progress = _service.progress;
      notifyListeners();
    }));
    _subs.add(_service.statusStream.listen((s) {
      _status = s;
      notifyListeners();
    }));
    _subs.add(_service.movieResultsStream.listen((list) {
      _movieResults = list;
      notifyListeners();
    }));
    _subs.add(_service.tvResultsStream.listen((list) {
      _tvResults = list;
      notifyListeners();
    }));
    _subs.add(_service.musicResultsStream.listen((list) {
      _musicResults = list;
      notifyListeners();
    }));
    _subs.add(_service.musicVideoResultsStream.listen((list) {
      _musicVideoResults = list;
      notifyListeners();
    }));
    _subs.add(_service.photoResultsStream.listen((list) {
      _photoResults = list;
      notifyListeners();
    }));

    // Populate from on-disk cache (if any) so that previously scanned
    // content is available immediately after app restart.
    _restoreFromCache();
  }

  final _subs = <StreamSubscription>[];

  double _progress = 0.0;
  String _status = 'Idle';
  List<Movie> _movieResults = const [];
  List<TvSeries> _tvResults = const [];
  List<Music> _musicResults = const [];
  List<MusicVideo> _musicVideoResults = const [];
  List<Photo> _photoResults = const [];

  bool get isScanning => _service.isScanning;
  bool get isFetchingMetadata => _service.isFetchingMetadata;
  double get progress => _progress;
  String get status => _status;
  List<Movie> get movieResults => _movieResults;
  List<TvSeries> get tvResults => _tvResults;
  List<Music> get musicResults => _musicResults;
  List<MusicVideo> get musicVideoResults => _musicVideoResults;
  List<Photo> get photoResults => _photoResults;
  int get totalCandidates => _service.totalCandidates;
  int get processed => _service.processed;

  Future<void> _restoreFromCache() async {
    await _service.loadFromCache();
  }

  Future<void> startScan(
    String rootDir,
    ContentType contentType, {
    bool clearExisting = true,
  }) async {
    _status = 'Starting scan...';
    _progress = 0.0;
    notifyListeners();
    await _service.startScan(
      rootDir,
      contentType,
      clearExisting: clearExisting,
    );
  }

  void cancel() {
    _service.cancel();
  }

  Future<void> scanAllAndFetchMetadata(UserDataService userDataService) async {
    _status = 'Scanning all libraries...';
    _progress = 0.0;
    notifyListeners();

    final entries = <MapEntry<ContentType, List<String>>>[
      MapEntry(ContentType.movie, userDataService.moviesLibraryPaths),
      MapEntry(ContentType.tvSeries, userDataService.seriesLibraryPaths),
      MapEntry(ContentType.music, userDataService.musicLibraryPaths),
      MapEntry(ContentType.musicVideo, userDataService.musicVideoLibraryPaths),
      MapEntry(ContentType.photo, userDataService.photoLibraryPaths),
      MapEntry(ContentType.mixed, userDataService.mixedLibraryPaths),
    ];

    for (final entry in entries) {
      final paths = entry.value;
      if (paths.isEmpty) continue;

      for (var i = 0; i < paths.length; i++) {
        await startScan(
          paths[i],
          entry.key,
          clearExisting: i == 0,
        );
      }
    }

    await _service.fetchTmdbMetadata();
  }

  Future<void> fetchTmdbMetadata() async {
    _status = 'Fetching TMDB metadata...';
    _progress = 0.0;
    notifyListeners();
    await _service.fetchTmdbMetadata();
  }

  @override
  void dispose() {
    for (final s in _subs) {
      s.cancel();
    }
    _service.dispose();
    super.dispose();
  }
}
