import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Core glassmorphism container widget.
/// All glass_* widgets are built on top of this.
/// Provides frosted glass effect with customizable blur, opacity, and border.
class GlassContainer extends ConsumerWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final double blurSigma;
  final double? opacity;
  final Color? borderColor;
  final VoidCallback? onTap;

  const GlassContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius = AppSpacing.radiusXl,
    this.blurSigma = AppSpacing.glassBlurSigma,
    this.opacity,
    this.borderColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color fillColor = isDark
        ? AppColors.darkSurface.withValues(alpha: 0.85)
        : AppColors.lightSurface.withValues(alpha: 0.85);
    final Color border = borderColor ??
        (isDark
            ? AppColors.darkGlassBorder.withValues(alpha: 0.15)
            : AppColors.lightGlassBorder.withValues(alpha: 0.3));
    final List<BoxShadow> shadow = [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.04),
        blurRadius: 16,
        offset: const Offset(0, 4),
      )
    ];

    Widget innerContent = Padding(
      padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
      child: child,
    );

    if (onTap != null) {
      innerContent = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: innerContent,
        ),
      );
    }

    Widget container = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: border,
          width: AppSpacing.glassBorderWidth,
        ),
        boxShadow: shadow,
      ),
      child: innerContent,
    );

    if (margin != null) {
      container = Padding(padding: margin!, child: container);
    }

    return container;
  }
}
