import 'package:audioplayers/audioplayers.dart';

enum AudioSourceType { file, network, asset }

class AudioFileModel {
  final String id;
  final String path;
  final String title;
  final String artist;
  final String album;
  final String? albumArtUrl; // Path to asset or URL
  final Duration duration;
  final AudioSourceType sourceType; // Added to distinguish source types

  AudioFileModel({
    required this.id,
    required this.path,
    required this.title,
    this.artist = 'Unknown Artist',
    this.album = 'Unknown Album',
    this.albumArtUrl,
    this.duration = const Duration(minutes: 4, seconds: 0), // Default duration
    this.sourceType = AudioSourceType.file,
  });

  // Factory constructor for creating an instance from a JSON map
  factory AudioFileModel.fromJson(Map<String, dynamic> json) {
    return AudioFileModel(
      id: json['id'],
      path: json['path'],
      title: json['title'],
      artist: json['artist'],
      album: json['album'],
      albumArtUrl: json['albumArtUrl'],
      duration: Duration(milliseconds: json['durationMs']),
      sourceType: AudioSourceType.values[json['sourceType']],
    );
  }

  // Method for converting an instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'path': path,
      'title': title,
      'artist': artist,
      'album': album,
      'albumArtUrl': albumArtUrl,
      'durationMs': duration.inMilliseconds,
      'sourceType': sourceType.index,
    };
  }

  // Helper for generating unique ID
  static String generateId(String path) {
    return path.hashCode.toString(); // Simple hash of the path for ID
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AudioFileModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

// models/playlist_model.dart
class PlaylistModel {
  final String name;
  final List<AudioFileModel> songs;

  PlaylistModel({required this.name, required this.songs});

  // You might add toJson/fromJson if you plan to persist playlists
}

// models/app_settings_model.dart
enum ShuffleMode { off, on }

enum LoopMode { off, all, one }

class AppSettingsModel {
  double volume;
  ShuffleMode shuffleMode;
  LoopMode loopMode;

  AppSettingsModel({
    this.volume = 0.5,
    this.shuffleMode = ShuffleMode.off,
    this.loopMode = LoopMode.off,
  });

  // To/from JSON for persistence
  factory AppSettingsModel.fromJson(Map<String, dynamic> json) {
    return AppSettingsModel(
      volume: json['volume'] as double,
      shuffleMode: ShuffleMode.values[json['shuffleMode'] as int],
      loopMode: LoopMode.values[json['loopMode'] as int],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'volume': volume,
      'shuffleMode': shuffleMode.index,
      'loopMode': loopMode.index,
    };
  }
}

// models/playback_state_model.dart
class PlaybackStateModel {
  AudioFileModel? currentSong;
  Duration currentPosition;
  Duration totalDuration;
  bool isPlaying; // Based on PlayerState.playing
  PlayerState playerState; // Raw PlayerState from audioplayers

  PlaybackStateModel({
    this.currentSong,
    this.currentPosition = Duration.zero,
    this.totalDuration = Duration.zero,
    this.isPlaying = false,
    this.playerState = PlayerState.stopped,
  });

  PlaybackStateModel copyWith({
    AudioFileModel? currentSong,
    Duration? currentPosition,
    Duration? totalDuration,
    bool? isPlaying,
    PlayerState? playerState,
  }) {
    return PlaybackStateModel(
      currentSong: currentSong ?? this.currentSong,
      currentPosition: currentPosition ?? this.currentPosition,
      totalDuration: totalDuration ?? this.totalDuration,
      isPlaying: isPlaying ?? this.isPlaying,
      playerState: playerState ?? this.playerState,
    );
  }
}
