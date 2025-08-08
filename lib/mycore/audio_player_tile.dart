// lib/ui/widgets/audio_player_tile.dart
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:audioplayers/audioplayers.dart';
class AudioPlayerTile extends StatefulWidget {
 final List<int> bytes;
 final String? mimeType;

 const AudioPlayerTile({super.key, required this.bytes, this.mimeType});

 @override
 State<AudioPlayerTile> createState() => _AudioPlayerTileState();
}

class _AudioPlayerTileState extends State<AudioPlayerTile> {
 late AudioPlayer _player;
 bool _ready = false;
bool isplaying = false;
 @override
 void initState() {
 super.initState();
 _player = AudioPlayer();
 _init();
 }

 Future<void> _init() async {
 try {
 await _player.setSource(BytesSource(widget.bytes as Uint8List) );
 setState(() => _ready = true);
 } catch (_) {
 setState(() => _ready = false);
 }
 }

 @override
 void dispose() {
 _player.dispose();
 super.dispose();
 }

 @override
 Widget build(BuildContext context) {
 return Row(
 children: [
 IconButton(
 icon: Icon(isplaying ? Icons.pause_circle_filled : Icons.play_circle_fill),
 iconSize: 32,
 onPressed: _ready
 ? () async {
 if (isplaying) {
 await _player.pause();
 } else {
 await _player.seek(Duration.zero);
 await _player.play(BytesSource(widget.bytes as Uint8List));
 }
 setState(() {});
 }
 : null,
 ),
 Expanded(
 child: StreamBuilder<Duration>(
 stream: _player.onPositionChanged,
 builder: (context, snap) {
 final pos = snap.data ?? Duration.zero;
 final dur = _player.getDuration ?? Duration.zero;
 return LinearProgressIndicator(
 value: dur == 0 ? 0 : pos.inMilliseconds.toDouble(),
 minHeight: 4,
 );
 },
 ),
 ),
 ],
 );
 }
}