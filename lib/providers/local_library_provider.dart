import 'dart:async';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

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

  Future<bool> startScan(
    String rootDir,
    ContentType contentType, {
    bool clearExisting = true,
  }) async {
    _status = 'Starting scan...';
    _progress = 0.0;
    notifyListeners();
    final ok = await _ensurePermissionsForScan(contentType);
    if (!ok) {
      _status = 'Permission denied for scanning files';
      notifyListeners();
      return false;
    }
    await _service.startScan(
      rootDir,
      contentType,
      clearExisting: clearExisting,
    );
    return true;
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

      // Ensure permissions are granted for this content type before scanning.
      final ok = await _ensurePermissionsForScan(entry.key);
      if (!ok) {
        // Abort scanning for all libraries if permissions are missing
        _status = 'Permission denied for scanning libraries';
        notifyListeners();
        return;
      }

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

  /// Ensure the app has the necessary permission(s) for scanning local files.
  /// Returns true if scanning may proceed, false otherwise.
  Future<bool> _ensurePermissionsForScan(ContentType contentType) async {
    // Only Android needs explicit external storage permissions for scanning
    if (!Platform.isAndroid) return true;

    // First try manage external storage (Android 11+)
    try {
      final manageStatus = await Permission.manageExternalStorage.status;
      if (manageStatus.isGranted) return true;
    } catch (_) {
      // Not all platforms have this permission; ignore failures.
    }

    // Fallback: request legacy storage permission
    final storageStatus = await Permission.storage.status;
    if (!storageStatus.isGranted) {
      final req = await Permission.storage.request();
      if (req.isGranted) return true;
    } else {
      return true;
    }

    // If still not granted, try to request manageExternalStorage explicitly.
    try {
      final reqManage = await Permission.manageExternalStorage.request();
      if (reqManage.isGranted) return true;
    } catch (_) {}

    // If either permission is permanently denied, show instructions via status.
    final nowManage = await Permission.manageExternalStorage.status;
    final nowStorage = await Permission.storage.status;
    if (nowManage.isPermanentlyDenied || nowStorage.isPermanentlyDenied) {
      _status = 'Storage permission permanently denied. Please enable in app settings.';
      // do not open settings here - the UI can present an option.
      notifyListeners();
      return false;
    }

    return false;
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
