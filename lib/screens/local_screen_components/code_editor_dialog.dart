import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:path/path.dart' as p;

import '../../widgets/code_editor/constants.dart';
import '../../widgets/code_editor/themes.dart';

/// A dialog that shows a code editor for editing file contents
class CodeEditorDialog extends StatefulWidget {
  final String filePath;
  final String initialContent;
  final Function(String) onSave;
    final Function(String) onSaveAs;

  final bool readOnly;

  const CodeEditorDialog({
    super.key,
    required this.filePath,
    required this.initialContent,
    required this.onSave,
        required this.onSaveAs,

    this.readOnly = false,
  });

  @override
  State<CodeEditorDialog> createState() => _CodeEditorDialogState();
}

class _CodeEditorDialogState extends State<CodeEditorDialog> {
  late final CodeController _codeController;
  final FocusNode _focusNode = FocusNode();
  String _theme = 'monokai-sublime';
  bool _showNumbers = true;
  bool _showFoldingHandles = true;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    
    // Determine language from file extension
    final language = _getLanguageFromExtension(widget.filePath);
    
    _codeController = CodeController(
      language: builtinLanguages[language],
      text: widget.initialContent,
    );
    
    _codeController.addListener(() {
      if (!_hasChanges) {
        setState(() {
          _hasChanges = true;
        });
      }
    });
  }

  String _getLanguageFromExtension(String filePath) {
    final ext = p.extension(filePath).toLowerCase();
    
    switch (ext) {
      case '.dart':
        return 'dart';
      case '.java':
        return 'java';
      case '.js':
        return 'javascript';
      case '.ts':
        return 'typescript';
      case '.py':
        return 'python';
      case '.cpp':
      case '.cc':
      case '.cxx':
        return 'cpp';
      case '.c':
        return 'c';
      case '.h':
      case '.hpp':
        return 'c';
      case '.cs':
        return 'csharp';
      case '.go':
        return 'go';
      case '.rs':
        return 'rust';
      case '.rb':
        return 'ruby';
      case '.php':
        return 'php';
      case '.swift':
        return 'swift';
      case '.kt':
        return 'kotlin';
      case '.scala':
        return 'scala';
      case '.sh':
      case '.bash':
        return 'bash';
      case '.xml':
        return 'xml';
      case '.html':
      case '.htm':
        return 'html';
      case '.css':
        return 'css';
      case '.scss':
        return 'scss';
      case '.json':
        return 'json';
      case '.yaml':
      case '.yml':
        return 'yaml';
      case '.md':
        return 'markdown';
      case '.sql':
        return 'sql';
      default:
        return 'plaintext';
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleSave() async {
  await  widget.onSave(_codeController.text);
    setState(() {
      _hasChanges = false;
    });
  }
  void _handleSaveAs() async {
   await  widget.onSaveAs(_codeController.text);
    setState(() {
      _hasChanges = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.95,
        height: MediaQuery.of(context).size.height * 0.9,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              color: themes[_theme]?['root']?.backgroundColor ?? Colors.grey[900],
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      p.basename(widget.filePath),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (_hasChanges)
                    Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'Modified',
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                  IconButton(
                    icon: Icon(
                      Icons.numbers,
                      color: _showNumbers ? Colors.white : Colors.grey,
                    ),
                    onPressed: () => setState(() => _showNumbers = !_showNumbers),
                    tooltip: 'Toggle Line Numbers',
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.chevron_right,
                      color: _showFoldingHandles ? Colors.white : Colors.grey,
                    ),
                    onPressed: () => setState(() => _showFoldingHandles = !_showFoldingHandles),
                    tooltip: 'Toggle Folding Handles',
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.color_lens, color: Colors.white),
                    tooltip: 'Select Theme',
                    onSelected: (value) => setState(() => _theme = value),
                    itemBuilder: (context) => themeList
                        .map((theme) => PopupMenuItem(
                              value: theme,
                              child: Text(theme),
                            ))
                        .toList(),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                    tooltip: 'Close',
                  ),
                ],
              ),
            ),
            
            // Editor
            Expanded(
              child: SingleChildScrollView(
                child: CodeTheme(
                  data: CodeThemeData(styles: themes[_theme]),
                  child: CodeField(
                    focusNode: _focusNode,
                    controller: _codeController,
                    readOnly: widget.readOnly,
                    textStyle: const TextStyle(
                      fontFamily: 'SourceCode',
                      fontSize: 14,
                    ),
                    gutterStyle: GutterStyle(
                      textStyle: const TextStyle(
                        color: Colors.purple,
                        fontSize: 12,
                      ),
                      showLineNumbers: _showNumbers,
                      showFoldingHandles: _showFoldingHandles,
                    ),
                  ),
                ),
              ),
            ),
            
            // Footer with action buttons
            if (!widget.readOnly)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border(
                    top: BorderSide(color: Colors.grey[400]!),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.save),
                      label: const Text('Save'),
                      onPressed: _hasChanges ? _handleSave : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                                        ElevatedButton.icon(
                      icon: const Icon(Icons.save_as),
                      label: const Text('Save As'),
                      onPressed: _hasChanges ? _handleSaveAs : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
