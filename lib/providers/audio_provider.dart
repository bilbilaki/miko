import 'dart:convert';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:miko/models/audio.dart';
import 'package:miko/services/audio_player.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettingsProvider with ChangeNotifier {
  final SharedPreferences _prefs;
  static const String _settingsKey = 'appSettings';

  AppSettingsModel _settings;

  AppSettingsProvider(this._prefs) : _settings = AppSettingsModel() {
    _loadSettings();
  }

  AppSettingsModel get settings => _settings;
  double get volume => _settings.volume;
  ShuffleMode get shuffleMode => _settings.shuffleMode;
  LoopMode get loopMode => _settings.loopMode;

  Future<void> _loadSettings() async {
    final String? settingsJson = _prefs.getString(_settingsKey);
    if (settingsJson != null) {
      _settings = AppSettingsModel.fromJson(jsonDecode(settingsJson));
    }
    notifyListeners();
  }

  Future<void> _saveSettings() async {
    await _prefs.setString(_settingsKey, jsonEncode(_settings.toJson()));
  }

  void setVolume(double value) {
    if (_settings.volume != value) {
      _settings.volume = value;
      _saveSettings();
      notifyListeners();
    }
  }

  void toggleShuffleMode() {
    _settings.shuffleMode = _settings.shuffleMode == ShuffleMode.off
        ? ShuffleMode.on
        : ShuffleMode.off;
    _saveSettings();
    notifyListeners();
  }

  void toggleLoopMode() {
    switch (_settings.loopMode) {
      case LoopMode.off:
        _settings.loopMode = LoopMode.all;
        break;
      case LoopMode.all:
        _settings.loopMode = LoopMode.one;
        break;
      case LoopMode.one:
        _settings.loopMode = LoopMode.off;
        break;
    }
    _saveSettings();
    notifyListeners();
  }
}

// providers/audio_files_provider.dart
// Manages the list of all scanned audio files.
class AudioFilesProvider with ChangeNotifier {
  final FileScannerService _fileScannerService;
  List<AudioFileModel> _allAudioFiles = [];

  AudioFilesProvider(this._fileScannerService);

  List<AudioFileModel> get allAudioFiles => _allAudioFiles;

  Future<void> loadAudioFiles() async {
    _allAudioFiles = await _fileScannerService.loadAudioFiles();
    notifyListeners();
  }

  Future<void> scanAndImportAudioFiles(BuildContext context) async {
    final result = await FilePicker.platform.getDirectoryPath();

    if (result != null) {
      try {
        List<AudioFileModel> scanned = await _fileScannerService.scanAudioFiles(
          result,
        );

        // Filter out duplicates and add new ones
        Set<String> existingIds = _allAudioFiles.map((e) => e.id).toSet();
        List<AudioFileModel> newFiles = [];
        for (var file in scanned) {
          if (!existingIds.contains(file.id)) {
            newFiles.add(file);
          }
        }

        if (newFiles.isNotEmpty) {
          _allAudioFiles.addAll(newFiles);
          await _fileScannerService.saveAudioFiles(_allAudioFiles);
          notifyListeners();
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Scanned ${newFiles.length} new audio files.'),
              ),
            );
          }
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('No new audio files found or imported.'),
              ),
            );
          }
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error scanning files: $e')));
        }
      }
    }
  }

  // Sorting functionality example (can be expanded)
  void sortAudioFiles(Comparator<AudioFileModel> comparator) {
    _allAudioFiles.sort(comparator);
    notifyListeners();
  }
}

// providers/playlist_provider.dart
// Manages the current playlist and all playback logic.
class PlaylistProvider with ChangeNotifier {
  final AudioPlayerService _audioPlayerService;
  final AppSettingsProvider _appSettingsProvider;

  PlaylistModel _currentPlaylist = PlaylistModel(name: 'Default', songs: []);
  int _currentSongIndex = -1;
  List<int> _shuffledIndices = [];
  int _currentShuffledIndex = -1;

  PlaylistProvider(this._audioPlayerService, this._appSettingsProvider) {
    _appSettingsProvider.addListener(_onAppSettingsChanged);
    _audioPlayerService.onPlayerComplete.listen((_) {
      _handleSongCompletion();
    });
  }

  PlaylistModel get currentPlaylist => _currentPlaylist;
  int get currentSongIndex => _currentSongIndex;
  AudioFileModel? get currentSong =>
      _currentSongIndex >= 0 &&
          _currentSongIndex < _currentPlaylist.songs.length
      ? _currentPlaylist.songs[_currentSongIndex]
      : null;

  void _onAppSettingsChanged() {
    _audioPlayerService.setVolume(_appSettingsProvider.volume);
    _audioPlayerService.setLoopMode(_appSettingsProvider.loopMode);
    notifyListeners(); // Notify listeners if settings directly affect UI
  }

