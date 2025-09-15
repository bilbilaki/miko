import 'dart:convert';
import 'package:miko/models/transcribe.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TranscriptionCacheService {
  final SharedPreferences _prefs;
  static const String _prefix = 'transcript_';

  TranscriptionCacheService(this._prefs);

  String _getKey(String songId) => '$_prefix$songId';

  /// Save transcript for a song. Throws if saving fails.
  Future<void> saveTranscript(
    String songId,
    VerboseTranscription transcript,
  ) async {
    final key = _getKey(songId);

    // Convert to JSON string
    String jsonString;
    try {
      jsonString = jsonEncode(transcript.toJson());
    } catch (e) {
      // If serialization fails, rethrow as FormatException for caller to handle.
      throw FormatException('Failed to encode transcript to JSON: $e');
    }

    // Optional safeguard: avoid storing extremely large payloads in SharedPreferences.
    // Adjust the limit according to your app/platform constraints or remove this check.
    const int maxAllowedSize = 20 * 1024 * 1024; // 2 MB
    if (jsonString.length > maxAllowedSize) {
      // Either throw or handle differently (e.g., store in file/db). Here we throw.
      throw Exception(
        'Transcript JSON too large to store in SharedPreferences (${jsonString.length} bytes).',
      );
    }

    try {
      final success = await _prefs.setString(key, jsonString);
      if (!success) {
        throw Exception(
          'SharedPreferences.setString returned false for key $key',
        );
      }
    } catch (e) {
      // Propagate write errors
      rethrow;
    }
  }

  /// Load transcript for a song. Returns null when not present or on parsing error.
  Future<VerboseTranscription?> loadTranscript(String songId) async {
    final key = _getKey(songId);

    try {
      final jsonString = _prefs.getString(key);
      if (jsonString == null) return null;

      // Parse JSON safely
      final dynamic decoded = jsonDecode(jsonString);
      if (decoded is Map<String, dynamic>) {
        try {
          return VerboseTranscription.fromJson(decoded);
        } catch (e) {
          // If domain parsing fails, remove invalid entry and return null.
          await _prefs.remove(key);
          return null;
        }
      } else {
        // Invalid data type stored; clean up and return null.
        await _prefs.remove(key);
        return null;
      }
    } catch (e) {
      // On any unexpected error (decoding, prefs), try to remove the entry and return null.
      try {
        await _prefs.remove(key);
      } catch (_) {}
      return null;
    }
  }

  /// Delete cached transcript for a song.
  Future<void> deleteTranscript(String songId) async {
    final key = _getKey(songId);
    try {
      await _prefs.remove(key);
    } catch (e) {
      rethrow;
    }
  }
}
