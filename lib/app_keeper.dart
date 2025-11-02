import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miko/providers/god_proovider.dart';
import 'package:miko/utils/colors.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:provider/provider.dart' as p;

// Assuming AppThemes is defined here
import 'widgets/center_content_panel.dart';
class StartPage extends ConsumerWidget {
  const StartPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
        p.Provider.of<MovieProvider>(context, listen: false);
    p.Provider.of<TvSeriesProvider>(context, listen: false);
    p.Provider.of<AnimeProvider>(context, listen: false);

    return MaterialApp(
      theme: AppThemes.netflixDarkTheme,
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: const [
          Breakpoint(start: 0, end: 450, name: MOBILE),
          Breakpoint(start: 451, end: 800, name: TABLET),
          Breakpoint(start: 801, end: 1920, name: DESKTOP),
          Breakpoint(start: 1921, end: double.infinity, name: '4K'),
        ],
      ),
      home: CenterContentPanel(isMobileLayout: true,));
  }
}

final GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();