import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:miko/data/models/session_models.dart';
import 'package:miko/widgets/code_block.dart';
import 'package:miko/widgets/thinking_block.dart';
import 'package:path/path.dart' as p;

class ChatMessage extends StatelessWidget {
  final SessionEvent event;
  const ChatMessage({required this.event, super.key});

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text)).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Copied to clipboard')),
      );
    });
  }

  bool _isImageFile(String path) {
    final extension = p.extension(path).toLowerCase();
    return ['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp'].contains(extension);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    bool isUser = event.map(
      userMessage: (_) => true,
      aiResponse: (_) => false,
      fileAttachment: (_) => true, // Display as a user-side event
      toolCall: (_) => false,
      toolResult: (_) => false,
    );

    final alignment = isUser ? Alignment.centerRight : Alignment.centerLeft;
    final color = isUser
        ? theme.colorScheme.tertiaryContainer
        : theme.colorScheme.surfaceContainerHighest;
    final textColor = isUser
        ? theme.colorScheme.onTertiaryContainer
        : theme.colorScheme.onSurface;

    return Align(
      alignment: alignment,
      child: GestureDetector(
        onLongPress: () {
          final textContent = event.whenOrNull(
            userMessage: (text) => text,
            aiResponse: (markdown, _) => markdown,
          );
          if (textContent != null && textContent.isNotEmpty) {
            _copyToClipboard(context, textContent);
          }
        },
        child: Container(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
          margin: const EdgeInsets.symmetric(vertical: 5.0),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20),
          ),
          child: event.when(
            userMessage: (text) => SelectableText(text, style: theme.textTheme.bodyLarge?.copyWith(color: textColor)),
            aiResponse: (markdownText, isError) {
              if (markdownText.isEmpty && !isError) {
                return const ThinkingBlock();
              }
              return MarkdownBody(
                data: markdownText,
                selectable: true,
                styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
                  p: theme.textTheme.bodyLarge?.copyWith(color: textColor),
                  code: theme.textTheme.bodyMedium?.copyWith(fontFamily: 'monospace', backgroundColor: theme.colorScheme.surface),
                ),
                builders: {
                  'code': CodeElementBuilder(),
                },
              );
            },
            fileAttachment: (fileName, filePath) {
              if (_isImageFile(filePath)) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(File(filePath), height: 150),
                    ),
                    const SizedBox(height: 8),
                    Text('Attached: $fileName', style: TextStyle(color: textColor))
                  ],
                );
              }
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.attach_file, color: textColor, size: 16),
                  const SizedBox(width: 8),
                  Flexible(child: Text('Attached: $fileName', style: TextStyle(color: textColor))),
                ],
              );
            },
            toolCall: (toolName, args) => Text('Tool Call: $toolName', style: TextStyle(color: textColor, fontStyle: FontStyle.italic)),
            toolResult: (toolName, result) => Text('Tool Result ($toolName): $result', style: TextStyle(color: textColor, fontStyle: FontStyle.italic)),
          ),
        ),
      ),
    );
  }
}

class CodeElementBuilder extends MarkdownElementBuilder {
  @override
  Widget visitElementAfter(element, preferredStyle) {
    var language = 'dart'; // Default language
    if (element.attributes['class'] != null) {
      String lg = element.attributes['class'] as String;
      language = lg.substring(9);
    }
    return CodeBlock(
      code: element.textContent,
      language: language,
    );
  }
}