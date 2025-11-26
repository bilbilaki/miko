import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:miko/screens/video_player_wplaylist_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
// Import your existing VideoPlayerScreen

class StreamPlayerPage extends StatefulWidget {
  const StreamPlayerPage({super.key});

  @override
  State<StreamPlayerPage> createState() => _StreamPlayerPageState();
}

class _StreamPlayerPageState extends State<StreamPlayerPage> {
  final TextEditingController _urlController = TextEditingController();
    final TextEditingController _audioController = TextEditingController();

  final TextEditingController _subtitleController = TextEditingController();

  bool _isLoading = false;
  List<StreamUrl> _savedUrls = [];

  @override
  void initState() {
    super.initState();
    _loadSavedUrls();
  }

  Future<void> _loadSavedUrls() async {
    final prefs = await SharedPreferences.getInstance();
    final urlsJson = prefs.getStringList('saved_streams') ?? [];
    setState(() {
      _savedUrls = urlsJson
          .map((json) => StreamUrl.fromJson(jsonDecode(json)))
          .toList();
    });
  }

  Future<void> _saveUrls(List<StreamUrl> urls) async {
    final prefs = await SharedPreferences.getInstance();
    final urlsJson = urls.map((u) => jsonEncode(u.toJson())).toList();
    await prefs.setStringList('saved_streams', urlsJson);
    await _loadSavedUrls();  // Refresh list
  }

