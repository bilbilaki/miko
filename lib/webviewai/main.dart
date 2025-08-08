import 'package:flutter/material.dart';
import 'package:miko/ai/functions/ai_browser_functions.dart';
import 'package:miko/ai/services/ai_browser_service.dart';

import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';
import 'dart:ui';



class AiBrowserApp extends StatelessWidget {
   AiBrowserApp( {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF0A192F),
        scaffoldBackgroundColor: const Color(0xFF0A192F),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF64FFDA), // Highlight color
          secondary: Color(0xFF8892B0), // Lighter text/icons
          background: Color(0xFF0A192F), // Main background
          surface: Color(0xFF112240), // Card/panel background
          onPrimary: Colors.black,
          onSecondary: Colors.white,
          onBackground: Color(0xFFCCD6F6), // Main text color
          onSurface: Color(0xFFCCD6F6),
        ),
        inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: const Color(0xFF0A192F),
            hintStyle: const TextStyle(color: Color(0xFF8892B0)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: Color(0xFF233554)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: Color(0xFF233554)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: Color(0xFF64FFDA)),
            ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFFCCD6F6)),
        textTheme: Theme.of(context).textTheme.apply(
          bodyColor: const Color(0xFFCCD6F6),
          displayColor: const Color(0xFFCCD6F6),
        ).copyWith(
          titleMedium: const TextStyle(color: Color(0xFFCCD6F6)),
        ),
      ),
      home: AdvancedWebViewer(),
    );
  }
}


class AdvancedWebViewer extends StatefulWidget {
  const AdvancedWebViewer({super.key});

  @override
  State<AdvancedWebViewer> createState() => _AdvancedWebViewerState();
}

class _AdvancedWebViewerState extends State<AdvancedWebViewer> with WidgetsBindingObserver {
  late final WebViewController _webViewController;
  late final AssistantService _assistantService;
  late final TextEditingController _promptController;
  late final TextEditingController _urlController;

  static const double _aiPanelHeight = 280.0;
  
  final List<String> _chatMessages = [];
  int _loadingPercentage = 100;
  bool _isAssistantProcessing = false;
  bool _isAiPanelVisible = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _promptController = TextEditingController();
    _urlController = TextEditingController();

    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setUserAgent("Mozilla/5.0 (Linux; Android 16; LM-Q720) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.7204.180 Mobile Safari/537.36")
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) => setState(() {
            _loadingPercentage = 0;
            _urlController.text = url;
          }),
          onProgress: (progress) => setState(() => _loadingPercentage = progress),
          onPageFinished: (url) => setState(() {
            _loadingPercentage = 100;
            _urlController.text = url;
          }),
          onWebResourceError: (error) {
            debugPrint('''
              Page resource error:
              code: ${error.errorCode}
              description: ${error.description}
              errorType: ${error.errorType}
              isForMainFrame: ${error.isForMainFrame}
            ''');
          },
        ),
      )
      ..loadRequest(Uri.parse('https://duckduckgo.com/'));

    _assistantService = AssistantService(
      webViewAIController: WebViewAIController(_webViewController),
      onNewMessage: _addChatMessage,
    );
  }
  
  void _addChatMessage(String message) {
    setState(() => _chatMessages.insert(0, message));
  }
  
  void _toggleAiPanel() {
    setState(() => _isAiPanelVisible = !_isAiPanelVisible);
  }

  void _handleUrlSubmit(String url) {
    Uri? uri = Uri.tryParse(url);
    if (uri != null) {
      if (!uri.hasScheme) {
        uri = Uri.parse('https://www.google.com/search?q=$url');
      }
      _webViewController.loadRequest(uri);
      FocusScope.of(context).unfocus(); // Dismiss keyboard
    }
  }

  void _handlePromptSubmit(String text) async {
    if (text.trim().isEmpty) return;
    final prompt = text.trim();
    _promptController.clear();
    _addChatMessage("User: $prompt");
    setState(() => _isAssistantProcessing = true);

    try {
      await _assistantService.processUserPrompt(prompt);
    } catch (e) {
      _addChatMessage("An error occurred: $e");
    } finally {
      setState(() => _isAssistantProcessing = false);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _promptController.dispose();
    _urlController.dispose();
    super.dispose();
  }
  
  @override
  Future<AppExitResponse> didRequestAppExit() async {
    // You can add logic here to ask the user for confirmation
    return AppExitResponse.exit;
  }

  @override
  Widget build(BuildContext context) {
    final isPanelVisible = _isAiPanelVisible;

    return Scaffold(
      appBar: BrowserAppBar(
        urlController: _urlController,
        webViewController: _webViewController,
        onUrlSubmit: _handleUrlSubmit,
        onToggleAiPanel: _toggleAiPanel,
        isAiPanelVisible: isPanelVisible,
      ),
      drawer: const AppDrawer(),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: isPanelVisible ? _aiPanelHeight - 10 : 0),
            child: WebViewStack(
              controller: _webViewController,
              loadingPercentage: _loadingPercentage,
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            bottom: isPanelVisible ? 0 : -_aiPanelHeight,
            left: 0,
            right: 0,
            height: _aiPanelHeight,
            child: AiChatPanel(
              chatMessages: _chatMessages,
              promptController: _promptController,
              isAssistantProcessing: _isAssistantProcessing,
              onPromptSubmit: _handlePromptSubmit,
            ),
          ),
        ],
      ),
    );
  }
}

