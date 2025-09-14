import 'package:flutter/material.dart';
import 'package:miko/utils/colors.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.shifting, // Ensures all labels are visible
      backgroundColor: AppColors.primaryBackground,
      selectedItemColor:  Color.fromARGB(255, 0, 72, 255),
      unselectedItemColor: AppColors.secondaryText,
      currentIndex: currentIndex,
      onTap: onTap,
      selectedFontSize: 12.0,
      unselectedFontSize: 10.0,
      items:  [
        BottomNavigationBarItem(
          icon: Icon(Icons.movie_edit),
          activeIcon: Icon(Icons.camera_roll_sharp),
          label: 'Movies',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.tv),
          activeIcon: Icon(Icons.live_tv),
          label: 'TVSeries',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.movie_outlined),
          activeIcon: Icon(Icons.movie),
          label: 'Anime',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.category_outlined),
          activeIcon: Icon(Icons.category),
          label: 'Genres',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.download_for_offline_outlined),
          activeIcon: Icon(Icons.download_done_outlined),
          label: 'Downloads',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bookmark_add),
          activeIcon: Icon(Icons.bookmark),
          label: 'WatchList',
        ),
      ],
    );
  }
}