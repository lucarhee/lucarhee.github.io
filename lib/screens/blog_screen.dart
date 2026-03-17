import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/posts_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/navbar.dart';
import '../widgets/post_card.dart';
import '../widgets/tag_chip.dart';

class BlogScreen extends StatefulWidget {
  const BlogScreen({super.key});

  @override
  State<BlogScreen> createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  final _searchCtrl = TextEditingController();
  String _searchQuery = '';
  String? _selectedTag;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PostsProvider>().loadIndex();
    });
    _searchCtrl.addListener(() {
      setState(() => _searchQuery = _searchCtrl.text);
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isWide = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      appBar: const NavBar(),
      body: Consumer<PostsProvider>(
        builder: (context, provider, _) {
          final allTags = provider.allTags;
          final posts = _searchQuery.isNotEmpty
              ? provider.search(_searchQuery)
              : _selectedTag != null
                  ? provider.filterByTag(_selectedTag!)
                  : provider.posts;

          return CustomScrollView(
            slivers: [
              // ── Header ─────────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: isDark
                        ? AppTheme.heroGradient
                        : const LinearGradient(
                            colors: [Color(0xFFEEF2FF), Color(0xFFE0F2FE)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: isWide ? 80 : 24,
                    vertical: 48,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) =>
                            AppTheme.primaryGradient.createShader(bounds),
                        child: Text(
                          'Blog',
                          style: theme.textTheme.displayMedium?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      )
                          .animate()
                          .fadeIn(duration: 500.ms)
                          .slideY(begin: 0.15, end: 0),

                      const SizedBox(height: 8),

                      Text(
                        '${provider.posts.length} articles about Flutter, Dart, and more',
                        style: theme.textTheme.bodyLarge,
                      )
                          .animate(delay: 100.ms)
                          .fadeIn(duration: 500.ms),

                      const SizedBox(height: 28),

                      // Search bar
                      _SearchBar(controller: _searchCtrl, isDark: isDark)
                          .animate(delay: 150.ms)
                          .fadeIn(duration: 500.ms),
                    ],
                  ),
                ),
              ),

              // ── Tag Filter ─────────────────────────────────────────────
              if (allTags.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      isWide ? 80 : 24,
                      28,
                      isWide ? 80 : 24,
                      0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Filter by tag',
                          style: theme.textTheme.labelLarge,
                        ),
                        const SizedBox(height: 12),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              // All
                              _FilterChip(
                                label: 'All',
                                selected: _selectedTag == null,
                                onTap: () =>
                                    setState(() => _selectedTag = null),
                              ),
                              const SizedBox(width: 8),
                              ...allTags.map((tag) => Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: _FilterChip(
                                      label: '#$tag',
                                      selected: _selectedTag == tag,
                                      color: AppTheme.tagColor(tag),
                                      onTap: () => setState(() {
                                        _selectedTag =
                                            _selectedTag == tag ? null : tag;
                                      }),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // ── Post Grid ──────────────────────────────────────────────
              SliverPadding(
                padding: EdgeInsets.symmetric(
                  horizontal: isWide ? 80 : 24,
                  vertical: 32,
                ),
                sliver: provider.isLoading
                    ? const SliverToBoxAdapter(
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(60),
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      )
                    : posts.isEmpty
                        ? SliverToBoxAdapter(
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(60),
                                child: Column(
                                  children: [
                                    const Text('🔍',
                                        style: TextStyle(fontSize: 48)),
                                    const SizedBox(height: 16),
                                    Text(
                                      'No posts found',
                                      style: theme.textTheme.headlineMedium,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Try a different search or tag',
                                      style: theme.textTheme.bodyMedium,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : isWide
                            ? SliverGrid.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 380,
                                  crossAxisSpacing: 24,
                                  mainAxisSpacing: 24,
                                  childAspectRatio: 0.9,
                                ),
                                itemCount: posts.length,
                                itemBuilder: (ctx, i) => PostCard(
                                  post: posts[i],
                                  index: i,
                                ),
                              )
                            : SliverList.separated(
                                itemCount: posts.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 20),
                                itemBuilder: (ctx, i) => PostCard(
                                  post: posts[i],
                                  index: i,
                                ),
                              ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.controller, required this.isDark});
  final TextEditingController controller;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C38) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? const Color(0xFF2D2D52)
              : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(
          fontSize: 15,
          color: isDark ? Colors.white : const Color(0xFF0F172A),
        ),
        decoration: InputDecoration(
          hintText: 'Search posts by title, tag...',
          hintStyle: TextStyle(
            fontSize: 15,
            color: isDark
                ? const Color(0xFF64748B)
                : const Color(0xFF94A3B8),
          ),
          prefixIcon: const Icon(Icons.search_rounded, size: 20),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close_rounded, size: 18),
                  onPressed: controller.clear,
                )
              : null,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.color,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final c = color ?? AppTheme.primary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: selected
              ? c.withOpacity(0.15)
              : (isDark ? const Color(0xFF1C1C38) : Colors.white),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? c.withOpacity(0.6)
                : (isDark
                    ? const Color(0xFF2D2D52)
                    : const Color(0xFFE2E8F0)),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            color: selected
                ? c
                : (isDark
                    ? const Color(0xFFCBD5E1)
                    : const Color(0xFF475569)),
          ),
        ),
      ),
    );
  }
}
