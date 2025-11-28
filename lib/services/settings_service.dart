import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/subtitletranslator/app_settings.dart';

class SettingsService {
  static const String _settingsKey = 'app_settings';
  static AppSettings? _cachedSettings;

  static Future<AppSettings> loadSettings() async {
    if (_cachedSettings != null) {
      return _cachedSettings!;
    }

    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_settingsKey);

    if (jsonString != null) {
      try {
        final json = jsonDecode(jsonString) as Map<String, dynamic>;
        _cachedSettings = AppSettings.fromJson(json);
        return _cachedSettings!;
      } catch (_) {
        // If parsing fails, return default settings
      }
    }

    _cachedSettings = const AppSettings();
    return _cachedSettings!;
  }

  static Future<void> saveSettings(AppSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(settings.toJson());
    await prefs.setString(_settingsKey, jsonString);
    _cachedSettings = settings;
  }

  static Future<void> resetSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_settingsKey);
    _cachedSettings = const AppSettings();
  }

  static AppSettings getCached() {
    return _cachedSettings ?? const AppSettings();
  }
}
