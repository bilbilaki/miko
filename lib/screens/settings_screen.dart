import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:miko/services/user_data_service.dart';
import 'package:miko/utils/colors.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

final TextEditingController _basePathController = TextEditingController();
final bool _isProcessing = false;
final UserDataService userDataService = UserDataService();
final List<String> _foundUrls = [];
final List<String> _logMessages = [];

// --- Helper Functions ---
void _log(String message) {
  _logMessages.insert(0, message);
}

Future<void> _requestStoragePermission() async {
  if (Platform.isAndroid || Platform.isIOS) {
    if (!await Permission.storage.isGranted) {
      await Permission.storage.request();
    }
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Watch the UserDataService for changes
    final userDataService = context.watch<UserDataService>();
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        appBar: AppBar(
          title: const Text('Settings',
              style: TextStyle(color: AppColors.primaryText)),
          backgroundColor: const Color.fromARGB(255, 70, 58, 98),
        ),
        body: ListView(children: [
          // Appearance (Placeholder for now, could add theme/color pickers)
          ListTile(
            leading: const Icon(Icons.color_lens_outlined,
                color: AppColors.iconColor),
            title: const Text('Appearance',
                style: TextStyle(color: AppColors.primaryText)),
            subtitle: const Text('Theme, colors',
                style: TextStyle(color: AppColors.secondaryText)),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Appearance settings not implemented')));
            },
          ),
          const Divider(color: AppColors.dividerColor),

          // Grid Layout Setting (Example using a Slider)
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Grid Layout',
                    style:
                        TextStyle(color: AppColors.primaryText, fontSize: 16)),
                const Text('Customize grid view for different pages',
                    style: TextStyle(
                        color: AppColors.secondaryText, fontSize: 12)),
                Slider(
                  value: userDataService.gridSize.toDouble() ?? 3.0,
                  min: 1.0,
                  max: 4.0, // Example: 1 to 4 columns
                  divisions: 3, // Creates steps at 1, 2, 3, 4
                  label: userDataService.gridSize.toString(),
                  onChanged: (double value) {
                    // Use read to call the setter without rebuilding the widget tree unnecessarily
                    context
                        .read<UserDataService>()
                        .setGridSize(value.toDouble());
                  },
                  activeColor: AppColors.iconColor,
                  inactiveColor: AppColors.secondaryText,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Columns: ${userDataService.gridSize.round()}',
                    style: const TextStyle(color: AppColors.secondaryText),
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: AppColors.dividerColor),

          // Playback Settings (Example using a Dropdown)
          // ListTile(
          //   leading: const Icon(Icons.play_circle_outline,
          //       color: AppColors.iconColor),
          //   title: const Text('Decoder Preference',
          //       style: TextStyle(color: AppColors.primaryText)),
          //   subtitle: const Text('Select preferred decoder',
          //       style: TextStyle(color: AppColors.secondaryText)),
          //   trailing: DropdownButton<String>(
          //     value: userDataService.decoderPreference,
          //     dropdownColor:
          //         const Color.fromARGB(255, 70, 58, 98), // Match AppBar color
          //     style: const TextStyle(color: AppColors.primaryText),
          //     underline: Container(), // Remove default underline
          //     icon:
          //         const Icon(Icons.arrow_drop_down, color: AppColors.iconColor),
          //     onChanged: (String? newValue) {
          //       if (newValue != null) {
          //         context
          //             .read<UserDataService>()
          //             .setDecoderPreference(newValue);
          //       }
          //     },
          //     items: <String>['HardwareAcceleration', 'SoftwareAcceleration']
          //         .map<DropdownMenuItem<String>>((String value) {
          //       return DropdownMenuItem<String>(
          //         value: value,
          //         child: Text(value
          //             .capitalize()), // Add a helper extension for capitalization
          //       );
          //     }).toList(),
          //   ),
          // ),
          // // Add other playback settings here if needed (e.g., secondary player switch)
          // const Divider(color: AppColors.dividerColor),

          // External Apps Settings (Example using TextFields)
      //    Padding(
        //    padding:
         //       const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          //  child:                   _buildImportOrSetData()),
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       const Text('External Apps',
          //           style:
          //               TextStyle(color: AppColors.primaryText, fontSize: 16)),
          //       const Text('Configure external player and download manager',
          //           style: TextStyle(
          //               color: AppColors.secondaryText, fontSize: 12)),
          //       const SizedBox(height: 8),
          //       TextField(
          //         controller: TextEditingController(
          //             text: userDataService.externalPlayer),
          //         decoration: InputDecoration(
          //           labelText: 'External Player Path/Name',
          //           labelStyle: const TextStyle(color: AppColors.secondaryText),
          //           hintStyle: const TextStyle(color: AppColors.secondaryText),
          //           enabledBorder: OutlineInputBorder(
          //             borderSide:
          //                 const BorderSide(color: AppColors.dividerColor),
          //             borderRadius: BorderRadius.circular(8.0),
          //           ),
          //           focusedBorder: OutlineInputBorder(
          //             borderSide: const BorderSide(color: AppColors.iconColor),
          //             borderRadius: BorderRadius.circular(8.0),
          //           ),
          //           filled: true,
          //           fillColor: const Color.fromARGB(
          //               255, 30, 30, 30), // Darker background
          //         ),
          //         style: const TextStyle(color: AppColors.primaryText),
          //         onChanged: (value) async {
          //           await context
          //               .read<UserDataService>()
          //               .setExternalPlayer(value);
          //         },
          //       ),
          //                       const SizedBox(height: 12),


          //       TextField(
          //         controller: TextEditingController(
          //             text: userDataService.downloadManager),
          //         decoration: InputDecoration(
          //           labelText: 'Download Manager Path/Name',
          //           labelStyle: const TextStyle(color: AppColors.secondaryText),
          //           hintStyle: const TextStyle(color: AppColors.secondaryText),
          //           enabledBorder: OutlineInputBorder(
          //             borderSide:
          //                 const BorderSide(color: AppColors.dividerColor),
          //             borderRadius: BorderRadius.circular(8.0),
          //           ),
          //           focusedBorder: OutlineInputBorder(
          //             borderSide: const BorderSide(color: AppColors.iconColor),
          //             borderRadius: BorderRadius.circular(8.0),
          //           ),
          //           filled: true,
          //           fillColor: const Color.fromARGB(255, 30, 30, 30),
          //         ),
          //         style: const TextStyle(color: AppColors.primaryText),
          //         onChanged: (value) {
          //           context.read<UserDataService>().setDownloadManager(value);
          //         },
          //       ),
          //     ],
          //   ),
          
          // const Divider(color: AppColors.dividerColor),
        
          // Storage (Placeholder)
          ListTile(
            leading:
                const Icon(Icons.storage_outlined, color: AppColors.iconColor),
            title: const Text('Storage',
                style: TextStyle(color: AppColors.primaryText)),
            subtitle: const Text('Manage downloaded data',
                style: TextStyle(color: AppColors.secondaryText)),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Storage settings not implemented')));
            },
          ),
          const Divider(color: AppColors.dividerColor),

          // Clear Data (Existing functionality)
          ListTile(
            leading: const Icon(Icons.delete_sweep_outlined,
                color: Colors.redAccent),
            title: const Text('Clear My Data',
                style: TextStyle(color: Colors.redAccent)),
            subtitle: const Text('Removes favorites and watchlist',
                style: TextStyle(color: AppColors.secondaryText)),
            onTap: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Confirm Clear Data'),
                  content: const Text(
                      'Are you sure you want to remove all your favorites and watchlist items? This cannot be undone.'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel')),
                    TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Clear Data',
                            style: TextStyle(color: Colors.redAccent))),
                  ],
                ),
              );
              if (confirm == true) {
                // ignore: use_build_context_synchronously
                await Provider.of<UserDataService>(context, listen: false)
                    .clearAllUserData();
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('User data cleared')));
              }
            },
          ),
          const Divider(color: AppColors.dividerColor),
          ExpansionTile(
            title: Text(
              'Custom Function Tool API (Advanced)',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            tilePadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
            childrenPadding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 8.0,
            ), // Pad children
            initiallyExpanded: userDataService
                .custoombaseurl.isNotEmpty, // Expand if configured
            children: [
              _buildTextFieldSetting(
                initialValue: userDataService.custoombaseurl,
                label: 'Tool API Name',
                hint: 'e.g., weather_api or stock_quote',
                saveAction: (values) =>
                    userDataService.setCustoombaseurl(values),
              ),
              // About (Existing functionality)
              ListTile(
                leading:
                    const Icon(Icons.info_outline, color: AppColors.iconColor),
                title: const Text('About',
                    style: TextStyle(color: AppColors.primaryText)),
                subtitle: const Text('App version, licenses',
                    style: TextStyle(color: AppColors.secondaryText)),
                onTap: () {
                  // Consider using showAboutDialog for standard licenses
                  showAboutDialog(
                    context: context,
                    applicationName: 'My Media App',
                    applicationVersion: '1.0.0', // Get from pubspec later
                    applicationLegalese: '© Inosuke/Company',
                    // applicationIcon: Image.asset('assets/icon.png', width: 40,), // Your app icon
                  );
                },
              ),
            ],
          )
        ]));
  }
}

