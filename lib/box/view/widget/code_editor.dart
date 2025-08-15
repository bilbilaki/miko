import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_code_crafter/code_crafter.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Themes
import 'package:flutter_highlight/themes/an-old-hope.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:flutter_highlight/themes/github.dart';
import 'package:flutter_highlight/themes/vs.dart';
import 'package:flutter_highlight/themes/dracula.dart';
import 'package:flutter_highlight/themes/solarized-dark.dart';
import 'package:flutter_highlight/themes/solarized-light.dart';

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

class CodeEditorApp extends StatefulWidget {
  final CodeCrafterController codeCrafterController;
  const CodeEditorApp( this.codeCrafterController,{super.key});

  @override
  State<CodeEditorApp> createState() => _CodeEditorAppState();
}

class _CodeEditorAppState extends State<CodeEditorApp> {
  late final CodeCrafterController _controller;
  final FocusNode _focusNode = FocusNode();

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
  final Map<String, Map<String, TextStyle>> _themes = {
    'An Old Hope': anOldHopeTheme,
    'Atom One Dark': atomOneDarkTheme,
    'Monokai Sublime': monokaiSublimeTheme,
    'GitHub': githubTheme,
    'VS': vsTheme,
    'Dracula': draculaTheme,
    'Solarized Dark': solarizedDarkTheme,
    'Solarized Light': solarizedLightTheme,
  };

  String _currentLanguage = 'Python';
  String _currentTheme = 'Atom One Dark';

  bool _enableBreakpoints = true;
  bool _enableFolding = true;
  bool _enableRulerLines = true;
  bool _enableSuggestions = true;
  bool _enableGutterDivider = false;
  bool _wrapLines = false;
  bool _readOnly = false;
  int _tabSize = 3;

  // AI + LSP runtime state
  AiCompletion? _aiCompletion; // built live from prefs when enabled
  bool _aiEnabled = false;

  Future<LspConfig?>? _lspFuture; // prepared on-demand from prefs
  bool _lspEnabled = false;

  // Cached last-known LSP filePath for CodeCrafter
  String? _lspFilePath;

  @override
  void initState() {
    super.initState();
    _controller = CodeCrafterController();
    _controller.language = _languages[_currentLanguage];
    _loadPrefsAndInit();
  }

