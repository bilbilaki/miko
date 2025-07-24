import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/settings_provider.dart';
import 'utils/colors.dart'; // Assuming AppThemes is defined here
import 'widgets/left_navigation_panel.dart';
import 'widgets/center_content_panel.dart';
import 'widgets/right_settings_panel.dart';

// Removed OpenAIChatMode enum from here, it's now in ai_chat_provider.dart

class AppKeeper extends ConsumerStatefulWidget {
  const AppKeeper({super.key});

  @override
  ConsumerState<AppKeeper> createState() => _AppKeeperConsumerState();
}

class _AppKeeperConsumerState extends ConsumerState<AppKeeper>
    with TickerProviderStateMixin {
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
    const Color leftSidebarColor =
        Color.fromARGB(255, 25, 0, 69); // Example theme color
    const Color rightSidebarColor =
        Color.fromARGB(255, 21, 0, 58); // Example theme color

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppThemes.netflixDarkTheme,
        darkTheme: AppThemes.netflixDarkTheme,
             builder: (context, child) {
        // Get the MediaQueryData
        final mediaQuery = MediaQuery.of(context);
        // Create a new TextScaler that is clamped between a minimum and maximum factor
        final clampedTextScaler = mediaQuery.textScaler.clamp(
          minScaleFactor: 0.9, // Allow text to be slightly smaller
          maxScaleFactor: 1.2, // Allow text to be 20% larger, but no more
        );

        // Return the child widget with the new, clamped textScaler
        return MediaQuery(
          data: mediaQuery.copyWith(textScaler: clampedTextScaler),
          child: child!,
        );
      },
        home: isSmallScreen
            ? Scaffold(
                appBar: AppBar(),
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
                          ),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: _leftDrawerTabController,
                          children: const [
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
              //  endDrawer: Drawer(
                //  backgroundColor: rightSidebarColor, // Used theme color
                  //child: Column(
                   // children: [
                      // NOTE: TabBar with `length: 1` is redundant. Consider replacing
                      // with a direct display of RightNavigationPanel if no more tabs are planned.
                     // TabBar(
                       //   controller: _rightDrawerTabController,
                        //  tabs: const [
                          ///  Tab(
                            //  icon: Icon(Icons.dashboard_customize_outlined),
                           // ),
                         // ]),
                   //   Expanded(
                     //   child: TabBarView(
                       //   controller: _rightDrawerTabController,
                        //  children: const [
                          //  RightNavigationPanel(
                            //  isMobileLayout: true,
                           //   isCollapsed: false,
                          //  ),
                        //  ],
                       // ),
                     // ),
                   // ],
                 // ),
               // ),
                body: CenterContentPanel(isMobileLayout: isSmallScreen),
              )
            : Scaffold(
              appBar: AppBar(),
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
                      child: CenterContentPanel(
                          isMobileLayout: false), // Added const
                    ),

                    // Right Settings Panel with Tabs
                  //   AnimatedContainer(
                  //     duration: const Duration(milliseconds: 200),
                  //     curve: Curves.easeInOutCubic,
                  //     width: sidebarWidthRight,
                  //     color: rightSidebarColor, // Used theme color
                  //     child: Column(
                  //       children: [
                  //         TabBar(
                  //           controller: _rightDrawerTabController,
                  //           isScrollable: true,
                  //           tabs: const [
                  //             Tab(
                  //               icon: Icon(Icons.dashboard_customize_outlined),
                  //             ),
                  //           ],
                  //         ),
                  //         Expanded(
                  //           child: TabBarView(
                  //             controller: _rightDrawerTabController,
                  //             children: [
                  //               RightNavigationPanel(
                  //                 isMobileLayout: false,
                  //                 isCollapsed: isRightSidebarCollapsed,
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                   ],
                ),
              ));
  }

  // --- Removed _buildClickableResponse from here as it's now in AiChatDialog ---
}