// Helper extension to capitalize strings for dropdown items
extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

// Widget _buildImportOrSetData() {
//   return SingleChildScrollView(
//     padding: const EdgeInsets.all(16.0),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         CheckboxListTile(
//           title: const Text(
//               'By Enabling This Button App Used External Data Instead Of Getting RealTime Info From The Movie Database Service.'),
//           value: userDataService.areyouwantfarsi,
//           onChanged:
//               _isProcessing ? null : (v) => userDataService.setAreuwanfarsi(v!),
//           controlAffinity: ListTileControlAffinity.leading,
//           contentPadding: EdgeInsets.zero,
//         ),
//         TextField(
//           controller: _basePathController,
//           decoration: const InputDecoration(
//               labelText: 'If You Want Write Base Path for External Data'),
//           enabled: !_isProcessing,
//         ),
//         const SizedBox(height: 16),
//         Column(
//           children: [
//             const LinearProgressIndicator(),
//             const SizedBox(height: 16),
//             ElevatedButton.icon(
//               icon: const Icon(Icons.playlist_add_check_sharp),
//               label: const Text('Choose Directory Data Exist There'),
//               onPressed: () {
//                 _requestStoragePermission;
//                 _startProcessing("path");
//               },
//               style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
//             ),
//             ElevatedButton.icon(
//               icon: const Icon(Icons.store_mall_directory_outlined),
//               label: const Text('Choose Data Archive File'),
//               onPressed: () {
//                 _requestStoragePermission;
//                 _startProcessing("archive");
//               },
//               style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blueGrey,
//                   padding: const EdgeInsets.symmetric(vertical: 16)),
//             ),
//           ],
//         ),
//         const SizedBox(height: 24),
//         const Text('Logs', style: TextStyle(fontWeight: FontWeight.bold)),
//         const Divider(),
//         Container(
//           height: 200,
//           padding: const EdgeInsets.all(8.0),
//           color: Colors.black.withOpacity(0.2),
//           child: ListView.builder(
//             reverse: true,
//             itemCount: _logMessages.length,
//             itemBuilder: (context, index) => Text(_logMessages[index]),
//           ),
//         ),
//       ],
//     ),
//   );
// }

