import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';

import '../app_keeper.dart';
import '../providers/local_provider.dart';
import 'local_screen_components/local_screen_models.dart';
import 'local_screen_components/local_screen_drawers.dart';
import 'local_screen_components/local_screen_dialogs.dart';
import 'local_screen_components/local_screen_item_builders.dart';
import 'local_screen_components/local_screen_context_menus.dart';
import 'local_screen_components/local_screen_file_operations.dart';
import 'local_screen_components/local_screen_appbar_actions.dart';

class LocalScreen extends StatefulWidget {
  const LocalScreen({super.key});

  @override
  State<LocalScreen> createState() => LocalScreenState();
}

class LocalScreenState extends State<LocalScreen> {
  // `currentFolderPath` keeps track of the subfolder the user is currently viewing.
  // If null, it means the user is at the root of the `externalPath`.
  String? currentFolderPath;

  // State for new features
  ViewMode _viewMode = ViewMode.grid;
  SortMode _sortMode = SortMode.type;
  bool _sortAscending = true;
  double _gridCrossAxisCount = 3.0; // Default to 3 columns for grid view

  @override
  void initState() {
    super.initState();
    // Ensure context is fully built before interacting with provider or file system
    WidgetsBinding.instance.addPostFrameCallback((_) => _initialize());
  }

