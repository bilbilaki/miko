import 'dart:io';
import 'package:path/path.dart' as p;

// Enums for managing UI states
enum ViewMode { grid, list }

enum SortMode { name, date, type }

// A helper class to unify File and Directory for sorting and display purposes
class GridItem {
  final FileSystemEntity entity;

  GridItem(this.entity);

  bool get isFolder => entity is Directory;
  
  // Get just the base name (file or folder name)
  String get name => p.basename(entity.path);
}
