/// Meal entity representing a single day's menu.
class MealEntity {
  final String id;
  final String pgId;
  final int dayNumber; // 1-14 for a 2-week menu
  final String dayName; // e.g., 'Monday - Week 1'
  final MealTime? breakfast;
  final MealTime? lunch;
  final MealTime? dinner;
  final DateTime lastUpdated;
  final String updatedBy;

  const MealEntity({
    required this.id,
    required this.pgId,
    required this.dayNumber,
    required this.dayName,
    this.breakfast,
    this.lunch,
    this.dinner,
    required this.lastUpdated,
    required this.updatedBy,
  });
}

class MealTime {
  final String type; // 'breakfast', 'lunch', 'dinner'
  final String mainDish;
  final List<String> sideItems;
  final String timeSlot;

  const MealTime({
    required this.type,
    required this.mainDish,
    required this.sideItems,
    required this.timeSlot,
  });
}
