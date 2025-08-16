import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miko/providers/god_proovider.dart';
import 'package:miko/providers/settings_provider.dart';
import 'package:miko/screens/anime_grid_screen.dart';
import 'package:miko/screens/filtrering_screen.dart';
import 'package:miko/screens/genre_detail_screen.dart';
import 'package:miko/screens/iptv_screen.dart';
import 'package:miko/screens/unisearch_screen.dart';
import 'package:miko/screens/watchlist_screen.dart';
import 'package:miko/showcases/movie_detail_page_copy.dart';
import 'package:miko/showcases/movie_service.dart';
import 'package:miko/showcases/tv_detail_page_anime.dart';
import 'package:miko/utils/colors.dart';
import 'package:miko/utils/utils.dart';
import 'package:miko/widgets/ai_chat_dialog.dart';
import 'package:miko/widgets/alienswapbutton.dart';
import 'package:miko/widgets/bottom_nav_bar.dart';
import 'package:miko/widgets/left_navigation_panel.dart';
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
  late final AppLinks _appLinks;
  late final Stream<Uri> _uriStream;
  final List<Widget> _pages = [
    const AnimeGridScreen(typec: "movie"),
    const AnimeGridScreen(typec: "tvseries"),
    const AnimeGridScreen(typec: "anime"),
    const GenreListScreen(),
    const FavoritesScreen(),
    const IptvScreen(),

    /// const WatchlistScreen(),
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
  void initState() {
    super.initState();
    _initDeepLinking();
  }

  // For when app is opened *while already running*
  void _initDeepLinking() async {
    _appLinks = AppLinks();
    _uriStream = _appLinks.uriLinkStream;

    // Listen for incoming links (hot start)
    _uriStream.listen((Uri uri) {
      _handleDeepLink(uri);
    });

    // Check for cold start deep link
    final initialUri = await _appLinks.getInitialLink();
    if (initialUri != null) {
      _handleDeepLink(initialUri);
    }
  }

  void _handleDeepLink(Uri uri) async {
    final path = uri.path;
    final idStr = uri.queryParameters['id'];
    final id = int.tryParse(idStr ?? '');

    if (path == 'miko/movie' && id != null) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => MovieDetailPage(id: id)));
    } else if (path == 'miko/series' && id != null) {
      final MovieService _movieService = MovieService();
      final tvs = await _movieService.getTvShowDetails(tvShowId: id);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => TvShowDetailPageAnime(tvShow: tvs, typec: "tvseries"),
        ),
      );
    }
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
        drawer: Drawer(

                  child:           LeftNavigationPanel(
                              isMobileLayout: true,
                              isCollapsed: false,
                            ),
                        
                        
                    
                  
                  
                ),
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
        floatingActionButton: pp.Consumer<FloatingButtonVisibilityNotifier>(
          builder: (context, visibilityNotifier, child) {
            return visibilityNotifier.isVisible
                ? AlienFloatSwapMenu(
                    OnAskAi: () {
                      showDialog(
                        context: context,
                        builder: (ctx) {
                          return ProviderScope(
                            parent: ProviderScope.containerOf(context),
                            child: AiChatDialog(),
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
                          }
                        },
                      );
                    },
                    search: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        builder: (context) =>
                            UnifiedSearchBottomSheet(initialQuery: ''),
                      );
                    },
                  )
                : Container();
          },
        ),
      ),
    );
  }
}


