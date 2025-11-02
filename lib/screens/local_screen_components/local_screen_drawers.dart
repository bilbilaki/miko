import 'package:flutter/material.dart';

class ComponentLibraryDrawer extends StatelessWidget {
  const ComponentLibraryDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: const [
          DrawerHeader(child: Text("Component Library")),
          ListTile(title: Text("Item 1")),
          // ... more items
        ],
      ),
    );
  }
}

class ComponentBrowserDrawer extends StatelessWidget {
  const ComponentBrowserDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: const [
          DrawerHeader(child: Text("Component Browser")),
          ListTile(title: Text("Item A")),
          // ... more items
        ],
      ),
    );
  }
}
