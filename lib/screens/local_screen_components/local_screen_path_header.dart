import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A header widget that displays and allows editing of the current directory path
class PathHeader extends StatefulWidget {
  final String currentPath;
  final Function(String) onPathChanged;
  final VoidCallback? onCopyPath;
  final VoidCallback? onPastePath;

  const PathHeader({
    super.key,
    required this.currentPath,
    required this.onPathChanged,
    this.onCopyPath,
    this.onPastePath,
  });

  @override
  State<PathHeader> createState() => _PathHeaderState();
}

class _PathHeaderState extends State<PathHeader> {
  late TextEditingController _controller;
  bool _isEditing = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentPath);
  }

  @override
  void didUpdateWidget(PathHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update controller when path changes externally (e.g., navigation)
    if (widget.currentPath != oldWidget.currentPath && !_isEditing) {
      _controller.text = widget.currentPath;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _startEditing() {
    setState(() {
      _isEditing = true;
    });
    _focusNode.requestFocus();
    // Select all text for easy editing
    _controller.selection = TextSelection(
      baseOffset: 0,
      extentOffset: _controller.text.length,
    );
  }

  Future<void> _submitPath() async {
    final newPath = _controller.text.trim();

    if (newPath.isEmpty) {
      _showErrorDialog('Path cannot be empty');
      _controller.text = widget.currentPath;
      setState(() => _isEditing = false);
      return;
    }

    if (newPath == widget.currentPath) {
      setState(() => _isEditing = false);
      return;
    }

    // Validate path exists
    final dir = Directory(newPath);
    if (!await dir.exists()) {
      _showErrorDialog(
        'Path does not exist',
        'The directory "$newPath" does not exist or is not accessible.',
      );
      _controller.text = widget.currentPath;
      setState(() => _isEditing = false);
      return;
    }

    // Path is valid, update
    setState(() => _isEditing = false);
    widget.onPathChanged(newPath);
  }

  void _showErrorDialog(String title, [String? message]) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.red),
            const SizedBox(width: 8),
            Text(title),
          ],
        ),
        content: message != null ? Text(message) : null,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _copyPath() async {
    await Clipboard.setData(ClipboardData(text: widget.currentPath));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Path copied to clipboard'),
          duration: Duration(seconds: 1),
        ),
      );
    }
    widget.onCopyPath?.call();
  }

  Future<void> _pastePath() async {
    final data = await Clipboard.getData('text/plain');
    if (data?.text != null && data!.text!.isNotEmpty) {
      _controller.text = data.text!;
      _startEditing();
    }
    widget.onPastePath?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
          Expanded(
            child: GestureDetector(
              onTap: _isEditing ? null : _startEditing,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: _isEditing
                      ? Theme.of(context).colorScheme.surface
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                  border: _isEditing
                      ? Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2,
                        )
                      : null,
                ),
                child: _isEditing
                    ? TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        style: const TextStyle(fontSize: 14),
                        decoration: const InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        onSubmitted: (_) => _submitPath(),
                        onEditingComplete: _submitPath,
                      )
                    : Row(
                        children: [
                          Icon(
                            Icons.folder_open,
                            size: 18,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              widget.currentPath,
                              style: const TextStyle(
                                fontSize: 14,
                                fontFamily: 'monospace',
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Action buttons
          IconButton(
            icon: const Icon(Icons.content_copy, size: 20),
            tooltip: 'Copy path',
            onPressed: _copyPath,
            visualDensity: VisualDensity.compact,
          ),
          IconButton(
            icon: const Icon(Icons.content_paste, size: 20),
            tooltip: 'Paste path',
            onPressed: _pastePath,
            visualDensity: VisualDensity.compact,
          ),
          if (_isEditing) ...[
            IconButton(
              icon: const Icon(Icons.close, size: 20),
              tooltip: 'Cancel',
              onPressed: () {
                _controller.text = widget.currentPath;
                setState(() => _isEditing = false);
              },
              visualDensity: VisualDensity.compact,
            ),
            IconButton(
              icon: const Icon(Icons.check, size: 20),
              tooltip: 'Apply',
              onPressed: _submitPath,
              visualDensity: VisualDensity.compact,
            ),
          ] else
            IconButton(
              icon: const Icon(Icons.edit, size: 20),
              tooltip: 'Edit path',
              onPressed: _startEditing,
              visualDensity: VisualDensity.compact,
            ),
        ],
      ),
    );
  }
}
