class PostMeta {
  final String slug;
  final String title;
  final String date;
  final String description;
  final List<String> tags;
  final int readTime;

  const PostMeta({
    required this.slug,
    required this.title,
    required this.date,
    required this.description,
    required this.tags,
    required this.readTime,
  });

  factory PostMeta.fromJson(Map<String, dynamic> json) {
    return PostMeta(
      slug: json['slug'] as String,
      title: json['title'] as String,
      date: json['date'] as String,
      description: json['description'] as String? ?? '',
      tags: List<String>.from(json['tags'] as List? ?? []),
      readTime: json['readTime'] as int? ?? 5,
    );
  }

  /// Display date formatted as "Jan 15, 2024"
  String get formattedDate {
    try {
      final parts = date.split('-');
      if (parts.length < 3) return date;
      final dt = DateTime(
        int.parse(parts[0]),
        int.parse(parts[1]),
        int.parse(parts[2]),
      );
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
    } catch (_) {
      return date;
    }
  }

  /// Asset path for the markdown file
  String get assetPath => 'assets/posts/$slug.md';
}

class Post {
  final PostMeta meta;
  final String content;

  const Post({required this.meta, required this.content});
}
