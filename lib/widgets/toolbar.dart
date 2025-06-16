import 'package:flutter/material.dart';

class Toolbar extends StatelessWidget {
  final VoidCallback onRefresh;
  final VoidCallback onClear;
  final VoidCallback onSwap;

  const Toolbar({
    super.key, 
    required this.onRefresh, 
    required this.onClear, 
    required this.onSwap
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Wrap(
        spacing: 8.0,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF373E4E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            onPressed: onRefresh,
            child: Text('Refresh Data'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF373E4E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            onPressed: onClear,
            child: Text('Clear Data'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF373E4E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            onPressed: onSwap,
            child: Text('Swap Left and Top'),
          ),
        ],
      ),
    );
  }
}