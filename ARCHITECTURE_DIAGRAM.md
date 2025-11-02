# Local Screen Architecture

## Component Hierarchy

```
┌─────────────────────────────────────────────────────────────────┐
│                        local_screen.dart                         │
│                     (Main Screen - 394 lines)                    │
│                                                                   │
│  • State Management (currentFolderPath, viewMode, sortMode)      │
│  • Navigation Logic (_goUp, _openFolder)                         │
│  • Sorting Logic (_getSortedItems)                               │
│  • Build Methods (_buildContent, _buildGridView, _buildListView) │
│                                                                   │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         │ Uses
                         ▼
    ┌────────────────────────────────────────────────────────┐
    │            LocalProvider (Data Layer)                   │
    │               (900 lines - unchanged)                   │
    │                                                          │
    │  • File System Operations                               │
    │  • Thumbnail Generation & Caching                       │
    │  • Path Management                                      │
    │  • File Type Detection                                  │
    └────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                 local_screen_components/                         │
│                  (Component Library)                             │
└─────────────────────────────────────────────────────────────────┘

┌──────────────────────┐  ┌──────────────────────┐  ┌──────────────────────┐
│  Models & Enums      │  │     UI Drawers       │  │   Dialog Widgets     │
│  (19 lines)          │  │     (35 lines)       │  │   (237 lines)        │
│                      │  │                      │  │                      │
│  • ViewMode enum     │  │  • ComponentLibrary  │  │  • Input Dialog      │
│  • SortMode enum     │  │    Drawer            │  │  • Confirmation      │
│  • GridItem class    │  │  • ComponentBrowser  │  │  • Path Selection    │
│                      │  │    Drawer            │  │  • Size Slider       │
│                      │  │                      │  │  • Batch Rename      │
└──────────────────────┘  └──────────────────────┘  └──────────────────────┘

┌──────────────────────┐  ┌──────────────────────┐  ┌──────────────────────┐
│  Item Builders       │  │   Context Menus      │  │  AppBar Actions      │
│  (195 lines)         │  │   (153 lines)        │  │  (87 lines)          │
│                      │  │                      │  │                      │
│  • Folder Tile       │  │  • File Context      │  │  • View Toggle       │
│  • File Tile         │  │    Menu              │  │  • Size Adjust       │
│  • Folder List Item  │  │  • Folder Context    │  │  • Sort Menu         │
│  • File List Item    │  │    Menu              │  │  • Folder Picker     │
│  • Thumbnail Builder │  │                      │  │  • Refresh           │
│                      │  │                      │  │  • Batch Actions     │
└──────────────────────┘  └──────────────────────┘  └──────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│              File Operations (481 lines)                         │
│                                                                   │
│  File Operations:                  Folder Operations:            │
│  • handleFileTap()                 • renameFolder()              │
│  • showImageDialog()               • deleteFolder()              │
│  • showDocumentContentDialog()     • copyFolder()                │
│  • renameFile()                    • moveFolder()                │
│  • deleteFile()                    • createNewFolder()           │
│  • copyFile()                                                    │
│  • moveFile()                      Batch Operations:             │
│                                    • showBatchRenameDialog()     │
└─────────────────────────────────────────────────────────────────┘
```

## Data Flow

```
User Action
    │
    ▼
┌─────────────────┐
│ LocalScreen     │◄───────────────┐
│ (UI Logic)      │                │
└────────┬────────┘                │
         │                         │
         │ Delegates to            │
         ▼                         │
┌─────────────────┐                │
│ Component Files │                │
│ (UI Components) │                │
└────────┬────────┘                │
         │                         │
         │ Calls                   │
         ▼                         │
┌─────────────────┐                │
│ LocalProvider   │                │
│ (Business Logic)│                │
└────────┬────────┘                │
         │                         │
         │ File System             │
         ▼                         │
┌─────────────────┐                │
│ File System     │                │
│ (Storage)       │                │
└────────┬────────┘                │
         │                         │
         │ Result/Data             │
         └─────────────────────────┘
```

