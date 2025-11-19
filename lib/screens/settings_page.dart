import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:miko/services/user_data_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late final TextEditingController _dirController;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final initialPath = context.read<UserDataService>().selectedDirectoryPath ?? '';
    _dirController = TextEditingController(text: initialPath);
  }

  @override
  void dispose() {
    _dirController.dispose();
    super.dispose();
  }

  Future<void> _pickDirectory() async {
    final path = await FilePicker.platform.getDirectoryPath(dialogTitle: 'Select a folder');
    if (path != null) {
      setState(() {
        _dirController.text = path;
      });
    }
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await context.read<UserDataService>().setSelectedDirectoryPath(_dirController.text.trim());
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Saved directory successfully')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final svc = context.watch<UserDataService>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Downloads directory',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _dirController,
            readOnly: true,
            decoration: InputDecoration(
              hintText: 'No folder selected',
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    tooltip: 'Clear',
                    onPressed: () {
                      setState(() => _dirController.clear());
                    },
                    icon: const Icon(Icons.clear),
                  ),
                  IconButton(
                    tooltip: 'Browse…',
                    onPressed: _pickDirectory,
                    icon: const Icon(Icons.folder_open),
                  ),
                ],
              ),
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: _pickDirectory,
                icon: const Icon(Icons.folder_open),
                label: const Text('Browse…'),
              ),
              const SizedBox(width: 12),
              FilledButton.icon(
                onPressed: _saving ? null : _save,
                icon: _saving
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save),
                label: const Text('Save'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Consumer<UserDataService>(
            builder: (_, svc, __) => Text(
              'Current: ${svc.selectedDirectoryPath ?? '—'}',
              style: theme.textTheme.bodySmall,
            ),
          ),
          const SizedBox(height: 24),
          Text('Local libraries', style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          _LibrarySection(
            title: 'Movies paths',
            paths: svc.moviesLibraryPaths,
            onAdd: () async {
              final path = await FilePicker.platform.getDirectoryPath(dialogTitle: 'Select a Movies folder');
              if (path != null) {
                await context.read<UserDataService>().addMoviesPath(path);
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Movie path added')));
              }
            },
            onRemove: (p) => context.read<UserDataService>().removeMoviesPath(p),
          ),
          _LibrarySection(
            title: 'Series paths',
            paths: svc.seriesLibraryPaths,
            onAdd: () async {
              final path = await FilePicker.platform.getDirectoryPath(dialogTitle: 'Select a Series folder');
              if (path != null) {
                await context.read<UserDataService>().addSeriesPath(path);
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Series path added')));
              }
            },
            onRemove: (p) => context.read<UserDataService>().removeSeriesPath(p),
          ),
          _LibrarySection(
            title: 'Music paths',
            paths: svc.musicLibraryPaths,
            onAdd: () async {
              final path = await FilePicker.platform.getDirectoryPath(dialogTitle: 'Select a Music folder');
              if (path != null) {
                await context.read<UserDataService>().addMusicPath(path);
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Music path added')));
              }
            },
            onRemove: (p) => context.read<UserDataService>().removeMusicPath(p),
          ),
          _LibrarySection(
            title: 'Music videos paths',
            paths: svc.musicVideoLibraryPaths,
            onAdd: () async {
              final path = await FilePicker.platform.getDirectoryPath(dialogTitle: 'Select a Music Videos folder');
              if (path != null) {
                await context.read<UserDataService>().addMusicVideoPath(path);
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Music video path added')));
              }
            },
            onRemove: (p) => context.read<UserDataService>().removeMusicVideoPath(p),
          ),
          _LibrarySection(
            title: 'Mixed content paths',
            paths: svc.mixedLibraryPaths,
            onAdd: () async {
              final path = await FilePicker.platform.getDirectoryPath(dialogTitle: 'Select a Mixed Content folder');
              if (path != null) {
                await context.read<UserDataService>().addMixedPath(path);
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Mixed content path added')));
              }
            },
            onRemove: (p) => context.read<UserDataService>().removeMixedPath(p),
          ),
          _LibrarySection(
            title: 'Photo paths',
            paths: svc.photoLibraryPaths,
            onAdd: () async {
              final path = await FilePicker.platform.getDirectoryPath(dialogTitle: 'Select a Photos folder');
              if (path != null) {
                await context.read<UserDataService>().addPhotoPath(path);
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Photo path added')));
              }
            },
            onRemove: (p) => context.read<UserDataService>().removePhotoPath(p),
          ),
        ],
      ),
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
                  child: Text(title, style: Theme.of(context).textTheme.titleMedium),
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
                    title: Text(path, maxLines: 2, overflow: TextOverflow.ellipsis),
                    trailing: IconButton(
                      tooltip: 'Remove',
                      onPressed: () async {
                        onRemove(path);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Removed path')));
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
