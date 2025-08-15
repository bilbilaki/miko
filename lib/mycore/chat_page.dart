// lib/ui/chat_page.dart
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:miko/ai/services/ai_browser_service.dart';
import 'package:miko/mycore/settings_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ai_core_models.dart';
import 'session_manager.dart';
import 'chat_controller.dart';
import 'attachment_preview.dart';
import 'message_bubble.dart';
import 'package:tiktoken/tiktoken.dart'; // Import at the top

class ChatPage extends StatefulWidget {
  ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _scrollController = ScrollController();
  final _imagePicker = ImagePicker();
  int _selectedIndex = 0;
  int _currentTokenCount = 0; // State variable for token count
  final TextEditingController _textController =
      TextEditingController(); // Controller for the text field
  String textl = '';
  String _selectedModel = 'gpt-5-mini';
  double _tokenCount = 62.0;
  double _temperature = 1;
  String _mediaResolution = 'Default';
  bool _thinkingModeEnabled = false; // Our state variable as per example
  bool _thinkingBudgetEnabled = false;
  bool _structuredOutputEnabled = false;
  bool _codeExecutionEnabled = false;
  bool _functionCallingEnabled = false;
  bool _groundingWithSearchEnabled = false;
  bool _urlContextEnabled = false;
  bool _safetySettingsEnabled = false;
  bool _addStopSequenceEnabled = false;
  bool _toolsEnabled = false;
  bool _voiceEnabled = false;
  bool _streamingEnabled = false;
  String _selectedVoice = 'alloy'; // Default voice
  bool _historyEnabled = false;
  bool _systemMessageEnabled = false;
  String _systemMessageText = '';

  // New state variable for dynamic models
  List<String> _availableModels = [
    'gpt-5-chat',
    'gpt-5-mini',
  ]; // Default/placeholder
  @override
  void initState() {
    super.initState();
    //  _loadSettings(); // Call our loading function when the state initializes
    _fetchModels(); // Fetch models on init
  }

