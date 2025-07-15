import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:miko/providers/local_provider.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pro_image_editor/pro_image_editor.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';
import 'package:file_picker/file_picker.dart';
import 'package:uuid/uuid.dart';

Uuid uuid = Uuid();

class Photoeditor extends StatelessWidget {
  final File imageFile;
  final String? currentFolderPath;

  const Photoeditor(this.imageFile, this.currentFolderPath, {super.key});

  @override
  Widget build(BuildContext context) {
    return buildPhotoeditor(context, imageFile, currentFolderPath);
  }

  Widget buildPhotoeditor(
      BuildContext context, File imageFile, String? currentFolderPath) {
    final provider = Provider.of<LocalProvider>(context, listen: false);

    return ProImageEditor.file(
      imageFile,
      callbacks: ProImageEditorCallbacks(
        onImageEditingComplete: (Uint8List bytes) async {
          try {
            // Get the temporary directory
            final tempDirectory = await getTemporaryDirectory();

            // Define the path where the image will be saved temporarily
            final tempFilePath = '${tempDirectory.path}/${uuid.v4()}.jpg';

            // Create a file and write the bytes to it
            final file = File(tempFilePath);
            await file.writeAsBytes(bytes);

            print('Image saved in temporary directory at: $tempFilePath');

            // Call the copyFile method for saving the image
            copyFile(file, provider, context);
          } catch (e) {
            print('Error saving image: $e');
          }
        },
        mainEditorCallbacks: MainEditorCallbacks(
          helperLines: HelperLinesCallbacks(onLineHit: () {
            if (Platform.isAndroid) {
              Vibration.vibrate(duration: 3);
            }
          }),
        ),
      ),
    );
  }

  // Move copyFile function outside the onImageEditingComplete callback
  Future<void> copyFile(
      File file, LocalProvider provider, BuildContext context) async {
    final String? destinationPath = await showPathSelectionDialog(
      imageFile,
      context,
      'Save "${p.basename(file.path)}" to',
      currentFolderPath
          .toString(), // Suggest current folder as initial destination
    );

    if (destinationPath != null) {
      final newFilePath = p.join(destinationPath);

      // Check if file exists at destination
      if (await File(newFilePath).exists()) {
        final overwriteConfirmed = await showConfirmationDialog(
          context,
          'File Exists',
          'A file with the same name already exists in the destination. Overwrite?',
        );
        if (overwriteConfirmed != true) {
          showSnackBar(context, 'Save cancelled: File already exists.');
          return;
        }

        await File(newFilePath).delete(); // Delete existing file before copying
      }

      final bool success = await provider.copyFile(file.path, newFilePath);
      if (success) {
        showSnackBar(context, 'File Saved successfully.');
      } else {
        showSnackBar(context, 'Failed to Save file.');
      }
    }
  }

  // Show a dialog to select the destination folder
  Future<String?> showPathSelectionDialog(
      File imageFile, context, String title, String initialPath) async {
    final TextEditingController controller =
        TextEditingController(text: initialPath);
    final String filename = ('Edited_${(p.basename(imageFile.path))}');
    final TextEditingController controllerName =
        TextEditingController(text: filename);
    return showDialog<String>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateInDialog) {
            return AlertDialog(
              title: Text(title),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      labelText: 'Destination Path',
                    ),
                    readOnly: true,
                  ),
                                    TextField(
                    controller: controllerName,
                    decoration: const InputDecoration(
                      labelText: 'New File Name',
                    ),
                    readOnly: false,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.folder_open),
                    label: const Text('Browse'),
                    onPressed: () async {
                      final selectedDirectory =
                          await FilePicker.platform.getDirectoryPath();
                      if (selectedDirectory != null) {
                        setStateInDialog(() {
                          controller.text = selectedDirectory;
                        });
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (await Directory(controller.text).exists()) {
                      Navigator.of(context).pop('${controller.text}/${controllerName.text}');
                    } else {
                      showSnackBar(context, 'Invalid or non-existent path.');
                    }
                  },
                  child: const Text('Select'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Show a confirmation dialog for overwriting files
  Future<bool> showConfirmationDialog(
      context, String title, String message) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(title),
              content: Text(message),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Yes'),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  // Show a snack bar with a message
  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
