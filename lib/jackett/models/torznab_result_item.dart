import 'package:xml/xml.dart';
import 'package:intl/intl.dart';

class TorznabResultItem {
  final String title;
  final String guid;
  final String link; // This can be a webpage link
  final DateTime? pubDate;
  final String category;
  final int size;
  final int? seeders;
  final int? peers;
  final int? grabs;
  final String? magnetUrl; // This is the direct magnet link

  TorznabResultItem({
    required this.title,
    required this.guid,
    required this.link,
    this.pubDate,
    required this.category,
    required this.size,
    this.seeders,
    this.peers,
    this.grabs,
    this.magnetUrl,
  });

  /// Provides the best link for user actions. Prioritizes magnet links.
  String get actionableLink => magnetUrl ?? link;

  /// Determines if the primary link is a downloadable magnet.
  bool get hasMagnet => magnetUrl != null;
  
  /// Determines if the standard link is a webpage that can be previewed.
  bool get isWebpage => !link.startsWith('magnet:') && link.startsWith('http');


  static int? _parseInt(XmlElement? element, String name, {String namespace = '*'}) {
    if (element == null) return null;
    final attr = element.getAttribute(name, namespace: namespace);
    return attr != null ? int.tryParse(attr) : null;
  }

  static String? _parseString(XmlElement element, String name) {
    try {
      return element.findElements(name).first.innerText;
    } catch (_) {
      return null;
    }
  }

  factory TorznabResultItem.fromXmlElement(XmlElement element) {
    DateTime? parsedDate;
    final dateString = _parseString(element, 'pubDate');
    if (dateString != null) {
      try {
        // Handles RFC 1123 date format, common in RSS feeds.
        parsedDate = DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'").parse(dateString, true).toLocal();
      } catch (e) {
        try {
          // Fallback for ISO 8601 format.
          parsedDate = DateTime.parse(dateString).toLocal();
        } catch (_) {
          // Could not parse date.
        }
      }
    }

    final torznabAttributes = element.findElements('torznab:attr');
    
    String? magnetUrlValue;
    try {
        final magnetAttr = torznabAttributes.firstWhere((e) => e.getAttribute('name') == 'magneturl');
        magnetUrlValue = magnetAttr.getAttribute('value');
    } catch (_) {
        // 'magneturl' attribute not found, which is common.
    }

    return TorznabResultItem(
      title: _parseString(element, 'title') ?? 'No Title',
      guid: _parseString(element, 'guid') ?? '',
      link: _parseString(element, 'link') ?? '',
      pubDate: parsedDate,
      category: _parseString(element, 'category') ?? 'N/A',
      size: int.tryParse(_parseString(element, 'size') ?? '0') ?? 0,
      seeders: _parseInt(torznabAttributes.firstWhere((e) => e.getAttribute('name') == 'seeders', orElse: () => XmlElement(XmlName('null'))), 'value'),
      peers: _parseInt(torznabAttributes.firstWhere((e) => e.getAttribute('name') == 'peers', orElse: () => XmlElement(XmlName('null'))), 'value'),
      grabs: _parseInt(torznabAttributes.firstWhere((e) => e.getAttribute('name') == 'grabs', orElse: () => XmlElement(XmlName('null'))), 'value'),
      magnetUrl: magnetUrlValue,
    );
  }
}