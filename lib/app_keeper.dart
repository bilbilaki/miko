import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/settings_provider.dart';
import 'utils/colors.dart'; // Assuming AppThemes is defined here
import 'widgets/left_navigation_panel.dart';
import 'widgets/center_content_panel.dart';
class AppKeeper extends ConsumerStatefulWidget {
  const AppKeeper({super.key});

  @override
  ConsumerState<AppKeeper> createState() => _AppKeeperConsumerState();
}

class _AppKeeperConsumerState extends ConsumerState<AppKeeper>
    with TickerProviderStateMixin {
  late TabController _leftDrawerTabController;

  @override
  void initState() {
    super.initState();
    _leftDrawerTabController = TabController(length: 1, vsync: this);
  }

  @override
  void dispose() {
    _leftDrawerTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSidebarCollapsed = ref.watch(sidebarCollapsedProvider);

    final double sidebarWidth = isSidebarCollapsed ? 60.0 : 260.0;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 1300; // Breakpoint for drawers

    const Color leftSidebarColor =
        Color.fromARGB(255, 25, 0, 69); // Example theme color

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppThemes.netflixDarkTheme,
        darkTheme: AppThemes.netflixDarkTheme,
        builder: (context, child) {
          final mediaQuery = MediaQuery.of(context);
          final clampedTextScaler = mediaQuery.textScaler.clamp(
            minScaleFactor: 0.9,
            maxScaleFactor: 1.2,
          );

          return MediaQuery(
            data: mediaQuery.copyWith(textScaler: clampedTextScaler),
            child: child!,
          );
        },
        home:  CenterContentPanel(isMobileLayout: isSmallScreen),
            
           );
  }
}
