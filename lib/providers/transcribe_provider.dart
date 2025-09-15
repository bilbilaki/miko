// lib/providers/transcription_cache_provider.dart
import 'package:flutter/foundation.dart';

import 'package:miko/models/audio.dart';
import 'package:miko/models/transcribe.dart';
import 'package:miko/providers/audio_provider.dart';
import 'package:miko/services/transcribe_persist_service.dart';
import 'dart:async';
import 'dart:io';

import 'package:miko/services/transcription_service.dart';

enum TranscriptionState { idle, loading, streaming, done, error }

class TranscriptionProvider extends ChangeNotifier {
  final TranscriptionService _service;

  TranscriptionProvider({TranscriptionService? service})
    : _service = service ?? TranscriptionService();

  TranscriptionState _state = TranscriptionState.idle;
  String _accumulatedText = '';
  String? _finalText;
  String? _error;
  List<TranscriptDelta> _deltas = [];
  StreamSubscription<TranscriptDelta?>? _streamSub;

  TranscriptionState get state => _state;
  String get accumulatedText => _accumulatedText;
  String? get finalText => _finalText;
  String? get error => _error;
  List<TranscriptDelta> get deltas => List.unmodifiable(_deltas);

  void _setState(TranscriptionState s) {
    _state = s;
    notifyListeners();
  }

  void reset() {
    _accumulatedText = '';
    _finalText = null;
    _error = null;
    _deltas = [];
    _streamSub?.cancel();
    _streamSub = null;
    _setState(TranscriptionState.idle);
  }

  Future<void> transcribeOnce(File file) async {
    reset();
    _setState(TranscriptionState.loading);
    try {
      final resp = await _service.transcribeFile(file);
      _finalText = resp.text;
      _accumulatedText = resp.text;
      _setState(TranscriptionState.done);
    } catch (e) {
      _error = e.toString();
      _setState(TranscriptionState.error);
    }
  }

  /// Start streaming transcription and accumulate deltas into accumulatedText.
  /// Caller can listen to notifyListeners updates to show partial results.
  Future<void> startStreaming(
    File file, {
    String model = 'gpt-4o-mini-transcribe',
  }) async {
    reset();
    _setState(TranscriptionState.streaming);
    try {
      final stream = _service.streamTranscribeFile(
        file,
        model: model,
        stream: true,
      );
      _streamSub = stream.listen(
        (delta) {
          //if (delta == null) return;
          _deltas.add(delta);
          if (delta.delta != null) {
            // Append partial delta text
            _accumulatedText += delta.delta!;
          }
          if (delta.isDone) {
            if (delta.text != null && delta.text!.isNotEmpty) {
              _finalText = delta.text;
              _accumulatedText = delta.text!;
            }
            _setState(TranscriptionState.done);
          } else {
            // still streaming
            notifyListeners();
          }
        },
        onError: (err) {
          _error = err.toString();
          _setState(TranscriptionState.error);
        },
        onDone: () {
          if (_state != TranscriptionState.done &&
              _state != TranscriptionState.error) {
            _setState(TranscriptionState.done);
          }
        },
        cancelOnError: true,
      );
    } catch (e) {
      _error = e.toString();
      _setState(TranscriptionState.error);
    }
  }

  Future<void> stopStreaming() async {
    await _streamSub?.cancel();
    _streamSub = null;
    if (_state == TranscriptionState.streaming)
      _setState(TranscriptionState.done);
  }

  @override
  void dispose() {
    _streamSub?.cancel();
    _service.dispose();
    super.dispose();
  }
}

class TranscriptionProviderSegmental extends ChangeNotifier {
  TranscriptionService service;

  bool _isLoading = false;
  String? _error;
  SimpleTranscription? _simple;
  VerboseTranscription? _verbose;

  TranscriptionProviderSegmental({required this.service});

  bool get isLoading => _isLoading;
  String? get error => _error;
  SimpleTranscription? get simpleResult => _simple;
  VerboseTranscription? get verboseResult => _verbose;

  void _setLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }

  void _setError(String? e) {
    _error = e;
    notifyListeners();
  }

  void clear() {
    _error = null;
    _simple = null;
    _verbose = null;
    notifyListeners();
  }

  Future<void> transcribeFile({
    required File file,
    String model = 'whisper-1',
    String responseFormat = 'verbose_json',
    List<String>? timestampGranularities,
    bool includeLogprobs = false,
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      final res = await service.transcribe(
        file: file,
        model: model,
        responseFormat: responseFormat,
        timestampGranularities: timestampGranularities,
        includeLogprobs: includeLogprobs,
      );

      if (res is VerboseTranscription) {
        _verbose = res;
        _simple = null;
      } else if (res is SimpleTranscription) {
        _simple = res;
        _verbose = null;
      } else {
        // Unknown; clear both and set error to raw type
        _simple = null;
        _verbose = null;
        _setError('Unsupported transcription response format.');
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }
}

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
