import 'package:flutter/material.dart';

class FloatingButtonVisibilityNotifier extends ChangeNotifier {
  bool _isVisible = true; // Default to visible

  bool get isVisible => _isVisible;

  void show() {
    if (!_isVisible) {
      _isVisible = true;
      notifyListeners(); // Notify widgets that are listening
    }
  }

  void hide() {
    if (_isVisible) {
      _isVisible = false;
      notifyListeners(); // Notify widgets that are listening
    }
  }
}