import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:miko/screens/video_player_wplaylist_screen.dart';

void main() {
  runApp(const LocalPlayerMenuApp());
}

class LocalPlayerMenuApp extends StatelessWidget {
  const LocalPlayerMenuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Local Player',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      home: SourceMenuPage(
        onSourceSelected: (uri, isNetwork) {
          // TODO: Navigate to your player page and start playback with `uri`.
          // Example:
          isNetwork?
          Navigator.push(context, MaterialPageRoute(
            builder: (_) => VideoPlayerScreen(videoUrl: uri.toString()),
          )):  Navigator.push(context, MaterialPageRoute(
            builder: (_) => VideoPlayerScreenLocal(videoUrl: uri.toString()),
          ));
        },
      ),
    );
  }
}

class SourceMenuPage extends StatefulWidget {
  const SourceMenuPage({super.key, this.onSourceSelected});

  final void Function(Uri uri, bool isNetwork)? onSourceSelected;

  @override
  State<SourceMenuPage> createState() => _SourceMenuPageState();
}

class _SourceMenuPageState extends State<SourceMenuPage> {
  final _urlController = TextEditingController();
  String? _urlError;

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  void _openMenu() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.link),
              title: const Text('Add URL to play'),
              subtitle: const Text('HTTP/HTTPS video URL'),
              onTap: () {
                Navigator.pop(ctx);
                _showAddUrlDialog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.folder_open),
              title: const Text('Select file from storage'),
              subtitle: const Text('Pick a local video file'),
              onTap: () {
                Navigator.pop(ctx);
                _pickLocalFile();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showAddUrlDialog() async {
    _urlController.text = '';
    _urlError = null;
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Play from URL'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _urlController,
              keyboardType: TextInputType.url,
              decoration: InputDecoration(
                hintText: 'https://example.com/video.mp4',
                errorText: _urlError,
              ),
              autofocus: true,
              onSubmitted: (_) => _submitUrl(ctx),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => _submitUrl(ctx),
            child: const Text('Play'),
          ),
        ],
      ),
    );
  }

  void _submitUrl(BuildContext ctx) {
    final raw = _urlController.text.trim();
    final uri = Uri.tryParse(raw);

    final valid =
        uri != null &&
        (uri.isScheme('http') || uri.isScheme('https')) &&
        uri.host.isNotEmpty;

    if (!valid) {
      setState(() => _urlError = 'Enter a valid http/https URL');
      return;
    }

    Navigator.pop(ctx); // close dialog
    widget.onSourceSelected?.call(uri!, true);
    _showSnack('URL selected: ${uri.toString()}');
  }

  Future<void> _pickLocalFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp4', 'mkv', 'mov', 'avi', 'webm', 'm4v'],
        allowMultiple: false,
        withData: false,
        dialogTitle: 'Select a video',
      );
      if (result == null || result.files.isEmpty) {
        _showSnack('No file selected');
        return;
      }

      final picked = result.files.single;

      // On mobile/desktop, `path` is available. On web, use `bytes`/`name` (not covered here).
      if (picked.path == null) {
        _showSnack('This platform requires a file path (try mobile/desktop).');
        return;
      }

      final uri = Uri.file(picked.path!);
      widget.onSourceSelected?.call(uri, false);
      _showSnack('File selected: ${picked.name}');
    } catch (e) {
      _showSnack('Error picking file: $e');
    }
  }

  void _showSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Local Player'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (v) {
              if (v == 'url') _showAddUrlDialog();
              if (v == 'file') _pickLocalFile();
            },
            itemBuilder: (ctx) => const [
              PopupMenuItem(value: 'url', child: Text('Add URL')),
              PopupMenuItem(value: 'file', child: Text('Select File')),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openMenu,
        icon: const Icon(Icons.add),
        label: const Text('Add Source'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.ondemand_video, size: 72),
              SizedBox(height: 12),
              Text(
                'Add a video source to play',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 6),
              Text(
                'Use the + button or menu to add a URL or pick a local file.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
