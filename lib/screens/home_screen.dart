import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/posts_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/navbar.dart';
import '../widgets/post_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PostsProvider>().loadIndex();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final isWide = size.width > 900;

    return Scaffold(
      appBar: const NavBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Hero ──────────────────────────────────────────────────────────
            Container(
              decoration: BoxDecoration(
                gradient: isDark
                    ? AppTheme.heroGradient
                    : const LinearGradient(
                        colors: [Color(0xFFEEF2FF), Color(0xFFE0F2FE)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isWide ? 80 : 24,
                  vertical: isWide ? 100 : 64,
                ),
                child: isWide
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(child: _HeroText(theme: theme)),
                          const SizedBox(width: 60),
                          _HeroVisual(isDark: isDark),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _HeroText(theme: theme),
                          const SizedBox(height: 40),
                          Center(child: _HeroVisual(isDark: isDark)),
                        ],
                      ),
              ),
            ),

            // ── Skills section ──────────────────────────────────────────────
            _SkillsSection(theme: theme, isWide: isWide),

            // ── Recent posts ────────────────────────────────────────────────
            _RecentPosts(theme: theme, isWide: isWide),

            // ── Footer ──────────────────────────────────────────────────────
            _Footer(theme: theme, isDark: isDark),
          ],
        ),
      ),
    );
  }
}

// ─── Hero Text ────────────────────────────────────────────────────────────────

class _HeroText extends StatelessWidget {
  const _HeroText({required this.theme});
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '✨  Available for opportunities',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        )
            .animate()
            .fadeIn(duration: 500.ms)
            .slideX(begin: -0.2, end: 0),

        const SizedBox(height: 24),

        // Name
        ShaderMask(
          shaderCallback: (bounds) =>
              AppTheme.primaryGradient.createShader(bounds),
          child: Text(
            'Hello, I\'m\nYour Name.',
            style: theme.textTheme.displayLarge?.copyWith(
              color: Colors.white,
            ),
          ),
        )
            .animate(delay: 100.ms)
            .fadeIn(duration: 600.ms)
            .slideY(begin: 0.2, end: 0),

        const SizedBox(height: 20),

        // Subtitle
        Text(
          'Flutter Developer & Technical Writer.\nI build beautiful apps and share what I learn.',
          style: theme.textTheme.bodyLarge?.copyWith(
            fontSize: 18,
            height: 1.6,
          ),
        )
            .animate(delay: 200.ms)
            .fadeIn(duration: 600.ms)
            .slideY(begin: 0.2, end: 0),

        const SizedBox(height: 36),

        // CTA buttons
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _GradientButton(
              label: 'Read my blog',
              onTap: () => context.go('/blog'),
            ),
            _OutlineButton(
              label: 'View GitHub',
              onTap: () {},
            ),
          ],
        )
            .animate(delay: 300.ms)
            .fadeIn(duration: 600.ms)
            .slideY(begin: 0.2, end: 0),
      ],
    );
  }
}

// ─── Hero Visual ──────────────────────────────────────────────────────────────

class _HeroVisual extends StatelessWidget {
  const _HeroVisual({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      height: 280,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            AppTheme.primary.withOpacity(0.3),
            AppTheme.secondary.withOpacity(0.1),
            Colors.transparent,
          ],
        ),
      ),
      child: Center(
        child: Container(
          width: 220,
          height: 220,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppTheme.primaryGradient,
            boxShadow: [
              BoxShadow(
                color: AppTheme.primary.withOpacity(0.4),
                blurRadius: 40,
                spreadRadius: 5,
              ),
            ],
          ),
          child: const Center(
            child: Text(
              '👨‍💻',
              style: TextStyle(fontSize: 80),
            ),
          ),
        ),
      ),
    )
        .animate(delay: 200.ms)
        .fadeIn(duration: 800.ms)
        .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1));
  }
}

// ─── Skills ───────────────────────────────────────────────────────────────────

class _SkillsSection extends StatelessWidget {
  const _SkillsSection({required this.theme, required this.isWide});
  final ThemeData theme;
  final bool isWide;

