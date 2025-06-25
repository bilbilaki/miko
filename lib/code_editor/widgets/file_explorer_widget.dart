import 'package:flutter/material.dart';

class FileExplorerWidget extends StatefulWidget {
  final bool isDark;
  final Function(Map<String, dynamic>)? onFileSelected;

  const FileExplorerWidget({
    super.key,
    required this.isDark,
    this.onFileSelected,
  });

  @override
  State<FileExplorerWidget> createState() => _FileExplorerWidgetState();
}

class _FileExplorerWidgetState extends State<FileExplorerWidget> {
  final Map<String, bool> _expandedFolders = {
    'lib': true,
    'assets': false,
    'test': false,
    'android': false,
    'ios': false,
    'web': false,
  };

  final List<Map<String, dynamic>> _fileStructure = [
    {
      'name': 'lib',
      'type': 'folder',
      'children': [
        {'name': 'main.dart', 'type': 'file', 'path': '/lib/main.dart'},
        {'name': 'app.dart', 'type': 'file', 'path': '/lib/app.dart'},
        {'name': 'app_keeper.dart', 'type': 'file', 'path': '/lib/app_keeper.dart'},
        {
          'name': 'screens',
          'type': 'folder',
          'children': [
            {'name': 'home_screen.dart', 'type': 'file', 'path': '/lib/screens/home_screen.dart'},
            {'name': 'settings_screen.dart', 'type': 'file', 'path': '/lib/screens/settings_screen.dart'},
          ]
        },
        {
          'name': 'widgets',
          'type': 'folder',
          'children': [
            {'name': 'custom_button.dart', 'type': 'file', 'path': '/lib/widgets/custom_button.dart'},
            {'name': 'navigation_bar.dart', 'type': 'file', 'path': '/lib/widgets/navigation_bar.dart'},
          ]
        },
        {
          'name': 'dev-ui',
          'type': 'folder',
          'children': [
            {'name': 'code_editor_ide.dart', 'type': 'file', 'path': '/lib/dev-ui/code_editor_ide.dart'},
            {'name': 'google_translate_page.dart', 'type': 'file', 'path': '/lib/dev-ui/google_translate_page.dart'},
          ]
        },
      ]
    },
    {
      'name': 'assets',
      'type': 'folder',
      'children': [
        {'name': 'images', 'type': 'folder', 'children': []},
        {'name': 'fonts', 'type': 'folder', 'children': []},
        {'name': 'data.json', 'type': 'file', 'path': '/assets/data.json'},
      ]
    },
    {
      'name': 'test',
      'type': 'folder',
      'children': [
        {'name': 'widget_test.dart', 'type': 'file', 'path': '/test/widget_test.dart'},
      ]
    },
    {'name': 'pubspec.yaml', 'type': 'file', 'path': '/pubspec.yaml'},
    {'name': 'README.md', 'type': 'file', 'path': '/README.md'},
    {'name': '.gitignore', 'type': 'file', 'path': '/.gitignore'},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(
                Icons.folder_open,
                size: 16,
                color: widget.isDark ? Colors.white70 : Colors.black54,
              ),
              const SizedBox(width: 8),
              Text(
                'EXPLORER',
                style: TextStyle(
                  color: widget.isDark ? Colors.white70 : Colors.black54,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: Icon(
                  Icons.add,
                  size: 16,
                  color: widget.isDark ? Colors.white70 : Colors.black54,
                ),
                onPressed: () => _showCreateFileDialog(),
                tooltip: 'New File',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 4),
              IconButton(
                icon: Icon(
                  Icons.create_new_folder,
                  size: 16,
                  color: widget.isDark ? Colors.white70 : Colors.black54,
                ),
                onPressed: () => _showCreateFolderDialog(),
                tooltip: 'New Folder',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 4),
              IconButton(
                icon: Icon(
                  Icons.refresh,
                  size: 16,
                  color: widget.isDark ? Colors.white70 : Colors.black54,
                ),
                onPressed: () => setState(() {}),
                tooltip: 'Refresh',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),
        
        // Project Name
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Row(
            children: [
              Icon(
                Icons.folder,
                size: 16,
                color: widget.isDark ? Colors.blue[300] : Colors.blue[600],
              ),
              const SizedBox(width: 8),
              Text(
                'MIKO',
                style: TextStyle(
                  color: widget.isDark ? Colors.white : Colors.black,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        
        // File Tree
        Expanded(
          child: ListView(
            padding: const EdgeInsets.only(left: 8),
            children: _buildFileTree(_fileStructure, 0),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildFileTree(List<Map<String, dynamic>> items, int depth) {
    List<Widget> widgets = [];
    
    for (var item in items) {
      widgets.add(_buildFileItem(item, depth));
      
      if (item['type'] == 'folder' && 
          item['children'] != null && 
          _expandedFolders[item['name']] == true) {
        widgets.addAll(_buildFileTree(item['children'], depth + 1));
      }
    }
    
    return widgets;
  }

  Widget _buildFileItem(Map<String, dynamic> item, int depth) {
    final isFolder = item['type'] == 'folder';
    final isExpanded = _expandedFolders[item['name']] ?? false;
    
    return InkWell(
      onTap: () {
        if (isFolder) {
          setState(() {
            _expandedFolders[item['name']] = !isExpanded;
          });
        } else {
          widget.onFileSelected?.call(item);
        }
      },
      child: Container(
        padding: EdgeInsets.only(
          left: 12.0 + (depth * 16.0),
          right: 8,
          top: 4,
          bottom: 4,
        ),
        child: Row(
          children: [
            if (isFolder)
              Icon(
                isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
                size: 16,
                color: widget.isDark ? Colors.white70 : Colors.black54,
              )
            else
              const SizedBox(width: 16),
            
            const SizedBox(width: 4),
            
            Icon(
              _getFileIcon(item['name'], isFolder),
              size: 16,
              color: _getFileIconColor(item['name'], isFolder),
            ),
            
            const SizedBox(width: 8),
            
            Expanded(
              child: Text(
                item['name'],
                style: TextStyle(
                  color: widget.isDark ? Colors.white : Colors.black,
                  fontSize: 13,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            
            if (!isFolder)
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_horiz,
                  size: 14,
                  color: widget.isDark ? Colors.white54 : Colors.black38,
                ),
                onSelected: (value) => _handleFileAction(value, item),
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'rename', child: Text('Rename')),
                  const PopupMenuItem(value: 'delete', child: Text('Delete')),
                  const PopupMenuItem(value: 'copy', child: Text('Copy Path')),
                ],
              ),
          ],
        ),
      ),
    );
  }

  IconData _getFileIcon(String name, bool isFolder) {
    if (isFolder) {
      return Icons.folder;
    }
    
    if (name.endsWith('.dart')) return Icons.code;
    if (name.endsWith('.js') || name.endsWith('.ts')) return Icons.javascript;
    if (name.endsWith('.py')) return Icons.code;
    if (name.endsWith('.html')) return Icons.web;
    if (name.endsWith('.css')) return Icons.style;
    if (name.endsWith('.json')) return Icons.data_object;
    if (name.endsWith('.yaml') || name.endsWith('.yml')) return Icons.settings;
    if (name.endsWith('.md')) return Icons.description;
    if (name.endsWith('.png') || name.endsWith('.jpg') || name.endsWith('.jpeg')) {
      return Icons.image;
    }
    
    return Icons.description;
  }

  Color _getFileIconColor(String name, bool isFolder) {
    if (isFolder) {
      return widget.isDark ? Colors.blue[300]! : Colors.blue[600]!;
    }
    
    if (name.endsWith('.dart')) {
      return widget.isDark ? Colors.blue[300]! : Colors.blue[600]!;
    }
    if (name.endsWith('.js') || name.endsWith('.ts')) {
      return widget.isDark ? Colors.yellow[300]! : Colors.yellow[700]!;
    }
    if (name.endsWith('.py')) {
      return widget.isDark ? Colors.green[300]! : Colors.green[600]!;
    }
    if (name.endsWith('.html')) {
      return widget.isDark ? Colors.orange[300]! : Colors.orange[600]!;
    }
    if (name.endsWith('.css')) {
      return widget.isDark ? Colors.purple[300]! : Colors.purple[600]!;
    }
    if (name.endsWith('.json')) {
      return widget.isDark ? Colors.amber[300]! : Colors.amber[700]!;
    }
    if (name.endsWith('.png') || name.endsWith('.jpg') || name.endsWith('.jpeg')) {
      return widget.isDark ? Colors.pink[300]! : Colors.pink[600]!;
    }
    
    return widget.isDark ? Colors.white70 : Colors.black54;
  }

  void _handleFileAction(String action, Map<String, dynamic> file) {
    switch (action) {
      case 'rename':
        _showRenameDialog(file);
        break;
      case 'delete':
        _showDeleteConfirmation(file);
        break;
      case 'copy':
        // Copy file path to clipboard
        break;
    }
  }

  void _showCreateFileDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New File'),
        content: TextField(
          decoration: const InputDecoration(
            hintText: 'Enter file name',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle file creation
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showCreateFolderDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Folder'),
        content: TextField(
          decoration: const InputDecoration(
            hintText: 'Enter folder name',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle folder creation
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showRenameDialog(Map<String, dynamic> file) {
    final controller = TextEditingController(text: file['name']);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename File'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle file rename
            },
            child: const Text('Rename'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(Map<String, dynamic> file) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete File'),
        content: Text('Are you sure you want to delete "${file['name']}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle file deletion
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}