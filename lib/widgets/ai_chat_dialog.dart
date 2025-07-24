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

  Widget _buildClickableResponse(String text, BuildContext context) {
    if (text.isEmpty) {
      return const SizedBox.shrink();
    }
    return MarkdownBody(
      data: text,
      selectable: true,
      onTapLink: (text, href, title) {
        if (href != null) {
          launchUrl(Uri.parse(href));
        }
      },
      styleSheet: MarkdownStyleSheet(
        p: const TextStyle(fontSize: 16),
        h1: const TextStyle(color: Colors.blueAccent, fontSize: 24),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(aiChatProvider);
    final chatNotifier = ref.read(aiChatProvider.notifier);

    if (_textEditingController.text != chatState.promptInput) {
      _textEditingController.text = chatState.promptInput;
      _textEditingController.selection = TextSelection.fromPosition(
          TextPosition(offset: _textEditingController.text.length));
    }

    return AlertDialog(
      title: const Text("Ask Gemini"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButton<GeminiChatMode>(
              value: chatState.currentMode,
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
            const SizedBox(height: 10),
            TextField(
              controller: _textEditingController,
              decoration: InputDecoration(
                labelText: 'Your message',
                hintText: chatState.currentMode == GeminiChatMode.textChat
                    ? 'Type your message'
                    : 'Provide context for media',
                suffixIcon: chatState.isLoading
                    ? const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () async {
                          await chatNotifier.sendMessage(stream: false);
                          _textEditingController.clear();
                          chatNotifier.updatePromptInput('');
                        },
                      ),
              ),
              onChanged: chatNotifier.updatePromptInput,
              onSubmitted: (message) async {
                if (!chatState.isLoading) {
                  await chatNotifier.sendMessage(stream: false);
                  _textEditingController.clear();
                  chatNotifier.updatePromptInput('');
                }
              },
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: chatState.isLoading || chatState.currentMode != GeminiChatMode.multiModal
                        ? null
                        : chatNotifier.pickImage,
                    icon: const Icon(Icons.image),
                    label: const Text('Image'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    // Audio support removed, button is permanently disabled
                    onPressed: null,
                    icon: Icon(Icons.audiotrack, color: Colors.grey.shade600),
                    label: Text(
                      'Audio',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ),
                ),
              ],
            ),
            if (chatState.imageBytes != null)
              Column(
                children: [
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Image selected.',
                        style: TextStyle(color: Colors.lightGreen),
                      ),
                      IconButton(
                        icon: const Icon(Icons.clear, size: 20),
                        onPressed: chatNotifier.clearMedia,
                        tooltip: 'Clear Media Selection',
                        color: Colors.redAccent,
                      ),
                    ],
                  ),
                ],
              ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: chatState.isLoading
                        ? null
                        : () {
                            chatNotifier.sendMessage(stream: false);
                            _textEditingController.clear();
                            chatNotifier.updatePromptInput('');
                          },
                    child: const Text('Send'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: chatState.isLoading
                        ? null
                        : () {
                            chatNotifier.sendMessage(stream: true);
                            _textEditingController.clear();
                            chatNotifier.updatePromptInput('');
                          },
                    child: const Text('Stream'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "AI Response:",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7)),
                ),
                const SizedBox(height: 8),
                chatState.isLoading && chatState.response.isEmpty
                    ? const LinearProgressIndicator()
                    : _buildClickableResponse(chatState.response, context),
              ],
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text("Close"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  // This custom widget seems to be for a specific response parsing logic
  // and can be kept as is, though it's not currently wired up to the provider state.
}