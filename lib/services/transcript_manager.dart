import 'package:flutter/foundation.dart';

import 'package:miko/models/audio.dart';
import 'package:miko/models/transcribe.dart';
import 'package:miko/providers/audio_provider.dart';
import 'package:miko/services/transcribe_persist_service.dart';

class TranscriptionCacheProvider with ChangeNotifier {
  final TranscriptionCacheService _cacheService;
  final PlaylistProvider _playlistProvider;

  VerboseTranscription? _cachedTranscript;
  bool _isLoading = false;
  AudioFileModel? _currentSong;

  // Incrementing counter to identify which load is active.
  int _loadCounter = 0;
  int _activeLoadId = 0;

  TranscriptionCacheProvider(this._cacheService, this._playlistProvider) {
    _playlistProvider.addListener(_onSongChanged);
    _onSongChanged(); // Initial load (non-awaited by design)
  }

  VerboseTranscription? get cachedTranscript => _cachedTranscript;
  bool get isLoading => _isLoading;
  AudioFileModel? get currentSong => _currentSong;

  Future<void> _onSongChanged() async {
    final newSong = _playlistProvider.currentSong;
    if (newSong != null && newSong.id != _currentSong?.id) {
      _currentSong = newSong;
      await loadTranscriptForCurrentSong();
    } else if (newSong == null) {
      _currentSong = null;
      _cachedTranscript = null;
      notifyListeners();
    }
  }

  /// Loads transcript for the current song.
  /// If [force] is true, forces a fresh load even if a transcript is already present.
  Future<void> loadTranscriptForCurrentSong({bool force = false}) async {
    if (_currentSong == null) return;

    // If not forcing and we already have a cached transcript for the same song, just return.
    // (Optional behavior — if you always want to reload, call with force: true)
    if (!force && _cachedTranscript != null) {
      // Ensure transcript in memory belongs to the current song.
      // If it doesn't (shouldn't normally happen), proceed to reload.
      // We keep this early-return to avoid unnecessary reloads.
      return;
    }

    final String songId = _currentSong!.id;

    // Start a new load and mark it active with an id to avoid race conditions.
    final int currentLoadId = ++_loadCounter;
    _activeLoadId = currentLoadId;

    _isLoading = true;
    _cachedTranscript = null; // Clear old transcript while loading
    notifyListeners();

    final VerboseTranscription? result = await _cacheService.loadTranscript(
      songId,
    );

    // If another load started after this one, discard this result.
    if (_activeLoadId != currentLoadId) {
      // Ensure we turn off isLoading only if this load was the active one that set it.
      // Another load likely set isLoading true again; do nothing here.
      return;
    }

    // If current song changed since this load started, discard the result.
    if (_currentSong?.id != songId) {
      return;
    }

    _cachedTranscript = result;
    _isLoading = false;
    notifyListeners();
  }

  /// Forces reloading the transcript for the current song.
  Future<void> regenerateTranscriptForCurrentSong() async {
    if (_currentSong == null) return;
    await loadTranscriptForCurrentSong(force: true);
  }

  Future<void> saveTranscriptForCurrentSong(
    VerboseTranscription transcript,
  ) async {
    if (_currentSong == null) return;
    final String songId = _currentSong!.id;
    await _cacheService.saveTranscript(songId, transcript);

    // Only update in-memory cache if the current song is still the same song we saved for.
    if (_currentSong?.id == songId) {
      _cachedTranscript = transcript;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _playlistProvider.removeListener(_onSongChanged);
    super.dispose();
  }
}
