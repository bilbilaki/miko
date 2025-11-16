import 'dart:async';

import 'package:flutter/material.dart';
import 'package:miko/models/local_library/directory_entry.dart';
import 'package:miko/services/local_scan_service.dart';
import 'package:miko/models/local_library/movie.dart';
import 'package:miko/models/local_library/tv_series.dart';
import 'package:miko/models/local_library/music.dart';
import 'package:miko/models/local_library/music_video.dart';
import 'package:miko/models/local_library/photo.dart';

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
  double get progress => _progress;
  String get status => _status;
  List<Movie> get movieResults => _movieResults;
  List<TvSeries> get tvResults => _tvResults;
  List<Music> get musicResults => _musicResults;
  List<MusicVideo> get musicVideoResults => _musicVideoResults;
  List<Photo> get photoResults => _photoResults;
  int get totalCandidates => _service.totalCandidates;
  int get processed => _service.processed;

  Future<void> startScan(String rootDir, ContentType contentType) async {
    _status = 'Starting scan...';
    _progress = 0.0;
    notifyListeners();
    await _service.startScan(rootDir, contentType);
  }

  void cancel() {
    _service.cancel();
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
