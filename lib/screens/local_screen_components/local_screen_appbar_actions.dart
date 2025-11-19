import 'package:flutter/material.dart';
import '../local_screen_components/local_screen_models.dart';

class LocalScreenAppBarActions {
  /// Build all AppBar action widgets
  static List<Widget> buildActions({
    required BuildContext context,
    required ViewMode viewMode,
    required SortMode sortMode,
    required bool sortAscending,
    required Function() onToggleView,
    required Function() onShowSizeSlider,
    required Function(SortMode) onSortSelected,
    required Function() onChangeFolder,
    required Function() onRefresh,
    required Function() onBatchRename,
    required Function() onClearCache,
  }) {
    return [
      // View Mode Toggle
      IconButton(
        icon: Icon(
          viewMode == ViewMode.grid ? Icons.view_list : Icons.grid_view,
        ),
        tooltip: "Toggle View",
        onPressed: onToggleView,
      ),
      
      // Size Adjustment Button (only shown in grid view)
      if (viewMode == ViewMode.grid)
        IconButton(
          icon: const Icon(Icons.view_quilt_outlined),
          tooltip: "Adjust Size",
          onPressed: onShowSizeSlider,
        ),
      
      // Sorting Menu
      PopupMenuButton<SortMode>(
        icon: const Icon(Icons.sort),
        tooltip: "Sort by",
        onSelected: onSortSelected,
        itemBuilder: (context) => const [
          PopupMenuItem(
            value: SortMode.type,
            child: Text("Sort by Type"),
          ),
          PopupMenuItem(
            value: SortMode.name,
            child: Text("Sort by Name"),
          ),
          PopupMenuItem(
            value: SortMode.date,
            child: Text("Sort by Date"),
          ),
        ],
      ),
      
      // Change Root Folder Button
      IconButton(
        icon: const Icon(Icons.folder_open),
        tooltip: "Change Base Folder",
        onPressed: onChangeFolder,
      ),
      
      // Refresh Current View Button
      IconButton(
        icon: const Icon(Icons.refresh),
        tooltip: "Refresh",
        onPressed: onRefresh,
      ),
      
      // Batch Rename Button
      IconButton(
        icon: const Icon(Icons.drive_file_rename_outline),
        tooltip: "Batch Rename Files in Current Directory",
        onPressed: onBatchRename,
      ),
      
      // Thumbnail Cache Clear Button
      IconButton(
        icon: const Icon(Icons.delete_sweep),
        tooltip: "Clear All Thumbnail Cache",
        onPressed: onClearCache,
      ),
    ];
  }
}
