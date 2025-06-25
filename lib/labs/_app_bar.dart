// _app_bar.dart

// MODIFIED: Added tabController parameter
import 'package:flutter/material.dart';

PreferredSizeWidget buildCustomAppBar(BuildContext context, TabController tabController) {
  return AppBar(
    backgroundColor: Theme.of(context).cardColor,
    elevation: 0,
    titleSpacing: 0,
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Row(
            children: [
              _AppBarButton(icon: Icons.add_box_outlined, label: 'New', onPressed: () {}),
              _AppBarButton(icon: Icons.folder_open_outlined, label: 'Open', onPressed: () {}),
              _AppBarButton(icon: Icons.save_outlined, label: 'Save', onPressed: () {}),
              const SizedBox(width: 16),
              _AppBarButton(icon: Icons.app_settings_alt_outlined, label: 'App Details', onPressed: () {}),
              _AppBarButton(icon: Icons.share_outlined, label: 'Share', onPressed: () {}),
              const Spacer(),
              ElevatedButton.icon(
                icon: const Icon(Icons.play_arrow, size: 18),
                label: const Text('Run'),
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[600],
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
          color: Theme.of(context).cardColor.withOpacity(0.7),
          child: Row(
            children: [
              Icon(Icons.insert_drive_file_outlined, size: 16, color: Colors.grey[400]),
              const SizedBox(width: 8),
              Text(
                'transientConduction.mlapp',
                style: TextStyle(fontSize: 13, color: Colors.grey[400]),
              ),
              const Spacer(),
            ],
          ),
        ),
      ],
    ),
    bottom: TabBar(
      controller: tabController, // MODIFIED: Use passed controller
      tabs: const [
        Tab(text: 'Design View'),
        Tab(text: 'Code View'),
      ],
      indicatorColor: Theme.of(context).primaryColor,
      labelColor: Theme.of(context).primaryColor,
      unselectedLabelColor: Colors.grey[500],
    ),
  );
}

class _AppBarButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _AppBarButton({required this.icon, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      icon: Icon(icon, size: 18, color: Colors.grey[400]),
      label: Text(label, style: TextStyle(color: Colors.grey[300], fontSize: 13)),
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        minimumSize: Size.zero,
      ),
    );
  }
}