// void _startProcessing(type) async {
//   if (type == "path") {
//     final dir = await FilePicker.platform.getDirectoryPath();
//     if (dir != null) {
//       // When a new path is set, always reset the view to the root of that new path

//       await userDataService
//           .setCustoombaseurl(dir); // Save and load the new path
//     }
//   } else {
//     // User cancelled path selection when no path was previously set.
//     // Optionally, show a message or keep the app in an empty state.
//     _showSnackBar('No folder selected. Please select a folder to start.');
//   }
//   if (type == "archive") {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['tar', 'tar.xz', 'zip'],
//     );

//     if (result == null || result.files.single.path == null) {
//       _log("... Task cancelled. No input file selected.");
//       return;
//     }
//     final inputPath = result.files.single.path!;
//     _log("... Selected input file: $inputPath");

//     // 2. Read and process the CSV
//     final archFile = File(inputPath);
//     final targetPath = await getApplicationSupportDirectory();
//     final newExterFileDir = Directory("$targetPath/externaldata");

//     try {
//       await ZipFile.extractToDirectory(
//           zipFile: archFile,
//           destinationDir: newExterFileDir,
//           onExtracting: (zipEntry, progress) {
//             _log('progress: ${progress.toStringAsFixed(1)}%');
//             _log('name: ${zipEntry.name}');
//             _log('isDirectory: ${zipEntry.isDirectory}');
//             _log(
//                 'modificationDate: ${zipEntry.modificationDate!.toLocal().toIso8601String()}');
//             _log('uncompressedSize: ${zipEntry.uncompressedSize}');
//             _log('compressedSize: ${zipEntry.compressedSize}');
//             _log('compressionMethod: ${zipEntry.compressionMethod}');
//             _log('crc: ${zipEntry.crc}');
//             return ZipFileOperation.includeItem;
//           });
//     } catch (e) {
//       _log(e.toString());
//     }
//     await userDataService.setCustoombaseurl(newExterFileDir.toString());
//     _log("Data Directoory Successfully Saved at App Settings");
    
