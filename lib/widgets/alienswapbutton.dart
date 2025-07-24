import 'package:flutter/material.dart';
import 'package:miko/utils/utils.dart';

class AlienFloatSwapMenu extends StatefulWidget {
  final Function OnAskAi;
  final Function onFilter;
  final Function search;
 // final Function searchOnline;
  // final Function onNew;   // New function for 'New' button
  // final Function onUndo;  // New function for 'Undo' button
  // final Function onRedo;  // New function for 'Redo' button

  const AlienFloatSwapMenu({
    super.key,
    required this.OnAskAi,
    required this.onFilter,
    required this.search,
   // required this.searchOnline,
    // required this.onNew,   // Must be provided
    // required this.onUndo,  // Must be provided
    // required this.onRedo,  // Must be provided
  });

  @override
  State<AlienFloatSwapMenu> createState() => _AlienFloatSwapMenuState();
}

class _AlienFloatSwapMenuState extends State<AlienFloatSwapMenu> {
  Offset centerOffset = Offset.zero;
  bool dragging = false;

  // Added new positions for 'New', 'Undo', and 'Redo' buttons
  final Map<String, Offset> actions = {
    "Ask AI": Offset(-50, -180),
    "Search": Offset(-140, -110),
    "Filter": Offset(-150, 0),
   // "SearchOnline": Offset(-250, 10),
    // "New": Offset(100, -150),   // Top-right quadrant
    // "Undo": Offset(-100, 150),  // Bottom-left quadrant
    // "Redo": Offset(150, 100),   // Bottom-right quadrant
  };

  // Added visibility states for the new buttons
  final Map<String, bool> visibility = {
    "Ask AI": false,
    "Search": false,
    "Filter": false,
   // "SearchOnline": false,
    // "New": false,
    // "Undo": false,
    // "Redo": false,
  };

  final double targetRadius = 80;

  // Extended the handleAction method to include the new buttons
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
      // case "SearchOnline":
      //   widget.searchOnline();
      //   break;
      // case "New":
      //   widget.onNew();
      //   break;
      // case "Undo":
      //   widget.onUndo();
      //   break;
      // case "Redo":
      //   widget.onRedo();
      //   break;
    }
  }
  // Helper method to get an icon based on action name
 
  String? getOverlappingAction() {
    for (var entry in actions.entries) {
      if ((centerOffset - entry.value).distance <= targetRadius) {
        return entry.key;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final centerStart =
        Offset(screenSize.width / 1.15, screenSize.height / 1.24);
    final position = centerStart + centerOffset;
    return GestureDetector(
        // Added GestureDetector for general touch/drag vibration
        onTapDown: (_) => triggerVibration(), // Vibrate on touch/tap down
        onPanDown: (_) => triggerVibration(),
        onTap: () => tVClick(),
        onSecondaryTap: () => tVmedium(),
        onSecondaryTapDown: (_) => tVmedium(),
        onSecondaryLongPress: () => tVheavy(),
        child: Stack(
          children: [
            ...actions.entries.map((entry) {
              final textPosition = centerStart + entry.value;
              final isVisible =
                  (centerOffset - entry.value).distance < targetRadius;

              return AnimatedPositioned(
                duration: const Duration(milliseconds: 100),
                left: textPosition.dx - 50,
                top: textPosition.dy - 20,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 150),
                  opacity: isVisible ? 1 : 0,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 76, 2, 78),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child:
                        Text(entry.key, style: const TextStyle(fontSize: 18)),
                  ),
                ),
              );
            }),
            Positioned(
              left: position.dx - 30,
              top: position.dy - 30,
              child: GestureDetector(
                onPanStart: (_) {
                  triggerVibration();
                  setState(() => dragging = true);
                },
                onPanUpdate: (details) { 
                                    triggerVibration();

                  setState(() {
                  centerOffset += details.delta;
                });},
                onPanEnd: (_) {
                  tVClick();
                  final action = getOverlappingAction();
                  if (action != null) handleAction(action);

                  setState(() {
                    centerOffset = Offset.zero;
                    dragging = false;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.greenAccent.shade400,
                    shape: BoxShape.circle,
                    boxShadow: dragging
                        ? [
                            BoxShadow(
                              color: Colors.greenAccent.shade100,
                              blurRadius: 30,
                              spreadRadius: 5,
                            )
                          ]
                        : [],
                  ),
                  child: const Center(
                    child:
                        Icon(Icons.bubble_chart, size: 30, color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ));
  }
}