class WebViewStack extends StatelessWidget {
  const WebViewStack({
    required this.controller,
    required this.loadingPercentage,
    super.key,
  });

  final WebViewController controller;
  final int loadingPercentage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebViewWidget(controller: controller),
        if (loadingPercentage < 100)
          LinearProgressIndicator(
            value: loadingPercentage / 100.0,
            backgroundColor: Colors.transparent,
            valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
          ),
      ],
    );
  }
}

class BrowserAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BrowserAppBar({
    required this.urlController,
    required this.webViewController,
    required this.onUrlSubmit,
    required this.onToggleAiPanel,
    required this.isAiPanelVisible,
    super.key,
  });

  final TextEditingController urlController;
  final WebViewController webViewController;
  final ValueChanged<String> onUrlSubmit;
  final VoidCallback onToggleAiPanel;
  final bool isAiPanelVisible;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      backgroundColor: theme.colorScheme.surface,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () => Scaffold.of(context).openDrawer(),
      ),
      titleSpacing: 0,
      title: Row(
        children: [
          NavigationButton(
              icon: Icons.arrow_back_ios_new,
              onPressed: () async {
                if (await webViewController.canGoBack()) {
                  await webViewController.goBack();
                }
              }),
          NavigationButton(
              icon: Icons.arrow_forward_ios,
              onPressed: () async {
                if (await webViewController.canGoForward()) {
                  await webViewController.goForward();
                }
              }),
              SizedBox(width: 1),
        ],
      ),
                           

      flexibleSpace: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 104, right: 56, top: 8, bottom: 8),
          child: Center(
            child: TextField(
              controller: urlController,
              onSubmitted: onUrlSubmit,
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                hintText: 'Search or type a URL',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.refresh, size: 20),
                  onPressed: () => webViewController.reload(),
                ),
              ),
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            isAiPanelVisible ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
            color: theme.colorScheme.primary,
          ),
          onPressed: onToggleAiPanel,
        ),
      ],
    );
  }
}

class NavigationButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  const NavigationButton({required this.icon, required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, size: 18),
      splashRadius: 20,
      onPressed: onPressed,
    );
  }
}

class AiChatPanel extends StatelessWidget {
  const AiChatPanel({
    super.key,
    required this.chatMessages,
    required this.promptController,
    required this.isAssistantProcessing,
    required this.onPromptSubmit,
  });

  final List<String> chatMessages;
  final TextEditingController promptController;
  final bool isAssistantProcessing;
  final ValueChanged<String> onPromptSubmit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(16.0),
        topRight: Radius.circular(16.0),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface.withOpacity(0.85),
            border: Border(
                top: BorderSide(color: theme.colorScheme.primary.withOpacity(0.5), width: 1.5)
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  itemCount: chatMessages.length,
                  itemBuilder: (context, index) {
                    final message = chatMessages[index];
                    final isUser = message.startsWith("User:");
                    return Align(
                      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.7,
                        ),
                        decoration: BoxDecoration(
                          color: isUser
                              ? theme.colorScheme.primary.withOpacity(0.8)
                              : theme.colorScheme.background,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          message,
                          style: TextStyle(
                            color: isUser ? Colors.black : theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: promptController,
                        style: const TextStyle(fontSize: 14),
                        decoration: const InputDecoration(
                          hintText: 'e.g., "summarize this page"',
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        ),
                        onSubmitted: isAssistantProcessing ? null : onPromptSubmit,
                      ),
                    ),
                    const SizedBox(width: 8),
                    isAssistantProcessing
                        ? const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 3),
                            ),
                          )
                        : IconButton(
                            icon: const Icon(Icons.send),
                            color: theme.colorScheme.primary,
                            onPressed: () => onPromptSubmit(promptController.text),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Drawer(
      backgroundColor: theme.scaffoldBackgroundColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
            ),
            child: Text(
              'Miko Browser',
              style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.bookmark_border),
            title: const Text('Bookmarks'),
            onTap: () {
              // TODO: Implement bookmark functionality
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('History'),
            onTap: () {
              // TODO: Implement history functionality
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.download_outlined),
            title: const Text('Downloads'),
            onTap: () {
              // TODO: Implement downloads functionality
              Navigator.pop(context);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Settings'),
            onTap: () {
              // TODO: Implement settings functionality
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}