import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/entities/dashboard_entity.dart';

/// Activity feed tile for the dashboard.
/// Features circular icon, bottom divider, and timestamp with clock icon.
class RecentActivityTile extends StatelessWidget {
  final ActivityItem activity;
  final bool showDivider;

  const RecentActivityTile({
    super.key,
    required this.activity,
    this.showDivider = true,
  });

  IconData get _icon {
    switch (activity.type) {
      case ActivityType.tenantJoined:
        return Icons.person_add_rounded;
      case ActivityType.complaintRaised:
        return Icons.report_problem_rounded;
      case ActivityType.paymentReceived:
        return Icons.currency_rupee_rounded;
      case ActivityType.leaveNotice:
        return Icons.exit_to_app_rounded;
      case ActivityType.tenantApproval:
        return Icons.pending_actions_rounded;
      case ActivityType.noticeIssued:
        return Icons.campaign_rounded;
    }
  }

  Color get _color {
    switch (activity.type) {
      case ActivityType.tenantJoined:
        return AppColors.success;
      case ActivityType.complaintRaised:
        return AppColors.error;
      case ActivityType.paymentReceived:
        return AppColors.success;
      case ActivityType.leaveNotice:
        return AppColors.warning;
      case ActivityType.tenantApproval:
        return AppColors.info;
      case ActivityType.noticeIssued:
        return AppColors.primaryOrange;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          child: Row(
            children: [
              // Circular icon background
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: _color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(_icon, color: _color, size: AppSpacing.iconMd),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity.title,
                      style: AppTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      activity.description,
                      style: AppTextStyles.caption.copyWith(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              // Timestamp with clock icon
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    size: 11,
                    color: isDark
                        ? AppColors.darkTextTertiary
                        : AppColors.lightTextTertiary,
                  ),
                  const SizedBox(width: AppSpacing.xxs),
                  Text(
                    Formatters.relative(activity.timestamp),
                    style: AppTextStyles.caption.copyWith(
                      fontSize: 11,
                      color: isDark
                          ? AppColors.darkTextTertiary
                          : AppColors.lightTextTertiary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Bottom divider for separation
        if (showDivider)
          Divider(
            height: 1,
            thickness: 0.5,
            color: isDark
                ? AppColors.darkGlassBorder.withValues(alpha: 0.15)
                : AppColors.lightGlassBorder.withValues(alpha: 0.4),
          ),
      ],
    );
  }
}
