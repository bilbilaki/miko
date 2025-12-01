import 'dart:io';

void main() {
  final filenames = [
    "Bakemonogatari  - (1).mkv",
    "Dungeon ni Deai wo Motomeru no S5 - (1).mkv",
    "Inu ni Nattara Suki na Hito ni Hirowareta  - (1).mkv",
    "One Punch Man 2nd Season  - (1).mkv",
    "Peter Grill to Kenja no Jikan  - (1).mkv",
    "Sora no Otoshimono Forte - (1).mkv",
    "[@AnimeGateOfficial] Ai Yori Aoshi Enishi - (1).mkv",
    "[@AnimeGateOfficial] Bad Girl - (1).mkv",
    "[@AnimeGateOfficial] Bokutachi wa Benkyou ga Dekinai Nagisa - (1).mkv",
    "[@AnimeGateOfficial] Chainsaw Man Recap - (1).mkv",
    "[@AnimeGateOfficial] Danjo no Yuujou wa Seiritsu suru - (1).mkv",
    "[@AnimeGateOfficial] Gorilla no Kami kara Kago sareta - (1).mkv",
    "[@AnimeGateOfficial] Guild no Uketsukejou desu ga Zangyou - (10).mkv",
    "[@AnimeGateOfficial] Haite Kudasai Takamine-san - (1).mkv",
    "[@AnimeGateOfficial] Inu ni Nattara Suki Specials - (1).mkv",
    "[@AnimeGateOfficial] Iya na Kao sare nagara Opantsu - (1).mkv",
    "[@AnimeGateOfficial] Kakushite Makina-san - (1).mkv",
    "[@AnimeGateOfficial] Kanojo, Okarishimasu 4th Season - (1).mkv",
    "[@AnimeGateOfficial] Lazarus - (1).mkv",
    "[@AnimeGateOfficial] Mayonaka Punch - (1).mkv",
    "[@AnimeGateOfficial] One Punch Man 3 - (0).mkv",
    "[@AnimeGateOfficial] Onmyou Kaiten ReBirth - (1).mkv",
    "[@AnimeGateOfficial] Sabage-bu - (1).mkv",
    "[@AnimeGateOfficial] Sawaranaide Kotesashi-kun - (1).mkv",
    "[@AnimeGateOfficial] Seishun Buta Yarou wa Randoseru Girl - (1).mkv",
    "[@AnimeGateOfficial] Shiunji-ke no Kodomotachi - (1).mkv",
    "[@AnimeGateOfficial] Tari Tari - (1).mkv",
    "[@AnimeGateOfficial] Tsuujou Kougeki OVA - (1).mkv",
    "[@AnimeGateOfficial] One Punch Man 3 - (7).mkv",
  ];

  for (final name in filenames) {
    final parsed = _parseMediaFromFilename(name);
    print("File: $name");
    print(
      "  -> Name: '${parsed.name}' | Season: ${parsed.season} | Episode: ${parsed.episode} | IsTV: ${parsed.isTv}",
    );
    print("------------------------------------------------");
  }
}

class _Parsed {
  final String name;
  final bool isTv;
  final int? season;
  final int? episode;
  final String? year;

  _Parsed({
    required this.name,
    required this.isTv,
    this.season,
    this.episode,
    this.year,
  });
}

