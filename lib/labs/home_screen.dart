// home_screen.dart
import '_app_bar.dart';
import 'package:flutter/material.dart';

import '../app_keeper.dart';
import '../chatview/ai_chat_client.dart';
import '../code_editor/code_editor_ide.dart';
import '../screens/anime_grid_screen.dart';
import '../screens/http_main.dart';
import '../screens/local_screen.dart';
import '../screens/watchlist_screen.dart';
part '_main_content.dart';
part '_common_widgets.dart';
part '_form_panels.dart';
part '_plot_placeholders.dart';
part '_axes_input_page.dart';
part '_left_drawer.dart';
part '_right_drawer.dart';
class HomeScreenLab extends StatefulWidget {
  const HomeScreenLab({super.key});

  @override
  State<HomeScreenLab> createState() => _HomeScreenLabState();
}

class _HomeScreenLabState extends State<HomeScreenLab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController thermalScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
      appBar: buildCustomAppBar(
        context,
        _tabController,
      ), // MODIFIED: Pass _tabController
      drawer: const ComponentLibraryDrawer(),
      endDrawer: const ComponentBrowserDrawer(),
      body: _buildMainContentArea(context, _tabController),
     ) );
  }
}

