part of '../page/home/home.dart';

class AudioPlayerTile extends StatefulWidget {
  final Uint8List bytes;
  final bool autoPlay;
  final File? file;

  const AudioPlayerTile({
    super.key,
    required this.bytes,
    this.autoPlay = false,
    this.file,
  });

  @override
  State<AudioPlayerTile> createState() => _AudioPlayerTileState();
}

class _AudioPlayerTileState extends State<AudioPlayerTile> {
  final _player = AudioPlayer();
  final _siriController = IOS9SiriWaveformController(
    amplitude: 0.0,
    speed: 0.1,
  );

  PlayerState _playerState = PlayerState.stopped;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerStateSubscription;

  bool get _isPlaying => _playerState == PlayerState.playing;

  @override
  void initState() {
    super.initState();

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

  Future<void> _initAudioPlayer() async {
    try {
      await _player.setSource(BytesSource(widget.bytes));
      if (ss.voicePlayedUntilNow.get() == false) {
        ss.voicePlayedUntilNow.set(true);

        await _play();
      }
    } catch (e) {
      debugPrint("Error setting audio source: $e");
      debugPrint("Stack trace: ${StackTrace.current}");
    }
  }

  void _updateWaveform() {
    _siriController.amplitude = _isPlaying ? 0.7 : 0.0;
  }

  Future<void> _play() async {
    if (_playerState == PlayerState.completed) {
      await _player.seek(Duration.zero);
    }

    await _player.resume();
  }

  Future<void> _pause() async {
    await _player.pause();
  }

  @override
  void dispose() {
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
              icon: Icon(
                _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
              ),
              iconSize: 48,
              color: theme.primaryColor,
              onPressed: _isPlaying ? _pause : _play,
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
                      Text(
                        _formatDuration(_position),
                        style: theme.textTheme.bodySmall,
                      ),
                      Text(
                        _formatDuration(_duration),
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
