// TODO Implement this library.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miko/jackett/models/jackett_config.dart';
import 'package:miko/jackett/providers/jackett_providers.dart';
import 'package:miko/jackett/ui/screens/settings_screen.dart';
import 'package:miko/jackett/ui/widgets/no_config_widget.dart';
import 'package:miko/jackett/ui/widgets/responsive_layout.dart';
import 'package:miko/jackett/ui/widgets/search_form.dart';
import 'package:miko/jackett/ui/widgets/search_results_list.dart';

class JackettHome extends ConsumerWidget {
  const JackettHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final configs = ref.watch(jackettConfigsProvider);
    final activeConfigKey = ref.watch(activeConfigKeyProvider);
    final bool hasConfigs = configs.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Jackett Search'),
        actions: [
          if (hasConfigs)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: DropdownButton<dynamic>(
                value: activeConfigKey,
                onChanged: (dynamic key) {
                  ref.read(activeConfigKeyProvider.notifier).state = key;
                  ref.read(searchProvider.notifier).clearSearch();
                },
                underline: const SizedBox.shrink(),
                items: configs.map<DropdownMenuItem<dynamic>>((JackettConfig config) {
                  return DropdownMenuItem<dynamic>(
                    value: config.key,
                    child: Text(config.name),
                  );
                }).toList(),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _navigateTo(context, const SettingsScreen()),
          ),
        ],
      ),
      body: !hasConfigs
          ? const NoConfigWidget()
          : const ResponsiveLayout(
              mobileBody: MobileHomeLayout(),
              desktopBody: DesktopHomeLayout(),
            ),
    );
  }
  void _navigateTo(BuildContext context, Widget screen) {
  //if (isMobileLayout) Navigator.pop(context);
  Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
}
}

class MobileHomeLayout extends StatelessWidget {
  const MobileHomeLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: SearchForm(),
        ),
        SizedBox(height: 8),
        Expanded(child: SearchResultsList()),
      ],
    );
  }
}

class DesktopHomeLayout extends StatelessWidget {
  const DesktopHomeLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 350,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SearchForm(),
          ),
        ),
        const VerticalDivider(width: 1),
        const Expanded(
          child: SearchResultsList(),
        ),
      ],
    );
  }
}