//   }
// }

void _showSnackBar(String message) {
  SnackBar(
    content: Text(message),
    duration: const Duration(seconds: 3), // Show for 3 seconds
  );
}

Widget _buildSectionTitle(BuildContext context, String title) {
  return Padding(
    padding: const EdgeInsets.only(
      top: 16.0,
      bottom: 8.0,
    ), // Add spacing around title
    child: Text(title, style: Theme.of(context).textTheme.titleLarge),
  );
}

// Updated Slider Helper
Widget _buildSliderSetting(
  BuildContext context, {
  required String label,
  required double value,
  required double min,
  required double max,
  required int divisions,
  required ValueChanged<double> onChanged,
}) {
  return Column(
    // Use Column for better label placement
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
      ),
      Slider(
        value: value,
        min: min,
        max: max,
        divisions: divisions,
        label: value.toStringAsFixed(2), // Keep label on slider
        onChanged: onChanged,
      ),
    ],
  );
}

// Updated Int Input Helper (Uses FocusNode for saving on focus loss)
Widget _buildIntInputSetting(
  BuildContext context, {
  required String label,
  required int value,
  required ValueChanged<int> onChanged,
  int minValue = 0,
  int? maxValue,
}) {
  return _SettingTextField<int>(
    label: label,
    initialValue: value,
    onSave: onChanged,
    keyboardType: TextInputType.number,
    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    parser: (text) => int.tryParse(text),
    validator: (val) {
      if (val == null) return value; // Revert if parse fails
      int finalVal = val;
      if (finalVal < minValue) finalVal = minValue;
      if (maxValue != null && finalVal > maxValue) finalVal = maxValue;
      return finalVal;
    },
    textAlign: TextAlign.right,
    width: 80,
  );
}

// Updated Text Field Helper (Uses FocusNode for saving on focus loss)
Widget _buildTextFieldSetting({
  required String initialValue,
  String? label, // Label can be optional if using _buildSectionTitle
  String? hint,
  required Function(String) saveAction,
  bool obscureText = false,
  int maxLines = 1,
  int minLines = 1,
  TextInputType keyboardType = TextInputType.text,
}) {
  return _SettingTextField<String>(
    initialValue: initialValue,
    label: label,
    hint: hint,
    onSave: saveAction,
    obscureText: obscureText,
    maxLines: maxLines,
    minLines: minLines,
    keyboardType: keyboardType,
    parser: (text) => text.trim(), // Trim whitespace on save
    validator: (val) =>
        val ?? initialValue, // Revert if parse fails (shouldn't for string)
  );
}

// Updated Dropdown Helper
Widget _buildDropdownSetting<T>({
  required String label,
  required T value,
  required List<T> items,
  required ValueChanged<T?> onSelected,
  String? hintWhenEmpty,
  // Optional: Add a way to get the current value for robust checking
  required T Function() currentValueProvider,
}) {
  bool isEmpty = items.isEmpty;
  // Ensure the currently selected value is actually in the list,
  // otherwise, fallback or show hint more clearly.
  T? selection = isEmpty ? null : (items.contains(value) ? value : null);

  return Padding(
    padding: const EdgeInsets.symmetric(
      vertical: 4.0,
    ), // Consistent vertical padding
    child: DropdownButtonFormField<T>(
      value: selection,
      isExpanded: true, // Make dropdown take available width
      decoration: InputDecoration(
        labelText: label,
        // hintText: isEmpty ? hintWhenEmpty : (selection == null ? "Select..." : null), // Show hint if empty OR current value not in list
        hintText: isEmpty
            ? hintWhenEmpty
            : (selection == null
                ? (items.isNotEmpty
                    ? 'Select a valid model'
                    : 'No models available')
                : null),
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        isDense: true,
        enabled: !isEmpty, // Disable interaction if empty
      ),
      items: isEmpty
          ? [] // No items if the list is empty
          : items
              .map(
                (item) => DropdownMenuItem<T>(
                  value: item,
                  child: Text(
                    item.toString().split('.').last,
                  ), // Attempt to shorten long model names if needed
                ),
              )
              .toList(),
      onChanged: isEmpty
          ? null
          : (T? newValue) {
              // Only call onSelected if the value actually changes
              if (newValue != null && newValue != currentValueProvider()) {
                onSelected(newValue);
              }
            },
    ),
  );
}

