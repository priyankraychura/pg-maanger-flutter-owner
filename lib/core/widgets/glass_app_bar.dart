import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

/// Glassmorphic app bar that floats over the content with blur effect.
class GlassAppBar extends ConsumerWidget implements PreferredSizeWidget {
  static const double _iconEdgePadding = 16.0;
  static const double _iconButtonSize = 38.0;

  final String title;
  final String? subtitle;
  final List<Widget>? actions;
  final IconData? actionIcon;
  final VoidCallback? onActionPressed;
  final String? actionTooltip;
  final Widget? leading;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final bool centerTitle;

  const GlassAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
    this.actionIcon,
    this.onActionPressed,
    this.actionTooltip,
    this.leading,
    this.showBackButton = true,
    this.onBackPressed,
    this.centerTitle = false,
  });

  @override
  Size get preferredSize => Size.fromHeight(
      AppSpacing.appBarHeight + (subtitle != null ? 8.0 : 0.0));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bgColor = isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final Color borderColor = isDark
        ? AppColors.darkGlassBorder.withValues(alpha: 0.2)
        : AppColors.lightGlassBorder.withValues(alpha: 0.1);

    Widget buildIconButton({
      required IconData icon,
      required VoidCallback onTap,
      required EdgeInsetsGeometry padding,
      String? tooltip,
    }) {
      final button = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(100),
          child: Ink(
            width: _iconButtonSize,
            height: _iconButtonSize,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                icon,
                size: 18,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
          ),
        ),
      );

      return Center(
        child: Padding(
          padding: padding,
          child: tooltip != null
              ? Tooltip(message: tooltip, child: button)
              : button,
        ),
      );
    }

    final Widget? leadingWidget = leading ??
        (showBackButton
            ? buildIconButton(
                icon: Icons.arrow_back_ios_new_rounded,
                onTap: onBackPressed ?? () {
                  if (Navigator.canPop(context)) {
                    Navigator.maybePop(context);
                  } else {
                    context.go('/dashboard');
                  }
                },
                padding: const EdgeInsets.only(left: _iconEdgePadding),
              )
            : null);

    final Widget? trailingAction = actionIcon != null && onActionPressed != null
        ? buildIconButton(
            icon: actionIcon!,
            onTap: onActionPressed!,
            padding: const EdgeInsets.only(right: _iconEdgePadding),
            tooltip: actionTooltip,
          )
        : null;

    Widget appBarWidget = Container(
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(
          bottom: BorderSide(
            color: borderColor,
            width: 0.5,
          ),
        ),
      ),
      child: AppBar(
        toolbarHeight: preferredSize.height,
        titleSpacing: showBackButton ? 0.0 : 20.0,
        title: Column(
          crossAxisAlignment:
              centerTitle ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: AppTextStyles.h2.copyWith(
                fontWeight: FontWeight.w700,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 2),
              Text(
                subtitle!,
                style: AppTextStyles.caption.copyWith(
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
            ],
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: centerTitle,
        leading: leadingWidget,
        leadingWidth: showBackButton
            ? _iconEdgePadding + _iconButtonSize
            : null,
        actions: [
          ...?actions?.map(
            (w) => Padding(
              padding: const EdgeInsets.only(right: _iconEdgePadding),
              child: w,
            ),
          ),
          ?trailingAction,
        ],
      ),
    );

    return appBarWidget;
  }
}
