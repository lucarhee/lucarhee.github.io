import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../theme/app_theme.dart';

class NavBar extends StatelessWidget implements PreferredSizeWidget {
  const NavBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final location = GoRouterState.of(context).uri.path;

    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF0B0B1A).withOpacity(0.9)
            : Colors.white.withOpacity(0.9),
        border: Border(
          bottom: BorderSide(
            color: isDark
                ? const Color(0xFF2D2D52)
                : const Color(0xFFE2E8F0),
            width: 1,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          children: [
            // Logo
            GestureDetector(
              onTap: () => context.go('/'),
              child: ShaderMask(
                shaderCallback: (bounds) =>
                    AppTheme.primaryGradient.createShader(bounds),
                child: Text(
                  'dev.blog',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontSize: 22,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
            ),

            const Spacer(),

            // Nav links
            _NavLink(label: 'Home', path: '/', current: location),
            const SizedBox(width: 8),
            _NavLink(label: 'Blog', path: '/blog', current: location),
            const SizedBox(width: 16),

            // Theme toggle
            Consumer<ThemeProvider>(
              builder: (context, tp, _) => IconButton(
                onPressed: tp.toggle,
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    tp.isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                    key: ValueKey(tp.isDark),
                    color: isDark
                        ? const Color(0xFFCBD5E1)
                        : const Color(0xFF475569),
                  ),
                ),
                tooltip: tp.isDark ? 'Light mode' : 'Dark mode',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavLink extends StatelessWidget {
  const _NavLink({
    required this.label,
    required this.path,
    required this.current,
  });

  final String label;
  final String path;
  final String current;

  bool get _isActive {
    if (path == '/') return current == '/';
    return current.startsWith(path);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return TextButton(
      onPressed: () => context.go(path),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: _isActive ? FontWeight.w600 : FontWeight.w400,
          color: _isActive
              ? AppTheme.primary
              : (isDark
                  ? const Color(0xFFCBD5E1)
                  : const Color(0xFF475569)),
        ),
      ),
    );
  }
}
