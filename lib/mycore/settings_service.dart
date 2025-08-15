// lib/services/storage_settings_service.dart
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class SettingsProfile {
  SettingsProfile({
    required this.id,
    required this.name,
    // Defaults
    this.defaultChatModelId = 'gpt-5-mini',
    this.defaultTemperature = 1,
    this.defaultVoice = 'alloy',
    // Nullable config values
    this.temperature,
    this.voiceProcessModel,
    this.systemMessage,
    this.titleGeneratorModel,
    this.apiKey,
    this.baseUrl,
    this.apiKey2,
    this.baseUrl2,
    this.enableTools = false,
    this.enableSystemMessage = true,
    this.limitForContextWindow,
    this.fallbackModel,
    this.transcriptModel,
    this.toolsMode,
    this.usage,
    this.cost,
    this.costInput,
    this.costOutput,
    this.tokenCount,
    this.geminiModel,
    this.headReminderMessage,
    // Capability flags
    this.supportsStreaming = true,
    this.supportsAudioInput = false,
    this.supportsAudioOutput = false,
    this.supportsTranscription = true,
    this.supportsTts = false,
    this.supportsToolCalling = false,
    this.supportsOcr = false,
    // Runtime state flags
    this.isThinking = false,
    this.isStreaming = true,
    this.isStreamDone = false,
    this.isResponseDone = false,
    this.isAudioPlaying = false,
    this.isToolCalling = false,
    this.isToolCallDone = false,
    this.isWaiting = false,
    this.isWaitingDone = false,
  });

  final String id;
  String name;

  // Defaults
  String defaultChatModelId;
  double defaultTemperature;
  String defaultVoice;

  // Nullable config values
  double? temperature;
  String? voiceProcessModel;
  String? systemMessage;
  String? titleGeneratorModel;
  String? apiKey;
  String? baseUrl;
  String? apiKey2;
  String? baseUrl2;
  bool enableTools;
  bool enableSystemMessage;
  int? limitForContextWindow;
  String? fallbackModel;
  String? transcriptModel;
  String? toolsMode;
  double? usage;
  double? cost;
  double? costInput;
  double? costOutput;
  int? tokenCount;
  String? geminiModel;
  String? headReminderMessage;

  // Capability flags
  bool supportsStreaming;
  bool supportsAudioInput;
  bool supportsAudioOutput;
  bool supportsTranscription;
  bool supportsTts;
  bool supportsToolCalling;
  bool supportsOcr;

  // Runtime state flags
  bool isThinking;
  bool isStreaming;
  bool isStreamDone;
  bool isResponseDone;
  bool isAudioPlaying;
  bool isToolCalling;
  bool isToolCallDone;
  bool isWaiting;
  bool isWaitingDone;

  factory SettingsProfile.defaults({
    String? id,
    String name = 'Default',
  }) {
    return SettingsProfile(
      id: id ?? const Uuid().v4(),
      name: name,
    );
  }

  SettingsProfile copyWith({
    String? id,
    String? name,
    String? defaultChatModelId,
    double? defaultTemperature,
    String? defaultVoice,
    double? temperature,
    String? voiceProcessModel,
    String? systemMessage,
    String? titleGeneratorModel,
    String? apiKey,
    String? baseUrl,
    String? apiKey2,
    String? baseUrl2,
    bool? enableTools,
    bool? enableSystemMessage,
    int? limitForContextWindow,
    String? fallbackModel,
    String? transcriptModel,
    String? toolsMode,
    double? usage,
    double? cost,
    double? costInput,
    double? costOutput,
    int? tokenCount,
    String? geminiModel,
    String? headReminderMessage,
    bool? supportsStreaming,
    bool? supportsAudioInput,
    bool? supportsAudioOutput,
    bool? supportsTranscription,
    bool? supportsTts,
    bool? supportsToolCalling,
    bool? supportsOcr,
    bool? isThinking,
    bool? isStreaming,
    bool? isStreamDone,
    bool? isResponseDone,
    bool? isAudioPlaying,
    bool? isToolCalling,
    bool? isToolCallDone,
    bool? isWaiting,
    bool? isWaitingDone,
  }) {
    return SettingsProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      defaultChatModelId: defaultChatModelId ?? this.defaultChatModelId,
      defaultTemperature: defaultTemperature ?? this.defaultTemperature,
      defaultVoice: defaultVoice ?? this.defaultVoice,
      temperature: temperature ?? this.temperature,
      voiceProcessModel: voiceProcessModel ?? this.voiceProcessModel,
      systemMessage: systemMessage ?? this.systemMessage,
      titleGeneratorModel: titleGeneratorModel ?? this.titleGeneratorModel,
      apiKey: apiKey ?? this.apiKey,
      baseUrl: baseUrl ?? this.baseUrl,
      apiKey2: apiKey2 ?? this.apiKey2,
      baseUrl2: baseUrl2 ?? this.baseUrl2,
      enableTools: enableTools ?? this.enableTools,
      enableSystemMessage: enableSystemMessage ?? this.enableSystemMessage,
      limitForContextWindow:
          limitForContextWindow ?? this.limitForContextWindow,
      fallbackModel: fallbackModel ?? this.fallbackModel,
      transcriptModel: transcriptModel ?? this.transcriptModel,
      toolsMode: toolsMode ?? this.toolsMode,
      usage: usage ?? this.usage,
      cost: cost ?? this.cost,
      costInput: costInput ?? this.costInput,
      costOutput: costOutput ?? this.costOutput,
      tokenCount: tokenCount ?? this.tokenCount,
      geminiModel: geminiModel ?? this.geminiModel,
      headReminderMessage: headReminderMessage ?? this.headReminderMessage,
      supportsStreaming: supportsStreaming ?? this.supportsStreaming,
      supportsAudioInput: supportsAudioInput ?? this.supportsAudioInput,
      supportsAudioOutput: supportsAudioOutput ?? this.supportsAudioOutput,
      supportsTranscription: supportsTranscription ?? this.supportsTranscription,
      supportsTts: supportsTts ?? this.supportsTts,
      supportsToolCalling: supportsToolCalling ?? this.supportsToolCalling,
      supportsOcr: supportsOcr ?? this.supportsOcr,
      isThinking: isThinking ?? this.isThinking,
      isStreaming: isStreaming ?? this.isStreaming,
      isStreamDone: isStreamDone ?? this.isStreamDone,
      isResponseDone: isResponseDone ?? this.isResponseDone,
      isAudioPlaying: isAudioPlaying ?? this.isAudioPlaying,
      isToolCalling: isToolCalling ?? this.isToolCalling,
      isToolCallDone: isToolCallDone ?? this.isToolCallDone,
      isWaiting: isWaiting ?? this.isWaiting,
      isWaitingDone: isWaitingDone ?? this.isWaitingDone,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'defaultChatModelId': defaultChatModelId,
        'defaultTemperature': defaultTemperature,
        'defaultVoice': defaultVoice,
        'temperature': temperature,
        'voiceProcessModel': voiceProcessModel,
        'systemMessage': systemMessage,
        'titleGeneratorModel': titleGeneratorModel,
        'apiKey': apiKey,
        'baseUrl': baseUrl,
        'apiKey2': apiKey2,
        'baseUrl2': baseUrl2,
        'enableTools': enableTools,
        'enableSystemMessage': enableSystemMessage,
        'limitForContextWindow': limitForContextWindow,
        'fallbackModel': fallbackModel,
        'transcriptModel': transcriptModel,
        'toolsMode': toolsMode,
        'usage': usage,
        'cost': cost,
        'costInput': costInput,
        'costOutput': costOutput,
        'tokenCount': tokenCount,
        'geminiModel': geminiModel,
        'headReminderMessage': headReminderMessage,
        'supportsStreaming': supportsStreaming,
        'supportsAudioInput': supportsAudioInput,
        'supportsAudioOutput': supportsAudioOutput,
        'supportsTranscription': supportsTranscription,
        'supportsTts': supportsTts,
        'supportsToolCalling': supportsToolCalling,
        'supportsOcr': supportsOcr,
        'isThinking': isThinking,
        'isStreaming': isStreaming,
        'isStreamDone': isStreamDone,
        'isResponseDone': isResponseDone,
        'isAudioPlaying': isAudioPlaying,
        'isToolCalling': isToolCalling,
        'isToolCallDone': isToolCallDone,
        'isWaiting': isWaiting,
        'isWaitingDone': isWaitingDone,
      };

  factory SettingsProfile.fromJson(Map<String, dynamic> json) {
    double? _toDouble(dynamic v) =>
        v == null ? null : (v is int ? v.toDouble() : (v as num).toDouble());
    return SettingsProfile(
      id: json['id'] as String,
      name: json['name'] as String? ?? 'Profile',
      defaultChatModelId:
          json['defaultChatModelId'] as String? ?? 'gpt-5-mini',
      defaultTemperature:
          _toDouble(json['defaultTemperature']) ?? 0.7,
      defaultVoice: json['defaultVoice'] as String? ?? 'alloy',
      temperature: _toDouble(json['temperature']),
      voiceProcessModel: json['voiceProcessModel'] as String?,
      systemMessage: json['systemMessage'] as String?,
      titleGeneratorModel: json['titleGeneratorModel'] as String?,
      apiKey: json['apiKey'] as String?,
      baseUrl: json['baseUrl'] as String?,
      apiKey2: json['apiKey2'] as String?,
      baseUrl2: json['baseUrl2'] as String?,
      enableTools: json['enableTools'] as bool? ?? false,
      enableSystemMessage: json['enableSystemMessage'] as bool? ?? true,
      limitForContextWindow: json['limitForContextWindow'] as int?,
      fallbackModel: json['fallbackModel'] as String?,
      transcriptModel: json['transcriptModel'] as String?,
      toolsMode: json['toolsMode'] as String?,
      usage: _toDouble(json['usage']),
      cost: _toDouble(json['cost']),
      costInput: _toDouble(json['costInput']),
      costOutput: _toDouble(json['costOutput']),
      tokenCount: json['tokenCount'] is num
          ? (json['tokenCount'] as num).toInt()
          : json['tokenCount'] as int?,
      geminiModel: json['geminiModel'] as String?,
      headReminderMessage: json['headReminderMessage'] as String?,
      supportsStreaming: json['supportsStreaming'] as bool? ?? true,
      supportsAudioInput: json['supportsAudioInput'] as bool? ?? false,
      supportsAudioOutput: json['supportsAudioOutput'] as bool? ?? false,
      supportsTranscription: json['supportsTranscription'] as bool? ?? false,
      supportsTts: json['supportsTts'] as bool? ?? true,
      supportsToolCalling: json['supportsToolCalling'] as bool? ?? false,
      supportsOcr: json['supportsOcr'] as bool? ?? false,
      isThinking: json['isThinking'] as bool? ?? false,
      isStreaming: json['isStreaming'] as bool? ?? false,
      isStreamDone: json['isStreamDone'] as bool? ?? false,
      isResponseDone: json['isResponseDone'] as bool? ?? false,
      isAudioPlaying: json['isAudioPlaying'] as bool? ?? false,
      isToolCalling: json['isToolCalling'] as bool? ?? false,
      isToolCallDone: json['isToolCallDone'] as bool? ?? false,
      isWaiting: json['isWaiting'] as bool? ?? false,
      isWaitingDone: json['isWaitingDone'] as bool? ?? false,
    );
  }
}

