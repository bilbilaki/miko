import 'package:flutter/material.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';

class CodeBlock extends StatelessWidget {
  final String code;
  final String? language;

  const CodeBlock({super.key, required this.code, this.language});

  @override
  Widget build(BuildContext context) {
    return SyntaxView(
      code: code,
      syntax:
          language != null ? _getSyntax(language!) : Syntax.DART, // Default to Dart if no language is provided
      syntaxTheme: SyntaxTheme.vscodeDark(), // Using a dark theme for the code
      withLinesCount: true,
      withZoom: true,
      expanded: false, // Set to false to allow the widget to be used in a scrollable view
    );
  }

  Syntax _getSyntax(String language) {
    switch (language.toLowerCase()) {
      case 'python':
        return Syntax.PYTHON;
      case 'java':
        return Syntax.JAVA;
      case 'javascript':
        return Syntax.JAVASCRIPT;
      
      case 'c':
        return Syntax.C;
      case 'cpp':
        return Syntax.CPP;
      
      case 'kotlin':
        return Syntax.KOTLIN;
      case 'swift':
        return Syntax.SWIFT;
      case 'yaml':
        return Syntax.YAML;
      default:
        return Syntax.DART;
    }
  }
}