// lib/utils/file_utils.dart
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

String sanitizeFileName(String input, {String replacement = '_'}) {
  final illegal = RegExp(r'[\\/:*?"<>|]+');
  final cleaned = input.replaceAll(illegal, replacement).trim();
  return cleaned.isEmpty ? 'file' : cleaned;
}

String? _parseRfc5987Value(String input) {
  // Example: filename*=UTF-8''%e2%82%ac%20rates.mp3
  final match = RegExp(
    r"(?i)filename\*\s*=\s*([^']*)'[^']*'(.+)",
  ).firstMatch(input);
  if (match != null) {
    final charset = match.group(1) ?? 'UTF-8';
    final encoded = match.group(2) ?? '';
    try {
      final bytes = Uri.decodeFull(encoded);
      final data = bytes.codeUnits;
      if (charset.toUpperCase() == 'UTF-8') {
        return sanitizeFileName(utf8.decode(data));
      }
      // Fallback: still return decoded percent-encoding
      return sanitizeFileName(bytes);
    } catch (_) {
      return null;
    }
  }
  return null;
}

String? _parseQuotedFilename(String input) {
  // filename="my file.mp3" or filename=myfile.mp3
  final matchQuoted = RegExp(r'(?i)filename\s*=\s*"([^"]+)"').firstMatch(input);
  if (matchQuoted != null) return sanitizeFileName(matchQuoted.group(1)!);

  final matchBare = RegExp(r'(?i)filename\s*=\s*([^;]+)').firstMatch(input);
  if (matchBare != null) return sanitizeFileName(matchBare.group(1)!.trim());
  return null;
}

String extractFilenameFromHeaders(
  Map<String, List<String>> headers,
  String fallbackUrl,
) {
  // Try Content-Disposition
  final cdKey = headers.keys.firstWhere(
    (k) => k.toLowerCase() == 'content-disposition',
    orElse: () => '',
  );
  if (cdKey.isNotEmpty) {
    final values = headers[cdKey] ?? const [];
    for (final v in values) {
      final rfc = _parseRfc5987Value(v);
      if (rfc != null && rfc.isNotEmpty) return rfc;
      final quoted = _parseQuotedFilename(v);
      if (quoted != null && quoted.isNotEmpty) return quoted;
    }
  }

  // Fallback to URL last segment
  final uri = Uri.tryParse(fallbackUrl);
  final segment = uri?.pathSegments.isNotEmpty == true
      ? uri!.pathSegments.last
      : 'file';
  final cleaned = sanitizeFileName(segment);
  return cleaned.isEmpty ? 'file' : cleaned;
}

Future<String> ensureUniqueFilePath(String directory, String filename) async {
  await Directory(directory).create(recursive: true);
  final base = p.basenameWithoutExtension(filename);
  final ext = p.extension(filename);
  var candidate = p.join(directory, filename);
  var count = 1;
  while (await File(candidate).exists()) {
    candidate = p.join(directory, '$base ($count)$ext');
    count++;
  }
  return candidate;
}

String formatBytes(int bytes) {
  const units = ['B', 'KB', 'MB', 'GB', 'TB'];
  double v = bytes.toDouble();
  int i = 0;
  while (v >= 1024 && i < units.length - 1) {
    v /= 1024;
    i++;
  }
  return '${v.toStringAsFixed(v < 10 && i > 0 ? 1 : 0)} ${units[i]}';
}

String formatSpeed(double bps) {
  if (bps.isNaN || bps.isInfinite) return '0 B/s';
  return '${formatBytes(bps.round())}/s';
}

String formatEta({
  required int? totalBytes,
  required int downloadedBytes,
  required double speedBps,
}) {
  if (totalBytes == null || totalBytes <= 0 || speedBps <= 0) return '--';
  final remaining = totalBytes - downloadedBytes;
  final seconds = (remaining / speedBps).clamp(0, 86400 * 7).round();
  final h = seconds ~/ 3600;
  final m = (seconds % 3600) ~/ 60;
  final s = seconds % 60;
  if (h > 0) return '${h}h ${m}m';
  if (m > 0) return '${m}m ${s}s';
  return '${s}s';
}

Future<String> getDefaultBaseDir() async {
  if (kIsWeb) {
    throw UnsupportedError('Web not supported for file downloads here.');
  }
  if (Platform.isAndroid) {
    final dir = await getExternalStorageDirectory();
    return dir?.path ?? (await getApplicationDocumentsDirectory()).path;
  } else if (Platform.isLinux) {
    final dir = await getApplicationSupportDirectory();
    return p.join(dir.path, 'downloads');
  } else if (Platform.isWindows || Platform.isMacOS) {
    final dir =
        await getDownloadsDirectory() ??
        await getApplicationDocumentsDirectory();
    return dir.path;
  } else if (Platform.isIOS) {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }
  final dir = await getApplicationDocumentsDirectory();
  return dir.path;
}

Future<String?> tryHeadForFilename(
  Dio dio,
  String url, {
  Map<String, String>? headers,
}) async {
  try {
    final resp = await dio.head(
      url,
      options: Options(
        headers: headers,
        followRedirects: true,
        validateStatus: (s) => s != null && s < 400,
      ),
    );
    final headerMap = resp.headers.map.map((k, v) => MapEntry(k, v));
    return extractFilenameFromHeaders(headerMap, url);
  } catch (_) {
    return null;
  }
}

extension DownloadTaskSuggest on RequestOptions {
  // Utility to clone headers map to String->String
  Map<String, String> get stringHeaders {
    final out = <String, String>{};
    headers.forEach((k, v) {
      out[k] = v is List && v.isNotEmpty ? v.first.toString() : v.toString();
    });
    return out;
  }
}
