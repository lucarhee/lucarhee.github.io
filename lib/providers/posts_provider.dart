import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/post.dart';

class PostsProvider extends ChangeNotifier {
  List<PostMeta> _posts = [];
  bool _isLoading = false;
  String? _error;

  List<PostMeta> get posts => _posts;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// All unique tags across all posts
  List<String> get allTags {
    final tags = <String>{};
    for (final p in _posts) {
      tags.addAll(p.tags);
    }
    return tags.toList()..sort();
  }

  /// Load the posts index from assets
  Future<void> loadIndex() async {
    if (_posts.isNotEmpty) return; // Already loaded
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final raw = await rootBundle.loadString('assets/posts/index.json');
      final data = jsonDecode(raw) as Map<String, dynamic>;
      final list = (data['posts'] as List).cast<Map<String, dynamic>>();
      _posts = list.map(PostMeta.fromJson).toList()
        ..sort((a, b) => b.date.compareTo(a.date)); // Newest first
    } catch (e) {
      _error = 'Failed to load posts: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load full markdown content for a specific post
  Future<Post?> loadPost(String slug) async {
    final meta = _posts.firstWhere(
      (p) => p.slug == slug,
      orElse: () => PostMeta(
        slug: slug,
        title: slug,
        date: '',
        description: '',
        tags: [],
        readTime: 5,
      ),
    );

    try {
      final raw = await rootBundle.loadString(meta.assetPath);
      // Strip YAML frontmatter if present
      final content = _stripFrontmatter(raw);
      return Post(meta: meta, content: content);
    } catch (e) {
      return null;
    }
  }

  /// Remove YAML frontmatter (--- ... ---) from markdown
  String _stripFrontmatter(String raw) {
    if (!raw.trimLeft().startsWith('---')) return raw;
    final end = raw.indexOf('\n---', 3);
    if (end == -1) return raw;
    return raw.substring(end + 4).trimLeft();
  }

  /// Filter posts by tag
  List<PostMeta> filterByTag(String tag) {
    return _posts.where((p) => p.tags.contains(tag)).toList();
  }

  /// Search posts by title or description
  List<PostMeta> search(String query) {
    final q = query.toLowerCase();
    return _posts.where((p) {
      return p.title.toLowerCase().contains(q) ||
          p.description.toLowerCase().contains(q) ||
          p.tags.any((t) => t.toLowerCase().contains(q));
    }).toList();
  }
}
