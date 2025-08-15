# Implementation Plan: Enhanced Code Block with Syntax Highlighting

## Overview
This plan outlines the steps to implement an enhanced code block with syntax highlighting, language detection, and improved UI in the Miko app.

## Implementation Steps

### 1. Create Language Detector Class

First, implement the language detection algorithm as a separate class:

```dart
// lib/mycore/code_language_detector.dart
import 'package:flutter/material.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';

class CodeLanguageDetector {
  static const Map<String, Syntax> _languageMap = {
    'c': Syntax.C,
    'cpp': Syntax.CPP,
    'dart': Syntax.DART,
    'java': Syntax.DART, // Using DART as fallback (update if Java is added)
    'javascript': Syntax.DART, // Using DART as fallback
    'kotlin': Syntax.DART, // Using DART as fallback
    'lua': Syntax.DART, // Using DART as fallback
    'python': Syntax.DART, // Using DART as fallback
    'rust': Syntax.DART, // Using DART as fallback
    'swift': Syntax.DART, // Using DART as fallback
    'yaml': Syntax.DART, // Using DART as fallback
  };

  // Detect language from code and class attribute
  static (String languageName, Syntax syntax) detectLanguage(String code, String? classAttr) {
    // Extract language from class attribute if available
    final explicitLang = _extractLanguage(classAttr);
    
    // If explicit language is provided and supported, use it
    if (explicitLang != null && _languageMap.containsKey(explicitLang.toLowerCase())) {
      final lang = explicitLang.toLowerCase();
      return (lang, _languageMap[lang] ?? Syntax.DART);
    }
    
    // Otherwise, detect language from code
    final detectedLang = _detectFromCode(code);
    return (detectedLang, _languageMap[detectedLang] ?? Syntax.DART);
  }

  // Extract language from class attribute (e.g., "language-dart" -> "dart")
  static String? _extractLanguage(String? classAttr) {
    if (classAttr == null) return null;
    final parts = classAttr.split('-');
    return parts.length > 1 ? parts.last : null;
  }

  // Detect language from code content
  static String _detectFromCode(String code) {
    // Implementation of the language detection algorithm
    // This will use pattern matching as described in language_detection_algorithm.md
    
    // For now, a simplified version that checks for common patterns
    if (code.contains('import \'package:flutter/')) return 'dart';
    if (code.contains('function') && code.contains('const ') && code.contains('=>')) return 'javascript';
    if (code.contains('def ') && code.contains(':') && !code.contains('{')) return 'python';
    if (code.contains('public class') || code.contains('public static void main')) return 'java';
    if (code.contains('#include <') || code.contains('int main()')) return 'cpp';
    
    // Default to dart if no match
    return 'dart';
  }
}
```

### 2. Update CodeBlockBuilder Class

Next, modify the existing CodeBlockBuilder to use flutter_syntax_view:

```dart
// lib/mycore/markdown_code_block.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:flutter_syntax_view/flutter_syntax_view.dart';
import 'package:google_fonts/google_fonts.dart';

import 'code_language_detector.dart';

class CodeBlockBuilder extends MarkdownElementBuilder {
  final VoidCallback? onCopied;
  
  CodeBlockBuilder({this.onCopied});
  
  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    final code = element.textContent;
    final (languageName, syntax) = CodeLanguageDetector.detectLanguage(
      code, 
      element.attributes['class']
    );
    
    return EnhancedCodeBlock(
      code: code,
      languageName: languageName,
      syntax: syntax,
      onCopied: onCopied,
    );
  }
}

class EnhancedCodeBlock extends StatefulWidget {
  final String code;
  final String languageName;
  final Syntax syntax;
  final VoidCallback? onCopied;
  
  const EnhancedCodeBlock({
    Key? key,
    required this.code,
    required this.languageName,
    required this.syntax,
    this.onCopied,
  }) : super(key: key);
  
  @override
  _EnhancedCodeBlockState createState() => _EnhancedCodeBlockState();
}

class _EnhancedCodeBlockState extends State<EnhancedCodeBlock> {
  bool _isCopied = false;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header with language badge and copy button
          _buildHeader(),
          
          // Code content with syntax highlighting
          _buildCodeContent(),
        ],
      ),
    );
  }
  
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Language badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _getLanguageIcon(),
                const SizedBox(width: 4),
                Text(
                  widget.languageName,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          
          // Copy button
          TextButton.icon(
            style: TextButton.styleFrom(
              foregroundColor: Colors.white70,
              visualDensity: VisualDensity.compact,
            ),
            icon: Icon(
              _isCopied ? Icons.check_rounded : Icons.copy_rounded,
              size: 16,
            ),
            label: Text(
              _isCopied ? 'Copied!' : 'Copy',
              style: const TextStyle(fontSize: 12),
            ),
            onPressed: _copyCode,
          ),
        ],
      ),
    );
  }
  
  Widget _buildCodeContent() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.85),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
      ),
      child: SyntaxView(
        code: widget.code,
        syntax: widget.syntax,
        syntaxTheme: SyntaxTheme.gravityDark(),
        fontSize: 13,
        withZoom: false,
        withLinesCount: true,
        expanded: false,
        selectable: true,
      ),
    );
  }
  
  Widget _getLanguageIcon() {
    // Return appropriate icon based on language
    IconData iconData;
    
    switch (widget.languageName) {
      case 'dart':
        iconData = Icons.flutter_dash;
        break;
      case 'python':
        iconData = Icons.code;
        break;
      case 'javascript':
        iconData = Icons.javascript;
        break;
      default:
        iconData = Icons.code;
    }
    
    return Icon(iconData, size: 14, color: Colors.white70);
  }
  
  void _copyCode() async {
    await Clipboard.setData(ClipboardData(text: widget.code));
    
    // Show copied animation
    setState(() {
      _isCopied = true;
    });
    
    // Reset after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isCopied = false;
        });
      }
    });
    
    widget.onCopied?.call();
  }
}
```

### 3. Optimize Font Rendering

Add a custom monospace font for better code readability:

```dart
// In the _buildCodeContent method of _EnhancedCodeBlockState
Widget _buildCodeContent() {
  return Container(
    decoration: BoxDecoration(
      color: Colors.black.withOpacity(0.85),
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(8),
        bottomRight: Radius.circular(8),
      ),
    ),
    child: DefaultTextStyle(
      style: GoogleFonts.jetbrainsMono(
        fontSize: 13,
        height: 1.5,
      ),
      child: SyntaxView(
        code: widget.code,
        syntax: widget.syntax,
        syntaxTheme: SyntaxTheme.gravityDark(),
        fontSize: 13,
        withZoom: false,
        withLinesCount: true,
        expanded: false,
        selectable: true,
      ),
    ),
  );
}
```

### 4. Update Dependencies

Ensure all required dependencies are properly added to pubspec.yaml:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_syntax_view: ^4.1.7
  google_fonts: ^6.2.1
  # ... other existing dependencies
```

## Testing Plan

1. Test with various programming languages:
   - Dart
   - Python
   - JavaScript
   - C/C++
   - Others supported by the package

2. Test edge cases:
   - Very long code blocks
   - Code with special characters
   - Empty code blocks
   - Code blocks with only comments

3. Test UI components:
   - Copy functionality
   - Language detection accuracy
   - Proper syntax highlighting
   - Responsiveness on different screen sizes

## Future Enhancements

1. Add support for more languages by extending the flutter_syntax_view package
2. Implement code folding for long code blocks
3. Add line highlighting for important code sections
4. Support for dark/light theme switching