import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/common_loader.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/glass_app_bar.dart';
import '../../../../core/widgets/glass_button.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../domain/entities/pg_entity.dart';
import '../providers/pg_provider.dart';

/// Lists the owner's PG properties, and lets them add a new PG or edit the
/// details of an existing one. The first PG shown is the one created when the
/// account was registered.
class PgManagementPage extends ConsumerWidget {
  const PgManagementPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pgsAsync = ref.watch(pgListProvider);

    return Scaffold(
      appBar: const GlassAppBar(
        title: 'Manage PGs',
        subtitle: 'Add or edit your properties',
        showBackButton: true,
      ),
      body: SafeArea(
        top: false,
        child: pgsAsync.when(
          loading: () => const CommonLoader(message: 'Loading properties...'),
          error: (e, _) => Center(child: Text('Error loading PGs: $e')),
          data: (pgs) {
            if (pgs.isEmpty) {
              return EmptyState(
                icon: Icons.business_rounded,
                title: 'No Properties Yet',
                subtitle: 'Add your first PG to start managing it.',
                actionLabel: 'Add New PG',
                actionIcon: Icons.add_home_work_rounded,
                primaryAction: true,
                onAction: () => _openForm(context),
              );
            }

            return RefreshIndicator(
              color: AppColors.primaryOrange,
              onRefresh: () async {
                ref.invalidate(pgListProvider);
                await ref.read(pgListProvider.future).catchError(
                      (_) => <PgEntity>[],
                    );
              },
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenPadding,
                  AppSpacing.lg,
                  AppSpacing.screenPadding,
                  AppSpacing.xxl,
                ),
                children: [
                  ...pgs.map(
                    (pg) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: _PgCard(
                        pg: pg,
                        onEdit: () => _openForm(context, pg: pg),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  GlassButton.outlined(
                    label: 'Add New PG',
                    icon: Icons.add_home_work_rounded,
                    onPressed: () => _openForm(context),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _openForm(BuildContext context, {PgEntity? pg}) {
    context.push('/pg-management/form', extra: pg);
  }
}

class _PgCard extends StatelessWidget {
  final PgEntity pg;
  final VoidCallback onEdit;

  const _PgCard({required this.pg, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: icon, name/city, status
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.primaryOrange.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                child: const Icon(
                  Icons.apartment_rounded,
                  color: AppColors.primaryOrange,
                  size: AppSpacing.iconLg,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pg.name,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w700,
                        color: context.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      '${pg.address}, ${pg.city}',
                      style: AppTextStyles.caption.copyWith(
                        color: context.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              StatusBadge(
                label: pg.isActive ? 'Active' : 'Inactive',
                type: pg.isActive ? StatusType.success : StatusType.neutral,
                small: true,
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          // Stats row
          Row(
            children: [
              _stat(context, Icons.stairs_outlined, '${pg.totalFloors}',
                  'Floors'),
              _stat(context, Icons.meeting_room_outlined, '${pg.totalRooms}',
                  'Rooms'),
              _stat(context, Icons.bed_rounded, '${pg.totalBeds}', 'Beds'),
              _stat(
                context,
                Icons.pie_chart_outline_rounded,
                '${pg.occupancyRate.toStringAsFixed(0)}%',
                'Occupied',
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          GlassButton.outlined(
            label: 'Edit Details',
            icon: Icons.edit_outlined,
            onPressed: onEdit,
          ),
        ],
      ),
    );
  }

  Widget _stat(
    BuildContext context,
    IconData icon,
    String value,
    String label,
  ) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: AppSpacing.iconMd, color: context.textSecondary),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            value,
            style: AppTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.w700,
              color: context.textPrimary,
            ),
          ),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: context.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}