  Future<void> _playStream(String url, String? subtitle, String? audio) async {
    if (url.isEmpty) {
      _showSnackbar('Please enter a valid URL');
      return;
    }

    setState(() => _isLoading = true);

    // Derive videoName from URL (e.g., filename or fallback)
    String videoName = 'External Stream';
    try {
      final uri = Uri.parse(url);
      if (uri.pathSegments.isNotEmpty) {
        final lastSegment = uri.pathSegments.last;
        if (lastSegment.contains('.')) {
          videoName = lastSegment;
        }
      }
    } catch (e) {
      // Ignore parsing errors
    }

    // Navigate to your existing VideoPlayerScreen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VideoPlayerScreen(
          videoName: videoName,
          source: 'network', 
          videoUrl: url,
           exterSubtitle: subtitle,
           exterAudio: audio,
        ),
      ),
    );

    setState(() => _isLoading = false);
    _showSnackbar('Opening in player...');
  }

  Future<void> _saveCurrentUrl() async {
    final url = _urlController.text.trim();
    if (url.isEmpty) {
      _showSnackbar('No URL to save');
      return;
    }

    // Parse for batch (comma-separated)
    final urls = url.split(',').map((u) => u.trim()).where((u) => u.isNotEmpty);
    final newUrls = urls.map((u) => StreamUrl(
      url: u,
      title: _urlController.text.trim().isNotEmpty && urls.length == 1 
          ? _urlController.text.trim() 
          : 'Saved Stream',  // Use input as title for single URL
    )).toList();

    // Avoid duplicates (simple check by URL)
    final existingUrls = _savedUrls.map((s) => s.url).toSet();
    final filteredNewUrls = newUrls.where((newUrl) => !existingUrls.contains(newUrl.url)).toList();
    final updatedUrls = [..._savedUrls, ...filteredNewUrls];

    await _saveUrls(updatedUrls);
    _showSnackbar('${filteredNewUrls.length} URL(s) saved');
  }

  void _deleteSavedUrl(int index) {
    setState(() {
      _savedUrls.removeAt(index);
    });
    _saveUrls(_savedUrls);
    _showSnackbar('URL removed');
  }

  void _pasteUrl() {
    Clipboard.getData(Clipboard.kTextPlain).then((data) {
      if (data != null && data.text != null) {
        _urlController.text = data.text!.trim();
        _showSnackbar('URL pasted');
      }
    });
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stream Player'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.paste),
            onPressed: _pasteUrl,
            tooltip: 'Paste URL',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Central URL Input
            const SizedBox(height: 40),
            Icon(
              Icons.play_circle_outline,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            const Text(
              'Enter Stream URL',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _urlController,
              decoration: InputDecoration(
                hintText: 'Paste video/audio stream URL (e.g., .mp4, .m3u8)',
                prefixIcon: Icon(Icons.link, color: Theme.of(context).colorScheme.primary),
                suffixIcon: IconButton(onPressed: () async { final fi = await FilePicker.platform.pickFiles(type: FileType.any );
               if (fi != null) {
                 setState(() {
                   _urlController.text = fi.files.first.path ?? _urlController.text;
                 });
               } 
               
                }, icon: Icon(Icons.file_open)),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceVariant,
              ),
              keyboardType: TextInputType.url,
              textInputAction: TextInputAction.done,
              onSubmitted: (value) => _playStream(value,_subtitleController.text, _audioController.text),
              maxLines: 1,
            ),
                        const Text(
              'Enter Subtitle URL Or File (Optional)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _subtitleController,
              decoration: InputDecoration(
                hintText: 'Paste Subtitle URL Or Select that (e.g., .srt, .vtt)',
                prefixIcon: Icon(Icons.link, color: Theme.of(context).colorScheme.primary),
                suffixIcon: IconButton(onPressed:() async {final fi = await FilePicker.platform.pickFiles(type: FileType.any );
               if (fi != null) {
                 setState(() {
                 _subtitleController.text=fi.files.first.path??_subtitleController.text;
               });
               } 
               
                }, icon: Icon(Icons.file_open)),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceVariant,
              ),
              keyboardType: TextInputType.url,
              textInputAction: TextInputAction.done,
            //  onSubmitted: (value) => _playStream(value),
              maxLines: 1,
            ),
                        const Text(
              'Enter External Audio URL (Optional)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _audioController,
              decoration: InputDecoration(
                hintText: 'Paste External audio URL or Path (e.g., .mp3, .ogg)',
                prefixIcon: Icon(Icons.link, color: Theme.of(context).colorScheme.primary),
                suffixIcon: IconButton(onPressed:() async {final fi = await FilePicker.platform.pickFiles(type: FileType.any );
               if (fi != null) {
                 setState(() {
                 _audioController.text=fi.files.first.path??_audioController.text;
               });
               } 
               
                }, icon: Icon(Icons.file_open)),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceVariant,
              ),
              keyboardType: TextInputType.url,
              textInputAction: TextInputAction.done,
            //  onSubmitted: (value) => _playStream(value),
              maxLines: 1,
            ),
            const SizedBox(height: 24),

            // Play & Save Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : () => _playStream(_urlController.text.trim(),_subtitleController.text.trim(), _audioController.text.trim()),
                    icon: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(Icons.play_arrow),
                    label: const Text('Play'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _urlController.text.trim().isEmpty ? null : _saveCurrentUrl,
                    icon: const Icon(Icons.bookmark),
                    label: const Text('Save'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Loading Indicator (if needed during navigation)
            if (_isLoading)
              const Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 8),
                  Text('Opening in player...'),
                ],
              ),
            const SizedBox(height: 32),

            // Saved Streams Section
            Text(
              'Saved Streams',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            if (_savedUrls.isEmpty)
              Text(
                'No saved URLs yet. Save some to access quickly!',
                style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _savedUrls.length,
              itemBuilder: (context, index) {
                final stream = _savedUrls[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  color: Theme.of(context).colorScheme.surface,
                  child: ListTile(
                    leading: Icon(
                      Icons.video_library,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: Text(
                      stream.title.isNotEmpty ? stream.title : 'Saved Stream',
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                    ),
                    subtitle: Text(
                      stream.url,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'monospace',
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.play_arrow,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          onPressed: () => _playStream(stream.url,_subtitleController.text.trim(), _audioController.text.trim()),
                          tooltip: 'Play',
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteSavedUrl(index),
                          tooltip: 'Delete',
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }
}

class StreamUrl {
  final String url;
  final String title;

  StreamUrl({required this.url, this.title = ''});

  Map<String, dynamic> toJson() => {'url': url, 'title': title};

  factory StreamUrl.fromJson(Map<String, dynamic> json) =>
      StreamUrl(url: json['url'], title: json['title'] ?? '');
}