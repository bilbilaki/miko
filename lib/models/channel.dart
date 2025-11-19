class Channel {
  final String id;
  final String name;
  final String logoUrl;
  final String streamUrl;
  final String category;
  final String language;
  final String country;
  final String subdivision; // e.g., state, province

  Channel({
    required this.id,
    required this.name,
    required this.logoUrl,
    required this.streamUrl,
    required this.category,
    required this.language,
    required this.country,
    required this.subdivision,
  });
}