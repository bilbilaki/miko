import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miko/main.dart';
import 'package:miko/providers/god_proovider.dart';
import 'package:miko/screens/anime_grid_screen.dart';
import 'package:miko/screens/dl.dart';
import 'package:miko/screens/favorites_screen.dart';
import 'package:miko/screens/filtrering_screen.dart';
import 'package:miko/screens/genres_list_screen.dart';
import 'package:miko/screens/watchlist_screen.dart';
import 'package:miko/utils/colors.dart';
import 'package:miko/utils/utils.dart';
import 'package:miko/widgets/awesome_unified_search_field.dart';
import 'package:miko/widgets/bottom_nav_bar.dart';
import 'package:miko/widgets/left_navigation_panel.dart';
import 'package:miko/widgets/right_navigation_panel.dart';
import 'package:provider/provider.dart';
import 'package:provider/provider.dart' as pp;

class CenterContentPanel extends ConsumerStatefulWidget {
  final bool isMobileLayout;
  const CenterContentPanel({super.key, required this.isMobileLayout});

  @override
  ConsumerState<CenterContentPanel> createState() => _CenterContentPanelState();
}

class _CenterContentPanelState extends ConsumerState<CenterContentPanel> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  StreamSubscription? _sub;
  
  // late final AppLinks _appLinks;
  // late final Stream<Uri> _uriStream;
  final List<Widget> _pages = [

    AnimeGridScreen(typec: "movie"),
    AnimeGridScreen(typec: "tvseries"),
    AnimeGridScreen(typec: "anime"),
    GenreListScreen(),
    FavoritesScreen(),
    WatchlistScreen(),

    /// const WatchlistScreen(),
  ];
  void _navigateToDownloadScreen() {
    tVClick();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DownloadScreen(
          downloadManager: downloadManager,
        ),
      ),
    );
  }

  void _onPageChanged(int index) {
    tVmedium();
    setState(() {
      _currentIndex = index;
    });
  }

  void _onNavBarTap(int index) {
    tVmedium();
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 200),
      curve: Curves.ease,
    );
  }

  @override
  void initState() {
    super.initState();
    // _initDeepLinking();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final movieProvider = context.watch<MovieProvider>();
    final tvProvider = context.watch<TvSeriesProvider>();
    final animeProvider = context.watch<AnimeProvider>();
    return MaterialApp(
      theme: AppThemes.netflixDarkTheme,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
// Inside your Scaffold (like in CenterContentPanel)
        appBar: AppBar(
          toolbarHeight: 72,
          flexibleSpace: SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                child: FractionallySizedBox(
                  widthFactor: 0.7, // Half width
                  child: AwesomeUnifiedSearchField(
                    autofocus: true,
                    // Map to your first example provider methods:
                    searchMovies: (q) =>
                        context.read<MovieProvider>().searchMovies(q),
                    searchTv: (q) => context
                        .read<TvSeriesProvider>()
                        .searchAnime(q), // adjust to your actual method
                    searchAnime: (q) =>
                        context.read<AnimeProvider>().searchAnime(q),
                        onDownloadsTap: _navigateToDownloadScreen,
                    onAdvancedTap: () {
                      showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) {
                switch (_currentIndex) {
                  case 0:
                    return ContentFilterBottomSheet<MovieProvider>(
                      provider: movieProvider,
                    );
                  case 1:
                    return ContentFilterBottomSheet<TvSeriesProvider>(
                      provider: tvProvider,
                    );
                  case 2:
                    return ContentFilterBottomSheet<AnimeProvider>(
                      provider: animeProvider,
                    );
                  default:
                    return ContentFilterBottomSheet<MovieProvider>(
                      provider: movieProvider,
                    );
                }});
                
                    },
                  ),
                ),
              ),
            ),
          ),
        ),       drawer: Drawer(
          child: LeftNavigationPanel(isMobileLayout: true, isCollapsed: false),
        ),
        endDrawer: Drawer(child: RightNavigationPanel(isMobileLayout: true, isCollapsed: false)),
        endDrawerEnableOpenDragGesture: true,
        drawerEnableOpenDragGesture: true,

        body: PageView(
          controller: _pageController,
          onPageChanged: _onPageChanged,
          physics: const BouncingScrollPhysics(),
          allowImplicitScrolling: true,
          children: _pages,
        ),
        bottomNavigationBar: BottomNavBar(
          currentIndex: _currentIndex,
          onTap: _onNavBarTap,
        ),
  //       floatingActionButton: ExpandableFab(
  // distance: 112,
  // children: [
  //   ActionButton(
  //     onPressed: () {
  //           showModalBottomSheet(
  //             context: context,
  //             isScrollControlled: true,
  //             builder: (context) {
  //               switch (_currentIndex) {
  //                 case 1:
  //                   return ContentFilterBottomSheet<MovieProvider>(
  //                     provider: movieProvider,
  //                   );
  //                 case 2:
  //                   return ContentFilterBottomSheet<TvSeriesProvider>(
  //                     provider: tvProvider,
  //                   );
  //                 case 3:
  //                   return ContentFilterBottomSheet<AnimeProvider>(
  //                     provider: animeProvider,
  //                   );
  //                 default:
  //                   return ContentFilterBottomSheet<MovieProvider>(
  //                     provider: movieProvider,
  //                   );
  //               }});},
  //     icon: const Icon(Icons.search_rounded),
  //   ),
  //   ActionButton(
  //     onPressed: () {
  //           showModalBottomSheet(
  //             context: context,
  //             isScrollControlled: true,
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //             ),
  //             builder: (context) => UnifiedSearchBottomSheet(initialQuery: ''),
  //           );
  //         },
  //     icon: const Icon(Icons.archive_rounded),
  //   ),
//  ],//
//),
        
        
        
        
        
        
        
        
        
));  }}