  void setPlaylist(List<AudioFileModel> songs, int startIndex) async {
    if (songs.isEmpty) {
      _currentPlaylist = PlaylistModel(name: 'Default', songs: []);
      _currentSongIndex = -1;
      _shuffledIndices = [];
      _currentShuffledIndex = -1;
      _audioPlayerService.stop();
    } else {
      _currentPlaylist = PlaylistModel(
        name: 'Current Playlist',
        songs: List.from(songs),
      );
      _currentSongIndex = startIndex;
      _generateShuffledIndices();
      _currentShuffledIndex = _shuffledIndices.indexOf(startIndex);
      await _playCurrentSong();
    }
    notifyListeners();
  }

  void _generateShuffledIndices() {
    _shuffledIndices = List<int>.generate(
      _currentPlaylist.songs.length,
      (i) => i,
    );
    if (_appSettingsProvider.shuffleMode == ShuffleMode.on) {
      _shuffledIndices.shuffle(Random());
      // Ensure the current song remains the first in shuffled order if playing
      if (_currentSongIndex != -1) {
        final int currentSongActualIndex = _currentSongIndex;
        _shuffledIndices.remove(currentSongActualIndex);
        _shuffledIndices.insert(0, currentSongActualIndex);
        _currentShuffledIndex = 0;
      }
    }
  }

  Future<void> _playCurrentSong() async {
    if (currentSong != null) {
      await _audioPlayerService.play(
        currentSong!.path,
        isLocal: currentSong!.sourceType == AudioSourceType.file,
      );
      await _audioPlayerService.setVolume(_appSettingsProvider.volume);
      // Loop mode for single song handled by `_handleSongCompletion`
      await _audioPlayerService.setLoopMode(_appSettingsProvider.loopMode);
    }
  }

  void togglePlayPause() async {
    final playerState = await _audioPlayerService.audioPlayer
        .getCurrentPosition();
    if (playerState == PlayerState.playing) {
      await _audioPlayerService.pause();
    } else if (playerState == PlayerState.paused ||
        playerState == PlayerState.stopped ||
        playerState == PlayerState.completed) {
      if (currentSong == null) {
        // If no song is playing, start from the first or a default song
        if (_currentPlaylist.songs.isNotEmpty) {
          setPlaylist(_currentPlaylist.songs, 0);
        }
      } else {
        await _audioPlayerService.resume();
      }
    }
    notifyListeners();
  }

  void playNext() async {
    if (_currentPlaylist.songs.isEmpty) return;

    if (_appSettingsProvider.loopMode == LoopMode.one) {
      // If loop one is on, just replay the current song
      await _playCurrentSong();
      notifyListeners();
      return;
    }

    if (_appSettingsProvider.shuffleMode == ShuffleMode.on) {
      _currentShuffledIndex =
          (_currentShuffledIndex + 1) % _shuffledIndices.length;
      _currentSongIndex = _shuffledIndices[_currentShuffledIndex];
    } else {
      _currentSongIndex =
          (_currentSongIndex + 1) % _currentPlaylist.songs.length;
    }

    await _playCurrentSong();
    notifyListeners();
  }

  void playPrevious() async {
    if (_currentPlaylist.songs.isEmpty) return;

    if (_appSettingsProvider.loopMode == LoopMode.one) {
      // If loop one is on, just replay the current song
      await _playCurrentSong();
      notifyListeners();
      return;
    }

    if (_appSettingsProvider.shuffleMode == ShuffleMode.on) {
      _currentShuffledIndex =
          (_currentShuffledIndex - 1 + _shuffledIndices.length) %
          _shuffledIndices.length;
      _currentSongIndex = _shuffledIndices[_currentShuffledIndex];
    } else {
      _currentSongIndex =
          (_currentSongIndex - 1 + _currentPlaylist.songs.length) %
          _currentPlaylist.songs.length;
    }

    await _playCurrentSong();
    notifyListeners();
  }

  void playAtIndex(int index) async {
    if (index < 0 ||
        index >= _currentPlaylist.songs.length ||
        index == _currentSongIndex) {
      return;
    }
    _currentSongIndex = index;
    _generateShuffledIndices(); // Re-shuffle to place new song at front if shuffle is on
    _currentShuffledIndex = _shuffledIndices.indexOf(index);
    await _playCurrentSong();
    notifyListeners();
  }

  void seek(double milliseconds) {
    _audioPlayerService.seek(Duration(milliseconds: milliseconds.toInt()));
  }

  void replayCurrentSong() async {
    if (currentSong != null) {
      await _playCurrentSong(); // Simply call playCurrentSong again
      notifyListeners();
    }
  }

