import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/post.dart';
import '../providers/posts_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/navbar.dart';
import '../widgets/tag_chip.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key, required this.slug});
  final String slug;

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  Post? _post;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    await context.read<PostsProvider>().loadIndex();
    final post =
        await context.read<PostsProvider>().loadPost(widget.slug);
    if (mounted) {
      setState(() {
        _post = post;
        _loading = false;
        _error = post == null ? 'Post not found.' : null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isWide = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      appBar: const NavBar(),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? _ErrorView(message: _error!)
              : _PostBody(
                  post: _post!,
                  theme: theme,
                  isDark: isDark,
                  isWide: isWide,
                ),
    );
  }
}

// ─── Post Body ────────────────────────────────────────────────────────────────

class _PostBody extends StatelessWidget {
  const _PostBody({
    required this.post,
    required this.theme,
    required this.isDark,
    required this.isWide,
  });

  final Post post;
  final ThemeData theme;
  final bool isDark;
  final bool isWide;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Hero Header ──────────────────────────────────────────────
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
            padding: EdgeInsets.symmetric(
              horizontal: isWide ? 80 : 24,
              vertical: 48,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back button
                TextButton.icon(
                  onPressed: () => context.go('/blog'),
                  icon: const Icon(Icons.arrow_back_rounded, size: 18),
                  label: const Text('Back to Blog'),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    foregroundColor: AppTheme.primary,
                  ),
                ).animate().fadeIn(duration: 300.ms),

                const SizedBox(height: 24),

                // Tags
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: post.meta.tags
                      .map((t) => TagChip(tag: t))
                      .toList(),
                ).animate(delay: 50.ms).fadeIn(duration: 400.ms),

                const SizedBox(height: 20),

                // Title
                Text(
                  post.meta.title,
                  style: theme.textTheme.displayMedium?.copyWith(
                    fontSize: isWide ? 40 : 28,
                  ),
                )
                    .animate(delay: 100.ms)
                    .fadeIn(duration: 500.ms)
                    .slideY(begin: 0.1, end: 0),

                const SizedBox(height: 16),

                // Description
                if (post.meta.description.isNotEmpty)
                  Text(
                    post.meta.description,
                    style: theme.textTheme.bodyLarge?.copyWith(fontSize: 18),
                  ).animate(delay: 150.ms).fadeIn(duration: 500.ms),

                const SizedBox(height: 20),

                // Meta info
                Row(
                  children: [
                    _MetaBadge(
                      icon: Icons.calendar_today_outlined,
                      label: post.meta.formattedDate,
                    ),
                    const SizedBox(width: 16),
                    _MetaBadge(
                      icon: Icons.timer_outlined,
                      label: '${post.meta.readTime} min read',
                    ),
                  ],
                ).animate(delay: 200.ms).fadeIn(duration: 500.ms),
              ],
            ),
          ),

          // ── Markdown Content ─────────────────────────────────────────
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isWide ? 24 : 24,
                  vertical: 48,
                ),
                child: _MarkdownContent(
                  content: post.content,
                  isDark: isDark,
                  theme: theme,
                ),
              ),
            ),
          ),

          // ── Navigation Footer ────────────────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isWide ? 80 : 24,
              vertical: 48,
            ),
            child: Column(
              children: [
                const Divider(),
                const SizedBox(height: 24),
                Center(
                  child: TextButton.icon(
                    onPressed: () => context.go('/blog'),
                    icon: const Icon(Icons.arrow_back_rounded, size: 18),
                    label: const Text('Back to all posts'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Markdown Content ─────────────────────────────────────────────────────────

class _MarkdownContent extends StatelessWidget {
  const _MarkdownContent({
    required this.content,
    required this.isDark,
    required this.theme,
  });

  final String content;
  final bool isDark;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final textColor =
        isDark ? const Color(0xFFE2E8F0) : const Color(0xFF1E293B);
    final mutedColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final codeBackground =
        isDark ? const Color(0xFF1E1E3F) : const Color(0xFFF1F5F9);
    final codeBorder =
        isDark ? const Color(0xFF2D2D52) : const Color(0xFFE2E8F0);

    return MarkdownBody(
      data: content,
      selectable: true,
      styleSheet: MarkdownStyleSheet(
        h1: GoogleFonts.poppins(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: textColor,
          height: 1.3,
        ),
        h2: GoogleFonts.poppins(
          fontSize: 26,
          fontWeight: FontWeight.w600,
          color: textColor,
          height: 1.4,
        ),
        h3: GoogleFonts.poppins(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: textColor,
          height: 1.4,
        ),
        h4: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
        p: GoogleFonts.inter(
          fontSize: 17,
          height: 1.8,
          color: textColor,
        ),
        strong: GoogleFonts.inter(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
        em: GoogleFonts.inter(
          fontSize: 17,
          fontStyle: FontStyle.italic,
          color: textColor,
        ),
        code: GoogleFonts.firaCode(
          fontSize: 14,
          color: AppTheme.secondary,
          backgroundColor: codeBackground,
        ),
        codeblockDecoration: BoxDecoration(
          color: codeBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: codeBorder),
        ),
        codeblockPadding: const EdgeInsets.all(20),
        blockquoteDecoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: AppTheme.primary,
              width: 4,
            ),
          ),
          color: AppTheme.primary.withOpacity(0.05),
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(8),
            bottomRight: Radius.circular(8),
          ),
        ),
        blockquotePadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        listBullet: GoogleFonts.inter(
          fontSize: 17,
          color: AppTheme.primary,
        ),
        a: GoogleFonts.inter(
          fontSize: 17,
          color: AppTheme.primary,
          decoration: TextDecoration.underline,
          decorationColor: AppTheme.primary.withOpacity(0.4),
        ),
        horizontalRuleDecoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: isDark
                  ? const Color(0xFF2D2D52)
                  : const Color(0xFFE2E8F0),
              width: 1,
            ),
          ),
        ),
        tableCellsDecoration: BoxDecoration(
          color: isDark
              ? const Color(0xFF1C1C38)
              : const Color(0xFFF8FAFC),
        ),
        tableHead: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
        tableBody: GoogleFonts.inter(
          color: textColor,
        ),
        h1Padding: const EdgeInsets.only(top: 40, bottom: 8),
        h2Padding: const EdgeInsets.only(top: 32, bottom: 8),
        h3Padding: const EdgeInsets.only(top: 24, bottom: 6),
        pPadding: const EdgeInsets.only(bottom: 16),
      ),
      onTapLink: (text, href, title) async {
        if (href != null) {
          final uri = Uri.tryParse(href);
          if (uri != null && await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        }
      },
      builders: {
        'code': _CodeBlockBuilder(isDark: isDark),
      },
    ).animate(delay: 200.ms).fadeIn(duration: 600.ms);
  }
}

