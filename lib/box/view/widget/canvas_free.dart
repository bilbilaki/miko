// lib/canvas/free_canvas_page.dart
import 'dart:convert';
import 'package:flutter/material.dart';

// Preset editors you already use
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:miko/box/data/model/canvas_result.dart';
import 'package:miko/box/view/widget/code_editor.dart';
import 'package:math_keyboard/math_keyboard.dart';
import 'package:json_editor_flutter/json_editor_flutter.dart';
import 'package:flutter_code_crafter/code_crafter.dart';
// Themes

// Languages
import 'package:highlight/languages/dart.dart' as lang_dart;
import 'package:highlight/languages/python.dart' as lang_python;
import 'package:highlight/languages/javascript.dart' as lang_js;
import 'package:highlight/languages/java.dart' as lang_java;
import 'package:highlight/languages/cpp.dart' as lang_cpp;
import 'package:highlight/languages/kotlin.dart' as lang_kotlin;
import 'package:highlight/languages/go.dart' as lang_go;
import 'package:highlight/languages/rust.dart' as lang_rust;
import 'package:highlight/languages/swift.dart' as lang_swift;
import 'package:highlight/languages/json.dart' as lang_json;
import 'package:highlight/languages/yaml.dart' as lang_yaml;
import 'package:highlight/languages/xml.dart' as lang_xml;
import 'package:highlight/languages/css.dart' as lang_css;
import 'package:highlight/languages/bash.dart' as lang_bash;

class FreeCanvasPage extends StatefulWidget {
  const FreeCanvasPage({super.key, this.initialTool});

  final EditorTool? initialTool;

  @override
  State<FreeCanvasPage> createState() => _FreeCanvasPageState();
}

enum EditorTool { quill, math, json, code }

