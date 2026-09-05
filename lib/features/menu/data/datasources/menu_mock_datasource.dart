import '../../../../core/constants/app_constants.dart';
import '../../../../mock_database/mock_database.dart';
import '../../../../mock_database/tables/owners_table.dart';
import '../../domain/entities/meal_entity.dart';
import '../../domain/entities/menu_plan_entity.dart';
import '../../domain/repositories/menu_repository.dart';

class MenuMockDatasource implements MenuRepository {
  List<MenuPlanEntity> get _plans => MockDatabase.instance.menuPlans;

  int _indexFor(String pgId) => _plans.indexWhere((p) => p.pgId == pgId);

  @override
  Future<MenuPlanEntity?> getMenuPlan(String pgId) async {
    await Future.delayed(
        const Duration(milliseconds: AppConstants.mockApiDelay));
    final index = _indexFor(pgId);
    return index == -1 ? null : _plans[index];
  }

  @override
  Future<MenuPlanEntity> saveMenuPlan({
    required String pgId,
    required int cycleWeeks,
    required int mealsPerDay,
    required DateTime startDate,
  }) async {
    await Future.delayed(
        const Duration(milliseconds: AppConstants.mockApiDelay));

    final now = DateTime.now();
    final totalDays = cycleWeeks * 7;
    final servedSlots = mealSlotsForCount(mealsPerDay).toSet();
    final index = _indexFor(pgId);
    final existing = index == -1 ? null : _plans[index];

    // Rebuild the day scaffold, carrying over anything that still fits.
    final days = List.generate(totalDays, (i) {
      final dayNumber = i + 1;
      final prior = existing?.dayByNumber(dayNumber);
      // Keep only meals for slots this plan still serves.
      final meals = <MealSlot, MealTime>{
        if (prior != null)
          for (final entry in prior.meals.entries)
            if (servedSlots.contains(entry.key)) entry.key: entry.value,
      };
      return MealEntity(
        id: prior?.id ?? 'm_${pgId}_$dayNumber',
        pgId: pgId,
        dayNumber: dayNumber,
        meals: meals,
        lastUpdated: now,
        updatedBy: kPrimaryOwnerId,
      );
    });

    final plan = MenuPlanEntity(
      id: existing?.id ?? 'menu_$pgId',
      pgId: pgId,
      cycleWeeks: cycleWeeks,
      mealsPerDay: mealsPerDay,
      startDate: startDate,
      days: days,
      lastUpdated: now,
      updatedBy: kPrimaryOwnerId,
    );

    if (index == -1) {
      _plans.add(plan);
    } else {
      _plans[index] = plan;
    }
    return plan;
  }

  @override
  Future<MenuPlanEntity> updateDayMeals(
    String pgId,
    int dayNumber,
    Map<MealSlot, MealTime> meals,
  ) async {
    await Future.delayed(
        const Duration(milliseconds: AppConstants.mockApiDelay));

    final index = _indexFor(pgId);
    if (index == -1) {
      throw Exception('No menu plan configured for this PG');
    }
    final plan = _plans[index];
    final now = DateTime.now();
    final days = plan.days
        .map((d) => d.dayNumber == dayNumber
            ? d.copyWith(meals: meals, lastUpdated: now, updatedBy: kPrimaryOwnerId)
            : d)
        .toList();

    final updated = plan.copyWith(days: days, lastUpdated: now);
    _plans[index] = updated;
    return updated;
  }
}
