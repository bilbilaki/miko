import 'package:flutter/material.dart';
import 'package:miko/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For HapticFeedback

class AlienFloatSwapMenu extends StatefulWidget {
  final Function OnAskAi;
  final Function onFilter;
  final Function search;

  const AlienFloatSwapMenu({
    super.key,
    required this.OnAskAi,
    required this.onFilter,
    required this.search,
  });

  @override
  State<AlienFloatSwapMenu> createState() => _AlienFloatSwapMenuState();
}

class _AlienFloatSwapMenuState extends State<AlienFloatSwapMenu> {
  Offset centerOffset = Offset.zero;
  bool dragging = false;
  String? _hoveredAction; // Tracks the action currently being hovered over by the main button

  // Refined 'actions' map to include icons for better UI
  final Map<String, ({Offset offset, IconData icon})> actions = {
    "Ask AI": (offset: Offset(-50, -180), icon: Icons.psychology_alt),
    "Search": (offset: Offset(-140, -110), icon: Icons.search),
    "Filter": (offset: Offset(-150, 0), icon: Icons.filter_list),
  };

  final double targetRadius = 90; // The radius within which an action becomes 'visible' and 'active'

  void handleAction(String action) {
    switch (action) {
      case "Ask AI":
        widget.OnAskAi();
        break;
      case "Search":
        widget.search();
        break;
      case "Filter":
        widget.onFilter();
        break;
    }
  }

  // Determines which action, if any, the main button is currently overlapping
  String? getOverlappingAction() {
    for (var entry in actions.entries) {
      if ((centerOffset - entry.value.offset).distance <= targetRadius) {
        return entry.key;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    // Calculate the initial center anchor position for the menu
    final centerAnchor = Offset(screenSize.width / 1.15, screenSize.height / 1.24);
    // Calculate the current position of the draggable main button
    final currentButtonPosition = centerAnchor + centerOffset;

    // Schedule a post-frame callback to update the hovered action state,
    // preventing setState calls during the build phase itself.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final newHoveredAction = getOverlappingAction();
      if (_hoveredAction != newHoveredAction) {
        setState(() {
          _hoveredAction = newHoveredAction;
        });
      }
    });

    return GestureDetector(
      // General touch/drag vibration
      onTapDown: (_) => triggerVibration(),
      onPanDown: (_) => triggerVibration(),
      onTap: () => tVClick(),
      onSecondaryTap: () => tVmedium(),
      onSecondaryTapDown: (_) => tVmedium(),
      onSecondaryLongPress: () => tVheavy(),
      child: Stack(
        children: [
          // Render each menu item (Ask AI, Search, Filter)
          ...actions.entries.map((entry) {
            final itemTargetPosition = centerAnchor + entry.value.offset;
            final isVisible = (centerOffset - entry.value.offset).distance < targetRadius;
            final isHovered = _hoveredAction == entry.key;

            return AnimatedPositioned(
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeOutCubic,
              // Adjust position to center the larger menu item container
              left: itemTargetPosition.dx - 60,
              top: itemTargetPosition.dy - 30,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: isVisible ? 1 : 0,
                // Scale animation for menu items
                child: AnimatedScale(
                  scale: isVisible ? (isHovered ? 1.1 : 1.0) : 0.8, // Pop out slightly on hover
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOutBack,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isHovered
                          ? Colors.deepPurple.shade700 // Different color when hovered
                          : const Color.fromARGB(255, 76, 2, 78).withOpacity(0.9),
                      borderRadius: BorderRadius.circular(30), // Pill shape
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(isHovered ? 0.4 : 0.2),
                          blurRadius: isHovered ? 12 : 6,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(
                        color: isHovered ? Colors.greenAccent : Colors.transparent,
                        width: isHovered ? 2 : 0,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(entry.value.icon, color: Colors.white70, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          entry.key,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
          // The main draggable floating action button
          Positioned(
            left: currentButtonPosition.dx - 35, // Adjust for 70px button size
            top: currentButtonPosition.dy - 35, // Adjust for 70px button size
            child: GestureDetector(
              onPanStart: (_) {
                triggerVibration();
                setState(() => dragging = true);
              },
              onPanUpdate: (details) {
                // Vibration on every update can be too much, removed for smoother feel.
                setState(() {
                  centerOffset += details.delta;
                });
              },
              onPanEnd: (_) {
                tVClick(); // Vibrate on release
                final action = getOverlappingAction();
                if (action != null) {
                  tVheavy(); // Vibrate heavily if an action is performed
                  handleAction(action);
                }

                setState(() {
                  centerOffset = Offset.zero; // Snap back to original position
                  dragging = false;
                  _hoveredAction = null; // Clear hovered state
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutBack,
                width: dragging ? 75 : 70, // Slightly expand when dragging
                height: dragging ? 75 : 70, // Slightly expand when dragging
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: dragging
                        ? [Colors.greenAccent.shade400, Colors.tealAccent.shade700] // More vibrant when dragging
                        : [Colors.greenAccent.shade700, Colors.tealAccent.shade400],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: dragging
                      ? [
                          BoxShadow(
                            color: Colors.greenAccent.shade100.withOpacity(0.6),
                            blurRadius: 40,
                            spreadRadius: 10,
                          ),
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                ),
                child: Center(
                  child: Icon(
                    Icons.bubble_chart,
                    size: dragging ? 36 : 32, // Icon size slightly larger when dragging
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}