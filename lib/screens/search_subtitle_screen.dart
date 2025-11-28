import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import '../models/subtitletranslator/opensubtitles_models.dart';
import '../models/subtitletranslator/subdl_models.dart';
import '../services/subdl_service.dart';
import '../services/opensubtitles_service.dart';
import '../utils/subtitle_parser.dart';
import 'subtitle_generation.dart.dart';

enum SubtitleSource { subdl, opensubtitles }

class SearchSubtitleScreen extends StatefulWidget {
  const SearchSubtitleScreen({super.key});

  @override
  State<SearchSubtitleScreen> createState() => _SearchSubtitleScreenState();
}

class _SearchSubtitleScreenState extends State<SearchSubtitleScreen> {
  SubtitleSource _selectedSource = SubtitleSource.subdl;
  bool _isSearching = false;
  bool _isDownloading = false;
  String? _errorMessage;

  // Search parameters
  final _searchController = TextEditingController();
  final _languagesController = TextEditingController(text: 'en');
  final _yearController = TextEditingController();
  final _seasonController = TextEditingController();
  final _episodeController = TextEditingController();
  String _selectedType = 'movie';

  // Search results
  List<SubDLSubtitle> _subdlResults = [];
  List<OpenSubtitlesSubtitleData> _opensubtitlesResults = [];

  @override
  void dispose() {
    _searchController.dispose();
    _languagesController.dispose();
    _yearController.dispose();
    _seasonController.dispose();
    _episodeController.dispose();
    super.dispose();
  }

  Future<void> _performSearch() async {
    if (_searchController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a search query';
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _errorMessage = null;
      _subdlResults = [];
      _opensubtitlesResults = [];
    });

