import 'package:flutter/material.dart';
import 'package:miko/utils/ai_translator.dart';

/// Mixin providing translation functionality for movie and TV show titles and overviews
mixin TranslationMixin<T extends StatefulWidget> on State<T> {
  String? _translatedTitle;
  bool _isTranslating = false;
  final MovieTvTranslator _translator = MovieTvTranslator();
  bool _overviewTranslated = false;
  String _overviewText = '';

  String? get translatedTitle => _translatedTitle;
  bool get isTranslating => _isTranslating;
  String get overviewText => _overviewText;

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

  /// Reset translation state
  void resetTranslationState() {
    _translatedTitle = null;
    _isTranslating = false;
    _overviewTranslated = false;
  }
}