  void _updateTokenCount() {
    final text = textl;
    final encoding = getEncoding('cl100k_base');
    final tokens = encoding.encode(text);
    setState(() {
      _currentTokenCount = tokens.length; // Update the token count state
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textController.dispose(); // Dispose controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settingsService = Provider.of<StorageSettingsService>(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SessionManager()..createSession(),
        ),
        ChangeNotifierProvider(create: (_) => AiSettings()),
        ChangeNotifierProxyProvider2<
          SessionManager,
          AiSettings,
          ChatController
        >(
          create: (ctx) => ChatController(
            sessionManager: ctx.read<SessionManager>(),
            settings: ctx.read<AiSettings>(),
            settingsService: settingsService,
          ),
          update: (ctx, sm, st, prev) => prev!..notifyListeners(),
        ),
      ],
      child: Builder(
        builder: (context) {
          final sessionManager = context.watch<SessionManager>();
          final settings = context.watch<AiSettings>();
          final chat = context.watch<ChatController>();
          final session = sessionManager.currentSession;
          textl = chat.textController.text;
          chat.textController.addListener(
            _updateTokenCount,
          ); // Listen for changes
          return Scaffold(
            appBar: AppBar(
              title: Text(session?.title ?? 'New Chat'),
              leading: Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
              actions: [
                Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(Icons.tune),
                    onPressed: () => Scaffold.of(context).openEndDrawer(),
                  ),
                ),
              ],
            ),
            drawer: _LeftDrawer(sessionManager: sessionManager),
            endDrawer: Drawer(child: rightpanel()),
            body: Column(
              children: [
                Expanded(
                  child: _messagesList(sessionManager, chat, settingsService),
                ),
                _inputArea(context, chat, settings, settingsService),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _messagesList(
    SessionManager sm,
    ChatController chat,
    StorageSettingsService settingsService,
  ) {
    final session = sm.currentSession;
    final messages = session?.messages ?? const <UnifiedMessage>[];
    final bool showThinkingBubble = chat.isSending;

    return NotificationListener<SizeChangedLayoutNotification>(
      onNotification: (_) {
        _scrollToBottom();
        return true;
      },
      child: SizeChangedLayoutNotifier(
        child: ListView.separated(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          itemBuilder: (context, index) {
            if (showThinkingBubble && index == messages.length) {
              return _ThinkingBubble();
            }

            final m = messages[index];
            final isUser = m.role == MessageRole.user;
            return MessageBubble(
              settingsService: settingsService,
              message: m,
              isUser: isUser,
              isStreaming: showThinkingBubble,
              autoPlay: false,
              onResendFromHere: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Resend from here?'),
                    content: const Text(
                      'This will remove messages after this point and resend. Continue?',
                    ),
                    actions: [
                      TextButton(onPressed: () {}, child: const Text('Cancel')),
                      FilledButton(
                        onPressed: () async {
                          await chat.resendFromMessage(m.id);
                        },
                        child: const Text('Resend'),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  await chat.resendFromMessage(m.id);
                }
              },
              onEdit: isUser
                  ? () async {
                      final controller = TextEditingController(
                        text: m.text ?? '',
                      );
                      final ok = await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Edit message'),
                          content: TextField(
                            controller: controller,
                            minLines: 1,
                            maxLines: 12,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {},
                              child: const Text('Cancel'),
                            ),
                            FilledButton(
                              onPressed: () => chat.updateMessage(
                                m.id,
                                controller.text.trim(),
                              ),
                              child: const Text('Save'),
                            ),
                          ],
                        ),
                      );
                      if (ok == true) {
                        chat.updateMessage(m.id, controller.text.trim());
                      }
                    }
                  : null,
            );
          },
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemCount: messages.length,
        ),
      ),
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  Widget _inputArea(
    BuildContext context,
    ChatController chat,
    AiSettings settings,
    StorageSettingsService settingsService,
  ) {
    final canSend =
        chat.textController.text.trim().isNotEmpty ||
        chat.hasPendingAttachments;
    final showRecord = !canSend;

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(blurRadius: 10, color: Colors.black.withOpacity(0.06)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Attachments preview
            AttachmentPreview(
              attachments: chat.pendingAttachments,
              onRemove: (i) => chat.removePendingAttachmentAt(i),
              settingsService: settingsService,
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Attachment button
                IconButton(
                  tooltip: 'Attach',
                  icon: const Icon(Icons.attach_file_outlined),
                  onPressed: () => _showAttachBottomSheet(context, chat),
                ),
                // Text field
                Expanded(
                  child: RawKeyboardListener(
                    focusNode: FocusNode(),
                    onKey: (event) {
                      if (event is RawKeyDownEvent) {
                        final isEnter =
                            event.logicalKey == LogicalKeyboardKey.enter;
                        final isShift = event.isShiftPressed;
                        final isCtrl =
                            event.isControlPressed || event.isMetaPressed;
                        if (isEnter && (isShift || isCtrl)) {
                          // Send on Shift+Enter or Ctrl+Enter
                          _send(context, chat);
                        }
                      }
                    },
                    child: TextField(
                      controller: chat.textController,
                      focusNode: chat.inputFocus,
                      minLines: 1,
                      maxLines: 8,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        hintText: 'Write a message...',
                        filled: true,
                        fillColor: Theme.of(
                          context,
                        ).colorScheme.surfaceVariant.withOpacity(0.6),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (_) => setState(() {}),
                      keyboardType: TextInputType.multiline,
                      textInputAction:
                          TextInputAction.newline, // Enter = newline
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Record or Send button
                if (showRecord)
                  _recButton(context, chat)
                else
                  _sendButton(context, chat),
              ],
            ),
            if (chat.isRecording) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.mic, color: Colors.red),
                  const SizedBox(width: 6),
                  Text(_formatDuration(chat.recordingDuration)),
                  const SizedBox(width: 10),
                  TextButton.icon(
                    onPressed: () => chat.stopRecording(cancelled: true),
                    icon: const Icon(Icons.close),
                    label: const Text('Cancel'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _sendButton(BuildContext context, ChatController chat) {
    return IconButton.filled(
      onPressed: chat.isSending
          ? null
          : () {
              _send(context, chat);
              _scrollToBottom();
            },
      icon: chat.isSending
          ? const SizedBox(
              height: 18,
              width: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.send_rounded),
    );
  }

  Widget _recButton(BuildContext context, ChatController chat) {
    if (chat.isRecording) {
      return IconButton.filled(
        style: IconButton.styleFrom(backgroundColor: Colors.red),
        onPressed: () {
          chat.stopRecording();
          _scrollToBottom();
        },
        icon: const Icon(Icons.stop),
      );
    } else {
      return IconButton.filled(
        onPressed: () {
          chat.startRecording();
          _scrollToBottom();
        },
        icon: const Icon(Icons.mic),
      );
    }
  }

  void _send(BuildContext context, ChatController chat) {
    FocusScope.of(context).unfocus();
    chat.sendCurrentInput();
  }

  Future<void> _showAttachBottomSheet(
    BuildContext context,
    ChatController chat,
  ) async {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.image_outlined),
              title: const Text('Pick image'),
              onTap: () async {
                final x = await ImagePicker().pickImage(
                  source: ImageSource.gallery,
                );
                if (x != null) {
                  final bytes = await x.readAsBytes();
                  chat.addImageBase64(base64Encode(bytes));
                }
                if (mounted) Navigator.pop(ctx);
              },
            ),
            ListTile(
              leading: const Icon(Icons.audiotrack_outlined),
              title: const Text('Pick audio'),
              onTap: () async {
                final res = await FilePicker.platform.pickFiles(
                  type: FileType.audio,
                  withData: true,
                );
                if (res != null) {
                  final file = res.files.single;
                  final bytes =
                      file.bytes ?? await File(file.path!).readAsBytes();
                  final fmt = _detectAudioFormat(
                    file.extension,
                    file.extension,
                  );
                  chat.addAudioBytes(
                    bytes,
                    format: fmt,
                    source: AudioSourceType.picked,
                  );
                }
                if (mounted) Navigator.pop(ctx);
              },
            ),
            ListTile(
              leading: const Icon(Icons.description_outlined),
              title: const Text('Pick file'),
              onTap: () async {
                final res = await FilePicker.platform.pickFiles(withData: true);
                if (res != null) {
                  final file = res.files.single;
                  final bytes =
                      file.bytes ?? await File(file.path!).readAsBytes();
                  chat.addFileBytes(
                    fileName: file.name,
                    bytes: bytes,
                    mimeType: 'application/octet-stream',
                    size: file.size,
                  );
                }
                if (mounted) Navigator.pop(ctx);
              },
            ),
            // New buttons for attachment bottom sheet
            ListTile(
              leading: const Icon(
                Icons.psychology_outlined,
              ), // Example icon for deep research
              title: const Text('Deep Research'),
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Deep Research feature not yet implemented'),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.search,
              ), // Example icon for search on web
              title: const Text('Search on Web'),
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Search on Web feature not yet implemented'),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.document_scanner_outlined,
              ), // Example icon for OCR
              title: const Text('OCR'),
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('OCR feature not yet implemented'),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.translate,
              ), // Example icon for translate
              title: const Text('Translate'),
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Translate feature not yet implemented'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  AudioFormat _detectAudioFormat(String? ext, String? mime) {
    final e = (ext ?? '').toLowerCase();
    final m = (mime ?? '').toLowerCase();
    if (e == 'wav' || m.contains('wav')) return AudioFormat.wav;
    if (e == 'mp3' || m.contains('mpeg')) return AudioFormat.wav;
    return AudioFormat.wav;
  }

  String _formatDuration(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(d.inMinutes.remainder(60))}:${two(d.inSeconds.remainder(60))}';
  }

  Widget buildSettingDropdown(
    BuildContext context,
    String label,
    String value,
    List<String> options,
    ValueChanged<String?> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Colors.white70, fontSize: 13)),
          const SizedBox(height: 4),
          DropdownButtonFormField<String>(
            value: value,
            dropdownColor: Colors.grey[800],
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.white10),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.white10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),

            items: options.map((String val) {
              return DropdownMenuItem<String>(
                value: val,
                child: Text(val, style: const TextStyle(color: Colors.white)),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget buildSettingSlider(
    BuildContext context,
    String label,
    double value,
    double max,
    double min,
    int divisions,
    ValueChanged<double> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
              Text(
                '${value.toInt()}${label == 'Token count' ? ' / ${max.toInt()}' : ''}',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
            activeColor: Theme.of(context).colorScheme.primary,
            inactiveColor: Colors.white10,
          ),
        ],
      ),
    );
  }

  Widget buildSettingToggle(
    BuildContext context,
    String label,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.white)),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }

  Widget buildSettingSwitch(
    BuildContext context,
    String label,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return buildSettingToggle(
      context,
      label,
      value,
      onChanged,
    ); // Same UI for simplicity
  }

  Widget buildExpansionTile(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: Text(title, style: TextStyle(color: Colors.white)),
        children: children,
        collapsedIconColor: Colors.white54,
        iconColor: Colors.white,
      ),
    );
  }

  Future<void> _fetchModels() async {
    try {
      final res = await client.listModels();
      if (mounted) {
        setState(() {
          _availableModels = res.data.map((model) => model.id).toList();
          // Ensure AiSettings.modelId is valid or default
       
        });
      }
    } catch (e) {
      debugPrint('Error fetching models: $e');
      // On error, revert to a default list if _availableModels is empty
      if (_availableModels.isEmpty) {
        if (mounted) {
          setState(() {
            _availableModels = ['gpt-5-chat', 'gpt-5-mini']; // Fallback
          });
        }
      }
      // Potentially show a user-friendly error message
    }
  }

  Future<void> _showSystemMessageDialog() async {
    final settings = context.watch<AiSettings>();

    final TextEditingController _controller = TextEditingController(
      text: settings.systemPrompt,
    );
    final String? result = await showDialog<String>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('System Message'),
          content: TextField(
            controller: _controller,
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: 'Enter your system message here...',
              border: OutlineInputBorder(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext, _controller.text);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (result != null) {
      settings.update((s) => s.systemPrompt = result);
    }
  }

  // Example of a programmatic 'set' function (not directly used by UI callbacks, but demonstrates functionality)
  void setThinkingMode(bool value) {
    final settings = context.watch<AiSettings>();

    setState(() {
      _thinkingModeEnabled = value;
    });
    settings.thinkingModeEnabled;
  }

  Widget rightpanel() {
    // Using Consumer to rebuild only the right panel when AiSettings change
    return Consumer<AiSettings>(
      builder: (context, aiSettings, child) {
        // List of OpenAI voices for the dropdown
        final List<String> openAIVoiceOptions = [
          'alloy',
          'ash',
          'echo',
          'ballad',
          'sage',
          'coral',
          'shimmer',
        ];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Run settings',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: Colors.white),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.push_pin_outlined,
                          size: 20,
                          color: Colors.white54,
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Feature not yet implemented'),
                            ),
                          );
                          debugPrint('Button pressed: Push Pin');
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.close,
                          size: 20,
                          color: Colors.white54,
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Feature not yet implemented'),
                            ),
                          );
                          debugPrint('Button pressed: Close');
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: [
                  buildSettingDropdown(
                    context,
                    'Model',
                    aiSettings.modelId,
                    _availableModels.isEmpty
                        ? ['Loading...']
                        : _availableModels, // Provide a loading state or default if empty
                    (String? newValue) {
                      if (newValue != null &&
                          _availableModels.contains(newValue)) {
                        aiSettings.update((s) => s.modelId = newValue);
                      }
                    },
                  ),
                  buildSettingSlider(
                    context,
                    'token count', // Changed from 'Token count'
                    _currentTokenCount.toDouble(),
                    1042582, // Max token count (e.g., Gemini 1.5 Pro's full context)
                    0, // Min token count
                    1, // Divisions (for a reasonable number of steps)
                    (double value) {},
                  ),
                  buildSettingSlider(
                    context,
                    'Temperature',
                    aiSettings.temperature,
                    1.0, // Max
                    0.0, // Min
                    100, // Divisions (for 0.01 steps)
                    (double value) {
                      aiSettings.update(
                        (s) => s.temperature = double.parse(
                          value.toStringAsFixed(2),
                        ),
                      );
                    },
                  ),
                  buildSettingDropdown(
                    context,
                    'Media resolution',
                    aiSettings.mediaResolution,
                    ['Default', 'High'],
                    (String? newValue) {
                      if (newValue != null) {
                        aiSettings.update((s) => s.mediaResolution = newValue);
                      }
                    },
                  ),
                  const Divider(color: Colors.white10),

                  // New settings introduced in the previous turn
                  buildSettingToggle(
                    context,
                    'Enable Tools',
                    aiSettings.toolsEnabled,
                    (bool value) {
                      aiSettings.update((s) => s.toolsEnabled = value);
                    },
                  ),
                  buildSettingToggle(
                    context,
                    'Enable Voice Response', // Changed from 'Enable Voice' for clarity
                    aiSettings.voiceResponse,
                    (bool value) {
                      aiSettings.update((s) => s.voiceResponse = value);
                    },
                  ),
                  if (aiSettings
                      .voiceResponse) // Show voice selector only if voice is enabled
                    buildSettingDropdown(
                      context,
                      'Select Voice',
                      aiSettings.selectedVoice,
                      openAIVoiceOptions,
                      (String? newValue) {
                        if (newValue != null &&
                            openAIVoiceOptions.contains(newValue)) {
                          aiSettings.update((s) => s.selectedVoice = newValue);
                        }
                      },
                    ),
                  buildSettingToggle(
                    context,
                    'Enable Streaming',
                    aiSettings.streaming,
                    (bool value) {
                      aiSettings.update((s) => s.streaming = value);
                    },
                  ),
                  buildSettingToggle(
                    context,
                    'Enable History',
                    aiSettings.historyEnabled,
                    (bool value) {
                      aiSettings.update((s) => s.historyEnabled = value);
                    },
                  ),
                  buildSettingToggle(
                    context,
                    'Enable Thinking Mode',
                    aiSettings.thinkingModeEnabled,
                    (bool value) {
                      aiSettings.update((s) => s.thinkingModeEnabled = value);
                    },
                  ),
                  buildSettingToggle(
                    context,
                    'Enable System Message',
                    aiSettings
                        .persistSystemMessage, // Maps to persistSystemMessage
                    (bool value) {
                      aiSettings.update((s) => s.persistSystemMessage = value);
                    },
                  ),
                  if (aiSettings.persistSystemMessage)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 0,
                      ),
                      child: Center(
                        child: OutlinedButton(
                          onPressed: _showSystemMessageDialog,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white10),
                          ),
                          child: Text(
                            aiSettings.systemPrompt.isEmpty
                                ? 'in your messages full use markdown schema , and when you got image and prompt , you should read prmpt and then creating flutter ui code user need that for using in his project'
                                : 'in your messages full use markdown schema , and when you got image and prompt , you should read prmpt and then creating flutter ui code user need that for using in his project',
                          ),
                        ),
                      ),
                    ),
                  const Divider(color: Colors.white10),

                  buildSettingToggle(
                    context,
                    'Set Thinking Budget',
                    aiSettings.thinkingBudgetEnabled,
                    (bool value) {
                      aiSettings.update((s) => s.thinkingBudgetEnabled = value);
                    },
                  ),
                  const Divider(color: Colors.white10),

                  // Tools section (existing, potentially redundant with 'Enable Tools' switch but keeping structure)
                  buildExpansionTile(context, 'Tools', [
                    buildSettingSwitch(
                      context,
                      'Structured Output',
                      aiSettings.structuredOutputEnabled,
                      (bool value) {
                        aiSettings.update(
                          (s) => s.structuredOutputEnabled = value,
                        );
                      },
                    ),
                    buildSettingSwitch(
                      context,
                      'Code Execution',
                      aiSettings.codeExecutionEnabled,
                      (bool value) {
                        aiSettings.update(
                          (s) => s.codeExecutionEnabled = value,
                        );
                      },
                    ),
                    buildSettingSwitch(
                      context,
                      'Function Calling',
                      aiSettings.functionCallingEnabled,
                      (bool value) {
                        aiSettings.update(
                          (s) => s.functionCallingEnabled = value,
                        );
                      },
                    ),
                    buildSettingSwitch(
                      context,
                      'Grounding with Google Search',
                      aiSettings.groundingWithSearchEnabled,
                      (bool value) {
                        aiSettings.update(
                          (s) => s.groundingWithSearchEnabled = value,
                        );
                      },
                    ),
                    buildSettingSwitch(
                      context,
                      'URL context',
                      aiSettings.urlContextEnabled,
                      (bool value) {
                        aiSettings.update((s) => s.urlContextEnabled = value);
                      },
                    ),
                  ]),
                  // Advanced settings
                  buildExpansionTile(context, 'Advanced settings', [
                    buildSettingSwitch(
                      context,
                      'Safety settings',
                      aiSettings.safetySettingsEnabled,
                      (bool value) {
                        aiSettings.update(
                          (s) => s.safetySettingsEnabled = value,
                        );
                      },
                    ),
                    buildSettingSwitch(
                      context,
                      'Add stop sequence',
                      aiSettings.addStopSequenceEnabled,
                      (bool value) {
                        aiSettings.update(
                          (s) => s.addStopSequenceEnabled = value,
                        );
                      },
                    ),
                  ]),
                  const SizedBox(height: 20),
                  // Example button to clear settings
                  Center(
                    child: ElevatedButton(
                      onPressed: () => aiSettings.reset(),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.red.shade700,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Clear All Settings'),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

// Widget leftpanel() {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Text(
//           'Google AI Studio',
//           style: Theme.of(
//             context,
//           ).textTheme.headlineSmall?.copyWith(color: Colors.white),
//         ),
//       ),
//       buildNavItem(context, Icons.chat_bubble_outline, 'Chat', 0),
//       buildNavItem(context, Icons.stream, 'Stream', 1),
//       buildNavItem(context, Icons.generating_tokens, 'Generate Media', 2),
//       buildNavItem(context, Icons.build, 'Build', 3),
//       buildNavItem(context, Icons.history, 'History', 4),
//       const Spacer(),
//       Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Text(
//           'Google AI models may make mistakes, so double-check outputs.',
//           style: Theme.of(
//             context,
//           ).textTheme.bodySmall?.copyWith(color: Colors.white54),
//         ),
//       ),
//     ],
//   );
// }

class _LeftDrawer extends StatelessWidget {
  final SessionManager sessionManager;
  const _LeftDrawer({required this.sessionManager});

  @override
  Widget build(BuildContext context) {
    final sessions = sessionManager.sessions;
    final currentId = sessionManager.currentSessionId;

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('New session'),
              onTap: () {
                final id = sessionManager.createSession();
                sessionManager.setCurrentSession(id);
                Navigator.pop(context);
              },
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: sessions.length,
                itemBuilder: (context, index) {
                  final s = sessions[index];
                  final selected = s.id == currentId;
                  return ListTile(
                    selected: selected,
                    leading: const Icon(Icons.chat_bubble_outline),
                    title: Text(s.title),
                    subtitle: Text(
                      s.lastMessage?.text ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {
                      sessionManager.setCurrentSession(s.id);
                      Navigator.pop(context);
                    },
                    trailing: PopupMenuButton<String>(
                      onSelected: (v) async {
                        if (v == 'rename') {
                          final controller = TextEditingController(
                            text: s.title,
                          );
                          final ok = await showDialog<bool>(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('Rename session'),
                              content: TextField(
                                controller: controller,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text('Cancel'),
                                ),
                                FilledButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('Save'),
                                ),
                              ],
                            ),
                          );
                          if (ok == true) {
                            sessionManager.renameSession(
                              s.id,
                              controller.text.trim(),
                            );
                          }
                        } else if (v == 'duplicate') {
                          final id = sessionManager.createSession(
                            title: s.title,
                          );
                          sessionManager.replaceAllMessages(
                            sessionId: id,
                            messages: s.messages,
                          );
                          sessionManager.setCurrentSession(id);
                        } else if (v == 'delete') {
                          sessionManager.deleteSession(s.id);
                        }
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(value: 'rename', child: Text('Rename')),
                        PopupMenuItem(
                          value: 'duplicate',
                          child: Text('Duplicate'),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThinkingBubble extends StatelessWidget {
  const _ThinkingBubble();

  @override
  Widget build(BuildContext context) {
    return MessageBubble(
      message: UnifiedMessage(
        id: 'thinking',
        role: MessageRole.assistant,
        createdAt: DateTime.now(),
      ),
      isUser: false,
      isStreaming: true, // Use the streaming indicator animation
      settingsService: Provider.of<StorageSettingsService>(
        context,
        listen: false,
      ),
    );
  }
}
