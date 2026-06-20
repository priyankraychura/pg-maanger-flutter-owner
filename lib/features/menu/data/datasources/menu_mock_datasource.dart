import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/meal_entity.dart';
import '../../domain/repositories/menu_repository.dart';

class MenuMockDatasource implements MenuRepository {
  @override
  Future<List<MealEntity>> getMenu(String pgId) async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay));
    return _mockMenus.where((m) => m.pgId == pgId).toList();
  }

  @override
  Future<MealEntity> updateMeal(String id, {MealTime? breakfast, MealTime? lunch, MealTime? dinner}) async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay));
    final index = _mockMenus.indexWhere((m) => m.id == id);
    final m = _mockMenus[index];
    final updated = MealEntity(id: m.id, pgId: m.pgId, dayNumber: m.dayNumber, dayName: m.dayName, breakfast: breakfast ?? m.breakfast, lunch: lunch ?? m.lunch, dinner: dinner ?? m.dinner, lastUpdated: DateTime.now(), updatedBy: 'owner_001');
    _mockMenus[index] = updated;
    return updated;
  }

  static final _mockMenus = List.generate(14, (i) {
    final dayNames = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return MealEntity(
      id: 'm_${i+1}',
      pgId: 'pg_001',
      dayNumber: i + 1,
      dayName: '${dayNames[i % 7]} - Week ${(i ~/ 7) + 1}',
      breakfast: const MealTime(type: 'breakfast', mainDish: 'Poha', sideItems: ['Chai', 'Banana'], timeSlot: '7:30 - 9:00 AM'),
      lunch: const MealTime(type: 'lunch', mainDish: 'Dal Rice', sideItems: ['Salad', 'Papad'], timeSlot: '12:30 - 2:00 PM'),
      dinner: const MealTime(type: 'dinner', mainDish: 'Paneer Masala', sideItems: ['Roti'], timeSlot: '7:30 - 9:30 PM'),
      lastUpdated: DateTime.now().subtract(const Duration(days: 5)),
      updatedBy: 'owner_001',
    );
  });
}
