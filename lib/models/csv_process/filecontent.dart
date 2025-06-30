class FileContent {
  final String filePath;
  String content;
  final List<String> lines; // To facilitate line-by-line loading

  FileContent(
      {required this.filePath, this.content = '', this.lines = const []});

  // Add a method if you want to load more lines
  FileContent loadMoreLines(int linesToLoad, {int startIndex = 0}) {
    // This would be handled by FileService, but conceptually:
    // Extract a subset of lines and append to current content/lines
    // For simplicity, this model might just hold all lines and we page in UI
    return this;
  }
}
