import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miko/src/providers/onboarding_provider.dart';
import 'package:miko/src/ui/onboarding/onboarding_flow.dart';
import 'package:miko/utils/colors.dart';
import 'package:responsive_framework/responsive_framework.dart';

// Assuming AppThemes is defined here
import 'widgets/center_content_panel.dart';
class StartPage extends ConsumerWidget {
  const StartPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingAsync = ref.watch(onboardingStatusProvider);
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
      home: onboardingAsync.when(
        data: (seen) {
          if (seen) {
            return  CenterContentPanel(isMobileLayout: true,);
          } else {
            return OnboardingFlow(onComplete: () {
              // after onboarding complete navigate to Home
              // navigator push replacement to avoid back to onboarding
              Navigator.of(navigationKey.currentContext!).pushReplacement(MaterialPageRoute(builder: (_) =>  CenterContentPanel(isMobileLayout: true,)));
            });
          }
        },
        loading: () =>  Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (_, __) => Scaffold(body: Center(child: CircularProgressIndicator())),
      ),
      navigatorKey: navigationKey,
    );
  }
}

final GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();