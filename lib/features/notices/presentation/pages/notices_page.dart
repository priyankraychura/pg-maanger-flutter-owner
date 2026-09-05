import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/extensions/date_extensions.dart';
import '../../../../core/rbac/access_provider.dart';
import '../../../../core/rbac/app_module.dart';
import '../../../../core/rbac/permission_guard.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/common_loader.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/glass_app_bar.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../domain/entities/notice_entity.dart';
import '../providers/notice_provider.dart';

class NoticesPage extends ConsumerWidget {
  const NoticesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canEdit = ref.watch(accessPolicyProvider).canEdit(AppModule.notices);
    final noticesAsync = ref.watch(noticesProvider);

    return Scaffold(
      appBar: GlassAppBar(
        title: 'Notices',
        showBackButton: true,
        actionIcon: canEdit ? Icons.add_alert_rounded : null,
        actionTooltip: 'New Notice',
        onActionPressed: canEdit ? () => context.push('/notices/create') : null,
      ),
      body: PermissionGuard(
        module: AppModule.notices,
        child: noticesAsync.when(
          loading: () => const CommonLoader(),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (notices) {
            if (notices.isEmpty) {
              return EmptyState(
                icon: Icons.campaign_outlined,
                title: 'No Notices Found',
                subtitle: 'There are no active broadcast notices.',
                actionLabel: canEdit ? 'Issue New Notice' : null,
                actionIcon: canEdit ? Icons.add_alert_rounded : null,
                primaryAction: true,
                onAction: canEdit ? () => context.push('/notices/create') : null,
              );
            }

            return RefreshIndicator(
              color: AppColors.primaryOrange,
              onRefresh: () async {
                ref.invalidate(noticesProvider);
                await ref.read(noticesProvider.future).catchError((_) => <NoticeEntity>[]);
              },
              child: ListView.builder(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.screenPadding,
                  AppSpacing.screenPadding,
                  AppSpacing.screenPadding,
                  context.bottomNavInset,
                ),
                itemCount: notices.length,
                itemBuilder: (context, index) =>
                    _NoticeCard(notice: notices[index]),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _NoticeCard extends StatelessWidget {
  final NoticeEntity notice;

  const _NoticeCard({required this.notice});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final category = NoticeCategoryInfo.fromKey(notice.category);

    return GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.info.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.campaign_rounded,
                    color: AppColors.info,
                    size: AppSpacing.iconMd,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    notice.title,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.textPrimary,
                    ),
                  ),
                ),
                StatusBadge(
                  label: category.label,
                  type: StatusType.info,
                  small: true,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              notice.description,
              style: AppTextStyles.body.copyWith(color: context.textSecondary),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Icon(
                  Icons.schedule_rounded,
                  size: 14,
                  color: isDark
                      ? AppColors.darkTextTertiary
                      : AppColors.lightTextTertiary,
                ),
                const SizedBox(width: AppSpacing.xxs),
                Text(
                  notice.createdAt.formatted,
                  style: AppTextStyles.caption.copyWith(
                    color: context.textTertiary,
                  ),
                ),
              ],
            ),
          ],
        ),
    );
  }
}
