// lib/ui/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_io/io.dart';
import 'package:miko/constants.dart';
import 'package:miko/yt-dlp/providers/settings_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _isLoading = false;

  void _installOrUpdate() async {
    setState(() => _isLoading = true);
    await ref.read(settingsProvider.notifier).findOrDownloadYtdlp();
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final settingsNotifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('yt-dlp Configuration',
                style: Theme.of(context).textTheme.titleLarge),
            const Divider(),
            const SizedBox(height: 8),
            ListTile(
              title: const Text('Engine'),
              subtitle: Text(settings.ytdlpPath == 'android_bundled'
                  ? 'Using built-in Android engine'
                  : settings.ytdlpPath ?? 'Not found/installed'),
            ),
            ListTile(
              title: const Text('Version'),
              subtitle: Text(settings.version ?? 'Unknown'),
            ),
            if (!Platform.isAndroid)
              ListTile(
                title: const Text('Release Channel'),
                trailing: DropdownButton<YtdlpChannel>(
                  value: settings.channel,
                  onChanged: (YtdlpChannel? newValue) {
                    if (newValue != null) {
                      settingsNotifier.setChannel(newValue);
                    }
                  },
                  items: YtdlpChannel.values
                      .map<DropdownMenuItem<YtdlpChannel>>(
                          (YtdlpChannel value) {
                    return DropdownMenuItem<YtdlpChannel>(
                      value: value,
                      child: Text(
                          value.name[0].toUpperCase() + value.name.substring(1)),
                    );
                  }).toList(),
                ),
              ),
            const SizedBox(height: 24),
            Center(
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : Platform.isAndroid
                      ? Text(
                          'The yt-dlp engine is included with the app on Android.',
                          style: Theme.of(context).textTheme.bodySmall,
                          textAlign: TextAlign.center,
                        )
                      : ElevatedButton.icon(
                          onPressed: _installOrUpdate,
                          icon: const Icon(Icons.system_update),
                          label: settings.ytdlpPath == null
                              ? const Text('Install yt-dlp')
                              : const Text('Check for Updates'),
                          style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 16)),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}