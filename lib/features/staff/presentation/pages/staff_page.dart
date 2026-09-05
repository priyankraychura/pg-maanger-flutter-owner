import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/rbac/access_provider.dart';
import '../../../../core/rbac/app_module.dart';
import '../../../../core/rbac/permission_level.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/common_loader.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/glass_app_bar.dart';
import '../../../../core/widgets/glass_button.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/rbac/permission_guard.dart' show AccessDeniedState;
import '../../../../core/widgets/status_badge.dart';
import '../../../auth/domain/entities/user_role.dart';
import '../../../roles/domain/entities/staff_entity.dart';
import '../../../roles/presentation/providers/staff_provider.dart';

/// Staff Management — list of invited managers/helpers/admins and their access.
///
/// Reached from More → Staff Management. Visible only to principals who can
/// view the staff module (owner / admins); edit actions are further gated on
/// [AccessPolicy.canEdit].
class StaffPage extends ConsumerWidget {
  const StaffPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final access = ref.watch(accessPolicyProvider);
    final canView = access.canView(AppModule.staff);
    final canEdit = access.canEdit(AppModule.staff);

    return Scaffold(
      appBar: GlassAppBar(
        title: 'Staff Management',
        subtitle: canView ? 'Manage roles & access' : null,
        showBackButton: true,
        actionIcon: canView && canEdit ? Icons.person_add_alt_1_rounded : null,
        actionTooltip: 'Add staff',
        onActionPressed:
            canView && canEdit ? () => context.push('/staff/form') : null,
      ),
      body: SafeArea(
        top: false,
        child: !canView
            ? const AccessDeniedState()
            : _StaffList(canEdit: canEdit),
      ),
    );
  }
}

class _StaffList extends ConsumerWidget {
  final bool canEdit;
  const _StaffList({required this.canEdit});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final staffAsync = ref.watch(staffListProvider);

    return staffAsync.when(
      loading: () => const CommonLoader(message: 'Loading staff...'),
      error: (e, _) => Center(child: Text('Error loading staff: $e')),
      data: (staff) {
        if (staff.isEmpty) {
          return EmptyState(
            icon: Icons.badge_rounded,
            title: 'No Staff Added',
            subtitle: 'Invite managers or helpers and set what they can access.',
            actionLabel: canEdit ? 'Add Staff' : null,
            actionIcon: Icons.person_add_alt_1_rounded,
            primaryAction: true,
            onAction: canEdit ? () => context.push('/staff/form') : null,
          );
        }

        return RefreshIndicator(
          color: AppColors.primaryOrange,
          onRefresh: () async {
            ref.invalidate(staffListProvider);
            await ref.read(staffListProvider.future).catchError(
                  (_) => <StaffEntity>[],
                );
          },
          child: ListView(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.screenPadding,
              AppSpacing.lg,
              AppSpacing.screenPadding,
              context.bottomNavInset,
            ),
            children: [
              ...staff.map(
                (s) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: _StaffCard(
                    staff: s,
                    onTap: canEdit && !s.isSuperAdmin
                        ? () => context.push('/staff/form', extra: s)
                        : null,
                  ),
                ),
              ),
              if (canEdit) ...[
                const SizedBox(height: AppSpacing.sm),
                GlassButton.outlined(
                  label: 'Add Staff',
                  icon: Icons.person_add_alt_1_rounded,
                  onPressed: () => context.push('/staff/form'),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _StaffCard extends StatelessWidget {
  final StaffEntity staff;
  final VoidCallback? onTap;

  const _StaffCard({required this.staff, this.onTap});

  @override
  Widget build(BuildContext context) {
    final editableCount = staff.permissions.values
        .where((l) => l == PermissionLevel.edit)
        .length;
    final viewableCount = staff.permissions.values.where((l) => l.canView).length;

    return GlassCard(
      onTap: onTap,
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.info.withValues(alpha: 0.15),
                child: Text(
                  staff.name.isNotEmpty ? staff.name[0].toUpperCase() : '?',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.info,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            staff.name,
                            style: AppTextStyles.bodyLarge.copyWith(
                              fontWeight: FontWeight.w700,
                              color: context.textPrimary,
                            ),
                          ),
                        ),
                        if (staff.isSuperAdmin) ...[
                          const SizedBox(width: AppSpacing.xs),
                          const Icon(Icons.lock_rounded,
                              size: 14, color: AppColors.warning),
                        ],
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      staff.email,
                      style: AppTextStyles.caption
                          .copyWith(color: context.textSecondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              _StatusBadge(status: staff.status),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              _chip(context, Icons.shield_outlined, staff.role.displayName),
              _chip(context, Icons.apartment_rounded,
                  '${staff.assignedPgIds.length} PG${staff.assignedPgIds.length == 1 ? '' : 's'}'),
              _chip(context, Icons.edit_outlined, '$editableCount editable'),
              _chip(context, Icons.visibility_outlined, '$viewableCount visible'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chip(BuildContext context, IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: context.isDark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.black.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(AppSpacing.radiusRound),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: context.textTertiary),
          const SizedBox(width: AppSpacing.xxs),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(color: context.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final StaffStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final StatusType type;
    switch (status) {
      case StaffStatus.active:
        type = StatusType.success;
        break;
      case StaffStatus.pendingInvite:
        type = StatusType.warning;
        break;
      case StaffStatus.inactive:
        type = StatusType.neutral;
        break;
    }
    return StatusBadge(label: status.label, type: type, small: true);
  }
}
