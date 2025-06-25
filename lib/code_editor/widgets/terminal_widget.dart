import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TerminalWidget extends StatefulWidget {
  final bool isDark;

  const TerminalWidget({
    super.key,
    required this.isDark,
  });

  @override
  State<TerminalWidget> createState() => _TerminalWidgetState();
}

class _TerminalWidgetState extends State<TerminalWidget> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  
  final List<Map<String, dynamic>> _terminalHistory = [
    {
      'type': 'output',
      'text': 'Welcome to Future Reach IDE Terminal',
      'timestamp': DateTime.now(),
    },
    {
      'type': 'output',
      'text': 'Type "help" for available commands',
      'timestamp': DateTime.now(),
    },
  ];
  
  final List<String> _commandHistory = [];
  int _historyIndex = -1;
  String _currentPath = '/workspace/miko';

  final Map<String, Function> _commands = {};

  @override
  void initState() {
    super.initState();
    _initializeCommands();
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _initializeCommands() {
    _commands.addAll({
      'help': _helpCommand,
      'clear': _clearCommand,
      'ls': _lsCommand,
      'pwd': _pwdCommand,
      'cd': _cdCommand,
      'echo': _echoCommand,
      'date': _dateCommand,
      'flutter': _flutterCommand,
      'dart': _dartCommand,
      'git': _gitCommand,
      'npm': _npmCommand,
      'python': _pythonCommand,
      'node': _nodeCommand,
      'cat': _catCommand,
      'mkdir': _mkdirCommand,
      'touch': _touchCommand,
      'rm': _rmCommand,
      'cp': _cpCommand,
      'mv': _mvCommand,
    });
  }

  void _executeCommand(String command) {
    if (command.trim().isEmpty) return;

    // Add command to history
    _commandHistory.add(command);
    _historyIndex = _commandHistory.length;

    // Add command to terminal output
    _addToTerminal('command', '\$ $command');

    // Parse command
    final parts = command.trim().split(' ');
    final cmd = parts[0].toLowerCase();
    final args = parts.length > 1 ? parts.sublist(1) : <String>[];

    // Execute command
    if (_commands.containsKey(cmd)) {
      _commands[cmd]!(args);
    } else {
      _addToTerminal('error', 'Command not found: $cmd');
      _addToTerminal('output', 'Type "help" for available commands');
    }

    // Clear input and scroll to bottom
    _inputController.clear();
    _scrollToBottom();
  }

  void _addToTerminal(String type, String text) {
    setState(() {
      _terminalHistory.add({
        'type': type,
        'text': text,
        'timestamp': DateTime.now(),
      });
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleKeyEvent(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        _navigateHistory(-1);
      } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        _navigateHistory(1);
      }
    }
  }

  void _navigateHistory(int direction) {
    if (_commandHistory.isEmpty) return;

    _historyIndex += direction;
    _historyIndex = _historyIndex.clamp(-1, _commandHistory.length - 1);

    if (_historyIndex >= 0 && _historyIndex < _commandHistory.length) {
      _inputController.text = _commandHistory[_historyIndex];
      _inputController.selection = TextSelection.fromPosition(
        TextPosition(offset: _inputController.text.length),
      );
    } else {
      _inputController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.isDark ? const Color(0xFF0C0C0C) : const Color(0xFFF8F8F8),
      child: Column(
        children: [
          // Terminal Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: widget.isDark ? const Color(0xFF1E1E1E) : const Color(0xFFE8E8E8),
              border: Border(
                bottom: BorderSide(
                  color: widget.isDark 
                      ? const Color(0xFF3E3E42) 
                      : const Color(0xFFD0D0D0),
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.terminal,
                  size: 16,
                  color: widget.isDark ? Colors.white70 : Colors.black54,
                ),
                const SizedBox(width: 8),
                Text(
                  'Terminal',
                  style: TextStyle(
                    color: widget.isDark ? Colors.white70 : Colors.black54,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(
                    Icons.clear_all,
                    size: 16,
                    color: widget.isDark ? Colors.white70 : Colors.black54,
                  ),
                  onPressed: () => _clearCommand([]),
                  tooltip: 'Clear Terminal',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
          
          // Terminal Output
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(8),
              itemCount: _terminalHistory.length,
              itemBuilder: (context, index) {
                final entry = _terminalHistory[index];
                return _buildTerminalLine(entry);
              },
            ),
          ),
          
          // Command Input
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: widget.isDark 
                      ? const Color(0xFF3E3E42) 
                      : const Color(0xFFD0D0D0),
                ),
              ),
            ),
            child: RawKeyboardListener(
              focusNode: _focusNode,
              onKey: _handleKeyEvent,
              child: Row(
                children: [
                  Text(
                    '\$ ',
                    style: TextStyle(
                      color: widget.isDark ? Colors.green[400] : Colors.green[600],
                      fontFamily: 'monospace',
                      fontSize: 14,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _inputController,
                      style: TextStyle(
                        color: widget.isDark ? Colors.white : Colors.black,
                        fontFamily: 'monospace',
                        fontSize: 14,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter command...',
                        contentPadding: EdgeInsets.zero,
                      ),
                      onSubmitted: _executeCommand,
                      autofocus: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTerminalLine(Map<String, dynamic> entry) {
    Color textColor;
    switch (entry['type']) {
      case 'command':
        textColor = widget.isDark ? Colors.cyan[300]! : Colors.cyan[700]!;
        break;
      case 'error':
        textColor = widget.isDark ? Colors.red[300]! : Colors.red[700]!;
        break;
      case 'success':
        textColor = widget.isDark ? Colors.green[300]! : Colors.green[700]!;
        break;
      case 'warning':
        textColor = widget.isDark ? Colors.yellow[300]! : Colors.yellow[700]!;
        break;
      default:
        textColor = widget.isDark ? Colors.white : Colors.black;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: SelectableText(
        entry['text'],
        style: TextStyle(
          color: textColor,
          fontFamily: 'monospace',
          fontSize: 13,
          height: 1.2,
        ),
      ),
    );
  }

  // Command implementations
  void _helpCommand(List<String> args) {
    _addToTerminal('output', 'Available commands:');
    _addToTerminal('output', '  help          - Show this help message');
    _addToTerminal('output', '  clear         - Clear terminal');
    _addToTerminal('output', '  ls            - List directory contents');
    _addToTerminal('output', '  pwd           - Print working directory');
    _addToTerminal('output', '  cd <dir>      - Change directory');
    _addToTerminal('output', '  echo <text>   - Print text');
    _addToTerminal('output', '  date          - Show current date/time');
    _addToTerminal('output', '  flutter <cmd> - Flutter commands');
    _addToTerminal('output', '  dart <cmd>    - Dart commands');
    _addToTerminal('output', '  git <cmd>     - Git commands');
    _addToTerminal('output', '  npm <cmd>     - NPM commands');
    _addToTerminal('output', '  python <cmd>  - Python commands');
    _addToTerminal('output', '  node <cmd>    - Node.js commands');
    _addToTerminal('output', '  cat <file>    - Display file contents');
    _addToTerminal('output', '  mkdir <dir>   - Create directory');
    _addToTerminal('output', '  touch <file>  - Create file');
    _addToTerminal('output', '  rm <file>     - Remove file');
    _addToTerminal('output', '  cp <src> <dst> - Copy file');
    _addToTerminal('output', '  mv <src> <dst> - Move file');
  }

  void _clearCommand(List<String> args) {
    setState(() {
      _terminalHistory.clear();
    });
  }

  void _lsCommand(List<String> args) {
    _addToTerminal('output', 'lib/');
    _addToTerminal('output', 'assets/');
    _addToTerminal('output', 'test/');
    _addToTerminal('output', 'android/');
    _addToTerminal('output', 'ios/');
    _addToTerminal('output', 'web/');
    _addToTerminal('output', 'pubspec.yaml');
    _addToTerminal('output', 'README.md');
    _addToTerminal('output', '.gitignore');
  }

  void _pwdCommand(List<String> args) {
    _addToTerminal('output', _currentPath);
  }

  void _cdCommand(List<String> args) {
    if (args.isEmpty) {
      _addToTerminal('error', 'cd: missing directory argument');
      return;
    }
    
    final dir = args[0];
    if (dir == '..') {
      _currentPath = '/workspace';
    } else if (dir.startsWith('/')) {
      _currentPath = dir;
    } else {
      _currentPath = '$_currentPath/$dir';
    }
    
    _addToTerminal('success', 'Changed directory to $_currentPath');
  }

  void _echoCommand(List<String> args) {
    _addToTerminal('output', args.join(' '));
  }

  void _dateCommand(List<String> args) {
    _addToTerminal('output', DateTime.now().toString());
  }

  void _flutterCommand(List<String> args) {
    if (args.isEmpty) {
      _addToTerminal('output', 'Flutter 3.16.0 • channel stable');
      return;
    }
    
    switch (args[0]) {
      case 'run':
        _addToTerminal('success', 'Running Flutter app...');
        _addToTerminal('output', 'Launching lib/main.dart on Chrome in debug mode...');
        break;
      case 'build':
        _addToTerminal('success', 'Building Flutter app...');
        break;
      case 'clean':
        _addToTerminal('success', 'Cleaning build files...');
        break;
      case 'pub':
        if (args.length > 1 && args[1] == 'get') {
          _addToTerminal('success', 'Running "flutter pub get"...');
          _addToTerminal('output', 'Got dependencies!');
        }
        break;
      default:
        _addToTerminal('error', 'Unknown flutter command: ${args[0]}');
    }
  }

  void _dartCommand(List<String> args) {
    if (args.isEmpty) {
      _addToTerminal('output', 'Dart SDK version: 3.2.0');
      return;
    }
    
    switch (args[0]) {
      case 'run':
        _addToTerminal('success', 'Running Dart application...');
        break;
      case 'compile':
        _addToTerminal('success', 'Compiling Dart code...');
        break;
      default:
        _addToTerminal('error', 'Unknown dart command: ${args[0]}');
    }
  }

  void _gitCommand(List<String> args) {
    if (args.isEmpty) {
      _addToTerminal('output', 'git version 2.34.1');
      return;
    }
    
    switch (args[0]) {
      case 'status':
        _addToTerminal('output', 'On branch main');
        _addToTerminal('output', 'Your branch is up to date with \'origin/main\'.');
        _addToTerminal('output', 'nothing to commit, working tree clean');
        break;
      case 'add':
        _addToTerminal('success', 'Files added to staging area');
        break;
      case 'commit':
        _addToTerminal('success', 'Changes committed successfully');
        break;
      case 'push':
        _addToTerminal('success', 'Changes pushed to remote repository');
        break;
      case 'pull':
        _addToTerminal('success', 'Already up to date.');
        break;
      default:
        _addToTerminal('error', 'Unknown git command: ${args[0]}');
    }
  }

  void _npmCommand(List<String> args) {
    if (args.isEmpty) {
      _addToTerminal('output', 'npm version 9.8.1');
      return;
    }
    
    switch (args[0]) {
      case 'install':
        _addToTerminal('success', 'Installing npm packages...');
        break;
      case 'run':
        _addToTerminal('success', 'Running npm script...');
        break;
      case 'start':
        _addToTerminal('success', 'Starting development server...');
        break;
      default:
        _addToTerminal('error', 'Unknown npm command: ${args[0]}');
    }
  }

  void _pythonCommand(List<String> args) {
    if (args.isEmpty) {
      _addToTerminal('output', 'Python 3.11.0');
      return;
    }
    
    _addToTerminal('success', 'Running Python script: ${args.join(' ')}');
  }

  void _nodeCommand(List<String> args) {
    if (args.isEmpty) {
      _addToTerminal('output', 'v18.17.0');
      return;
    }
    
    _addToTerminal('success', 'Running Node.js script: ${args.join(' ')}');
  }

  void _catCommand(List<String> args) {
    if (args.isEmpty) {
      _addToTerminal('error', 'cat: missing file argument');
      return;
    }
    
    _addToTerminal('output', 'File contents of ${args[0]}:');
    _addToTerminal('output', '// Sample file content');
    _addToTerminal('output', 'void main() {');
    _addToTerminal('output', '  print("Hello, World!");');
    _addToTerminal('output', '}');
  }

  void _mkdirCommand(List<String> args) {
    if (args.isEmpty) {
      _addToTerminal('error', 'mkdir: missing directory argument');
      return;
    }
    
    _addToTerminal('success', 'Directory created: ${args[0]}');
  }

  void _touchCommand(List<String> args) {
    if (args.isEmpty) {
      _addToTerminal('error', 'touch: missing file argument');
      return;
    }
    
    _addToTerminal('success', 'File created: ${args[0]}');
  }

  void _rmCommand(List<String> args) {
    if (args.isEmpty) {
      _addToTerminal('error', 'rm: missing file argument');
      return;
    }
    
    _addToTerminal('success', 'File removed: ${args[0]}');
  }

  void _cpCommand(List<String> args) {
    if (args.length < 2) {
      _addToTerminal('error', 'cp: missing source or destination');
      return;
    }
    
    _addToTerminal('success', 'File copied: ${args[0]} -> ${args[1]}');
  }

  void _mvCommand(List<String> args) {
    if (args.length < 2) {
      _addToTerminal('error', 'mv: missing source or destination');
      return;
    }
    
    _addToTerminal('success', 'File moved: ${args[0]} -> ${args[1]}');
  }
}