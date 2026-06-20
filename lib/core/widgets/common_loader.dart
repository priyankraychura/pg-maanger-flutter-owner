import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

class CommonLoader extends StatelessWidget {
  final String? message;
  final bool fullScreen;

  const CommonLoader({
    super.key,
    this.message,
    this.fullScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final loader = Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 54,
            height: 54,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.primaryOrange.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryOrange),
              strokeWidth: 3.5,
            ).animate(onPlay: (controller) => controller.repeat()).shimmer(duration: 1200.ms, color: AppColors.primaryOrange.withValues(alpha: 0.5)),
          ).animate(onPlay: (controller) => controller.repeat(reverse: true)).scale(begin: const Offset(0.95, 0.95), end: const Offset(1.05, 1.05), duration: 1000.ms, curve: Curves.easeInOut),
          if (message != null) ...[
            const SizedBox(height: AppSpacing.lg),
            Text(
              message!,
              style: TextStyle(
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0),
          ],
        ],
      ).animate().fadeIn(duration: 300.ms).scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1), curve: Curves.easeOutBack),
    );

    if (fullScreen) {
      return Container(
        color: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.6),
        child: loader,
      );
    }

    return loader;
  }
}
