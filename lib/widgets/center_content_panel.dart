import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miko/providers/god_proovider.dart';
import 'package:miko/providers/settings_provider.dart';
import 'package:miko/screens/anime_grid_screen.dart';
import 'package:miko/screens/filtrering_screen.dart';
import 'package:miko/screens/genre_detail_screen.dart';
import 'package:miko/screens/unisearch_screen.dart';
import 'package:miko/screens/watchlist_screen.dart';
import 'package:miko/utils/colors.dart';
import 'package:miko/utils/utils.dart';
import 'package:miko/widgets/ai_chat_dialog.dart';
import 'package:miko/widgets/alienswapbutton.dart';
import 'package:miko/widgets/bottom_nav_bar.dart';
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

  final List<Widget> _pages = [
    const AnimeGridScreen(typec: "movie"),
    const AnimeGridScreen(typec: "tvseries"),
    const AnimeGridScreen(typec: "anime"), 
    const GenreListScreen(), 
    const FavoritesScreen(), 
    const WatchlistScreen(), 
  ];

  void _onPageChanged(int index) {
    debugPrint('Navigating to page index: $index');
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
  void dispose() {
    _pageController.dispose();
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
        floatingActionButton: pp.Consumer<FloatingButtonVisibilityNotifier>(
    builder: (context, visibilityNotifier, child) {
      return visibilityNotifier.isVisible ?
         AlienFloatSwapMenu(
            OnAskAi: () {
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
                onFilter: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) {
                    switch (_currentIndex) {
                      case 0:
                        return ContentFilterBottomSheet<MovieProvider>(provider: movieProvider);
                      case 1:
                        return ContentFilterBottomSheet<TvSeriesProvider>(provider: tvProvider);
                      case 2:
                        return ContentFilterBottomSheet<AnimeProvider>(provider: animeProvider);
                      default:
                        return ContentFilterBottomSheet<MovieProvider>(provider: movieProvider);
                    }
                  },
                );
              },
                search: () {showModalBottomSheet(
  context: context,
  isScrollControlled: true, 
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
  builder: (context) => UnifiedSearchBottomSheet(initialQuery: ''),
);},
          ) : Container();
        }),
      ),
    );
  }
}
