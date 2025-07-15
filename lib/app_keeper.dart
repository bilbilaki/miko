import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Removed unused imports:
// import 'dart:typed_data';
// import 'package:flutter/gestures.dart';
// import 'package:miko/services/ai_chat_service.dart';
// import 'package:miko/services/audio_player_service.dart';
// import 'package:miko/services/files_service.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:provider/provider.dart' as pp; // <-- Remove this line
// import 'package:image_picker/image_picker.dart';

import 'package:miko/widgets/alienswapbutton.dart';
import 'providers/settings_provider.dart';
import 'screens/settings_screen.dart';
import 'screens/unisearch_screen.dart';
import 'utils/colors.dart'; // Assuming AppThemes is defined here
import 'widgets/left_navigation_panel.dart';
import 'widgets/center_content_panel.dart';
import 'widgets/right_settings_panel.dart';
import 'widgets/ai_chat_dialog.dart'; // New: Import the extracted AI chat dialog

// Removed OpenAIChatMode enum from here, it's now in ai_chat_provider.dart


class AppKeeper extends ConsumerStatefulWidget {
  const AppKeeper({super.key});

  @override
  ConsumerState<AppKeeper> createState() => _AppKeeperConsumerState();
}

class _AppKeeperConsumerState extends ConsumerState<AppKeeper>
    with TickerProviderStateMixin {
  // --- Removed AI chat related state and logic from here ---
  // final TextEditingController _promptController = TextEditingController();
  // String _response = '';
  // bool _isLoading = false;
  // String? _selectedImageBase64;
  // String? _selectedAudioBase64;
  // String? _selectedAudioFormat;
  // final AudioPlayerService _audioPlayerService = AudioPlayerService();
  // OpenAIChatMode _currentMode = OpenAIChatMode.textChat;
  // late OpenAIServiceBase _currentService;
  // --------------------------------------------------------

  // Tab controllers remain for layout
  late TabController _leftDrawerTabController;
  late TabController _rightDrawerTabController;

  @override
  void initState() {
    super.initState();
    _leftDrawerTabController = TabController(length: 1, vsync: this);
    _rightDrawerTabController = TabController(length: 1, vsync: this);
    // Removed _setService(_currentMode);
  }

  // --- Removed all AI chat logic methods (_setService, _clearMedia, _pickImage, _pickAudio, _sendMessage) ---

  @override
  void dispose() {
    // Removed AI chat related disposals:
    // _promptController.dispose();
    // _audioPlayerService.dispose();
    _leftDrawerTabController.dispose();
    _rightDrawerTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSidebarCollapsed = ref.watch(sidebarCollapsedProvider);
    final isRightSidebarCollapsed = ref.watch(rightSidebarCollapsedProvider);

    final double sidebarWidth = isSidebarCollapsed ? 60.0 : 260.0;
    final double sidebarWidthRight = isRightSidebarCollapsed ? 60.0 : 260.0;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 1300; // Breakpoint for drawers

    // Using theme colors for sidebars for better theming consistency
    final Color leftSidebarColor = const Color.fromARGB(255, 25, 0, 69); // Example theme color
    final Color rightSidebarColor =  const Color.fromARGB(255, 21, 0, 58);// Example theme color

    return MaterialApp(
      theme: AppThemes.netflixDarkTheme,
      darkTheme: AppThemes.netflixDarkTheme,
      home: isSmallScreen
          ? Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).appBarTheme.backgroundColor, // Use theme color
                actions: [
                  IconButton(
                    icon: const Icon(Icons.settings_outlined),
                    tooltip: 'Settings',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SettingsScreen()), // Added const
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.search),
                    tooltip: 'search',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const UnifiedSearchScreen()), // Added const
                      );
                    },
                  ),
                  // Removed commented out AppBar code
                ],
              ),
              drawer: Drawer(
                backgroundColor: leftSidebarColor, // Used theme color
                child: Column(
                  children: [
                    // NOTE: TabBar with `length: 1` is redundant. Consider replacing
                    // with a direct display of LeftNavigationPanel if no more tabs are planned.
                    TabBar(
                      controller: _leftDrawerTabController,
                      tabs: const [
                        Tab(
                          icon: Icon(Icons.query_builder_outlined),
                          text: "History", // Added text for clarity
                        ),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _leftDrawerTabController,
                        children: [
                          LeftNavigationPanel(
                            isMobileLayout: true,
                            isCollapsed: false,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              endDrawer: Drawer(
                backgroundColor: rightSidebarColor, // Used theme color
                child: Column(
                  children: [
                    // NOTE: TabBar with `length: 1` is redundant. Consider replacing
                    // with a direct display of RightNavigationPanel if no more tabs are planned.
                    TabBar(
                        controller: _rightDrawerTabController,
                        tabs: const [
                          Tab(
                            icon: Icon(Icons.dashboard_customize_outlined),
                            text: "Panels", // Added text for clarity
                          ),
                        ]),
                    Expanded(
                      child: TabBarView(
                        controller: _rightDrawerTabController,
                        children: [
                          RightNavigationPanel(
                            isMobileLayout: true,
                            isCollapsed: false,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              body: CenterContentPanel(isMobileLayout: isSmallScreen),
              floatingActionButton: AlienFloatSwapMenu(
                onOpenEditor: () {
                  // Now simply show the new AiChatDialog widget
                  showDialog(
                    context: context,
                    builder: (ctx) {
                      // It is critical to wrap the dialog with ProviderScope
                      // if the dialog (or its children) will consume Riverpod providers,
                      // and it's being shown outside of the main widget tree's ProviderScope.
                      // ProviderScope.containerOf(context) ensures it uses the existing Riverpod container.
                      return ProviderScope(
                        parent: ProviderScope.containerOf(context),
                        child: const AiChatDialog(),
                      );
                    },
                  );
                },
                onClose: () => print("Close"),
                onSave: () => print("Save"),
                onSearch: () => print("Search"),
                onNew: () => print("New"), // Consistent naming
                onUndo: () => print("Undo"), // Consistent naming
                onRedo: () => print("Redo"), // Consistent naming
              ))
          : Scaffold(
              // Removed commented out AppBar block
              body: Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOutCubic,
                    width: sidebarWidth,
                    color: leftSidebarColor, // Used theme color
                    child: Column(
                      children: [
                        TabBar(
                          controller: _leftDrawerTabController,
                          isScrollable: true,
                          tabs: const [
                            Tab(
                              icon: Icon(Icons.query_builder_outlined),
                              text: "History",
                            ),
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            controller: _leftDrawerTabController,
                            children: [
                              LeftNavigationPanel(
                                isMobileLayout: false,
                                isCollapsed: isSidebarCollapsed,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Center Content Panel
                  const Expanded(
                    flex: 3,
                    child: CenterContentPanel(isMobileLayout: false), // Added const
                  ),

                  // Right Settings Panel with Tabs
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOutCubic,
                    width: sidebarWidthRight,
                    color: rightSidebarColor, // Used theme color
                    child: Column(
                      children: [
                        TabBar(
                          controller: _rightDrawerTabController,
                          isScrollable: true,
                          tabs: const [
                            Tab(
                              icon: Icon(Icons.dashboard_customize_outlined),
                              text: "Panels",
                            ),
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            controller: _rightDrawerTabController,
                            children: [
                              RightNavigationPanel(
                                isMobileLayout: false,
                                isCollapsed: isRightSidebarCollapsed,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              floatingActionButton: AlienFloatSwapMenu(
                onOpenEditor: () {
                  showDialog(
                    context: context,
                    builder: (ctx) {
                      return ProviderScope(
                        parent: ProviderScope.containerOf(context),
                        child: const AiChatDialog(),
                      );
                    },
                  );
                },
                onClose: () {}, // Empty function as per original (was print("Close"))
                onSave: () => print("Save"),
                onSearch: () => print("Search"),
                onNew: () => print("New"),
                onUndo: () => print("Undo"),
                onRedo: () => print("Redo"),
              ),
            ),
    );
  }

  // --- Removed _buildClickableResponse from here as it's now in AiChatDialog ---
}