_Parsed _parseMediaFromFilename(String filePath) {
  final fileName = filePath.split(Platform.pathSeparator).last;
  final noExt = fileName.replaceAll(RegExp(r'\.[^.]*$'), '');

  // Common TV patterns: S01E02, 1x02, Season 1 Episode 2, Ep 12
  final sxe = RegExp(r'[sS](\d{1,2})[ ._-]?[eE](\d{1,3})').firstMatch(noExt);
  final x = RegExp(r'(\d{1,2})x(\d{1,3})').firstMatch(noExt);

  // Year pattern
  final y = RegExp(r'(19|20)\d{2}').firstMatch(noExt);
  String? year = y?.group(0);

  bool isTv = false;
  int? season;
  int? episode;

  if (sxe != null) {
    isTv = true;
    season = int.tryParse(sxe.group(1)!);
    episode = int.tryParse(sxe.group(2)!);
  } else if (x != null) {
    isTv = true;
    season = int.tryParse(x.group(1)!);
    episode = int.tryParse(x.group(2)!);
  }

  // Try to extract season and episode using helper functions
  if (isTv && season == null) {
    final seasonStr = _extractSeason(filePath);
    if (seasonStr != null) {
      season = int.tryParse(seasonStr.replaceAll(RegExp(r'[^\d]'), ''));
    }
  }

  if (isTv && episode == null) {
    final episodeStr = _extractEpisodeNumber(filePath);
    if (episodeStr != null) {
      episode = int.tryParse(episodeStr.replaceAll(RegExp(r'[^\d]'), ''));
    }
  }

  // NEW LOGIC START: Check for " - (1)" pattern if not found yet
  if (episode == null) {
    final parenMatch = RegExp(r' - \((\d+)\)').firstMatch(noExt);
    if (parenMatch != null) {
      episode = int.tryParse(parenMatch.group(1)!);
      isTv = true; // Assume TV if it has this pattern
    }
  }
  // NEW LOGIC END

  // Try to extract a clean title by removing common tokens
  var name = noExt
      .replaceAll(RegExp(r'[._]'), ' ')
      .replaceAll(
        RegExp(
          r'\b(1080p|720p|480p|x264|x265|Bluray|WEBRip|WEB-DL|HEVC|H264|H265|AAC|DVDRip)\b',
          caseSensitive: false,
        ),
        '',
      )
      .replaceAll(
        RegExp(r'[\[\(].*?[\]\)]'),
        '',
      ) // This removes [Group] and (1)
      .trim();

  // Remove season/episode tokens from name
  name = name
      .replaceAll(RegExp(r'[sS](\d{1,2})[ ._-]?[eE](\d{1,3})'), '')
      .replaceAll(RegExp(r'(\d{1,2})x(\d{1,3})'), '')
      .trim();

  // If year exists, keep it separate and remove from name tail
  if (year != null) {
    name = name.replaceAll(year, '').trim();
  }

  // Collapse multiple spaces
  name = name.replaceAll(RegExp(r'\s+'), ' ').trim();

  // NEW LOGIC: Extract season from name if present (e.g. "S5", "2nd Season")
  if (isTv && season == null) {
    // Check for "S5" or "Season 5" or "5th Season" in the original filename (noExt)
    // We use noExt because 'name' has been stripped of brackets

    // "S5" surrounded by spaces or end of string
    final sMatch = RegExp(
      r'\bS(\d+)\b',
      caseSensitive: false,
    ).firstMatch(noExt);
    if (sMatch != null) {
      season = int.tryParse(sMatch.group(1)!);
      // Remove S5 from name
      name = name
          .replaceAll(RegExp(r'\bS\d+\b', caseSensitive: false), '')
          .trim();
    }

    // "2nd Season", "Season 2"
    final seasonMatch = RegExp(
      r'\b(?:Season\s*(\d+)|(\d+)(?:st|nd|rd|th)?\s*Season)\b',
      caseSensitive: false,
    ).firstMatch(noExt);
    if (seasonMatch != null) {
      final sNum = seasonMatch.group(1) ?? seasonMatch.group(2);
      if (sNum != null) {
        season = int.tryParse(sNum);
        // Remove "2nd Season" from name
        // Note: 'name' variable already had brackets removed, so "One Punch Man 2nd Season" -> "One Punch Man 2nd Season"
        // But we need to be careful about what we remove.
        // Let's re-clean name based on what we found.
      }
    }
  }

  // Clean up name again for Season stuff
  name = name.replaceAll(RegExp(r'\bS(\d+)\b', caseSensitive: false), '');
  name = name.replaceAll(
    RegExp(
      r'\b(?:Season\s*\d+|\d+(?:st|nd|rd|th)?\s*Season)\b',
      caseSensitive: false,
    ),
    '',
  );

  name = name
      .replaceAll(RegExp(r'-+$'), '')
      .trim(); // Remove trailing hyphens first

  // NEW LOGIC: Check for "Name N" where N is a number at the end, treating it as season
  if (isTv && season == null) {
    final endNumberMatch = RegExp(r'\s+(\d+)$').firstMatch(name);
    if (endNumberMatch != null) {
      season = int.tryParse(endNumberMatch.group(1)!);
      name = name.substring(0, endNumberMatch.start).trim();
    }
  }

  name = name.replaceAll(RegExp(r'\s+'), ' ').trim();

  return _Parsed(
    name: name,
    isTv: isTv,
    season: season,
    episode: episode,
    year: year,
  );
}

String? _extractSeason(String url) {
  final match = RegExp(r'/S(\d+)/', caseSensitive: false).firstMatch(url);
  if (match != null) {
    return 'S${int.parse(match.group(1)!).toString().padLeft(2, '0')}';
  }
  return null;
}

String? _extractEpisodeNumber(String url) {
  final filename = url.split('/').last;
  RegExpMatch? match;

  match = RegExp(r'S\d+E(\d+)', caseSensitive: false).firstMatch(filename);
  if (match != null) {
    return 'E${int.parse(match.group(1)!).toString().padLeft(2, '0')}';
  }

  match = RegExp(
    r'Ep(?:isode)?\.?(\d+)',
    caseSensitive: false,
  ).firstMatch(filename);
  if (match != null) {
    return 'E${int.parse(match.group(1)!).toString().padLeft(2, '0')}';
  }

  match = RegExp(r'(?<!\d)(?<!p)[._-](\d{2,3})[._-]').firstMatch(filename);
  if (match != null) {
    return 'E${int.parse(match.group(1)!).toString().padLeft(2, '0')}';
  }

  match = RegExp(r'\.(\d{2,3})\.').firstMatch(filename);
  if (match != null && !_isQualityString(match.group(0)!)) {
    return 'E${int.parse(match.group(1)!).toString().padLeft(2, '0')}';
  }

  return null;
}

bool _isQualityString(String text) => RegExp(r'\d+p').hasMatch(text);
