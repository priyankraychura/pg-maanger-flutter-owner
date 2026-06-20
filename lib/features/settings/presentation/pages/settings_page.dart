import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/glass_app_bar.dart';
import '../../../../core/widgets/glass_card.dart';
import '../providers/settings_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

/// Settings page for the owner app.
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeProvider);
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final owner = ref.watch(currentOwnerProvider);

    return Scaffold(
      appBar: const GlassAppBar(
        title: 'Settings',
        showBackButton: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        children: [
          // Profile Card
          GlassCard(
            onTap: () {},
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppColors.primaryOrange.withValues(alpha: 0.15),
                  child: Text(
                    owner?.name.isNotEmpty == true
                        ? owner!.name[0].toUpperCase()
                        : 'O',
                    style: AppTextStyles.h1.copyWith(
                      color: AppColors.primaryOrange,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        owner?.name ?? 'Owner',
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        owner?.email ?? '',
                        style: AppTextStyles.caption.copyWith(
                          color: isDarkTheme
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: isDarkTheme
                      ? AppColors.darkTextTertiary
                      : AppColors.lightTextTertiary,
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // Appearance
          GlassCard.info(
            icon: Icons.dark_mode_rounded,
            title: 'Dark Mode',
            iconColor: AppColors.secondarySlate,
            trailing: Switch.adaptive(
              value: isDark,
              onChanged: (_) => ref.read(themeProvider.notifier).toggle(),
              activeTrackColor: AppColors.primaryOrange,
            ),
          ),

          // Staff Management
          GlassCard.info(
            icon: Icons.group_add_rounded,
            title: 'Staff Management',
            subtitle: 'Manage roles & access',
            iconColor: AppColors.info,
            onTap: () => context.push('/staff'),
          ),

          // PG Management
          GlassCard.info(
            icon: Icons.apartment_rounded,
            title: 'Manage PGs',
            subtitle: 'Add or edit properties',
            iconColor: AppColors.accentTeal,
            onTap: () => context.push('/pg-management'),
          ),

          // Help & Support
          GlassCard.info(
            icon: Icons.help_outline_rounded,
            title: 'Help & Support',
            subtitle: 'FAQs and contact',
            iconColor: AppColors.warning,
            onTap: () {},
          ),

          // Privacy Policy
          GlassCard.info(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            iconColor: AppColors.secondarySlate,
            onTap: () {},
          ),

          const SizedBox(height: AppSpacing.xxl),

          // Logout
          GlassCard.info(
            icon: Icons.logout_rounded,
            title: 'Logout',
            iconColor: AppColors.error,
            onTap: () async {
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) {
                context.go('/login');
              }
            },
          ),

          const SizedBox(height: AppSpacing.massive),
        ],
      ),
    );
  }
}
