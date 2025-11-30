import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';

import '../app_keeper.dart';
import '../models/fileexplorer/fs_entry.dart';
import '../models/fileexplorer/fs_entry_union.dart';
import '../providers/local_provider.dart';
import '../providers/zip_explorer_provider.dart';
import 'local_screen_components/local_screen_models.dart';
import 'local_screen_components/local_screen_drawers.dart';
import 'local_screen_components/local_screen_dialogs.dart';
import 'local_screen_components/local_screen_item_builders.dart';
import 'local_screen_components/local_screen_context_menus.dart';
import 'local_screen_components/local_screen_file_operations.dart';
import 'local_screen_components/local_screen_appbar_actions.dart';
import 'local_screen_components/local_screen_path_header.dart';
import 'local_screen_components/local_screen_tree_sidebar.dart';
import 'local_screen_components/zip_explorer_view.dart';

// Main tap handler from FsEntry

class LocalScreen extends StatefulWidget {
  const LocalScreen({super.key});

  @override
  State<LocalScreen> createState() => LocalScreenState();
}

class LocalScreenState extends State<LocalScreen> {
  // `currentFolderPath` keeps track of the subfolder the user is currently viewing.
  // If null, it means the user is at the root of the `externalPath`.
  String? currentFolderPath;
  final ZipExplorerProvider _zipper = ZipExplorerProvider();
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
    final provider = Provider.of<LocalProvider>(context, listen: false);

    // On Android, request storage permission first
    if (Platform.isAndroid) {
      final hasPermission = await provider.requestAndroidStoragePermission();
      if (!hasPermission) {
        showSnackBar('Storage permission is required to browse files.');
      }
    }

    await provider.setDefaultPathIfNoneSet();