  static const _skills = [
    ('Flutter', '🐦', AppTheme.primary),
    ('Dart', '🎯', AppTheme.secondary),
    ('Firebase', '🔥', Color(0xFFF59E0B)),
    ('REST APIs', '🌐', Color(0xFF10B981)),
    ('Git', '🗂️', Color(0xFFEF4444)),
    ('UI/UX', '🎨', Color(0xFFEC4899)),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? 80 : 24,
        vertical: 64,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionLabel(label: 'Skills & Tools'),
          const SizedBox(height: 32),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              for (int i = 0; i < _skills.length; i++)
                _SkillCard(
                  emoji: _skills[i].$2,
                  label: _skills[i].$1,
                  color: _skills[i].$3,
                  index: i,
                )
            ],
          ),
        ],
      ),
    );
  }
}

class _SkillCard extends StatefulWidget {
  const _SkillCard({
    required this.emoji,
    required this.label,
    required this.color,
    required this.index,
  });
  final String emoji;
  final String label;
  final Color color;
  final int index;

  @override
  State<_SkillCard> createState() => _SkillCardState();
}

class _SkillCardState extends State<_SkillCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 130,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: _hovered
              ? widget.color.withOpacity(0.15)
              : (isDark ? const Color(0xFF1C1C38) : Colors.white),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _hovered
                ? widget.color.withOpacity(0.5)
                : (isDark
                    ? const Color(0xFF2D2D52)
                    : const Color(0xFFE2E8F0)),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 8),
            Text(
              widget.label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: _hovered ? widget.color : null,
              ),
            ),
          ],
        ),
      ),
    )
        .animate(delay: Duration(milliseconds: widget.index * 60))
        .fadeIn(duration: 400.ms)
        .slideY(begin: 0.1, end: 0);
  }
}

// ─── Recent Posts ─────────────────────────────────────────────────────────────

class _RecentPosts extends StatelessWidget {
  const _RecentPosts({required this.theme, required this.isWide});
  final ThemeData theme;
  final bool isWide;

  @override
  Widget build(BuildContext context) {
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF0D0D22)
            : const Color(0xFFF1F5F9),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? 80 : 24,
        vertical: 64,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _SectionLabel(label: 'Recent Posts'),
              TextButton.icon(
                onPressed: () => context.go('/blog'),
                icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                label: const Text('View all'),
                iconAlignment: IconAlignment.end,
              ),
            ],
          ),
          const SizedBox(height: 32),
          Consumer<PostsProvider>(
            builder: (context, provider, _) {
              if (provider.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (provider.error != null) {
                return Center(child: Text(provider.error!));
              }
              final recent = provider.posts.take(3).toList();
              if (recent.isEmpty) {
                return const Center(child: Text('No posts yet.'));
              }
              return isWide
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (int i = 0; i < recent.length; i++)
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: i < recent.length - 1 ? 20 : 0,
                              ),
                              child: PostCard(post: recent[i], index: i),
                            ),
                          ),
                      ],
                    )
                  : Column(
                      children: [
                        for (int i = 0; i < recent.length; i++)
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: i < recent.length - 1 ? 20 : 0,
                            ),
                            child: PostCard(post: recent[i], index: i),
                          ),
                      ],
                    );
            },
          ),
        ],
      ),
    );
  }
}

// ─── Footer ───────────────────────────────────────────────────────────────────

class _Footer extends StatelessWidget {
  const _Footer({required this.theme, required this.isDark});
  final ThemeData theme;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      child: Column(
        children: [
          const Divider(),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Built with ',
                style: theme.textTheme.bodyMedium,
              ),
              const Text('💙', style: TextStyle(fontSize: 14)),
              Text(
                ' Flutter Web',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                ' · © ${DateTime.now().year}',
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Shared Widgets ──────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          width: 4,
          height: 28,
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Text(label, style: theme.textTheme.headlineMedium),
      ],
    );
  }
}

class _GradientButton extends StatelessWidget {
  const _GradientButton({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        decoration: BoxDecoration(
          gradient: AppTheme.primaryGradient,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primary.withOpacity(0.4),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _OutlineButton extends StatelessWidget {
  const _OutlineButton({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark
                ? const Color(0xFF2D2D52)
                : const Color(0xFFCBD5E1),
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isDark
                ? const Color(0xFFCBD5E1)
                : const Color(0xFF475569),
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
