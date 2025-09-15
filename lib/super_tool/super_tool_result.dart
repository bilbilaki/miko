import 'package:miko/functions/data_storage.dart';


class CrawlHit {
  final String url;
  final String? quality; // e.g., 1080p
  final String? series; // optional bucket
  final String? episode; // SxxExx
  CrawlHit({required this.url, this.quality, this.series, this.episode});
}

class PostItem {
  final String url;
  final String title;
  final String poster;
  final String overview;
  final Map<String, dynamic> meta;
  PostItem({
    required this.url,
    required this.title,
    required this.poster,
    required this.overview,
    required this.meta,
  });
}

class SuperToolResult {
  final String strategyUsed; // 'webPage' | 'webPath' | 'fallback'
  final List<CrawlHit> hits;
  final List<PostItem> posts;
  final Map<String, dynamic> summary; // counts, timings
  final Map<String, List<String>>?
  assetsByType; // anchors/images/videos/audio/docs
  SuperToolResult({
    required this.strategyUsed,
    this.hits = const [],
    this.posts = const [],
    this.summary = const {},
    this.assetsByType,
  });

  TabularData toTabularForHits() {
    final columns = ['url', 'quality', 'series', 'episode'];
    final rows = hits
        .map((h) => [h.url, h.quality, h.series, h.episode])
        .toList();
    return TabularData(columns, rows);
  }

  TabularData toTabularForPosts() {
    final columns = ['url', 'title', 'poster', 'overview', 'meta_json'];
    final rows = posts
        .map(
          (p) => [
            p.url,
            p.title,
            p.poster,
            p.overview,
            p.meta.isEmpty ? '{}' : p.meta,
          ],
        )
        .toList();
    return TabularData(columns, rows);
  }
}
