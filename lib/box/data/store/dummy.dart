// Required external packages:
// flutter_riverpod: ^2.x.x
// shared_preferences: ^2.x.x
// tiktoken: ^1.x.x // As used for token counting
// file_picker: ^6.x.x // As used in _showAttachBottomSheet
// image_picker: ^1.x.x // As used in _showAttachBottomSheet

import 'package:flutter/material.dart';
import 'package:miko/box/view/page/home/home.dart';
import 'package:openai_dart/openai_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiktoken/tiktoken.dart'; // Import at the top
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktoken/tiktoken.dart' as tk; // Import Riverpod

// --- MOCK/PLACEHOLDER DEPENDENCIES ---
// These are included to make the provided code snippets compile and run for demonstration.
// You should replace these with your actual implementations.

// Mock ChatController based on its usage in _showAttachBottomSheet
class ChatController {
  void addImageBase64(String base64String) {
    debugPrint(
      'ChatController: Image added (Base64 length: ${base64String.length})',
    );
  }

  void addAudioBytes(
    List<int> bytes, {
    required String format,
    required AudioSourceType source,
  }) {
    debugPrint(
      'ChatController: Audio added (Bytes length: ${bytes.length}, Format: $format, Source: $source)',
    );
  }

  void addFileBytes({
    required String fileName,
    required List<int> bytes,
    required String mimeType,
    required int size,
  }) {
    debugPrint(
      'ChatController: File added (FileName: $fileName, Size: $size, MimeType: $mimeType)',
    );
  }
}

enum AudioSourceType { picked, recorded }

// Mock Client for fetching models

// Global instance of the mock client, can be replaced by a Riverpod provider later
final client = OpenAIClient(apiKey: '', baseUrl: 'baseUrl');

// --- AI SETTINGS PROVIDER (USING CHANGE NOTIFIER) ---

enum AiProviderType { openai, gemini }

class AiSettings extends ChangeNotifier {
  AiProviderType provider = AiProviderType.openai;
  String openAiApiKey = '';
  String? openAiBaseUrl;
  String geminiApiKey = '';
  String modelId = 'gpt-5-mini'; // Changed default to better fit mock models
  double temperature = 1.0;
  int maxTokens = 100000;
  bool streaming = true;
  bool voiceResponse = false;
  bool persistSystemMessage = true;
  String systemPrompt =
      'in your messages full use markdown schema , and when you got image and prompt , you should read prmpt and then creating flutter ui code user need that for using in his project';

  // New settings
  bool toolsEnabled = false;
  String selectedVoice = 'alloy';
  bool historyEnabled = false;
  bool thinkingModeEnabled = false;
  bool thinkingBudgetEnabled = false;
  bool structuredOutputEnabled = false;
  bool codeExecutionEnabled = false;
  bool functionCallingEnabled = false;
  bool groundingWithSearchEnabled = false;
  bool urlContextEnabled = false;
  bool safetySettingsEnabled = false;
  bool addStopSequenceEnabled = false;
  String mediaResolution = 'Default';

  // State specific to the UI, not persisted globally by AiSettings but updated externally
  int currentTokenCount = 0;
  List<String> availableModels = ['Loading...']; // Initial state

  // Internal constant for default settings values
  static const String _defaultModelId = 'gpt-5-mini';
  static const double _defaultTemperature = 1.0;
  static const int _defaultMaxTokens = 100000;
  static const bool _defaultStreaming =
      false; // Changed from true to match common UX
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

  Future<void> init() async {
    await load();
    await fetchModels(); // Fetch models on init
  }

  void update(void Function(AiSettings s) change) {
    change(this);
    notifyListeners();
    save(); // Save changes immediately
  }

  void onTextChangedForTokens({String? modelText = ''}) {
    final userText = inputCtrl.text;
    // Only user text here; model text is added during streams (see token update hooks below)
    // TokenCounter.updateFrom(userText: userText, modelText: '');
    final u = userText;
    final m = modelText ?? '';
    String total;
    total = u + m;

    final encoding = tk.getEncoding('cl100k_base');
    final xcounter = ss.currentTokenCount.get();
    // _curPage.value == HomePageEnum.history;

    final countr = encoding.encode(total).length;
    ss.currentTokenCount.set(countr + xcounter);
    notifyListeners(); // Notify listeners that current token count has changed

    // notifyListeners(); // Notify listeners that current token count has changed
  }

  void updateCurrentTokenCount(String text) {
    final encoding = getEncoding('cl100k_base');
    currentTokenCount = encoding.encode(text).length;
    notifyListeners(); // Notify listeners that current token count has changed
  }

  Future<void> fetchModels() async {
    try {
      final res = await client.listModels(); // Using the global mock client
      availableModels = res.data.map((model) => model.id).toList();
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching models: $e');
      if (availableModels.isEmpty || availableModels.first == 'Loading...') {
        availableModels = [
          'gpt-4o-mini-audio',
          'gpt-5-mini',
        ]; // Fallback models
        notifyListeners();
      }
    }
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
    await prefs.clear(); // Clear all shared preferences for simplicity
    await init(); // Reload defaults and refetch models
  }
}

// You would provide this using Riverpod or another state management solution
final aiSettings = ChangeNotifierProvider((ref) => AiSettings()..init());

// Riverpod provider for AiSettings
