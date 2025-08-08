// lib/ui/widgets/message_bubble.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'ai_core_models.dart';
import 'audio_player_tile.dart';
import 'markdown_code_block.dart';

class MessageBubble extends StatelessWidget {
 final UnifiedMessage message;
 final bool isUser;
 final VoidCallback? onCopyAll;
 final VoidCallback? onEdit;
 final VoidCallback? onResendFromHere;
 final void Function(String newText)? onSubmitEdit;
 final bool isStreaming;

 const MessageBubble({
 super.key,
 required this.message,
 required this.isUser,
 this.onCopyAll,
 this.onEdit,
 this.onResendFromHere,
 this.onSubmitEdit,
 this.isStreaming = false,
 });

 @override
 Widget build(BuildContext context) {
 final bg = isUser
 ? Theme.of(context).colorScheme.primary.withOpacity(0.10)
 : Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.7);

 final bubble = Container(
 padding: const EdgeInsets.all(12),
 decoration: BoxDecoration(
 color: bg,
 borderRadius: BorderRadius.circular(12),
 ),
 child: Column(
 crossAxisAlignment: CrossAxisAlignment.stretch,
 children: [
 if ((message.text ?? '').isNotEmpty)
 _markdown(context, message.text!),
 if (message.attachments.isNotEmpty) ...[
 const SizedBox(height: 8),
 _attachments(context),
 ],
 if (isStreaming) ...[
 const SizedBox(height: 6),
 Row(
 children: [
 const SizedBox(
 width: 14,
 height: 14,
 child: CircularProgressIndicator(strokeWidth: 2),
 ),
 const SizedBox(width: 8),
 Text('Thinking...', style: Theme.of(context).textTheme.bodySmall),
 ],
 ),
 ],
 ],
 ),
 );

 return Row(
 crossAxisAlignment: CrossAxisAlignment.start,
 children: [
 if (!isUser)
 const CircleAvatar(child: Icon(Icons.smart_toy_outlined)),
 if (!isUser) const SizedBox(width: 8),
 Expanded(child: bubble),
 if (isUser) const SizedBox(width: 8),
 if (isUser)
 const CircleAvatar(child: Icon(Icons.person)),
 ],
 );
 }

 Widget _attachments(BuildContext context) {
 return Column(
 crossAxisAlignment: CrossAxisAlignment.start,
 children: [
 for (final a in message.attachments)
 Padding(
 padding: const EdgeInsets.only(bottom: 6),
 child: a.map(
 image: (img) {
 final bytes = base64Decode(img.base64Data);
 return GestureDetector(
 onTap: () {
 showDialog(
 context: context,
 builder: (_) => Dialog(
 insetPadding: EdgeInsets.zero,
 backgroundColor: Colors.black,
 child: InteractiveViewer(
 child: Image.memory(bytes, fit: BoxFit.contain),
 ),
 ),
 );
 },
 child: ClipRRect(
 borderRadius: BorderRadius.circular(8),
 child: Image.memory(bytes, height: 160, fit: BoxFit.cover),
 ),
 );
 },
 audio: (aud) {
 return AudioPlayerTile(bytes: aud.bytes, mimeType: aud.format.mimeType);
 },
 file: (f) {
 return Row(
 children: [
 const Icon(Icons.attach_file, size: 18),
 const SizedBox(width: 6),
 Expanded(child: Text('${f.fileName} • ${f.mimeType}', maxLines: 1, overflow: TextOverflow.ellipsis)),
 IconButton(
 icon: const Icon(Icons.copy),
 onPressed: () => Clipboard.setData(ClipboardData(text: f.fileName)),
 tooltip: 'Copy file name',
 ),
 ],
 );
 },
 chunk: (c) {
 return Text('[Chunk] ${c.sourceName ?? ''}\n${c.text}', style: Theme.of(context).textTheme.bodySmall);
 },
 ),
 ),
 ],
 );
 }

 Widget _markdown(BuildContext context, String data) {
 return Column(
 crossAxisAlignment: CrossAxisAlignment.start,
 children: [
 MarkdownBody(
 data: data,
 selectable: true,
 softLineBreak: true,
 styleSheet: MarkdownStyleSheet(
 codeblockDecoration: BoxDecoration(
 color: Colors.transparent,
 ),
 ),
 builders: {
 'code': CodeBlockBuilder(
 onCopied: () {
 ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Code copied')));
 },
 ),
 },
 ),
 const SizedBox(height: 6),
 Row(
 mainAxisAlignment: MainAxisAlignment.end,
 children: [
 IconButton(
 tooltip: 'Copy message',
 icon: const Icon(Icons.copy_all_outlined, size: 18),
 onPressed: () => Clipboard.setData(ClipboardData(text: data)).then((_) {
 ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Message copied')));
 }),
 ),
 if (onEdit != null)
 IconButton(
 tooltip: 'Edit message',
 icon: const Icon(Icons.edit_outlined, size: 18),
 onPressed: onEdit,
 ),
 if (onResendFromHere != null)
 IconButton(
 tooltip: 'Resend from here',
 icon: const Icon(Icons.refresh_outlined, size: 18),
 onPressed: onResendFromHere,
 ),
 ],
 ),
 ],
 );
 }
}