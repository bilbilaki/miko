// TODO Implement this library.
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:miko/yt-dlp/models/ytdlp_config.dart';

class OptionsPanel extends StatefulWidget {
  final YtdlpConfig config;
  const OptionsPanel({super.key, required this.config});

  @override
  State<OptionsPanel> createState() => _OptionsPanelState();
}

class _OptionsPanelState extends State<OptionsPanel> {
  late YtdlpConfig _config;

  @override
  void initState() {
    super.initState();
    _config = widget.config;
  }

  Widget _buildTextOption(
      String label, String hint, Function(String) onChanged) {
    return TextFormField(
      decoration: InputDecoration(labelText: label, hintText: hint),
      onChanged: onChanged,
    );
  }

  Widget _buildSwitchOption(String title, bool? initialValue, Function(bool) onChanged) {
    return SwitchListTile(
      title: Text(title),
      value: initialValue ?? false,
      onChanged: onChanged,
      dense: true,
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildFilePickerOption(String label, String? currentPath, Function(String) onSelected) {
    return Row(children: [
      Expanded(child: Text(currentPath ?? 'Not Selected', overflow: TextOverflow.ellipsis)),
      ElevatedButton(
        child: Text(label),
        onPressed: () async {
          FilePickerResult? result = await FilePicker.platform.pickFiles();
          if (result != null) {
            onSelected(result.files.single.path!);
          }
        },
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ExpansionTile(
          title: const Text('Format Selection'),
          children: [
            _buildTextOption('Format (-f)', 'bestvideo+bestaudio/best', (val) => _config.format = val),
            const SizedBox(height: 8),
            _buildTextOption('Format Sort (-S)', 'res,fps,codec', (val) => _config.formatSort = val),
            const SizedBox(height: 8),
            _buildSwitchOption('Audio-only (-x)', _config.extractAudio, (val) => setState(() => _config.extractAudio = val)),
            if (_config.extractAudio == true)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: _buildTextOption('Audio Format', 'best, mp3, aac, etc.', (val) => _config.audioFormat = val),
              ),
          ],
        ),
        ExpansionTile(
          title: const Text('Filesystem & Subtitles'),
          children: [
             _buildFilePickerOption('Cookies File', _config.cookies, (path) => setState(() => _config.cookies = path)),
             const SizedBox(height: 8),
             _buildFilePickerOption('Download Archive', _config.downloadArchive, (path) => setState(() => _config.downloadArchive = path)),
             const SizedBox(height: 8),
            _buildSwitchOption('Write thumbnail', _config.writeThumbnail, (val) => setState(() => _config.writeThumbnail = val)),
            _buildSwitchOption('Write subtitles (--write-subs)', _config.writeSubs, (val) => setState(() => _config.writeSubs = val)),
            if(_config.writeSubs == true)
              _buildTextOption('Subtitle Languages (--sub-langs)', 'en,es', (val) => _config.subLangs = val),
            _buildSwitchOption('Embed thumbnail', _config.embedThumbnail, (val) => setState(() => _config.embedThumbnail = val)),
            _buildSwitchOption('Embed metadata', _config.embedMetadata, (val) => setState(() => _config.embedMetadata = val)),
            _buildSwitchOption('Embed subtitles', _config.embedSubs, (val) => setState(() => _config.embedSubs = val)),
          ],
        ),
         ExpansionTile(
          title: const Text('Network'),
          children: [
            _buildTextOption('Proxy', 'socks5://127.0.0.1:1080', (val) => _config.proxy = val),
            const SizedBox(height: 8),
            _buildTextOption('Rate Limit', 'e.g., 50K or 4.2M', (val) => _config.limitRate = val),
            const SizedBox(height: 8),
            _buildTextOption('Retries', '10', (val) => _config.retries = int.tryParse(val)),
          ],
        ),
        // Add more ExpansionTiles for other option groups...
      ],
    );
  }
}
