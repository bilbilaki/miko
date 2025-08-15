# Code Implementation for Enhanced Code Block

This document contains the complete implementation code for the enhanced code block with syntax highlighting, language detection, and improved UI.

## 1. Language Detector Class

Create a new file: `lib/mycore/code_language_detector.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';

/// A utility class for detecting programming languages from code snippets
class CodeLanguageDetector {
  /// Map of language names to Syntax enum values
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

  /// Detect language from code and class attribute
  /// Returns a tuple with (languageName, syntax)
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

  /// Extract language from class attribute (e.g., "language-dart" -> "dart")
  static String? _extractLanguage(String? classAttr) {
    if (classAttr == null) return null;
    final parts = classAttr.split('-');
    return parts.length > 1 ? parts.last : null;
  }

  /// Detect language from code content using pattern matching
  static String _detectFromCode(String code) {
    // Check for shebang line
    if (code.startsWith('#!')) {
      final firstLine = code.split('\n').first;
      if (firstLine.contains('python')) return 'python';
      if (firstLine.contains('node')) return 'javascript';
      if (firstLine.contains('dart')) return 'dart';
    }
    
    // Check for language-specific patterns
    
    // Dart patterns
    if (code.contains('import \'package:flutter/') || 
        code.contains('Widget build(') ||
        (code.contains('class') && code.contains('extends') && code.contains('State<'))) {
      return 'dart';
    }
    
    // JavaScript patterns
    if ((code.contains('function') || code.contains('=>')) && 
        (code.contains('const ') || code.contains('let ')) &&
        (code.contains('document.') || code.contains('window.'))) {
      return 'javascript';
    }
    
    // Python patterns
    if (code.contains('def ') && 
        code.contains(':') && 
        !code.contains('{') &&
        (code.contains('    ') || code.contains('import '))) {
      return 'python';
    }
    
    // Java patterns
    if (code.contains('public class') || 
        code.contains('public static void main') ||
        (code.contains('import java.') && code.contains(';'))) {
      return 'java';
    }
    
    // C/C++ patterns
    if (code.contains('#include <') || 
        code.contains('int main(') ||
        (code.contains('std::') && code.contains(';'))) {
      return 'cpp';
    }
    
    // Kotlin patterns
    if (code.contains('fun ') && 
        (code.contains('val ') || code.contains('var ')) &&
        !code.contains(';')) {
      return 'kotlin';
    }
    
    // Rust patterns
    if (code.contains('fn ') && 
        code.contains('let ') &&
        (code.contains('mut ') || code.contains('->'))) {
      return 'rust';
    }
    
    // Swift patterns
    if (code.contains('func ') && 
        (code.contains('let ') || code.contains('var ')) &&
        code.contains('->')) {
      return 'swift';
    }
    
    // YAML patterns
    if (!code.contains('{') && 
        !code.contains(';') &&
        code.contains(':') &&
        (code.contains('- ') || code.contains('  '))) {
      return 'yaml';
    }
    
    // Default to dart if no match
    return 'dart';
  }
  
  /// Get an icon for a specific language
  static IconData getLanguageIcon(String language) {
    switch (language.toLowerCase()) {
      case 'dart':
        return Icons.flutter_dash;
      case 'python':
        return Icons.code;
      case 'javascript':
        return Icons.javascript;
      case 'java':
        return Icons.coffee;
      case 'cpp':
      case 'c':
        return Icons.memory;
      default:
        return Icons.code;
    }
  }
}
```

## 2. Enhanced Code Block Implementation

Update the file: `lib/mycore/markdown_code_block.dart`

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
    // element.textContent contains raw code; language may be in element.attributes['class']
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

class _EnhancedCodeBlockState extends State<EnhancedCodeBlock> with SingleTickerProviderStateMixin {
  bool _isCopied = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
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
                Icon(
                  CodeLanguageDetector.getLanguageIcon(widget.languageName),
                  size: 14, 
                  color: Colors.white70,
                ),
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
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                _isCopied ? Icons.check_rounded : Icons.copy_rounded,
                size: 16,
                key: ValueKey<bool>(_isCopied),
              ),
            ),
            label: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Text(
                _isCopied ? 'Copied!' : 'Copy',
                style: const TextStyle(fontSize: 12),
                key: ValueKey<bool>(_isCopied),
              ),
            ),
            onPressed: _copyCode,
          ),
        ],
      ),
    );
  }
  
  Widget _buildCodeContent() {
    return Container(
      constraints: BoxConstraints(
        maxHeight: widget.code.split('\n').length > 15 
            ? 300 // Limit height for very long code blocks
            : double.infinity,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.85),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          textTheme: Theme.of(context).textTheme.copyWith(
            bodyMedium: GoogleFonts.jetbrainsMono(
              fontSize: 13,
              height: 1.5,
              color: Colors.white,
            ),
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
      ),
    );
  }
  
  void _copyCode() async {
    await Clipboard.setData(ClipboardData(text: widget.code));
    
    // Show copied animation
    setState(() {
      _isCopied = true;
    });
    _animationController.forward();
    
    // Reset after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isCopied = false;
        });
        _animationController.reverse();
      }
    });
    
    widget.onCopied?.call();
  }
}
```

## 3. Update pubspec.yaml

Make sure to add the required dependencies:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_syntax_view: ^4.1.7
  google_fonts: ^6.2.1
  # ... other existing dependencies
```

## Implementation Notes

1. The `CodeLanguageDetector` class handles language detection using both explicit language tags and pattern matching.

2. The `EnhancedCodeBlock` widget provides:
   - A header with language badge and copy button
   - Syntax highlighting using SyntaxView
   - Optimized font rendering with JetBrains Mono
   - Copy functionality with visual feedback
   - Responsive design with constraints for long code blocks

3. The implementation supports all languages available in flutter_syntax_view:
   - C, C++, Dart, Java, JavaScript, Kotlin, Lua, Python, Rust, Swift, YAML

4. For languages not directly supported by flutter_syntax_view, we fallback to Dart syntax highlighting but still show the correct language name.

## Usage

The enhanced code block will be automatically used when rendering markdown content:

```dart
MarkdownBody(
  data: markdownText,
  selectable: true,
  builders: {
    'code': CodeBlockBuilder(
      onCopied: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Code copied')),
        );
      },
    ),
  },
)