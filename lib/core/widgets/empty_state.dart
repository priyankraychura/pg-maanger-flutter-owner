import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Empty state placeholder widget for screens with no data.
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final IconData? actionIcon;
  final VoidCallback? onAction;

  /// When true, the action renders as a prominent filled button instead of a
  /// plain text button.
  final bool primaryAction;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.actionIcon,
    this.onAction,
    this.primaryAction = false,
  });

  Widget _buildAction() {
    final label = Text(actionLabel!);
    final icon = actionIcon;

    if (primaryAction) {
      final style = ElevatedButton.styleFrom(
        minimumSize: const Size(0, AppSpacing.buttonHeight),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
      );
      return icon != null
          ? ElevatedButton.icon(
              onPressed: onAction,
              style: style,
              icon: Icon(icon, size: AppSpacing.iconMd),
              label: label,
            )
          : ElevatedButton(onPressed: onAction, style: style, child: label);
    }

    return icon != null
        ? TextButton.icon(
            onPressed: onAction,
            icon: Icon(icon, size: AppSpacing.iconMd),
            label: label,
          )
        : TextButton(onPressed: onAction, child: label);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: AppColors.primaryOrange.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: AppSpacing.iconXxl,
                color: AppColors.primaryOrange.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            Text(
              title,
              style: AppTextStyles.h2.copyWith(
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                subtitle!,
                style: AppTextStyles.body.copyWith(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AppSpacing.xxl),
              _buildAction(),
            ],
          ],
        ),
      ),
    );
  }
}
