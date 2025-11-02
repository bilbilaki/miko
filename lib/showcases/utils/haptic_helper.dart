import 'dart:io';
import 'package:flutter/services.dart';

/// Helper class for haptic feedback
class HapticHelper {
  /// Perform light haptic feedback (Android only)
  static void performHapticFeedback() {
    if (Platform.isAndroid) {
      HapticFeedback.lightImpact();
    }
  }

  /// Perform selection click feedback (Android only)
  static void performSelectionClick() {
    if (Platform.isAndroid) {
      HapticFeedback.selectionClick();
    }
  }

  /// Perform medium haptic feedback
  static void performMediumImpact() {
    if (Platform.isAndroid) {
      HapticFeedback.mediumImpact();
    }
  }

  /// Perform heavy haptic feedback
  static void performHeavyImpact() {
    if (Platform.isAndroid) {
      HapticFeedback.heavyImpact();
    }
  }
}
