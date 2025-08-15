import 'package:fl_lib/fl_lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miko/box/data/res/openai.dart';
import 'package:miko/jackett/ui/screens/home_screen.dart';
import 'package:miko/mycore/chat_page.dart';
import 'package:miko/screens/anime_grid_screen.dart';
import 'package:miko/screens/genre_detail_screen.dart';
import 'package:miko/screens/grid.dart';
import 'package:miko/screens/http.dart';
import 'package:miko/screens/iptv_screen.dart';
import 'package:miko/screens/watchlist_screen.dart';
import 'package:miko/showcases/keyword_search_page.dart';
import 'package:miko/showcases/movie_page_copy.dart';
import 'package:miko/showcases/moviesearchpage.dart';
import 'package:miko/showcases/tvsearchpage.dart';
import 'package:miko/utils/colors.dart';
import 'package:miko/utils/utils.dart';
import 'package:miko/webviewai/main.dart';
import 'package:miko/yt-dlp/ui/screens/home_screen.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../providers/settings_provider.dart';
import 'package:fl_lib/fl_lib.dart';
import 'package:fl_lib/generated/l10n/lib_l10n.dart';
import 'package:flutter/material.dart';
import 'package:miko/box/data/res/build_data.dart';
import 'package:miko/box/data/res/l10n.dart';
import 'package:miko/box/data/store/all.dart';
import 'package:miko/box/generated/l10n/l10n.dart';
import 'package:miko/box/view/page/home/home.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:responsive_framework/responsive_framework.dart';

typedef _Builder = Widget Function(BuildContext ctx, double padTop);

final class _IntroPage extends StatelessWidget {
  final List<_Builder> pages;

  const _IntroPage(this.pages);

  static const _builders = {237: _buildAppSettings};

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      // To fix the l10n issue
      key: UniqueKey(),
      builder: (context, cons) {
        final padTop = cons.maxHeight * .12;
        final pages_ = pages.map((e) => e(context, padTop)).toList();
        return IntroPage(
          args: IntroPageArgs(
            pages: pages_,
            onDone: (ctx) {
              Stores.setting.introVer.set(BuildData.build);
              Navigator.of(ctx).pushReplacement(
                MaterialPageRoute(builder: (_) => const HomePage()),
              );
            },
          ),
        );
      },
    );
  }

  static Widget _buildAppSettings(BuildContext ctx, double padTop) {
    return ListView(
      padding: _introListPad,
      children: [
        SizedBox(height: padTop),
        _buildTitle(icon: Iconsax.magic_star_bold, big: true),
        SizedBox(height: padTop),
        _buildTitle(text: 'App'),
        ListTile(
          leading: const Icon(IonIcons.language),
          title: Text(libL10n.language),
          onTap: () async {
            final selected = await ctx.showPickSingleDialog(
              title: libL10n.language,
              items: AppLocalizations.supportedLocales,
              display: (p0) => p0.nativeName,
              initial: _setting.locale.get().toLocale,
            );
            if (selected != null) {
              _setting.locale.set(selected.code);
              RNodes.app.notify(delay: true);
            }
          },
          trailing: Text(
            l10n.languageName,
            style: const TextStyle(fontSize: 15, color: Colors.grey),
          ),
        ).cardx,
        ListTile(
          leading: const Icon(Icons.update),
          title: Text(l10n.autoCheckUpdate),
          trailing: StoreSwitch(prop: _setting.autoCheckUpdate),
        ).cardx,
        _buildTitle(text: l10n.chat),
        ListTile(
          leading: const Icon(Iconsax.subtitle_bold),
          title: Text(l10n.genChatTitle),
          trailing: StoreSwitch(prop: _setting.genTitle),
        ).cardx,
        ListTile(
          leading: const Icon(LineAwesome.compress_solid),
          title: Text(l10n.compress),
          subtitle: Text(l10n.compressImgTip, style: UIs.textGrey),
          trailing: StoreSwitch(prop: _setting.compressImg),
        ).cardx,
        ListTile(
          leading: const Icon(Icons.swap_vert),
          title: Text(l10n.scrollSwitchChat),
          trailing: StoreSwitch(prop: _setting.scrollSwitchChat),
        ).cardx,
      ],
    );
  }

  static Widget _buildTitle({IconData? icon, String? text, bool big = false}) {
    assert(icon != null || text != null);

    Widget child;
    if (icon != null) {
      child = Icon(icon, size: big ? 41 : null);
    } else if (text != null) {
      child = Text(
        text,
        style: big
            ? const TextStyle(fontSize: 41, fontWeight: FontWeight.w500)
            : UIs.textGrey,
      );
    } else {
      child = const SizedBox();
    }
    if (!big) {
      child = Padding(
        padding: const EdgeInsets.symmetric(vertical: 13),
        child: child,
      );
    }
    return Center(child: child);
  }

  static final _setting = Stores.setting;
  static const _introListPad = EdgeInsets.symmetric(horizontal: 17);

  static List<_Builder> get builders {
    final storedVer = _setting.introVer.get();
    return _builders.entries
        .where((e) => e.key > storedVer)
        .map((e) => e.value)
        .toList();
  }
}

