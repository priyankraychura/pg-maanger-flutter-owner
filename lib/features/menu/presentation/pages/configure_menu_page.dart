import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/extensions/date_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/glass_app_bar.dart';
import '../../../../core/widgets/glass_button.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/gradient_background.dart';
import '../../domain/entities/menu_plan_entity.dart';
import '../providers/menu_provider.dart';

/// Sets up (or reconfigures) a PG's repeating mess-menu plan: how many weeks
/// the cycle runs, how many meals are served each day, and the date the cycle
/// starts repeating from.
///
/// Opened with the existing [MenuPlanEntity] as `extra` when editing, or `null`
/// when creating a new plan.
class ConfigureMenuPage extends ConsumerStatefulWidget {
  final MenuPlanEntity? existing;

  const ConfigureMenuPage({super.key, this.existing});

  @override
  ConsumerState<ConfigureMenuPage> createState() => _ConfigureMenuPageState();
}

class _ConfigureMenuPageState extends ConsumerState<ConfigureMenuPage> {
  late int _cycleWeeks;
  late int _mealsPerDay;
  late DateTime _startDate;
  bool _submitting = false;

  bool get _isEditing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _cycleWeeks = existing?.cycleWeeks ?? 1;
    _mealsPerDay = existing?.mealsPerDay ?? 3;
    _startDate = existing?.startDate ?? DateTime.now();
  }

  Future<void> _pickStartDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 2),
      helpText: 'Menu start date',
    );
    if (picked != null) setState(() => _startDate = picked);
  }

  Future<void> _handleSubmit() async {
    FocusScope.of(context).unfocus();
    setState(() => _submitting = true);
    try {
      await saveMenuPlan(
        ref,
        cycleWeeks: _cycleWeeks,
        mealsPerDay: _mealsPerDay,
        startDate: DateTime(_startDate.year, _startDate.month, _startDate.day),
      );
      if (!mounted) return;
      context.showSnackBar(_isEditing ? 'Menu updated' : 'Menu created');
      if (Navigator.canPop(context)) Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      context.showSnackBar('Could not save menu: $e', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final willReshape = _isEditing &&
        (widget.existing!.cycleWeeks != _cycleWeeks ||
            widget.existing!.mealsPerDay != _mealsPerDay);

    return Scaffold(
      appBar: GlassAppBar(
        title: _isEditing ? 'Edit Menu Plan' : 'Create Menu',
        subtitle: 'Set the cycle, meals, and start date',
        showBackButton: true,
      ),
      body: GradientBackground(
        child: SafeArea(
          top: false,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenPadding,
              AppSpacing.lg,
              AppSpacing.screenPadding,
              AppSpacing.xxl,
            ),
            children: [
              _section(
                title: 'Menu Cycle',
                icon: Icons.repeat_rounded,
                children: [
                  Text(
                    'How many weeks does the menu run before it repeats?',
                    style: AppTextStyles.bodySmall
                        .copyWith(color: context.textSecondary),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _SegmentedSelector<int>(
                    value: _cycleWeeks,
                    options: const [
                      _SegOption(1, '1 Week', '7-day cycle'),
                      _SegOption(2, '2 Weeks', '14-day cycle'),
                    ],
                    onChanged: (v) => setState(() => _cycleWeeks = v),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              _section(
                title: 'Meals Per Day',
                icon: Icons.restaurant_rounded,
                children: [
                  Text(
                    'Number of meals served each day.',
                    style: AppTextStyles.bodySmall
                        .copyWith(color: context.textSecondary),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _SegmentedSelector<int>(
                    value: _mealsPerDay,
                    options: const [
                      _SegOption(3, '3 Meals', 'Breakfast · Lunch · Dinner'),
                      _SegOption(4, '4 Meals', '+ Evening Snacks'),
                    ],
                    onChanged: (v) => setState(() => _mealsPerDay = v),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              _section(
                title: 'Start Date',
                icon: Icons.event_rounded,
                children: [
                  Text(
                    'The menu repeats every $_cycleWeeks '
                    '${_cycleWeeks == 1 ? 'week' : 'weeks'} from this date.',
                    style: AppTextStyles.bodySmall
                        .copyWith(color: context.textSecondary),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  InkWell(
                    onTap: _pickStartDate,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.md,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryOrange.withValues(alpha: 0.08),
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusLg),
                        border: Border.all(
                          color:
                              AppColors.primaryOrange.withValues(alpha: 0.25),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today_rounded,
                              size: AppSpacing.iconMd,
                              color: AppColors.primaryOrange),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Text(
                              '${_startDate.dayName}, ${_startDate.formatted}',
                              style: AppTextStyles.bodyLarge.copyWith(
                                fontWeight: FontWeight.w600,
                                color: context.textPrimary,
                              ),
                            ),
                          ),
                          Text(
                            'Change',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.primaryOrange,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              if (willReshape) ...[
                const SizedBox(height: AppSpacing.lg),
                _reshapeNotice(),
              ],
              const SizedBox(height: AppSpacing.xxl),
              GlassButton(
                label: _isEditing ? 'Save Changes' : 'Create Menu',
                icon: Icons.check_rounded,
                isLoading: _submitting,
                onPressed: _handleSubmit,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _reshapeNotice() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded,
              size: AppSpacing.iconMd, color: AppColors.warning),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'Changing the cycle or meal count reshapes the plan. Existing '
              'meals are kept where they still fit; new days or slots start '
              'empty.',
              style:
                  AppTextStyles.caption.copyWith(color: context.textSecondary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _section({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return GlassCard(
      animate: false,
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(icon,
                  size: AppSpacing.iconMd, color: AppColors.primaryOrange),
              const SizedBox(width: AppSpacing.sm),
              Text(
                title,
                style: AppTextStyles.h3.copyWith(
                  color: context.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          ...children,
        ],
      ),
    );
  }
}

class _SegOption<T> {
  final T value;
  final String label;
  final String hint;
  const _SegOption(this.value, this.label, this.hint);
}

/// A two-or-more option segmented pill selector.
class _SegmentedSelector<T> extends StatelessWidget {
  final T value;
  final List<_SegOption<T>> options;
  final ValueChanged<T> onChanged;

  const _SegmentedSelector({
    required this.value,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < options.length; i++) ...[
          if (i > 0) const SizedBox(width: AppSpacing.md),
          Expanded(child: _tile(context, options[i])),
        ],
      ],
    );
  }

  Widget _tile(BuildContext context, _SegOption<T> option) {
    final selected = option.value == value;
    return InkWell(
      onTap: () => onChanged(option.value),
      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primaryOrange.withValues(alpha: 0.12)
              : (context.isDark
                  ? AppColors.darkSurface.withValues(alpha: 0.5)
                  : AppColors.lightSurface),
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(
            color: selected
                ? AppColors.primaryOrange
                : (context.isDark
                    ? AppColors.darkGlassBorder.withValues(alpha: 0.3)
                    : AppColors.lightGlassBorder),
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  selected
                      ? Icons.radio_button_checked_rounded
                      : Icons.radio_button_unchecked_rounded,
                  size: AppSpacing.iconSm,
                  color: selected
                      ? AppColors.primaryOrange
                      : context.textTertiary,
                ),
                const SizedBox(width: AppSpacing.xs),
                Flexible(
                  child: Text(
                    option.label,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w700,
                      color: selected
                          ? AppColors.primaryOrange
                          : context.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              option.hint,
              style: AppTextStyles.caption.copyWith(color: context.textTertiary),
            ),
          ],
        ),
      ),
    );
  }
}
