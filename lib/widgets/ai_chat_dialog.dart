// lib/widgets/ai_chat_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:miko/providers/ai_chat_provider.dart';


class AiChatDialog extends ConsumerStatefulWidget {
  const AiChatDialog({super.key});

  @override
  ConsumerState<AiChatDialog> createState() => _AiChatDialogState();
}

class _AiChatDialogState extends ConsumerState<AiChatDialog> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  Widget _buildMarkdownResponse(String text, BuildContext context) {
    if (text.isEmpty) {
      return const SizedBox.shrink();
    }
    return SelectionArea( // Enables universal text selection
      child: MarkdownBody(
        data: text,
        selectable: true, // Already true, but good to be explicit
        onTapLink: (text, href, title) async {
          if (href != null) {
            final uri = Uri.parse(href);
            if (await canLaunchUrl(uri)) {
              await launchUrl(
                uri,
                mode: LaunchMode.externalApplication, // Opens in external browser
              );
            } else {
              // Optionally show a dialog or snackbar if link cannot be opened
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Could not launch $href')),
              );
            }
          }
        },
        styleSheet: MarkdownStyleSheet(
          p: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 16,
            height: 1.5, // Improved line height for readability
          ),
          h1: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
          h2: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: Theme.of(context).colorScheme.secondary,
          ),
          // Add more styles for other elements like code blocks, lists, etc.
          code: Theme.of(context).textTheme.bodySmall?.copyWith(
            backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
            fontFamily: 'monospace',
            fontSize: 14,
            height: 1.4,
          ),
          blockquote: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            fontStyle: FontStyle.italic,
          ),
          listBullet: Theme.of(context).textTheme.bodyMedium,
          // You can customize more markdown elements here
        ),
        // Ensures proper rendering for RTL languages if the
        // root Directionality widget is set.
        softLineBreak: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkTheme = theme.brightness == Brightness.dark;
    final mq = MediaQuery.of(context);
    final isSmallScreen = mq.size.width < 600;

    ref.watch(aiChatObserverProvider);
    final chatState = ref.watch(aiChatProvider);
    final chatNotifier = ref.read(aiChatProvider.notifier);

    // Update text controller if promptInput changes externally
    if (_textEditingController.text != chatState.promptInput) {
      _textEditingController.text = chatState.promptInput;
      _textEditingController.selection = TextSelection.fromPosition(
          TextPosition(offset: _textEditingController.text.length));
    }

    // Determine the text direction for the dialog content
    // This will inherit from the MaterialApp or explicit Directionality
    final TextDirection currentTextDirection = Directionality.of(context);

    return Dialog(
      backgroundColor: theme.colorScheme.surface,
      surfaceTintColor: Colors.transparent, // Prevents default tint
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: isSmallScreen ? mq.size.width * 0.9 : 700.0,
          maxHeight: mq.size.height * 0.9,
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Ask Gemini",
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              // Dropdown for chat mode
              Align(
                alignment: currentTextDirection == TextDirection.ltr ? Alignment.centerLeft : Alignment.centerRight,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<GeminiChatMode>(
                    value: chatState.currentMode,
                    icon: Icon(Icons.arrow_drop_down, color: theme.colorScheme.primary),
                    dropdownColor: theme.colorScheme.surfaceVariant,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                    onChanged: chatState.isLoading
                        ? null
                        : (mode) {
                            if (mode != null) {
                              chatNotifier.setChatMode(mode);
                            }
                          },
                    items: GeminiChatMode.values.map((mode) {
                      return DropdownMenuItem(
                        value: mode,
                        child: Text(mode.toString().split('.').last),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Message Input Field
              TextField(
                controller: _textEditingController,
                textDirection: currentTextDirection, // Explicitly set text direction
                minLines: 1,
                maxLines: 5,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.send,
                decoration: InputDecoration(
                  labelText: 'Your message',
                  hintText: chatState.currentMode == GeminiChatMode.textChat
                      ? 'Type your message'
                      : 'Provide context for media',
                  alignLabelWithHint: true, // Centers label for multiline
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: theme.colorScheme.outline),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: theme.colorScheme.outline.withOpacity(0.7)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
                  ),
                  suffixIcon: chatState.isLoading
                      ? Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: SizedBox(
                            width: 24, // Fixed size for circular progress
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        )
                      : IconButton(
                          icon: Icon(
                            Icons.send_rounded,
                            color: theme.colorScheme.primary,
                          ),
                          onPressed: () async {
                            if (!chatState.isLoading && _textEditingController.text.isNotEmpty) {
                              await chatNotifier.sendMessage(stream: true);
                              _textEditingController.clear();
                              chatNotifier.updatePromptInput('');
                            }
                          },
                        ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                onChanged: chatNotifier.updatePromptInput,
                onSubmitted: (message) async {
                  if (!chatState.isLoading && message.isNotEmpty) {
                    await chatNotifier.sendMessage(stream: true);
                    _textEditingController.clear();
                    chatNotifier.updatePromptInput('');
                  }
                },
              ),
              const SizedBox(height: 24),
              // AI Response Section
              Text(
                "AI Response:",
                style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface.withOpacity(0.8)),
                textDirection: currentTextDirection, // Ensure header also respects direction
              ),
              const SizedBox(height: 8),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: isDarkTheme ? Colors.grey[900] : Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: theme.colorScheme.outline.withOpacity(0.2)),
                    ),
                    alignment: currentTextDirection == TextDirection.ltr ? Alignment.topLeft : Alignment.topRight,
                    child: chatState.isLoading && chatState.response.isEmpty
                        ? LinearProgressIndicator(
                            color: theme.colorScheme.primary,
                            backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
                          )
                        : _buildMarkdownResponse(chatState.response, context),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Action Buttons
              Align(
                alignment: currentTextDirection == TextDirection.ltr ? Alignment.centerRight : Alignment.centerLeft,
                child: TextButton.icon(
                  icon: const Icon(Icons.close),
                  label: const Text("Close"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: theme.colorScheme.onSurface,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}