class _FreeCanvasPageState extends State<FreeCanvasPage>
    with TickerProviderStateMixin {
  // Current tool
  late EditorTool _tool;

  // FAB state
  bool _fabOpen = false;
  late final CodeCrafterController _controller;

  // Language registry
  final Map<String, dynamic> _languages = {
    'Dart': lang_dart.dart,
    'Python': lang_python.python,
    'JavaScript': lang_js.javascript,
    'Java': lang_java.java,
    'C++': lang_cpp.cpp,
    'Kotlin': lang_kotlin.kotlin,
    'Go': lang_go.go,
    'Rust': lang_rust.rust,
    'Swift': lang_swift.swift,
    'JSON': lang_json.json,
    'YAML': lang_yaml.yaml,
    'XML': lang_xml.xml,
    'CSS': lang_css.css,
    'Bash': lang_bash.bash,
  };

  // Theme registry

  final String _currentLanguage = 'Python';

  // Background colors per tool (all dark, subtle differences, cross-faded)
  static const Map<EditorTool, Color> _bg = {
    EditorTool.quill: Color(0xFF0F1115),
    EditorTool.math: Color(0xFF0B0E12),
    EditorTool.json: Color(0xFF0A0C0F),
    EditorTool.code: Color(0xFF0D1117),
  };

  // ---------- Quill ----------
  late final quill.QuillController _quillCtrl;

  // ---------- Math ----------
  final _mathCtrl = MathFieldEditingController();

  // ---------- JSON ----------
  late String _jsonString;

  // ---------- Code ----------
  late final _codeCtrl = _controller;
  late final String _codeText = _codeCtrl.text;

  @override
  void initState() {
    super.initState();
    _tool = widget.initialTool ?? EditorTool.quill;
    _controller = CodeCrafterController();
    _controller.language = _languages[_currentLanguage];

    // Quill starter
    _quillCtrl = quill.QuillController.basic();

    // JSON starter
    _jsonString = jsonEncode({
      "greeting": "Hello",
      "items": [1, 2, 3],
      "meta": {"ts": DateTime.now().toIso8601String()},
    });

    // Code starter
  }

  @override
  void dispose() {
    _quillCtrl.dispose();
    _mathCtrl.dispose();
    super.dispose();
  }

  void _switchTool(EditorTool t) {
    if (t == _tool) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _tool = t;
      _fabOpen = false;
    });
  }

  // Build one CanvasPart from a specific tool
  CanvasPart _buildPartForTool(EditorTool t) {
    switch (t) {
      case EditorTool.quill:
        return CanvasPart(
          type: CanvasPartType.quill,
          title: 'Canvas:Quill',
          text: _quillCtrl.document.toPlainText(),
        );
      case EditorTool.math:
        return CanvasPart(
          type: CanvasPartType.math,
          title: 'Canvas:Math',
          text: _mathCtrl.currentEditingValue(),
        );
      case EditorTool.json:
        return CanvasPart(
          type: CanvasPartType.json,
          title: 'Canvas:JSON',
          text: _jsonString,
        );
      case EditorTool.code:
        return CanvasPart(
          type: CanvasPartType.code,
          title: 'Canvas:Code',
          text: _codeText,
        );
    }
  }

  // All non-empty parts
  List<CanvasPart> _buildAllNonEmptyParts() {
    final parts = <CanvasPart>[
      _buildPartForTool(EditorTool.quill),
      _buildPartForTool(EditorTool.math),
      _buildPartForTool(EditorTool.json),
      _buildPartForTool(EditorTool.code),
    ];
    return parts.where((p) => p.text.trim().isNotEmpty).toList(growable: false);
  }

  void _useCurrentToolInChat() {
    final part = _buildPartForTool(_tool);
    Navigator.of(context).pop(CanvasResult(parts: [part]));
  }

  void _useAllInChat() {
    final all = _buildAllNonEmptyParts();
    Navigator.of(context).pop(CanvasResult(parts: all));
  }

  @override
  Widget build(BuildContext context) {
    // Always wrap with MathKeyboardViewInsets so math keyboard plays nice with insets.
    return MathKeyboardViewInsets(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
          color: _bg[_tool],
          child: SafeArea(
            bottom: false,
            child: Stack(
              children: [
                // Content area with fade switch
                Positioned.fill(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 280),
                    switchInCurve: Curves.easeOut,
                    switchOutCurve: Curves.easeIn,
                    layoutBuilder: (currentChild, previousChildren) {
                      return Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          ...previousChildren,
                          if (currentChild != null) currentChild,
                        ],
                      );
                    },
                    transitionBuilder: (child, anim) =>
                        FadeTransition(opacity: anim, child: child),
                    child: _buildTool(_tool),
                  ),
                ),

                // Minimal top gradient scrim
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: IgnorePointer(
                    child: Container(
                      height: 28,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.black54, Colors.transparent],
                        ),
                      ),
                    ),
                  ),
                ),

                // "Use in chat" action (bottom-left)
                Positioned(
                  left: 16,
                  bottom: 16 + 56, // keep above nav bars a bit
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FloatingActionButton.extended(
                        heroTag: 'use-current',
                        backgroundColor: Colors.indigoAccent,
                        icon: const Icon(
                          Icons.send_rounded,
                          color: Colors.black,
                        ),
                        label: const Text(
                          'Use in chat',
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: _useCurrentToolInChat,
                      ),
                      const SizedBox(height: 8),
                      TextButton.icon(
                        onPressed: _useAllInChat,
                        icon: const Icon(
                          Icons.playlist_add_check_circle_outlined,
                          color: Colors.white70,
                          size: 18,
                        ),
                        label: const Text(
                          'Use all',
                          style: TextStyle(color: Colors.white70),
                        ),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          backgroundColor: Colors.white12,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: _ExpandableToolFab(
          open: _fabOpen,
          onMainTap: () => setState(() => _fabOpen = !_fabOpen),
          children: [
            _ToolAction(
              icon: Icons.format_align_left,
              label: 'Rich Text',
              selected: _tool == EditorTool.quill,
              onTap: () => _switchTool(EditorTool.quill),
            ),
            _ToolAction(
              icon: Icons.functions_rounded,
              label: 'Math',
              selected: _tool == EditorTool.math,
              onTap: () => _switchTool(EditorTool.math),
            ),
            _ToolAction(
              icon: Icons.data_object,
              label: 'JSON',
              selected: _tool == EditorTool.json,
              onTap: () => _switchTool(EditorTool.json),
            ),
            _ToolAction(
              icon: Icons.code,
              label: 'Code',
              selected: _tool == EditorTool.code,
              onTap: () => _switchTool(EditorTool.code),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- Tool builders ----------

  Widget _buildTool(EditorTool tool) {
    switch (tool) {
      case EditorTool.quill:
        return _buildQuill();
      case EditorTool.math:
        return _buildMath();
      case EditorTool.json:
        return _buildJson();
      case EditorTool.code:
        return _buildCode();
    }
  }

  Widget _buildQuill() {
    return Container(
      key: const ValueKey('tool-quill'),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Column(
        children: [
          Container(
            width: 44,
            height: 4,
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: Colors.white12,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.02),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white12, width: 1),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    textSelectionTheme: TextSelectionThemeData(
                      cursorColor: Colors.indigoAccent,
                      selectionColor: Colors.indigo.withOpacity(0.25),
                      selectionHandleColor: Colors.indigoAccent,
                    ),
                  ),
                  child: quill.QuillEditor.basic(
                    key: const ValueKey('quill-basic'),
                    config: const quill.QuillEditorConfig(
                      placeholder: 'Start typing...',
                      enableInteractiveSelection: true,
                      scrollable: true,
                    ),
                    controller: _quillCtrl,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMath() {
    return Container(
      key: const ValueKey('tool-math'),
      padding: const EdgeInsets.all(16),
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _Header(title: 'Math Input'),
            const SizedBox(height: 10),
            Material(
              color: Colors.white.withOpacity(0.03),
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: MathField(
                  controller: _mathCtrl,
                  keyboardType: MathKeyboardType.expression,
                  variables: const ['x', 'y', 'z'],
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText:
                        'Enter TeX or expressions (e.g., \\frac{1}{2} + x^2)',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(12),
                  ),
                  onChanged: (_) {},
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _mathCtrl.currentEditingValue(),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white.withOpacity(0.75),
                fontFamily: 'monospace',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJson() {
    return Container(
      key: const ValueKey('tool-json'),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          const _Header(title: 'JSON Editor'),
          const SizedBox(height: 10),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.02),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white12, width: 1),
              ),
              child: JsonEditor(
                json: _jsonString,
                themeColor: Colors.indigoAccent,
                enableMoreOptions: true,
                enableKeyEdit: true,
                enableValueEdit: true,
                duration: const Duration(milliseconds: 250),
                onChanged: (v) => setState(() => _jsonString = v),
                editors: const [Editors.tree, Editors.text],
                enableHorizontalScroll: false,
                hideEditorsMenuButton: false,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCode() {
    return CodeEditorApp(_codeCtrl);
    //     key: const ValueKey('tool-code'),
    //     padding: const EdgeInsets.all(12),
    //     child: Column(
    //       children: [
    //         const _Header(title: 'Code Editor'),
    //         const SizedBox(height: 10),
    //         Expanded(
    //           child: DecoratedBox(
    //             decoration: BoxDecoration(
    //               color: const Color(0xFF0B0D11),
    //               borderRadius: BorderRadius.circular(10),
    //               border: Border.all(color: Colors.white12),
    //             ),
    //             child: ClipRRect(
    //               borderRadius: BorderRadius.circular(10),
    //               child: CodeCrafter(
    //                 key: const ValueKey('code-crafter'),
    //                 controller: _codeCtrl,
    //                 initialText: _codeText,
    //                 readOnly: false,
    //                 autoFocus: true,
    //                 wrapLines: false,
    //                 tabSize: 2,
    //                 selectionColor: Colors.indigo.withOpacity(0.25),
    //                 selectionHandleColor: Colors.indigoAccent,
    //                 cursorColor: Colors.indigoAccent,
    //                 editorField: EditorField(
    //                 onChanged: (text) => _codeText = text,
    //               )),
    //             ),
    //           ),
    //         ),
    //       ],
    //     ),
    //   );
    // }
  }
}

// ---------- UI bits ----------

class _Header extends StatelessWidget {
  const _Header({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white70,
        fontSize: 14,
        letterSpacing: 0.25,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _ToolAction {
  _ToolAction({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.selected,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool selected;
}

class _ExpandableToolFab extends StatelessWidget {
  const _ExpandableToolFab({
    required this.open,
    required this.onMainTap,
    required this.children,
  });

  final bool open;
  final VoidCallback onMainTap;
  final List<_ToolAction> children;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomRight,
      children: [
        if (open)
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onMainTap,
              child: Container(color: Colors.transparent),
            ),
          ),
        AnimatedSlide(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          offset: open ? Offset.zero : const Offset(0, 0.2),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 180),
            opacity: open ? 1 : 0,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 72.0, right: 6),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: children
                    .map(
                      (c) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _MiniFab(
                          icon: c.icon,
                          label: c.label,
                          selected: c.selected,
                          onTap: c.onTap,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
        FloatingActionButton(
          elevation: 0,
          backgroundColor: Colors.indigoAccent,
          onPressed: onMainTap,
          child: AnimatedRotation(
            duration: const Duration(milliseconds: 220),
            turns: open ? 0.125 : 0,
            child: const Icon(Icons.add, color: Colors.black),
          ),
        ),
      ],
    );
  }
}

class _MiniFab extends StatelessWidget {
  const _MiniFab({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final chipColor = selected ? Colors.indigo : Colors.white12;
    final iconColor = selected ? Colors.black : Colors.white70;

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: chipColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: selected ? Colors.indigoAccent : Colors.white10,
            width: selected ? 1.5 : 1,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: iconColor),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.black : Colors.white70,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