class StorageSettingsService extends ChangeNotifier {
  StorageSettingsService._();

  static const _prefsKeyProfiles = 'settings.profiles';
  static const _prefsKeyActiveProfileId = 'settings.activeProfileId';
  static const _prefsKeyVersion = 'settings.version';
  static const _currentVersion = 1;

  final Map<String, SettingsProfile> _profiles = {};
  String? _activeProfileId;

  SettingsProfile get _activeProfile =>
      _profiles[_activeProfileId] ?? ensureDefaultProfile();

  static Future<StorageSettingsService> init() async {
    final svc = StorageSettingsService._();
    await svc.load();
    return svc;
  }

  // Profiles management
  List<SettingsProfile> get profiles =>
      _profiles.values.toList(growable: false);

  String get activeProfileId => _activeProfileId ?? ensureDefaultProfile().id;

  SettingsProfile get activeProfile => _activeProfile;

  String createProfile({String name = 'Profile', SettingsProfile? seed}) {
    final id = const Uuid().v4();
    final profile = (seed ?? SettingsProfile.defaults()).copyWith(
      id: id,
      name: name,
    );
    _profiles[id] = profile;
    _activeProfileId = id;
    save();
    notifyListeners();
    return id;
  }

  bool switchProfile(String id) {
    if (!_profiles.containsKey(id)) return false;
    _activeProfileId = id;
    save();
    notifyListeners();
    return true;
  }