    try {
      if (_selectedSource == SubtitleSource.subdl) {
        await _searchSubDL();
      } else {
        await _searchOpenSubtitles();
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Search failed: $e';
      });
    } finally {
      setState(() {
        _isSearching = false;
      });
    }
  }

  Future<void> _searchSubDL() async {
    final response = await SubDLService.searchSubtitles(
      filmName: _searchController.text.trim(),
      type: _selectedType,
      languages: _languagesController.text.trim(),
      year: _yearController.text.isNotEmpty
          ? int.tryParse(_yearController.text)
          : null,
      seasonNumber: _seasonController.text.isNotEmpty
          ? int.tryParse(_seasonController.text)
          : null,
      episodeNumber: _episodeController.text.isNotEmpty
          ? int.tryParse(_episodeController.text)
          : null,
    );

    setState(() {
      if (response.status && response.subtitles.isNotEmpty) {
        _subdlResults = response.subtitles;
      } else if (response.error != null) {
        _errorMessage = response.error;
      } else {
        _errorMessage = 'No subtitles found';
      }
    });
  }

  Future<void> _searchOpenSubtitles() async {
    final response = await OpenSubtitlesService.searchSubtitles(
      query: _searchController.text.trim(),
      languages: _languagesController.text.trim(),
      type: _selectedType,
      year: _yearController.text.isNotEmpty
          ? int.tryParse(_yearController.text)
          : null,
      seasonNumber:
          _seasonController.text.isNotEmpty ? _seasonController.text : null,
      episodeNumber:
          _episodeController.text.isNotEmpty ? _episodeController.text : null,
    );

    setState(() {
      if (response != null && response.data.isNotEmpty) {
        _opensubtitlesResults = response.data;
      } else {
        _errorMessage = 'No subtitles found';
      }
    });
  }

  Future<String> _getDownloadPath() async {
    if (Platform.isAndroid) {
      return '/storage/emulated/0/Download';
    } else if (Platform.isLinux) {
      final home = Platform.environment['HOME'] ?? '';
      return '$home/Downloads';
    } else {
      // For other platforms, let user choose
      final result = await FilePicker.platform.getDirectoryPath();
      return result ?? '';
    }
  }

  Future<void> _downloadSubDLSubtitle(SubDLSubtitle subtitle,
      {bool openInTranslate = false}) async {
    setState(() {
      _isDownloading = true;
      _errorMessage = null;
    });

    try {
      // Get download URL
      final downloadUrl = subtitle.downloadUrl ??
          SubDLService.constructDownloadUrl(subtitle.url ?? '');

      if (downloadUrl.isEmpty) {
        throw Exception('Download URL not available');
      }

      if (openInTranslate) {
        // Download subtitle content for translation view
        final content = await SubDLService.downloadSubtitle(downloadUrl);

        if (content == null || content.isEmpty) {
          throw Exception('Failed to download subtitle');
        }

        await _openInTranslatePage(content, subtitle.releaseName ?? 'subtitle');
      } else {
        // Directly download file
        await _saveSubtitleToFile(
          downloadUrl,
          subtitle.releaseName ?? 'subtitle',
          subtitle.language,
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Download failed: $e';
      });
    } finally {
      setState(() {
        _isDownloading = false;
      });
    }
  }

  Future<void> _downloadOpenSubtitlesSubtitle(
      OpenSubtitlesSubtitleData subtitle,
      {bool openInTranslate = false}) async {
    setState(() {
      _isDownloading = true;
      _errorMessage = null;
    });

    try {
      // Extract file ID from files object
      int? fileId;
      if (subtitle.attributes.files != null) {
        final files = subtitle.attributes.files!;
        for (var entry in files.entries) {
          if (entry.value is Map && entry.value['file_id'] != null) {
            fileId = entry.value['file_id'] as int?;
            break;
          }
        }
      }

      if (fileId == null) {
        throw Exception('File ID not found in subtitle data');
      }

      // Get download link
      final downloadResponse = await OpenSubtitlesService.download(fileId);

      if (downloadResponse == null || downloadResponse.link.isEmpty) {
        throw Exception('Failed to get download link');
      }

      if (openInTranslate) {
        final content = await OpenSubtitlesService.downloadSubtitleFile(
            downloadResponse.link);

        if (content == null || content.isEmpty) {
          throw Exception('Failed to download subtitle');
        }

        // Open in translate page
        await _openInTranslatePage(
            content, subtitle.attributes.release ?? 'subtitle');
      } else {
        // Directly download file
        await _saveSubtitleToFile(
          downloadResponse.link,
          subtitle.attributes.release ?? 'subtitle',
          subtitle.attributes.language,
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Download failed: $e';
      });
    } finally {
      setState(() {
        _isDownloading = false;
      });
    }
  }

  Future<void> _saveSubtitleToFile(
      String downloadUrl, String baseName, String? language) async {
    try {
      final downloadPath = await _getDownloadPath();

      if (downloadPath.isEmpty) {
        throw Exception('Download path not available');
      }

      final client = http.Client();
      try {
        final uri = Uri.parse(downloadUrl);
        final request = http.Request('GET', uri);
        final response = await client.send(request);

        if (response.statusCode != 200) {
          throw Exception(
              'Failed to download file (HTTP ${response.statusCode})');
        }

        final fileName = _resolveFileName(
          contentDisposition: response.headers['content-disposition'],
          uri: uri,
          baseName: baseName,
          language: language,
        );

        final filePath = '$downloadPath/$fileName';
        final file = File(filePath);
        final sink = file.openWrite();

        await response.stream.pipe(sink);
        await sink.close();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Subtitle saved to: $filePath'),
              duration: const Duration(seconds: 3),
              action: SnackBarAction(
                label: 'OK',
                onPressed: () {},
              ),
            ),
          );
        }
      } finally {
        client.close();
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to save file: $e';
      });
    }
  }

  String _resolveFileName({
    String? contentDisposition,
    required Uri uri,
    required String baseName,
    String? language,
  }) {
    final fromHeader = _fileNameFromContentDisposition(contentDisposition);
    if (fromHeader != null) {
      return fromHeader;
    }

    if (uri.pathSegments.isNotEmpty) {
      final lastSegment = uri.pathSegments.last;
      if (lastSegment.trim().isNotEmpty) {
        return _sanitizeFileName(lastSegment);
      }
    }

    final fallbackName =
        language != null && language.isNotEmpty ? '${baseName}_$language' : baseName;
    return _sanitizeFileName(fallbackName);
  }

  String? _fileNameFromContentDisposition(String? header) {
    if (header == null || header.isEmpty) {
      return null;
    }

    final filenameStarMatch = RegExp(r"filename\*=(?:UTF-8''|)([^;]+)",
            caseSensitive: false)
        .firstMatch(header);
    if (filenameStarMatch != null && filenameStarMatch.groupCount >= 1) {
      return _decodeAndSanitizeFileName(filenameStarMatch.group(1)!);
    }

    final filenameMatch =
        RegExp(r'filename="?([^";]+)"?', caseSensitive: false)
            .firstMatch(header);
    if (filenameMatch != null && filenameMatch.groupCount >= 1) {
      return _decodeAndSanitizeFileName(filenameMatch.group(1)!);
    }

    return null;
  }

  String _decodeAndSanitizeFileName(String value) {
    final cleaned = value.replaceAll('"', '').trim();
    try {
      return _sanitizeFileName(Uri.decodeFull(cleaned));
    } catch (_) {
      return _sanitizeFileName(cleaned);
    }
  }

  String _sanitizeFileName(String name) {
    final sanitized = name
        .trim()
        .replaceAll(RegExp(r'[\\/:*?"<>|]'), '_')
        .replaceAll(RegExp(r'\s+'), '_');
    return sanitized.isNotEmpty ? sanitized : 'subtitle_download';
  }

  Future<void> _openInTranslatePage(String content, String fileName) async {
    try {
      // Parse subtitle
      final subtitles = parseSubtitles(content);

      if (subtitles.isEmpty) {
        throw Exception('Failed to parse subtitle');
      }

      if (mounted) {
        // Navigate back to home and pass the subtitle data
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SubtitleGeneration(
              initialSubtitle: SubtitleFile(
                path: 'downloaded',
                fileName: fileName,
                subtitles: subtitles,
                isVttFormat: content.trim().startsWith('WEBVTT'),
              ),
            ),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to open in translate: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Subtitles'),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          // Source selector
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              border: Border(
                bottom: BorderSide(color: Colors.cyanAccent.withOpacity(0.3)),
              ),
            ),
            child: Row(
              children: [
                const Text(
                  'Source:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyanAccent,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SegmentedButton<SubtitleSource>(
                    segments: const [
                      ButtonSegment(
                        value: SubtitleSource.subdl,
                        label: Text('SubDL'),
                        icon: Icon(Icons.subtitles),
                      ),
                      ButtonSegment(
                        value: SubtitleSource.opensubtitles,
                        label: Text('OpenSubtitles'),
                        icon: Icon(Icons.cloud),
                      ),
                    ],
                    selected: {_selectedSource},
                    onSelectionChanged: (Set<SubtitleSource> newSelection) {
                      setState(() {
                        _selectedSource = newSelection.first;
                        _subdlResults = [];
                        _opensubtitlesResults = [];
                        _errorMessage = null;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          // Search form
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Search Query',
                    hintText: 'Enter movie/show name',
                    prefixIcon: const Icon(Icons.search, color: Colors.cyanAccent),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.cyanAccent.withOpacity(0.5)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.cyanAccent.withOpacity(0.3)),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.cyanAccent),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedType,
                        decoration: InputDecoration(
                          labelText: 'Type',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.cyanAccent.withOpacity(0.5)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.cyanAccent.withOpacity(0.3)),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'movie', child: Text('Movie')),
                          DropdownMenuItem(value: 'tv', child: Text('TV Show')),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedType = value;
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _languagesController,
                        decoration: InputDecoration(
                          labelText: 'Languages',
                          hintText: 'en,es',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.cyanAccent.withOpacity(0.5)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.cyanAccent.withOpacity(0.3)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _yearController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Year',
                          hintText: '2024',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.cyanAccent.withOpacity(0.5)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.cyanAccent.withOpacity(0.3)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _seasonController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Season',
                          hintText: '1',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.cyanAccent.withOpacity(0.5)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.cyanAccent.withOpacity(0.3)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _episodeController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Episode',
                          hintText: '1',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.cyanAccent.withOpacity(0.5)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.cyanAccent.withOpacity(0.3)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _isSearching ? null : _performSearch,
                  icon: _isSearching
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.search),
                  label: Text(_isSearching ? 'Searching...' : 'Search'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyanAccent,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ],
            ),
          ),

          // Error message
          if (_errorMessage != null)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                border: Border.all(color: Colors.red),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.red),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 16),

          // Results
          Expanded(
            child: _buildResultsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsList() {
    if (_isSearching) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_selectedSource == SubtitleSource.subdl) {
      if (_subdlResults.isEmpty) {
        return const Center(
          child: Text(
            'No results. Try searching above.',
            style: TextStyle(color: Colors.grey),
          ),
        );
      }

      return ListView.builder(
        itemCount: _subdlResults.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          final subtitle = _subdlResults[index];
          return _buildSubDLSubtitleCard(subtitle);
        },
      );
    } else {
      if (_opensubtitlesResults.isEmpty) {
        return const Center(
          child: Text(
            'No results. Try searching above.',
            style: TextStyle(color: Colors.grey),
          ),
        );
      }

      return ListView.builder(
        itemCount: _opensubtitlesResults.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          final subtitle = _opensubtitlesResults[index];
          return _buildOpenSubtitlesSubtitleCard(subtitle);
        },
      );
    }
  }

  Widget _buildSubDLSubtitleCard(SubDLSubtitle subtitle) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.cyanAccent.withOpacity(0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              subtitle.releaseName ?? 'Unknown',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.cyanAccent,
              ),
            ),
            const SizedBox(height: 8),
            if (subtitle.language != null)
              Row(
                children: [
                  const Icon(Icons.language, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    'Language: ${subtitle.language}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            if (subtitle.author != null)
              Row(
                children: [
                  const Icon(Icons.person, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    'Author: ${subtitle.author}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: _isDownloading
                      ? null
                      : () => _downloadSubDLSubtitle(subtitle,
                          openInTranslate: true),
                  icon: const Icon(Icons.translate, size: 16),
                  label: const Text('Open in Translate'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.purpleAccent,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _isDownloading
                      ? null
                      : () => _downloadSubDLSubtitle(subtitle),
                  icon: const Icon(Icons.download, size: 16),
                  label: const Text('Download'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyanAccent,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOpenSubtitlesSubtitleCard(OpenSubtitlesSubtitleData subtitle) {
    final attrs = subtitle.attributes;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.cyanAccent.withOpacity(0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              attrs.release ?? attrs.title ?? 'Unknown',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.cyanAccent,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.language, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  'Language: ${attrs.language}',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            if (attrs.uploader != null)
              Row(
                children: [
                  const Icon(Icons.person, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    'Uploader: ${attrs.uploader}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            if (attrs.downloadCount != null)
              Row(
                children: [
                  const Icon(Icons.cloud_download, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    'Downloads: ${attrs.downloadCount}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            if (attrs.ratings != null && attrs.ratings! > 0)
              Row(
                children: [
                  const Icon(Icons.star, size: 16, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text(
                    'Rating: ${attrs.ratings!.toStringAsFixed(1)}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: _isDownloading
                      ? null
                      : () => _downloadOpenSubtitlesSubtitle(subtitle,
                          openInTranslate: true),
                  icon: const Icon(Icons.translate, size: 16),
                  label: const Text('Open in Translate'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.purpleAccent,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _isDownloading
                      ? null
                      : () => _downloadOpenSubtitlesSubtitle(subtitle),
                  icon: const Icon(Icons.download, size: 16),
                  label: const Text('Download'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyanAccent,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