// Helper method for reset confirmation
void _showResetConfirmationDialog(
  BuildContext context,
  UserDataService service,
) {
  showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Reset Settings?'),
      content: const Text(
        'This will reset all settings to their default values. Reloading the app may be required for all changes to take effect.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: const Text('Cancel'),
        ),
        TextButton(
          style: TextButton.styleFrom(foregroundColor: Colors.orange),
          onPressed: () => Navigator.of(ctx).pop(true),
          child: const Text('Reset'),
        ),
      ],
    ),
  ).then((confirmed) {
    if (confirmed == true) {
      service.clearAllUserData();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Settings reset to defaults.')),
      );
    }
  });
}

// --- Reusable Stateful Helper Widget for Text Fields ---
// This manages controller and focus node lifecycle and saves on focus loss
class _SettingTextField<T> extends StatefulWidget {
  final T initialValue;
  final String? label;
  final String? hint;
  final Function(T) onSave;
  final bool obscureText;
  final int maxLines;
  final int minLines;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final T? Function(String) parser; // Function to parse text to type T
  final T Function(T?) validator; // Function to validate/clamp parsed value
  final TextAlign textAlign;
  final double? width; // Optional fixed width

  const _SettingTextField({
    super.key,
    required this.initialValue,
    this.label,
    this.hint,
    required this.onSave,
    this.obscureText = false,
    this.maxLines = 1,
    this.minLines = 1,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    required this.parser,
    required this.validator,
    this.textAlign = TextAlign.start,
    this.width,
  });

  @override
  State<_SettingTextField<T>> createState() => _SettingTextFieldState<T>();
}

class _SettingTextFieldState<T> extends State<_SettingTextField<T>> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  late T _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
    _controller = TextEditingController(text: widget.initialValue.toString());
    _focusNode = FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    if (!_focusNode.hasFocus) {
      _saveValue();
    }
  }

  void _saveValue() {
    final parsed = widget.parser(_controller.text);
    final validatedValue = widget.validator(parsed);

    // Only trigger save if the value has actually changed
    if (validatedValue != _currentValue) {
      widget.onSave(validatedValue);
      _currentValue = validatedValue; // Update internal state tracking
      // Update controller text only if validation changed it (e.g., clamping)
      if (_controller.text != validatedValue.toString()) {
        final newText = validatedValue.toString();
        _controller.text = newText;
        // Optionally move cursor to end after programmatic change
        _controller.selection = TextSelection.fromPosition(
          TextPosition(offset: newText.length),
        );
      }
    } else {
      // If validation didn't change the value, but parsing failed or resulted
      // in the same value, ensure the text field reflects the known good state.
      // This handles cases where the user types invalid chars then clicks away.
      if (_controller.text != _currentValue.toString()) {
        _controller.text = _currentValue.toString();
        _controller.selection = TextSelection.fromPosition(
          TextPosition(offset: _controller.text.length),
        );
      }
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _SettingTextField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the initialValue coming from the provider changes externally
    // (e.g., due to reset), update the text field.
    if (widget.initialValue != oldWidget.initialValue &&
        widget.initialValue != _currentValue) {
      _currentValue = widget.initialValue;
      _controller.text = widget.initialValue.toString();
      // Move cursor to end if needed
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget textField = TextFormField(
      controller: _controller,
      focusNode: _focusNode,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        border: const OutlineInputBorder(),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
      ),
      obscureText: widget.obscureText,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatters,
      textAlign: widget.textAlign,
      // Save on submission (e.g., pressing Enter on keyboard)
      onFieldSubmitted: (_) => _saveValue(),
    );

    // Wrap with SizedBox if width is specified
    if (widget.width != null) {
      textField = SizedBox(width: widget.width, child: textField);
    }

    // If label is provided standalone (not part of InputDecoration)
    if (widget.label != null && widget.width != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                widget.label!,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            textField, // SizedBox is now inside the 'textField' variable
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: textField, // Regular text field, label is inside InputDecoration
      );
    }
  }
}