  bool renameProfile(String id, String newName) {
    final p = _profiles[id];
    if (p == null) return false;
    _profiles[id] = p.copyWith(name: newName);
    save();
    notifyListeners();
    return true;
  }

  bool deleteProfile(String id) {
    if (!_profiles.containsKey(id)) return false;
    if (_profiles.length == 1) return false; // keep at least one
    _profiles.remove(id);
    if (_activeProfileId == id) {
      _activeProfileId = _profiles.values.first.id;
    }
    save();
    notifyListeners();
    return true;
  }

  void resetActiveProfile() {
    final current = _activeProfile;
    _profiles[current.id] =
        SettingsProfile.defaults(id: current.id, name: current.name);
    save();
    notifyListeners();
  }

  // Persistence
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final version = prefs.getInt(_prefsKeyVersion);
    final profilesJson = prefs.getString(_prefsKeyProfiles);
    final activeId = prefs.getString(_prefsKeyActiveProfileId);

    if (profilesJson != null) {
      final decoded = jsonDecode(profilesJson) as List<dynamic>;
      for (final e in decoded) {
        final p = SettingsProfile.fromJson(e as Map<String, dynamic>);
        _profiles[p.id] = p;
      }
      _activeProfileId = activeId ?? decoded.first['id'] as String?;
    }

