// lib/ui/screens/download_screen.dart
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_io/io.dart';
import 'package:miko/yt-dlp/models/download_task.dart';
import 'package:miko/yt-dlp/models/ytdlp_config.dart';
import 'package:miko/yt-dlp/providers/download_provider.dart';
import 'package:miko/yt-dlp/ui/widgets/options_panel.dart';
import 'package:path_provider/path_provider.dart';

class DownloadScreen extends ConsumerStatefulWidget {
  const DownloadScreen({super.key});

  @override
  ConsumerState<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends ConsumerState<DownloadScreen> {
  final _urlController = TextEditingController();
  final _config = YtdlpConfig();
  String _outputDirectory = '';

  @override
  void initState() {
    super.initState();
    _setDefaultOutputDirectory();
  }

  Future<void> _setDefaultOutputDirectory() async {
    try {
      final Directory? directory = Platform.isAndroid
          ? await getExternalStorageDirectory()
          : await getDownloadsDirectory(); // Desktop Downloads
      if (directory != null) {
        setState(() {
          _outputDirectory = directory.path;
        });
      }
    } catch (e) {
      debugPrint("Error getting default downloads directory: $e");
    }
  }

  Future<void> _selectOutputDirectory() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (selectedDirectory != null) {
      setState(() {
        _outputDirectory = selectedDirectory;
      });
    }
  }

  void _startDownload() {
    if (_urlController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a URL.')),
      );
      return;
    }
    if (_outputDirectory.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an output directory.')),
      );
      return;
    }

    final task = DownloadTask(
      url: _urlController.text,
      config: _config,
      outputDirectory: _outputDirectory,
    );
    ref.read(downloadProvider.notifier).addDownload(task);
    _urlController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Task added to queue.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Download')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _urlController,
              decoration: InputDecoration(
                labelText: 'Video/Playlist URL',
                hintText: Platform.isAndroid 
                  ? 'Enter a single video or playlist URL'
                  : 'Enter one or more URLs, each on a new line',
              ),
              minLines: Platform.isAndroid ? 1 : 3,
              maxLines: Platform.isAndroid ? 3 : 10,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _outputDirectory.isEmpty
                        ? 'No output directory selected'
                        : _outputDirectory,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _selectOutputDirectory,
                  icon: const Icon(Icons.folder_open),
                  label: const Text('Output'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            if (Platform.isAndroid)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'On Android, downloads use default recommended settings. Advanced options are available on desktop.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              )
            else ...[
              const SizedBox(height: 8),
              OptionsPanel(config: _config),
            ],
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _startDownload,
              icon: const Icon(Icons.download),
              label: const Text('Start Download'),
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16)),
            ),
          ],
        ),
      ),
    );
  }
}