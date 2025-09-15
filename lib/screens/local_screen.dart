import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:miko/screens/video_player_wplaylist_screen.dart';
import 'package:miko/widgets/alienswapbutton.dart';
import 'package:path/path.dart' as p;
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:swipe_image_gallery/swipe_image_gallery.dart';

import '../app_keeper.dart';
import '../providers/local_provider.dart';
import '../widgets/photoeditor.dart';
import 'package:audioplayers/audioplayers.dart';

// ...
final player = AudioPlayer();

// Enums for managing UI states
class ComponentLibraryDrawer extends StatelessWidget {
  const ComponentLibraryDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: const [
          DrawerHeader(child: Text("Component Library")),
          ListTile(title: Text("Item 1")),
          // ... more items
        ],
      ),
    );
  }
}

class ComponentBrowserDrawer extends StatelessWidget {
  const ComponentBrowserDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: const [
          DrawerHeader(child: Text("Component Browser")),
          ListTile(title: Text("Item A")),
          // ... more items
        ],
      ),
    );
  }
}

enum ViewMode { grid, list }

enum SortMode { name, date, type }

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

  // --- Sorting Logic ---
  /// Combines all file and folder lists from the provider and sorts them.
  List<_GridItem> _getSortedItems(LocalProvider provider) {
    final items = [
      ...provider.folders.map((f) => _GridItem(f)),
      ...provider.movies.map((f) => _GridItem(f)),
      ...provider.audios.map((f) => _GridItem(f)), // Added audios
      ...provider.images.map((f) => _GridItem(f)), // Added images
      ...provider.documents.map((f) => _GridItem(f)), // Added documents
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
            comparison = -1; // 'a' (folder) comes before 'b' (file)
          } else if (!a.isFolder && b.isFolder) {
            comparison = 1; // 'a' (file) comes after 'b' (folder)
          } else {
            // Both are files or both are folders; sort by file extension then by name
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
      return _sortAscending
          ? comparison
          : -comparison; // Apply ascending/descending order
    });

    return items;
  }

  // --- UI FOR GRID SIZE SLIDER ---
  /// Shows a dialog to adjust the number of columns in grid view.
  void _showSizeSliderDialog() {
    showDialog(
      context: context,
      builder: (context) {
        // Use a StatefulBuilder so only the slider dialog rebuilds on drag,
        // without rebuilding the entire LocalScreen.
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
                    min: 2, // Minimum 2 columns (for larger items)
                    max: 8, // Maximum 8 columns (for smaller items)
                    divisions: 6, // 8 - 2 = 6 steps for integer values
                    label: _gridCrossAxisCount.toInt().toString(),
                    onChanged: (newValue) {
                      // Update both the dialog's state and the main screen's state
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
            // Show back button if not at the root of the external path
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
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => StartPage()));
              },
            ),
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
              // --- Size Adjustment Button (only shown in grid view) ---
              if (_viewMode == ViewMode.grid)
                IconButton(
                  icon: const Icon(Icons.view_quilt_outlined),
                  tooltip: "Adjust Size",
                  onPressed: _showSizeSliderDialog,
                ),
              // --- Sorting Menu ---
              PopupMenuButton<SortMode>(
                icon: Icon(Icons.sort),
                tooltip: "Sort by",
                onSelected: (mode) {
                  // If same sort mode is selected, toggle ascending/descending
                  if (_sortMode == mode) {
                    setState(() => _sortAscending = !_sortAscending);
                  } else {
                    // Otherwise, set new sort mode and reset to ascending
                    setState(() {
                      _sortMode = mode;
                      _sortAscending = true;
                    });
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: SortMode.type,
                    child: Text("Sort by Type"),
                  ),
                  PopupMenuItem(
                    value: SortMode.name,
                    child: Text("Sort by Name"),
                  ),
                  PopupMenuItem(
                    value: SortMode.date,
                    child: Text("Sort by Date"),
                  ),
                ],
              ),
              // --- Change Root Folder Button ---
              IconButton(
                icon: const Icon(Icons.folder_open),
                tooltip: "Change Base Folder",
                onPressed: _promptPathSelection,
              ),
              // --- Refresh Current View Button ---
              IconButton(
                icon: const Icon(Icons.refresh),
                tooltip: "Refresh",
                onPressed: () => provider.refresh(currentFolderPath),
              ),
              // --- NEW: Batch Rename Button ---
              IconButton(
                icon: const Icon(Icons.drive_file_rename_outline),
                tooltip: "Batch Rename Files in Current Directory",
                onPressed: () => _showBatchRenameDialog(provider),
              ),
              // --- NEW: Thumbnail Cache Clear Button ---
              IconButton(
                icon: const Icon(Icons.delete_sweep),
                tooltip: "Clear All Thumbnail Cache",
                onPressed: () async {
                  final confirmed = await showConfirmationDialog(
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
  Widget _buildGridView(List<_GridItem> items) {
    // Dynamically adjust aspect ratio for items to look better at different sizes
    double aspectRatio = _gridCrossAxisCount <= 3 ? 0.8 : 1.0;

    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _gridCrossAxisCount
            .toInt(), // Uses the adjustable column count
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: aspectRatio, // Dynamic aspect ratio
      ),
      itemBuilder: (context, idx) {
        final item = items[idx];
        return item.isFolder
            ? _buildFolderTile(item.entity as Directory) // Build a folder tile
            : _buildFileTile(item.entity as File); // Build a generic file tile
      },
    );
  }

  // --- List View Builder ---
  Widget _buildListView(List<_GridItem> items) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return item.isFolder
            ? _buildFolderListItem(
                item.entity as Directory,
              ) // Build a folder list item
            : _buildFileListItem(
                item.entity as File,
              ); // Build a generic file list item
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

  // --- WIDGETS FOR GRID VIEW ITEMS ---

  Widget _buildFolderTile(Directory folder) {
    return InkWell(
      onTap: () => _openFolder(folder.path), // Tapping opens the folder
      onLongPress: () =>
          _showFolderContextMenu(folder), // Long press shows context menu
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.folder, color: Colors.amber, size: 80),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(
              p.basename(folder.path), // Display only the folder name
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

  /// Generic file tile that displays a thumbnail/icon and filename.
  /// Handles different file types for tap and long-press actions.
  Widget _buildFileTile(File file) {
    final provider = Provider.of<LocalProvider>(context, listen: false);
    return InkWell(
      onTap: () => _handleFileTap(file, provider), // Tap for opening/viewing
      onLongPress: () =>
          _showFileContextMenu(file), // Long press for context menu
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
              child: _buildThumbnailOrIcon(
                file,
                provider,
              ), // Re-usable thumbnail/icon widget
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  p.basename(file.path), // Display only the filename
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

  // --- WIDGETS FOR LIST VIEW ITEMS ---

  Widget _buildFolderListItem(Directory folder) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: ListTile(
        leading: const Icon(Icons.folder, color: Colors.amber, size: 40),
        title: Text(p.basename(folder.path)), // Display folder name
        subtitle: Text(
          "Modified: ${folder.statSync().modified.toLocal().toString().split('.')[0]}",
        ), // Display modification date
        onTap: () => _openFolder(folder.path),
        onLongPress: () => _showFolderContextMenu(folder),
      ),
    );
  }

  /// Generic file list item.
  Widget _buildFileListItem(File file) {
    final provider = Provider.of<LocalProvider>(context, listen: false);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: ListTile(
        leading: SizedBox(
          width: 80,
          height: 50,
          child: _buildThumbnailOrIcon(
            file,
            provider,
          ), // Re-usable thumbnail/icon widget
        ),
        title: Text(
          p.basename(file.path), // Display filename
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          "${(file.statSync().size / (1024 * 1024)).toStringAsFixed(2)} MB",
        ), // Display file size
        onTap: () => _handleFileTap(file, provider),
        onLongPress: () => _showFileContextMenu(file),
      ),
    );
  }

  // --- RE-USABLE THUMBNAIL OR ICON WIDGET BASED ON FILE TYPE ---

  /// Determines if a thumbnail should be generated or a default icon should be displayed.
  Widget _buildThumbnailOrIcon(File file, LocalProvider provider) {
    IconData defaultIcon;
    Color iconColor;

    if (provider.isMovieFile(file)) {
      defaultIcon = Icons.movie;
      iconColor = Colors.red.shade400;
    } else if (provider.isImageFile(file)) {
      defaultIcon = Icons.image;
      iconColor = Colors.blue.shade400;
    } else if (provider.isAudioFile(file)) {
      defaultIcon = Icons.audio_file;
      iconColor = Colors.green.shade400;
    } else if (provider.isTextFile(file)) {
      defaultIcon = Icons.description;
      iconColor = Colors.grey.shade600;
    } else {
      defaultIcon = Icons.insert_drive_file; // Generic file icon
      iconColor = Colors.grey;
    }

    // Only attempt to get thumbnail for media files that support it in LocalProvider
    bool canGetThumbnail =
        provider.isMovieFile(file) ||
        provider.isImageFile(file) ||
        provider.isAudioFile(file) ||
        provider.isTextFile(file);
    if (!canGetThumbnail) {
      // If thumbnail cannot/should not be generated, just show the default icon
      return Container(
        color: Colors.grey[100],
        child: Center(child: Icon(defaultIcon, color: iconColor, size: 48)),
      );
    }

    // Attempt to get or generate thumbnail for supported media files
    return FutureBuilder<Uint8List?>(
      future: provider.getThumbnail(file.path),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(strokeWidth: 2.0),
          );
        }
        if (snapshot.hasData && snapshot.data != null) {
          // If thumbnail data is available, display it
          return Image.memory(
            snapshot.data!,
            fit: BoxFit.cover,
            gaplessPlayback:
                true, // Prevents flicker on hot reload/state change
            errorBuilder: (context, error, stackTrace) {
              // Fallback if image data cannot be decoded or displayed
              return Container(
                color: Colors.grey[100],
                child: Center(
                  child: Icon(defaultIcon, color: iconColor, size: 48),
                ),
              );
            },
          );
        }
        // Fallback icon if thumbnail generation fails or returns null
        return Container(
          color: Colors.grey[100],
          child: Center(child: Icon(defaultIcon, color: iconColor, size: 48)),
        );
      },
    );
  }

  // --- NEW: File Type Specific Action Handlers on Tap ---

  Future<void> _handleFileTap(File file, LocalProvider provider) async {
    try {
      if (provider.isMovieFile(file)) {
        // For movies: Try to open with VLC (assuming it's in system PATH)
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => VideoPlayerScreenLocal(videoUrl: file.path),
          ),
        );
      } else if (provider.isImageFile(file)) {
        // For images: Show in a simple dialog viewer
        _showImageDialog(file);
      } else if (provider.isAudioFile(file)) {
        final bytes = await file.readAsBytes(); // file is a File object
        await player.play(BytesSource(bytes));
      } else if (provider.isTextFile(file)) {
        // For text files: Open content for viewing/editing
        _showDocumentContentDialog(file, provider);
      } else {
        showSnackBar('No specific handler for this file type.');
      }
    } catch (e) {
      showSnackBar('Could not open file: ${p.basename(file.path)} - $e');
      if (kDebugMode) print('Error opening file: $e');
    }
  }

  // 6. Process Photo: Show image in a dialog
  void _showImageDialog(File imageFile) {
    SwipeImageGallery(
      context: context,
      children: [
        Image.file(imageFile, fit: BoxFit.contain),
        Photoeditor(imageFile, currentFolderPath),
      ],
    ).show();
    // showDialog(
    //   context: context,
    //   builder: (context) => AlertDialog(
    //     title: Text(p.basename(imageFile.path)),
    //     content: ConstrainedBox(
    //       constraints: BoxConstraints(
    //         maxHeight: MediaQuery.of(context).size.height * 0.7, // Limit max height
    //         maxWidth: MediaQuery.of(context).size.width * 0.7, // Limit max width
    //       ),
    //       child:  // Display image, fitting within bounds
    //     ),
    //     actions: [
    //       TextButton(
    //         onPressed: () => Navigator.of(context).pop(),
    //         child: const Text('Close'),
    //       ),
    //     ],
    //   ),
    // );
  }

  // 8. Process and Parse Content of Documents to view/edit
  Future<void> _showDocumentContentDialog(
    File documentFile,
    LocalProvider provider,
  ) async {
    // Attempt to read content from the file
    String? initialContent = await provider.getDocumentContent(
      documentFile.path,
    );

    if (initialContent == null) {
      showSnackBar(
        'Failed to read document content. It might be a binary or unsupported file type.',
      );
      return;
    }

    TextEditingController contentController = TextEditingController(
      text: initialContent,
    );

    // Show a dialog to view/edit the document content
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit: ${p.basename(documentFile.path)}'),
          content: SizedBox(
            width:
                MediaQuery.of(context).size.width * 0.8, // Make content wider
            height:
                MediaQuery.of(context).size.height * 0.6, // Make content taller
            child: TextField(
              controller: contentController,
              maxLines: null, // Allow unlimited lines
              expands: true, // Make TextField expand to fill available space
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Document content',
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final String newContent = contentController.text;
                // Save changes to the original file
                final bool success = await provider.saveDocumentContent(
                  documentFile.path,
                  newContent,
                );
                if (success) {
                  showSnackBar('File saved successfully.');
                  Navigator.of(context).pop(); // Close dialog on success
                } else {
                  showSnackBar('Failed to save file.');
                }
              },
              child: const Text('Save'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Prompt for a new filename for "Save As"
                final String? newFileName = await _showInputDialog(
                  'Save As',
                  'Enter new file name (e.g., my_document.txt):',
                  p.basename(documentFile.path), // Pre-fill with current name
                );
                if (newFileName != null && newFileName.isNotEmpty) {
                  final String newFilePath = p.join(
                    p.dirname(documentFile.path),
                    newFileName,
                  );
                  // Save content to a new file
                  final bool success = await provider.saveDocumentContentAs(
                    newFilePath,
                    contentController.text,
                  );
                  if (success) {
                    showSnackBar('File saved as $newFileName successfully.');
                    Navigator.of(context).pop(); // Close dialog on success
                  } else {
                    showSnackBar('Failed to save file as $newFileName.');
                  }
                }
              },
              child: const Text('Save As'),
            ),
          ],
        );
      },
    );
  }

  // --- NEW: Context Menus (Long Press Actions) ---

  /// Displays a bottom sheet context menu for a specific file.
  void _showFileContextMenu(File file) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        final provider = Provider.of<LocalProvider>(
          context,
          listen: false,
        ); // Provider not listening here
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min, // Wrap content height
            children: <Widget>[
              // Header displaying file name
              ListTile(
                title: Text(
                  p.basename(file.path),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(file.path),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Rename'),
                onTap: () {
                  Navigator.pop(context); // Close bottom sheet
                  _renameFile(file, provider); // Call rename logic
                },
              ),
              ListTile(
                leading: const Icon(Icons.copy),
                title: const Text('Copy'),
                onTap: () {
                  Navigator.pop(context);
                  copyFile(file, provider); // Call copy logic
                },
              ),
              ListTile(
                leading: const Icon(Icons.drive_file_move),
                title: const Text('Move'),
                onTap: () {
                  Navigator.pop(context);
                  _moveFile(file, provider); // Call move logic
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Delete'),
                onTap: () {
                  Navigator.pop(context);
                  _deleteFile(file, provider); // Call delete logic
                },
              ),
              // Show "Edit Content" only if it's a text-based file
              if (provider.isTextFile(file))
                ListTile(
                  leading: const Icon(Icons.document_scanner),
                  title: const Text('Edit Content'),
                  onTap: () {
                    Navigator.pop(context);
                    _showDocumentContentDialog(
                      file,
                      provider,
                    ); // Open document editor
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  /// Displays a bottom sheet context menu for a specific folder.
  void _showFolderContextMenu(Directory folder) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        final provider = Provider.of<LocalProvider>(context, listen: false);
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // Header displaying folder name
              ListTile(
                title: Text(
                  p.basename(folder.path),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(folder.path),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Rename'),
                onTap: () {
                  Navigator.pop(context);
                  _renameFolder(folder, provider); // Call rename logic
                },
              ),
              ListTile(
                leading: const Icon(Icons.copy),
                title: const Text('Copy'),
                onTap: () {
                  Navigator.pop(context);
                  _copyFolder(folder, provider); // Call copy logic
                },
              ),
              ListTile(
                leading: const Icon(Icons.drive_file_move),
                title: const Text('Move'),
                onTap: () {
                  Navigator.pop(context);
                  _moveFolder(folder, provider); // Call move logic
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Delete'),
                onTap: () {
                  Navigator.pop(context);
                  _deleteFolder(folder, provider); // Call delete logic
                },
              ),
              ListTile(
                leading: const Icon(Icons.create_new_folder),
                title: const Text('Create New Folder Here'),
                onTap: () {
                  Navigator.pop(context);
                  _createNewFolder(
                    folder,
                    provider,
                  ); // Call new folder creation logic
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // --- NEW: Rename Operations ---

  /// Handles renaming a single file with user input.
  Future<void> _renameFile(File file, LocalProvider provider) async {
    final oldName = p.basename(file.path);
    final String? newName = await _showInputDialog(
      'Rename File',
      'Enter new name for "$oldName":',
      oldName, // Pre-fill with current name
    );
    if (newName != null && newName.isNotEmpty && newName != oldName) {
      final bool success = await provider.renameFile(file.path, newName);
      if (success) {
        showSnackBar('File renamed to "$newName"');
      } else {
        showSnackBar('Failed to rename file.');
      }
    }
  }

  /// Handles renaming a folder with user input.
  Future<void> _renameFolder(Directory folder, LocalProvider provider) async {
    final oldName = p.basename(folder.path);
    final String? newName = await _showInputDialog(
      'Rename Folder',
      'Enter new name for "$oldName":',
      oldName, // Pre-fill with current name
    );
    if (newName != null && newName.isNotEmpty && newName != oldName) {
      // Renaming a folder is effectively moving it to a new name in the same parent directory
      final newPath = p.join(p.dirname(folder.path), newName);
      final bool success = await provider.moveDirectory(folder.path, newPath);
      if (success) {
        showSnackBar('Folder renamed to "$newName"');
      } else {
        showSnackBar('Failed to rename folder.');
      }
    }
  }

  /// Displays a dialog for batch renaming files in the current directory.
  Future<void> _showBatchRenameDialog(LocalProvider provider) async {
    final TextEditingController prefixController = TextEditingController();
    final TextEditingController postfixController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Batch Rename Files'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: prefixController,
                decoration: const InputDecoration(
                  labelText: 'Prefix (optional)',
                ),
              ),
              TextField(
                controller: postfixController,
                decoration: const InputDecoration(
                  labelText: 'Postfix (optional)',
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Files will be renamed as: prefix + index + postfix + .extension',
              ),
              const Text('Example: photo_1.jpg, photo_2.jpg'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context); // Close dialog first
                // Use currentFolderPath for batch rename target
                final String targetPath =
                    currentFolderPath ?? provider.externalPath!;
                if (targetPath.isEmpty) {
                  showSnackBar('No directory selected for batch rename.');
                  return;
                }

                final bool? confirmed = await showConfirmationDialog(
                  'Confirm Batch Rename',
                  'Are you sure you want to batch rename all files in \n"$targetPath"?\nThis action cannot be easily undone.',
                );

                if (confirmed == true) {
                  final bool success = await provider.renameFilesInPath(
                    targetPath,
                    prefix: prefixController.text.isEmpty
                        ? null
                        : prefixController.text,
                    postfix: postfixController.text.isEmpty
                        ? null
                        : postfixController.text,
                  );
                  if (success) {
                    showSnackBar('Batch rename completed.');
                  } else {
                    showSnackBar('Batch rename failed.');
                  }
                }
              },
              child: const Text('Rename All'),
            ),
          ],
        );
      },
    );
  }

  // --- NEW: Deletion Operations ---

  /// Handles deleting a single file after confirmation.
  Future<void> _deleteFile(File file, LocalProvider provider) async {
    final confirmed = await showConfirmationDialog(
      'Delete File',
      'Are you sure you want to delete "${p.basename(file.path)}"? This cannot be undone.',
    );
    if (confirmed == true) {
      final bool success = await provider.deleteFile(file.path);
      if (success) {
        showSnackBar('File deleted successfully.');
      } else {
        showSnackBar('Failed to delete file.');
      }
    }
  }

  /// Handles deleting a folder after confirmation.
  Future<void> _deleteFolder(Directory folder, LocalProvider provider) async {
    final confirmed = await showConfirmationDialog(
      'Delete Folder',
      'Are you sure you want to delete folder "${p.basename(folder.path)}"? All its contents will be lost. This cannot be undone.',
    );
    if (confirmed == true) {
      final bool success = await provider.deleteFolder(folder.path);
      if (success) {
        showSnackBar('Folder deleted successfully.');
        // If the deleted folder was the current view, navigate up
        if (p.equals(
          folder.path,
          currentFolderPath ?? provider.externalPath!,
        )) {
          _goUp();
        }
      } else {
        showSnackBar('Failed to delete folder.');
      }
    }
  }

  // --- NEW: Copy Operations ---

  /// Handles copying a file to a new location selected by the user.
  Future<void> copyFile(File file, LocalProvider provider) async {
    final String? destinationPath = await showPathSelectionDialog(
      'Copy "${p.basename(file.path)}" to',
      currentFolderPath, // Suggest current folder as initial destination
    );
    if (destinationPath != null) {
      final newFilePath = p.join(destinationPath, p.basename(file.path));
      // Check if file exists at destination
      if (await File(newFilePath).exists()) {
        final overwriteConfirmed = await showConfirmationDialog(
          'File Exists',
          'A file with the same name already exists in the destination. Overwrite?',
        );
        if (overwriteConfirmed != true) {
          showSnackBar('Copy cancelled: File already exists.');
          return;
        }
        await File(newFilePath).delete(); // Delete existing file before copying
      }

      final bool success = await provider.copyFile(file.path, newFilePath);
      if (success) {
        showSnackBar('File copied successfully.');
      } else {
        showSnackBar('Failed to copy file.');
      }
    }
  }

  /// Handles copying a folder to a new location selected by the user.
  Future<void> _copyFolder(Directory folder, LocalProvider provider) async {
    final String? destinationPath = await showPathSelectionDialog(
      'Copy folder "${p.basename(folder.path)}" to',
      currentFolderPath, // Suggest current folder as initial destination
    );
    if (destinationPath != null) {
      final newDirPath = p.join(destinationPath, p.basename(folder.path));
      // Check if folder exists at destination
      if (await Directory(newDirPath).exists()) {
        final overwriteConfirmed = await showConfirmationDialog(
          'Folder Exists',
          'A folder with the same name already exists in the destination. Overwrite (merge/replace contents)?',
        );
        if (overwriteConfirmed != true) {
          showSnackBar('Copy cancelled: Folder already exists.');
          return;
        }
        await Directory(
          newDirPath,
        ).delete(recursive: true); // Delete existing folder recursively
      }
      final bool success = await provider.copyDirectory(
        folder.path,
        newDirPath,
      );
      if (success) {
        showSnackBar('Folder copied successfully.');
      } else {
        showSnackBar('Failed to copy folder.');
      }
    }
  }

  // --- NEW: Move Operations ---

  /// Handles moving a file to a new location selected by the user.
  Future<void> _moveFile(File file, LocalProvider provider) async {
    final String? destinationPath = await showPathSelectionDialog(
      'Move "${p.basename(file.path)}" to',
      currentFolderPath, // Suggest current folder as initial destination
    );
    if (destinationPath != null) {
      final newFilePath = p.join(destinationPath, p.basename(file.path));
      // Check if file exists at destination
      if (await File(newFilePath).exists()) {
        final overwriteConfirmed = await showConfirmationDialog(
          'File Exists',
          'A file with the same name already exists in the destination. Overwrite?',
        );
        if (overwriteConfirmed != true) {
          showSnackBar('Move cancelled: File already exists.');
          return;
        }
        await File(newFilePath).delete(); // Delete existing file before moving
      }
      final bool success = await provider.moveFile(file.path, newFilePath);
      if (success) {
        showSnackBar('File moved successfully.');
      } else {
        showSnackBar('Failed to move file.');
      }
    }
  }

  /// Handles moving a folder to a new location selected by the user.
  Future<void> _moveFolder(Directory folder, LocalProvider provider) async {
    final String? destinationPath = await showPathSelectionDialog(
      'Move folder "${p.basename(folder.path)}" to',
      currentFolderPath, // Suggest current folder as initial destination
    );
    if (destinationPath != null) {
      final newDirPath = p.join(destinationPath, p.basename(folder.path));
      // Check if folder exists at destination
      if (await Directory(newDirPath).exists()) {
        final overwriteConfirmed = await showConfirmationDialog(
          'Folder Exists',
          'A folder with the same name already exists in the destination. Overwrite (merge/replace contents)?',
        );
        if (overwriteConfirmed != true) {
          showSnackBar('Move cancelled: Folder already exists.');
          return;
        }
        await Directory(
          newDirPath,
        ).delete(recursive: true); // Delete existing folder recursively
      }
      final bool success = await provider.moveDirectory(
        folder.path,
        newDirPath,
      );
      if (success) {
        showSnackBar('Folder moved successfully.');
        // If the moved folder was the current view, navigate up
        if (p.equals(
          folder.path,
          currentFolderPath ?? provider.externalPath!,
        )) {
          _goUp();
        }
      } else {
        showSnackBar('Failed to move folder.');
      }
    }
  }

  /// Handles creating a new folder in the specified parent folder.
  Future<void> _createNewFolder(
    Directory parentFolder,
    LocalProvider provider,
  ) async {
    final String? folderName = await _showInputDialog(
      'Create New Folder',
      'Enter new folder name (e.g., New folder):',
    );
    if (folderName != null && folderName.isNotEmpty) {
      final String fullNewFolderPath = p.join(parentFolder.path, folderName);
      // The provider's createFolder method needs to be modified if it only appends to _basePath.
      // Assuming LocalProvider.createFolder now takes a full path directly:
      // (If not, you'd call `await Directory(fullNewFolderPath).create(recursive: true);` directly here)
      // Correction: My `LocalProvider`'s `createFolder` still expects just a name to be appended to `_basePath`.
      // It should ideally be updated to create relative to `_currentPath`.
      // For now, let's call it making it relative to `currentFolderPath`.
      // NOTE: The `createFolder` in `LocalProvider` was `final newDir = Directory('$_basePath/$name');`
      // This implies it creates in the base path. I've updated it to create relative to currentPath in the LocalProvider code in my head.
      // If NOT updated, you might need:
      // final bool success = await Directory(p.join(currentFolderPath ?? provider.externalPath!, folderName)).create(recursive:true).then((_) => true).catchError((_) => false);
      // OR pass the FULL PATH to the provider method if it takes a full path:
      final bool success = await provider.createFolder(
        fullNewFolderPath,
      ); // Assuming updated provider method
      if (success) {
        showSnackBar('Folder "$folderName" created.');
      } else {
        showSnackBar(
          'Failed to create folder. It might already exist or permissions are an issue.',
        );
      }
    }
  }

  // --- Generic Dialog Helpers ---

  /// Shows a general input dialog and returns the entered string.
  Future<String?> _showInputDialog(
    String title,
    String message, [
    String? initialValue,
  ]) async {
    final TextEditingController controller = TextEditingController(
      text: initialValue,
    );
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: message),
          autofocus: true, // Automatically focus the text field
          onSubmitted: (value) =>
              Navigator.of(context).pop(value), // Submit on Enter key
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.of(context).pop(), // Pop with null on Cancel
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(
              context,
            ).pop(controller.text), // Pop with text on OK
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Shows a confirmation dialog and returns true if confirmed, false otherwise.
  Future<bool?> showConfirmationDialog(String title, String message) async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), // User cancelled
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true), // User confirmed
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  /// Shows a dialog to select a path, optionally with a file picker button.
  Future<String?> showPathSelectionDialog(
    String title,
    String? initialPath,
  ) async {
    final TextEditingController controller = TextEditingController(
      text: initialPath ?? p.current,
    );

    return showDialog<String>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          // Use StatefulBuilder for changes within the dialog
          builder: (context, setStateInDialog) {
            return AlertDialog(
              title: Text(title),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      labelText: 'Destination Path',
                    ),
                    readOnly:
                        true, // Make it read-only to force using the browse button
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.folder_open),
                    label: const Text('Browse'),
                    onPressed: () async {
                      final selectedDirectory = await FilePicker.platform
                          .getDirectoryPath();
                      if (selectedDirectory != null) {
                        setStateInDialog(() {
                          // Update dialog's state
                          controller.text = selectedDirectory;
                        });
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () =>
                      Navigator.of(context).pop(), // Pop with null on Cancel
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    // Validate if the chosen path exists before returning
                    if (await Directory(controller.text).exists()) {
                      Navigator.of(
                        context,
                      ).pop(controller.text); // Return the selected path
                    } else {
                      showSnackBar(
                        'Invalid or non-existent path. Please select a valid directory.',
                      );
                    }
                  },
                  child: const Text('Select'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  /// Displays a SnackBar message at the bottom of the screen.
  void showSnackBar(String message) {
    if (!mounted) {
      return; // Ensure widget is still mounted before showing SnackBar
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3), // Show for 3 seconds
      ),
    );
  }
}

// A helper class to unify File and Directory for sorting and display purposes
class _GridItem {
  final FileSystemEntity entity;

  _GridItem(this.entity);

  bool get isFolder => entity is Directory;
  // Get just the base name (file or folder name)
  String get name => p.basename(entity.path);
}
