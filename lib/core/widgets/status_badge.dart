import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// A small badge for displaying status (Paid, Pending, Active, etc.)
class StatusBadge extends StatelessWidget {
  final String label;
  final StatusType type;
  final bool small;

  const StatusBadge({
    super.key,
    required this.label,
    this.type = StatusType.info,
    this.small = false,
  });

  Color get _backgroundColor {
    switch (type) {
      case StatusType.success:
        return AppColors.success.withValues(alpha: 0.15);
      case StatusType.warning:
        return AppColors.warning.withValues(alpha: 0.15);
      case StatusType.error:
        return AppColors.error.withValues(alpha: 0.15);
      case StatusType.info:
        return AppColors.info.withValues(alpha: 0.15);
      case StatusType.neutral:
        return Colors.grey.withValues(alpha: 0.15);
    }
  }

  Color get _textColor {
    switch (type) {
      case StatusType.success:
        return AppColors.success;
      case StatusType.warning:
        return const Color(0xFFFF8F00);
      case StatusType.error:
        return AppColors.error;
      case StatusType.info:
        return AppColors.info;
      case StatusType.neutral:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? AppSpacing.sm : AppSpacing.md,
        vertical: small ? AppSpacing.xxs : AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusRound),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: small ? 10 : 12,
          fontWeight: FontWeight.w600,
          color: _textColor,
        ),
      ),
    );
  }
}

enum StatusType { success, warning, error, info, neutral }
