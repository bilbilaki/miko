
import '../models/subtitletranslator/subtitle_item.dart';

List<SubtitleItem> parseSubtitles(String content) {
  // Detect if VTT format
  if (content.trim().startsWith('WEBVTT')) {
    return _parseVttSubtitles(content);
  } else {
    return _parseSrtSubtitles(content);
  }
}

List<SubtitleItem> _parseSrtSubtitles(String content) {
  final lines = content.split('\n');
  final items = <SubtitleItem>[];
  var i = 0;

  while (i < lines.length) {
    while (i < lines.length && lines[i].trim().isEmpty) {
      i++;
    }
    if (i >= lines.length) break;

    final number = int.tryParse(lines[i].trim()) ?? (items.length + 1);
    i++;

    if (i >= lines.length) break;

    final timeLine = lines[i].trim();
    final times = timeLine.split(' --> ');
    final startTime = times.isNotEmpty ? times.first : '';
    final endTime = times.length > 1 ? times[1] : '';
    i++;

    final subtitleBuffer = StringBuffer();
    while (i < lines.length && !RegExp(r'^\d+$').hasMatch(lines[i].trim())) {
      if (lines[i].trim().isNotEmpty) {
        subtitleBuffer.writeln(lines[i]);
      }
      i++;
    }

    items.add(SubtitleItem(
      number: number,
      startTime: startTime,
      endTime: endTime,
      content: subtitleBuffer.toString().trim(),
      isVttFormat: false,
    ));
  }

  return items;
}

List<SubtitleItem> _parseVttSubtitles(String content) {
  final lines = content.split('\n');
  final items = <SubtitleItem>[];
  var i = 0;

  // Skip WEBVTT header and metadata
  while (i < lines.length) {
    final line = lines[i].trim();
    if (line.isEmpty || line.startsWith('WEBVTT') || line.startsWith('NOTE')) {
      i++;
      continue;
    }
    // Check if line contains timestamp arrow
    if (line.contains('-->')) {
      break;
    }
    i++;
  }

  var itemNumber = 1;

  while (i < lines.length) {
    while (i < lines.length && lines[i].trim().isEmpty) {
      i++;
    }
    if (i >= lines.length) break;

    // VTT may have optional cue identifiers, skip them if not a timestamp
    var currentLine = lines[i].trim();
    if (!currentLine.contains('-->')) {
      i++;
      if (i >= lines.length) break;
      currentLine = lines[i].trim();
    }

    // Parse timestamp line
    final times = currentLine.split(' --> ');
    if (times.length < 2) {
      i++;
      continue;
    }

    final startTime = times[0].trim();
    final endTime = times[1].split(' ').first.trim(); // Remove any cue settings
    i++;

    // Parse content
    final subtitleBuffer = StringBuffer();
    while (i < lines.length && lines[i].trim().isNotEmpty && !lines[i].contains('-->')) {
      subtitleBuffer.writeln(lines[i]);
      i++;
    }

    items.add(SubtitleItem(
      number: itemNumber++,
      startTime: startTime,
      endTime: endTime,
      content: subtitleBuffer.toString().trim(),
      isVttFormat: true,
    ));
  }

  return items;
}
