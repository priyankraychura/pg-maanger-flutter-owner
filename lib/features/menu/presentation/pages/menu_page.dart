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
import '../../../../core/widgets/section_header.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../domain/entities/meal_entity.dart';
import '../../domain/entities/menu_plan_entity.dart';
import '../providers/menu_provider.dart';
import 'edit_day_meals_page.dart';
import 'menu_day_labels.dart';

class MenuPage extends ConsumerWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canEdit = ref.watch(accessPolicyProvider).canEdit(AppModule.menu);
    final planAsync = ref.watch(menuPlanProvider);
    final plan = planAsync.valueOrNull;

    return Scaffold(
      appBar: GlassAppBar(
        title: 'Mess Menu',
        subtitle: plan != null ? 'Weekly meal plan' : null,
        showBackButton: true,
        actionIcon: (canEdit && plan != null) ? Icons.edit_rounded : null,
        actionTooltip: 'Edit menu plan',
        onActionPressed: (canEdit && plan != null)
            ? () => context.push('/menu/configure', extra: plan)
            : null,
      ),
      body: PermissionGuard(
        module: AppModule.menu,
        child: planAsync.when(
          loading: () => const CommonLoader(),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (plan) {
            if (plan == null) {
              return EmptyState(
                icon: Icons.restaurant_menu_rounded,
                title: 'No Menu Configured',
                subtitle: canEdit
                    ? 'Set up a repeating meal plan for your PG.'
                    : 'A mess menu has not been set up yet.',
                actionLabel: canEdit ? 'Create Menu' : null,
                actionIcon: canEdit ? Icons.add_rounded : null,
                primaryAction: true,
                onAction:
                    canEdit ? () => context.push('/menu/configure') : null,
              );
            }
            return _MenuPlanView(plan: plan, canEdit: canEdit);
          },
        ),
      ),
    );
  }
}

class _MenuPlanView extends ConsumerWidget {
  final MenuPlanEntity plan;
  final bool canEdit;

  const _MenuPlanView({required this.plan, required this.canEdit});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todayCycleDay = plan.cycleDayFor(DateTime.now());

    return RefreshIndicator(
      color: AppColors.primaryOrange,
      onRefresh: () async {
        ref.invalidate(menuPlanProvider);
        await ref.read(menuPlanProvider.future).catchError((_) => null);
      },
      child: ListView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.screenPadding,
          AppSpacing.lg,
          AppSpacing.screenPadding,
          context.bottomPadding + AppSpacing.xxl,
        ),
        children: [
          _PlanSummaryCard(plan: plan, todayCycleDay: todayCycleDay),
          const SizedBox(height: AppSpacing.xxl),
          for (var week = 1; week <= plan.cycleWeeks; week++) ...[
            if (plan.cycleWeeks > 1) SectionHeader(title: 'Week $week'),
            for (final day in plan.days.where((d) => d.weekNumber == week))
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: _DayCard(
                  plan: plan,
                  day: day,
                  isToday: day.dayNumber == todayCycleDay,
                  canEdit: canEdit,
                  onTap: canEdit
                      ? () => context.push(
                            '/menu/day',
                            extra: EditDayMealsArgs(
                              plan: plan,
                              dayNumber: day.dayNumber,
                            ),
                          )
                      : null,
                ),
              ),
          ],
        ],
      ),
    );
  }
}

/// Top card summarizing the cycle, meal count, start date, and today's day.
class _PlanSummaryCard extends StatelessWidget {
  final MenuPlanEntity plan;
  final int todayCycleDay;

  const _PlanSummaryCard({required this.plan, required this.todayCycleDay});

  @override
  Widget build(BuildContext context) {
    final todayLabel = dayLabel(plan, todayCycleDay);
    final weekLabel =
        plan.cycleWeeks == 1 ? '1-week cycle' : '${plan.cycleWeeks}-week cycle';

    return GlassCard(
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _chip(context, Icons.repeat_rounded, weekLabel),
              const SizedBox(width: AppSpacing.sm),
              _chip(context, Icons.restaurant_rounded,
                  '${plan.mealsPerDay} meals/day'),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Icon(Icons.event_rounded,
                  size: AppSpacing.iconSm, color: context.textTertiary),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  'Repeats every ${plan.cycleWeeks == 1 ? 'week' : '${plan.cycleWeeks} weeks'} '
                  'from ${plan.startDate.formatted}',
                  style: AppTextStyles.bodySmall
                      .copyWith(color: context.textSecondary),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.primaryOrange.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Row(
              children: [
                const Icon(Icons.today_rounded,
                    size: AppSpacing.iconMd, color: AppColors.primaryOrange),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Today · ${todayLabel.title}',
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w700,
                          color: context.textPrimary,
                        ),
                      ),
                      Text(
                        todayLabel.subtitle,
                        style: AppTextStyles.caption
                            .copyWith(color: context.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(BuildContext context, IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: context.isDark
            ? AppColors.darkSurface.withValues(alpha: 0.5)
            : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusRound),
        border: Border.all(
          color: context.isDark
              ? AppColors.darkGlassBorder.withValues(alpha: 0.3)
              : AppColors.lightGlassBorder,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: AppSpacing.iconSm, color: AppColors.primaryOrange),
          const SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              fontWeight: FontWeight.w600,
              color: context.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

/// One day of the cycle, listing each served meal slot.
class _DayCard extends StatelessWidget {
  final MenuPlanEntity plan;
  final MealEntity day;
  final bool isToday;
  final bool canEdit;
  final VoidCallback? onTap;

  const _DayCard({
    required this.plan,
    required this.day,
    required this.isToday,
    required this.canEdit,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final label = dayLabel(plan, day.dayNumber);

    return GlassCard(
      onTap: onTap,
      margin: EdgeInsets.zero,
      borderColor: isToday ? AppColors.primaryOrange : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label.title,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w700,
                    color: context.textPrimary,
                  ),
                ),
              ),
              if (isToday) ...[
                const StatusBadge(
                  label: 'Today',
                  type: StatusType.success,
                  small: true,
                ),
                const SizedBox(width: AppSpacing.sm),
              ],
              if (canEdit)
                Icon(Icons.chevron_right_rounded,
                    size: AppSpacing.iconMd, color: context.textTertiary),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          for (final slot in plan.slots) ...[
            _slotRow(context, slot, day.mealFor(slot)),
            if (slot != plan.slots.last)
              const SizedBox(height: AppSpacing.sm),
          ],
        ],
      ),
    );
  }

  Widget _slotRow(BuildContext context, MealSlot slot, MealTime? meal) {
    final hasMeal = meal != null && !meal.isEmpty;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(slot.icon,
            size: AppSpacing.iconSm,
            color: hasMeal ? AppColors.accentTeal : context.textTertiary),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    slot.label,
                    style: AppTextStyles.caption.copyWith(
                      fontWeight: FontWeight.w600,
                      color: context.textTertiary,
                    ),
                  ),
                  if (hasMeal && meal.timeSlot.isNotEmpty) ...[
                    Text(
                      '  ·  ${meal.timeSlot}',
                      style: AppTextStyles.caption
                          .copyWith(color: context.textTertiary),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 1),
              if (hasMeal)
                Text(
                  [
                    meal.mainDish,
                    if (meal.sideItems.isNotEmpty) meal.sideItems.join(', '),
                  ].where((s) => s.trim().isNotEmpty).join('  ·  '),
                  style: AppTextStyles.body.copyWith(color: context.textPrimary),
                )
              else
                Text(
                  'Not set',
                  style: AppTextStyles.body.copyWith(
                    color: context.textTertiary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
