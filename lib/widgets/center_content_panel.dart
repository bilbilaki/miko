import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miko/screens/anime_grid_screen.dart';
import 'package:miko/screens/genre_detail_screen.dart';
import 'package:miko/screens/watchlist_screen.dart';
import 'package:miko/utils/colors.dart';
import 'package:miko/widgets/bottom_nav_bar.dart';

class CenterContentPanel extends ConsumerStatefulWidget {
  final bool isMobileLayout;
  const CenterContentPanel({super.key, required this.isMobileLayout});

  @override
  ConsumerState<CenterContentPanel> createState() => _CenterContentPanelState();
}

class _CenterContentPanelState extends ConsumerState<CenterContentPanel> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const AnimeGridScreen(typec: "movie"),
  //  const TvSeriesGridScreen(),
    const AnimeGridScreen(typec: "tvseries"), // Placeholder
    const AnimeGridScreen(typec: "anime"), // Placeholder

    const GenreListScreen(), // Placeholder
    const FavoritesScreen(), // Placeholder
    const WatchlistScreen(), // Placeholder
  ];

  void _onPageChanged(int index) {
    debugPrint('Navigating to page index: $index');
    setState(() {
      _currentIndex = index;
    });
  }

  void _onNavBarTap(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppThemes.netflixDarkTheme,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: PageView(
          controller: _pageController,
          onPageChanged: _onPageChanged,
          physics: const BouncingScrollPhysics(),
          children: _pages,
        ),
        bottomNavigationBar: BottomNavBar(
          currentIndex: _currentIndex,
          onTap: _onNavBarTap,
        ),
      ),
    );
  }
}