import '../../features/menu/domain/entities/meal_entity.dart';
import './owners_table.dart';

const _dayNames = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

/// `menus` table — a 14-day (two-week) meal plan per PG.
List<MealEntity> seedMenus() => List.generate(14, (i) {
      return MealEntity(
        id: 'm_${i + 1}',
        pgId: 'pg_001',
        dayNumber: i + 1,
        dayName: '${_dayNames[i % 7]} - Week ${(i ~/ 7) + 1}',
        breakfast: const MealTime(type: 'breakfast', mainDish: 'Poha', sideItems: ['Chai', 'Banana'], timeSlot: '7:30 - 9:00 AM'),
        lunch: const MealTime(type: 'lunch', mainDish: 'Dal Rice', sideItems: ['Salad', 'Papad'], timeSlot: '12:30 - 2:00 PM'),
        dinner: const MealTime(type: 'dinner', mainDish: 'Paneer Masala', sideItems: ['Roti'], timeSlot: '7:30 - 9:30 PM'),
        lastUpdated: DateTime.now().subtract(const Duration(days: 5)),
        updatedBy: kPrimaryOwnerId,
      );
    });
