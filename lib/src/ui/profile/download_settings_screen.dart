// File: lib/src/ui/profile/download_settings_screen.dart
import 'package:flutter/material.dart';
import 'package:miko/src/ui/widgets/option_switch_tile.dart';
import 'package:miko/src/ui/widgets/profile_menu_item.dart';

class DownloadSettingsScreen extends StatefulWidget {
  const DownloadSettingsScreen({super.key});

  @override
  State<DownloadSettingsScreen> createState() => _DownloadSettingsScreenState();
}

class _DownloadSettingsScreenState extends State<DownloadSettingsScreen> {
  bool _wifiOnly = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0F10),
      appBar: AppBar(
        title: const Text('Download'),
        backgroundColor: const Color(0xFF0D0F10),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        children: [
          OptionSwitchTile(
            title: 'Wi-Fi Only',
            value: _wifiOnly,
            onChanged: (value) => setState(() => _wifiOnly = value),
          ),
          ProfileMenuItem(
            icon: Icons.auto_mode, // Placeholder icon
            title: 'Smart Downloads',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Smart Downloads settings')),
              );
            },
          ),
          ProfileMenuItem(
            icon: Icons.videocam,
            title: 'Video Quality',
            subtitle: '720p', // Placeholder for current quality
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Video Quality settings')),
              );
            },
          ),
          ProfileMenuItem(
            icon: Icons.mic,
            title: 'Audio Quality',
            subtitle: 'Stereo', // Placeholder for current quality
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Audio Quality settings')),
              );
            },
          ),
          const Divider(indent: 16, endIndent: 16, color: Colors.white10),
          ProfileMenuItem(
            icon: Icons.delete_outline,
            title: 'Delete All Downloads',
            onTap: () {
              // TODO: Implement confirmation dialog for deleting all downloads
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Delete All Downloads (Not Implemented)')),
              );
            },
          ),
          ProfileMenuItem(
            icon: Icons.delete_sweep_outlined,
            title: 'Delete Cache',
            onTap: () {
              // TODO: Implement confirmation dialog for deleting cache
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Delete Cache (Not Implemented)')),
              );
            },
          ),
        ],
      ),
    );
  }
}