import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ThinkingBlock extends StatelessWidget {
  const ThinkingBlock({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset(
            'assets/thinking_animation.json', // Placeholder for a thinking animation
            width: 40,
            height: 40,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.psychology,
                  size: 24, color: Colors.blue); // Fallback icon
            },
          ),
          const SizedBox(width: 12.0),
          const Text(
            'Thinking...',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}