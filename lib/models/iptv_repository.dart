import 'package:flutter/services.dart';
import '/models/channel.dart';

class IptvRepository {
  // Load M3U playlist from local assets
  Future<List<Channel>> fetchChannels() async {
    try {
      final content = await rootBundle.loadString('assets/index.m3u');
      return _parseM3u(content);
    } catch (e) {
      // In a real app, handle this error more gracefully
      print('Error loading channels: $e');
      rethrow;
    }
  }

  // A simple M3U parser. For production, you might want a more robust one.
  List<Channel> _parseM3u(String content) {
    final List<Channel> channels = [];
    final lines = content.split('\n');

    for (int i = 0; i < lines.length; i++) {
      if (lines[i].startsWith('#EXTINF:')) {
        // Find the next line which should be the stream URL
        if (i + 1 < lines.length && (lines[i+1].startsWith('http') || lines[i+1].startsWith('https'))) {
          final infoLine = lines[i];
          final urlLine = lines[i + 1];

          final name = infoLine.split(',').last.trim();
          final logo = _getTagValue(infoLine, 'tvg-logo');
          final category = _getTagValue(infoLine, 'group-title');
          final id = _getTagValue(infoLine, 'tvg-id');
          
          // These are often not in standard M3U, so we'll mock them for now
          // In a real scenario, your M3U would need to provide this data.
          final country = _getCountryFromId(id) ?? 'Unknown';
          final language = 'English'; // Placeholder
          final subdivision = 'General'; // Placeholder

          channels.add(
            Channel(
              id: id.isNotEmpty ? id : name, // Use name as fallback ID
              name: name,
              logoUrl: logo,
              streamUrl: urlLine.trim(),
              category: category.isNotEmpty ? category : 'Uncategorized',
              language: language,
              country: country,
              subdivision: subdivision,
            ),
          );
        }
      }
    }
    return channels;
  }

  String _getTagValue(String line, String tagName) {
    final regex = RegExp('$tagName="(.*?)"');
    final match = regex.firstMatch(line);
    return match?.group(1) ?? '';
  }

  String? _getCountryFromId(String id) {
    if (id.contains('.')) {
      final parts = id.split('.');
      if (parts.length > 1) {
        // e.g., Channel1.us -> US
        return parts.last.toUpperCase();
      }
    }
    // You could add more complex logic here based on your M3U source
    return null;
  }
}