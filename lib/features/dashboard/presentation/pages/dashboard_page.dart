import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/common_loader.dart';
import '../../../../core/widgets/stat_card.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/providers/pg_selection_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../pg_management/presentation/providers/pg_provider.dart';
import '../providers/dashboard_provider.dart';
import '../../domain/entities/dashboard_entity.dart';
import '../widgets/quick_action_card.dart';
import '../widgets/recent_activity_tile.dart';

/// Owner dashboard page with PG stats, quick actions, and activity feed.
class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final owner = ref.watch(currentOwnerProvider);
    final pgsAsync = ref.watch(pgListProvider);
    final selectedPgId = ref.watch(pgSelectionProvider);
    final dashboardAsync = ref.watch(dashboardProvider);

    return Scaffold(
      body: SafeArea(
        child: pgsAsync.when(
          loading: () => const CommonLoader(message: 'Loading...'),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (pgs) {
            // Auto-select first PG if none selected
            if (selectedPgId == null && pgs.isNotEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ref.read(pgSelectionProvider.notifier).selectPg(pgs.first.id);
              });
              return const CommonLoader(message: 'Loading...');
            }

            final selectedPg = pgs.where((pg) => pg.id == selectedPgId).firstOrNull;

            return RefreshIndicator(
              color: AppColors.primaryOrange,
              onRefresh: () async {
                ref.invalidate(dashboardProvider);
                ref.invalidate(pgListProvider);
              },
              child: CustomScrollView(
                slivers: [
                  // ─── Header ─────────────────────────────────
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.screenPadding,
                        AppSpacing.lg,
                        AppSpacing.screenPadding,
                        0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Welcome back,',
                                      style: AppTextStyles.body.copyWith(
                                        color: isDark
                                            ? AppColors.darkTextSecondary
                                            : AppColors.lightTextSecondary,
                                      ),
                                    ),
                                    Text(
                                      owner?.name ?? 'Owner',
                                      style: AppTextStyles.h1.copyWith(
                                        color: isDark
                                            ? AppColors.darkTextPrimary
                                            : AppColors.lightTextPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () => context.push('/settings'),
                                child: Container(
                                  padding: const EdgeInsets.all(AppSpacing.md),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? AppColors.darkSurface
                                        : AppColors.lightSurface,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isDark
                                          ? AppColors.darkGlassBorder
                                          : AppColors.lightGlassBorder,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.notifications_outlined,
                                    color: isDark
                                        ? AppColors.darkTextPrimary
                                        : AppColors.lightTextPrimary,
                                    size: AppSpacing.iconLg,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.lg),

                          // PG Switcher
                          if (pgs.length > 1)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.lg,
                                vertical: AppSpacing.xs,
                              ),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppColors.darkSurface.withValues(alpha: 0.85)
                                    : AppColors.lightSurface.withValues(alpha: 0.85),
                                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                                border: Border.all(
                                  color: isDark
                                      ? AppColors.darkGlassBorder.withValues(alpha: 0.15)
                                      : AppColors.lightGlassBorder.withValues(alpha: 0.3),
                                ),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: selectedPgId,
                                  isExpanded: true,
                                  icon: const Icon(Icons.keyboard_arrow_down_rounded),
                                  style: AppTextStyles.bodyLarge.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: isDark
                                        ? AppColors.darkTextPrimary
                                        : AppColors.lightTextPrimary,
                                  ),
                                  dropdownColor: isDark
                                      ? AppColors.darkSurface
                                      : AppColors.lightSurface,
                                  items: pgs.map((pg) {
                                    return DropdownMenuItem(
                                      value: pg.id,
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.apartment_rounded,
                                            size: AppSpacing.iconMd,
                                            color: AppColors.primaryOrange,
                                          ),
                                          const SizedBox(width: AppSpacing.sm),
                                          Expanded(
                                            child: Text(
                                              pg.name,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    if (value != null) {
                                      ref.read(pgSelectionProvider.notifier).selectPg(value);
                                    }
                                  },
                                ),
                              ),
                            )
                          else if (selectedPg != null)
                            Row(
                              children: [
                                Icon(
                                  Icons.apartment_rounded,
                                  size: AppSpacing.iconMd,
                                  color: AppColors.primaryOrange,
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                Text(
                                  selectedPg.name,
                                  style: AppTextStyles.bodyLarge.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primaryOrange,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),

                  // ─── Stats Grid ─────────────────────────────
                  SliverToBoxAdapter(
                    child: dashboardAsync.when(
                      loading: () => const Padding(
                        padding: EdgeInsets.all(AppSpacing.huge),
                        child: CommonLoader(),
                      ),
                      error: (e, _) => Padding(
                        padding: const EdgeInsets.all(AppSpacing.xxl),
                        child: Center(child: Text('Error loading dashboard: $e')),
                      ),
                      data: (data) => _DashboardContent(data: data),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  final OwnerDashboardEntity data;

  const _DashboardContent({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.xxl),

          // Stats Grid
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: AppSpacing.md,
            mainAxisSpacing: AppSpacing.md,
            childAspectRatio: 1.15,
            children: [
              StatCard(
                icon: Icons.bed_rounded,
                label: 'Total Beds',
                value: '${data.totalBeds}',
                iconColor: AppColors.primaryOrange,
              ),
              StatCard(
                icon: Icons.check_circle_rounded,
                label: 'Occupied',
                value: '${data.occupiedBeds}',
                iconColor: AppColors.success,
                trend: '${data.collectionRate.toStringAsFixed(0)}%',
                isTrendPositive: true,
              ),
              StatCard(
                icon: Icons.hotel_rounded,
                label: 'Available',
                value: '${data.availableBeds}',
                iconColor: AppColors.info,
              ),
              StatCard(
                icon: Icons.people_rounded,
                label: 'Tenants',
                value: '${data.totalTenants}',
                iconColor: AppColors.accentTeal,
              ),
              StatCard(
                icon: Icons.pending_actions_rounded,
                label: 'Pending Approvals',
                value: '${data.pendingApprovals}',
                iconColor: AppColors.warning,
              ),
              StatCard(
                icon: Icons.currency_rupee_rounded,
                label: 'Revenue',
                value: Formatters.currency(data.totalRevenue),
                iconColor: AppColors.success,
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.xxl),

          // Quick Actions
          const SectionHeader(title: 'Quick Actions'),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                QuickActionCard(
                  icon: Icons.person_add_rounded,
                  label: 'Add Tenant',
                  color: AppColors.primaryOrange,
                  onTap: () => context.push('/invitations'),
                ),
                const SizedBox(width: AppSpacing.md),
                QuickActionCard(
                  icon: Icons.campaign_rounded,
                  label: 'Issue Notice',
                  color: AppColors.info,
                  onTap: () => context.push('/notices'),
                ),
                const SizedBox(width: AppSpacing.md),
                QuickActionCard(
                  icon: Icons.report_problem_rounded,
                  label: 'Complaints',
                  color: AppColors.warning,
                  onTap: () => context.push('/complaints'),
                ),
                const SizedBox(width: AppSpacing.md),
                QuickActionCard(
                  icon: Icons.restaurant_menu_rounded,
                  label: 'Menu',
                  color: AppColors.accentTeal,
                  onTap: () => context.push('/menu'),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xxl),

          // Pending Approvals
          if (data.pendingApprovals > 0) ...[
            GlassCard(
              onTap: () => context.push('/tenants'),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    ),
                    child: const Icon(
                      Icons.pending_actions_rounded,
                      color: AppColors.warning,
                      size: AppSpacing.iconLg,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${data.pendingApprovals} Pending Approvals',
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xxs),
                        Text(
                          'Review tenant applications',
                          style: AppTextStyles.caption.copyWith(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  StatusBadge(
                    label: 'Review',
                    type: StatusType.warning,
                    small: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],

          // Recent Activity
          SectionHeader(
            title: 'Recent Activity',
            actionLabel: 'View All',
            onAction: () => context.push('/recent-activity'),
          ),
          ...data.recentActivity.take(5).map(
            (activity) => RecentActivityTile(activity: activity),
          ),

          const SizedBox(height: AppSpacing.massive + AppSpacing.xxl),
        ],
      ),
    );
  }
}
