import 'package:flutter/material.dart';
import 'package:miko/utils/ai_translator.dart';

/// Mixin providing translation functionality for movie and TV show titles and overviews
mixin TranslationMixin<T extends StatefulWidget> on State<T> {
  String? _translatedTitle;
  bool _isTranslating = false;
  final MovieTvTranslator _translator = MovieTvTranslator();
  bool _overviewTranslated = false;
  String _overviewText = '';
  
  // Store for multiple translated items (e.g., for lists of content)
  final Map<String, String> _translationCache = {};
  final Set<String> _translatingKeys = {};

  String? get translatedTitle => _translatedTitle;
  bool get isTranslating => _isTranslating;
  String get overviewText => _overviewText;
  MovieTvTranslator get translator => _translator;

  /// Initialize overview text
  void initializeOverview(String text) {
    if (!_overviewTranslated) {
      _overviewText = text;
    }
  }

  /// Translate title
  Future<void> translateTitle(String original) async {
    setState(() => _isTranslating = true);
    try {
      final translated = await _translator.translateTextForMoviesAndTV(original);
      setState(() {
        _translatedTitle = translated;
      });
    } finally {
      setState(() => _isTranslating = false);
    }
  }

  /// Clear translated title (revert to original)
  void clearTranslatedTitle() {
    setState(() => _translatedTitle = null);
  }

  /// Toggle title translation
  Future<void> toggleTitleTranslation(String originalTitle) async {
    if (_translatedTitle != null) {
      clearTranslatedTitle();
      return;
    }
    await translateTitle(originalTitle);
  }

  /// Translate overview
  Future<void> translateOverview(String original) async {
    if (_overviewTranslated) {
      return; // Already translated
    }
    
    try {
      final translated = await _translator.translateTextForMoviesAndTV(original);
      setState(() {
        _overviewTranslated = true;
        _overviewText = translated;
      });
    } catch (e) {
      debugPrint('Error translating overview: $e');
    }
  }

  /// Get cached translation for a specific key
  String? getCachedTranslation(String key) => _translationCache[key];

  /// Check if a specific key is currently being translated
  bool isTranslatingKey(String key) => _translatingKeys.contains(key);

  /// Translate content and cache by key
  Future<String?> translateAndCache(String key, String content) async {
    if (_translationCache.containsKey(key)) {
      return _translationCache[key];
    }

    setState(() => _translatingKeys.add(key));
    try {
      final translated = await _translator.translateTextForMoviesAndTV(content);
      setState(() {
        _translationCache[key] = translated;
        _translatingKeys.remove(key);
      });
      return translated;
    } catch (e) {
      debugPrint('Error translating content for key $key: $e');
      setState(() => _translatingKeys.remove(key));
      return null;
    }
  }

  /// Remove cached translation for a specific key
  void clearCachedTranslation(String key) {
    setState(() => _translationCache.remove(key));
  }

  /// Toggle translation for a specific key
  Future<void> toggleCachedTranslation(String key, String originalContent) async {
    if (_translationCache.containsKey(key)) {
      clearCachedTranslation(key);
      return;
    }
    await translateAndCache(key, originalContent);
  }

  /// Reset translation state
  void resetTranslationState() {
    _translatedTitle = null;
    _isTranslating = false;
    _overviewTranslated = false;
    _translationCache.clear();
    _translatingKeys.clear();
  }
}
