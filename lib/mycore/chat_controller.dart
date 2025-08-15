// lib/ui/chat_controller.dart
import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:miko/ai/services/ai_browser_service.dart';
import 'package:miko/mycore/settings_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'ai_core_models.dart';
import 'ai_core_service.dart';
import 'gemini_core.dart';
import 'openai_core.dart';
import 'session_manager.dart';

enum AiProviderType { openai, gemini }

class AiSettings extends ChangeNotifier {
  // Existing settings from original AiSettings
  AiProviderType provider = AiProviderType.openai;
  String openAiApiKey = '';
  String? openAiBaseUrl;
  String geminiApiKey = '';
  String modelId = 'gpt-5-mini'; // Maps to _selectedModel
  double temperature = 1.0; // Maps to _temperature
  int maxTokens = 10000; // Maps to _tokenCount
  bool streaming = true; // Maps to _streamingEnabled
  bool voiceResponse = false; // Maps to _voiceEnabled
  bool persistSystemMessage = true; // Maps to _systemMessageEnabled
  String systemPrompt =
      'in your messages full use markdown schema , and when you got image and prompt , you should read prmpt and then creating flutter ui code user need that for using in his project'; // Maps to _systemMessageText

  // New settings added based on user request (and synced with previous _state_ variables)
  bool toolsEnabled = false; // Maps to _toolsEnabled
  String selectedVoice = 'alloy'; // Maps to _selectedVoice
  bool historyEnabled = false; // Maps to _historyEnabled
  bool thinkingModeEnabled = false; // Maps to _thinkingModeEnabled
  bool thinkingBudgetEnabled = false; // Maps to _thinkingBudgetEnabled
  bool structuredOutputEnabled = false; // Maps to _structuredOutputEnabled
  bool codeExecutionEnabled = false; // Maps to _codeExecutionEnabled
  bool functionCallingEnabled = false; // Maps to _functionCallingEnabled
  bool groundingWithSearchEnabled =
      false; // Maps to _groundingWithSearchEnabled
  bool urlContextEnabled = false; // Maps to _urlContextEnabled
  bool safetySettingsEnabled = false; // Maps to _safetySettingsEnabled
  bool addStopSequenceEnabled = false; // Maps to _addStopSequenceEnabled
  String mediaResolution = 'Default'; // Maps to _mediaResolution

  // Internal constant for default settings values
  static const String _defaultModelId = 'gpt-5-mini';
  static const double _defaultTemperature = 1.0;
  static const int _defaultMaxTokens = 10000;
  static const bool _defaultStreaming =
      false; // Changed from true as often disabled by default
  static const bool _defaultVoiceResponse = false;
  static const bool _defaultPersistSystemMessage = true;
  static const String _defaultSystemPrompt =
      'in your messages full use markdown schema , and when you got image and prompt , you should read prmpt and then creating flutter ui code user need that for using in his project';
  static const bool _defaultToolsEnabled = false;
  static const String _defaultSelectedVoice = 'alloy';
  static const bool _defaultHistoryEnabled = false;
  static const bool _defaultThinkingModeEnabled = false;
  static const bool _defaultThinkingBudgetEnabled = false;
  static const bool _defaultStructuredOutputEnabled = false;
  static const bool _defaultCodeExecutionEnabled = false;
  static const bool _defaultFunctionCallingEnabled = false;
  static const bool _defaultGroundingWithSearchEnabled = false;
  static const bool _defaultUrlContextEnabled = false;
  static const bool _defaultSafetySettingsEnabled = false;
  static const bool _defaultAddStopSequenceEnabled = false;
  static const String _defaultMediaResolution = 'Default';

  // Constructor for initial defaults or loading
  AiSettings() {
    // Setting initial states to defaults will be handled by load()
  }

