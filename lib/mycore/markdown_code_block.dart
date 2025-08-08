// lib/ui/widgets/markdown_code_block.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;

class CodeBlockBuilder extends MarkdownElementBuilder {
 final VoidCallback? onCopied;

 CodeBlockBuilder({this.onCopied});

 @override
 Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
 // element.textContent contains raw code; language may be in element.attributes['class']
 final code = element.textContent;
 final lang = _extractLanguage(element.attributes['class']);

 return Stack(
 children: [
 Container(
 width: double.infinity,
 padding: const EdgeInsets.all(12),
 decoration: BoxDecoration(
 color: Colors.black.withOpacity(0.85),
 borderRadius: BorderRadius.circular(8),
 ),
 child: SingleChildScrollView(
 scrollDirection: Axis.horizontal,
 child: SelectableText(
 code,
 style: const TextStyle(
 fontFamily: 'monospace',
 color: Colors.white,
 fontSize: 13,
 ),
 ),
 ),
 ),
 Positioned(
 top: 4,
 right: 4,
 child: Row(
 mainAxisSize: MainAxisSize.min,
 children: [
 if (lang != null)
 Container(
 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
 decoration: BoxDecoration(
 color: Colors.white10,
 borderRadius: BorderRadius.circular(6),
 ),
 child: Text(
 lang,
 style: const TextStyle(color: Colors.white70, fontSize: 11),
 ),
 ),
 const SizedBox(width: 6),
 IconButton(
 visualDensity: VisualDensity.compact,
 icon: const Icon(Icons.copy_rounded, size: 18, color: Colors.white70),
 onPressed: () async {
 await Clipboard.setData(ClipboardData(text: code));
 onCopied?.call();
 },
 ),
 ],
 ),
 ),
 ],
 );
 }

 String? _extractLanguage(String? classAttr) {
 if (classAttr == null) return null;
 // classAttr like "language-dart"
 final parts = classAttr.split('-');
 return parts.length > 1 ? parts.last : null;
 }
}