import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miko/providers/god_proovider.dart';
import 'package:miko/screens/anime_grid_screen.dart';
import 'package:miko/screens/filtrering_screen.dart';
import 'package:miko/screens/genre_detail_screen.dart';
import 'package:miko/screens/unisearch_screen.dart';
import 'package:miko/screens/watchlist_screen.dart';
import 'package:miko/utils/colors.dart';
import 'package:miko/utils/utils.dart';
import 'package:miko/widgets/alienswapbutton.dart';
import 'package:miko/widgets/bottom_nav_bar.dart';
import 'package:provider/provider.dart';

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
        floatingActionButton: 
 AlienFloatSwapMenu(
                OnAskAi: () {
                  // Now simply show the new AiChatDialog widget
                  // showDialog(
                  //   context: context,
                  //   builder: (ctx) {
                  //     // It is critical to wrap the dialog with ProviderScope
                  //     // if the dialog (or its children) will consume Riverpod providers,
                  //     // and it's being shown outside of the main widget tree's ProviderScope.
                  //     // ProviderScope.containerOf(context) ensures it uses the existing Riverpod container.
                  //     return ProviderScope(
                  //       parent: ProviderScope.containerOf(context),
                  //       child: const AiChatDialog(),
                  //     );
                  //   },
                  // );
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
  isScrollControlled: true, // For full height if needed
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
  builder: (context) => UnifiedSearchBottomSheet(initialQuery: ''),
);},
           //     searchOnline: () => AnimeGridScreenState().showSearchOverlay(context),
                // onNew: () => print("New"), // Consistent naming
                // onUndo: () => print("Undo"), // Consistent naming
                // onRedo: () => print("Redo"), // Consistent naming

      ),
      )  );
  }
}
