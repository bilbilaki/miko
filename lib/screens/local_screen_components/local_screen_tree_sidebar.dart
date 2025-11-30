import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import '../../widgets/icons/folder_icon_helper.dart';

/// Model for system directory shortcuts
class SystemDirectory {
  final String name;
  final String path;
  final FolderType type;
  final bool isDrive; // For Windows drives

  SystemDirectory({
    required this.name,
    required this.path,
    required this.type,
    this.isDrive = false,
  });
}

/// Helper to get platform-specific home directory path
class PlatformPaths {
  /// Get home directory based on platform
  static String? getHomePath() {
    if (Platform.isAndroid) {
      return '/storage/emulated/0';
    } else if (Platform.isLinux || Platform.isMacOS) {
      return Platform.environment['HOME'];
    } else if (Platform.isWindows) {
      return Platform.environment['USERPROFILE'];
    }
    return null;
  }

  /// Get available drive letters on Windows
  /// Uses parallel checks for better performance
  static Future<List<String>> getWindowsDrives() async {
    if (!Platform.isWindows) return [];

    // Create list of all possible drive paths A-Z
    final drivePaths = List.generate(
      26,
      (i) => '${String.fromCharCode(65 + i)}:\\',
    );

    // Check all drives in parallel
    final existChecks = await Future.wait(
      drivePaths.map((path) async {
        try {
          return await Directory(path).exists() ? path : null;
        } catch (e) {
          return null;
        }
      }),
    );

    // Filter out non-existent drives and return
    return existChecks.whereType<String>().toList();
  }

  /// Get standard directories based on platform
  static Future<List<SystemDirectory>> getSystemDirectories() async {
    final List<SystemDirectory> dirs = [];

    try {
      if (Platform.isAndroid) {
        // Android standard directories
        const androidBase = '/storage/emulated/0';
        final androidDirs = [
          ('DCIM', FolderType.images),
          ('Pictures', FolderType.images),
          ('Music', FolderType.music),
          ('Movies', FolderType.videos),
          ('Videos', FolderType.videos),
          ('Download', FolderType.downloads),
          ('Documents', FolderType.documents),
        ];

        for (final (name, type) in androidDirs) {
          final path = p.join(androidBase, name);
          if (await Directory(path).exists()) {
            dirs.add(SystemDirectory(name: name, path: path, type: type));
          }
        }
      } else if (Platform.isWindows) {
        // Windows: First add drives
        final drives = await getWindowsDrives();
        for (final drive in drives) {
          dirs.add(SystemDirectory(
            name: drive.replaceAll('\\', ''),
            path: drive,
            type: FolderType.generic,
            isDrive: true,
          ));
        }

        // Then add user directories
        final homePath = getHomePath();
        if (homePath != null && await Directory(homePath).exists()) {
          final commonDirs = [
            ('Desktop', FolderType.desktop),
            ('Documents', FolderType.documents),
            ('Downloads', FolderType.downloads),
            ('Music', FolderType.music),
            ('Pictures', FolderType.images),
            ('Videos', FolderType.videos),
          ];

          for (final (name, type) in commonDirs) {
            final path = p.join(homePath, name);
            if (await Directory(path).exists()) {
              dirs.add(SystemDirectory(name: name, path: path, type: type));
            }
          }
        }
      } else if (Platform.isLinux || Platform.isMacOS) {
        // Linux/macOS standard directories
        final homePath = getHomePath();
        if (homePath != null && await Directory(homePath).exists()) {
          final commonDirs = [
            ('Desktop', FolderType.desktop),
            ('Documents', FolderType.documents),
            ('Downloads', FolderType.downloads),
            ('Music', FolderType.music),
            ('Pictures', FolderType.images),
            ('Videos', FolderType.videos),
          ];

          for (final (name, type) in commonDirs) {
            final path = p.join(homePath, name);
            if (await Directory(path).exists()) {
              dirs.add(SystemDirectory(name: name, path: path, type: type));
            }
          }
        }
      }
    } catch (e) {
      // Silently fail if unable to load system directories
    }

    return dirs;
  }
}

/// A tree view sidebar showing directory structure
class TreeSidebar extends StatefulWidget {
  final String rootPath;
  final String? currentPath;
  final Function(String) onPathSelected;
  final double? width; // Now optional for responsive sizing
  final VoidCallback? onClose; // Close callback for mobile

