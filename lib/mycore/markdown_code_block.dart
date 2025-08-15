// lib/ui/widgets/markdown_code_block.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/themes/vs.dart';
import 'package:markdown/markdown.dart' as md;

// Highlight languages
import 'package:highlight/languages/dart.dart' as lang_dart;
import 'package:highlight/languages/javascript.dart' as lang_js;
import 'package:highlight/languages/typescript.dart' as lang_ts;
import 'package:highlight/languages/java.dart' as lang_java;
import 'package:highlight/languages/kotlin.dart' as lang_kotlin;
import 'package:highlight/languages/swift.dart' as lang_swift;
import 'package:highlight/languages/objectivec.dart' as lang_objc;
import 'package:highlight/languages/cpp.dart' as lang_cpp;
import 'package:highlight/languages/python.dart' as lang_py;
import 'package:highlight/languages/go.dart' as lang_go;
import 'package:highlight/languages/ruby.dart' as lang_ruby;
import 'package:highlight/languages/rust.dart' as lang_rust;
import 'package:highlight/languages/php.dart' as lang_php;
import 'package:highlight/languages/yaml.dart' as lang_yaml;
import 'package:highlight/languages/json.dart' as lang_json;
import 'package:highlight/languages/markdown.dart' as lang_md;
import 'package:highlight/languages/xml.dart' as lang_xml;
import 'package:highlight/languages/css.dart' as lang_css;
import 'package:highlight/languages/scss.dart' as lang_scss;
import 'package:highlight/languages/sql.dart' as lang_sql;
import 'package:highlight/languages/bash.dart' as lang_bash;
import 'package:highlight/languages/powershell.dart' as lang_ps;
import 'package:highlight/languages/plaintext.dart' as lang_plain;


// Main builder class - no changes needed here
class CodeBlockBuilder extends MarkdownElementBuilder {
  final VoidCallback? onCopied;

  CodeBlockBuilder({this.onCopied});

  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    final code = element.textContent;
    final lang = _extractLanguage(element.attributes['class']);
    return Padding(
      // Add some vertical margin between code blocks
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: _CodeSnippet(
        code: code,
        languageTag: lang,
        onCopied: onCopied,
      ),
    );
  }

  String? _extractLanguage(String? classAttr) {
    if (classAttr == null) return null;
    final lower = classAttr.toLowerCase();
    final idx = lower.lastIndexOf('language-');
    if (idx == -1) return null;
    return lower.substring(idx + 'language-'.length).trim();
  }
}



  // ... rest of your widget (build, header, copy handler, etc.)


class _CodeSnippet extends StatefulWidget {
  final String code;
  final String? languageTag;
  final VoidCallback? onCopied;

  const _CodeSnippet({
    required this.code,
    this.languageTag,
    this.onCopied,
  });

  @override
  State<_CodeSnippet> createState() => _CodeSnippetState();
}

class _CodeSnippetState extends State<_CodeSnippet> {
  late CodeController _controller;           // removed final
  String? _normalizedTag;                    // removed final so we can update it
  bool _isCopied = false;

  // colors omitted for brevity...

  @override
  void initState() {
    super.initState();
    _normalizedTag = _normalizeTag(widget.languageTag);
    final language = _languageByTag(_normalizedTag);
    _controller = CodeController(
      text: widget.code,
      language: language,
    );
  }

