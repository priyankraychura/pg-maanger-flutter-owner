import '../entities/meal_entity.dart';

abstract class MenuRepository {
  Future<List<MealEntity>> getMenu(String pgId);
  Future<MealEntity> updateMeal(String id, {MealTime? breakfast, MealTime? lunch, MealTime? dinner});
}
