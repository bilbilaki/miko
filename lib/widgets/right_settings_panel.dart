// TODO Implement this library.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miko/providers/right_sidebar_provider.dart';
import 'package:miko/screens/anime_grid_screen.dart';
import 'package:miko/screens/csv_editor_screen.dart';
import 'package:miko/screens/favorites_screen.dart';
import 'package:miko/screens/genre_list_screen.dart';
import 'package:miko/screens/home_screen.dart';
import 'package:miko/screens/http%20copy.dart';

import 'package:miko/screens/local_screen.dart';
import 'package:miko/screens/settings_screen.dart';
import 'package:miko/screens/shorts_screen.dart';
import 'package:miko/screens/tv_series_grid_screen.dart';
import 'package:miko/screens/watchlist_screen.dart';
import 'package:miko/showcases/movie_page.dart';
import 'package:miko/showcases/movie_page_copy.dart';
import 'package:miko/showcases/tv_page_anime.dart';
import 'package:miko/showcases/tv_page_tv.dart';
import 'package:miko/utils/colors.dart';

class RightNavigationPanel extends ConsumerWidget {
  final bool isMobileLayout;
  final bool isCollapsed; // Only relevant for desktop

  const RightNavigationPanel({
    super.key,
    required this.isMobileLayout,
    required this.isCollapsed, // Pass collapsed state
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                    ref.read(rightSidebarCollapsedProvider.notifier).state =
                        false;
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
                        icon: const Icon(Icons.chevron_right, size: 20),
                        onPressed: () => ref
                            .read(rightSidebarCollapsedProvider.notifier)
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
              // --- REVERSED ORDER ---
              _buildNavigationItem(
                context,
                ref,
                icon: Icons.file_open_outlined,
                title: 'File Explorer',
                showText: showText,
                onTap: () =>
                    _navigateTo(context, LocalScreen(), isMobileLayout),
              ),
              _buildNavigationItem(
                context,
                ref,
                icon: Icons.hdr_on_select_rounded,
                title: 'Creweler',
                showText: showText,
                onTap: () =>
                    _navigateTo(context, CrawlerHomePage1(), isMobileLayout),
              ),
              _buildNavigationItem(
                context,
                ref,
                icon: Icons.card_membership_sharp,
                title: 'Tvshow Beta',
                showText: showText,
                onTap: () =>
                    _navigateTo(context, TvShowPage1(), isMobileLayout),
              ),
              _buildNavigationItem(
                context,
                ref,
                icon: Icons.movie_edit,
                title: 'Movie Beta',
                showText: showText,
                onTap: () => _navigateTo(context, MoviePage1(), isMobileLayout),
              ),
              _buildNavigationItem(context, ref,
                  icon: Icons.data_object_outlined,
                  title: 'Csv Editor',
                  showText: showText, onTap: () {
               
                  _navigateTo(context, CsvEditorScreen(), isMobileLayout);
              
              }),
              _buildNavigationItem(
                context,
                ref,
                icon: Icons.tv_rounded,
                title: 'TvShow Beta2',
                showText: showText,
                onTap: () => _navigateTo(context, TvShowPageTV(), isMobileLayout),
              ),
              _buildNavigationItem(
                context,
                ref,
                icon: Icons.movie_outlined,
                title: 'Popular Movie',
                showText: showText,
                onTap: () => _navigateTo(context, MoviePage(), isMobileLayout),
              ),
              if (showText) _buildSectionHeader('Subscriptions'),
              const Padding(padding: EdgeInsets.fromLTRB(16, 12, 16, 8)),
              const Divider(color: AppColors.dividerColor, height: 1),
              _buildNavigationItem(
                context,
                ref,
                icon: Icons.playlist_play,
                title: 'Playlist Player',
                showText: showText,
                onTap: () =>
                    _navigateTo(context, SubscriptionsPage(), isMobileLayout),
              ),
              _buildNavigationItem(
                context,
                ref,
                icon: Icons.favorite_border_sharp,
                title: 'Favorites',
                showText: showText,
                onTap: () =>
                    _navigateTo(context, FavoritesScreen(), isMobileLayout),
              ),
              _buildNavigationItem(
                context,
                ref,
                icon: Icons.watch_later_outlined,
                title: 'Watchlist',
                showText: showText,
                onTap: () =>
                    _navigateTo(context, WatchlistScreen(), isMobileLayout),
              ),
              _buildNavigationItem(
                context,
                ref,
                icon: Icons.settings_outlined,
                title: 'Settings',
                showText: showText,
                onTap: () =>
                    _navigateTo(context, SettingsScreen(), isMobileLayout),
              ),
              _buildNavigationItem(
                context,
                ref,
                icon: Icons.video_library_outlined,
                title: 'Subscription',
                showText: showText,
                onTap: () =>
                    _navigateTo(context, SubscriptionsPage(), isMobileLayout),
              ),
              const Divider(color: AppColors.dividerColor, height: 1),
              _buildNavigationItem(
                context,
                ref,
                icon: Icons.category_outlined,
                title: 'Genres',
                showText: showText,
                onTap: () =>
                    _navigateTo(context, GenreListScreen(), isMobileLayout),
              ),
              _buildNavigationItem(
                context,
                ref,
                icon: Icons.movie_outlined,
                title: 'Anime',
                showText: showText,
                onTap: () =>
                    _navigateTo(context, AnimeGridScreen(), isMobileLayout),
              ),
              _buildNavigationItem(
                context,
                ref,
                icon: Icons.live_tv_rounded,
                title: 'TV Series',
                showText: showText,
                onTap: () =>
                    _navigateTo(context, TvSeriesGridScreen(), isMobileLayout),
              ),
              _buildNavigationItem(
                context,
                ref,
                icon: Icons.movie_creation,
                title: 'Movies',
                showText: showText,
                onTap: () => _navigateTo(context, HomeScreen(), isMobileLayout),
              ),
            ],
          ),
        ),
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
    WidgetRef ref, {
    required IconData icon,
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
                Text(title,
                    style: TextStyle(color: Colors.grey[300], fontSize: 14)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
