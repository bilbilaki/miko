import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;

class LocalScreenDialogs {
  /// Shows a general input dialog and returns the entered string.
  static Future<String?> showInputDialog(
    BuildContext context,
    String title,
    String message, [
    String? initialValue,
  ]) async {
    final TextEditingController controller = TextEditingController(
      text: initialValue,
    );
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: message),
          autofocus: true,
          onSubmitted: (value) => Navigator.of(context).pop(value),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(controller.text),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Shows a confirmation dialog and returns true if confirmed, false otherwise.
  static Future<bool?> showConfirmationDialog(
    BuildContext context,
    String title,
    String message,
  ) async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  /// Shows a dialog to select a path, optionally with a file picker button.
  static Future<String?> showPathSelectionDialog(
    BuildContext context,
    String title,
    String? initialPath,
  ) async {
    final TextEditingController controller = TextEditingController(
      text: initialPath ?? p.current,
    );

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
                      Navigator.of(context).pop(controller.text);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Invalid or non-existent path. Please select a valid directory.',
                          ),
                        ),
                      );
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

  /// Shows a dialog to adjust the number of columns in grid view.
  static void showSizeSliderDialog(
    BuildContext context,
    double gridCrossAxisCount,
    Function(double) onChanged,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Adjust Item Size"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Columns: ${gridCrossAxisCount.toInt()}"),
                  Slider(
                    value: gridCrossAxisCount,
                    min: 2,
                    max: 8,
                    divisions: 6,
                    label: gridCrossAxisCount.toInt().toString(),
                    onChanged: (newValue) {
                      setDialogState(() {
                        onChanged(newValue);
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Done"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  /// Displays a dialog for batch renaming files in the current directory.
  static Future<void> showBatchRenameDialog(
    BuildContext context,
    Function(String?, String?) onRename,
  ) async {
    final TextEditingController prefixController = TextEditingController();
    final TextEditingController postfixController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Batch Rename Files'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: prefixController,
                decoration: const InputDecoration(
                  labelText: 'Prefix (optional)',
                ),
              ),
              TextField(
                controller: postfixController,
                decoration: const InputDecoration(
                  labelText: 'Postfix (optional)',
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Files will be renamed as: prefix + index + postfix + .extension',
              ),
              const Text('Example: photo_1.jpg, photo_2.jpg'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                onRename(
                  prefixController.text.isEmpty ? null : prefixController.text,
                  postfixController.text.isEmpty ? null : postfixController.text,
                );
              },
              child: const Text('Rename All'),
            ),
          ],
        );
      },
    );
  }
}
