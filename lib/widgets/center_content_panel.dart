import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miko/screens/anime_grid_screen.dart';
import 'package:miko/screens/genre_list_screen.dart';
import 'package:miko/screens/home_screen.dart';
import 'package:miko/screens/tv_series_grid_screen.dart';
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
  final ScrollController _scrollController = ScrollController();
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const TvSeriesGridScreen(),
    const AnimeGridScreen(), // Placeholder
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

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppThemes.netflixDarkTheme,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: _pages[_currentIndex],
        bottomNavigationBar: BottomNavBar(
          currentIndex: _currentIndex,
          onTap: _onPageChanged,
        ),
      ),
    );
  }

    //ref.read(activeChatMessagesProvider.allTransitiveDependencies)?.addMessage(userMessage);
    //_scrollToBottom(true);

    // Actual file sending logic (e.g., upload) should be in ChatController
    // For now, we assume ChatController handles this when it receives the message
    // (or create a specific method in ChatController like 'sendFileMessage')
    // Or simply:
    // ref.read(chatControllerProvider.notifier).sendMessage(
    //   userMessage.content, // or a special type of message
    //   attachmentPath: file.path,
    //   attachmentType: contentType,
    // );
  }