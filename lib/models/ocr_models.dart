import 'dart:io';

// Enum to track the status of each task in the queue
enum TaskStatus { queued, processing, success, failed }

// Represents a single OCR task in the processing queue
class OcrTask {
  final String id;
  final File file;
  TaskStatus status;
  String? ocrResultText;
  String? errorMessage;

  OcrTask({
    required this.id,
    required this.file,
    this.status = TaskStatus.queued,
    this.ocrResultText,
    this.errorMessage,
  });
}

// Represents a completed task in the history
class OcrHistoryItem {
  final String id;
  final String inputFileName;
  final String outputText;
  final DateTime timestamp;
  final bool wasSuccessful;

  OcrHistoryItem({
    required this.id,
    required this.inputFileName,
    required this.outputText,
    required this.timestamp,
    required this.wasSuccessful,
  });
}

// Models for the Mistral API Request/Response
// Based on the excellent models you provided

class OcrRequest {
  final String model;
  final Map<String, String> document;
  final bool includeImageBase64;

  OcrRequest({
    this.model = 'mistral-ocr-latest',
    required this.document,
    this.includeImageBase64 = true,
  });

  Map<String, dynamic> toJson() => {
        'model': model,
        'document': document,
        'include_image_base64': includeImageBase64,
      };
}

class OcrResponse {
  final List<OcrPage> pages;

  OcrResponse({required this.pages});

  factory OcrResponse.fromJson(Map<String, dynamic> json) {
    return OcrResponse(
      pages: (json['pages'] as List)
          .map((p) => OcrPage.fromJson(p as Map<String, dynamic>))
          .toList(),
    );
  }

  // Helper to get all markdown text combined
  String get fullMarkdownText => pages.map((p) => p.markdown).join('\n\n---\n\n');
}

class OcrPage {
  final int index;
  final String markdown;
  // Other fields like images, dimensions can be added here if needed

  OcrPage({required this.index, required this.markdown});

  factory OcrPage.fromJson(Map<String, dynamic> json) {
    return OcrPage(
      index: json['index'],
      markdown: json['markdown'],
    );
  }
}