import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart' as a;
import 'package:miko/mycore/settings_service.dart';
import 'package:siri_wave/siri_wave.dart';
import 'package:just_audio/just_audio.dart' as j;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miko/mycore/ai_core_service.dart';
import 'package:uuid/uuid.dart';



class GrowingBytesAudioSource extends j.StreamAudioSource {
  final StreamController<Uint8List> _controller = StreamController.broadcast();
  final String contentType;

  GrowingBytesAudioSource({this.contentType = 'audio/wav'});

  void addChunk(Uint8List bytes) {
    if (!_controller.isClosed) _controller.add(bytes);
  }

  Future<void> close() async {
    await _controller.close();
  }

  @override
  Future<j.StreamAudioResponse> request([int? start, int? end]) async {
    // Provide a continuous stream of bytes. Just Audio will read until stream ends.
    return j.StreamAudioResponse(
      sourceLength: null,
      contentLength: null,
      offset: start ?? 0,
      contentType: contentType,
      stream: _controller.stream,
      rangeRequestsSupported: false,
    );
  }
}

class AudioPlaybackController {
  final j.AudioPlayer _player = j.AudioPlayer();
  GrowingBytesAudioSource? _streamSource;

  Future<void> setBytes(Uint8List bytes, {String contentType = 'audio/wav'}) async {
    await _player.setAudioSource(BytesAudioSource(bytes, contentType: contentType));
  }

  Future<void> startStreaming({String contentType = 'audio/wav'}) async {
    _streamSource = GrowingBytesAudioSource(contentType: contentType);
    await _player.setAudioSource(_streamSource!);
  }

  void appendStreamChunk(Uint8List bytes) {
    _streamSource?.addChunk(bytes);
  }

  Future<void> endStreaming() async {
    await _streamSource?.close();
    _streamSource = null;
  }

  Future<void> play() => _player.play();
  Future<void> pause() => _player.pause();
  Future<void> stop() => _player.stop();
  Future<void> dispose() => _player.dispose();
}

class BytesAudioSource extends j.StreamAudioSource {
  final Uint8List bytes;
  final String contentType;
  BytesAudioSource(this.bytes, {this.contentType = 'audio/wav'});

  @override
  Future<j.StreamAudioResponse> request([int? start, int? end]) async {
    final int s = start ?? 0;
    final int e = end ?? bytes.length;
    return j.StreamAudioResponse(
      sourceLength: bytes.length,
      contentLength: e - s,
      offset: s,
      contentType: contentType,
      stream: Stream.value(Uint8List.sublistView(bytes, s, e)),
      rangeRequestsSupported: true,
    );
  }
}


class AudioPlayerTile extends StatefulWidget {
  final Uint8List bytes;
  
  // SOLVES PROBLEM 1: Add a flag to control autoplay.
  // Default is 'false' so existing widgets don't autoplay on restart.
  final bool autoPlay;
  final StorageSettingsService settingsService;
  final File? file;

  const AudioPlayerTile({
    super.key,
    required this.bytes,
    this.autoPlay = false,
    required this.settingsService,
    this.file
  });

  @override
  State<AudioPlayerTile> createState() => _AudioPlayerTileState();
}

class _AudioPlayerTileState extends State<AudioPlayerTile> {
  final _player = a.AudioPlayer();
  final _siriController = IOS9SiriWaveformController(
    amplitude: 0.0,
    speed: 0.1,
  );

  a.PlayerState _playerState = a.PlayerState.stopped;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerStateSubscription;

  bool get _isPlaying => _playerState == a.PlayerState.playing;
  bool get _isReady => _playerState != a.PlayerState.stopped || _duration > Duration.zero;

  @override
  void initState() {
    super.initState();
        _initAudioPlayer();

    _playerStateSubscription = _player.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() => _playerState = state);
      _updateWaveform();
    });

    _durationSubscription = _player.onDurationChanged.listen((duration) {
      if (!mounted) return;
      setState(() => _duration = duration);
    });

    _positionSubscription = _player.onPositionChanged.listen((position) {
      if (!mounted) return;
      setState(() => _position = position);
    });

    _initAudioPlayer();
  }
  
  Uint8List _maybeDecodeBase64(Uint8List input) {
    try {
      final asString = utf8.decode(input, allowMalformed: true).trim();
      if (asString.length % 4 == 0) {
        return base64Decode(asString);
      }
      return input;
    } catch (_) {
      return input;
    }
  }

  Future<void> _initAudioPlayer() async {
    try {
      final audioBytes = _maybeDecodeBase64(widget.bytes);
      debugPrint("Audio bytes length: ${audioBytes.length}");
      await _player.setSource(a.BytesSource(audioBytes));
      debugPrint("Audio source set successfully.");

      // SOLVES PROBLEM 1: Only play if the 'autoPlay' flag is true.
      if (widget.settingsService.isAudioPlaying) {
        // We call our new, smarter _play() method.
        await _play();
      }
    } catch (e) {
      debugPrint("Error setting audio source: $e");
      debugPrint("Stack trace: ${StackTrace.current}");
    }
  }

  void _updateWaveform() {
    if (_isPlaying) {
      _siriController.amplitude = 0.7;
    } else {
      _siriController.amplitude = 0.0;
    }
  }

  // SOLVES PROBLEM 2: A smarter play function that can handle replay.
  Future<void> _play() async {
    if (_playerState == a.PlayerState.completed) {
      // If the audio finished, seek to the beginning to replay.
      await _player.seek(Duration.zero);
      await _player.resume();
      widget.settingsService.setIsAudioPlaying(false);

    } else {
      // For any other state (paused, stopped), just resume.
      await _player.resume();
      widget.settingsService.setIsAudioPlaying(false);
    }
  }

  Future<void> _pause() async {
    await _player.pause();
          widget.settingsService.setIsAudioPlaying(false);

  }

  @override
  void dispose() {
          widget.settingsService.setIsAudioPlaying(false);

    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerStateSubscription?.cancel();
    _player.dispose();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            IconButton(
              icon: Icon(_isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill),
              iconSize: 48,
              color: theme.primaryColor,
              onPressed: (_isPlaying ? _pause : _play) ,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SiriWaveform.ios9(
                    controller: _siriController,
                    options: const IOS9SiriWaveformOptions(
                      height: 60,
                      width: double.infinity,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_formatDuration(_position), style: theme.textTheme.bodySmall),
                      Text(_formatDuration(_duration), style: theme.textTheme.bodySmall),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}