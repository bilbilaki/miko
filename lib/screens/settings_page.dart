import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:miko/services/user_data_service.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/subtitletranslator/app_settings.dart';
import '../services/ai_models_service.dart';
import '../services/settings_service.dart';
part 'settings_page/library_settings.dart';
part 'settings_page/subtitle_generation_settings.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(icon: Icon(Icons.folder), text: 'Libraries'),
                        Tab(icon: Icon(Icons.subtitles_outlined), text: 'AI Sub Gen'),

            Tab(icon: Icon(Icons.palette), text: 'Appearance'),
            Tab(icon: Icon(Icons.play_circle), text: 'Playback'),
            Tab(icon: Icon(Icons.info), text: 'About'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _LibrariesTab(),
          SubtitlesGenSettings(),
          _AppearanceTab(),
          _PlaybackTab(),
          _AboutTab(),
        ],
      ),
    );
  }
}

/// Tab 2: Appearance Settings
class _AppearanceTab extends StatelessWidget {
  const _AppearanceTab();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Theme', style: theme.textTheme.titleLarge),
        const SizedBox(height: 16),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.brightness_auto),
                title: const Text('Theme Mode'),
                subtitle: const Text('System default'),
                trailing: DropdownButton<String>(
                  value: 'system',
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(value: 'system', child: Text('System')),
                    DropdownMenuItem(value: 'light', child: Text('Light')),
                    DropdownMenuItem(value: 'dark', child: Text('Dark')),
                  ],
                  onChanged: (value) {
                    // TODO: Implement theme switching
                  },
                ),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.color_lens),
                title: const Text('Accent Color'),
                subtitle: const Text('Blue'),
                trailing: const Icon(Icons.circle, color: Colors.blue),
                onTap: () {
                  // TODO: Implement color picker
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text('Display', style: theme.textTheme.titleLarge),
        const SizedBox(height: 16),
        Card(
          child: Column(
            children: [
              SwitchListTile(
                secondary: const Icon(Icons.grid_view),
                title: const Text('Compact Mode'),
                subtitle: const Text('Show more items in grid'),
                value: false,
                onChanged: (value) {
                  // TODO: Implement compact mode
                },
              ),
              const Divider(height: 1),
              SwitchListTile(
                secondary: const Icon(Icons.image),
                title: const Text('Show Thumbnails'),
                subtitle: const Text('Display preview thumbnails'),
                value: true,
                onChanged: (value) {
                  // TODO: Implement thumbnail toggle
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.text_fields),
                title: const Text('Font Size'),
                subtitle: const Text('Medium'),
                trailing: DropdownButton<String>(
                  value: 'medium',
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(value: 'small', child: Text('Small')),
                    DropdownMenuItem(value: 'medium', child: Text('Medium')),
                    DropdownMenuItem(value: 'large', child: Text('Large')),
                  ],
                  onChanged: (value) {
                    // TODO: Implement font size
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Tab 3: Playback Settings
class _PlaybackTab extends StatelessWidget {
  const _PlaybackTab();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Video', style: theme.textTheme.titleLarge),
        const SizedBox(height: 16),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.high_quality),
                title: const Text('Default Quality'),
                subtitle: const Text('Auto'),
                trailing: DropdownButton<String>(
                  value: 'auto',
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(value: 'auto', child: Text('Auto')),
                    DropdownMenuItem(value: '1080p', child: Text('1080p')),
                    DropdownMenuItem(value: '720p', child: Text('720p')),
                    DropdownMenuItem(value: '480p', child: Text('480p')),
                  ],
                  onChanged: (value) {
                    // TODO: Implement quality setting
                  },
                ),
              ),
              const Divider(height: 1),
              SwitchListTile(
                secondary: const Icon(Icons.speed),
                title: const Text('Hardware Acceleration'),
                subtitle: const Text('Use GPU for video decoding'),
                value: true,
                onChanged: (value) {
                  // TODO: Implement HW acceleration toggle
                },
              ),
              const Divider(height: 1),
              SwitchListTile(
                secondary: const Icon(Icons.replay),
                title: const Text('Auto-play Next'),
                subtitle: const Text('Automatically play next episode'),
                value: true,
                onChanged: (value) {
                  // TODO: Implement auto-play
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text('Audio', style: theme.textTheme.titleLarge),
        const SizedBox(height: 16),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('Preferred Audio Language'),
                subtitle: const Text('English'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Show language picker
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.volume_up),
                title: const Text('Default Volume'),
                subtitle: Slider(
                  value: 0.8,
                  onChanged: (value) {
                    // TODO: Implement volume setting
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text('Subtitles', style: theme.textTheme.titleLarge),
        const SizedBox(height: 16),
        Card(
          child: Column(
            children: [
              SwitchListTile(
                secondary: const Icon(Icons.subtitles),
                title: const Text('Enable Subtitles'),
                subtitle: const Text('Show subtitles by default'),
                value: true,
                onChanged: (value) {
                  // TODO: Implement subtitle toggle
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('Preferred Subtitle Language'),
                subtitle: const Text('English'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Show language picker
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.format_size),
                title: const Text('Subtitle Size'),
                subtitle: const Text('Medium'),
                trailing: DropdownButton<String>(
                  value: 'medium',
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(value: 'small', child: Text('Small')),
                    DropdownMenuItem(value: 'medium', child: Text('Medium')),
                    DropdownMenuItem(value: 'large', child: Text('Large')),
                  ],
                  onChanged: (value) {
                    // TODO: Implement subtitle size
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Tab 4: About
class _AboutTab extends StatelessWidget {
  const _AboutTab();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Center(
          child: Column(
            children: [
              const SizedBox(height: 32),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.play_circle_filled,
                  size: 60,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Miko',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Version 1.0.0',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.update),
                title: const Text('Check for Updates'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('You are on the latest version'),
                    ),
                  );
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.bug_report),
                title: const Text('Report a Bug'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Open issue tracker
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.code),
                title: const Text('Source Code'),
                subtitle: const Text('github.com/bilbilaki/miko'),
                trailing: const Icon(Icons.open_in_new),
                onTap: () {
                  // TODO: Open GitHub
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.description),
                title: const Text('Licenses'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  showLicensePage(
                    context: context,
                    applicationName: 'Miko',
                    applicationVersion: '1.0.0',
                  );
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.privacy_tip),
                title: const Text('Privacy Policy'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Open privacy policy
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.gavel),
                title: const Text('Terms of Service'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Open terms
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Center(
          child: Text(
            '© 2025 Miko. All rights reserved.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _LibrarySection extends StatelessWidget {
  final String title;
  final List<String> paths;
  final Future<void> Function() onAdd;
  final void Function(String path) onRemove;

  const _LibrarySection({
    required this.title,
    required this.paths,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: onAdd,
                  icon: const Icon(Icons.add),
                  label: const Text('Add folder'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (paths.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 4.0),
                child: Text('No folders added'),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: paths.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final path = paths[index];
                  return ListTile(
                    dense: true,
                    leading: const Icon(Icons.folder),
                    title: Text(
                      path,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: IconButton(
                      tooltip: 'Remove',
                      onPressed: () async {
                        onRemove(path);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Removed path')),
                        );
                      },
                      icon: const Icon(Icons.delete_outline),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
