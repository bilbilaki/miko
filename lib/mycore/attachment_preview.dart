// lib/ui/widgets/attachment_preview.dart
import 'dart:convert';
import 'package:flutter/material.dart';

import 'ai_core_models.dart';
import 'audio_player_tile.dart';

class AttachmentPreview extends StatelessWidget {
 final List<Attachment> attachments;
 final void Function(int index)? onRemove;

 const AttachmentPreview({super.key, required this.attachments, this.onRemove});

 @override
 Widget build(BuildContext context) {
 if (attachments.isEmpty) return const SizedBox.shrink();
 return Wrap(
 spacing: 8,
 runSpacing: 8,
 children: [
 for (int i = 0; i < attachments.length; i++)
 _buildChip(context, attachments[i], i),
 ],
 );
 }

 Widget _buildChip(BuildContext context, Attachment a, int index) {
 return a.map(
 image: (img) {
 final bytes = base64Decode(img.base64Data);
 return Stack(
 alignment: Alignment.topRight,
 children: [
 ClipRRect(
 borderRadius: BorderRadius.circular(8),
 child: Image.memory(bytes, width: 96, height: 96, fit: BoxFit.cover),
 ),
 if (onRemove != null)
 _removeBtn(index),
 ],
 );
 },
 audio: (aud) {
 return Container(
 width: 240,
 padding: const EdgeInsets.all(8),
 decoration: BoxDecoration(
 color: Theme.of(context).colorScheme.surfaceVariant,
 borderRadius: BorderRadius.circular(8),
 ),
 child: Stack(
 children: [
 Column(
 crossAxisAlignment: CrossAxisAlignment.start,
 children: [
 const Text('Audio attachment', style: TextStyle(fontSize: 12)),
 const SizedBox(height: 4),
 AudioPlayerTile(bytes: aud.bytes, mimeType: aud.format.mimeType),
 ],
 ),
 if (onRemove != null)
 Positioned(top: 0, right: 0, child: _removeBtn(index)),
 ],
 ),
 );
 },
 file: (file) {
 return InputChip(
 label: Text(file.fileName),
 avatar: const Icon(Icons.insert_drive_file_outlined),
 onDeleted: onRemove != null ? () => onRemove!(index) : null,
 );
 },
 chunk: (chunk) {
 return InputChip(
 label: Text(chunk.sourceName ?? 'Text chunk'),
 avatar: const Icon(Icons.notes_outlined),
 onDeleted: onRemove != null ? () => onRemove!(index) : null,
 );
 },
 );
 }

 Widget _removeBtn(int index) {
 return Material(
 color: Colors.black54,
 shape: const CircleBorder(),
 child: InkWell(
 customBorder: const CircleBorder(),
 onTap: () => onRemove?.call(index),
 child: const Padding(
 padding: EdgeInsets.all(2),
 child: Icon(Icons.close, size: 16, color: Colors.white),
 ),
 ),
 );
 }
}