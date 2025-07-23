import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:miko/widgets/gridcart.dart';

// --- MODIFICATION 1: Converted GridWall to a StatefulWidget ---
class GridWall extends StatefulWidget {
  const GridWall({super.key});

  @override
  State<GridWall> createState() => _GridWallState();
}

class _GridWallState extends State<GridWall> {
  Future<List<Scene>>? _scenesFuture;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _scenesFuture = getBase(context);
        });
      }
    });
  }

  Future<String?> gridMaker(
      BuildContext context, String hint, String title) async {
    final controller = TextEditingController(text: hint);
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(labelText: title),
            ),
            const SizedBox(height: 10),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton( // Added an OK button to submit the dialog
            onPressed: () => Navigator.of(context).pop(controller.text),
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

  Future<List<Scene>> getBase(BuildContext context) async {
    final baseurl = await gridMaker(context, '192.168.0.0:9999', 'Base Url');
    final List<Scene> scenes = [];
    if (baseurl != null && baseurl.isNotEmpty) {
      final howmany = await gridMaker(context, '600', 'how many?');
      if (howmany == null) return scenes; // Exit if user cancels the second dialog
      final howManyInt = int.tryParse(howmany) ?? 1;

      for (int index = 1; index <= howManyInt; index++) {
        String finalbasescreenshot;
        String finalbasepreview;
        String finalbasestream;

        // Simplified URL creation
        String baseUrlWithProtocol = baseurl.startsWith("http") ? baseurl : "http://$baseurl";
        finalbasescreenshot = "$baseUrlWithProtocol/scene/$index/screenshot";
        finalbasepreview = "$baseUrlWithProtocol/scene/$index/preview";
        finalbasestream = "$baseUrlWithProtocol/scene/$index/stream";

        scenes.add(Scene(
            index, finalbasescreenshot, finalbasepreview, finalbasestream));
      }

      return scenes;
    }
    return scenes;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Scene>>(
      // Use the state variable for the future
      future: _scenesFuture,
      builder: (context, snapshot) {
     if (_scenesFuture == null || snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingGrid();
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No scenes found. Try again.'));
        }

        return _buildSceneGrid(snapshot.data!);
      },
    );
  }

  Widget _buildLoadingGrid() {
    return MasonryGridView.count(
    //  padding: const EdgeInsets.all(5.0),
      crossAxisCount: 3,
      mainAxisSpacing: 0.0,
      crossAxisSpacing: 0.0,
      itemCount: 10,
      itemBuilder: (context, index) => Container(
        height: index % 2 == 0 ? 200 : 250,
        color: const Color.fromARGB(255, 0, 0, 0),
      ),
    );
  }
  

    Widget _buildSceneGrid(List<Scene> scenes) {
    return MasonryGridView.count(
   //   padding: const EdgeInsets.all(5.0),
      crossAxisCount: 3,
      mainAxisSpacing: 0.0, // A bit more spacing looks nice
      crossAxisSpacing: 0.0,
      itemCount: scenes.length,
      // --- THE ONLY CHANGE IS HERE ---
      itemBuilder: (context, index) => InteractiveVideoCard(
        scene: scenes[index],
      ),
      // --- END OF CHANGE ---
    );
  }
}

class Scene {
  final int index;
  final String screenshot;
  final String preview;
  final String stream;

  Scene(this.index, this.screenshot, this.preview, this.stream);
}

