// TODO Implement this library.

import 'dart:io';

import 'package:flutter/material.dart';

import 'package:miko/models/audio.dart';
import 'package:miko/models/transcribe.dart';
import 'package:miko/providers/audio_provider.dart';
import 'package:miko/providers/transcribe_provider.dart' hide TranscriptionCacheProvider;
import 'package:miko/services/transcript_manager.dart';
import 'package:provider/provider.dart';

class LyricsView extends StatefulWidget {
  final TabController tabController;

  const LyricsView({super.key, required this.tabController});

  @override
  State<LyricsView> createState() => _LyricsViewState();
}

class _LyricsViewState extends State<LyricsView> {
  final ScrollController _scrollController = ScrollController();
  int _activeSegmentIndex = -1;

  List<GlobalKey> _lineKeys = [];

  VoidCallback? _transcriptionListener;
  VoidCallback? _playbackListener;

  void _startTranscription(BuildContext context, AudioFileModel song) {
    final provider = context.read<TranscriptionProviderSegmental>();
    provider.transcribeFile(
      file: File(song.path),
      responseFormat: 'verbose_json',
      timestampGranularities: ['word', 'segment'],
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final transcriptionProvider = context
        .read<TranscriptionProviderSegmental>();
    if (_transcriptionListener != null) {
      transcriptionProvider.removeListener(_transcriptionListener!);
    }
    _transcriptionListener = () {
      if (!transcriptionProvider.isLoading &&
          transcriptionProvider.verboseResult != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          context
              .read<TranscriptionCacheProvider>()
              .saveTranscriptForCurrentSong(
                transcriptionProvider.verboseResult!,
              );
        });
      }
      _rebuildLineKeysIfNeeded(transcriptionProvider.verboseResult);
      if (mounted) {
        setState(() {
          _activeSegmentIndex = -1;
        });
      }
    };
    transcriptionProvider.addListener(_transcriptionListener!);

    final playbackProvider = context.read<PlaybackStateProvider>();
    if (_playbackListener != null) {
      playbackProvider.removeListener(_playbackListener!);
    }
    _playbackListener = () {
      _updateActiveSegmentAndScroll();
    };
    playbackProvider.addListener(_playbackListener!);

    _rebuildLineKeysIfNeeded(
      context.read<TranscriptionCacheProvider>().cachedTranscript ??
          transcriptionProvider.verboseResult,
    );
  }

  void _rebuildLineKeysIfNeeded(VerboseTranscription? transcript) {
    final segCount = transcript?.segments?.length ?? 0;
    if (_lineKeys.length != segCount) {
      _lineKeys = List.generate(segCount, (_) => GlobalKey());
    }
  }

  void _updateActiveSegmentAndScroll() {
    if (!mounted) return;
    final playbackProvider = context.read<PlaybackStateProvider>();
    final cacheProvider = context.read<TranscriptionCacheProvider>();
    final transcriptionProvider = context
        .read<TranscriptionProviderSegmental>();

    final transcript =
        cacheProvider.cachedTranscript ?? transcriptionProvider.verboseResult;
    if (transcript == null ||
        transcript.segments == null ||
        transcript.segments!.isEmpty) {
      if (_activeSegmentIndex != -1) {
        setState(() => _activeSegmentIndex = -1);
      }
      return;
    }

    final currentMs = playbackProvider.currentPosition.inMilliseconds
        .toDouble();
    final segments = transcript.segments!;
    int newIndex = -1;

    for (int i = 0; i < segments.length; i++) {
      final seg = segments[i];
      final startMs = (seg.start ?? 0) * 1000.0;
      final endMs = (seg.end ?? double.infinity) * 1000.0;
      if (currentMs >= startMs && currentMs < endMs) {
        newIndex = i;
        break;
      }
    }

    if (newIndex != _activeSegmentIndex) {
      setState(() {
        _activeSegmentIndex = newIndex;
      });

      if (newIndex >= 0 && newIndex < _lineKeys.length) {
        final key = _lineKeys[newIndex];
        if (key.currentContext != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            try {
              Scrollable.ensureVisible(
                key.currentContext!,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                alignment: 0.5,
              );
            } catch (_) {}
          });
        }
      }
    }
  }

  @override
  void dispose() {
    if (_transcriptionListener != null) {
      try {
        context.read<TranscriptionProviderSegmental>().removeListener(
          _transcriptionListener!,
        );
      } catch (_) {}
    }
    if (_playbackListener != null) {
      try {
        context.read<PlaybackStateProvider>().removeListener(
          _playbackListener!,
        );
      } catch (_) {}
    }
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cacheProvider = context.watch<TranscriptionCacheProvider>();
    final transcriptionProvider = context
        .watch<TranscriptionProviderSegmental>();
    final playbackSong = context.select(
      (PlaybackStateProvider p) => p.currentSong,
    );

    if (playbackSong == null) {
      return const Center(child: Text("No song is playing."));
    }

    if (cacheProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (transcriptionProvider.isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text("Generating transcript, this may take a moment..."),
          ],
        ),
      );
    }

    if (transcriptionProvider.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
            const SizedBox(height: 16),
            const Text("Transcription Failed", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text(
              transcriptionProvider.error!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                transcriptionProvider.clear();
                _startTranscription(context, playbackSong);
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    final result =
        cacheProvider.cachedTranscript ?? transcriptionProvider.verboseResult;

    if (result != null) {
      _rebuildLineKeysIfNeeded(result);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _updateActiveSegmentAndScroll();
      });

      return _buildTranscriptContent(result);
    }

    return Center(
      child: ElevatedButton.icon(
        icon: const Icon(Icons.text_snippet_outlined),
        label: const Text('Generate Transcript'),
        onPressed: () => _startTranscription(context, playbackSong),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildTranscriptContent(VerboseTranscription transcript) {
    final playbackProvider = context.watch<PlaybackStateProvider>();
    final currentMs = playbackProvider.currentPosition.inMilliseconds
        .toDouble();

    if (transcript.segments == null || transcript.segments!.isEmpty) {
      return Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            transcript.text,
            style: const TextStyle(fontSize: 18, height: 1.6),
          ),
        ),
      );
    }

    final segments = transcript.segments!;

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      itemCount: segments.length,
      itemBuilder: (context, index) {
        final segment = segments[index];
        final startMs = (segment.start ?? 0) * 1000.0;
        final endMs = (segment.end ?? double.infinity) * 1000.0;
        final isActive = currentMs >= startMs && currentMs < endMs;

        final key = (index < _lineKeys.length) ? _lineKeys[index] : null;

        final activeColor = Theme.of(context).colorScheme.primary;
        final inactiveColor = Colors.white;

        return Padding(
          key: key,
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeInOut,
            style: TextStyle(
              fontSize: 18,
              height: 1.5,
              color: isActive ? activeColor : inactiveColor,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 160),
              opacity: isActive ? 1.0 : 0.9,
              child: Text(
                segment.text?.trim() ?? '',
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        );
      },
    );
  }
}
