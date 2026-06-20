import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/glass_app_bar.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GlassAppBar(
        title: 'Mess Menu',
        showBackButton: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant_menu_rounded, size: 80, color: AppColors.lightTextTertiary),
            const SizedBox(height: AppSpacing.md),
            Text(
              'No Menu Configured',
              style: AppTextStyles.h2.copyWith(color: AppColors.lightTextSecondary),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'You have not set up a mess menu yet.',
              style: AppTextStyles.body.copyWith(color: AppColors.lightTextTertiary),
            ),
            const SizedBox(height: AppSpacing.xl),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add_rounded),
              label: const Text('Create Menu'),
            ),
          ],
        ),
      ),
    );
  }
}
