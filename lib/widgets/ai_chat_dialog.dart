// lib/widgets/ai_chat_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpt_markdown/gpt_markdown.dart';
import 'package:miko/widgets/Typing_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:miko/providers/ai_chat_provider.dart'; // Import the new provider
import 'package:flutter_markdown/flutter_markdown.dart';

class AiChatDialog extends ConsumerStatefulWidget {
  const AiChatDialog({super.key});

  @override
  ConsumerState<AiChatDialog> createState() => _AiChatDialogState();
}

class _AiChatDialogState extends ConsumerState<AiChatDialog> {
  final TextEditingController _textEditingController = TextEditingController();
bool _isLoading = false;
bool _isThinkingExpanded = false; // To control the expansion of the thinking box
String _thinkingText = ''; // Holds only the text inside <think> tags
String _finalAnswerText = ''; // Holds the final response text

// Phase State
bool _isThinking = false; // Is the model currently in a <think> block?
bool _isFinished = false; // Has the entire response stream completed?
  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  // Helper method for clickable URLs in the response
  Widget _buildClickableResponse(String text, BuildContext context) {
    final urlRegex =
        RegExp(r'https?://[^\s/$.?#].[^\s]*', caseSensitive: false);
    final List<TextSpan> textSpans = [];
    int lastMatchEnd = 0;
    

      // Replace the found tags with an empty string and trim whitespace.
  

    for (final match in urlRegex.allMatches(text)) {
      if (match.start > lastMatchEnd) {
        textSpans
            .add(TextSpan(text: text.substring(lastMatchEnd, match.start)));
      }

      final String url = match.group(0)!;
      textSpans.add(
        TextSpan(
          text: url,
          style: const TextStyle(
            color: Colors.blue,
            decoration: TextDecoration.underline,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () async {
              final uri = Uri.parse(url);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              } else {
                if (!context.mounted)
                  return; // Check if widget is still in tree
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Could not open link: $url')),
                );
              }
            },
        ),
      );
      lastMatchEnd = match.end;
    }

    if (lastMatchEnd < text.length) {
      textSpans.add(TextSpan(text: text.substring(lastMatchEnd)));
    }
    return SingleChildScrollView(
      child: MarkdownBody(
        data: text, // The string from your AI model
        selectable: true, // Allows users to copy text
        styleSheet: MarkdownStyleSheet(
          // Optional: Customize the look
          p: TextStyle(color: Colors.white, fontSize: 16),
          h1: TextStyle(color: Colors.blueAccent, fontSize: 24),
          listBullet: TextStyle(color: Colors.white),
          // ... add more styles for h2, code blocks, etc.
        ),
      ),
    );
    // return SelectableText.rich(
    //   TextSpan(
    //     children: textSpans,
    //    // style: DefaultTextStyle.of(context).style,
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    // Watch the state from the provider to rebuild when it changes
    final chatState = ref.watch(aiChatProvider);
    // Read the notifier to call methods (doesn't trigger rebuilds)
    final chatNotifier = ref.read(aiChatProvider.notifier);

    // Synchronize the TextEditingController with the state's promptInput
    // This is crucial for keeping TextField's internal state matching the Riverpod state.
    if (_textEditingController.text != chatState.promptInput) {
      _textEditingController.text = chatState.promptInput;
      // Keep cursor at the end, important for user experience especially with streaming/updates
      _textEditingController.selection = TextSelection.fromPosition(
          TextPosition(offset: _textEditingController.text.length));
    }

