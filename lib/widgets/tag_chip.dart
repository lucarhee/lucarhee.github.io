import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class TagChip extends StatelessWidget {
  const TagChip({
    super.key,
    required this.tag,
    this.onTap,
    this.small = false,
  });

  final String tag;
  final VoidCallback? onTap;
  final bool small;

  @override
  Widget build(BuildContext context) {
    final color = AppTheme.tagColor(tag);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: small ? 8 : 10,
          vertical: small ? 2 : 4,
        ),
        decoration: BoxDecoration(
          color: color.withOpacity(isDark ? 0.15 : 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: color.withOpacity(0.4),
            width: 1,
          ),
        ),
        child: Text(
          '#$tag',
          style: TextStyle(
            fontSize: small ? 11 : 12,
            fontWeight: FontWeight.w500,
            color: color,
            height: 1.2,
          ),
        ),
      ),
    );
  }
}