  void update(void Function(AiSettings s) change) {
    change(this);
    notifyListeners();
    save(); // Save changes immediately
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    modelId = prefs.getString('setting_modelId') ?? _defaultModelId;
    temperature = prefs.getDouble('setting_temperature') ?? _defaultTemperature;
    maxTokens = prefs.getInt('setting_maxTokens') ?? _defaultMaxTokens;
    streaming = prefs.getBool('setting_streaming') ?? _defaultStreaming;
    voiceResponse =
        prefs.getBool('setting_voiceResponse') ?? _defaultVoiceResponse;
    persistSystemMessage =
        prefs.getBool('setting_persistSystemMessage') ??
        _defaultPersistSystemMessage;
    systemPrompt =
        prefs.getString('setting_systemPrompt') ?? _defaultSystemPrompt;

    // Load new settings
    toolsEnabled =
        prefs.getBool('setting_toolsEnabled') ?? _defaultToolsEnabled;
    selectedVoice =
        prefs.getString('setting_selectedVoice') ?? _defaultSelectedVoice;
    historyEnabled =
        prefs.getBool('setting_historyEnabled') ?? _defaultHistoryEnabled;
    thinkingModeEnabled =
        prefs.getBool('setting_thinkingModeEnabled') ??
        _defaultThinkingModeEnabled;
    thinkingBudgetEnabled =
        prefs.getBool('setting_thinkingBudgetEnabled') ??
        _defaultThinkingBudgetEnabled;
    structuredOutputEnabled =
        prefs.getBool('setting_structuredOutputEnabled') ??
        _defaultStructuredOutputEnabled;
    codeExecutionEnabled =
        prefs.getBool('setting_codeExecutionEnabled') ??
        _defaultCodeExecutionEnabled;
    functionCallingEnabled =
        prefs.getBool('setting_functionCallingEnabled') ??
        _defaultFunctionCallingEnabled;
    groundingWithSearchEnabled =
        prefs.getBool('setting_groundingWithSearchEnabled') ??
        _defaultGroundingWithSearchEnabled;
    urlContextEnabled =
        prefs.getBool('setting_urlContextEnabled') ?? _defaultUrlContextEnabled;
    safetySettingsEnabled =
        prefs.getBool('setting_safetySettingsEnabled') ??
        _defaultSafetySettingsEnabled;
    addStopSequenceEnabled =
        prefs.getBool('setting_addStopSequenceEnabled') ??
        _defaultAddStopSequenceEnabled;
    mediaResolution =
        prefs.getString('setting_mediaResolution') ?? _defaultMediaResolution;

    notifyListeners();
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('setting_modelId', modelId);
    await prefs.setDouble('setting_temperature', temperature);
    await prefs.setInt('setting_maxTokens', maxTokens);
    await prefs.setBool('setting_streaming', streaming);
    await prefs.setBool('setting_voiceResponse', voiceResponse);
    await prefs.setBool('setting_persistSystemMessage', persistSystemMessage);
    await prefs.setString('setting_systemPrompt', systemPrompt);

    // Save new settings
    await prefs.setBool('setting_toolsEnabled', toolsEnabled);
    await prefs.setString('setting_selectedVoice', selectedVoice);
    await prefs.setBool('setting_historyEnabled', historyEnabled);
    await prefs.setBool('setting_thinkingModeEnabled', thinkingModeEnabled);
    await prefs.setBool('setting_thinkingBudgetEnabled', thinkingBudgetEnabled);
    await prefs.setBool(
      'setting_structuredOutputEnabled',
      structuredOutputEnabled,
    );
    await prefs.setBool('setting_codeExecutionEnabled', codeExecutionEnabled);
    await prefs.setBool(
      'setting_functionCallingEnabled',
      functionCallingEnabled,
    );
    await prefs.setBool(
      'setting_groundingWithSearchEnabled',
      groundingWithSearchEnabled,
    );
    await prefs.setBool('setting_urlContextEnabled', urlContextEnabled);
    await prefs.setBool('setting_safetySettingsEnabled', safetySettingsEnabled);
    await prefs.setBool(
      'setting_addStopSequenceEnabled',
      addStopSequenceEnabled,
    );
    await prefs.setString('setting_mediaResolution', mediaResolution);
  }

  Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('setting_modelId');
    await prefs.remove('setting_temperature');
    await prefs.remove('setting_maxTokens');
    await prefs.remove('setting_streaming');
    await prefs.remove('setting_voiceResponse');
    await prefs.remove('setting_persistSystemMessage');
    await prefs.remove('setting_systemPrompt');