  const TreeSidebar({
    super.key,
    required this.rootPath,
    this.currentPath,
    required this.onPathSelected,
    this.width,
    this.onClose,
  });

  @override
  State<TreeSidebar> createState() => _TreeSidebarState();
}

class _TreeSidebarState extends State<TreeSidebar> {
  final Map<String, bool> _expandedDirs = {};
  final Map<String, List<Directory>> _cachedSubdirs = {};
  final ScrollController _scrollController = ScrollController();
  List<SystemDirectory> _systemDirs = [];
  List<SystemDirectory> _drives = []; // Windows drives

  @override
  void initState() {
    super.initState();
    // Auto-expand root
    _expandedDirs[widget.rootPath] = true;
    _loadSubdirectories(widget.rootPath);
    _loadSystemDirectories();
  }

  Future<void> _loadSystemDirectories() async {
    final dirs = await PlatformPaths.getSystemDirectories();

    if (mounted) {
      setState(() {
        // Separate drives from other directories on Windows
        if (Platform.isWindows) {
          _drives = dirs.where((d) => d.isDrive).toList();
          _systemDirs = dirs.where((d) => !d.isDrive).toList();
        } else {
          _systemDirs = dirs;
        }
      });
    }
  }

  /// Navigate to home directory
  void _goToHome() {
    final homePath = PlatformPaths.getHomePath();
    if (homePath != null) {
      widget.onPathSelected(homePath);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadSubdirectories(String dirPath) async {
    if (_cachedSubdirs.containsKey(dirPath)) return;

    try {
      final dir = Directory(dirPath);
      if (!await dir.exists()) return;

      final entities = await dir.list().toList();
      final subdirs = entities
          .whereType<Directory>()
          .where(
              (d) => !p.basename(d.path).startsWith('.')) // Skip hidden folders
          .toList();

      subdirs.sort((a, b) => p.basename(a.path).toLowerCase().compareTo(
            p.basename(b.path).toLowerCase(),
          ));

      if (mounted) {
        setState(() {
          _cachedSubdirs[dirPath] = subdirs;
        });
      }
    } catch (e) {
      // Silently fail for permission errors, etc.
      if (mounted) {
        setState(() {
          _cachedSubdirs[dirPath] = [];
        });
      }
    }
  }

  void _toggleExpanded(String dirPath) {
    setState(() {
      _expandedDirs[dirPath] = !(_expandedDirs[dirPath] ?? false);
    });
    if (_expandedDirs[dirPath] == true) {
      _loadSubdirectories(dirPath);
    }
  }

  Widget _buildFolderIcon(String folderName) {
    // Using the FolderIconHelper with SVG support
    return FolderIconHelper.getIcon(folderName, size: 18);
  }

  Widget _buildSystemDirItem(SystemDirectory sysDir) {
    final isSelected = widget.currentPath != null &&
        p.equals(sysDir.path, widget.currentPath!);

    return InkWell(
      onTap: () => widget.onPathSelected(sysDir.path),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        color: isSelected
            ? Theme.of(context)
                .colorScheme
                .primaryContainer
                .withValues(alpha: 0.3)
            : null,
        child: Row(
          children: [
            // Show drive icon for Windows drives
            sysDir.isDrive
                ? Icon(Icons.storage,
                    size: 18, color: Theme.of(context).colorScheme.secondary)
                : FolderIconHelper.getIcon(sysDir.name, size: 18),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                sysDir.name,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color:
                      isSelected ? Theme.of(context).colorScheme.primary : null,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build drive item for Windows
  Widget _buildDriveItem(SystemDirectory drive) {
    final isSelected = widget.currentPath != null &&
        (widget.currentPath!.startsWith(drive.path) ||
            p.equals(drive.path, widget.currentPath!));

    return InkWell(
      onTap: () => widget.onPathSelected(drive.path),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        color: isSelected
            ? Theme.of(context)
                .colorScheme
                .primaryContainer
                .withValues(alpha: 0.3)
            : null,
        child: Row(
          children: [
            Icon(Icons.storage,
                size: 18, color: Theme.of(context).colorScheme.secondary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Local Disk (${drive.name})',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color:
                      isSelected ? Theme.of(context).colorScheme.primary : null,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTreeNode(String dirPath, int depth) {
    final isExpanded = _expandedDirs[dirPath] ?? false;
    final subdirs = _cachedSubdirs[dirPath] ?? [];
    final isSelected = widget.currentPath != null &&
        (dirPath == widget.currentPath ||
            p.equals(dirPath, widget.currentPath!));
    final folderName = p.basename(dirPath);
    final hasChildren = subdirs.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => widget.onPathSelected(dirPath),
          child: Container(
            padding: EdgeInsets.only(
              left: 8.0 + (depth * 16.0),
              right: 8.0,
              top: 6.0,
              bottom: 6.0,
            ),
            color: isSelected
                ? Theme.of(context)
                    .colorScheme
                    .primaryContainer
                    .withValues(alpha: 0.3)
                : null,
            child: Row(
              children: [
                // Expand/collapse arrow
                SizedBox(
                  width: 20,
                  child: hasChildren
                      ? GestureDetector(
                          onTap: () => _toggleExpanded(dirPath),
                          child: Icon(
                            isExpanded
                                ? Icons.keyboard_arrow_down
                                : Icons.keyboard_arrow_right,
                            size: 18,
                            color: Colors.grey[600],
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 4),
                // Folder icon (placeholder for SVG)
                _buildFolderIcon(folderName),
                const SizedBox(width: 8),
                // Folder name
                Expanded(
                  child: Text(
                    folderName,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : null,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
        // Children
        if (isExpanded && hasChildren)
          ...subdirs.map((subdir) => _buildTreeNode(subdir.path, depth + 1)),
      ],
    );
  }

  /// Calculate responsive width based on screen size
  double _calculateResponsiveWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 800;
    final isTablet = screenWidth > 600 && screenWidth <= 800;

    if (isDesktop) {
      // Desktop: fixed width or percentage of screen
      return widget.width ?? 280.0;
    } else if (isTablet) {
      // Tablet: slightly smaller
      return widget.width ?? 240.0;
    } else {
      // Mobile: full width when shown
      return widget.width ?? screenWidth * 0.75;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth <= 600;
    final responsiveWidth = _calculateResponsiveWidth(context);

    return Container(
      width: responsiveWidth,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          right: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with close button on mobile
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 8.0 : 12.0,
              vertical: isMobile ? 8.0 : 12.0,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.folder_open,
                  size: isMobile ? 18 : 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(width: isMobile ? 4 : 8),
                Expanded(
                  child: Text(
                    'Navigation',
                    style: TextStyle(
                      fontSize: isMobile ? 12 : 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Home button
                IconButton(
                  icon: Icon(Icons.home, size: isMobile ? 18 : 20),
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(
                    minWidth: isMobile ? 32 : 40,
                    minHeight: isMobile ? 32 : 40,
                  ),
                  tooltip: 'Go to Home',
                  onPressed: _goToHome,
                ),
                // Close button (only show on mobile or if close callback provided)
                if (isMobile || widget.onClose != null) ...[
                  IconButton(
                    icon: Icon(Icons.close, size: isMobile ? 18 : 20),
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(
                      minWidth: isMobile ? 32 : 40,
                      minHeight: isMobile ? 32 : 40,
                    ),
                    tooltip: 'Close',
                    onPressed: widget.onClose ??
                        () {
                          // Default behavior: navigate back if possible
                          Navigator.of(context).maybePop();
                        },
                  ),
                ],
              ],
            ),
          ),
          // Tree view
          Expanded(
            child: Scrollbar(
              controller: _scrollController,
              thumbVisibility: true,
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Windows Drives Section (only on Windows)
                    if (Platform.isWindows && _drives.isNotEmpty) ...[
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          isMobile ? 8 : 12,
                          isMobile ? 8 : 12,
                          isMobile ? 8 : 12,
                          6,
                        ),
                        child: Text(
                          'Drives',
                          style: TextStyle(
                            fontSize: isMobile ? 10 : 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      ..._drives.map((drive) => _buildDriveItem(drive)),
                      const Divider(height: 16),
                    ],
                    // System Directories Section
                    if (_systemDirs.isNotEmpty) ...[
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          isMobile ? 8 : 12,
                          isMobile ? 8 : 12,
                          isMobile ? 8 : 12,
                          6,
                        ),
                        child: Text(
                          'Quick Access',
                          style: TextStyle(
                            fontSize: isMobile ? 10 : 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      ..._systemDirs
                          .map((sysDir) => _buildSystemDirItem(sysDir)),
                      const Divider(height: 16),
                    ],
                    // Current Root Directory
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        isMobile ? 8 : 12,
                        8,
                        isMobile ? 8 : 12,
                        6,
                      ),
                      child: Text(
                        'Current Location',
                        style: TextStyle(
                          fontSize: isMobile ? 10 : 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    _buildTreeNode(widget.rootPath, 0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A wrapper widget that provides a collapsible sidebar
/// Responsive: uses drawer on mobile, inline sidebar on desktop
class CollapsibleTreeSidebar extends StatefulWidget {
  final String rootPath;
  final String? currentPath;
  final Function(String) onPathSelected;
  final Widget child;

  const CollapsibleTreeSidebar({
    super.key,
    required this.rootPath,
    this.currentPath,
    required this.onPathSelected,
    required this.child,
  });

  @override
  State<CollapsibleTreeSidebar> createState() => _CollapsibleTreeSidebarState();
}

class _CollapsibleTreeSidebarState extends State<CollapsibleTreeSidebar> {
  bool _isSidebarVisible = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _toggleSidebar() {
    setState(() {
      _isSidebarVisible = !_isSidebarVisible;
    });
  }

  void _closeSidebar() {
    setState(() {
      _isSidebarVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth <= 600;
    final isTablet = screenWidth > 600 && screenWidth <= 800;

    // On mobile, use a drawer-like overlay
    if (isMobile) {
      return Stack(
        children: [
          // Main content
          widget.child,
          // Toggle button (floating)
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 28,
              color: Theme.of(context)
                  .colorScheme
                  .surfaceContainerHighest
                  .withValues(alpha: 0.9),
              child: Center(
                child: IconButton(
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                  iconSize: 18,
                  icon: Icon(
                    _isSidebarVisible
                        ? Icons.chevron_left
                        : Icons.chevron_right,
                  ),
                  onPressed: _toggleSidebar,
                  tooltip: _isSidebarVisible ? 'Hide sidebar' : 'Show sidebar',
                ),
              ),
            ),
          ),
          // Sidebar overlay
          if (_isSidebarVisible)
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              right: 0, // Cover entire screen
              child: Row(
                children: [
                  // Sidebar
                  Material(
                    elevation: 8,
                    child: TreeSidebar(
                      rootPath: widget.rootPath,
                      currentPath: widget.currentPath,
                      onPathSelected: (path) {
                        widget.onPathSelected(path);
                        // Auto-close on mobile after selection
                        _closeSidebar();
                      },
                      onClose: _closeSidebar,
                    ),
                  ),
                  // Tap outside to close - Expanded fills remaining space
                  Expanded(
                    child: GestureDetector(
                      onTap: _closeSidebar,
                      child: Container(
                        color: Colors.black38,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      );
    }

    // On tablet/desktop, use inline sidebar with toggle
    return Row(
      children: [
        // Sidebar (collapsible)
        if (_isSidebarVisible)
          TreeSidebar(
            rootPath: widget.rootPath,
            currentPath: widget.currentPath,
            onPathSelected: widget.onPathSelected,
            width: isTablet ? 220 : 280, // Smaller on tablet
          ),
        // Toggle button
        Container(
          width: 24,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            border: Border(
              right: _isSidebarVisible
                  ? BorderSide.none
                  : BorderSide(
                      color: Theme.of(context).dividerColor,
                      width: 1,
                    ),
            ),
          ),
          child: Center(
            child: IconButton(
              padding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
              iconSize: 18,
              icon: Icon(
                _isSidebarVisible ? Icons.chevron_left : Icons.chevron_right,
              ),
              onPressed: _toggleSidebar,
              tooltip: _isSidebarVisible ? 'Hide sidebar' : 'Show sidebar',
            ),
          ),
        ),
        // Main content
        Expanded(child: widget.child),
      ],
    );
  }
}
