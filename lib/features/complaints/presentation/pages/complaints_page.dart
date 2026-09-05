import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/extensions/date_extensions.dart';
import '../../../../core/rbac/access_provider.dart';
import '../../../../core/rbac/app_module.dart';
import '../../../../core/rbac/permission_guard.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/common_bottom_sheet.dart';
import '../../../../core/widgets/common_loader.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/glass_app_bar.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../domain/entities/complaint_entity.dart';
import '../providers/complaint_provider.dart';

class ComplaintsPage extends ConsumerWidget {
  const ComplaintsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canEdit = ref.watch(accessPolicyProvider).canEdit(AppModule.complaints);
    final complaintsAsync = ref.watch(complaintsProvider);

    return Scaffold(
      appBar: const GlassAppBar(
        title: 'Complaints',
        showBackButton: true,
      ),
      body: PermissionGuard(
        module: AppModule.complaints,
        child: complaintsAsync.when(
          loading: () => const CommonLoader(),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (complaints) {
            if (complaints.isEmpty) {
              return const EmptyState(
                icon: Icons.report_gmailerrorred_rounded,
                title: 'No Complaints Found',
                subtitle: 'All tenant complaints have been resolved.',
              );
            }

            return RefreshIndicator(
              color: AppColors.primaryOrange,
              onRefresh: () async {
                ref.invalidate(complaintsProvider);
                await ref
                    .read(complaintsProvider.future)
                    .catchError((_) => <ComplaintEntity>[]);
              },
              child: ListView.builder(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.screenPadding,
                  AppSpacing.screenPadding,
                  AppSpacing.screenPadding,
                  context.bottomNavInset,
                ),
                itemCount: complaints.length,
                itemBuilder: (context, index) => _ComplaintCard(
                  complaint: complaints[index],
                  canEdit: canEdit,
                  onChangeStatus: canEdit
                      ? () => _openStatusSheet(context, ref, complaints[index])
                      : null,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _openStatusSheet(
    BuildContext context,
    WidgetRef ref,
    ComplaintEntity complaint,
  ) {
    return showCommonBottomSheet(
      context: context,
      title: 'Update Status',
      builder: (ctx, setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              complaint.title,
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.bold,
                color: ctx.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            for (final status in ComplaintStatus.values) ...[
              _StatusOption(
                status: status,
                selected: complaint.status == status,
                onTap: () async {
                  Navigator.of(ctx).pop();
                  try {
                    await updateComplaintStatus(ref, complaint.id, status);
                    if (context.mounted) {
                      context.showSnackBar('Marked as ${status.label}');
                    }
                  } catch (e) {
                    if (context.mounted) {
                      context.showSnackBar('Could not update status: $e',
                          isError: true);
                    }
                  }
                },
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
          ],
        );
      },
    );
  }
}

/// Maps a complaint status to a display color and badge type.
({Color color, StatusType badge, IconData icon}) _statusVisuals(
    ComplaintStatus status) {
  switch (status) {
    case ComplaintStatus.pending:
      return (
        color: AppColors.error,
        badge: StatusType.error,
        icon: Icons.error_outline_rounded,
      );
    case ComplaintStatus.inProgress:
      return (
        color: AppColors.warning,
        badge: StatusType.warning,
        icon: Icons.autorenew_rounded,
      );
    case ComplaintStatus.resolved:
      return (
        color: AppColors.success,
        badge: StatusType.success,
        icon: Icons.check_circle_outline_rounded,
      );
  }
}

class _ComplaintCard extends StatelessWidget {
  final ComplaintEntity complaint;
  final bool canEdit;
  final VoidCallback? onChangeStatus;

  const _ComplaintCard({
    required this.complaint,
    required this.canEdit,
    this.onChangeStatus,
  });

  @override
  Widget build(BuildContext context) {
    final visuals = _statusVisuals(complaint.status);

    return GlassCard(
      onTap: onChangeStatus,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: visuals.color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(visuals.icon,
                    color: visuals.color, size: AppSpacing.iconMd),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      complaint.title,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.bold,
                        color: context.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      '${complaint.category} • ${complaint.tenantName} • Room ${complaint.roomNumber}',
                      style: AppTextStyles.caption.copyWith(
                        color: context.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              StatusBadge(
                label: complaint.status.label,
                type: visuals.badge,
                small: true,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            complaint.description,
            style: AppTextStyles.body.copyWith(color: context.textSecondary),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Icon(
                Icons.schedule_rounded,
                size: 14,
                color: context.textTertiary,
              ),
              const SizedBox(width: AppSpacing.xxs),
              Text(
                complaint.createdAt.formatted,
                style: AppTextStyles.caption.copyWith(
                  color: context.textTertiary,
                ),
              ),
              const Spacer(),
              if (canEdit)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Change status',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primaryOrange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xxs),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 11,
                      color: AppColors.primaryOrange,
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusOption extends StatelessWidget {
  final ComplaintStatus status;
  final bool selected;
  final VoidCallback onTap;

  const _StatusOption({
    required this.status,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final visuals = _statusVisuals(status);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: selected
                ? visuals.color.withValues(alpha: 0.10)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            border: Border.all(
              color: selected
                  ? visuals.color.withValues(alpha: 0.5)
                  : (context.isDark
                      ? AppColors.darkGlassBorder
                      : AppColors.lightGlassBorder),
            ),
          ),
          child: Row(
            children: [
              Icon(visuals.icon, color: visuals.color, size: AppSpacing.iconMd),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  status.label,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    color: context.textPrimary,
                  ),
                ),
              ),
              if (selected)
                Icon(Icons.check_rounded, color: visuals.color, size: AppSpacing.iconMd),
            ],
          ),
        ),
      ),
    );
  }
}
