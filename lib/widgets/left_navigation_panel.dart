import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miko/screens/anime_grid_screen.dart';
import 'package:miko/screens/genre_detail_screen.dart';
import 'package:miko/screens/settings_screen.dart';
import 'package:miko/screens/shorts_screen.dart';
import 'package:miko/screens/watchlist_screen.dart';
import 'package:miko/showcases/keyword_search_page.dart';
import 'package:miko/showcases/movie_page.dart';
import 'package:miko/showcases/moviesearchpage.dart';
import 'package:miko/showcases/multi_search_page.dart';
import 'package:miko/showcases/tvsearchpage.dart';
import 'package:miko/utils/colors.dart';

import '../providers/settings_provider.dart';
class LeftNavigationPanel extends ConsumerWidget {
  final bool isMobileLayout;
  final bool isCollapsed; // Only relevant for desktop

  const LeftNavigationPanel({
    super.key,
    required this.isMobileLayout,
    required this.isCollapsed, // Pass collapsed state
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch providers needed for display and actions
    // No need to watch sidebarCollapsedProvider directly if passed via constructor

    final bool showText =
        !isCollapsed || isMobileLayout; // Determine when to show text

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- Header / Logo ---
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: isCollapsed && !isMobileLayout
              ? IconButton(
                  // Icon when collapsed
                  icon: const Icon(
                      Icons.interests_rounded), // Use a relevant icon
                  tooltip: 'Xoshio',
                  onPressed: () {
                    // Maybe expand sidebar on icon click?
                    ref.read(sidebarCollapsedProvider.notifier).state = false;
                  },
                  color: Colors.grey[300],
                )
              : Row(
                  // Logo/Title and potentially a collapse button when expanded
                  children: [
                    Icon(Icons.interests_rounded,
                        color: Colors.blue[300], size: 24),
                    const SizedBox(width: 8),
                    const Text(
                      'Xoshio',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    // Show collapse button only when expanded on desktop
                    if (!isCollapsed && !isMobileLayout)
                      IconButton(
                        icon: const Icon(Icons.chevron_left, size: 20),
                        onPressed: () => ref
                            .read(sidebarCollapsedProvider.notifier)
                            .state = true,
                        tooltip: 'Collapse sidebar',
                        color: Colors.grey[400],
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                  ],
                ),
        ),

        // --- New Chat Button ---
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: isCollapsed && !isMobileLayout
              ? IconButton(
                  icon: const Icon(Icons.add_comment_outlined),
                  tooltip: "New Chat",
                  onPressed: () {},
                  color: Colors.grey[300],
                )
              : ElevatedButton.icon(
                  icon: const Icon(Icons.add, size: 20),
                  label: const Text('New Chat'),
                  onPressed: () {
                    if (isMobileLayout) Navigator.pop(context); // Close drawer
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 40), // Full width
                    // Use theme colors or define explicitly
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    foregroundColor:
                        Theme.of(context).colorScheme.onPrimaryContainer,
                    alignment: Alignment.centerLeft, // Align icon/text left
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                  ),
                ),
        ),

     Expanded(
  child: ListView(
    padding: EdgeInsets.zero,
    shrinkWrap: true,
    children: [
      _buildNavigationItem(
        context,
        ref,
        icon: Icons.movie_creation, 
        title: 'Movies',
        showText: showText,
        onTap: () => _navigateTo(context, AnimeGridScreen(typec: "movie",), isMobileLayout),
      ),
      _buildNavigationItem(
        context,
        ref,
        icon: Icons.live_tv_rounded,
        title: 'TV Series',
        showText: showText,
        onTap: () => _navigateTo(context, AnimeGridScreen(typec: "tvseries"), isMobileLayout),
      ),
                  _buildNavigationItem(
            context,
            ref,
            icon: Icons.movie_outlined,
            title: 'Anime',
                    showText: showText,

            onTap: () => _navigateTo(context, AnimeGridScreen(typec: "anime") ,isMobileLayout),
          ),
          _buildNavigationItem(
            context,
            ref,
            icon: Icons.category_outlined,
            title: 'Genres',
            showText:showText,
            onTap: () => _navigateTo(context, GenreListScreen(), isMobileLayout),
          ),
          const Divider(color: AppColors.dividerColor, height: 1),
          _buildNavigationItem(
            context,
            ref,
            icon: Icons.video_library_outlined,
            title: 'Subscription',
            showText:showText,
            onTap: () => _navigateTo(context, SubscriptionsPage(), isMobileLayout),
          ),
          _buildNavigationItem(
            context,
            ref,
            icon: Icons.settings_outlined,
            title: 'Settings',
            showText:showText,
            onTap: () => _navigateTo(context, SettingsScreen(), isMobileLayout),
          ),
          _buildNavigationItem(
            context,
            ref,
            icon: Icons.watch_later_outlined,
            title: 'Watchlist',
            showText:showText,
            onTap: () => _navigateTo(context, WatchlistScreen(), isMobileLayout),
          ),
          _buildNavigationItem(
            context,
            ref,
            icon: Icons.favorite_border_sharp,
            title: 'Favorites',
            showText:showText,
            onTap: () => _navigateTo(context, FavoritesScreen(), isMobileLayout),
          ),
          // _buildDrawerItem(
          //   context,
          //   icon: Icons.download_outlined,
          //   title: 'Downloads',
          //   onTap: () => _showNotImplementedSnackbar(context),
          // ),
                  _buildNavigationItem(
                    context,
                    ref,
                    icon: Icons.playlist_play,
                    title: 'Playlist Player',
                    showText: showText,
                    onTap: () => _navigateTo(context, SubscriptionsPage(), isMobileLayout),
                  ),
                  const Divider(color: AppColors.dividerColor, height: 1),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 12, 16, 8)),
      if (showText) _buildSectionHeader('Subscriptions'),
      _buildNavigationItem(
        context,
        ref,
        icon: Icons.movie_outlined,
        title: 'Popular Movie',
        showText: showText,
        onTap: () => _navigateTo(context, MoviePage(), isMobileLayout),
      ),                  
                     
                _buildNavigationItem(
 context,
 ref,
 icon: Icons.tv_rounded,
 title: 'Popular TV Shows',
 showText: showText,
 onTap: () => _navigateTo(context, TvSearchPage(), isMobileLayout),
),

_buildNavigationItem(
 context,
 ref,
 icon: Icons.add,
 title: 'Browse channels',
 showText: showText,
 onTap: () => _navigateTo(context, TvSearchPage(), isMobileLayout),
),

_buildNavigationItem(
 context,
 ref,
 icon: Icons.question_mark,
 title: 'Browse movies',
 showText: showText,
 onTap: () => _navigateTo(context, MovieSearchPage(), isMobileLayout),
),

_buildNavigationItem(
 context,
 ref,
 icon: Icons.five_k_plus_rounded,
 title: 'Browse keywords',
 showText: showText,
 onTap: () => _navigateTo(context, KeywordSearchPage(), isMobileLayout),
),

_buildNavigationItem(
 context,
 ref,
 icon: Icons.javascript,
 title: 'Browse search',
 showText: showText,
 onTap: () => _navigateTo(context, MultiSearchPage(), isMobileLayout),
),

// _buildNavigationItem(
//  context,
//  ref,
//  icon: Icons.dangerous,
//  title: 'Fullscreen',
//  showText: showText,
//  onTap: () => _navigateTo(context, const WebV(), isMobileLayout),
// ),
                  
                ])
        )
      ],
    );
  }
// New helper methods
void _navigateTo(BuildContext context, Widget screen, bool isMobileLayout) {
  if (isMobileLayout) Navigator.pop(context);
  Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
}

Widget _buildSectionHeader(String text) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
    child: Text(
      text,
      style: TextStyle(
        color: Colors.grey[400],
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}

Widget _buildNavigationItem(
  BuildContext context,
  WidgetRef ref,
  {required IconData icon,
  required String title,
  required bool showText,
  required VoidCallback onTap,
}) {
  return Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 22, color: Colors.grey[300]),
            if (showText) ...[
              const SizedBox(width: 16),
              Text(title, style: TextStyle(color: Colors.grey[300], fontSize: 14)),
            ],
          ],
        ),
      ),
    ),
  );
}
}
