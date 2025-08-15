import 'package:flutter/material.dart';
import 'package:miko/ai/functions/ai_browser_functions.dart';
import 'package:miko/ai/services/ai_browser_service.dart';
import 'package:miko/webviewai/download_service.dart'; // Import the new download service
import 'package:miko/webviewai/bookmark_service.dart'; // Import the new bookmark service

import 'package:webview_flutter/webview_flutter.dart';
import 'package:miko/webviewai/bookmarks_screen.dart'; // Import BookmarksScreen
import 'dart:async';
import 'dart:ui';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class AiBrowserApp extends StatelessWidget {
  AiBrowserApp({super.key});

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
        textTheme: Theme.of(context).textTheme
            .apply(
              bodyColor: const Color(0xFFCCD6F6),
              displayColor: const Color(0xFFCCD6F6),
            )
            .copyWith(titleMedium: const TextStyle(color: Color(0xFFCCD6F6))),
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

class _AdvancedWebViewerState extends State<AdvancedWebViewer>
    with WidgetsBindingObserver {
  late final WebViewController _webViewController;
  late final AssistantService _assistantService;
  late final TextEditingController _promptController;
  late final TextEditingController _urlController;
  late final DownloadService _downloadService; // Correct declaration
  late final BookmarkService _bookmarkService; // Declare BookmarkService

  static const double _aiPanelHeight =
      200.0; // Reduced height for a more minimal appearance

  final List<String> _chatMessages = [];
  int _loadingPercentage = 100;
  bool _isAssistantProcessing = false;
  bool _isAiPanelVisible = true;
  bool _canGoBack = false;
  bool _canGoForward = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _promptController = TextEditingController();
    _urlController = TextEditingController();
    _downloadService = DownloadService(); // Correct initialization
    _bookmarkService = BookmarkService(); // Initialize BookmarkService

    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setUserAgent(
        "Mozilla/5.0 (Linux; Android 16; LM-Q720) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.7204.180 Mobile Safari/537.36",
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('WebView is loading (progress : $progress%)');
            setState(() => _loadingPercentage = progress);
          },
          onPageStarted: (String url) async {
            debugPrint('Page started loading: $url');
            setState(() {
              _loadingPercentage = 0;
              _urlController.text = url;
            });
            _updateNavigationState();
          },
          onPageFinished: (String url) async {
            debugPrint('Page finished loading: $url');
            setState(() {
              _loadingPercentage = 100;
              _urlController.text = url;
            });
            _updateNavigationState();
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('''
              Page resource error:
              code: ${error.errorCode}
              description: ${error.description}
              errorType: ${error.errorType}
              isForMainFrame: ${error.isForMainFrame}
            ''');
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('mailto:') ||
                request.url.startsWith('tel:')) {
              return NavigationDecision.prevent;
            }
            // Simple heuristic for downloads: check file extension
            final uri = Uri.parse(request.url);
            final path = uri.path;
            final fileExtension = path.contains('.')
                ? path.substring(path.lastIndexOf('.') + 1)
                : '';
            final downloadExtensions = [
              'pdf',
              'doc',
              'docx',
              'xls',
              'xlsx',
              'ppt',
              'pptx',
              'zip',
              'rar',
              'tar',
              'gz',
              'mp3',
              'mp4',
              'jpg',
              'jpeg',
              'png',
              'gif',
            ];

            if (downloadExtensions.contains(fileExtension.toLowerCase())) {
              final filename = path.substring(path.lastIndexOf('/') + 1);
              _downloadService.downloadFile(request.url, filename, context);
              return NavigationDecision
                  .prevent; // Prevent WebView from navigating to the download URL
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://duckduckgo.com/'));

    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }

    _webViewController = controller;

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

  void _updateNavigationState() async {
    final canGoBack = await _webViewController.canGoBack();
    final canGoForward = await _webViewController.canGoForward();
    setState(() {
      _canGoBack = canGoBack;
      _canGoForward = canGoForward;
    });
  }

  void _handleUrlSubmit(String url) {
    Uri? uri = Uri.tryParse(url);
    if (uri != null) {
      if (!uri.hasScheme) {
        uri = Uri.parse('https://duckduckgo.com/search?q=$url');
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
        canGoBack: _canGoBack,
        canGoForward: _canGoForward,
        downloadService: _downloadService, // Pass downloadService
        bookmarkService: _bookmarkService, // Pass bookmarkService
      ),
      drawer: AppDrawer(
        webViewController: _webViewController,
        bookmarkService: _bookmarkService,
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(
              bottom: isPanelVisible ? _aiPanelHeight - 10 : 0,
            ),
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
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary,
            ),
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
    required this.canGoBack,
    required this.canGoForward,
    required this.downloadService, // Add downloadService to constructor
    required this.bookmarkService, // Add bookmarkService to constructor
    super.key,
  });

  final TextEditingController urlController;
  final WebViewController webViewController;
  final ValueChanged<String> onUrlSubmit;
  final VoidCallback onToggleAiPanel;
  final bool isAiPanelVisible;
  final bool canGoBack;
  final bool canGoForward;
  final DownloadService downloadService; // Declare downloadService
  final BookmarkService bookmarkService; // Declare BookmarkService

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
        tooltip: 'Menu',
        splashRadius: 20,
      ),
      titleSpacing: 0,
      title: Row(
        children: [
          // Navigation buttons group (fixed compact widths)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 40,
                child: IconButton(
                  iconSize: 18,
                  icon: const Icon(Icons.arrow_back_ios_new),
                  onPressed: canGoBack
                      ? () => webViewController.goBack()
                      : null,
                  tooltip: 'Back',
                  splashRadius: 20,
                ),
              ),
              SizedBox(
                width: 40,
                child: IconButton(
                  iconSize: 18,
                  icon: const Icon(Icons.arrow_forward_ios),
                  onPressed: canGoForward
                      ? () => webViewController.goForward()
                      : null,
                  tooltip: 'Forward',
                  splashRadius: 20,
                ),
              ),
              SizedBox(
                width: 40,
                child: IconButton(
                  iconSize: 20,
                  icon: const Icon(Icons.home),
                  onPressed: () => webViewController.loadRequest(
                    Uri.parse('https://duckduckgo.com/'),
                  ),
                  tooltip: 'Home',
                  splashRadius: 20,
                ),
              ),
            ],
          ),
          Expanded(
            child: Container(
              height: 40,
              margin: const EdgeInsets.only(right: 8),
              child: TextField(
                controller: urlController,
                onSubmitted: onUrlSubmit,
                textAlignVertical: TextAlignVertical.center,
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  isDense: true,
                  filled: true,
                  fillColor: theme.colorScheme.background,
                  hintText: 'Search or type a URL',
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 0,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.refresh, size: 20),
                    onPressed: () => webViewController.reload(),
                    tooltip: 'Reload',
                    splashRadius: 20,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.bookmark_add),
          onPressed: () async {
            final currentUrl = await webViewController.currentUrl();
            final currentTitle = await webViewController.getTitle();
            if (currentUrl != null && currentTitle != null) {
              bookmarkService.addBookmark(currentUrl, currentTitle);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Bookmark added: $currentTitle')),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Could not add bookmark.')),
              );
            }
          },
          tooltip: 'Add bookmark',
          splashRadius: 20,
        ),
        IconButton(
          icon: Icon(
            isAiPanelVisible
                ? Icons.keyboard_arrow_down
                : Icons.keyboard_arrow_up,
            color: theme.colorScheme.primary,
          ),
          onPressed: onToggleAiPanel,
          tooltip: 'Toggle AI panel',
          splashRadius: 20,
        ),
      ],
    );
  }
}

class NavigationButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed; // Make onPressed nullable
  const NavigationButton({required this.icon, this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, size: 18),
      splashRadius: 20,
      onPressed: onPressed,
    );
  }
}

class AiChatPanel extends StatefulWidget {
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
  State<AiChatPanel> createState() => _AiChatPanelState();
}

class _AiChatPanelState extends State<AiChatPanel> {
  bool _isPromptEmpty = true;

  @override
  void initState() {
    super.initState();
    widget.promptController.addListener(_updatePromptEmptyState);
  }

  @override
  void dispose() {
    widget.promptController.removeListener(_updatePromptEmptyState);
    super.dispose();
  }

  void _updatePromptEmptyState() {
    setState(() {
      _isPromptEmpty = widget.promptController.text.isEmpty;
    });
  }

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
              top: BorderSide(
                color: theme.colorScheme.primary.withOpacity(0.5),
                width: 1.5,
              ),
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  itemCount: widget.chatMessages.length,
                  itemBuilder: (context, index) {
                    final message = widget.chatMessages[index];
                    final isUser = message.startsWith("User:");
                    return Align(
                      alignment: isUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
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
                            color: isUser
                                ? Colors.black
                                : theme.colorScheme.onSurface,
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
                        controller: widget.promptController,
                        style: const TextStyle(fontSize: 14),
                        decoration: const InputDecoration(
                          hintText: 'e.g., "summarize this page"',
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                        ),
                        onSubmitted: widget.isAssistantProcessing
                            ? null
                            : widget.onPromptSubmit,
                      ),
                    ),
                    widget.isAssistantProcessing
                        ? const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 3),
                            ),
                          )
                        : IconButton(
                            icon: _isPromptEmpty
                                ? const Icon(Icons.mic)
                                : const Icon(Icons.send),
                            color: theme.colorScheme.primary,
                            onPressed: _isPromptEmpty
                                ? () {
                                    /* TODO: Implement record functionality */
                                  }
                                : () => widget.onPromptSubmit(
                                    widget.promptController.text,
                                  ),
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
  final WebViewController webViewController;
  final BookmarkService bookmarkService;

  const AppDrawer({
    super.key,
    required this.webViewController,
    required this.bookmarkService,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Drawer(
      backgroundColor: theme.scaffoldBackgroundColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: theme.colorScheme.surface),
            child: Text(
              'Miko Browser',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.bookmark_border),
            title: const Text('Bookmarks'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookmarksScreen(
                    webViewController: webViewController,
                    bookmarkService: bookmarkService,
                  ),
                ),
              );
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
