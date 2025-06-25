import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:highlight/highlight_core.dart';
import 'package:highlight/languages/cpp.dart';
import 'package:highlight/languages/cs.dart';
import 'package:highlight/languages/css.dart';
import 'package:highlight/languages/dart.dart';
import 'package:highlight/languages/go.dart';
import 'package:highlight/languages/htmlbars.dart';
import 'package:highlight/languages/java.dart';
import 'package:highlight/languages/javascript.dart';
import 'package:highlight/languages/kotlin.dart';
import 'package:highlight/languages/plaintext.dart';
import 'package:highlight/languages/python.dart';
import 'package:highlight/languages/ruby.dart';
import 'package:highlight/languages/rust.dart';
import 'package:highlight/languages/swift.dart';
import 'package:highlight/languages/typescript.dart';
import 'package:highlight/languages/xml.dart';
import '../labs/home_screen.dart';
import 'widgets/code_editor_widget.dart';
import 'widgets/file_explorer_widget.dart';
import 'widgets/terminal_widget.dart';
import 'widgets/toolbar_widget.dart';

class CodeEditorIDE extends StatefulWidget {
  const CodeEditorIDE({super.key});

  @override
  State<CodeEditorIDE> createState() => CodeEditorIDEState();
}

class CodeEditorIDEState extends State<CodeEditorIDE>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late TabController _bottomTabController;

  final TextEditingController _findController = TextEditingController();
   late  final CodeController _codeController = CodeController( language: _getCommentPrefix(),  analyzer: DefaultLocalAnalyzer());

  final TextEditingController _replaceController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String selectedLanguage= 'Dart';
  String _selectedTheme = 'Dark';
  bool _isFileExplorerVisible = true;
  bool _isTerminalVisible = true;
  bool _isFindReplaceVisible = false;
  bool _isRunning = false;

  final List<String> _languages = [
    'Dart',
    'Flutter',
    'JavaScript',
    'TypeScript',
    'Python',
    'Java',
    'C++',
    'C#',
    'Go',
    'Rust',
    'Swift',
    'Kotlin',
    'PHP',
    'Ruby',
    'HTML',
    'CSS',
    'JSON',
    'XML',
    'YAML',
    'Markdown',
  ];
  Mode _getCommentPrefix()  {
    switch (selectedLanguage) {
      case 'dart':
        return  dart;

      case 'flutter':
        return  dart;
      case 'javascript':
        return  javascript;
      case 'typescript':
        return  typescript;
      case 'java':
        return  java;
      case 'c++':
        return  cpp;
      case 'c#':
        return  cs;
      case 'go':
        return  go;
      case 'rust':
        return  rust;
      case 'swift':
        return  swift;
      case 'kotlin':
        return  kotlin;
      case 'python':
        return  python;
      case 'ruby':
        return  ruby;
      case 'html':
        return  htmlbars;
      case 'xml':
        return  xml;
      case 'css':
        return  css;
      default:
        return  plaintext;
    }
  }

  final List<String> _themes = ['Dark', 'Light', 'Monokai', 'Solarized'];

  final List<Map<String, dynamic>> _openFiles = [
    {'name': 'main.dart', 'path': '/lib/main.dart', 'modified': false},
    {'name': 'app.dart', 'path': '/lib/app.dart', 'modified': true},
  ];

  final int _currentFileIndex = 0;

  final Map<String, String> _codeTemplates = {
    'Dart': '''void main() {
  print('Hello, Dart!');
}

class MyClass {
  String name;
  
  MyClass(this.name);
  
  void greet() {
    print('Hello, \$name!');
  }
}''',
    'Flutter': '''import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('You have pushed the button this many times:'),
            Text(
              '\$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}''',
    'JavaScript': '''// JavaScript Example
function greet(name) {
    return `Hello, \${name}!`;
}

class Person {
    constructor(name, age) {
        this.name = name;
        this.age = age;
    }
    
    introduce() {
        console.log(`Hi, I'm \${this.name} and I'm \${this.age} years old.`);
    }
}

const person = new Person('John', 25);
person.introduce();

// Async/Await Example
async function fetchData() {
    try {
        const response = await fetch('https://api.example.com/data');
        const data = await response.json();
        return data;
    } catch (error) {
        console.error('Error fetching data:', error);
    }
}''',
    'Python': '''# Python Example
def greet(name):
    return f"Hello, {name}!"

class Person:
    def __init__(self, name, age):
        self.name = name
        self.age = age
    
    def introduce(self):
        print(f"Hi, I'm {self.name} and I'm {self.age} years old.")

# List comprehension
numbers = [1, 2, 3, 4, 5]
squares = [x**2 for x in numbers]

# Dictionary comprehension
word_lengths = {word: len(word) for word in ['hello', 'world', 'python']}

# Main execution
if __name__ == "__main__":
    person = Person("Alice", 30)
    person.introduce()
    print(f"Squares: {squares}")
    print(f"Word lengths: {word_lengths}")''',
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _openFiles.length, vsync: this);
    _bottomTabController = TabController(length: 3, vsync: this);
    _codeController.text = _codeTemplates[selectedLanguage] ?? '';
  }

  @override
  void dispose() {
    _tabController.dispose();
    _bottomTabController.dispose();
    _codeController.dispose();
    _findController.dispose();
    _replaceController.dispose();
    super.dispose();
  }

  void _onLanguageChanged(String language) {
    setState(() {
      selectedLanguage= language;
      _codeController.text = _codeTemplates[language] ?? '';
    });
  }

  void _runCode() {
    setState(() {
      _isRunning = true;
    });

    // Simulate code execution
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isRunning = false;
        });
        _showOutput('Code executed successfully!\nOutput: Hello, World!');
      }
    });
  }

  void _showOutput(String output) {
    setState(() {
      _isTerminalVisible = true;
    });
    // In a real IDE, this would update the terminal widget
  }

  void _duplicateLine() {
    final text = _codeController.text;
    final selection = _codeController.selection;
    final lines = text.split('\n');

    if (selection.isValid) {
      final currentLine = _getCurrentLineNumber(text, selection.start);
      if (currentLine < lines.length) {
        lines.insert(currentLine + 1, lines[currentLine]);
        _codeController.text = lines.join('\n');
      }
    }
  }

  int _getCurrentLineNumber(String text, int position) {
    return text.substring(0, position).split('\n').length - 1;
  }

  void _findAndReplace() {
    setState(() {
      _isFindReplaceVisible = !_isFindReplaceVisible;
    });
  }

  void _performFind() {
    final findText = _findController.text;
    if (findText.isNotEmpty) {
      final text = _codeController.text;
      final index = text.indexOf(findText);
      if (index != -1) {
        _codeController.selection = TextSelection(
          baseOffset: index,
          extentOffset: index + findText.length,
        );
      }
    }
  }

  void _performReplace() {
    final findText = _findController.text;
    final replaceText = _replaceController.text;
    if (findText.isNotEmpty) {
      final text = _codeController.text;
      final newText = text.replaceFirst(findText, replaceText);
      _codeController.text = newText;
    }
  }

  void _performReplaceAll() {
    final findText = _findController.text;
    final replaceText = _replaceController.text;
    if (findText.isNotEmpty) {
      final text = _codeController.text;
      final newText = text.replaceAll(findText, replaceText);
      _codeController.text = newText;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          _selectedTheme == 'Dark'
              ? const Color(0xFF1E1E1E)
              : const Color(0xFFF5F5F5),
      appBar: _buildAppBar(),
      drawer: const ComponentLibraryDrawer(),

      body: Column(
        children: [
          // Toolbar
          ToolbarWidget(
            selectedLanguage: selectedLanguage,
            selectedTheme: _selectedTheme,
            languages: _languages,
            themes: _themes,
            isRunning: _isRunning,
            onLanguageChanged: _onLanguageChanged,
            onThemeChanged: (theme) => setState(() => _selectedTheme = theme),
            onRun: _runCode,
            onDuplicate: _duplicateLine,
            onFindReplace: _findAndReplace,
            onToggleFileExplorer:
                () => setState(
                  () => _isFileExplorerVisible = !_isFileExplorerVisible,
                ),
            onToggleTerminal:
                () => setState(() => _isTerminalVisible = !_isTerminalVisible),
          ),

          // Find/Replace Bar
          if (_isFindReplaceVisible) _buildFindReplaceBar(),

          // Main Content
          Expanded(
            child: Row(
              children: [
                // File Explorer
                if (_isFileExplorerVisible)
                  Container(
                    width: 250,
                    decoration: BoxDecoration(
                      color:
                          _selectedTheme == 'Dark'
                              ? const Color(0xFF252526)
                              : Colors.white,
                      border: Border(
                        right: BorderSide(
                          color:
                              _selectedTheme == 'Dark'
                                  ? const Color(0xFF3E3E42)
                                  : const Color(0xFFE0E0E0),
                        ),
                      ),
                    ),
                    child: FileExplorerWidget(
                      isDark: _selectedTheme == 'Dark',
                      onFileSelected: (file) {
                        // Handle file selection
                      },
                    ),
                  ),

                // Editor Area
                Expanded(
                  child: Column(
                    children: [
                      // File Tabs
                      _buildFileTabs(),

                      // Code Editor
                      Expanded(
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          physics: AlwaysScrollableScrollPhysics(),

                          scrollDirection: Axis.vertical,
                          reverse: false,
                          dragStartBehavior: DragStartBehavior.start,

                          child: SizedBox(
                            height: 800,
                            child: CodeEditorWidget(
                              controller: _codeController,
                              language: selectedLanguage,
                              isDark: _selectedTheme == 'Dark',
                              onChanged: (text) {
                                // Mark file as modified
                                setState(() {
                                  _openFiles[_currentFileIndex]['modified'] =
                                      true;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Bottom Panel (Terminal, Output, etc.)
          if (_isTerminalVisible) _buildBottomPanel(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor:
          _selectedTheme == 'Dark'
              ? const Color(0xFF2D2D30)
              : const Color(0xFF007ACC),
      foregroundColor: Colors.white,
      title: const Text('Future Reach IDE'),
      actions: [
        IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {},
          tooltip: 'Home',
        ),
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {},
          tooltip: 'Settings',
        ),
        IconButton(
          icon: const Icon(Icons.help_outline),
          onPressed: () {},
          tooltip: 'Help',
        ),
      ],
    );
  }

  Widget _buildFindReplaceBar() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color:
            _selectedTheme == 'Dark'
                ? const Color(0xFF3C3C3C)
                : const Color(0xFFF3F3F3),
        border: Border(
          bottom: BorderSide(
            color:
                _selectedTheme == 'Dark'
                    ? const Color(0xFF3E3E42)
                    : const Color(0xFFE0E0E0),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _findController,
              decoration: const InputDecoration(
                hintText: 'Find',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              style: TextStyle(
                color: _selectedTheme == 'Dark' ? Colors.white : Colors.black,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _replaceController,
              decoration: const InputDecoration(
                hintText: 'Replace',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              style: TextStyle(
                color: _selectedTheme == 'Dark' ? Colors.white : Colors.black,
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _performFind,
            tooltip: 'Find',
          ),
          IconButton(
            icon: const Icon(Icons.find_replace),
            onPressed: _performReplace,
            tooltip: 'Replace',
          ),
          IconButton(
            icon: const Icon(Icons.select_all),
            onPressed: _performReplaceAll,
            tooltip: 'Replace All',
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => setState(() => _isFindReplaceVisible = false),
            tooltip: 'Close',
          ),
        ],
      ),
    );
  }

  Widget _buildFileTabs() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color:
            _selectedTheme == 'Dark'
                ? const Color(0xFF2D2D30)
                : const Color(0xFFF3F3F3),
        border: Border(
          bottom: BorderSide(
            color:
                _selectedTheme == 'Dark'
                    ? const Color(0xFF3E3E42)
                    : const Color(0xFFE0E0E0),
          ),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        labelColor: _selectedTheme == 'Dark' ? Colors.white : Colors.black,
        unselectedLabelColor:
            _selectedTheme == 'Dark' ? Colors.white70 : Colors.black54,
        indicatorColor: const Color(0xFF007ACC),
        tabs:
            _openFiles.asMap().entries.map((entry) {
              final index = entry.key;
              final file = entry.value;
              return Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(_getFileIcon(file['name']), size: 16),
                    const SizedBox(width: 4),
                    Text(file['name']),
                    if (file['modified'])
                      Container(
                        margin: const EdgeInsets.only(left: 4),
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Colors.orange,
                          shape: BoxShape.circle,
                        ),
                      ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        // Close tab
                        setState(() {
                          _openFiles.removeAt(index);
                          if (_openFiles.isNotEmpty) {
                            _tabController = TabController(
                              length: _openFiles.length,
                              vsync: this,
                            );
                          }
                        });
                      },
                      child: const Icon(Icons.close, size: 14),
                    ),
                  ],
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildBottomPanel() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color:
            _selectedTheme == 'Dark' ? const Color(0xFF1E1E1E) : Colors.white,
        border: Border(
          top: BorderSide(
            color:
                _selectedTheme == 'Dark'
                    ? const Color(0xFF3E3E42)
                    : const Color(0xFFE0E0E0),
          ),
        ),
      ),
      child: Column(
        children: [
          TabBar(
            controller: _bottomTabController,
            labelColor: _selectedTheme == 'Dark' ? Colors.white : Colors.black,
            unselectedLabelColor:
                _selectedTheme == 'Dark' ? Colors.white70 : Colors.black54,
            indicatorColor: const Color(0xFF007ACC),
            tabs: const [
              Tab(text: 'Terminal'),
              Tab(text: 'Output'),
              Tab(text: 'Problems'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _bottomTabController,
              children: [
                TerminalWidget(isDark: _selectedTheme == 'Dark'),
                _buildOutputPanel(),
                _buildProblemsPanel(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOutputPanel() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Output',
            style: TextStyle(
              color: _selectedTheme == 'Dark' ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color:
                    _selectedTheme == 'Dark'
                        ? const Color(0xFF0C0C0C)
                        : const Color(0xFFF8F8F8),
                border: Border.all(
                  color:
                      _selectedTheme == 'Dark'
                          ? const Color(0xFF3E3E42)
                          : const Color(0xFFE0E0E0),
                ),
              ),
              child: Text(
                _isRunning
                    ? 'Running...'
                    : 'Code executed successfully!\nOutput: Hello, World!',
                style: TextStyle(
                  color: _selectedTheme == 'Dark' ? Colors.green : Colors.black,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProblemsPanel() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Problems',
            style: TextStyle(
              color: _selectedTheme == 'Dark' ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              children: [
                _buildProblemItem(
                  'Warning',
                  'Unused import',
                  'main.dart:1',
                  Icons.warning,
                  Colors.orange,
                ),
                _buildProblemItem(
                  'Error',
                  'Undefined variable',
                  'app.dart:25',
                  Icons.error,
                  Colors.red,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProblemItem(
    String type,
    String message,
    String location,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color:
            _selectedTheme == 'Dark'
                ? const Color(0xFF2D2D30)
                : const Color(0xFFF8F8F8),
        border: Border.all(
          color:
              _selectedTheme == 'Dark'
                  ? const Color(0xFF3E3E42)
                  : const Color(0xFFE0E0E0),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: TextStyle(
                    color:
                        _selectedTheme == 'Dark' ? Colors.white : Colors.black,
                  ),
                ),
                Text(
                  location,
                  style: TextStyle(
                    color:
                        _selectedTheme == 'Dark'
                            ? Colors.white70
                            : Colors.black54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getFileIcon(String fileName) {
    if (fileName.endsWith('.dart')) return Icons.code;
    if (fileName.endsWith('.js')) return Icons.javascript;
    if (fileName.endsWith('.py')) return Icons.code;
    if (fileName.endsWith('.html')) return Icons.web;
    if (fileName.endsWith('.css')) return Icons.style;
    if (fileName.endsWith('.json')) return Icons.data_object;
    return Icons.description;
  }
}