  void _handleSongCompletion() async {
    if (_currentPlaylist.songs.isEmpty) return;

    if (_appSettingsProvider.loopMode == LoopMode.one) {
      await _playCurrentSong(); // Replay the current song
    } else if (_appSettingsProvider.loopMode == LoopMode.all) {
      // Move to next song, will loop back to start automatically
      playNext();
    } else {
      // No loop, check if it's the last song
      int nextIndex;
      if (_appSettingsProvider.shuffleMode == ShuffleMode.on) {
        nextIndex = (_currentShuffledIndex + 1);
        if (nextIndex < _shuffledIndices.length) {
          _currentShuffledIndex = nextIndex;
          _currentSongIndex = _shuffledIndices[_currentShuffledIndex];
          await _playCurrentSong();
        } else {
          // End of playlist
          _audioPlayerService.stop();
          _currentSongIndex = 0; // Reset to first song but don't play
          notifyListeners();
        }
      } else {
        nextIndex = (_currentSongIndex + 1);
        if (nextIndex < _currentPlaylist.songs.length) {
          _currentSongIndex = nextIndex;
          await _playCurrentSong();
        } else {
          // End of playlist
          _audioPlayerService.stop();
          _currentSongIndex = 0; // Reset to first song but don't play
          notifyListeners();
        }
      }
    }
  }

  @override
  void dispose() {
    _appSettingsProvider.removeListener(_onAppSettingsChanged);
    _audioPlayerService.dispose();
    super.dispose();
  }
}

// providers/liked_songs_provider.dart
// Manages a list of liked songs, persisting them using SharedPreferences.
class LikedSongsProvider with ChangeNotifier {
  final SharedPreferences _prefs;
  static const String _likedSongsKey = 'likedSongs';

  List<AudioFileModel> _likedSongs = [];

  LikedSongsProvider(this._prefs) {
    loadLikedSongs();
  }

  List<AudioFileModel> get likedSongs => _likedSongs;

  bool isLiked(AudioFileModel song) {
    return _likedSongs.any((s) => s.id == song.id);
  }

  void toggleLike(AudioFileModel song) {
    if (isLiked(song)) {
      _likedSongs.removeWhere((s) => s.id == song.id);
    } else {
      _likedSongs.add(song);
    }
    _saveLikedSongs();
    notifyListeners();
  }

  Future<void> _saveLikedSongs() async {
    final List<String> jsonList = _likedSongs
        .map((file) => file.toJson())
        .map((jsonMap) => jsonEncode(jsonMap))
        .toList();
    await _prefs.setStringList(_likedSongsKey, jsonList);
  }

  Future<void> loadLikedSongs() async {
    final List<String>? jsonList = _prefs.getStringList(_likedSongsKey);
    if (jsonList != null) {
      _likedSongs = jsonList
          .map((jsonString) => AudioFileModel.fromJson(jsonDecode(jsonString)))
          .toList();
    }
    notifyListeners();
  }
}

// providers/playback_state_provider.dart
// Observes the AudioPlayerService and updates the PlaybackStateModel.
class PlaybackStateProvider with ChangeNotifier {
  final AudioPlayerService _audioPlayerService;
  final PlaylistProvider _playlistProvider;

  PlaybackStateModel _playbackState = PlaybackStateModel();

  PlaybackStateProvider(this._audioPlayerService, this._playlistProvider) {
    _audioPlayerService.onPositionChanged.listen((position) {
      _playbackState.currentPosition = position;
      notifyListeners();
    });

    _audioPlayerService.onDurationChanged.listen((duration) {
      _playbackState.totalDuration = duration ?? Duration.zero;
      notifyListeners();
    });

    _audioPlayerService.onPlayerStateChanged.listen((playerState) {
      _playbackState.playerState = playerState;
      _playbackState.isPlaying = playerState == PlayerState.playing;
      notifyListeners();
    });

    // Listen to playlist changes to update the current song in playback state
    _playlistProvider.addListener(_onPlaylistSongChanged);
  }

  PlaybackStateModel get playbackState => _playbackState;
  AudioFileModel? get currentSong => _playbackState.currentSong;
  Duration get currentPosition => _playbackState.currentPosition;
  Duration get totalDuration => _playbackState.totalDuration;
  bool get isPlaying => _playbackState.isPlaying;

  void _onPlaylistSongChanged() {
    _playbackState.currentSong = _playlistProvider.currentSong;
    // Reset position and duration when song changes
    _playbackState.currentPosition = Duration.zero;
    _playbackState.totalDuration =
        _playbackState.currentSong?.duration ?? Duration.zero;
    notifyListeners();
  }

  @override
  void dispose() {
    _playlistProvider.removeListener(_onPlaylistSongChanged);
    super.dispose();
  }
}