    return AlertDialog(
      title: const Text("Ask AI"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Dropdown to switch AI Chat Modes
            DropdownButton<OpenAIChatMode>(
              value: chatState.currentMode,
              onChanged: chatState.isLoading
                  ? null
                  : (mode) {
                      if (mode != null) {
                        chatNotifier.setChatMode(mode);
                      }
                    },
              items: OpenAIChatMode.values.map((mode) {
                return DropdownMenuItem(
                  value: mode,
                  child:
                      Text(mode.toString().split('.').last), // e.g., "textChat"
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            // Text input for prompt
            TextField(
              controller: _textEditingController,
              decoration: InputDecoration(
                labelText: 'Your message',
                hintText: chatState.currentMode == OpenAIChatMode.textChat
                    ? 'Type your message'
                    : 'Provide context for media',
                suffixIcon: chatState.isLoading
                    ? const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(
                            strokeWidth: 2), // Loading indicator for send
                      )
                    : IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () async {
                          await chatNotifier.sendMessage(
                              stream: false); // Send without streaming
                          _textEditingController
                              .clear(); // Clear input after sending
                          chatNotifier.updatePromptInput(
                              ''); // Clear notifier's state as well
                        },
                      ),
              ),
              onChanged: (text) {
                chatNotifier.updatePromptInput(text); // Update state on typing
              },
              onSubmitted: (message) async {
                if (!chatState.isLoading) {
                  await chatNotifier.sendMessage(stream: false);
                  _textEditingController.clear();
                  chatNotifier.updatePromptInput('');
                }
              },
            ),
            const SizedBox(height: 10),
            // Buttons for media selection (only enabled for MultiModal mode)
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: chatState.isLoading ||
                            chatState.currentMode != OpenAIChatMode.multiModal
                        ? null // Disable if loading or not MultiModal mode
                        : chatNotifier.pickImage,
                    icon: const Icon(Icons.image),
                    label: const Text('Image'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: chatState.isLoading ||
                            chatState.currentMode != OpenAIChatMode.multiModal
                        ? null // Disable if loading or not MultiModal mode
                        : chatNotifier.pickAudio,
                    icon: const Icon(Icons.audiotrack),
                    label: const Text('Audio'),
                  ),
                ),
              ],
            ),
            // Display feedback for selected media and a clear button
            if (chatState.imageBase64 != null || chatState.audioBase64 != null)
              Column(
                children: [
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (chatState.imageBase64 != null)
                        Expanded(
                          child: Text(
                            'Image selected.',
                            style: const TextStyle(color: Colors.lightGreen),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      if (chatState.audioBase64 != null &&
                          chatState.imageBase64 != null)
                        const SizedBox(width: 8),
                      if (chatState.audioBase64 != null)
                        Expanded(
                          child: Text(
                            'Audio Selected (.${chatState.audioFormat})',
                            style: const TextStyle(color: Colors.lightGreen),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
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
            // Stream and Non-Stream send buttons
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
            // AI Response display area
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "AI Response:",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.7)),
                ),
                const SizedBox(height: 8),
                chatState.isLoading &&
                        chatState.response
                            .isEmpty // Show progress only if loading and no response yet
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
            // Because aiChatProvider is .autoDispose, the notifier and its state
            // will be automatically cleaned up when the dialog is dismissed
            // and no longer observed. No explicit resetChat() is needed.
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
  // In _AiChatDialogState, add this helper method:
Widget _buildThinkingBox() {
  return InkWell(
    onTap: () {
      setState(() {
        _isThinkingExpanded = !_isThinkingExpanded;
      });
    },
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: _isThinkingExpanded ? Colors.grey.shade800 : Colors.grey.shade900,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade700),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
              Icon(Icons.psychology, color: Colors.tealAccent, size: 20),
              const SizedBox(width: 8),
              const Text("AI is thinking"),
              if (_isLoading) const TypingIndicator(), // Show animated dots
              const Spacer(),
              Icon(
                _isThinkingExpanded ? Icons.expand_less : Icons.expand_more,
                color: Colors.grey.shade400,
              ),
            ],
          ),
          // Expandable Content
          if (_isThinkingExpanded)
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 150), // Prevent it from getting too big
                child: SingleChildScrollView(
                  child: MarkdownBody(
                    data: _thinkingText.isEmpty ? "..." : _thinkingText,
                    styleSheet: MarkdownStyleSheet(p: const TextStyle(color: Colors.grey)),
                  ),
                ),
              ),
            ),
        ],
      ),
    ),
  );
}
}
