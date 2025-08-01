class PrayerRequest {
  final String id;
  final String title;
  final String content;
  final String author;
  final int likes;
  final List<String> tags;
  final String? imageUrl;

  PrayerRequest({
    required this.id,
    required this.title,
    required this.content,
    required this.author,
    required this.likes,
    required this.tags,
    this.imageUrl,
  });
}
