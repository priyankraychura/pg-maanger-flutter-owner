import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/rbac/access_provider.dart';
import '../../../../core/rbac/app_module.dart';
import '../../../../core/rbac/permission_guard.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/invite_link_builder.dart';
import '../../../../core/widgets/glass_app_bar.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/status_badge.dart';

class TenantsPage extends ConsumerWidget {
  const TenantsPage({super.key});

  /// Builds a 24-hour tenant invite link and opens it in the browser.
  Future<void> _openInviteLink(BuildContext context) async {
    final link = InviteLinkBuilder.buildTenantInviteLink(
      pgId: 'pg_001',
      pgName: 'Sunrise PG',
    );

    final launched = await launchUrl(
      Uri.parse(link),
      mode: LaunchMode.externalApplication,
    );

    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open the invite link')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final canEdit = ref.watch(accessPolicyProvider).canEdit(AppModule.tenants);

    // Mock Data
    final tenants = [
      {'name': 'Rahul Kumar', 'room': '101', 'status': 'Active', 'rentStatus': 'Paid'},
      {'name': 'Amit Singh', 'room': '102', 'status': 'Active', 'rentStatus': 'Pending'},
      {'name': 'Priya Sharma', 'room': '201', 'status': 'Notice', 'rentStatus': 'Paid'},
      {'name': 'Vikram Gupta', 'room': '103', 'status': 'Active', 'rentStatus': 'Overdue'},
      {'name': 'Neha Patel', 'room': '203', 'status': 'Active', 'rentStatus': 'Paid'},
    ];

    return Scaffold(
      appBar: GlassAppBar(
        title: 'Tenants',
        showBackButton: false,
        actionIcon: canEdit ? Icons.mail_outline_rounded : null,
        actionTooltip: 'Invite Tenant',
        onActionPressed: canEdit ? () => _openInviteLink(context) : null,
      ),
      body: PermissionGuard(
        module: AppModule.tenants,
        child: ListView.builder(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.screenPadding,
          AppSpacing.screenPadding,
          AppSpacing.screenPadding,
          context.bottomNavInset,
        ),
        itemCount: tenants.length,
        itemBuilder: (context, index) {
          final tenant = tenants[index];
          final rentStatus = tenant['rentStatus'];

          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: GlassCard(
              onTap: () {},
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.primaryOrange.withValues(alpha: 0.15),
                    child: Text(
                      tenant['name']![0],
                      style: AppTextStyles.h2.copyWith(color: AppColors.primaryOrange),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tenant['name']!,
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xxs),
                        Text(
                          'Room ${tenant['room']}',
                          style: AppTextStyles.caption.copyWith(
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      StatusBadge(
                        label: tenant['status']!,
                        type: tenant['status'] == 'Active' ? StatusType.success : StatusType.warning,
                        small: true,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        rentStatus!,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: rentStatus == 'Paid' ? AppColors.success : (rentStatus == 'Pending' ? AppColors.warning : AppColors.error),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
        ),
      ),
      floatingActionButton: canEdit
          ? Padding(
              padding: EdgeInsets.only(bottom: context.fabBottomInset),
              child: FloatingActionButton(
                onPressed: () => context.push('/tenants/add'),
                backgroundColor: AppColors.primaryOrange,
                child: const Icon(Icons.person_add_alt_1_rounded,
                    color: Colors.white),
              ),
            )
          : null,
    );
  }
}