class LeftNavigationPanel1 extends StatelessWidget {
  const LeftNavigationPanel1({super.key});

  @override
  Widget build(BuildContext context) {
    SystemUIs.setTransparentNavigationBar(context);

    return RNodes.app.listen(() => _buildApp(context));
  }

  Widget _buildApp(BuildContext context) {
    UIs.colorSeed = Color(Stores.setting.themeColorSeed.get());
    final themeMode = switch (Stores.setting.themeMode.get()) {
      1 => ThemeMode.light,
      2 => ThemeMode.dark,
      _ => ThemeMode.system,
    };
    final locale = Stores.setting.locale.get();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: locale.toLocale,
      localizationsDelegates: const [
        ...AppLocalizations.localizationsDelegates,
        LibLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      localeListResolutionCallback: LocaleUtil.resolve,
      themeMode: themeMode,
      theme: ThemeData(colorSchemeSeed: UIs.colorSeed).fixWindowsFont,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorSchemeSeed: UIs.colorSeed,
      ).toAmoled.fixWindowsFont,
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child ?? UIs.placeholder,
        breakpoints: const [
          Breakpoint(start: 0, end: 450, name: MOBILE),
          Breakpoint(start: 451, end: 800, name: TABLET),
          Breakpoint(start: 801, end: 1920, name: DESKTOP),
        ],
      ),
      home: VirtualWindowFrame(
        child: Builder(
          builder: (context) {
            final l10n_ = AppLocalizations.of(context);
            if (l10n_ != null) l10n = l10n_;
            context.setLibL10n();
            UIs.primaryColor = Theme.of(context).colorScheme.primary;

            final intros = _IntroPage.builders;
            if (intros.isNotEmpty) {
              return _IntroPage(intros);
            }
            return const HomePage();
          },
        ),
      ),
    );
  }}

class LeftNavigationPanel extends ConsumerWidget {
  final bool isMobileLayout;
  final bool isCollapsed; // Only relevant for desktop

