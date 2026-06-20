import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/glass_app_bar.dart';

class InvitationsPage extends StatelessWidget {
  const InvitationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GlassAppBar(
        title: 'Invitations',
        showBackButton: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_add_disabled_rounded, size: 80, color: AppColors.lightTextTertiary),
            const SizedBox(height: AppSpacing.md),
            Text(
              'No Pending Invitations',
              style: AppTextStyles.h2.copyWith(color: AppColors.lightTextSecondary),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'You have no pending invitations to display.',
              style: AppTextStyles.body.copyWith(color: AppColors.lightTextTertiary),
            ),
            const SizedBox(height: AppSpacing.xl),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text('Send Invitation'),
            ),
          ],
        ),
      ),
    );
  }
}