    // Determine a sensible default grid size based on platform and screen size
    final screenWidth = MediaQuery.of(context).size.width;
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      // Desktop: more columns for larger screens
      _gridCrossAxisCount = screenWidth > 1200 ? 5.0 : 4.0;
    } else if (Platform.isAndroid || Platform.isIOS) {
      // Mobile: fewer columns
      _gridCrossAxisCount = screenWidth > 600 ? 3.0 : 2.0;
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

  /// Navigates into a specific folder and refreshes the displayed content.
  void _openFolder(String folderPath) {
    setState(() {
      currentFolderPath = folderPath; // Update the current folder being viewed
    });
    // Tell the provider to refresh its list based on the new folder path
    Provider.of<LocalProvider>(context, listen: false).refresh(folderPath);
  }

  /// Handles path change from the PathHeader widget
  Future<void> _handlePathChange(String newPath) async {
    final provider = Provider.of<LocalProvider>(context, listen: false);
    final rootPath = provider.externalPath;

    if (rootPath == null) return;

    // Check if the new path is within or equal to the root path
    if (newPath == rootPath || p.isWithin(rootPath, newPath)) {
      // Navigate to the new path
      setState(() {
        currentFolderPath = newPath == rootPath ? null : newPath;
      });
      await provider.refresh(newPath);
    } else {
      // If the path is outside the root, change the root path
      await provider.setPath(newPath);
      setState(() {
        currentFolderPath = null; // Reset to root of new path
      });
    }
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
  /// This version uses the new domain model entries (FsEntry) when available
  ///
  /// Currently not used in UI, but ready for gradual migration to domain model.
  /// Will replace _getSortedItems() in future refactoring phases.
  // ignore: unused_element
  List<GridItem> _getSortedItemsFromDomainModel(LocalProvider provider) {
    final items =
        provider.entries.map((entry) => GridItem.fromFsEntry(entry)).toList();

    items.sort((a, b) {
      int comparison;
      switch (_sortMode) {
        case SortMode.name:
          comparison = a.name.toLowerCase().compareTo(b.name.toLowerCase());
          break;
        case SortMode.date:
          // For date, newer comes first if descending, older comes first if ascending
          // Note: FsEntry has timestamps, would need to extract here
          comparison = 0; // TODO: Implement date sorting for FsEntry
          break;
        case SortMode.type:
          // Sort folders first, then files by type, then by name
          if (a.isFolder && !b.isFolder) {
            comparison = -1;
          } else if (!a.isFolder && b.isFolder) {
            comparison = 1;
          } else {
            String typeA =
                a.isFolder ? 'folder' : p.extension(a.path).toLowerCase();
            String typeB =
                b.isFolder ? 'folder' : p.extension(b.path).toLowerCase();
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth <= 600;

    return Consumer<LocalProvider>(
      builder: (context, provider, _) {
        // Show an empty view if no external path is set, prompting user to choose one
        if (provider.externalPath == null) {
          return _buildEmptyView();
        }

        final sortedItems = _getSortedItemsFromDomainModel(provider);
        // Display the current folder name in the AppBar, or "Local Files" if at root
        final currentDirName = currentFolderPath != null
            ? p.basename(currentFolderPath!)
            : "Local Files";

        // Calculate if we can go back
        final canGoBack = currentFolderPath != null &&
            !p.equals(currentFolderPath!, provider.externalPath!);

        // Calculate if we're at root but can navigate up (parent exists)
        final canNavigateUpFromRoot = currentFolderPath == null &&
            provider.externalPath != null &&
            Directory(provider.externalPath!).parent.path !=
                provider.externalPath!;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              currentDirName,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: isMobile ? 16 : 20,
              ),
            ),
            leading: (canGoBack || canNavigateUpFromRoot)
                ? IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: _goUp,
                    tooltip: 'Go back',
                  )
                : null,
            // Home button in app bar
            flexibleSpace: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(
                    left: (canGoBack || canNavigateUpFromRoot) ? 56 : 16),
                child: IconButton(
                  icon: Icon(Icons.home_sharp, size: isMobile ? 20 : 24),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => StartPage()),
                    );
                  },
                  tooltip: 'Go to home screen',
                ),
              ),
            ),
            actions: [
              // Image Gallery Button
              ...LocalScreenAppBarActions.buildActions(
                context: context,
                viewMode: _viewMode,
                sortMode: _sortMode,
                sortAscending: _sortAscending,
                onToggleView: () => setState(
                  () => _viewMode = _viewMode == ViewMode.grid
                      ? ViewMode.list
                      : ViewMode.grid,
                ),
                onShowSizeSlider: () => LocalScreenDialogs.showSizeSliderDialog(
                  context,
                  _gridCrossAxisCount,
                  (newValue) => setState(() => _gridCrossAxisCount = newValue),
                ),
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
                onBatchRename: () =>
                    LocalScreenFileOperations.showBatchRenameDialog(
                  context,
                  provider,
                  currentFolderPath,
                  showSnackBar,
                ),
                onClearCache: () async {
                  final confirmed =
                      await LocalScreenDialogs.showConfirmationDialog(
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
            ],
          ),
          drawer: const ComponentLibraryDrawer(), // Your left drawer
          endDrawer: const ComponentBrowserDrawer(), // Your right drawer
          body: CollapsibleTreeSidebar(
            rootPath: provider.externalPath!,
            currentPath: currentFolderPath ?? provider.externalPath,
            onPathSelected: (path) {
              setState(() {
                currentFolderPath = path == provider.externalPath ? null : path;
              });
              provider.refresh(path);
            },
            child: Column(
              children: [
                // Path header
                PathHeader(
                  currentPath: currentFolderPath ?? provider.externalPath ?? '',
                  onPathChanged: _handlePathChange,
                ),
                // Content
                Expanded(
                  child: sortedItems.isEmpty
                      ? const Center(child: Text("This folder is empty."))
                      : _buildContent(sortedItems),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Builds either a GridView or ListView based on the current `_viewMode`.
  Widget _buildContent(List<GridItem> items) {
    if (_viewMode == ViewMode.grid) {
      return _buildGridView(items);
    } else {
      return _buildListView(items);
    }
  }

  // --- Grid View Builder ---
  Widget _buildGridView(List<GridItem> items) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth <= 600;

    // Responsive aspect ratio
    double aspectRatio = _gridCrossAxisCount <= 3 ? 0.8 : 1.0;

    // Responsive padding and spacing
    final padding = isMobile ? 8.0 : 16.0;
    final spacing = isMobile ? 8.0 : 16.0;

    return GridView.builder(
      padding: EdgeInsets.all(padding),
      itemCount: items.length,
      // Preload items slightly outside viewport for smoother scrolling
      cacheExtent: 200,
      // Keep loaded thumbnails alive when scrolled off screen temporarily
      addAutomaticKeepAlives: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _gridCrossAxisCount.toInt(),
        mainAxisSpacing: spacing,
        crossAxisSpacing: spacing,
        childAspectRatio: aspectRatio,
      ),
      itemBuilder: (context, idx) {
        final item = items[idx];
        final provider = Provider.of<LocalProvider>(context, listen: false);

        final entry = item.entry; // may be null for legacy items

        if (entry != null) {
          // Domain-model based rendering
          if (entry.isFolder) {
            return LocalScreenItemBuilders.buildFolderTileFromEntry(
              entry,
              () => _openFolder(entry.path),
              () => _showFolderContextMenu(Directory(entry.path)),
            );
          } else if (entry.kind == FileKind.archive) {
            return LocalScreenItemBuilders.buildFileTileFromEntry(
              entry,
              provider,
              () => _zipper.enterZipMode(entry.path),
              () => _showArchiveContextMenu(entry),
            );
          } else {
            return LocalScreenItemBuilders.buildFileTileFromEntry(
              entry,
              provider,
              () => LocalScreenFileOperations.handleEntryTap(
                context,
                entry,
                provider,
                showSnackBar,
              ),
              () => _showFileContextMenuFromEntry(entry),
            );
          }
        } else {
          // Fallback to legacy rendering (optional, can be removed when no legacy)
          final entity = item.entity!;
          return entity is Directory
              ? LocalScreenItemBuilders.buildFolderTile(
                  entity,
                  () => _openFolder(entity.path),
                  () => _showFolderContextMenu(entity),
                )
              : LocalScreenItemBuilders.buildFileTile(
                  entity as File,
                  provider,
                  () => LocalScreenFileOperations.handleFileTap(
                    context,
                    entity,
                    provider,
                    showSnackBar,
                  ),
                  () => _showFileContextMenu(entity),
                );
        }
      },
    );
  }

  void _showFileContextMenuFromEntry(FsEntry entry) {
    final provider = Provider.of<LocalProvider>(context, listen: false);
    LocalScreenContextMenus.showFileContextMenuForEntry(
      context,
      entry,
      provider,
      (e) => LocalScreenFileOperations.renameEntry(
        context,
        e,
        provider,
        showSnackBar,
      ),
      (e) => LocalScreenFileOperations.copyEntry(
        context,
        e,
        provider,
        currentFolderPath,
        showSnackBar,
      ),
      (e) => LocalScreenFileOperations.moveEntry(
        context,
        e,
        provider,
        currentFolderPath,
        showSnackBar,
      ),
      (e) => LocalScreenFileOperations.deleteEntry(
        context,
        e,
        provider,
        showSnackBar,
      ),
      // Edit content only if document
      entry.kind == FileKind.document || entry.kind == FileKind.markdown
          ? (e) => LocalScreenFileOperations.showEntryDocumentDialog(
                context,
                e,
                provider,
                showSnackBar,
              )
          : null,
    );
  }

  // --- List View Builder ---
  Widget _buildListView(List<GridItem> items) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      itemCount: items.length,
      // Preload items slightly outside viewport
      cacheExtent: 150,
      addAutomaticKeepAlives: true,
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth <= 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Local Files",
          style: TextStyle(fontSize: isMobile ? 16 : 20),
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(isMobile ? 16 : 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.folder_open,
                size: isMobile ? 64 : 80,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.5),
              ),
              SizedBox(height: isMobile ? 16 : 24),
              Text(
                "Please select a folder to view your local files.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: isMobile ? 14 : 16),
              ),
              if (Platform.isAndroid) ...[
                SizedBox(height: isMobile ? 8 : 12),
                Text(
                  "Storage permission is required to browse files.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isMobile ? 12 : 14,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.6),
                  ),
                ),
              ],
              SizedBox(height: isMobile ? 20 : 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.folder_open),
                label: Text(
                  "Choose Folder",
                  style: TextStyle(fontSize: isMobile ? 14 : 16),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 20 : 24,
                    vertical: isMobile ? 12 : 16,
                  ),
                ),
                onPressed: _promptPathSelection,
              ),
            ],
          ),
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
      (f) => LocalScreenFileOperations.renameFile(
        context,
        f,
        provider,
        showSnackBar,
      ),
      (f) => LocalScreenFileOperations.copyFile(
        context,
        f,
        provider,
        currentFolderPath,
        showSnackBar,
      ),
      (f) => LocalScreenFileOperations.moveFile(
        context,
        f,
        provider,
        currentFolderPath,
        showSnackBar,
      ),
      (f) => LocalScreenFileOperations.deleteFile(
        context,
        f,
        provider,
        showSnackBar,
      ),
      provider.isTextFile(file)
          ? (f) => LocalScreenFileOperations.showDocumentContentDialog(
                context,
                f,
                provider,
                showSnackBar,
              )
          : null,
    );
  }

  void _showFolderContextMenu(Directory folder) {
    final provider = Provider.of<LocalProvider>(context, listen: false);
    LocalScreenContextMenus.showFolderContextMenu(
      context,
      folder,
      provider,
      (d) => LocalScreenFileOperations.renameFolder(
        context,
        d,
        provider,
        showSnackBar,
      ),
      (d) => LocalScreenFileOperations.copyFolder(
        context,
        d,
        provider,
        currentFolderPath,
        showSnackBar,
      ),
      (d) => LocalScreenFileOperations.moveFolder(
        context,
        d,
        provider,
        currentFolderPath,
        showSnackBar,
        _goUp,
      ),
      (d) => LocalScreenFileOperations.deleteFolder(
        context,
        d,
        provider,
        currentFolderPath,
        showSnackBar,
        _goUp,
      ),
      (d) => LocalScreenFileOperations.createNewFolder(
        context,
        d,
        provider,
        showSnackBar,
      ),
    );
  }

  void _showArchiveContextMenu(FsEntry entry) {
    final provider = Provider.of<LocalProvider>(context, listen: false);

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text(
                  entry.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text('Archive File'),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.unarchive),
                title: const Text('Extract All'),
                onTap: () async {
                  Navigator.pop(context);
                  await _handleExtractArchive(entry);
                },
              ),
              ListTile(
                leading: const Icon(Icons.explore),
                title: const Text('Browse'),
                onTap: () {
                  Navigator.pop(context);
                  _zipper.enterZipMode(entry.path);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Scaffold(
                        appBar: AppBar(
                          title: Text(entry.name),
                          leading: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              _zipper.exitZipMode();
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        body: ZipExplorerView(
                          zipProvider: _zipper,
                          localProvider: provider,
                          showSnackBar: showSnackBar,
                        ),
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Rename'),
                onTap: () {
                  Navigator.pop(context);
                  LocalScreenFileOperations.renameEntry(
                    context,
                    entry,
                    provider,
                    showSnackBar,
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Delete'),
                onTap: () {
                  Navigator.pop(context);
                  LocalScreenFileOperations.deleteEntry(
                    context,
                    entry,
                    provider,
                    showSnackBar,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _handleExtractArchive(FsEntry archiveEntry) async {
    final destinationPath = await FilePicker.platform.getDirectoryPath();
    if (destinationPath == null) {
      showSnackBar('No destination folder selected');
      return;
    }

    try {
      // Use the zip service to extract all files from the archive
      await _zipper.extractFromZip(
        sourcePaths: [], // Empty list means extract all
        destinationPath: destinationPath,
        onProgress: (progress) => showSnackBar('Extracting...'),
      );
      showSnackBar('Archive extracted successfully to $destinationPath');
    } catch (e) {
      showSnackBar('Error extracting archive: $e');
    }
  }

  /// Load image files from a directory

  /// Displays a SnackBar message at the bottom of the screen.
  void showSnackBar(String message) {
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 3)),
    );
  }
}
