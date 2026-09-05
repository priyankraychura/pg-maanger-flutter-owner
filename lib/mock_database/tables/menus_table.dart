import '../../features/menu/domain/entities/meal_entity.dart';
import '../../features/menu/domain/entities/menu_plan_entity.dart';
import './owners_table.dart';

/// `menuPlans` table — one repeating mess-menu plan per PG.
///
/// The seed sets up a single 2-week, 4-meals-a-day plan for `pg_001` starting
/// on the most recent Monday, so the demo always shows a live "today" day.
List<MenuPlanEntity> seedMenuPlans() {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  // Roll back to the Monday of the current week for a tidy start date.
  final startDate = today.subtract(Duration(days: today.weekday - 1));

  const mealsPerDay = 4;
  const cycleWeeks = 2;

  // A little rotation so the two weeks don't read identically.
  const breakfastDishes = [
    'Poha', 'Idli & Sambar', 'Aloo Paratha', 'Upma', 'Masala Dosa',
    'Bread & Omelette', 'Chole Bhature',
  ];
  const lunchDishes = [
    'Dal Rice', 'Rajma Chawal', 'Veg Pulao', 'Kadhi Chawal', 'Sambar Rice',
    'Chole Rice', 'Veg Biryani',
  ];
  const dinnerDishes = [
    'Paneer Masala', 'Mix Veg', 'Aloo Gobi', 'Bhindi Masala', 'Dal Makhani',
    'Egg Curry', 'Malai Kofta',
  ];

  final days = List.generate(cycleWeeks * 7, (i) {
    final dow = i % 7;
    return MealEntity(
      id: 'm_${i + 1}',
      pgId: 'pg_001',
      dayNumber: i + 1,
      meals: {
        MealSlot.breakfast: MealTime(
          mainDish: breakfastDishes[dow],
          sideItems: const ['Chai'],
          timeSlot: MealSlot.breakfast.defaultTimeSlot,
        ),
        MealSlot.lunch: MealTime(
          mainDish: lunchDishes[dow],
          sideItems: const ['Salad', 'Papad'],
          timeSlot: MealSlot.lunch.defaultTimeSlot,
        ),
        MealSlot.snacks: MealTime(
          mainDish: dow.isEven ? 'Samosa' : 'Pakora',
          sideItems: const ['Tea'],
          timeSlot: MealSlot.snacks.defaultTimeSlot,
        ),
        MealSlot.dinner: MealTime(
          mainDish: dinnerDishes[dow],
          sideItems: const ['Roti', 'Rice'],
          timeSlot: MealSlot.dinner.defaultTimeSlot,
        ),
      },
      lastUpdated: now.subtract(const Duration(days: 5)),
      updatedBy: kPrimaryOwnerId,
    );
  });

  return [
    MenuPlanEntity(
      id: 'menu_pg_001',
      pgId: 'pg_001',
      cycleWeeks: cycleWeeks,
      mealsPerDay: mealsPerDay,
      startDate: startDate,
      days: days,
      lastUpdated: now.subtract(const Duration(days: 5)),
      updatedBy: kPrimaryOwnerId,
    ),
  ];
}
