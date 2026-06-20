import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/glass_app_bar.dart';

class PgManagementPage extends StatelessWidget {
  const PgManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GlassAppBar(
        title: 'Manage PGs',
        showBackButton: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.business_rounded, size: 80, color: AppColors.lightTextTertiary),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Manage Properties',
              style: AppTextStyles.h2.copyWith(color: AppColors.lightTextSecondary),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Add, edit or remove PG branches.',
              style: AppTextStyles.body.copyWith(color: AppColors.lightTextTertiary),
            ),
            const SizedBox(height: AppSpacing.xl),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add_home_work_rounded),
              label: const Text('Add New PG'),
            ),
          ],
        ),
      ),
    );
  }
}
