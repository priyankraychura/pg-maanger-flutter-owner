import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Animated gradient background with floating decorative circles.
/// Used as the base scaffold background across all screens.
class GradientBackground extends StatefulWidget {
  final Widget child;
  final bool animate;

  const GradientBackground({
    super.key,
    required this.child,
    this.animate = false,
  });

  @override
  State<GradientBackground> createState() => _GradientBackgroundState();
}

class _GradientBackgroundState extends State<GradientBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    );
    if (widget.animate) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(
        gradient: isDark
            ? AppColors.darkBackgroundGradient
            : AppColors.lightBackgroundGradient,
      ),
      child: Stack(
        children: [
          if (widget.animate)
            AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                return CustomPaint(
                  size: size,
                  painter: _OrbsPainter(
                    progress: _controller.value,
                    isDark: isDark,
                  ),
                );
              },
            )
          else
            CustomPaint(
              size: size,
              painter: _OrbsPainter(
                progress: 0.0,
                isDark: isDark,
              ),
            ),
          widget.child,
        ],
      ),
    );
  }
}

class _OrbsPainter extends CustomPainter {
  final double progress;
  final bool isDark;

  _OrbsPainter({required this.progress, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, isDark ? 140 : 100);

    final glow1X = size.width * 0.8 + math.sin(progress * 2 * math.pi) * 30;
    final glow1Y = size.height * 0.15 + math.cos(progress * 2 * math.pi) * 20;
    paint.color = AppColors.primaryOrange.withValues(alpha: isDark ? 0.09 : 0.07);
    canvas.drawCircle(Offset(glow1X, glow1Y), isDark ? 180 : 140, paint);

    final glow2X = size.width * 0.15 + math.cos(progress * 2 * math.pi + 1.5) * 25;
    final glow2Y = size.height * 0.5 + math.sin(progress * 2 * math.pi + 1.5) * 30;
    paint.color = AppColors.secondarySlate.withValues(alpha: isDark ? 0.08 : 0.06);
    canvas.drawCircle(Offset(glow2X, glow2Y), isDark ? 200 : 150, paint);

    final glow3X = size.width * 0.75 + math.sin(progress * 2 * math.pi + 3) * 20;
    final glow3Y = size.height * 0.8 + math.cos(progress * 2 * math.pi + 3) * 25;
    paint.color = AppColors.accentTeal.withValues(alpha: isDark ? 0.06 : 0.04);
    canvas.drawCircle(Offset(glow3X, glow3Y), isDark ? 160 : 120, paint);
  }

  @override
  bool shouldRepaint(_OrbsPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
