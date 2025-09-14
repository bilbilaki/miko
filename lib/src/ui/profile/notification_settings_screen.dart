// File: lib/src/ui/profile/notification_settings_screen.dart
import 'package:flutter/material.dart';
import 'package:miko/src/ui/widgets/option_switch_tile.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool _generalNotifications = true;
  bool _newArrival = false;
  bool _newServicesAvailable = false;
  bool _newReleasesMovie = true;
  bool _appUpdates = true;
  bool _subscription = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0F10),
      appBar: AppBar(
        title: const Text('Notification'),
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
            title: 'General Notification',
            value: _generalNotifications,
            onChanged: (value) => setState(() => _generalNotifications = value),
          ),
          OptionSwitchTile(
            title: 'New Arrival',
            value: _newArrival,
            onChanged: (value) => setState(() => _newArrival = value),
          ),
          OptionSwitchTile(
            title: 'New Services Available',
            value: _newServicesAvailable,
            onChanged: (value) => setState(() => _newServicesAvailable = value),
          ),
          OptionSwitchTile(
            title: 'New Releases Movie',
            value: _newReleasesMovie,
            onChanged: (value) => setState(() => _newReleasesMovie = value),
          ),
          OptionSwitchTile(
            title: 'App Updates',
            value: _appUpdates,
            onChanged: (value) => setState(() => _appUpdates = value),
          ),
          OptionSwitchTile(
            title: 'Subscription',
            value: _subscription,
            onChanged: (value) => setState(() => _subscription = value),
          ),
        ],
      ),
    );
  }
}