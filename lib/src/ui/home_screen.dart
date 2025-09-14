// // File: lib/src/ui/home_screen.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:responsive_framework/responsive_framework.dart';
// import 'package:miko/src/ui/dashboard_screen.dart';
// import 'package:miko/src/ui/release_calendar_screen.dart';
// import 'package:miko/src/ui/my_list_screen.dart';
// import 'package:miko/src/ui/download_screen.dart';
// import 'package:miko/src/ui/profile_screen.dart';

// class HomeScreen extends ConsumerStatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   ConsumerState<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends ConsumerState<HomeScreen> {
//   int _selectedIndex = 0;

//   static  final List<Widget> _mobileScreens = <Widget>[
//     DashboardScreen(),
//     ReleaseCalendarScreen(),
//    // CollectionsPage(),
//     DownloadScreen(),
//     ProfileScreen(),
//   ];

//   void _onItemTapped(int index) => setState(() => _selectedIndex = index);

//   Widget _buildNavigation(BuildContext context) {
//     final isDesktop = ResponsiveBreakpoints.of(context).isDesktop || ResponsiveBreakpoints.of(context).largerThan(TABLET);
//     if (isDesktop) {
//       return NavigationRail(
//         selectedIndex: _selectedIndex,
//         onDestinationSelected: _onItemTapped,
//         extended: ResponsiveBreakpoints.of(context).largerThan(DESKTOP),
//         labelType: NavigationRailLabelType.none,
//         destinations: const [
//           NavigationRailDestination(icon: Icon(Icons.home_filled), label: Text('Home')),
//           NavigationRailDestination(icon: Icon(Icons.calendar_month), label: Text('Release Cal.')),
//           NavigationRailDestination(icon: Icon(Icons.bookmark_border), label: Text('My List')),
//           NavigationRailDestination(icon: Icon(Icons.download_rounded), label: Text('Download')),
//           NavigationRailDestination(icon: Icon(Icons.person_outline), label: Text('Profile')),
//         ],
//       );
//     } else {
//       return const SizedBox.shrink();
//     }
//   }

//   Widget _buildBody(BuildContext context) {
//     final isDesktopLayout = ResponsiveBreakpoints.of(context).isDesktop || ResponsiveBreakpoints.of(context).largerThan(TABLET);
//     if (isDesktopLayout) {
//       return Row(
//         children: [
//           _buildNavigation(context),
//           const VerticalDivider(width: 1),
//           Expanded(child: IndexedStack(index: _selectedIndex, children: _mobileScreens)),
//         ],
//       );
//     } else {
//       return IndexedStack(index: _selectedIndex, children: _mobileScreens);
//     }
//   }

//   BottomNavigationBar _buildBottomNav() {
//     return BottomNavigationBar(
//       type: BottomNavigationBarType.fixed, // Ensure icons are visible
//       currentIndex: _selectedIndex,
//       onTap: _onItemTapped,
//       items: const [
//         BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
//         BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: 'Release Cal.'),
//    //     BottomNavigationBarItem(icon: Icon(Icons.bookmark_border), label: 'My List'),
//         BottomNavigationBarItem(icon: Icon(Icons.download_rounded), label: 'Download'),
//         BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Note: The app bar is removed here and integrated into individual screens (DashboardScreen has a custom header).
//     // This allows for more flexible UI as seen in the design images.
//     final isMobile = ResponsiveBreakpoints.of(context).isMobile || ResponsiveBreakpoints.of(context).smallerThan(TABLET);
//     return Scaffold(
//       appBar: AppBar(
//         toolbarHeight: 0, // Effectively hides the AppBar
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//       ),
//       body: _buildBody(context),
//       bottomNavigationBar: isMobile ? _buildBottomNav() : null,
//     );
//   }
// }