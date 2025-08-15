// lib/ui/widgets/message_bubble.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:miko/mycore/settings_service.dart';
import 'package:openai_dart/openai_dart.dart' hide Image;

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
   final bool? autoPlay;
   final StorageSettingsService settingsService;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isUser,
    this.onCopyAll,
    this.onEdit,
    this.onResendFromHere,
    this.onSubmitEdit,
    this.isStreaming = false,
    this.autoPlay = false,
    required this.settingsService,
  });

  @override
  Widget build(BuildContext context) {
    // The main row structure: [Avatar, Bubble] or [Bubble, Avatar]
    final children = [
      if (!isUser) _buildAvatar(context),
      Expanded(
        child: Align(
          alignment: isUser ? Alignment.topRight : Alignment.topLeft,
          child: _BubbleContent(
            message: message,
            isUser: isUser,
            isStreaming: isStreaming,
            autoPlay: autoPlay,
            settingsService: settingsService,
            onEdit: onEdit,
            onResendFromHere: onResendFromHere,
          ),
        ),
      ),
      if (isUser) _buildAvatar(context),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        // Reverse the children if the message is from the user
        children: isUser ? children.reversed.toList() : children,
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    final theme = Theme.of(context);
    final avatarIcon = isUser
        ? Icon(Icons.person_outline_rounded, size: 22, color: theme.colorScheme.onSecondaryContainer)
        : Icon(Icons.auto_awesome_outlined, size: 22, color: theme.colorScheme.onTertiaryContainer);
    final avatarColor = isUser ? const Color.fromARGB(255, 10, 53, 194) : theme.colorScheme.tertiaryContainer;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: CircleAvatar(
        radius: 20,
        backgroundColor: avatarColor,
        child: avatarIcon,
      ),
    );
  }
}

class _BubbleContent extends StatelessWidget {
  final UnifiedMessage message;
  final bool isUser;
  final bool isStreaming;
  final bool? autoPlay;
  final StorageSettingsService settingsService;
  final VoidCallback? onEdit;
  final VoidCallback? onResendFromHere;

  const _BubbleContent({
    required this.message,
    required this.isUser,
    required this.isStreaming,
    this.autoPlay,
    required this.settingsService,
    this.onEdit,
    this.onResendFromHere,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bubbleColor = isUser ?  const Color.fromARGB(255, 45, 58, 77) : theme.colorScheme.surfaceVariant;

    // This creates the "tail" on the bubble
    final borderRadius = BorderRadius.only(
      topLeft: const Radius.circular(18),
      topRight: const Radius.circular(18),
      bottomLeft: isUser ? const Radius.circular(18) : const Radius.circular(4),
      bottomRight: isUser ? const Radius.circular(4) : const Radius.circular(18),
    );

    return Container(
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: bubbleColor,
        borderRadius: borderRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (message.attachments.isNotEmpty)
            _AttachmentsGrid(
              attachments: message.attachments,
              autoPlay: autoPlay,
              settingsService: settingsService,
            ),
          // Only show text part if it's not empty
          if (message.text != null)
            _MessageText(
              text: message.text!,
              onEdit: onEdit,
              onResendFromHere: onResendFromHere,
            ),
          if (isStreaming) const _StreamingIndicator(),
        ],
      ),
    );
  }
}

class _MessageText extends StatelessWidget {
  final String text;
  final VoidCallback? onEdit;
  final VoidCallback? onResendFromHere;

  const _MessageText({
    required this.text,
    this.onEdit,
    this.onResendFromHere,
  });

  @override
  Widget build(BuildContext context) {
    // We group the markdown and the action bar together
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MarkdownBody(
          data: text,
          selectable: true,
          styleSheet: _getMarkdownStyleSheet(context),
          builders: {'code': CodeBlockBuilder()},
        ),
        const SizedBox(height: 8),
        _ActionBar(
          messageText: text,
          onEdit: onEdit,
          onResendFromHere: onResendFromHere,
        ),
      ],
    );
  }

  MarkdownStyleSheet _getMarkdownStyleSheet(BuildContext context) {
    final theme = Theme.of(context);
    return MarkdownStyleSheet.fromTheme(theme).copyWith(
      code: theme.textTheme.bodyMedium!.copyWith(
        fontFamily: 'monospace',
        backgroundColor: theme.colorScheme.onSurface.withOpacity(0.08),
        fontSize: 14,
      ),
      p: theme.textTheme.bodyLarge?.copyWith(fontSize: 16),
    );
  }
}