  Future<void> _loadPrefsAndInit() async {
    final sp = await SharedPreferences.getInstance();

    // AI
    _aiEnabled = sp.getBool(_kAiEnabled) ?? false;
    _aiCompletion = await _buildAiCompletionFromPrefs(sp);

    // LSP
    _lspEnabled = sp.getBool(_kLspEnabled) ?? false;
    _lspFuture = _prepareLspFromPrefs(sp);
    _lspFilePath = sp.getString(_kLspFilePath);

    setState(() {});
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  String get _fileName {
    switch (_currentLanguage) {
      case 'Dart':
        return 'main.dart';
      case 'Python':
        return 'main.py';
      case 'JavaScript':
        return 'index.js';
      case 'Java':
        return 'Main.java';
      case 'C':
        return 'main.c';
      case 'C++':
        return 'main.cpp';
      case 'Kotlin':
        return 'Main.kt';
      case 'Go':
        return 'main.go';
      case 'Rust':
        return 'main.rs';
      case 'Swift':
        return 'main.swift';
      case 'JSON':
        return 'data.json';
      case 'YAML':
        return 'config.yaml';
      case 'XML':
        return 'layout.xml';
      case 'HTML':
        return 'index.html';
      case 'CSS':
        return 'styles.css';
      case 'Bash':
        return 'script.sh';
      default:
        return 'untitled.txt';
    }
  }

  String _starterText(String lang) {
    switch (lang) {
      case 'Dart':
        return '''
import 'dart:io';

void main() {
  stdout.writeln('Hello from Dart!');
  final list = [1, 2, 3];
  for (final i in list) {
    stdout.writeln('Item: \$i');
  }
}
''';
      case 'Python':
        return '''
import sys

def greet(name: str) -> None:
  print(f"Hello, {name}!")

if __name__ == "__main__":
  greet("Python")
  nums = [1,2,3,4]
  for n in nums:
    print("Item:", n)
''';
      case 'JavaScript':
        return '''
function greet(name) {
  console.log(`Hello, {name}!`);
}

greet('JavaScript');
const arr = [1,2,3];
arr.forEach(n => console.log('Item:', n));
''';
      case 'Java':
        return '''
public class Main {
  public static void main(String[] args) {
    System.out.println("Hello from Java!");
    int[] arr = {1,2,3};
    for (int n : arr) {
      System.out.println("Item: " + n);
    }
  }
}
''';
      case 'C':
        return '''
#include <stdio.h>

int main() {
  printf("Hello from C!\\n");
  int arr[] = {1,2,3};
  for (int i = 0; i < 3; i++) {
    printf("Item: %d\\n", arr[i]);
  }
  return 0;
}
''';
      case 'C++':
        return '''
#include <iostream>
using namespace std;

int main() {
  cout << "Hello from C++!" << endl;
  int arr[] = {1,2,3};
  for (int n : arr) {
    cout << "Item: " << n << endl;
  }
  return 0;
}
''';
      case 'Kotlin':
        return '''
fun main() {
  println("Hello from Kotlin!")
  val arr = listOf(1,2,3)
  arr.forEach { println("Item: it") }
}
''';
      case 'Go':
        return '''
package main
import "fmt"

func main() {
  fmt.Println("Hello from Go!")
  arr := []int{1,2,3}
  for _, n := range arr {
    fmt.Println("Item:", n)
  }
}
''';
      case 'Rust':
        return '''
fn main() {
  println!("Hello from Rust!");
  let arr = [1, 2, 3];
  for n in arr {
    println!("Item: {}", n);
  }
}
''';
      case 'Swift':
        return '''
import Foundation

print("Hello from Swift!")
let arr = [1,2,3]
for n in arr {
  print("Item: \\(n)")
}
''';
      case 'JSON':
        return '''
{
  "greeting": "Hello",
  "items": [1, 2, 3]
}
''';
      case 'YAML':
        return '''
greeting: Hello
items:
  - 1
  - 2
  - 3
''';
      case 'XML':
        return '''
<root>
  <greeting>Hello</greeting>
  <items>
    <item>1</item>
    <item>2</item>
    <item>3</item>
  </items>
</root>
''';
      case 'HTML':
        return '''
<!DOCTYPE html>
<html>
  <head>
    <title>Hello</title>
  </head>
  <body>
    <h1>Hello from HTML!</h1>
    <ul>
      <li>1</li><li>2</li><li>3</li>
    </ul>
  </body>
</html>
''';
      case 'CSS':
        return '''
:root { --fg: #222; }
body {
  color: var(--fg);
  font-family: system-ui, sans-serif;
}
ul li { padding: 4px 0; }
''';
      case 'Bash':
        return '''
#!/usr/bin/env bash
echo "Hello from Bash!"
for i in 1 2 3; do
  echo "Item: i"
done
''';
      default:
        return 'Hello!';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = _themes[_currentTheme]!;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Code Crafter Demo',
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Code Editor'),
          actions: [
            _LangPicker(
              items: _languages.keys.toList(),
              value: _currentLanguage,
              onChanged: (v) {
                if (v == null) return;
                setState(() {
                  _currentLanguage = v;
                  _controller.language = _languages[v];
                });
              },
            ),
            _ThemePicker(
              items: _themes.keys.toList(),
              value: _currentTheme,
              onChanged: (v) {
                if (v == null) return;
                setState(() => _currentTheme = v);
              },
            ),
            const SizedBox(width: 8),
            IconButton(
              tooltip: 'AI Settings',
              icon: const Icon(Icons.memory_outlined),
              onPressed: _openAiDialog,
            ),
            IconButton(
              tooltip: 'LSP Settings',
              icon: const Icon(Icons.hub_outlined),
              onPressed: _openLspDialog,
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: Column(
          children: [
            _Toolbar(
              enableBreakpoints: _enableBreakpoints,
              enableFolding: _enableFolding,
              enableRulerLines: _enableRulerLines,
              enableSuggestions: _enableSuggestions,
              enableGutterDivider: _enableGutterDivider,
              wrapLines: _wrapLines,
              readOnly: _readOnly,
              tabSize: _tabSize,
              onChanged: (s) => setState(() {
                _enableBreakpoints = s.enableBreakpoints;
                _enableFolding = s.enableFolding;
                _enableRulerLines = s.enableRulerLines;
                _enableSuggestions = s.enableSuggestions;
                _enableGutterDivider = s.enableGutterDivider;
                _wrapLines = s.wrapLines;
                _readOnly = s.readOnly;
                _tabSize = s.tabSize;
              }),
            ),
            const Divider(height: 1),
            Expanded(
              child: FutureBuilder<LspConfig?>(
                future: _lspEnabled ? _lspFuture : Future.value(null),
                builder: (context, snapshot) {
                  final lspConfig = _lspEnabled ? snapshot.data : null;

                  // If waiting for LSP init (stdio), show small loader. Editor still loads after init.
                  final busy =
                      _lspEnabled &&
                      (snapshot.connectionState == ConnectionState.waiting);

                  return Stack(
                    children: [
                      CodeCrafter(
                        key: const ValueKey('code-editor'),
                        controller: widget.codeCrafterController,
                        initialText: _starterText(_currentLanguage),

                        // If LSP is enabled we must pass exact same filePath to both CodeCrafter and LspConfig.
                        // filePath: _lspEnabled ? (_lspFilePath ?? _fileName) : _fileName,
                        focusNode: _focusNode,

                        editorTheme: theme,

                        // Styling
                        textStyle: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 13.5,
                          height: 1.45,
                        ),
                        gutterStyle: GutterStyle(
                          gutterWidth: 48,
                          dividerColor: Colors.grey.shade800,
                          dividerThickness: _enableGutterDivider ? 1 : 0,
                          breakpointColor: Colors.redAccent,
                          unfilledBreakpointColor: Colors.transparent,
                          foldedIconColor: Colors.grey,
                          unfoldedIconColor: Colors.grey,
                          breakpointSize: 10,
                          foldingIconSize: 18,
                        ),
                        // suggestionStyle: const TextStyle(
                        //  fontFamily: 'monospace',
                        // fontSize: 13,
                        // ),
                        // hoverDetailsStyle: const TextStyle(
                        //  fontFamily: 'monospace',
                        //   fontSize: 13,
                        //  ),
                        aiCompletionTextStyle: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 13,
                          color: Colors.grey,
                        ),

                        // Colors
                        selectionColor: Colors.indigo.withOpacity(0.25),
                        selectionHandleColor: Colors.indigoAccent,
                        cursorColor: Colors.indigoAccent,

                        // Toggles
                        enableBreakPoints: _enableBreakpoints,
                        enableFolding: _enableFolding,
                        enableRulerLines: _enableRulerLines,
                        enableSuggestions: _enableSuggestions,
                        enableGutterDivider: _enableGutterDivider,
                        wrapLines: _wrapLines,
                        readOnly: _readOnly,
                        autoFocus: true,
                        tabSize: _tabSize,

                        // Feature configs
                        aiCompletion: _aiEnabled ? _aiCompletion : null,
                        lspConfig: lspConfig,
                      ),
                      if (busy)
                        Positioned(
                          right: 12,
                          top: 12,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text('Starting LSP...'),
                            ],
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- AI Config ----------

  static const _kAiEnabled = 'ai.enabled';
  static const _kAiProvider = 'ai.provider'; // Gemini/OpenAI/.../Custom
  static const _kAiApiKey = 'ai.apiKey';
  static const _kAiModel = 'ai.model';
  static const _kAiBaseUrl = 'ai.baseUrl'; // used only for Custom

  static const List<String> _aiProviders = <String>[
    'Gemini',
    'OpenAI',
    'Claude',
    'Grok',
    'DeepSeek',
    'Gorq',
    'TogetherAi',
    'Sonar',
    'OpenRouter',
    'FireWorks',
    'Custom',
  ];

  Future<AiCompletion?> _buildAiCompletionFromPrefs(
    SharedPreferences sp,
  ) async {
    final enabled = sp.getBool(_kAiEnabled) ?? false;
    if (!enabled) return null;

    final provider = sp.getString(_kAiProvider) ?? 'Gemini';
    final apiKey = sp.getString(_kAiApiKey) ?? '';
    final model = sp.getString(_kAiModel);
    final baseUrl = sp.getString(_kAiBaseUrl);

    Models? m;

    switch (provider) {
      case 'Gemini':
        if (apiKey.isEmpty) return null;
        m = Gemini(
          apiKey: apiKey,
          model: model.toString(), // null => defaults to gemini-2.0-flash
        );
        break;
      case 'OpenAI':
        if (apiKey.isEmpty || (model == null || model.isEmpty)) return null;
        m = OpenAI(apiKey: apiKey, model: model);
        break;
      case 'Claude':
        if (apiKey.isEmpty || (model == null || model.isEmpty)) return null;
        m = Claude(apiKey: apiKey, model: model);
        break;
      case 'Grok':
        if (apiKey.isEmpty || (model == null || model.isEmpty)) return null;
        m = Grok(apiKey: apiKey, model: model);
        break;
      case 'DeepSeek':
        if (apiKey.isEmpty || (model == null || model.isEmpty)) return null;
        m = DeepSeek(apiKey: apiKey, model: model);
        break;
      case 'Gorq':
        if (apiKey.isEmpty || (model == null || model.isEmpty)) return null;
        m = Gorq(apiKey: apiKey, model: model);
        break;
      case 'TogetherAi':
        if (apiKey.isEmpty || (model == null || model.isEmpty)) return null;
        m = TogetherAi(apiKey: apiKey, model: model);
        break;
      case 'Sonar':
        if (apiKey.isEmpty || (model == null || model.isEmpty)) return null;
        m = Sonar(apiKey: apiKey, model: model);
        break;
      case 'OpenRouter':
        if (apiKey.isEmpty || (model == null || model.isEmpty)) return null;
        m = OpenRouter(apiKey: apiKey, model: model);
        break;
      case 'FireWorks':
        if (apiKey.isEmpty || (model == null || model.isEmpty)) return null;
        m = FireWorks(apiKey: apiKey, model: model);
        break;
      case 'Custom':
        if ((baseUrl == null || baseUrl.isEmpty) ||
            apiKey.isEmpty ||
            (model == null || model.isEmpty)) {
          return null;
        }
        // Generic OpenAI-compatible chat completions style request.
        m = CustomModel(
          url: baseUrl,
          customHeaders: {
            'Authorization': 'Bearer $apiKey',
            'Content-Type': 'application/json',
          },
          requestBuilder: (code, instruction) {
            return {
              'model': model,
              'messages': [
                {'role': 'system', 'content': instruction},
                {'role': 'user', 'content': code},
              ],
            };
          },
          customParser: (response) {
            // Try several common shapes:
            // OpenAI-like
            try {
              final c = response['choices'][0];
              final msg = c['message'];
              if (msg is Map && msg['content'] is String) {
                return msg['content'];
              }
            } catch (_) {}
            // Together/OpenAI alt
            try {
              return response['choices'][0]['text'];
            } catch (_) {}
            // Fallback
            return response.toString();
          },
        );
        break;
      default:
        return null;
    }

    return AiCompletion(model: m);
  }

  Future<void> _openAiDialog() async {
    final sp = await SharedPreferences.getInstance();

    final initEnabled = sp.getBool(_kAiEnabled) ?? false;
    final initProvider = sp.getString(_kAiProvider) ?? 'Gemini';
    final initApiKey = sp.getString(_kAiApiKey) ?? '';
    final initModel = sp.getString(_kAiModel) ?? '';
    final initBaseUrl = sp.getString(_kAiBaseUrl) ?? '';

    bool enabled = initEnabled;
    String provider = initProvider;
    final apiKeyCtrl = TextEditingController(text: initApiKey);
    final modelCtrl = TextEditingController(text: initModel);
    final baseUrlCtrl = TextEditingController(text: initBaseUrl);

    await showDialog<void>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setS) {
            final isCustom = provider == 'Custom';
            final needsModel = isCustom || provider != 'Gemini';

            return AlertDialog(
              title: const Text('AI Settings'),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      value: enabled,
                      onChanged: (v) => setS(() => enabled = v ?? false),
                      title: const Text('Enable AI Completion'),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    const SizedBox(height: 8),
                    InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Provider',
                        border: OutlineInputBorder(),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: provider,
                          isExpanded: true,
                          items: _aiProviders
                              .map(
                                (e) =>
                                    DropdownMenuItem(value: e, child: Text(e)),
                              )
                              .toList(),
                          onChanged: (v) =>
                              setS(() => provider = v ?? provider),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: apiKeyCtrl,
                      decoration: const InputDecoration(
                        labelText: 'API Key',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                    ),
                    const SizedBox(height: 12),
                    if (needsModel)
                      TextField(
                        controller: modelCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Model (required for most providers)',
                          hintText: 'e.g. gpt-4o-mini, claude-3-5-sonnet, etc.',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    if (needsModel) const SizedBox(height: 12),
                    if (isCustom)
                      TextField(
                        controller: baseUrlCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Base URL (Custom model endpoint)',
                          hintText:
                              'e.g. https://api.together.xyz/v1/chat/completions',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    if (isCustom) const SizedBox(height: 8),
                    if (provider == 'Gemini')
                      const Text(
                        'Note: Model is optional for Gemini (defaults to gemini-2.0-flash)',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Cancel'),
                ),
                FilledButton.tonal(
                  onPressed: () async {
                    // Save prefs
                    await sp.setBool(_kAiEnabled, enabled);
                    await sp.setString(_kAiProvider, provider);
                    await sp.setString(_kAiApiKey, apiKeyCtrl.text.trim());
                    await sp.setString(_kAiModel, modelCtrl.text.trim());
                    await sp.setString(_kAiBaseUrl, baseUrlCtrl.text.trim());

                    // Rebuild runtime config
                    final completion = await _buildAiCompletionFromPrefs(sp);

                    setState(() {
                      _aiEnabled = enabled;
                      _aiCompletion = completion;
                    });
                    if (mounted) Navigator.pop(ctx);
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ---------- LSP Config ----------

  static const _kLspEnabled = 'lsp.enabled';
  static const _kLspKind = 'lsp.kind'; // 'socket' | 'stdio'
  static const _kLspServerUrl = 'lsp.serverUrl';
  static const _kLspExecutable = 'lsp.executable';
  static const _kLspArgs = 'lsp.args'; // space-separated
  static const _kLspFilePath = 'lsp.filePath';
  static const _kLspWorkspacePath = 'lsp.workspacePath';
  static const _kLspLanguageId = 'lsp.languageId';

  Future<LspConfig?> _prepareLspFromPrefs(SharedPreferences sp) async {
    final enabled = sp.getBool(_kLspEnabled) ?? false;
    if (!enabled) return null;

    final kind = sp.getString(_kLspKind) ?? 'socket';
    final filePath = sp.getString(_kLspFilePath);
    final workspacePath = sp.getString(_kLspWorkspacePath);
    final languageId = sp.getString(_kLspLanguageId);

    if ((filePath == null || filePath.isEmpty) ||
        (workspacePath == null || workspacePath.isEmpty) ||
        (languageId == null || languageId.isEmpty)) {
      return null;
    }

    if (kind == 'socket') {
      final serverUrl = sp.getString(_kLspServerUrl);
      if (serverUrl == null || serverUrl.isEmpty) return null;

      return LspSocketConfig(
        serverUrl: serverUrl,
        filePath: filePath,
        workspacePath: workspacePath,
        languageId: languageId,
      );
    } else {
      final exe = sp.getString(_kLspExecutable);
      if (exe == null || exe.isEmpty) return null;

      final argsRaw = sp.getString(_kLspArgs) ?? '';
      final args = argsRaw.trim().isEmpty
          ? const <String>[]
          : argsRaw.split(RegExp(r'\s+'));

      try {
        final config = await LspStdioConfig.start(
          executable: exe,
          args: args,
          filePath: filePath,
          workspacePath: workspacePath,
          languageId: languageId,
        );
        return config;
      } catch (e) {
        debugPrint('LSP init failed: $e');
        return null;
      }
    }
  }

  Future<void> _openLspDialog() async {
    final sp = await SharedPreferences.getInstance();

    bool enabled = sp.getBool(_kLspEnabled) ?? false;
    String kind = sp.getString(_kLspKind) ?? 'socket';

    final serverUrlCtrl = TextEditingController(
      text: sp.getString(_kLspServerUrl) ?? '',
    );

    final exeCtrl = TextEditingController(
      text: sp.getString(_kLspExecutable) ?? '',
    );
    final argsCtrl = TextEditingController(text: sp.getString(_kLspArgs) ?? '');

    final filePathCtrl = TextEditingController(
      text: sp.getString(_kLspFilePath) ?? '',
    );
    final workspaceCtrl = TextEditingController(
      text: sp.getString(_kLspWorkspacePath) ?? '',
    );
    final langIdCtrl = TextEditingController(
      text: sp.getString(_kLspLanguageId) ?? '',
    );

    await showDialog<void>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setS) {
            final isSocket = kind == 'socket';
            return AlertDialog(
              title: const Text('LSP Settings'),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      value: enabled,
                      onChanged: (v) => setS(() => enabled = v ?? false),
                      title: const Text('Enable LSP Client'),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    const SizedBox(height: 8),
                    InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Connection Type',
                        border: OutlineInputBorder(),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: kind,
                          isExpanded: true,
                          items: const [
                            DropdownMenuItem(
                              value: 'socket',
                              child: Text('WebSocket'),
                            ),
                            DropdownMenuItem(
                              value: 'stdio',
                              child: Text('Stdio'),
                            ),
                          ],
                          onChanged: (v) => setS(() => kind = v ?? 'socket'),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (isSocket)
                      TextField(
                        controller: serverUrlCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Server URL',
                          hintText: 'ws://localhost:5656',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    if (isSocket) const SizedBox(height: 12),
                    if (!isSocket)
                      TextField(
                        controller: exeCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Executable (absolute path)',
                          hintText: '/usr/bin/pyright-langserver',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    if (!isSocket) const SizedBox(height: 12),
                    if (!isSocket)
                      TextField(
                        controller: argsCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Args',
                          hintText: '--stdio',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: filePathCtrl,
                      decoration: const InputDecoration(
                        labelText: 'File Path',
                        hintText: '/path/to/project/main.py',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: workspaceCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Workspace Path',
                        hintText: '/path/to/project',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: langIdCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Language ID',
                        hintText: 'python | typescript | dart | ...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Note: The filePath passed to CodeCrafter and LspConfig must match.',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Cancel'),
                ),
                FilledButton.tonal(
                  onPressed: () async {
                    await sp.setBool(_kLspEnabled, enabled);
                    await sp.setString(_kLspKind, kind);
                    await sp.setString(
                      _kLspServerUrl,
                      serverUrlCtrl.text.trim(),
                    );
                    await sp.setString(_kLspExecutable, exeCtrl.text.trim());
                    await sp.setString(_kLspArgs, argsCtrl.text.trim());
                    await sp.setString(_kLspFilePath, filePathCtrl.text.trim());
                    await sp.setString(
                      _kLspWorkspacePath,
                      workspaceCtrl.text.trim(),
                    );
                    await sp.setString(_kLspLanguageId, langIdCtrl.text.trim());

                    final fut = _prepareLspFromPrefs(sp);

                    setState(() {
                      _lspEnabled = enabled;
                      _lspFuture = fut;
                      _lspFilePath = filePathCtrl.text.trim().isEmpty
                          ? null
                          : filePathCtrl.text.trim();
                    });

                    if (mounted) Navigator.pop(ctx);
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

// ---------- UI bits below (unchanged toolbar and pickers) ----------

class _LangPicker extends StatelessWidget {
  const _LangPicker({
    required this.items,
    required this.value,
    required this.onChanged,
  });

  final List<String> items;
  final String value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: value,
        items: items
            .map(
              (e) => DropdownMenuItem(
                value: e,
                child: Text(e, style: const TextStyle(fontSize: 13)),
              ),
            )
            .toList(),
        onChanged: onChanged,
        dropdownColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        padding: const EdgeInsets.symmetric(horizontal: 8),
      ),
    );
  }
}

class _ThemePicker extends StatelessWidget {
  const _ThemePicker({
    required this.items,
    required this.value,
    required this.onChanged,
  });

  final List<String> items;
  final String value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: value,
        items: items
            .map(
              (e) => DropdownMenuItem(
                value: e,
                child: Text(e, style: const TextStyle(fontSize: 13)),
              ),
            )
            .toList(),
        onChanged: onChanged,
        dropdownColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        padding: const EdgeInsets.symmetric(horizontal: 8),
      ),
    );
  }
}

class _Toolbar extends StatelessWidget {
  const _Toolbar({
    required this.enableBreakpoints,
    required this.enableFolding,
    required this.enableRulerLines,
    required this.enableSuggestions,
    required this.enableGutterDivider,
    required this.wrapLines,
    required this.readOnly,
    required this.tabSize,
    required this.onChanged,
  });

  final bool enableBreakpoints;
  final bool enableFolding;
  final bool enableRulerLines;
  final bool enableSuggestions;
  final bool enableGutterDivider;
  final bool wrapLines;
  final bool readOnly;
  final int tabSize;

  final ValueChanged<_ToolbarState> onChanged;

  @override
  Widget build(BuildContext context) {
    final labelStyle = Theme.of(context).textTheme.labelSmall;

    return Material(
      color: Theme.of(context).colorScheme.surfaceContainerHigh,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 12,
          runSpacing: 6,
          children: [
            _boolToggle(
              'Breakpoints',
              enableBreakpoints,
              (v) => onChanged(_ToolbarState.copy(this, enableBreakpoints: v)),
              labelStyle,
            ),
            _boolToggle(
              'Folding',
              enableFolding,
              (v) => onChanged(_ToolbarState.copy(this, enableFolding: v)),
              labelStyle,
            ),
            _boolToggle(
              'Rulers',
              enableRulerLines,
              (v) => onChanged(_ToolbarState.copy(this, enableRulerLines: v)),
              labelStyle,
            ),
            _boolToggle(
              'Suggestions',
              enableSuggestions,
              (v) => onChanged(_ToolbarState.copy(this, enableSuggestions: v)),
              labelStyle,
            ),
            _boolToggle(
              'Gutter Divider',
              enableGutterDivider,
              (v) =>
                  onChanged(_ToolbarState.copy(this, enableGutterDivider: v)),
              labelStyle,
            ),
            _boolToggle(
              'Wrap Lines',
              wrapLines,
              (v) => onChanged(_ToolbarState.copy(this, wrapLines: v)),
              labelStyle,
            ),
            _boolToggle(
              'Read Only',
              readOnly,
              (v) => onChanged(_ToolbarState.copy(this, readOnly: v)),
              labelStyle,
            ),
            SizedBox(
              width: 180,
              child: Row(
                children: [
                  Text('Tab Size', style: labelStyle),
                  Expanded(
                    child: Slider(
                      value: tabSize.toDouble(),
                      min: 2,
                      max: 8,
                      divisions: 6,
                      label: '$tabSize',
                      onChanged: (v) => onChanged(
                        _ToolbarState.copy(this, tabSize: v.round()),
                      ),
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

  Widget _boolToggle(
    String label,
    bool value,
    ValueChanged<bool> onChanged,
    TextStyle? style,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Switch(
          value: value,
          onChanged: onChanged,
          //  visualDensity: VisualDensity.compact,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        Text(label, style: style),
      ],
    );
  }
}

class _ToolbarState {
  final bool enableBreakpoints;
  final bool enableFolding;
  final bool enableRulerLines;
  final bool enableSuggestions;
  final bool enableGutterDivider;
  final bool wrapLines;
  final bool readOnly;
  final int tabSize;

  _ToolbarState({
    required this.enableBreakpoints,
    required this.enableFolding,
    required this.enableRulerLines,
    required this.enableSuggestions,
    required this.enableGutterDivider,
    required this.wrapLines,
    required this.readOnly,
    required this.tabSize,
  });

  static _ToolbarState copy(
    _Toolbar toolbar, {
    bool? enableBreakpoints,
    bool? enableFolding,
    bool? enableRulerLines,
    bool? enableSuggestions,
    bool? enableGutterDivider,
    bool? wrapLines,
    bool? readOnly,
    int? tabSize,
  }) {
    return _ToolbarState(
      enableBreakpoints: enableBreakpoints ?? toolbar.enableBreakpoints,
      enableFolding: enableFolding ?? toolbar.enableFolding,
      enableRulerLines: enableRulerLines ?? toolbar.enableRulerLines,
      enableSuggestions: enableSuggestions ?? toolbar.enableSuggestions,
      enableGutterDivider: enableGutterDivider ?? toolbar.enableGutterDivider,
      wrapLines: wrapLines ?? toolbar.wrapLines,
      readOnly: readOnly ?? toolbar.readOnly,
      tabSize: tabSize ?? toolbar.tabSize,
    );
  }
}
