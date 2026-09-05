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

import '../../../../core/utils/formatters.dart';
import '../../../../core/rbac/access_policy.dart';
import '../../../../core/rbac/access_provider.dart';
import '../../../../core/rbac/app_module.dart';
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
    final pgsAsync = ref.watch(accessiblePgListProvider);
    final selectedPgId = ref.watch(pgSelectionProvider);
    final dashboardAsync = ref.watch(dashboardProvider);
    final access = ref.watch(accessPolicyProvider);

    return Scaffold(
      body: SafeArea(
        child: pgsAsync.when(
          loading: () => const CommonLoader(message: 'Loading...'),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (pgs) {
            // Select the first accessible PG when none is selected, or when the
            // current selection isn't one this user is allowed to see (e.g.
            // after switching from an owner session to a staff one).
            final selectionValid =
                selectedPgId != null && pgs.any((pg) => pg.id == selectedPgId);
            if (!selectionValid && pgs.isNotEmpty) {
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
                // Wait for the fresh data so the refresh spinner reflects the
                // actual reload instead of vanishing immediately.
                await Future.wait([
                  ref.read(accessiblePgListProvider.future),
                  ref.read(dashboardProvider.future),
                ]).catchError((_) => <Object>[]);
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
                                      'Welcome back 👋',
                                      style: AppTextStyles.bodyLarge.copyWith(
                                        color: isDark
                                            ? AppColors.darkTextSecondary
                                            : AppColors.lightTextSecondary,
                                      ),
                                    ),
                                    const SizedBox(height: AppSpacing.xxs),
                                    Text(
                                      owner?.name ?? 'Owner',
                                      style: AppTextStyles.h1.copyWith(
                                        fontSize: 26,
                                        fontWeight: FontWeight.w700,
                                        color: isDark
                                            ? AppColors.darkTextPrimary
                                            : AppColors.lightTextPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Notification bell with dot badge
                              if (access.canView(AppModule.notices))
                              GestureDetector(
                                onTap: () => context.push('/notices'),
                                child: Stack(
                                  children: [
                                    Container(
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
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black
                                                .withValues(alpha: 0.04),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        Icons.notifications_outlined,
                                        color: isDark
                                            ? AppColors.darkTextPrimary
                                            : AppColors.lightTextPrimary,
                                        size: AppSpacing.iconLg,
                                      ),
                                    ),
                                    // Notification dot
                                    Positioned(
                                      right: 10,
                                      top: 10,
                                      child: Container(
                                        width: 9,
                                        height: 9,
                                        decoration: BoxDecoration(
                                          color: AppColors.error,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: isDark
                                                ? AppColors.darkBackground
                                                : AppColors.lightBackground,
                                            width: 1.5,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.xl),

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
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.03),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
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
                                          Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              color: AppColors.primaryOrange
                                                  .withValues(alpha: 0.1),
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.apartment_rounded,
                                              size: AppSpacing.iconSm,
                                              color: AppColors.primaryOrange,
                                            ),
                                          ),
                                          const SizedBox(width: AppSpacing.md),
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
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.lg,
                                vertical: AppSpacing.md,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryOrange
                                    .withValues(alpha: 0.08),
                                borderRadius:
                                    BorderRadius.circular(AppSpacing.radiusLg),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryOrange
                                          .withValues(alpha: 0.15),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.apartment_rounded,
                                      size: AppSpacing.iconSm,
                                      color: AppColors.primaryOrange,
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.md),
                                  Text(
                                    selectedPg.name,
                                    style: AppTextStyles.bodyLarge.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primaryOrange,
                                    ),
                                  ),
                                ],
                              ),
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

class _DashboardContent extends ConsumerWidget {
  final OwnerDashboardEntity data;

  const _DashboardContent({required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final access = ref.watch(accessPolicyProvider);
    final occupancyPercent = data.totalBeds > 0
        ? (data.occupiedBeds / data.totalBeds)
        : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.xxxl),

          // ─── Overview Header ──────────────────────────
          const SectionHeader(title: 'Overview'),

          // ─── Hero Stat Cards (Primary KPIs) ───────────
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: StatCard(
                    icon: Icons.bed_rounded,
                    label: 'Total Beds',
                    value: '${data.totalBeds}',
                    iconColor: AppColors.primaryOrange,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: StatCard(
                    icon: Icons.check_circle_rounded,
                    label: 'Occupied',
                    value: '${data.occupiedBeds}',
                    iconColor: AppColors.success,
                    trend: '${data.collectionRate.toStringAsFixed(0)}%',
                    isTrendPositive: true,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // ─── Occupancy Progress Bar ────────────────────
          GlassCard(
            margin: EdgeInsets.zero,
            borderRadius: AppSpacing.radiusLg,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Occupancy Rate',
                      style: AppTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                    Text(
                      '${(occupancyPercent * 100).toStringAsFixed(0)}%',
                      style: AppTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryOrange,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusRound),
                  child: LinearProgressIndicator(
                    value: occupancyPercent,
                    minHeight: 8,
                    backgroundColor: isDark
                        ? AppColors.darkGlassBorder.withValues(alpha: 0.15)
                        : AppColors.lightGlassBorder.withValues(alpha: 0.4),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      occupancyPercent > 0.85
                          ? AppColors.success
                          : occupancyPercent > 0.5
                              ? AppColors.primaryOrange
                              : AppColors.warning,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${data.occupiedBeds} occupied',
                      style: AppTextStyles.caption.copyWith(
                        color: isDark
                            ? AppColors.darkTextTertiary
                            : AppColors.lightTextTertiary,
                      ),
                    ),
                    Text(
                      '${data.availableBeds} available',
                      style: AppTextStyles.caption.copyWith(
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

          const SizedBox(height: AppSpacing.lg),

          // ─── Secondary Stats Grid ─────────────────────
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: StatCard(
                    icon: Icons.hotel_rounded,
                    label: 'Available',
                    value: '${data.availableBeds}',
                    iconColor: AppColors.info,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: StatCard(
                    icon: Icons.people_rounded,
                    label: 'Tenants',
                    value: '${data.totalTenants}',
                    iconColor: AppColors.accentTeal,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: StatCard(
                    icon: Icons.pending_actions_rounded,
                    label: 'Pending',
                    value: '${data.pendingApprovals}',
                    iconColor: AppColors.warning,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: StatCard(
                    icon: Icons.currency_rupee_rounded,
                    label: 'Revenue',
                    value: Formatters.currency(data.totalRevenue),
                    iconColor: AppColors.success,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xxxl),

          // ─── Quick Actions ────────────────────────────
          if (_QuickActionsRow.hasAny(access)) ...[
            const SectionHeader(title: 'Quick Actions'),
            _QuickActionsRow(access: access),
            const SizedBox(height: AppSpacing.xxxl),
          ],

          // ─── Pending Approvals Banner ─────────────────
          if (data.pendingApprovals > 0 && access.canView(AppModule.tenants)) ...[
            _PendingApprovalsBanner(
              count: data.pendingApprovals,
              onTap: () => context.push('/tenants'),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],

          // ─── Recent Activity ──────────────────────────
          SectionHeader(
            title: 'Recent Activity',
            actionLabel: 'View All',
            onAction: () => context.push('/recent-activity'),
          ),
          ...data.recentActivity.take(4).toList().asMap().entries.map(
            (entry) => RecentActivityTile(
              activity: entry.value,
              showDivider: entry.key < data.recentActivity.take(4).length - 1,
            ),
          ),

          const SizedBox(height: AppSpacing.massive + AppSpacing.xxl),
        ],
      ),
    );
  }
}

/// A single quick-action, tied to the module it navigates to so it can be
/// hidden when the user lacks access.
class _QuickAction {
  final AppModule module;
  final IconData icon;
  final String label;
  final Color color;
  final String route;
  const _QuickAction(
      this.module, this.icon, this.label, this.color, this.route);
}

/// Quick actions horizontal scroll with gradient fade hint.
///
/// Only actions for modules the user can view are shown.
class _QuickActionsRow extends StatelessWidget {
  final AccessPolicy access;

  const _QuickActionsRow({required this.access});

  static const List<_QuickAction> _actions = [
    _QuickAction(AppModule.invitations, Icons.person_add_rounded, 'Add Tenant',
        AppColors.primaryOrange, '/invitations'),
    _QuickAction(AppModule.notices, Icons.campaign_rounded, 'Notices',
        AppColors.info, '/notices'),
    _QuickAction(AppModule.complaints, Icons.report_problem_rounded,
        'Complaints', AppColors.warning, '/complaints'),
    _QuickAction(AppModule.menu, Icons.restaurant_menu_rounded, 'Menu',
        AppColors.accentTeal, '/menu'),
    _QuickAction(AppModule.payments, Icons.account_balance_wallet_rounded,
        'Payments', AppColors.success, '/payments'),
  ];

  static bool hasAny(AccessPolicy access) =>
      _actions.any((a) => access.canView(a.module));

  @override
  Widget build(BuildContext context) {
    final visible =
        _actions.where((a) => access.canView(a.module)).toList(growable: false);

    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.white,
            Colors.white,
            Colors.white,
            Colors.white.withValues(alpha: 0.0),
          ],
          stops: const [0.0, 0.7, 0.92, 1.0],
        ).createShader(bounds);
      },
      blendMode: BlendMode.dstIn,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(right: AppSpacing.xxxl),
        child: Row(
          children: [
            for (var i = 0; i < visible.length; i++) ...[
              if (i > 0) const SizedBox(width: AppSpacing.md),
              QuickActionCard(
                icon: visible[i].icon,
                label: visible[i].label,
                color: visible[i].color,
                onTap: () => context.push(visible[i].route),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Pending approvals alert banner with accent left border.
class _PendingApprovalsBanner extends StatelessWidget {
  final int count;
  final VoidCallback onTap;

  const _PendingApprovalsBanner({
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GlassCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          // Warning accent strip on the left
          Container(
            width: 4,
            height: 80,
            color: AppColors.warning,
          ),
          const SizedBox(width: AppSpacing.lg),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.pending_actions_rounded,
              color: AppColors.warning,
              size: AppSpacing.iconLg,
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$count Pending Approvals',
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    'Review tenant applications',
                    style: AppTextStyles.caption.copyWith(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.lg),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppSpacing.radiusRound),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Review',
                    style: AppTextStyles.caption.copyWith(
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFFF8F00),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xxs),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 10,
                    color: Color(0xFFFF8F00),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