    // Remove new settings
    await prefs.remove('setting_toolsEnabled');
    await prefs.remove('setting_selectedVoice');
    await prefs.remove('setting_historyEnabled');
    await prefs.remove('setting_thinkingModeEnabled');
    await prefs.remove('setting_thinkingBudgetEnabled');
    await prefs.remove('setting_structuredOutputEnabled');
    await prefs.remove('setting_codeExecutionEnabled');
    await prefs.remove('setting_functionCallingEnabled');
    await prefs.remove('setting_groundingWithSearchEnabled');
    await prefs.remove('setting_urlContextEnabled');
    await prefs.remove('setting_safetySettingsEnabled');
    await prefs.remove('setting_addStopSequenceEnabled');
    await prefs.remove('setting_mediaResolution');

    await load(); // Reload defaults
  }
}

class ChatController extends ChangeNotifier {
  final SessionManager sessionManager;
  final AiSettings settings;
  final StorageSettingsService settingsService;
  ChatController({
    required this.sessionManager,
    required this.settings,
    required this.settingsService,
  });

  // Input state
  final textController = TextEditingController();
  final inputFocus = FocusNode();
  final List<Attachment> _pendingAttachments = [];
  bool get hasPendingAttachments => _pendingAttachments.isNotEmpty;
  List<Attachment> get pendingAttachments =>
      List.unmodifiable(_pendingAttachments);

  // Recording
  final _recorder = AudioRecorder();
  bool isRecording = false;
  Duration recordingDuration = Duration.zero;
  Timer? _recordingTimer;
  String? _recordTempPath;

  // Streaming / typing
  bool isSending = false;
  bool isStreaming = false;
  String streamingMessageId = '';
  StreamSubscription<AiStreamEvent>? _streamSub;

  // Provider factory
  AiCoreService _makeService() {
    //  switch (settings.provider) {
    //  case AiProviderType.openai:
    return OpenAiCoreService(
      client:
          client, // you should create the client with apiKey/baseUrl in your app layer
      defaultChatModelId: settings.modelId,
      defaultTemperature: settings.temperature,
      settingsService: settingsService,
      settings: settings,
    );
  }
  //  case AiProviderType.gemini:
  //  return GeminiCoreService(
  //  apiKey: settings.geminiApiKey,
  //  chatModelId: settings.modelId,
  //  defaultTemperature: settings.temperature,
  //  settingsService: settingsService
  //  );
  //  }
  //  }

  // Placeholder for OpenAI dart client injection
  // Replace this with your actual client builder with API key/base URL

  // Attachments handling
  void addImageBase64(String base64, {String mimeType = 'image/jpeg'}) {
    _pendingAttachments.add(
      Attachment.image(base64Data: base64, mimeType: mimeType),
    );
    notifyListeners();
  }

  void addAudioBytes(
    Uint8List bytes, {
    Duration duration = Duration.zero,
    AudioFormat format = AudioFormat.wav,
    AudioSourceType source = AudioSourceType.recorded,
  }) {
    _pendingAttachments.add(
      Attachment.audio(
        bytes: bytes,
        duration: duration,
        sourceType: source,
        format: format,
      ),
    );
    notifyListeners();
  }

