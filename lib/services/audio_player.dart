import 'dart:convert';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:miko/models/audio.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';

class AudioPlayerService {
  final AudioPlayer audioPlayer = AudioPlayer();

  AudioPlayerService() {
    // Optionally configure the player here
  }

  // Getters for streams
  Stream<Duration> get onPositionChanged => audioPlayer.onPositionChanged;
  Stream<Duration?> get onDurationChanged => audioPlayer.onDurationChanged;
  Stream<PlayerState> get onPlayerStateChanged =>
      audioPlayer.onPlayerStateChanged;
  Stream<void> get onPlayerComplete => audioPlayer.onPlayerComplete;

  Future<void> play(String path, {bool isLocal = true}) async {
    await audioPlayer.stop(); // Stop any currently playing audio
    Source source;
    if (isLocal) {
      source = DeviceFileSource(path);
    } else {
      source = UrlSource(path);
    }
    await audioPlayer.play(source);
  }

  Future<void> pause() async {
    await audioPlayer.pause();
  }

  Future<void> resume() async {
    await audioPlayer.resume();
  }

  Future<void> stop() async {
    await audioPlayer.stop();
  }

  Future<void> seek(Duration position) async {
    await audioPlayer.seek(position);
  }

  Future<void> setVolume(double volume) async {
    await audioPlayer.setVolume(volume);
  }

  Future<void> setLoopMode(LoopMode mode) async {
    // audioplayers only supports loop or no loop (all)
    // for LoopMode.one, we need custom logic in PlaylistProvider
    await audioPlayer.setReleaseMode(
      mode == LoopMode.all ? ReleaseMode.loop : ReleaseMode.release,
    );
  }

  Future<void> dispose() async {
    await audioPlayer.dispose();
  }
}

// services/file_scanner_service.dart
// This service handles scanning local directories for audio files
// and persisting the list of files.
class FileScannerService {
  final SharedPreferences _prefs;
  static const String _audioFilesKey = 'audioFiles';

  FileScannerService(this._prefs);

  Future<List<AudioFileModel>> scanAudioFiles(String directoryPath) async {
    final Directory directory = Directory(directoryPath);
    List<AudioFileModel> scannedFiles = [];

    if (!await directory.exists()) {
      return scannedFiles;
    }

    final List<FileSystemEntity> entities = await directory
        .list(recursive: true, followLinks: false)
        .toList();

    for (var entity in entities) {
      if (entity is File) {
        String filePath = entity.path;
        String extension = p.extension(filePath).toLowerCase();

        // Basic check for common audio file extensions
        if (['.mp3', '.wav', '.aac', '.flac', '.ogg'].contains(extension)) {
          // For simplicity, we'll use filename as title/artist/album
          // A real app would use a metadata parser like `just_audio_background` or `flutter_audio_metadata`
          String filename = p.basenameWithoutExtension(filePath);
          String title = filename;
          String artist = 'Unknown Artist';
          String album = 'Unknown Album';

          // Simple heuristic for artist (e.g., "Artist - Song Title")
          if (filename.contains(' - ')) {
            List<String> parts = filename.split(' - ');
            if (parts.length >= 2) {
              artist = parts[0];
              title = parts.sublist(1).join(' - ');
            }
          }

          scannedFiles.add(
            AudioFileModel(
              id: AudioFileModel.generateId(filePath),
              path: filePath,
              title: title,
              artist: artist,
              album: album,
              // No actual album art extraction from file, using placeholder
              albumArtUrl: 'assets/demo.png',
              sourceType: AudioSourceType.file,
              // Duration will be updated by audioplayers when loaded
              duration: const Duration(minutes: 0, seconds: 0),
            ),
          );
        }
      }
    }
    return scannedFiles;
  }

  Future<void> saveAudioFiles(List<AudioFileModel> audioFiles) async {
    final List<String> jsonList = audioFiles
        .map((file) => file.toJson())
        .map((jsonMap) => jsonEncode(jsonMap))
        .toList();
    await _prefs.setStringList(_audioFilesKey, jsonList);
  }

  Future<List<AudioFileModel>> loadAudioFiles() async {
    final List<String>? jsonList = _prefs.getStringList(_audioFilesKey);
    if (jsonList == null) {
      return [];
    }
    return jsonList
        .map((jsonString) => AudioFileModel.fromJson(jsonDecode(jsonString)))
        .toList();
  }
}