  Future<void> _initialize() async {
    final localProvider = LocalProvider();
    final provider = Provider.of<LocalProvider>(context, listen: false);
    await localProvider.setDefaultPathIfNoneSet();

    // Determine a sensible default grid size based on platform
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      _gridCrossAxisCount = 4.0;
    }
    await provider.loadPath(); // Load saved path from SharedPreferences
    if (provider.externalPath == null) {
      _promptPathSelection(); // If no path saved, prompt user to select one
    }
  }

  /// Prompts the user to select an external directory.
  Future<void> _promptPathSelection() async {
    final provider = Provider.of<LocalProvider>(context, listen: false);
    final selected = await FilePicker.platform.getDirectoryPath();
    if (selected != null) {
      // When a new path is set, always reset the view to the root of that new path
      setState(() {
        currentFolderPath = null; // Display the root of the new path
      });
      await provider.setPath(selected); // Save and load the new path
    } else {
      // User cancelled path selection when no path was previously set.
      // Optionally, show a message or keep the app in an empty state.
      showSnackBar('No folder selected. Please select a folder to start.');
    }
  }

  // --- NAVIGATION LOGIC ---

  /// Navigates into a specific folder and refreshes the displayed content.
  void _openFolder(String folderPath) {
    setState(() {
      currentFolderPath = folderPath; // Update the current folder being viewed
    });
    // Tell the provider to refresh its list based on the new folder path
    Provider.of<LocalProvider>(context, listen: false).refresh(folderPath);
  }

  /// Navigates up one level in the directory hierarchy.
  void _goUp() {
    final provider = Provider.of<LocalProvider>(context, listen: false);
    final rootPath = provider.externalPath;

    if (rootPath == null) {
      // If no root path is set, there's nowhere to go up from effectively.
      return;
    }

    // If currently at the very root (currentFolderPath is null or matches rootPath), can't go higher
    if (currentFolderPath == null || p.equals(currentFolderPath!, rootPath)) {
      showSnackBar('Already at the root directory.');
      return;
    }

    // Get the parent directory of the current path
    final parentDir = Directory(currentFolderPath!).parent;

    // Use path package for reliable comparison: if parent is the root, go to root view
    if (p.equals(parentDir.path, rootPath)) {
      setState(() {
        currentFolderPath =
            null; // Reset to null to signify viewing the root externalPath
      });
      provider.refresh(rootPath); // Refresh with root path
    } else {
      // Otherwise, open the parent folder
      _openFolder(parentDir.path);
    }
  }

  /// Combines all file and folder lists from the provider and sorts them.
  List<GridItem> _getSortedItems(LocalProvider provider) {
    final items = [
      ...provider.folders.map((f) => GridItem(f)),
      ...provider.movies.map((f) => GridItem(f)),
      ...provider.audios.map((f) => GridItem(f)),
      ...provider.images.map((f) => GridItem(f)),
      ...provider.documents.map((f) => GridItem(f)),
    ];

    items.sort((a, b) {
      int comparison;
      switch (_sortMode) {
        case SortMode.name:
          comparison = a.name.toLowerCase().compareTo(b.name.toLowerCase());
          break;
        case SortMode.date:
          // For date, newer comes first if descending, older comes first if ascending
          comparison = b.entity.statSync().modified.compareTo(
            a.entity.statSync().modified,
          );
          break;
        case SortMode.type:
          // Sort folders first, then files by type, then by name
          if (a.isFolder && !b.isFolder) {
            comparison = -1;
          } else if (!a.isFolder && b.isFolder) {
            comparison = 1;
          } else {
            String typeA = a.isFolder
                ? 'folder'
                : p.extension(a.entity.path).toLowerCase();
            String typeB = b.isFolder
                ? 'folder'
                : p.extension(b.entity.path).toLowerCase();
            comparison = typeA.compareTo(typeB);
            if (comparison == 0) {
              comparison = a.name.toLowerCase().compareTo(b.name.toLowerCase());
            }
          }
          break;
      }
      return _sortAscending ? comparison : -comparison;
    });

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocalProvider>(
      builder: (context, provider, _) {
        // Show an empty view if no external path is set, prompting user to choose one
        if (provider.externalPath == null) {
          return _buildEmptyView();
        }

        final sortedItems = _getSortedItems(provider);
        // Display the current folder name in the AppBar, or "Local Files" if at root
        final currentDirName = currentFolderPath != null
            ? p.basename(currentFolderPath!)
            : "Local Files";

        return Scaffold(
          appBar: AppBar(
            title: Text(currentDirName, overflow: TextOverflow.ellipsis),
            leading:
                (currentFolderPath != null &&
                        !p.equals(
                          currentFolderPath!,
                          provider.externalPath!,
                        )) ||
                    (currentFolderPath == null &&
                        provider.externalPath != null &&
                        Directory(provider.externalPath!).parent.path !=
                            provider.externalPath!)
                ? IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: _goUp,
                  )
                : null,
            flexibleSpace: IconButton(
              icon: const Icon(Icons.home_sharp),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => StartPage()),
                );
              },
            ),
            actions: LocalScreenAppBarActions.buildActions(
              context: context,
              viewMode: _viewMode,
              sortMode: _sortMode,
              sortAscending: _sortAscending,
              onToggleView: () => setState(() => _viewMode = _viewMode == ViewMode.grid ? ViewMode.list : ViewMode.grid),
              onShowSizeSlider: () => LocalScreenDialogs.showSizeSliderDialog(context, _gridCrossAxisCount, (newValue) => setState(() => _gridCrossAxisCount = newValue)),
              onSortSelected: (mode) {
                if (_sortMode == mode) {
                  setState(() => _sortAscending = !_sortAscending);
                } else {
                  setState(() {
                    _sortMode = mode;
                    _sortAscending = true;
                  });
                }
              },
              onChangeFolder: _promptPathSelection,
              onRefresh: () => provider.refresh(currentFolderPath),
              onBatchRename: () => LocalScreenFileOperations.showBatchRenameDialog(context, provider, currentFolderPath, showSnackBar),
              onClearCache: () async {
                final confirmed = await LocalScreenDialogs.showConfirmationDialog(
                  context,
                  'Clear Cache',
                  'Are you sure you want to clear all generated thumbnail cache files?',
                );
                if (confirmed == true) {
                  final success = await provider.clearAllThumbnailsCache();
                  if (success) {
                    showSnackBar('Thumbnail cache cleared successfully.');
                  } else {
                    showSnackBar('Failed to clear thumbnail cache.');
                  }
                }
              },
            ),
          ),
          drawer: const ComponentLibraryDrawer(), // Your left drawer
          endDrawer: const ComponentBrowserDrawer(), // Your right drawer
          body: sortedItems.isEmpty
              ? const Center(child: Text("This folder is empty."))
              : _buildContent(sortedItems),
        );
      },
    );
  }

  /// Builds either a GridView or ListView based on the current `_viewMode`.
  Widget _buildContent(List<_GridItem> items) {
    if (_viewMode == ViewMode.grid) {
      return _buildGridView(items);
    } else {
      return _buildListView(items);
    }
  }

  // --- Grid View Builder ---
  Widget _buildGridView(List<GridItem> items) {
    double aspectRatio = _gridCrossAxisCount <= 3 ? 0.8 : 1.0;

    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _gridCrossAxisCount.toInt(),
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: aspectRatio,
      ),
      itemBuilder: (context, idx) {
        final item = items[idx];
        final provider = Provider.of<LocalProvider>(context, listen: false);
        return item.isFolder
            ? LocalScreenItemBuilders.buildFolderTile(
                item.entity as Directory,
                () => _openFolder((item.entity as Directory).path),
                () => _showFolderContextMenu(item.entity as Directory),
              )
            : LocalScreenItemBuilders.buildFileTile(
                item.entity as File,
                provider,
                () => LocalScreenFileOperations.handleFileTap(
                  context,
                  item.entity as File,
                  provider,
                  showSnackBar,
                ),
                () => _showFileContextMenu(item.entity as File),
              );
      },
    );
  }

  // --- List View Builder ---
  Widget _buildListView(List<GridItem> items) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final provider = Provider.of<LocalProvider>(context, listen: false);
        return item.isFolder
            ? LocalScreenItemBuilders.buildFolderListItem(
                item.entity as Directory,
                () => _openFolder((item.entity as Directory).path),
                () => _showFolderContextMenu(item.entity as Directory),
              )
            : LocalScreenItemBuilders.buildFileListItem(
                item.entity as File,
                provider,
                () => LocalScreenFileOperations.handleFileTap(
                  context,
                  item.entity as File,
                  provider,
                  showSnackBar,
                ),
                () => _showFileContextMenu(item.entity as File),
              );
      },
    );
  }

  /// Displays a view when no base path is selected, prompting user for selection.
  Widget _buildEmptyView() {
    return Scaffold(
      appBar: AppBar(title: const Text("Local Files")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Please select a folder to view your local files."),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.folder_open),
              label: const Text("Choose Folder"),
              onPressed: _promptPathSelection,
            ),
          ],
        ),
      ),
    );
  }

  // --- CONTEXT MENU HANDLERS ---

  void _showFileContextMenu(File file) {
    final provider = Provider.of<LocalProvider>(context, listen: false);
    LocalScreenContextMenus.showFileContextMenu(
      context,
      file,
      provider,
      (f) => LocalScreenFileOperations.renameFile(context, f, provider, showSnackBar),
      (f) => LocalScreenFileOperations.copyFile(context, f, provider, currentFolderPath, showSnackBar),
      (f) => LocalScreenFileOperations.moveFile(context, f, provider, currentFolderPath, showSnackBar),
      (f) => LocalScreenFileOperations.deleteFile(context, f, provider, showSnackBar),
      provider.isTextFile(file)
          ? (f) => LocalScreenFileOperations.showDocumentContentDialog(context, f, provider, showSnackBar)
          : null,
    );
  }

  void _showFolderContextMenu(Directory folder) {
    final provider = Provider.of<LocalProvider>(context, listen: false);
    LocalScreenContextMenus.showFolderContextMenu(
      context,
      folder,
      provider,
      (d) => LocalScreenFileOperations.renameFolder(context, d, provider, showSnackBar),
      (d) => LocalScreenFileOperations.copyFolder(context, d, provider, currentFolderPath, showSnackBar),
      (d) => LocalScreenFileOperations.moveFolder(context, d, provider, currentFolderPath, showSnackBar, _goUp),
      (d) => LocalScreenFileOperations.deleteFolder(context, d, provider, currentFolderPath, showSnackBar, _goUp),
      (d) => LocalScreenFileOperations.createNewFolder(context, d, provider, showSnackBar),
    );
  }

  /// Displays a SnackBar message at the bottom of the screen.
  void showSnackBar(String message) {
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