// ─── Code Block with Copy Button ─────────────────────────────────────────────

class _CodeBlockBuilder extends MarkdownElementBuilder {
  _CodeBlockBuilder({required this.isDark});
  final bool isDark;

  @override
  Widget? visitElementAfterWithContext(
    BuildContext context,
    dynamic element,
    TextStyle? preferredStyle,
    TextStyle? parentStyle,
  ) {
    // Only intercept fenced code blocks (multiline)
    if (element.textContent.contains('\n')) {
      return _CopyableCodeBlock(
        code: element.textContent,
        isDark: isDark,
      );
    }
    return null;
  }
}

class _CopyableCodeBlock extends StatefulWidget {
  const _CopyableCodeBlock({required this.code, required this.isDark});
  final String code;
  final bool isDark;

  @override
  State<_CopyableCodeBlock> createState() => _CopyableCodeBlockState();
}

class _CopyableCodeBlockState extends State<_CopyableCodeBlock> {
  bool _copied = false;

  @override
  Widget build(BuildContext context) {
    final bg = widget.isDark
        ? const Color(0xFF1E1E3F)
        : const Color(0xFFF1F5F9);
    final border = widget.isDark
        ? const Color(0xFF2D2D52)
        : const Color(0xFFE2E8F0);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top bar with copy button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: border)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () async {
                    await Clipboard.setData(
                        ClipboardData(text: widget.code));
                    setState(() => _copied = true);
                    await Future.delayed(const Duration(seconds: 2));
                    if (mounted) setState(() => _copied = false);
                  },
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      _copied ? Icons.check_rounded : Icons.copy_rounded,
                      key: ValueKey(_copied),
                      size: 16,
                      color: _copied
                          ? AppTheme.success
                          : (widget.isDark
                              ? const Color(0xFF64748B)
                              : const Color(0xFF94A3B8)),
                    ),
                  ),
                  tooltip: _copied ? 'Copied!' : 'Copy code',
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                ),
              ],
            ),
          ),
          // Code content
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(20),
            child: SelectableText(
              widget.code,
              style: GoogleFonts.firaCode(
                fontSize: 14,
                color: widget.isDark
                    ? const Color(0xFFE2E8F0)
                    : const Color(0xFF1E293B),
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Meta Badge ───────────────────────────────────────────────────────────────

class _MetaBadge extends StatelessWidget {
  const _MetaBadge({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 14,
          color: isDark
              ? const Color(0xFF64748B)
              : const Color(0xFF94A3B8),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium,
        ),
      ],
    );
  }
}

// ─── Error View ───────────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('😕', style: TextStyle(fontSize: 60)),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => context.go('/blog'),
            icon: const Icon(Icons.arrow_back_rounded),
            label: const Text('Back to Blog'),
          ),
        ],
      ),
    );
  }
}
