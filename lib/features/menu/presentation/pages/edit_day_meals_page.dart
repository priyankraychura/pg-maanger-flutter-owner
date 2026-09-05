import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/glass_app_bar.dart';
import '../../../../core/widgets/glass_button.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/glass_text_field.dart';
import '../../../../core/widgets/gradient_background.dart';
import '../../domain/entities/meal_entity.dart';
import '../../domain/entities/menu_plan_entity.dart';
import '../providers/menu_provider.dart';
import 'menu_day_labels.dart';

/// Navigation payload for [EditDayMealsPage].
class EditDayMealsArgs {
  final MenuPlanEntity plan;
  final int dayNumber;
  const EditDayMealsArgs({required this.plan, required this.dayNumber});
}

/// Edits every meal slot for a single day of the menu cycle.
class EditDayMealsPage extends ConsumerStatefulWidget {
  final EditDayMealsArgs args;

  const EditDayMealsPage({super.key, required this.args});

  @override
  ConsumerState<EditDayMealsPage> createState() => _EditDayMealsPageState();
}

class _EditDayMealsPageState extends ConsumerState<EditDayMealsPage> {
  final _formKey = GlobalKey<FormState>();
  late final Map<MealSlot, _SlotControllers> _controllers;
  bool _submitting = false;

  MenuPlanEntity get _plan => widget.args.plan;
  int get _dayNumber => widget.args.dayNumber;

  @override
  void initState() {
    super.initState();
    final day = _plan.dayByNumber(_dayNumber);
    _controllers = {
      for (final slot in _plan.slots)
        slot: _SlotControllers.fromMeal(slot, day?.mealFor(slot)),
    };
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() => _submitting = true);

    final meals = <MealSlot, MealTime>{};
    for (final entry in _controllers.entries) {
      final c = entry.value;
      final mainDish = c.mainDish.text.trim();
      final sides = c.sideItems.text
          .split(',')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();
      // Skip a slot only when it is entirely blank.
      if (mainDish.isEmpty && sides.isEmpty) continue;
      meals[entry.key] = MealTime(
        mainDish: mainDish,
        sideItems: sides,
        timeSlot: c.timeSlot.text.trim(),
      );
    }

    try {
      await saveDayMeals(ref, dayNumber: _dayNumber, meals: meals);
      if (!mounted) return;
      context.showSnackBar('Menu saved');
      if (Navigator.canPop(context)) Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      context.showSnackBar('Could not save menu: $e', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final label = dayLabel(_plan, _dayNumber);

    return Scaffold(
      appBar: GlassAppBar(
        title: label.title,
        subtitle: label.subtitle,
        showBackButton: true,
      ),
      body: GradientBackground(
        child: SafeArea(
          top: false,
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenPadding,
                AppSpacing.lg,
                AppSpacing.screenPadding,
                AppSpacing.xxl,
              ),
              children: [
                for (final slot in _plan.slots) ...[
                  _slotCard(slot),
                  const SizedBox(height: AppSpacing.lg),
                ],
                const SizedBox(height: AppSpacing.xs),
                GlassButton(
                  label: 'Save Menu',
                  icon: Icons.check_rounded,
                  isLoading: _submitting,
                  onPressed: _handleSubmit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _slotCard(MealSlot slot) {
    final c = _controllers[slot]!;
    return GlassCard(
      animate: false,
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.accentTeal.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                child: Icon(slot.icon,
                    size: AppSpacing.iconMd, color: AppColors.accentTeal),
              ),
              const SizedBox(width: AppSpacing.md),
              Text(
                slot.label,
                style: AppTextStyles.h3.copyWith(
                  color: context.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          GlassTextField(
            controller: c.mainDish,
            label: 'Main Dish',
            hint: 'e.g. Paneer Masala',
            prefixIcon: Icons.restaurant_menu_rounded,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: AppSpacing.md),
          GlassTextField(
            controller: c.sideItems,
            label: 'Side Items',
            hint: 'Comma separated · e.g. Roti, Rice, Salad',
            prefixIcon: Icons.rice_bowl_rounded,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: AppSpacing.md),
          GlassTextField(
            controller: c.timeSlot,
            label: 'Serving Time',
            hint: 'e.g. 7:30 - 9:00 AM',
            prefixIcon: Icons.schedule_rounded,
            textInputAction: TextInputAction.next,
          ),
        ],
      ),
    );
  }
}

class _SlotControllers {
  final TextEditingController mainDish;
  final TextEditingController sideItems;
  final TextEditingController timeSlot;

  _SlotControllers({
    required this.mainDish,
    required this.sideItems,
    required this.timeSlot,
  });

  factory _SlotControllers.fromMeal(MealSlot slot, MealTime? meal) {
    return _SlotControllers(
      mainDish: TextEditingController(text: meal?.mainDish ?? ''),
      sideItems:
          TextEditingController(text: meal?.sideItems.join(', ') ?? ''),
      timeSlot: TextEditingController(
          text: meal?.timeSlot ?? slot.defaultTimeSlot),
    );
  }

  void dispose() {
    mainDish.dispose();
    sideItems.dispose();
    timeSlot.dispose();
  }
}
