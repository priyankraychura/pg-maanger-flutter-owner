import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/pg_selection_provider.dart';
import '../../../../injection/service_locator.dart';
import '../../domain/entities/meal_entity.dart';
import '../../domain/entities/menu_plan_entity.dart';
import '../../domain/repositories/menu_repository.dart';

/// The menu plan for the currently selected PG.
///
/// Resolves to `null` when the PG has no plan configured yet — the page turns
/// that into a "create menu" empty state.
final menuPlanProvider =
    FutureProvider.autoDispose<MenuPlanEntity?>((ref) async {
  final pgId = ref.watch(pgSelectionProvider);
  if (pgId == null) return null;
  return getIt<MenuRepository>().getMenuPlan(pgId);
});

/// Creates or reconfigures the plan for the selected PG, then refreshes
/// [menuPlanProvider].
Future<void> saveMenuPlan(
  WidgetRef ref, {
  required int cycleWeeks,
  required int mealsPerDay,
  required DateTime startDate,
}) async {
  final pgId = ref.read(pgSelectionProvider);
  if (pgId == null) throw Exception('No PG selected');
  await getIt<MenuRepository>().saveMenuPlan(
    pgId: pgId,
    cycleWeeks: cycleWeeks,
    mealsPerDay: mealsPerDay,
    startDate: startDate,
  );
  ref.invalidate(menuPlanProvider);
}

/// Saves the meals for a single day of the plan, then refreshes
/// [menuPlanProvider].
Future<void> saveDayMeals(
  WidgetRef ref, {
  required int dayNumber,
  required Map<MealSlot, MealTime> meals,
}) async {
  final pgId = ref.read(pgSelectionProvider);
  if (pgId == null) throw Exception('No PG selected');
  await getIt<MenuRepository>().updateDayMeals(pgId, dayNumber, meals);
  ref.invalidate(menuPlanProvider);
}
