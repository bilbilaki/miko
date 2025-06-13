import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/settings_screen.dart';
import 'providers/sidebar_provider.dart';
import 'providers/right_sidebar_provider.dart';

import 'widgets/left_navigation_panel.dart';
import 'widgets/center_content_panel.dart';
import 'widgets/right_settings_panel.dart';

class AppKeeper extends ConsumerStatefulWidget {
  const AppKeeper({super.key});

  @override
  _AppKeeperConsumerState createState() => _AppKeeperConsumerState();
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

    if (isSmallScreen) {
      // Mobile/Tablet Layout: Use Drawers with Tabs
      return Scaffold(
        appBar: AppBar(
          title: const Text('Xmiko'),
          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              tooltip: 'Settings',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()),
                );
              },
            ),
          ],
        ),
        drawer: Drawer(
          backgroundColor: const Color.fromARGB(255, 110, 6, 6),
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
          backgroundColor: const Color.fromARGB(255, 134, 10, 10),
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
      );
    } else {
      // Desktop Layout
      return Scaffold(
        body: Row(
          children: [
            // Animated Collapsible Sidebar with Tabs
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOutCubic,
              width: sidebarWidth,
              color: const Color.fromARGB(255, 65, 0, 0),
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
            Expanded(flex: 3, child: CenterContentPanel(isMobileLayout: false)),

            // Right Settings Panel with Tabs
                        AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOutCubic,
              width: sidebarWidthRight,
              color: const Color.fromARGB(255, 65, 0, 0),
              child: Column(
                children: [
                  TabBar(
                    controller: _rightDrawerTabController,
                    isScrollable: true,
                    tabs: [
                      Tab(
                        icon: Icon(Icons.dashboard_customize_outlined),
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
      );
    }
  }
}