  LeftNavigationPanel({
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
                    Icons.interests_rounded,
                  ), // Use a relevant icon
                  onPressed: () {
                    // Maybe expand sidebar on icon click?
                    ref.read(sidebarCollapsedProvider.notifier).state = false;
                  },
                  color: Colors.grey[300],
                )
              : Row(
                  // Logo/Title and potentially a collapse button when expanded
                  children: [
                    Icon(
                      Icons.interests_rounded,
                      color: Colors.blue[300],
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      '',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    // Show collapse button only when expanded on desktop
                    if (!isCollapsed && !isMobileLayout)
                      IconButton(
                        icon: const Icon(Icons.chevron_left, size: 20),
                        onPressed: () =>
                            ref.read(sidebarCollapsedProvider.notifier).state =
                                true,
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
                  onPressed: () {},
                  color: Colors.grey[300],
                )
              : ElevatedButton.icon(
                  icon: const Icon(Icons.add, size: 20),
                  label: const Text(''),
                  onPressed: () {
                    if (isMobileLayout) Navigator.pop(context); // Close drawer
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 40), // Full width
                    // Use theme colors or define explicitly
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.primaryContainer,
                    foregroundColor: Theme.of(
                      context,
                    ).colorScheme.onPrimaryContainer,
                    alignment: Alignment.centerLeft, // Align icon/text left
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
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
                icon: Icons.tornado_rounded,
                title: 'Jackett Search',
                showText: showText,
                onTap: () =>
                    _navigateTo(context, JackettHome(), isMobileLayout),
              ),

              _buildNavigationItem(
                context,
                ref,
                icon: Icons.tv,
                title: 'IPTV Player',
                showText: showText,
                onTap: () => _navigateTo(context, IptvScreen(), isMobileLayout),
              ),

              _buildNavigationItem(
                context,
                ref,
                icon: Icons.assistant,
                title: 'AI Browser OpenAI',
                showText: showText,
                onTap: () =>
                    _navigateTo(context, AiBrowserApp(), isMobileLayout),
              ),

              _buildNavigationItem(
                context,
                ref,
                icon: Icons.assistant,
                title: 'AI Studio ',
                showText: showText,
                onTap: () => _navigateTo(context, ChatPage(), isMobileLayout),
              ),
              _buildNavigationItem(
                context,
                ref,
                icon: Icons.assistant,
                title: 'AI Studio2 ',
                showText: showText,
                onTap: () async {

                   UserApi.init();

  final sets = Stores.setting;
  final windowStateProp = sets.windowState;
  final windowState = windowStateProp.fetch();
  await SystemUIs.initDesktopWindow(
    hideTitleBar: sets.hideTitleBar.get(),
    size: windowState?.size,
    position: windowState?.position,
    listener: WindowStateListener(windowStateProp),
  );

  Cfg.applyClient();
  Cfg.updateModels();

  //  BakSync.instance.init();
  //  BakSync.instance.sync();

  //if (Stores.setting.joinBeta.get()) AppUpdate.chan = AppUpdateChan.beta;

  Stores.trash.autoDelete();
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (_) => const LeftNavigationPanel1()));
                },
              ),
              _buildNavigationItem(
                context,
                ref,
                icon: Icons.play_lesson_rounded,
                title: 'Yt-dlp',
                showText: showText,
                onTap: () =>
                    _navigateTo(context, YTDLPHomeScreen(), isMobileLayout),
              ),
              _buildNavigationItem(
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
              _buildNavigationItem(
                context,
                ref,
                icon: Icons.live_tv_rounded,
                title: 'TV Series',
                showText: showText,
                onTap: () => _navigateTo(
                  context,
                  const AnimeGridScreen(typec: "tvseries"),
                  isMobileLayout,
                ),
              ),
              _buildNavigationItem(
                context,
                ref,
                icon: Icons.movie_outlined,
                title: 'Anime',
                showText: showText,

                onTap: () => _navigateTo(
                  context,
                  const AnimeGridScreen(typec: "anime"),
                  isMobileLayout,
                ),
              ),
              _buildNavigationItem(
                context,
                ref,
                icon: Icons.category_outlined,
                title: 'Genres',
                showText: showText,
                onTap: () => _navigateTo(
                  context,
                  const GenreListScreen(),
                  isMobileLayout,
                ),
              ),
              const Divider(color: AppColors.dividerColor, height: 1),

              _buildNavigationItem(
                context,
                ref,
                icon: Icons.watch_later_outlined,
                title: 'Watchlist',
                showText: showText,
                onTap: () => _navigateTo(
                  context,
                  const WatchlistScreen(),
                  isMobileLayout,
                ),
              ),
              _buildNavigationItem(
                context,
                ref,
                icon: Icons.favorite_border_sharp,
                title: 'Favorites',
                showText: showText,
                onTap: () => _navigateTo(
                  context,
                  const FavoritesScreen(),
                  isMobileLayout,
                ),
              ),

              _buildNavigationItem(
                context,
                ref,
                icon: Icons.spoke_outlined,
                title: 'Crawler Tools',
                showText: showText,
                onTap: () => _navigateTo(
                  context,
                  const CrawlerHomePage4(),
                  isMobileLayout,
                ),
              ),
              const Divider(color: AppColors.dividerColor, height: 1),
              const Padding(padding: EdgeInsets.fromLTRB(16, 12, 16, 8)),
              if (showText) _buildSectionHeader('Subscriptions'),
              _buildNavigationItem(
                context,
                ref,
                icon: Icons.movie_outlined,
                title: 'Popular Movie',
                showText: showText,
                onTap: () =>
                    _navigateTo(context, const MoviePage1(), isMobileLayout),
              ),

              _buildNavigationItem(
                context,
                ref,
                icon: Icons.tv_rounded,
                title: 'Popular TV Shows',
                showText: showText,
                onTap: () =>
                    _navigateTo(context, const TvSearchPage(), isMobileLayout),
              ),

              _buildNavigationItem(
                context,
                ref,
                icon: Icons.search,
                title: 'Search movies',
                showText: showText,
                onTap: () => _navigateTo(
                  context,
                  const MovieSearchPage(),
                  isMobileLayout,
                ),
              ),

              _buildNavigationItem(
                context,
                ref,
                icon: Icons.text_fields,
                title: 'Search keywords',
                showText: showText,
                onTap: () => _navigateTo(
                  context,
                  const KeywordSearchPage(),
                  isMobileLayout,
                ),
              ),

              // _buildNavigationItem(
              //  context,
              //  ref,
              //  icon: Icons.file_copy,
              //  title: 'File Browser',
              //  showText: showText,
              //  onTap: () => _navigateTo(context, const LocalScreen(), isMobileLayout),
              // ),
              _buildNavigationItem(
                context,
                ref,
                icon: Icons.dangerous,
                title: 'Fullscreen',
                showText: showText,
                onTap: () =>
                    _navigateTo(context, const GridWall(), isMobileLayout),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // New helper methods
  void _navigateTo(BuildContext context, Widget screen, bool isMobileLayout) {
    tVClick();
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
                Text(
                  title,
                  style: TextStyle(color: Colors.grey[300], fontSize: 14),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