    if (_profiles.isEmpty) {
      final def = SettingsProfile.defaults(name: 'Default');
      _profiles[def.id] = def;
      _activeProfileId = def.id;
      await save();
    }

    if (version != _currentVersion) {
      await _migrate(version ?? 0);
    }

    notifyListeners();
  }

  Future<void> _migrate(int oldVersion) async {
    // Reserved for future migrations
    await save();
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    final list = _profiles.values.map((e) => e.toJson()).toList();
    await prefs.setString(_prefsKeyProfiles, jsonEncode(list));
    await prefs.setString(_prefsKeyActiveProfileId, _activeProfileId!);
    await prefs.setInt(_prefsKeyVersion, _currentVersion);
  }

  SettingsProfile ensureDefaultProfile() {
    if (_profiles.isEmpty) {
      final def = SettingsProfile.defaults(name: 'Default');
      _profiles[def.id] = def;
      _activeProfileId = def.id;
    }
    return _profiles[_activeProfileId]!;
  }

  // Export / Import
  String exportActiveProfileToJson({bool pretty = false}) {
    final encoder = pretty ? const JsonEncoder.withIndent('  ') : const JsonEncoder();
    return encoder.convert(_activeProfile.toJson());
  }

  String exportAllProfilesToJson({bool pretty = false}) {
    final encoder = pretty ? const JsonEncoder.withIndent('  ') : const JsonEncoder();
    final list = _profiles.values.map((e) => e.toJson()).toList();
    return encoder.convert({
      'version': _currentVersion,
      'activeProfileId': _activeProfileId,
      'profiles': list,
    });
  }

  Future<File> exportActiveProfileToFile(File file, {bool pretty = true}) async {
    final jsonStr = exportActiveProfileToJson(pretty: pretty);
    return file.writeAsString(jsonStr);
  }

  Future<File> exportAllProfilesToFile(File file, {bool pretty = true}) async {
    final jsonStr = exportAllProfilesToJson(pretty: pretty);
    return file.writeAsString(jsonStr);
  }

  Future<String> importProfileFromJson(String jsonStr,
      {bool makeActive = true}) async {
    final map = jsonDecode(jsonStr) as Map<String, dynamic>;
    // Generate new id to avoid collisions
    final imported = SettingsProfile.fromJson(map);
    final newId = const Uuid().v4();
    final prof = imported.copyWith(id: newId);
    _profiles[newId] = prof;
    if (makeActive) _activeProfileId = newId;
    await save();
    notifyListeners();
    return newId;
  }

  Future<void> importAllFromJson(String jsonStr) async {
    final map = jsonDecode(jsonStr) as Map<String, dynamic>;
    final profilesList = (map['profiles'] as List<dynamic>? ?? []);
    final newProfiles = <String, SettingsProfile>{};
    for (final p in profilesList) {
      final prof = SettingsProfile.fromJson(p as Map<String, dynamic>);
      newProfiles[prof.id] = prof;
    }
    if (newProfiles.isNotEmpty) {
      _profiles
        ..clear()
        ..addAll(newProfiles);
      final incomingActive = map['activeProfileId'] as String?;
      _activeProfileId = incomingActive != null && _profiles.containsKey(incomingActive)
          ? incomingActive
          : _profiles.values.first.id;
      await save();
      notifyListeners();
    }
  }

  Future<void> importProfileFromFile(File file, {bool makeActive = true}) async {
    final str = await file.readAsString();
    await importProfileFromJson(str, makeActive: makeActive);
  }

  Future<void> importAllFromFile(File file) async {
    final str = await file.readAsString();
    await importAllFromJson(str);
  }

  // Voice helper (returns normalized voice id; map to your SDK as needed)
  String getOpenAIVoiceId(String voiceParams) {
    switch (voiceParams.toLowerCase()) {
      case 'alloy':
        return 'alloy';
      case 'ash':
        return 'ash';
      case 'echo':
        return 'echo';
      case 'ballad':
        return 'ballad';
      case 'sage':
        return 'sage';
      case 'coral':
        return 'coral';
      case 'shimmer':
        return 'shimmer';
      default:
        return 'alloy';
    }
  }

  // Getters with defaults / fallbacks
  double get temperature =>
      _activeProfile.temperature ?? _activeProfile.defaultTemperature;
  String get defaultVoice => _activeProfile.defaultVoice;
  String get defaultChatModelId => _activeProfile.defaultChatModelId;
  double get defaultTemperature => _activeProfile.defaultTemperature;

  String? get voiceProcessModel => _activeProfile.voiceProcessModel;
  String? get systemMessage => _activeProfile.systemMessage;
  String? get titleGeneratorModel => _activeProfile.titleGeneratorModel;
  String? get apiKey => _activeProfile.apiKey;
  String? get baseUrl => _activeProfile.baseUrl;
  String? get apiKey2 => _activeProfile.apiKey2;
  String? get baseUrl2 => _activeProfile.baseUrl2;
  bool get enableTools => _activeProfile.enableTools;
  bool get enableSystemMessage => _activeProfile.enableSystemMessage;
  int? get limitForContextWindow => _activeProfile.limitForContextWindow;
  String? get fallbackModel => _activeProfile.fallbackModel;
  String? get transcriptModel => _activeProfile.transcriptModel;
  String? get toolsMode => _activeProfile.toolsMode;
  double? get usage => _activeProfile.usage;
  double? get cost => _activeProfile.cost;
  double? get costInput => _activeProfile.costInput;
  double? get costOutput => _activeProfile.costOutput;
  int? get tokenCount => _activeProfile.tokenCount;
  String? get geminiModel => _activeProfile.geminiModel;
  String? get headReminderMessage => _activeProfile.headReminderMessage;

  bool get supportsStreaming => _activeProfile.supportsStreaming;
  bool get supportsAudioInput => _activeProfile.supportsAudioInput;
  bool get supportsAudioOutput => _activeProfile.supportsAudioOutput;
  bool get supportsTranscription => _activeProfile.supportsTranscription;
  bool get supportsTts => _activeProfile.supportsTts;
  bool get supportsToolCalling => _activeProfile.supportsToolCalling;
  bool get supportsOcr => _activeProfile.supportsOcr;

  bool get isThinking => _activeProfile.isThinking;
  bool get isStreaming => _activeProfile.isStreaming;
  bool get isStreamDone => _activeProfile.isStreamDone;
  bool get isResponseDone => _activeProfile.isResponseDone;
  bool get isAudioPlaying => _activeProfile.isAudioPlaying;
  bool get isToolCalling => _activeProfile.isToolCalling;
  bool get isToolCallDone => _activeProfile.isToolCallDone;
  bool get isWaiting => _activeProfile.isWaiting;
  bool get isWaitingDone => _activeProfile.isWaitingDone;

  // Setters (each updates, persists, and notifies)
  Future<void> setTemperature(double? value) async {
    _updateActive(_activeProfile.copyWith(temperature: value));
  }

  Future<void> setDefaultTemperature(double value) async {
    _updateActive(_activeProfile.copyWith(defaultTemperature: value));
  }

  Future<void> setDefaultVoice(String value) async {
    _updateActive(_activeProfile.copyWith(defaultVoice: getOpenAIVoiceId(value)));
  }

  Future<void> setDefaultChatModelId(String value) async {
    _updateActive(_activeProfile.copyWith(defaultChatModelId: value));
  }

  Future<void> setVoiceProcessModel(String? value) async {
    _updateActive(_activeProfile.copyWith(voiceProcessModel: value));
  }

  Future<void> setSystemMessage(String? value) async {
    _updateActive(_activeProfile.copyWith(systemMessage: value));
  }

  Future<void> setTitleGeneratorModel(String? value) async {
    _updateActive(_activeProfile.copyWith(titleGeneratorModel: value));
  }

  Future<void> setApiKey(String? value) async {
    _updateActive(_activeProfile.copyWith(apiKey: value));
  }

  Future<void> setBaseUrl(String? value) async {
    _updateActive(_activeProfile.copyWith(baseUrl: value));
  }

  Future<void> setApiKey2(String? value) async {
    _updateActive(_activeProfile.copyWith(apiKey2: value));
  }

  Future<void> setBaseUrl2(String? value) async {
    _updateActive(_activeProfile.copyWith(baseUrl2: value));
  }

  Future<void> setEnableTools(bool value) async {
    _updateActive(_activeProfile.copyWith(enableTools: value));
  }

  Future<void> setEnableSystemMessage(bool value) async {
    _updateActive(_activeProfile.copyWith(enableSystemMessage: value));
  }

  Future<void> setLimitForContextWindow(int? value) async {
    _updateActive(_activeProfile.copyWith(limitForContextWindow: value));
  }

  Future<void> setFallbackModel(String? value) async {
    _updateActive(_activeProfile.copyWith(fallbackModel: value));
  }

  Future<void> setTranscriptModel(String? value) async {
    _updateActive(_activeProfile.copyWith(transcriptModel: value));
  }

  Future<void> setToolsMode(String? value) async {
    _updateActive(_activeProfile.copyWith(toolsMode: value));
  }

  Future<void> setUsage(double? value) async {
    _updateActive(_activeProfile.copyWith(usage: value));
  }

  Future<void> setCost(double? value) async {
    _updateActive(_activeProfile.copyWith(cost: value));
  }

  Future<void> setCostInput(double? value) async {
    _updateActive(_activeProfile.copyWith(costInput: value));
  }

  Future<void> setCostOutput(double? value) async {
    _updateActive(_activeProfile.copyWith(costOutput: value));
  }

  Future<void> setTokenCount(int? value) async {
    _updateActive(_activeProfile.copyWith(tokenCount: value));
  }

  Future<void> setGeminiModel(String? value) async {
    _updateActive(_activeProfile.copyWith(geminiModel: value));
  }

  Future<void> setHeadReminderMessage(String? value) async {
    _updateActive(_activeProfile.copyWith(headReminderMessage: value));
  }

  Future<void> setSupportsStreaming(bool value) async {
    _updateActive(_activeProfile.copyWith(supportsStreaming: value));
  }

  Future<void> setSupportsAudioInput(bool value) async {
    _updateActive(_activeProfile.copyWith(supportsAudioInput: value));
  }

  Future<void> setSupportsAudioOutput(bool value) async {
    _updateActive(_activeProfile.copyWith(supportsAudioOutput: value));
  }

  Future<void> setSupportsTranscription(bool value) async {
    _updateActive(_activeProfile.copyWith(supportsTranscription: value));
  }

  Future<void> setSupportsTts(bool value) async {
    _updateActive(_activeProfile.copyWith(supportsTts: value));
  }

  Future<void> setSupportsToolCalling(bool value) async {
    _updateActive(_activeProfile.copyWith(supportsToolCalling: value));
  }

  Future<void> setSupportsOcr(bool value) async {
    _updateActive(_activeProfile.copyWith(supportsOcr: value));
  }

  Future<void> setIsThinking(bool value) async {
    _updateActive(_activeProfile.copyWith(isThinking: value));
  }

  Future<void> setIsStreaming(bool value) async {
    _updateActive(_activeProfile.copyWith(isStreaming: value));
  }

  Future<void> setIsStreamDone(bool value) async {
    _updateActive(_activeProfile.copyWith(isStreamDone: value));
  }

  Future<void> setIsResponseDone(bool value) async {
    _updateActive(_activeProfile.copyWith(isResponseDone: value));
  }

  Future<void> setIsAudioPlaying(bool value) async {
    _updateActive(_activeProfile.copyWith(isAudioPlaying: value));
  }

  Future<void> setIsToolCalling(bool value) async {
    _updateActive(_activeProfile.copyWith(isToolCalling: value));
  }

  Future<void> setIsToolCallDone(bool value) async {
    _updateActive(_activeProfile.copyWith(isToolCallDone: value));
  }

  Future<void> setIsWaiting(bool value) async {
    _updateActive(_activeProfile.copyWith(isWaiting: value));
  }

  Future<void> setIsWaitingDone(bool value) async {
    _updateActive(_activeProfile.copyWith(isWaitingDone: value));
  }

  // Internal updater
  Future<void> _updateActive(SettingsProfile updated) async {
    _profiles[updated.id] = updated;
    await save();
    notifyListeners();
  }
}