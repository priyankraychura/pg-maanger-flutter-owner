import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/glass_app_bar.dart';

class ComplaintsPage extends StatelessWidget {
  const ComplaintsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GlassAppBar(
        title: 'Complaints',
        showBackButton: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.report_gmailerrorred_rounded, size: 80, color: AppColors.lightTextTertiary),
            const SizedBox(height: AppSpacing.md),
            Text(
              'No Complaints Found',
              style: AppTextStyles.h2.copyWith(color: AppColors.lightTextSecondary),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'All tenant complaints have been resolved.',
              style: AppTextStyles.body.copyWith(color: AppColors.lightTextTertiary),
            ),
          ],
        ),
      ),
    );
  }
}
