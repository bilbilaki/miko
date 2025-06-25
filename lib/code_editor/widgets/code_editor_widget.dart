
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:flutter_highlight/themes/vs2015.dart';





class CodeEditorWidget extends StatefulWidget {
  final CodeController controller;
  final String language;
  final bool isDark;
  final Function(String)? onChanged;

  const CodeEditorWidget({
    super.key,
    required this.controller,
    required this.language,
    required this.isDark,
    this.onChanged,
  });

  @override
  State<CodeEditorWidget> createState() => _CodeEditorWidgetState();
}

class _CodeEditorWidgetState extends State<CodeEditorWidget> {
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
    final FocusNode _focusNode2 = FocusNode();


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

 
  Issue issueFromJson(Map<String, dynamic> json) {
  final type = mapIssueType(json['kind']);
  return Issue(
    line: json['line'] - 1,
    message: json['message'],
    suggestion: json['correction'],
    type: type,
    url: json['url'],
  );
}

IssueType mapIssueType(String type) {
  switch (type) {
    case 'error':
      return IssueType.error;
    case 'warning':
      return IssueType.warning;
    case 'info':
      return IssueType.info;
    default:
      return IssueType.warning;
  }
}
  

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: widget.isDark ? const Color.fromARGB(255, 0, 0, 0) : Colors.white,
      child: CodeTheme(
        data: CodeThemeData(styles: monokaiSublimeTheme),
        child:
        //  Row(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     // Line Numbers
        //     // Vertical Divider
        //     Container(
        //       width: 1,
        //       color:
        //           widget.isDark
        //               ? const Color(0xFF3E3E42)
        //               : const Color(0xFFE0E0E0),
        //     ),
        // Code Editor
        Expanded(child: _buildCodeEditor()),
        // ],
      ),
    );
    // );
  }

  Widget _buildCodeEditor() {
    return RawKeyboardListener(
      focusNode: _focusNode,
      onKey: _handleKeyEvent,
      child: CodeTheme(
        data: CodeThemeData(styles: vs2015Theme),

        child: Expanded(
          flex: 2,
          child: CodeField(
            focusNode: _focusNode2,
            controller: widget.controller,
            wrap: true,
            expands: true,

            gutterStyle: GutterStyle(
              textAlign: TextAlign.left,
              background: Colors.black,
              showErrors: true,
              showFoldingHandles: true,
              showLineNumbers: true,
              errorPopupTextStyle: TextStyle(
                backgroundColor: Colors.black,

                fontSize: 16,
                fontWeight: FontWeight.w200,
                color: Color(0xFFB00020),
              ),
            ),
          ),
        ),
        //     onChanged: widget.onChanged,
        //   //  scrollController: _scrollController,
        //     textAlignVertical: TextAlignVertical.top,
        //   ),
        // );
      ),
    );
  }

  void _handleKeyEvent(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      // Handle Tab key for indentation
      if (event.logicalKey == LogicalKeyboardKey.tab) {
        _insertTab();
      }
      // Handle Ctrl+D for duplicate line
      else if (event.isControlPressed &&
          event.logicalKey == LogicalKeyboardKey.keyD) {
        _duplicateLine();
      }
      // Handle Ctrl+/ for comment toggle
      else if (event.isControlPressed &&
          event.logicalKey == LogicalKeyboardKey.slash) {
        _toggleComment();
      }
      // Handle Enter for auto-indentation
      else if (event.logicalKey == LogicalKeyboardKey.enter) {
        _handleEnterKey();
      }
    }
  }

  void _insertTab() {
    final text = widget.controller.text;
    final selection = widget.controller.selection;

    if (selection.isValid) {
      final newText = text.replaceRange(
        selection.start,
        selection.end,
        '  ', // 2 spaces for tab
      );

      widget.controller.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: selection.start + 2),
      );
    }
  }

  void _duplicateLine() {
    final text = widget.controller.text;
    final selection = widget.controller.selection;

    if (selection.isValid) {
      final lines = text.split('\n');
      final currentLineIndex = _getCurrentLineIndex(text, selection.start);

      if (currentLineIndex < lines.length) {
        final currentLine = lines[currentLineIndex];
        lines.insert(currentLineIndex + 1, currentLine);

        widget.controller.text = lines.join('\n');
      }
    }
  }

  void _toggleComment() {
    final text = widget.controller.text;
    final selection = widget.controller.selection;

    if (selection.isValid) {
      final lines = text.split('\n');
      final currentLineIndex = _getCurrentLineIndex(text, selection.start);

      if (currentLineIndex < lines.length) {
        final currentLine = lines[currentLineIndex];
        final commentPrefix = _getCommentPrefix();

        if (currentLine.trimLeft().startsWith(commentPrefix)) {
          // Remove comment
          lines[currentLineIndex] = currentLine.replaceFirst(commentPrefix, '');
        } else {
          // Add comment
          final leadingSpaces =
              currentLine.length - currentLine.trimLeft().length;
          lines[currentLineIndex] =
              currentLine.substring(0, leadingSpaces) +
              commentPrefix +
              currentLine.substring(leadingSpaces);
        }

        widget.controller.text = lines.join('\n');
      }
    }
  }

  void _handleEnterKey() {
    final text = widget.controller.text;
    final selection = widget.controller.selection;

    if (selection.isValid) {
      final lines = text.split('\n');
      final currentLineIndex = _getCurrentLineIndex(text, selection.start);

      if (currentLineIndex < lines.length) {
        final currentLine = lines[currentLineIndex];
        final leadingSpaces =
            currentLine.length - currentLine.trimLeft().length;
        final indentation = ' ' * leadingSpaces;

        // Add extra indentation for certain characters
        if (currentLine.trimRight().endsWith('{') ||
            currentLine.trimRight().endsWith(':')) {
          final newText = text.replaceRange(
            selection.start,
            selection.end,
            '\n$indentation  ', // Add 2 extra spaces
          );

          widget.controller.value = TextEditingValue(
            text: newText,
            selection: TextSelection.collapsed(
              offset: selection.start + indentation.length + 3,
            ),
          );
        }
      }
    }
  }

  int _getCurrentLineIndex(String text, int position) {
    return text.substring(0, position).split('\n').length - 1;
  }

  String _getCommentPrefix() {
    switch (widget.language.toLowerCase()) {
      case 'dart':
        return '//';
      case 'flutter':
        return '//';
      case 'javascript':
      case 'typescript':
      case 'java':
      case 'c++':
      case 'c#':
      case 'go':
      case 'rust':
      case 'swift':
      case 'kotlin':
        return '// ';
      case 'python':
      case 'ruby':
        return '# ';
      case 'html':
      case 'xml':
        return '<!-- ';
      case 'css':
        return '/* ';
      default:
        return '// ';
    }
  }
}
