import 'meal_entity.dart';

/// A repeating mess-menu plan for a PG.
///
/// The plan runs on a fixed [cycleWeeks] cycle (1 or 2 weeks) that repeats
/// indefinitely from [startDate]. Each of the [totalDays] days carries its own
/// meals; every day serves the same [mealsPerDay] slots (3 or 4).
class MenuPlanEntity {
  final String id;
  final String pgId;
  final int cycleWeeks; // 1 or 2
  final int mealsPerDay; // 3 or 4
  final DateTime startDate;
  final List<MealEntity> days; // length == totalDays, sorted by dayNumber
  final DateTime lastUpdated;
  final String updatedBy;

  const MenuPlanEntity({
    required this.id,
    required this.pgId,
    required this.cycleWeeks,
    required this.mealsPerDay,
    required this.startDate,
    required this.days,
    required this.lastUpdated,
    required this.updatedBy,
  });

  /// Total number of days in one full cycle.
  int get totalDays => cycleWeeks * 7;

  /// The ordered meal slots every day of this plan serves.
  List<MealSlot> get slots => mealSlotsForCount(mealsPerDay);

  /// The day record for a 1-based [dayNumber], or `null` if out of range.
  MealEntity? dayByNumber(int dayNumber) {
    for (final d in days) {
      if (d.dayNumber == dayNumber) return d;
    }
    return null;
  }

  /// Which cycle day (1..[totalDays]) the given [date] lands on, given the plan
  /// repeats every [totalDays] days from [startDate].
  int cycleDayFor(DateTime date) {
    final start = DateTime(startDate.year, startDate.month, startDate.day);
    final target = DateTime(date.year, date.month, date.day);
    final diff = target.difference(start).inDays;
    final mod = diff % totalDays;
    final normalized = mod < 0 ? mod + totalDays : mod;
    return normalized + 1;
  }

  MenuPlanEntity copyWith({
    int? cycleWeeks,
    int? mealsPerDay,
    DateTime? startDate,
    List<MealEntity>? days,
    DateTime? lastUpdated,
    String? updatedBy,
  }) {
    return MenuPlanEntity(
      id: id,
      pgId: pgId,
      cycleWeeks: cycleWeeks ?? this.cycleWeeks,
      mealsPerDay: mealsPerDay ?? this.mealsPerDay,
      startDate: startDate ?? this.startDate,
      days: days ?? this.days,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      updatedBy: updatedBy ?? this.updatedBy,
    );
  }
}