## Component Interaction Example

### Opening a File

```
1. User taps on file
   │
   ▼
2. LocalScreen.build()
   └─> LocalScreenItemBuilders.buildFileTile()
       └─> onTap callback
           │
           ▼
3. LocalScreenFileOperations.handleFileTap()
   ├─> Check file type
   │   ├─> Movie: Navigate to VideoPlayerScreen
   │   ├─> Image: showImageDialog()
   │   ├─> Audio: Check format
   │   └─> Text: showDocumentContentDialog()
   │
   └─> If document:
       ├─> LocalProvider.getDocumentContent()
       ├─> Show dialog with TextField
       └─> On save: LocalProvider.saveDocumentContent()
```

### Context Menu Flow

```
1. User long-presses on folder
   │
   ▼
2. LocalScreen._showFolderContextMenu()
   │
   ▼
3. LocalScreenContextMenus.showFolderContextMenu()
   ├─> Shows bottom sheet with options
   │   ├─> Rename
   │   ├─> Copy
   │   ├─> Move
   │   ├─> Delete
   │   └─> Create New Folder
   │
   └─> On selection:
       ├─> Calls respective LocalScreenFileOperations method
       └─> Which calls LocalProvider method
           └─> Updates file system
               └─> Refreshes UI via notifyListeners()
```

## Before vs After Structure

### Before Refactoring
```
local_screen.dart (1462 lines)
├─ Imports
├─ Drawer classes (inline)
├─ Enums (inline)
├─ LocalScreen class
│  ├─ State variables
│  ├─ Init methods
│  ├─ Navigation methods
│  ├─ Sorting logic (inline)
│  ├─ Dialog methods (inline, 300+ lines)
│  ├─ Build methods
│  ├─ Grid/List item builders (inline, 200+ lines)
│  ├─ Context menu methods (inline, 150+ lines)
│  ├─ File operation methods (inline, 400+ lines)
│  └─ Helper methods
└─ GridItem class (inline)
```

### After Refactoring
```
local_screen.dart (394 lines)
├─ Imports (now organized)
├─ LocalScreen class
│  ├─ State variables
│  ├─ Init methods
│  ├─ Navigation methods
│  ├─ Sorting logic
│  ├─ Build methods
│  ├─ Context menu handlers (delegate to components)
│  └─ Helper methods

local_screen_components/
├─ local_screen_models.dart (19 lines)
├─ local_screen_drawers.dart (35 lines)
├─ local_screen_dialogs.dart (237 lines)
├─ local_screen_item_builders.dart (195 lines)
├─ local_screen_context_menus.dart (153 lines)
├─ local_screen_file_operations.dart (481 lines)
├─ local_screen_appbar_actions.dart (87 lines)
└─ local_screen_components.dart (barrel file)
```

## Metrics

| Metric | Before | After | Improvement |
|--------|--------|-------|-------------|
| Main file lines | 1,462 | 394 | 73% reduction |
| Number of files | 1 | 9 | Better organization |
| Avg file size | 1,462 lines | 151 lines | Easier to navigate |
| Largest component | N/A | 481 lines | Still manageable |
| Inline classes | 3 | 0 | Properly modularized |
| Code reusability | Low | High | Components are standalone |

## Testing Strategy

```
Unit Tests
├─ local_screen_models_test.dart
│  └─ Test GridItem, enums
│
├─ local_screen_dialogs_test.dart
│  └─ Test dialog widgets
│
├─ local_screen_item_builders_test.dart
│  └─ Test item rendering
│
├─ local_screen_file_operations_test.dart
│  └─ Test file operation logic
│
└─ local_screen_test.dart
   └─ Integration tests for main screen

Widget Tests
├─ Test drawer widgets
├─ Test context menus
└─ Test AppBar actions

Integration Tests
└─ End-to-end file management flows
```
