import 'package:flutter/material.dart';

class ComponentLibraryDrawer extends StatelessWidget {
  const ComponentLibraryDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth <= 600;

    // Responsive drawer width
    final drawerWidth =
        isMobile ? screenWidth * 0.75 : (screenWidth <= 800 ? 280.0 : 320.0);

    return SizedBox(
      width: drawerWidth,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.library_books,
                    size: isMobile ? 32 : 40,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  SizedBox(height: isMobile ? 8 : 12),
                  Text(
                    "Component Library",
                    style: TextStyle(
                      fontSize: isMobile ? 16 : 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.widgets),
              title: Text(
                "Item 1",
                style: TextStyle(fontSize: isMobile ? 14 : 16),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: isMobile ? 12 : 16,
                vertical: isMobile ? 2 : 4,
              ),
            ),
            // ... more items
          ],
        ),
      ),
    );
  }
}

class ComponentBrowserDrawer extends StatelessWidget {
  const ComponentBrowserDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth <= 600;

    // Responsive drawer width
    final drawerWidth =
        isMobile ? screenWidth * 0.75 : (screenWidth <= 800 ? 280.0 : 320.0);

    return SizedBox(
      width: drawerWidth,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryContainer,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.explore,
                    size: isMobile ? 32 : 40,
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
                  SizedBox(height: isMobile ? 8 : 12),
                  Text(
                    "Component Browser",
                    style: TextStyle(
                      fontSize: isMobile ? 16 : 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.category),
              title: Text(
                "Item A",
                style: TextStyle(fontSize: isMobile ? 14 : 16),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: isMobile ? 12 : 16,
                vertical: isMobile ? 2 : 4,
              ),
            ),
            // ... more items
          ],
        ),
      ),
    );
  }
}
