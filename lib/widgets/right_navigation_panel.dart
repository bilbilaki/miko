import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miko/screens/anime_grid_screen.dart';
import 'package:miko/screens/dl.dart';
import 'package:miko/screens/update_bia2anime_resources.dart';
import 'package:miko/screens/local_library_grid_screen.dart';
import 'package:miko/screens/local_screen.dart';
import 'package:miko/screens/scrap_page.dart';
import 'package:miko/screens/settings_page.dart';
import 'package:miko/screens/url_source_screen.dart';
import 'package:miko/utils/colors.dart';
import 'package:miko/utils/utils.dart';
import '../providers/settings_provider.dart';
import '../screens/subtitle_generation.dart.dart';

class RightNavigationPanel extends ConsumerWidget {
  final bool isMobileLayout;
  final bool isCollapsed;

  const RightNavigationPanel({
    super.key,
    required this.isMobileLayout,
    required this.isCollapsed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool showText = !isCollapsed || isMobileLayout;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Header / Logo (mirrored)
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: isCollapsed && !isMobileLayout
              ? Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: const Icon(Icons.interests_rounded),
                    onPressed: () {
                      ref.read(rightSidebarCollapsedProvider.notifier).state =
                          false;
                    },
                    color: Colors.grey[300],
                  ),
                )
              : Row(
                  children: [
                    // Collapse button on the left when expanded on desktop
                    if (!isCollapsed && !isMobileLayout)
                      IconButton(
                        icon: const Icon(Icons.chevron_right, size: 20),
                        onPressed: () =>
                            ref
                                    .read(
                                      rightSidebarCollapsedProvider.notifier,
                                    )
                                    .state =
                                true,
                        tooltip: 'Collapse sidebar',
                        color: Colors.grey[400],
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    const Spacer(),
                    const Text(
                      '',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.interests_rounded,
                      color: Colors.blue[300],
                      size: 24,
                    ),
                  ],
                ),
        ),

        // New Chat / Action Button (mirrored)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: isCollapsed && !isMobileLayout
              ? Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: const Icon(Icons.add_comment_outlined),
                    onPressed: () {},
                    color: Colors.grey[300],
                  ),
                )
              : Directionality(
                  textDirection: TextDirection.rtl, // mirror icon/text order
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.add, size: 20),
                    label: const Text(''),
                    onPressed: () {
                      if (isMobileLayout) Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 40),
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.primaryContainer,
                      foregroundColor: Theme.of(
                        context,
                      ).colorScheme.onPrimaryContainer,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                ),
        ),

        // Items
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            children: [
              _buildSectionHeader('Browse', alignRight: true),

              _buildRightNavigationItem(
                context,
                ref,
                icon: Icons.movie_creation,
                title: 'Movies',
                showText: showText,
                onTap: () => _navigateTo(
                  context,
                  AnimeGridScreen(typec: "movie"),
                  isMobileLayout,
                ),
              ),
              _buildRightNavigationItem(
                context,
                ref,
                icon: Icons.live_tv_rounded,
                title: 'TV Series',
                showText: showText,
                onTap: () => _navigateTo(
                  context,
                  AnimeGridScreen(typec: "tvseries"),
                  isMobileLayout,
                ),
              ),
              _buildRightNavigationItem(
                context,
                ref,
                icon: Icons.movie_outlined,
                title: 'Anime',
                showText: showText,
                onTap: () => _navigateTo(
                  context,
                  AnimeGridScreen(typec: "anime"),
                  isMobileLayout,
                ),
              ),
              _buildRightNavigationItem(
                context,
                ref,
                icon: Icons.library_add_check,
                title: 'Local Files',
                showText: showText,
                onTap: () =>
                    _navigateTo(context, LocalScreen(), isMobileLayout),
              ),
              _buildRightNavigationItem(
                context,
                ref,
                icon: Icons.network_wifi_sharp,
                title: 'Scrap Page',
                showText: showText,
                onTap: () =>
                    _navigateTo(context, DataExplorerScreen(), isMobileLayout),
              ),
              _buildRightNavigationItem(
                context,
                ref,
                icon: Icons.music_video,
                title: 'Audio Player',
                showText: showText,
                onTap: () => _navigateTo(
                  context,
                  DownloadScreen(downloadManager: DownloadListManager()),
                  isMobileLayout,
                ),
              ),
              _buildRightNavigationItem(
                context,
                ref,
                icon: Icons.music_video,
                title: 'http2',
                showText: showText,
                onTap: () => _navigateTo(
                  context,
                  UpdateBia2AnimeResources(),
                  isMobileLayout,
                ),
              ),
              _buildRightNavigationItem(
                context,
                ref,
                icon: Icons.music_video,
                title: 'Url',
                showText: showText,
                onTap: () =>
                    _navigateTo(context, StreamPlayerPage(), isMobileLayout),
              ),
              _buildRightNavigationItem(
                context,
                ref,
                icon: Icons.settings,
                title: 'Settings',
                showText: showText,
                onTap: () =>
                    _navigateTo(context, SettingsPage(), isMobileLayout),
              ),
              _buildRightNavigationItem(
                context,
                ref,
                icon: Icons.local_florist,
                title: 'local',
                showText: showText,
                onTap: () => _navigateTo(
                  context,
                  LocalLibraryGridScreen(),
                  isMobileLayout,
                ),
              ),
              _buildRightNavigationItem(
                context,
                ref,
                icon: Icons.subtitles,
                title: 'Subtitle Generator',
                showText: showText,
                onTap: () =>
                    _navigateTo(context, SubtitleGeneration(), isMobileLayout),
              ),

              const Divider(color: AppColors.dividerColor, height: 1),

              // Add your own items below; kept minimal as requested
              // _buildRightNavigationItem(...),
            ],
          ),
        ),
      ],
    );
  }

  void _navigateTo(BuildContext context, Widget screen, bool isMobileLayout) {
    tVClick();
    if (isMobileLayout) Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  Widget _buildSectionHeader(String text, {bool alignRight = false}) {
    final txt = Text(
      text,
      style: TextStyle(
        color: Colors.grey[400],
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      textAlign: alignRight ? TextAlign.right : TextAlign.left,
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: alignRight
          ? Align(alignment: Alignment.centerRight, child: txt)
          : txt,
    );
  }

  // Mirrored item (text then icon, aligned to the right)
  Widget _buildRightNavigationItem(
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
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (showText) ...[
                Flexible(
                  child: Text(
                    title,
                    style: TextStyle(color: Colors.grey[300], fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                  ),
                ),
                const SizedBox(width: 16),
              ],
              Icon(icon, size: 22, color: Colors.grey[300]),
            ],
          ),
        ),
      ),
    );
  }
}
