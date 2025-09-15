import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:miko/providers/local_provider.dart';
import 'package:miko/screens/video_player_wplaylist_screen.dart';
import 'package:path/path.dart' as p;
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';

// Enums for managing UI states
enum ViewMode { grid, list }

enum SortMode { name, date, type }

class LocalScreen extends StatefulWidget {
  const LocalScreen({super.key});

  @override
  State<LocalScreen> createState() => _LocalScreenState();
}

class _LocalScreenState extends State<LocalScreen> {
  String? currentFolderPath;

  // State for new features
  ViewMode _viewMode = ViewMode.grid;
  SortMode _sortMode = SortMode.type;
  bool _sortAscending = true;
  double _gridCrossAxisCount = 3.0; // Default to 3 columns

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initialize());
  }

  Future<void> _initialize() async {
    final provider = Provider.of<LocalProvider>(context, listen: false);
    // Determine a sensible default grid size based on platform
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      _gridCrossAxisCount = 4.0;
    }
    await provider.loadPath();
    if (provider.externalPath == null) {
      _promptPathSelection();
    }
  }

  Future<void> _promptPathSelection() async {
    final provider = Provider.of<LocalProvider>(context, listen: false);
    final selected = await FilePicker.platform.getDirectoryPath();
    if (selected != null) {
      // When a new path is set, always reset the view to the root
      setState(() {
        currentFolderPath = null;
      });
      await provider.setPath(selected);
    }
  }

  // --- NAVIGATION LOGIC (REPAIRED AND IMPROVED) ---

  void _openFolder(String folderPath) {
    // This function now correctly triggers a state update and a provider refresh
    setState(() {
      currentFolderPath = folderPath;
    });
    Provider.of<LocalProvider>(context, listen: false).refresh(folderPath);
  }

  void _goUp() {
    if (currentFolderPath == null) return;
    final provider = Provider.of<LocalProvider>(context, listen: false);
    final rootPath = provider.externalPath;

    if (rootPath == null) return;

    // Use Directory object for robust parent path finding
    final parentDir = Directory(currentFolderPath!).parent;

    // Use path package for reliable comparison, avoids issues with trailing slashes
    if (p.equals(parentDir.path, rootPath)) {
      // If parent is the root, go back to the root view
      setState(() {
        currentFolderPath = null;
      });
      provider.refresh(rootPath); // Refresh with root path
    } else {
      // Otherwise, open the parent folder
      _openFolder(parentDir.path);
    }
  }

  // --- Sorting Logic ---
  List<_GridItem> _getSortedItems(LocalProvider provider) {
    final items = [
      ...provider.folders.map((f) => _GridItem(f)),
      ...provider.movies.map((f) => _GridItem(f)),
    ];

    items.sort((a, b) {
      int comparison;
      switch (_sortMode) {
        case SortMode.name:
          comparison = a.name.toLowerCase().compareTo(b.name.toLowerCase());
          break;
        case SortMode.date:
          comparison = b.entity.statSync().modified.compareTo(
            a.entity.statSync().modified,
          );
          break;
        case SortMode.type:
        default:
          if (a.isFolder && !b.isFolder) {
            comparison = -1;
          } else if (!a.isFolder && b.isFolder)
            comparison = 1;
          else
            comparison = a.name.toLowerCase().compareTo(b.name.toLowerCase());
          break;
      }
      return _sortAscending ? comparison : -comparison;
    });

    return items;
  }

  // --- UI FOR SIZE SLIDER ---
  void _showSizeSliderDialog() {
    showDialog(
      context: context,
      builder: (context) {
        // Use a StatefulBuilder so only the slider dialog rebuilds on drag
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Adjust Item Size"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Columns: ${_gridCrossAxisCount.toInt()}"),
                  Slider(
                    value: _gridCrossAxisCount,
                    min: 2, // Min 2 columns (large items)
                    max: 8, // Max 8 columns (small items) for desktop
                    divisions: 6, // 8 - 2 = 6 steps
                    label: _gridCrossAxisCount.toInt().toString(),
                    onChanged: (newValue) {
                      // This updates both the dialog's UI and the main screen's state
                      setDialogState(() {
                        setState(() {
                          _gridCrossAxisCount = newValue;
                        });
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Done"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocalProvider>(
      builder: (context, provider, _) {
        if (provider.externalPath == null) {
          return _buildEmptyView();
        }

        final sortedItems = _getSortedItems(provider);
        final currentDirName = currentFolderPath != null
            ? p.basename(currentFolderPath!)
            : "Local Files";

        return Scaffold(
          appBar: AppBar(
            title: Text(currentDirName, overflow: TextOverflow.ellipsis),
            leading: currentFolderPath != null
                ? IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: _goUp,
                  )
                : null,
            actions: [
              // --- View Mode Toggle ---
              IconButton(
                icon: Icon(
                  _viewMode == ViewMode.grid
                      ? Icons.view_list
                      : Icons.grid_view,
                ),
                tooltip: "Toggle View",
                onPressed: () => setState(
                  () => _viewMode = _viewMode == ViewMode.grid
                      ? ViewMode.list
                      : ViewMode.grid,
                ),
              ),
              // --- NEW: Size Adjustment Button (only shown in grid view) ---
              if (_viewMode == ViewMode.grid)
                IconButton(
                  icon: const Icon(Icons.view_quilt_outlined),
                  tooltip: "Adjust Size",
                  onPressed: _showSizeSliderDialog,
                ),
              // --- Sorting Menu ---
              PopupMenuButton<SortMode>(
                icon: const Icon(Icons.sort),
                tooltip: "Sort by",
                onSelected: (mode) {
                  if (_sortMode == mode) {
                    setState(() => _sortAscending = !_sortAscending);
                  } else {
                    setState(() {
                      _sortMode = mode;
                      _sortAscending = true;
                    });
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: SortMode.type,
                    child: Text("Sort by Type"),
                  ),
                  const PopupMenuItem(
                    value: SortMode.name,
                    child: Text("Sort by Name"),
                  ),
                  const PopupMenuItem(
                    value: SortMode.date,
                    child: Text("Sort by Date"),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.folder_open),
                tooltip: "Change Folder",
                onPressed: _promptPathSelection,
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                tooltip: "Refresh",
                onPressed: () => provider.refresh(currentFolderPath),
              ),
            ],
          ),
          body: sortedItems.isEmpty
              ? const Center(child: Text("This folder is empty."))
              : _buildContent(sortedItems),
        );
      },
    );
  }

  Widget _buildContent(List<_GridItem> items) {
    if (_viewMode == ViewMode.grid) {
      return _buildGridView(items);
    } else {
      return _buildListView(items);
    }
  }

  // --- Grid View Builder (UPDATED) ---
  Widget _buildGridView(List<_GridItem> items) {
    // Dynamically adjust aspect ratio for better look at different sizes
    double aspectRatio = _gridCrossAxisCount <= 3 ? 0.8 : 1.0;

    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _gridCrossAxisCount.toInt(), // Use state variable
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: aspectRatio, // Dynamic aspect ratio
      ),
      itemBuilder: (context, idx) {
        final item = items[idx];
        return item.isFolder
            ? _buildFolderTile(item.entity as Directory)
            : _buildMovieTile(item.entity as File);
      },
    );
  }

  // --- Sorting Logic ---

  // --- Grid View Builder ---

  // --- List View Builder ---
  Widget _buildListView(List<_GridItem> items) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return item.isFolder
            ? _buildFolderListItem(item.entity as Directory)
            : _buildMovieListItem(item.entity as File);
      },
    );
  }

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

  // --- WIDGETS FOR GRID VIEW ---

  Widget _buildFolderTile(Directory folder) {
    return InkWell(
      onTap: () => _openFolder(folder.path),
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.folder, color: Colors.amber, size: 80),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(
              folder.path.split(Platform.pathSeparator).last,
              style: const TextStyle(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieTile(File file) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VideoPlayerScreenLocal(videoUrl: file.path),
        ),
      ),
      borderRadius: BorderRadius.circular(12),
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: _buildThumbnail(file), // Re-usable thumbnail widget
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  file.path.split(Platform.pathSeparator).last,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGETS FOR LIST VIEW ---

  Widget _buildFolderListItem(Directory folder) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: ListTile(
        leading: const Icon(Icons.folder, color: Colors.amber, size: 40),
        title: Text(folder.path.split(Platform.pathSeparator).last),
        subtitle: Text("${folder.statSync().modified.toLocal()}"),
        onTap: () => _openFolder(folder.path),
      ),
    );
  }

  Widget _buildMovieListItem(File file) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: ListTile(
        leading: SizedBox(
          width: 80,
          height: 50,
          child: _buildThumbnail(file), // Re-usable thumbnail widget
        ),
        title: Text(
          file.path.split(Platform.pathSeparator).last,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          "${(file.statSync().size / (1024 * 1024)).toStringAsFixed(2)} MB",
        ),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => VideoPlayerScreenLocal(videoUrl: file.path),
          ),
        ),
      ),
    );
  }

  // --- RE-USABLE THUMBNAIL WIDGET ---

  Widget _buildThumbnail(File file) {
    // Use the provider to get the thumbnail
    final provider = Provider.of<LocalProvider>(context, listen: false);

    return FutureBuilder<Uint8List?>(
      future: provider.getThumbnail(file.path),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(strokeWidth: 2.0),
          );
        }
        if (snapshot.hasData && snapshot.data != null) {
          return Image.memory(
            snapshot.data!,
            fit: BoxFit.cover,
            gaplessPlayback: true, // Prevents flicker on reload
          );
        }
        // Fallback icon if thumbnail fails
        return Container(
          color: Colors.grey[300],
          child: const Icon(Icons.movie, color: Colors.grey, size: 48),
        );
      },
    );
  }
}

// A helper class to unify File and Directory for sorting purposes
class _GridItem {
  final FileSystemEntity entity;

  _GridItem(this.entity);

  bool get isFolder => entity is Directory;
  String get name => entity.path.split(Platform.pathSeparator).last;
}