class _ActionBar extends StatelessWidget {
  final String messageText;
  final VoidCallback? onEdit;
  final VoidCallback? onResendFromHere;

  const _ActionBar({
    required this.messageText,
    this.onEdit,
    this.onResendFromHere,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Wrap(
        spacing: 4,
        children: [
          _ActionButton(
            tooltip: 'Copy Message',
            icon: Icons.copy_all_outlined,
            onPressed: () {
              Clipboard.setData(ClipboardData(text: messageText)).then((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Message copied to clipboard.'), behavior: SnackBarBehavior.floating),
                );
              });
            },
          ),
          if (onEdit != null)
            _ActionButton(
              tooltip: 'Edit Message',
              icon: Icons.edit_outlined,
              onPressed: onEdit!,
            ),
          if (onResendFromHere != null)
            _ActionButton(
              tooltip: 'Resend From Here',
              icon: Icons.refresh_outlined,
              onPressed: onResendFromHere!,
            ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String tooltip;
  final IconData icon;
  final VoidCallback onPressed;

  const _ActionButton({required this.tooltip, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      icon: Icon(icon, size: 20, color: Theme.of(context).textTheme.bodySmall?.color),
      onPressed: onPressed,
      style: IconButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: const EdgeInsets.all(8),
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}

class _AttachmentsGrid extends StatelessWidget {
  final List<Attachment> attachments;
  final bool? autoPlay;
  final StorageSettingsService settingsService;

  const _AttachmentsGrid({
    required this.attachments,
    this.autoPlay,
    required this.settingsService,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: attachments
            .map((attachment) => _AttachmentItem(
                  attachment: attachment,
                  autoPlay: autoPlay,
                  settingsService: settingsService,
                ))
            .toList(),
      ),
    );
  }
}

class _AttachmentItem extends StatelessWidget {
  final Attachment attachment;
  final bool? autoPlay;
  final StorageSettingsService settingsService;

  const _AttachmentItem({
    required this.attachment,
    this.autoPlay,
    required this.settingsService,
  });

  @override
  Widget build(BuildContext context) {
    return attachment.map(
      image: (img) => _ImageAttachment(imageData: img.base64Data),
      audio: (aud) =>  AudioPlayerTile(
        bytes: aud.bytes,
        autoPlay: autoPlay ?? false,
        settingsService: settingsService,
        file: aud.file
      ),
      file: (f) => _FileAttachment(fileName: f.fileName, mimeType: f.mimeType),
      chunk: (c) => _ChunkAttachment(
        sourceName: c.sourceName,
        text: c.text,
      ),
    );
  }
}

class _ImageAttachment extends StatelessWidget {
  final String imageData;
  const _ImageAttachment({required this.imageData});

  @override
  Widget build(BuildContext context) {
    final bytes = base64Decode(imageData);
    final heroTag = 'image_hero_${imageData.hashCode}';

    return GestureDetector(
      onTap: () => _showFullScreenImage(context, bytes, heroTag),
      child: Hero(
        tag: heroTag,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 250, maxWidth: 250),
            child: Image.memory(
              bytes,
              fit: BoxFit.cover,
             // frameBuilder: (context, child, progress) =>
               //   progress == null ? child : const CircularProgressIndicator(),
            ),
          ),
        ),
      ),
    );
  }

  void _showFullScreenImage(
      BuildContext context, Uint8List bytes, String heroTag) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.8),
      builder: (_) => Dialog.fullscreen(
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            InteractiveViewer(
              panEnabled: true,
              minScale: 0.5,
              maxScale: 4.0,
              child: Center(
                child: Hero(
                  tag: heroTag,
                  child: Image.memory(bytes, fit: BoxFit.contain),
                ),
              ),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: IconButton.filled(
                style: IconButton.styleFrom(
                  backgroundColor: Colors.black.withOpacity(0.5),
                ),
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FileAttachment extends StatelessWidget {
  final String fileName;
  final String? mimeType;
  const _FileAttachment({required this.fileName, this.mimeType});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: theme.dividerColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.insert_drive_file_outlined,
              size: 24, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  style: theme.textTheme.bodyMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (mimeType != null)
                  Text(
                    mimeType!,
                    style: theme.textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _ActionButton(
            tooltip: 'Copy file name',
            icon: Icons.copy,
            onPressed: () {
              Clipboard.setData(ClipboardData(text: fileName)).then((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('File name copied.')),
                );
              });
            },
          ),
        ],
      ),
    );
  }
}

