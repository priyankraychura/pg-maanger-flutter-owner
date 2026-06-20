import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/glass_app_bar.dart';

class StaffPage extends StatelessWidget {
  const StaffPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GlassAppBar(
        title: 'Staff Management',
        showBackButton: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.badge_rounded, size: 80, color: AppColors.lightTextTertiary),
            const SizedBox(height: AppSpacing.md),
            Text(
              'No Staff Added',
              style: AppTextStyles.h2.copyWith(color: AppColors.lightTextSecondary),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Manage your managers and staff here.',
              style: AppTextStyles.body.copyWith(color: AppColors.lightTextTertiary),
            ),
            const SizedBox(height: AppSpacing.xl),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.person_add_rounded),
              label: const Text('Add Staff'),
            ),
          ],
        ),
      ),
    );
  }
}
