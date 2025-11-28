import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:miko/utils/utils.dart';

// For HapticFeedback

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
    "Ask AI": (offset: Offset(-60, -180), icon: Icons.psychology_alt),
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
    final centerAnchor = Offset(screenSize.width / 1.15, screenSize.height / 1.20);
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
   //   onPanDown: (_) => triggerVibration(),
      onTap: () => tVClick(),
     // onSecondaryTap: () => tVmedium(),
     // onSecondaryTapDown: (_) => tVmedium(),
     // onSecondaryLongPress: () => tVheavy(),
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
              left: itemTargetPosition.dx - (60),
              top: itemTargetPosition.dy - (30),
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
                          : const Color.fromARGB(255, 76, 2, 78).withValues(alpha:0.9),
                      borderRadius: BorderRadius.circular(30), // Pill shape
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha:isHovered ? 0.4 : 0.2),
                          blurRadius: isHovered ? 12 : 6,
                          offset:  Offset(1, 4),
                        ),
                      ],
                      border: Border.all(
                        color: isHovered ? Colors.greenAccent : Colors.transparent,
                        width: isHovered ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(entry.value.icon, color: Colors.white70, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          entry.key,
                          style: TextStyle(
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
          }),
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
                width: dragging ? 60 : 55, // Slightly expand when dragging
                height: dragging ? 60 : 55, // Slightly expand when dragging
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
                            color: Colors.greenAccent.shade100.withValues(alpha:0.6),
                            blurRadius: 40,
                            spreadRadius: 10,
                          ),
                          BoxShadow(
                            color: Colors.black.withValues(alpha:0.4),
                            blurRadius: 15,
                            offset: const Offset(1, 8),
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: Colors.black.withValues(alpha:0.3),
                            blurRadius: 10,
                            offset: const Offset(1, 5),
                          ),
                        ],
                ),
                child: Center(
                  child: Icon(
                    Icons.bubble_chart,
                    size: dragging ? 29 : 25, // Icon size slightly larger when dragging
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

@immutable
class ExpandableFab extends StatefulWidget {
  const ExpandableFab({
    super.key,
    this.initialOpen,
    required this.distance,
    required this.children,
  });

  final bool? initialOpen;
  final double distance;
  final List<Widget> children;

  @override
  State<ExpandableFab> createState() => _ExpandableFabState();
}


class _ExpandableFabState extends State<ExpandableFab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;
  bool _open = false;

  @override
  void initState() {
    super.initState();
    _open = widget.initialOpen ?? false;
    _controller = AnimationController(
      value: _open ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.easeOutQuad,
      parent: _controller,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _open = !_open;
      if (_open) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }


@override
 Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.bottomRight,
        clipBehavior: Clip.none,
        children: [
          _buildTapToCloseFab(),
          ..._buildExpandingActionButtons(),
          _buildTapToOpenFab(),
        ],
      ),);

  }
  List<Widget> _buildExpandingActionButtons() {
    final children = <Widget>[];
    final count = widget.children.length;
    final step = 90.0 / (count - 1);
    for (
      var i = 0, angleInDegrees = 0.0;
      i < count;
      i++, angleInDegrees += step
    ) {
      children.add(
        _ExpandingActionButton(
          directionInDegrees: angleInDegrees,
          maxDistance: widget.distance,
          progress: _expandAnimation,
          child: widget.children[i],
        ),
      );
    }
    return children;
  }
  
  Widget _buildTapToCloseFab() {
    return SizedBox(
      width: 56,
      height: 56,
      child: Center(
        child: Material(
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          elevation: 4,
          child: InkWell(
            onTap: _toggle,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Icon(Icons.close, color: Theme.of(context).primaryColor),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTapToOpenFab() {
    return IgnorePointer(
      ignoring: _open,
      child: AnimatedContainer(
        transformAlignment: Alignment.center,
        transform: Matrix4.diagonal3Values(
          _open ? 0.7 : 1.0,
          _open ? 0.7 : 1.0,
          1.0,
        ),
        duration: const Duration(milliseconds: 250),
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
        child: AnimatedOpacity(
          opacity: _open ? 0.0 : 1.0,
          curve: const Interval(0.25, 1.0, curve: Curves.easeInOut),
          duration: const Duration(milliseconds: 250),
          child: FloatingActionButton(
            onPressed: _toggle,
            child: const Icon(Icons.auto_awesome),
          ),
        ),
      ),
    );
  }
}

@immutable
class ActionButton extends StatelessWidget {
  const ActionButton({super.key, this.onPressed, required this.icon});

  final VoidCallback? onPressed;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      color: theme.colorScheme.secondary,
      elevation: 4,
      child: IconButton(
        onPressed: onPressed,
        icon: icon,
        color: theme.colorScheme.onSecondary,
      ),
    );
  }
}

@immutable
class _ExpandingActionButton extends StatelessWidget {
  const _ExpandingActionButton({
    required this.directionInDegrees,
    required this.maxDistance,
    required this.progress,
    required this.child,
  });

  final double directionInDegrees;
  final double maxDistance;
  final Animation<double> progress;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (context, child) {
        final offset = Offset.fromDirection(
          directionInDegrees * (math.pi / 180.0),
          progress.value * maxDistance,
        );
        return Positioned(
          right: 3.0 + offset.dx,
          bottom: 3.0 + offset.dy,
          child: Transform.rotate(
            angle: (1.0 - progress.value) * math.pi / 2,
            child: child!,
          ),
        );
      },
      child: FadeTransition(opacity: progress, child: child),
    );
  }
}