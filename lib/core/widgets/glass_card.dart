import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/app_spacing.dart';
import 'glass_container.dart';

/// A glassmorphic card with optional icon, title, subtitle, and tap handler.
/// Commonly used on the dashboard and feature screens.
class GlassCard extends ConsumerWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final bool animate;

  const GlassCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.margin,
    this.borderRadius = AppSpacing.radiusXl,
    this.animate = true,
  });

  /// Convenience factory for a simple icon + title + subtitle card.
  factory GlassCard.info({
    Key? key,
    required IconData icon,
    required String title,
    String? subtitle,
    Color? iconColor,
    VoidCallback? onTap,
    Widget? trailing,
    bool animate = true,
  }) {
    return GlassCard(
      key: key,
      onTap: onTap,
      animate: animate,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: (iconColor ?? Colors.white).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Icon(icon, color: iconColor, size: AppSpacing.iconLg),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ],
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget card = GlassContainer(
      onTap: onTap,
      padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
      margin: margin ?? const EdgeInsets.only(bottom: AppSpacing.md),
      borderRadius: borderRadius,
      child: child,
    );

    return card;
  }
}
