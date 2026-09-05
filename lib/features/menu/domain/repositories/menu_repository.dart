import '../entities/meal_entity.dart';
import '../entities/menu_plan_entity.dart';

abstract class MenuRepository {
  /// The menu plan for a PG, or `null` if one has not been configured yet.
  Future<MenuPlanEntity?> getMenuPlan(String pgId);

  /// Creates the plan, or updates its configuration.
  ///
  /// Changing [cycleWeeks] or [mealsPerDay] reshapes the day scaffold: days and
  /// meal slots are added or trimmed to match, while existing entries are
  /// preserved wherever they still fit.
  Future<MenuPlanEntity> saveMenuPlan({
    required String pgId,
    required int cycleWeeks,
    required int mealsPerDay,
    required DateTime startDate,
  });

  /// Replaces the meals served on a single [dayNumber] of the plan.
  Future<MenuPlanEntity> updateDayMeals(
    String pgId,
    int dayNumber,
    Map<MealSlot, MealTime> meals,
  );
}