  void addFileBytes({
    required String fileName,
    required Uint8List bytes,
    String mimeType = 'application/octet-stream',
    int? size,
  }) {
    _pendingAttachments.add(
      Attachment.file(
        fileName: fileName,
        bytes: bytes,
        mimeType: mimeType,
        size: size,
      ),
    );
    notifyListeners();
  }

  void addChunkText(String text, {String? sourceName}) {
    _pendingAttachments.add(
      Attachment.chunk(text: text, sourceName: sourceName),
    );
    notifyListeners();
  }

  void removePendingAttachmentAt(int index) {
    if (index >= 0 && index < _pendingAttachments.length) {
      _pendingAttachments.removeAt(index);
      notifyListeners();
    }
  }

  void clearPending() {
    _pendingAttachments.clear();
    notifyListeners();
  }

  // Recording
  Future<void> startRecording() async {
    if (await _recorder.hasPermission() != true) return;
    isRecording = true;
    recordingDuration = Duration.zero;
    _recordingTimer?.cancel();
    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      recordingDuration += const Duration(seconds: 1);
      notifyListeners();
    });

    final dir = await getTemporaryDirectory();
    _recordTempPath = '${dir.path}/${const Uuid().v4()}.wav';
    await _recorder.start(
      const RecordConfig(encoder: AudioEncoder.wav),
      path: _recordTempPath!,
    );
    notifyListeners();
  }

  Future<void> stopRecording({bool cancelled = false}) async {
    _recordingTimer?.cancel();
    final path = await _recorder.stop();
    isRecording = false;
    notifyListeners();

    if (cancelled || path == null) {
      if (path != null) {
        try {
          File(path).delete();
        } catch (_) {}
      }
      return;
    }

    final bytes = await File(path).readAsBytes();
    addAudioBytes(
      bytes,
      duration: recordingDuration,
      format: AudioFormat.wav,
      source: AudioSourceType.recorded,
    );
    recordingDuration = Duration.zero;
    notifyListeners();
  }

  // Send flow
  Future<void> sendCurrentInput() async {
    if (isSending) return;
    final session = sessionManager.currentSession;
    if (session == null) return;

    final text = textController.text.trim();
    final hasContent = text.isNotEmpty || _pendingAttachments.isNotEmpty;
    if (!hasContent) return;
    isStreaming = true;
    isSending = true;
    notifyListeners();

    final userMsg = sessionManager.addMessage(
      sessionId: session.id,
      role: MessageRole.user,
      text: text.isEmpty ? null : text,
      attachments: List.of(_pendingAttachments),
    );

    textController.clear();
    clearPending();

    // Auto title
    if (session.title == 'New Chat' && text.isNotEmpty) {
      _autoTitle(text);
    }

    try {
      final service = _makeService();
      final history = sessionManager.currentSession!.messages;
      if (settings.voiceResponse) {
        // voice answer
        final vr = await service.voiceResponse(
          history: history,
          options: AiCallOptions(
            modelIdOverride: settings.modelId,
            temperature: settings.temperature,
          ),
          tts: const AiTtsOptions(responseMimeType: 'audio/wav'),
        );
        final detectedFormat = detectAudioFormat(vr.audioBytes);
        final assistant = UnifiedMessage(
          id: const Uuid().v4(),
          role: MessageRole.assistant,
          text: vr.transcript ?? '',
          attachments: [
            if (vr.audioBytes.isNotEmpty)
              Attachment.audio(
                bytes: vr.audioBytes,
                duration: Duration(minutes: 1),
                sourceType: AudioSourceType.picked,
                format: detectedFormat,
              ),
          ],
          createdAt: DateTime.now(),
        );
        sessionManager.addMessage(
          sessionId: session.id,
          role: assistant.role,
          text: assistant.text,
          attachments: assistant.attachments,
        );
      } else if (settings.streaming) {
        await _handleStreaming(service, session.id, history);
      } else {
        final res = await service.messageMulti(
          history: history,
          options: AiCallOptions(
            modelIdOverride: settings.modelId,
            temperature: settings.temperature,
          ),
        );
        sessionManager.addMessage(
          sessionId: session.id,
          role: res.message.role,
          text: res.message.text,
          attachments: res.message.attachments,
        );
      }
    } finally {
      isStreaming = false;
      isSending = false;
      notifyListeners();
    }
  }

  Future<void> _handleStreaming(
    AiCoreService service,
    String sessionId,
    List<UnifiedMessage> history,
  ) async {
    isStreaming = true;
    isSending = true;
    final placeholder = sessionManager.addMessage(
      sessionId: sessionId,
      role: MessageRole.assistant,
      text: null,
    );

    streamingMessageId = placeholder.id;
    notifyListeners();

    _streamSub?.cancel();
    _streamSub = service
        .streamMessage(
          history: history,
          options: AiCallOptions(
            modelIdOverride: settings.modelId,
            temperature: settings.temperature,
          ),
        )
        .listen(
          (event) {
            if (event is AiStreamDeltaText) {
              sessionManager.editMessage(
                sessionId: sessionId,
                messageId: streamingMessageId,
                newText: event.fullText,
              );
            } else if (event is AiStreamThinking) {
              // can be used to show thinking UI
            } else if (event is AiStreamToolCall) {
              // could append tool call info in metadata
            } else if (event is AiStreamCompleted) {
              isStreaming = false;
              isSending = false;
              notifyListeners();
            }
          },
          onError: (e, st) {
            isSending = false;
            isStreaming = false;
            notifyListeners();
          },
        );
  }

  AudioFormat detectAudioFormat(Uint8List bytes) {
    if (bytes.length >= 3 &&
        bytes[0] == 0x49 && // 'I'
        bytes[1] == 0x44 && // 'D'
        bytes[2] == 0x33) {
      // '3'
      return AudioFormat.mp3;
    }
    if (bytes.length >= 12 &&
        bytes[0] == 0x52 && // 'R'
        bytes[1] == 0x49 && // 'I'
        bytes[2] == 0x46 && // 'F'
        bytes[3] == 0x46) {
      // 'F'
      return AudioFormat.wav;
    }
    return AudioFormat.wav; // fallback
  }

  // Resend: drop messages after target, then resend from that history
  Future<void> resendFromMessage(String messageId) async {
    final s = sessionManager.currentSession;
    if (s == null) return;
    final idx = s.messages.indexWhere((m) => m.id == messageId);
    if (idx < 0) return;

    final trimmed = s.messages.sublist(0, idx + 1);
    sessionManager.replaceAllMessages(sessionId: s.id, messages: trimmed);
    await sendCurrentInput(); // assumes current input has content; if not, re-run last user message only
  }

  // Edit a message
  void updateMessage(String messageId, String newText) {
    final s = sessionManager.currentSession;
    if (s == null) return;
    sessionManager.editMessage(
      sessionId: s.id,
      messageId: messageId,
      newText: newText,
    );
  }

  // Title generation helper
  Future<void> _autoTitle(String seed) async {
    try {
      final service = _makeService();
      final title = await service.generateTitle(seedText: seed);
      final s = sessionManager.currentSession;
      if (s != null && title.isNotEmpty) {
        sessionManager.renameSession(s.id, title);
      }
    } catch (_) {}
  }

  // Generate a system prompt from user description
  Future<void> generateSystemPrompt(String description) async {
    final service = _makeService();
    final prompt = await service.summarize(
      text: 'Generate a concise system prompt for this app need: $description',
    );
    settings.update(
      (s) => s.systemPrompt = prompt.isNotEmpty ? prompt : s.systemPrompt,
    );
  }

  // Cleanup
  @override
  void dispose() {
    _streamSub?.cancel();
    _recordingTimer?.cancel();
    textController.dispose();
    inputFocus.dispose();
    super.dispose();
  }
}
