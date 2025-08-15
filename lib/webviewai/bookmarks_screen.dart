import 'package:flutter/material.dart';
import 'package:miko/webviewai/bookmark_service.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BookmarksScreen extends StatefulWidget {
  final WebViewController webViewController;
  final BookmarkService bookmarkService;

  const BookmarksScreen({
    Key? key,
    required this.webViewController,
    required this.bookmarkService,
  }) : super(key: key);

  @override
  State<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  List<Map<String, String>> _bookmarks = [];

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
  }

  Future<void> _loadBookmarks() async {
    final loadedBookmarks = await widget.bookmarkService.loadBookmarks();
    setState(() {
      _bookmarks = loadedBookmarks;
    });
  }

  Future<void> _removeBookmark(String url) async {
    await widget.bookmarkService.removeBookmark(url);
    _loadBookmarks(); // Reload bookmarks after removal
  }

  void _navigateToUrl(String url) {
    widget.webViewController.loadRequest(Uri.parse(url));
    Navigator.pop(context); // Close bookmarks screen
    Navigator.pop(context); // Close drawer
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
        backgroundColor: theme.colorScheme.surface,
      ),
      body: _bookmarks.isEmpty
          ? Center(
              child: Text(
                'No bookmarks yet.',
                style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.onBackground),
              ),
            )
          : ListView.builder(
              itemCount: _bookmarks.length,
              itemBuilder: (context, index) {
                final bookmark = _bookmarks[index];
                return Card(
                  color: theme.colorScheme.surface,
                  margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: ListTile(
                    title: Text(
                      bookmark['title'] ?? 'No Title',
                      style: TextStyle(color: theme.colorScheme.onSurface),
                    ),
                    subtitle: Text(
                      bookmark['url'] ?? 'No URL',
                      style: TextStyle(color: theme.colorScheme.secondary),
                    ),
                    onTap: () => _navigateToUrl(bookmark['url']!),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () => _removeBookmark(bookmark['url']!),
                    ),
                  ),
                );
              },
            ),
    );
  }
}