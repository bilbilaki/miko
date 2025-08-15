// lib/canvas/canvas_result.dart
import 'package:flutter/foundation.dart';

enum CanvasPartType { quill, math, json, code }

@immutable
class CanvasPart {
  const CanvasPart({
    required this.type,
    required this.title,
    required this.text,
  });

  final CanvasPartType type;
  final String title; // e.g. 'Canvas:Quill'
  final String text;
}

@immutable
class CanvasResult {
  const CanvasResult({required this.parts});
  final List<CanvasPart> parts;
}