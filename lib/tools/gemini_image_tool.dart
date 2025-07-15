// lib/tools/gemini_image_tool.dart

import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart'; // For lookupMimeType

// IMPORTANT: Replace with your actual Google Gemini API Key
const String geminiApiKey = 'YOUR_GEMINI_API_KEY';
const String geminiBaseUrl = 'https://generativelanguage.googleapis.com';

/// Represents the result of an image analysis.
class ImageAnalysisResult {
  final String textContent;
  final String? error;

  ImageAnalysisResult({required this.textContent, this.error});

  Map<String, dynamic> toJson() => {
        'textContent': textContent,
        if (error != null) 'error': error,
      };
}

/// Uploads an image to Gemini's file API and returns its file URI.
Future<String?> _uploadImageToGemini(Uint8List imageBytes, String mimeType, String displayName) async {
  final uploadUrl = Uri.parse('$geminiBaseUrl/upload/v1beta/files?key=$geminiApiKey');

  // Step 1: Start the resumable upload
  final startResponse = await http.post(
    uploadUrl,
    headers: {
      'X-Goog-Upload-Protocol': 'resumable',
      'X-Goog-Upload-Command': 'start',
      'X-Goog-Upload-Header-Content-Length': imageBytes.length.toString(),
      'X-Goog-Upload-Header-Content-Type': mimeType,
      'Content-Type': 'application/json',
    },
    body: json.encode({'file': {'display_name': displayName}}),
  );

  if (startResponse.statusCode != 200) {
    print('Failed to start Gemini upload: ${startResponse.statusCode} - ${startResponse.body}');
    return null;
  }

  final String? resumableUploadUrl = startResponse.headers['x-goog-upload-url'];
  if (resumableUploadUrl == null) {
    print('No x-goog-upload-url found in start response headers.');
    return null;
  }
  print('Resumable Upload URL: $resumableUploadUrl');

  // Step 2: Upload the actual bytes
  final uploadBytesResponse = await http.post(
    Uri.parse(resumableUploadUrl),
    headers: {
      'Content-Length': imageBytes.length.toString(),
      'X-Goog-Upload-Offset': '0',
      'X-Goog-Upload-Command': 'upload, finalize',
      'Content-Type': mimeType, // Important: Use the actual MIME type here
    },
    body: imageBytes,
  );

  if (uploadBytesResponse.statusCode != 200) {
    print('Failed to upload image bytes to Gemini: ${uploadBytesResponse.statusCode} - ${uploadBytesResponse.body}');
    return null;
  }

  final Map<String, dynamic> uploadResult = json.decode(uploadBytesResponse.body);
  final String? fileUri = uploadResult['file']?['uri'];

  if (fileUri == null) {
    print('No file URI found in upload result: $uploadResult');
  } else {
    print('Gemini File URI: $fileUri');
  }
  return fileUri;
}

/// Analyzes an image with Gemini, given image bytes and a query.
///
/// This function is designed to be called by your OpenAI model.
/// It takes image data directly, rather than a path, for better flexibility
/// within the tool calling context (as the OpenAI model won't know local paths).
///
/// Returns a Map containing the text content from Gemini or an error message.
Future<Map<String, dynamic>> analyzeImageWithGemini(Uint8List imageBytes, String query) async {
  try {
    print('Tool Called: analyzeImageWithGemini with query: "$query"');

    final String? mimeType = lookupMimeType('', headerBytes: imageBytes.sublist(0, 12)); // Guess MIME type from first few bytes
    if (mimeType == null) {
      return {'error': 'Could not determine MIME type of the image.'};
    }
    print('Detected MIME Type: $mimeType');

    // For display name, you might want to generate a unique name or use part of the query
    final String displayName = 'image_for_query_${DateTime.now().millisecondsSinceEpoch}';

    final String? fileUri = await _uploadImageToGemini(imageBytes, mimeType, displayName);

    if (fileUri == null) {
      return {'error': 'Failed to upload image to Gemini.'};
    }

    // Now generate content using that file URI
    final generateContentUrl = Uri.parse('$geminiBaseUrl/v1beta/models/gemini-1.5-flash:generateContent?key=$geminiApiKey');
    final generateContentHeaders = {
      'Content-Type': 'application/json',
    };
    final generateContentBody = json.encode({
      'contents': [
        {
          'parts': [
            {'text': query},
            {
              'file_data': {'mime_type': mimeType, 'file_uri': fileUri}
            }
          ]
        }
      ]
    });

    final generateContentResponse = await http.post(
      generateContentUrl,
      headers: generateContentHeaders,
      body: generateContentBody,
    );

    if (generateContentResponse.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(generateContentResponse.body);
      print('Gemini Generate Content Raw Response: $responseData');

      // Extract the text content from Gemini's response
      final List<dynamic>? candidates = responseData['candidates'];
      if (candidates != null && candidates.isNotEmpty) {
        final List<dynamic>? parts = candidates[0]['content']?['parts'];
        if (parts != null && parts.isNotEmpty) {
          final String? text = parts[0]?['text'];
          if (text != null) {
            return {'textContent': text};
          }
        }
      }
      return {'error': 'Gemini response did not contain expected text content.'};
    } else {
      print('Error calling Gemini Generate Content API: ${generateContentResponse.statusCode} - ${generateContentResponse.body}');
      return {'error': 'Failed to analyze image with Gemini: ${generateContentResponse.statusCode} - ${generateContentResponse.body}'};
    }
  } catch (e) {
    print('Exception during Gemini image analysis: $e');
    return {'error': 'An unexpected error occurred during Gemini image analysis: $e'};
  }
}