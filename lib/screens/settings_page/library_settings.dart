part of '../settings_page.dart';


/// Tab 1: Libraries & Directories Settings (original content)
class _LibrariesTab extends StatefulWidget {
  const _LibrariesTab();

  @override
  State<_LibrariesTab> createState() => _LibrariesTabState();
}

class _LibrariesTabState extends State<_LibrariesTab>
    with AutomaticKeepAliveClientMixin {
  late final TextEditingController _dirController;
  bool _saving = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    final initialPath =
        context.read<UserDataService>().selectedDirectoryPath ?? '';
    _dirController = TextEditingController(text: initialPath);
  }

  @override
  void dispose() {
    _dirController.dispose();
    super.dispose();
  }

  Future<void> _pickDirectory() async {
    final path = await FilePicker.platform.getDirectoryPath(
      dialogTitle: 'Select a folder',
    );
    if (path != null) {
      setState(() {
        _dirController.text = path;
      });
    }
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await context.read<UserDataService>().setSelectedDirectoryPath(
        _dirController.text.trim(),
      );
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
    super.build(context);
    final theme = Theme.of(context);
    final svc = context.watch<UserDataService>();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Downloads directory', style: theme.textTheme.titleMedium),
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
            final path = await FilePicker.platform.getDirectoryPath(
              dialogTitle: 'Select a Movies folder',
            );
            if (path != null) {
              await context.read<UserDataService>().addMoviesPath(path);
              if (!mounted) return;
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Movie path added')));
            }
          },
          onRemove: (p) => context.read<UserDataService>().removeMoviesPath(p),
        ),
        _LibrarySection(
          title: 'Series paths',
          paths: svc.seriesLibraryPaths,
          onAdd: () async {
            final path = await FilePicker.platform.getDirectoryPath(
              dialogTitle: 'Select a Series folder',
            );
            if (path != null) {
              await context.read<UserDataService>().addSeriesPath(path);
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Series path added')),
              );
            }
          },
          onRemove: (p) => context.read<UserDataService>().removeSeriesPath(p),
        ),
        _LibrarySection(
          title: 'Music paths',
          paths: svc.musicLibraryPaths,
          onAdd: () async {
            final path = await FilePicker.platform.getDirectoryPath(
              dialogTitle: 'Select a Music folder',
            );
            if (path != null) {
              await context.read<UserDataService>().addMusicPath(path);
              if (!mounted) return;
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Music path added')));
            }
          },
          onRemove: (p) => context.read<UserDataService>().removeMusicPath(p),
        ),
        _LibrarySection(
          title: 'Music videos paths',
          paths: svc.musicVideoLibraryPaths,
          onAdd: () async {
            final path = await FilePicker.platform.getDirectoryPath(
              dialogTitle: 'Select a Music Videos folder',
            );
            if (path != null) {
              await context.read<UserDataService>().addMusicVideoPath(path);
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Music video path added')),
              );
            }
          },
          onRemove: (p) =>
              context.read<UserDataService>().removeMusicVideoPath(p),
        ),
        _LibrarySection(
          title: 'Mixed content paths',
          paths: svc.mixedLibraryPaths,
          onAdd: () async {
            final path = await FilePicker.platform.getDirectoryPath(
              dialogTitle: 'Select a Mixed Content folder',
            );
            if (path != null) {
              await context.read<UserDataService>().addMixedPath(path);
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Mixed content path added')),
              );
            }
          },
          onRemove: (p) => context.read<UserDataService>().removeMixedPath(p),
        ),
        _LibrarySection(
          title: 'Photo paths',
          paths: svc.photoLibraryPaths,
          onAdd: () async {
            final path = await FilePicker.platform.getDirectoryPath(
              dialogTitle: 'Select a Photos folder',
            );
            if (path != null) {
              await context.read<UserDataService>().addPhotoPath(path);
              if (!mounted) return;
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Photo path added')));
            }
          },
          onRemove: (p) => context.read<UserDataService>().removePhotoPath(p),
        ),
      ],
    );
  }
}