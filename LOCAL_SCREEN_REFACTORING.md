# Local Screen Refactoring Documentation

## Overview
The `local_screen.dart` file has been refactored from a monolithic 1462-line file into a modular, maintainable structure with 8 focused component files.

## File Structure

### Main File
- **lib/screens/local_screen.dart** (394 lines)
  - Core screen logic and state management
  - Navigation logic (goUp, openFolder)
  - Sorting logic
  - Build methods for grid/list views

### Component Files (in lib/screens/local_screen_components/)

#### 1. local_screen_models.dart (19 lines)
**Purpose:** Core data models and enums
- `ViewMode` enum (grid, list)
- `SortMode` enum (name, date, type)
- `GridItem` class (helper for sorting files and folders)

#### 2. local_screen_drawers.dart (35 lines)
**Purpose:** Side drawer widgets
- `ComponentLibraryDrawer` - Left drawer
- `ComponentBrowserDrawer` - Right drawer

#### 3. local_screen_dialogs.dart (237 lines)
**Purpose:** All dialog UI components
- `showInputDialog()` - Generic text input
- `showConfirmationDialog()` - Yes/No confirmation
- `showPathSelectionDialog()` - Directory picker with browse button
- `showSizeSliderDialog()` - Grid column adjustment
- `showBatchRenameDialog()` - Batch file renaming interface

#### 4. local_screen_item_builders.dart (195 lines)
**Purpose:** Grid and list item widgets
- `buildFolderTile()` - Folder card for grid view
- `buildFileTile()` - File card for grid view
- `buildFolderListItem()` - Folder row for list view
- `buildFileListItem()` - File row for list view
- `buildThumbnailOrIcon()` - Thumbnail generation with fallback icons

#### 5. local_screen_context_menus.dart (153 lines)
**Purpose:** Long-press context menus
- `showFileContextMenu()` - File operations menu (rename, copy, move, delete, edit)
- `showFolderContextMenu()` - Folder operations menu (rename, copy, move, delete, create new)

#### 6. local_screen_file_operations.dart (481 lines)
**Purpose:** File and folder operation handlers
**File Operations:**
- `handleFileTap()` - Open files based on type
- `showImageDialog()` - Image viewer with gallery
- `showDocumentContentDialog()` - Text editor
- `renameFile()` - Single file rename
- `deleteFile()` - Delete with confirmation
- `copyFile()` - Copy with destination picker
- `moveFile()` - Move with destination picker

**Folder Operations:**
- `renameFolder()` - Folder rename
- `deleteFolder()` - Recursive delete with confirmation
- `copyFolder()` - Recursive copy
- `moveFolder()` - Recursive move
- `createNewFolder()` - New folder creation

**Batch Operations:**
- `showBatchRenameDialog()` - Batch rename with prefix/postfix

#### 7. local_screen_appbar_actions.dart (87 lines)
**Purpose:** AppBar action buttons
- `buildActions()` - Generates all AppBar actions
  - View mode toggle (grid/list)
  - Size adjustment (grid columns)
  - Sort menu (type/name/date)
  - Change base folder
  - Refresh
  - Batch rename
  - Clear thumbnail cache

#### 8. local_screen_components.dart (7 exports)
**Purpose:** Barrel file for easier imports
- Exports all component files in one place

## Benefits of Refactoring

### 1. **Maintainability**
- Each file has a single, clear responsibility
- Easier to locate and fix bugs
- Reduced cognitive load when reading code

### 2. **Reusability**
- Components can be reused in other screens
- Dialogs and builders are standalone utilities
- File operations can be imported separately

### 3. **Testability**
- Each component can be unit tested independently
- Mock dependencies are easier to inject
- Reduced test complexity

### 4. **Scalability**
- New features can be added to specific components
- Less risk of merge conflicts
- Easier onboarding for new developers

### 5. **Code Organization**
- 73% reduction in main file size (1462 → 394 lines)
- Clear separation of UI and business logic
- Logical grouping of related functionality

## Usage Example

```dart
// Before refactoring (inline code in main file)
Widget _buildFileTile(File file) {
  // 50+ lines of inline code
}

// After refactoring (clean delegation)
LocalScreenItemBuilders.buildFileTile(
  file,
  provider,
  () => onTap(),
  () => onLongPress(),
)
```

## Import Strategy

Instead of importing individual files:
```dart
import 'local_screen_components/local_screen_models.dart';
import 'local_screen_components/local_screen_dialogs.dart';
// ... 7 more imports
```

You can use the barrel file:
```dart
import 'local_screen_components/local_screen_components.dart';
```

## Connection with LocalProvider

The `LocalProvider` (900 lines) handles:
- File system operations (read, write, delete, move, copy)
- Thumbnail generation and caching
- Path management with SharedPreferences
- File type detection (movies, images, audio, documents)

The refactored components interact with `LocalProvider` through:
- Provider pattern: `Provider.of<LocalProvider>(context, listen: false)`
- Method calls for operations: `provider.renameFile()`, `provider.deleteFolder()`
- File type checks: `provider.isMovieFile()`, `provider.isImageFile()`

## Future Enhancements

Potential areas for further improvement:
1. Extract sorting logic to a separate utility
2. Create a search/filter component
3. Add unit tests for each component
4. Implement a theming system for consistent styling
5. Add analytics or logging to file operations
6. Create a settings screen for user preferences

## Migration Notes

- No breaking changes to public API
- All original functionality preserved
- State management remains unchanged
- Provider pattern integration intact
- No changes to `LocalProvider` required
