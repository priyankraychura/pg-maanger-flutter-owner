import '../../../../core/constants/app_constants.dart';
import '../../../../mock_database/mock_database.dart';
import '../../../../mock_database/tables/owners_table.dart';
import '../../domain/entities/meal_entity.dart';
import '../../domain/repositories/menu_repository.dart';

class MenuMockDatasource implements MenuRepository {
  List<MealEntity> get _menus => MockDatabase.instance.menus;

  @override
  Future<List<MealEntity>> getMenu(String pgId) async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay));
    return _menus.where((m) => m.pgId == pgId).toList();
  }

  @override
  Future<MealEntity> updateMeal(String id, {MealTime? breakfast, MealTime? lunch, MealTime? dinner}) async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay));
    final index = _menus.indexWhere((m) => m.id == id);
    final m = _menus[index];
    final updated = MealEntity(id: m.id, pgId: m.pgId, dayNumber: m.dayNumber, dayName: m.dayName, breakfast: breakfast ?? m.breakfast, lunch: lunch ?? m.lunch, dinner: dinner ?? m.dinner, lastUpdated: DateTime.now(), updatedBy: kPrimaryOwnerId);
    _menus[index] = updated;
    return updated;
  }
}
