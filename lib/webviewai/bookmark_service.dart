import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class BookmarkService {
  static const String _bookmarksKey = 'bookmarks';

  Future<List<Map<String, String>>> loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? bookmarksString = prefs.getString(_bookmarksKey);
    if (bookmarksString != null) {
      final List<dynamic> decodedList = json.decode(bookmarksString);
      return decodedList.map((item) => Map<String, String>.from(item)).toList();
    }
    return [];
  }

  Future<void> saveBookmarks(List<Map<String, String>> bookmarks) async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedList = json.encode(bookmarks);
    await prefs.setString(_bookmarksKey, encodedList);
  }

  Future<void> addBookmark(String url, String title) async {
    final List<Map<String, String>> bookmarks = await loadBookmarks();
    // Prevent adding duplicate bookmarks
    if (!bookmarks.any((bookmark) => bookmark['url'] == url)) {
      bookmarks.add({'url': url, 'title': title});
      await saveBookmarks(bookmarks);
    }
  }

  Future<void> removeBookmark(String url) async {
    List<Map<String, String>> bookmarks = await loadBookmarks();
    bookmarks.removeWhere((bookmark) => bookmark['url'] == url);
    await saveBookmarks(bookmarks);
  }
}