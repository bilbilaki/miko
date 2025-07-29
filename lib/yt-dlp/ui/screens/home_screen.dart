// TODO Implement this library.
import 'package:flutter/material.dart';
import 'package:miko/yt-dlp/ui/screens/download_screen.dart';
import 'package:miko/yt-dlp/ui/screens/queue_screen.dart';
import 'package:miko/yt-dlp/ui/screens/settings_screen.dart';

class YTDLPHomeScreen extends StatefulWidget {
  const YTDLPHomeScreen({super.key});

  @override
  State<YTDLPHomeScreen> createState() => _YTDLPHomeScreenState();
}

class _YTDLPHomeScreenState extends State<YTDLPHomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    DownloadScreen(),
    QueueScreen(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 600;
    
    if (isDesktop) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: _onItemTapped,
              labelType: NavigationRailLabelType.all,
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.download_for_offline_outlined),
                  selectedIcon: Icon(Icons.download_for_offline),
                  label: Text('Download'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.queue_outlined),
                  selectedIcon: Icon(Icons.queue),
                  label: Text('Queue'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.settings_outlined),
                  selectedIcon: Icon(Icons.settings),
                  label: Text('Settings'),
                ),
              ],
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(
              child: _widgetOptions.elementAt(_selectedIndex),
            ),
          ],
        ),
      );
    } 
    
    // Mobile Layout
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.download_for_offline),
            label: 'Download',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.queue),
            label: 'Queue',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