class _ChunkAttachment extends StatelessWidget {
  final String? sourceName;
  final String text;
  const _ChunkAttachment({this.sourceName, required this.text});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.8,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          '[Chunk] ${sourceName ?? 'Source'}\n$text',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }
}

class _StreamingIndicator extends StatefulWidget {
  const _StreamingIndicator();
  @override
  State<_StreamingIndicator> createState() => _StreamingIndicatorState();
}

class _StreamingIndicatorState extends State<_StreamingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
                mainAxisSize: MainAxisSize.min,
        children: [
          _TypingDot(controller: _controller, startTime: 0.0, endTime: 0.33),
          const SizedBox(width: 4),
          _TypingDot(controller: _controller, startTime: 0.15, endTime: 0.48),
          const SizedBox(width: 4),
          _TypingDot(controller: _controller, startTime: 0.30, endTime: 0.63),
        ],
      ),
    );
  }
}

class _TypingDot extends StatelessWidget {
  final AnimationController controller;
  final double startTime;
  final double endTime;

  const _TypingDot({
    required this.controller,
    required this.startTime,
    required this.endTime,
  });

  @override
  Widget build(BuildContext context) {
    final animation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(startTime, endTime, curve: Curves.easeInOutCubicEmphasized),
      ),
    );

    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        child: Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color:
                Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.6),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

// class _StreamingIndicator extends StatefulWidget {
//   const _StreamingIndicator();
//   @override
//   State<_StreamingIndicator> createState() => _StreamingIndicatorState();
// }

// class _StreamingIndicatorState extends State<_StreamingIndicator> with SingleTickerProviderStateMixin {
//   late final AnimationController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1500),
//     )..repeat();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 8.0),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           _TypingDot(controller: _controller, startTime: 0.0, endTime: 0.33),
//           const SizedBox(width: 4),
//           _TypingDot(controller: _controller, startTime: 0.15, endTime: 0.48),
//           const SizedBox(width: 4),
//           _TypingDot(controller: _controller, startTime: 0.30, endTime: 0.63),
//         ],
//       ),
//     );
//   }
// }

//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         if (!isUser) const CircleAvatar(child: Icon(Icons.auto_awesome,size: 20,),radius: 20,),
//         if (!isUser) const SizedBox(width: 8),
//         Expanded(child: bubble),
//         if (isUser) const SizedBox(width: 8),
//         if (isUser) const CircleAvatar(child: Icon(Icons.person,size: 10,),radius: 20,),
//       ],
//     );
//   }

//   Widget _attachments(BuildContext context) {
    

//   Widget _markdown(BuildContext context, String data) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         MarkdownBody(
//           data: data,
//           selectable: true,
//           // softLineBreak: true,
//           // styleSheet: MarkdownStyleSheet(
//           //   codeblockDecoration: BoxDecoration(color: Colors.transparent),
//           // ),
//           builders: {
//             'code': CodeBlockBuilder(
              
//             ),
//           },
//         ),
//         const SizedBox(height: 6),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             IconButton(
//               tooltip: 'Copy message',
//               icon: const Icon(Icons.copy_all_outlined, size: 18),
//               onPressed: () =>
//                   Clipboard.setData(ClipboardData(text: data)).then((_) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(content: Text('Message copied')),
//                     );
//                   }),
//             ),
//             if (onEdit != null)
//               IconButton(
//                 tooltip: 'Edit message',
//                 icon: const Icon(Icons.edit_outlined, size: 18),
//                 onPressed: onEdit,
//               ),
//             if (onResendFromHere != null)
//               IconButton(
//                 tooltip: 'Resend from here',
//                 icon: const Icon(Icons.refresh_outlined, size: 18),
//                 onPressed: onResendFromHere,
//               ),
//           ],
//         ),
//       ],
//     );
//   }
// }
