import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:miko/configs/consts2.dart';
import 'package:miko/models/transcribe.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;
import 'package:mime/mime.dart';

/// Requires:
/// - appSettings.gptApiKey
/// - appSettings.baseUrl
///
/// Example usage:
/// final svc = TranscriptionService();
/// final resp = await svc.transcribeFile(file);
/// final stream = svc.streamTranscribeFile(file);
class TranscriptionService {
  final http.Client _client;

  TranscriptionService({http.Client? client})
    : _client = client ?? http.Client();

  Uri _endpoint() {
    final base = kApiBaseUrl; // provided environment value
    return Uri.parse('$base/audio/transcriptions');
  }

  Map<String, String> _authHeaders() {
    return {
      'Authorization': 'Bearer $kApiKey',
      // Note: MultipartRequest will set the multipart Content-Type
    };
  }

  /// Non-streaming transcription. Returns final TranscriptionResponse.
  Future<TranscriptionResponse> transcribeFile(
    File file, {
    String model = 'gpt-4o-transcribe',
    Map<String, String>? extraFields,
  }) async {
    final uri = _endpoint();
    final request = http.MultipartRequest('POST', uri);
    request.headers.addAll(_authHeaders());
    request.files.add(await http.MultipartFile.fromPath('file', file.path));
    request.fields['model'] = model;
    if (extraFields != null) request.fields.addAll(extraFields);

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final Map<String, dynamic> jsonResp = json.decode(response.body);
      return TranscriptionResponse.fromJson(jsonResp);
    } else {
      throw HttpException(
        'Transcription failed: ${response.statusCode} ${response.reasonPhrase} - ${response.body}',
      );
    }
  }

  /// Streaming transcription. Yields TranscriptDelta events as they arrive.
  /// The server returns newline-delimited "data: {...}" messages.
  Stream<TranscriptDelta> streamTranscribeFile(
    File file, {
    String model = 'gpt-4o-mini-transcribe',
    bool stream = true,
    Map<String, String>? extraFields,
  }) async* {
    final uri = _endpoint();
    final request = http.MultipartRequest('POST', uri);
    request.headers.addAll(_authHeaders());
    request.files.add(await http.MultipartFile.fromPath('file', file.path));
    request.fields['model'] = model;
    request.fields['stream'] = stream ? 'true' : 'false';
    if (extraFields != null) request.fields.addAll(extraFields);

    final streamedResponse = await request.send();

    final byteStream = streamedResponse.stream;
    final utf8Stream = byteStream.transform(utf8.decoder);
    final lineStream = utf8Stream.transform(const LineSplitter());

    await for (final rawLine in lineStream) {
      // OpenAI streaming often prefixes lines with "data: " and may send blank lines.
      final line = rawLine.trim();
      if (line.isEmpty) continue;

      // Some servers send "data: [DONE]" or "data: [done]" or just "[DONE]".
      // Handle common forms.
      String parsed = line;
      if (parsed.startsWith('data:')) {
        parsed = parsed.substring(5).trim();
      }

      if (parsed.isEmpty) continue;
      if (parsed == '[DONE]' || parsed == '[done]') {
        // optionally yield a done delta
        yield TranscriptDelta(
          type: 'transcript.text.done',
          text: '',
          raw: {'done': true},
        );
        continue;
      }

      try {
        final Map<String, dynamic> jsonData = json.decode(parsed);
        final delta = TranscriptDelta.fromJson(jsonData);
        yield delta;
      } catch (e) {
        // If a line isn't valid JSON, skip or yield as a raw message.
        // Yield a raw delta to not lose data
        yield TranscriptDelta(
          type: 'unknown',
          delta: parsed,
          raw: {'raw': parsed},
        );
      }
    }
  }

  Future<dynamic> transcribe({
    required File file,
    String model = 'whisper-1',
    String responseFormat = 'verbose_json',
    List<String>? timestampGranularities,
    bool includeLogprobs = false,
  }) async {
    final uri = _endpoint();
    final request = http.MultipartRequest('POST', uri);

    request.headers.addAll({
      'Authorization': 'Bearer $kApiKey',
    });

    final fileName = path.basename(file.path);
    final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';
    final mimeParts = mimeType.split('/');
    final multipartFile = await http.MultipartFile.fromPath(
      'file',
      file.path,
      filename: fileName,
      contentType: mimeParts.length == 2
          ? MediaType(mimeParts[0], mimeParts[1])
          : MediaType('application', 'octet-stream'),
    );

    request.files.add(multipartFile);
    request.fields['model'] = model;
    request.fields['response_format'] = responseFormat;

    if (timestampGranularities != null && timestampGranularities.isNotEmpty) {
      // Some servers accept repeated field names. MultipartRequest.fields is a map,
      // so for simplicity we supply comma-separated value which server should handle if supported.
      request.fields['timestamp_granularities'] = timestampGranularities.join(
        ',',
      );
    }

    if (includeLogprobs) {
      request.fields['include'] = 'logprobs';
    }

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final body = response.body;
      try {
        final json = jsonDecode(body);
        if (json is Map<String, dynamic>) {
          if (json.containsKey('task') ||
              json.containsKey('segments') ||
              json.containsKey('words')) {
            return VerboseTranscription.fromJson(json);
          } else if (json.containsKey('text')) {
            return SimpleTranscription.fromJson(json);
          } else {
            return json;
          }
        } else {
          return json;
        }
      } catch (e) {
        return body;
      }
    } else {
      String message = response.body;
      try {
        final json = jsonDecode(response.body);
        message = json.toString();
      } catch (_) {}
      throw HttpException(
        'Transcription failed: ${response.statusCode} - $message',
      );
    }
  }

  void dispose() {
    _client.close();
  }
}
