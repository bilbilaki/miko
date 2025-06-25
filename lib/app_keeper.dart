import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/settings_provider.dart';
import 'screens/settings_screen.dart';

import 'screens/unisearch_screen.dart';
import 'utils/colors.dart';
import 'widgets/left_navigation_panel.dart';
import 'widgets/center_content_panel.dart';
import 'widgets/right_settings_panel.dart';

class AppKeeper extends ConsumerStatefulWidget {
  const AppKeeper({super.key});

  @override
 ConsumerState<AppKeeper> createState() => _AppKeeperConsumerState();
}

class _AppKeeperConsumerState extends ConsumerState<AppKeeper>
    with TickerProviderStateMixin {
  // Changed to TickerProviderStateMixin
  // Left Drawer Tab Controller
  late TabController _leftDrawerTabController;
  // Right Drawer Tab Controller
  late TabController _rightDrawerTabController;

  @override
  void initState() {
    super.initState();
    // Initialize tab controllers (3 tabs each)
    _leftDrawerTabController = TabController(length: 1, vsync: this);
    _rightDrawerTabController = TabController(length: 1, vsync: this);
  }

  @override
  void dispose() {
    // Dispose of tab controllers
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
    return MaterialApp(
        theme: AppThemes.netflixDarkTheme,
        darkTheme: AppThemes.netflixDarkTheme,
        home:
            isSmallScreen
                ?
                Scaffold(
                    appBar: AppBar(
                      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                      actions: [
                        IconButton(
                          icon: const Icon(Icons.settings_outlined),
                          tooltip: 'Settings',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SettingsScreen()),
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
                                  builder: (context) => UnifiedSearchScreen()),
                            );
                          },
                        ),
                      ],
                    ),
                    drawer: Drawer(
                      backgroundColor: const Color.fromARGB(255, 63, 8, 93),
                      child: Column(
                        children: [
                          TabBar(
                            controller: _leftDrawerTabController,
                            tabs: [
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
                      backgroundColor: const Color.fromARGB(255, 13, 10, 136),
                      child: Column(
                        children: [
                          TabBar(controller: _rightDrawerTabController, tabs: [
                            Tab(
                              icon: Icon(Icons.dashboard_customize_outlined),
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
                  )
                :
                Scaffold(
                    body: Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOutCubic,
                        width: sidebarWidth,
                        color: const Color.fromARGB(255, 29, 8, 116),
                        child: Column(
                          children: [
                            TabBar(
                              controller: _leftDrawerTabController,
                              isScrollable: true,
                              tabs: [
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
                      Expanded(
                          flex: 3,
                          child: CenterContentPanel(isMobileLayout: false)),

                      // Right Settings Panel with Tabs
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOutCubic,
                        width: sidebarWidthRight,
                        color: const Color.fromARGB(255, 25, 14, 120),
                        child: Column(
                          children: [
                            TabBar(
                              controller: _rightDrawerTabController,
                              isScrollable: true,
                              tabs: [
                                Tab(
                                  icon:
                                      Icon(Icons.dashboard_customize_outlined),
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
                  )));
  }
}