  @override
  void didUpdateWidget(covariant _CodeSnippet oldWidget) {
    super.didUpdateWidget(oldWidget);

    // 1) Update the text when streaming appends come in
    if (oldWidget.code != widget.code) {
      // keep caret at end so new content becomes visible
      _controller.text = widget.code;
      _controller.selection = TextSelection.collapsed(offset: widget.code.length);
      // no setState required because CodeField listens to the controller
    }

    // 2) Update language if the languageTag changed (recreate controller if necessary)
    final newTag = _normalizeTag(widget.languageTag);
    if (newTag != _normalizedTag) {
      _normalizedTag = newTag;
      final newLanguage = _languageByTag(_normalizedTag);

      // Recreate controller to apply new language highlighting.
      // Preserve the current text/selection.
      final currentText = _controller.text;
      final currentSelection = _controller.selection;
      _controller.dispose();
      _controller = CodeController(
        text: currentText,
        language: newLanguage,
      );
      _controller.selection = currentSelection;
      // force rebuild so CodeTheme/CodeField pick up the new controller
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }



  // Define our beautiful theme colors
  static const _codeBlockBackground = Color(0xFF282C34);
  static const _headerBackground = Color(0xFF21252B);
  static const _headerTextColor = Color(0xFFABB2BF);
  static const _iconColor = Color(0xFFABB2BF);

  // @override
  // void initState() {
  //   super.initState();
  //   _normalizedTag = _normalizeTag(widget.languageTag);
  //   final language = _languageByTag(_normalizedTag);
  //   _controller = CodeController(
  //     text: widget.code,
  //     language: language,
  //   );
  // }

  // @override
  // void dispose() {
  //   _controller.dispose();
  //   super.dispose();
  // }

  void _handleCopy() async {
    await Clipboard.setData(ClipboardData(text: widget.code));
    widget.onCopied?.call();
    setState(() => _isCopied = true);
    // Reset the icon after a short delay
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _isCopied = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        color: _codeBlockBackground,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildCodeEditor(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: _headerBackground,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_normalizedTag != null)
            Text(
              _normalizedTag!,
              style: const TextStyle(
                color: _headerTextColor,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          const Spacer(),
          InkWell(
            onTap: _handleCopy,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _isCopied ? Icons.check_rounded : Icons.copy_rounded,
                  color: _iconColor,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  _isCopied ? 'Copied!' : 'Copy code',
                  style: const TextStyle(
                    color: _headerTextColor,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCodeEditor() {
    // Use CodeTheme to apply syntax highlighting
    return CodeTheme(
      data: CodeThemeData(styles: atomOneDarkTheme), // Use the imported theme
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CodeField(
          controller: _controller,
          readOnly: true,
          wrap: false, // Allows horizontal scrolling
          gutterStyle: GutterStyle.none,
          textStyle: const TextStyle(
            // IMPORTANT: Use a monospaced font!
            fontFamily: 'FiraCode', // or 'JetBrainsMono', 'SourceCodePro', etc.
            color: Colors.white,
            fontSize: 14,
            height: 1.5,
          ),
          cursorColor: Colors.transparent, // Hide cursor in read-only mode
          background: Colors.transparent, // Inherit from parent container
        ),
      ),
    );
  }
}

String? _normalizeTag(String? tag) {
  if (tag == null || tag.isEmpty) return null;
  final t = tag.toLowerCase();
  switch (t) {
    case 'js':
      return 'javascript';
    case 'ts':
      return 'typescript';
    case 'py':
      return 'python';
    case 'rb':
      return 'ruby';
    case 'rs':
      return 'rust';
    case 'yml':
      return 'yaml';
    case 'md':
      return 'markdown';
    case 'sh':
    case 'shell':
      return 'bash';
    case 'ps':
    case 'ps1':
      return 'powershell';
    case 'c++':
      return 'cpp';
    case 'objc':
    case 'objective-c':
      return 'objectivec';
    default:
      return t;
  }
}

dynamic _languageByTag(String? tag) {
  switch (tag) {
    case 'dart':
      return lang_dart.dart;
    case 'javascript':
      return lang_js.javascript;
    case 'typescript':
      return lang_ts.typescript;
    case 'java':
      return lang_java.java;
    case 'kotlin':
      return lang_kotlin.kotlin;
    case 'swift':
      return lang_swift.swift;
    case 'objectivec':
      return lang_objc.objectivec;
    case 'cpp':
      return lang_cpp.cpp;
    case 'python':
      return lang_py.python;
    case 'go':
      return lang_go.go;
    case 'ruby':
      return lang_ruby.ruby;
    case 'rust':
      return lang_rust.rust;
    case 'php':
      return lang_php.php;
    case 'yaml':
      return lang_yaml.yaml;
    case 'json':
      return lang_json.json;
    case 'markdown':
      return lang_md.markdown;
    case 'xml':
      return lang_xml.xml;
    case 'css':
      return lang_css.css;
    case 'scss':
      return lang_scss.scss;
    case 'sql':
      return lang_sql.sql;
    case 'bash':
      return lang_bash.bash;
    case 'powershell':
      return lang_ps.powershell;
    case null:
    default:
      return lang_plain.plaintext;
  }
}