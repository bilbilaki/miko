// TODO Implement this library.
import 'package:flutter/material.dart';

class NoConfigWidget extends StatelessWidget {
  const NoConfigWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.settings_suggest, size: 80, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 20),
          Text(
            'No Jackett Server Configured',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 10),
          const Text(
            'Go to Settings to add a server configuration.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/settings'),
            icon: const Icon(Icons.add),
            label: const Text('Add Configuration'),
          ),
        ],
      ),
    );
  }
}