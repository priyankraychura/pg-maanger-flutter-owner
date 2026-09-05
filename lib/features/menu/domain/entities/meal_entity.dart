import 'package:flutter/material.dart';

/// A single meal slot in a day's menu.
///
/// A day always runs Breakfast → Lunch → (Snacks) → Dinner. The optional
/// [snacks] slot is what turns a 3-meal day into a 4-meal one, so the ordering
/// stays intuitive regardless of how many meals a PG serves.
enum MealSlot { breakfast, lunch, snacks, dinner }

extension MealSlotInfo on MealSlot {
  /// Stable string id used in mock records / serialization.
  String get key {
    switch (this) {
      case MealSlot.breakfast:
        return 'breakfast';
      case MealSlot.lunch:
        return 'lunch';
      case MealSlot.snacks:
        return 'snacks';
      case MealSlot.dinner:
        return 'dinner';
    }
  }

  String get label {
    switch (this) {
      case MealSlot.breakfast:
        return 'Breakfast';
      case MealSlot.lunch:
        return 'Lunch';
      case MealSlot.snacks:
        return 'Evening Snacks';
      case MealSlot.dinner:
        return 'Dinner';
    }
  }

  IconData get icon {
    switch (this) {
      case MealSlot.breakfast:
        return Icons.free_breakfast_rounded;
      case MealSlot.lunch:
        return Icons.lunch_dining_rounded;
      case MealSlot.snacks:
        return Icons.bakery_dining_rounded;
      case MealSlot.dinner:
        return Icons.dinner_dining_rounded;
    }
  }

  /// Sensible default serving window, pre-filled when a slot is first created.
  String get defaultTimeSlot {
    switch (this) {
      case MealSlot.breakfast:
        return '7:30 - 9:00 AM';
      case MealSlot.lunch:
        return '12:30 - 2:00 PM';
      case MealSlot.snacks:
        return '5:00 - 6:00 PM';
      case MealSlot.dinner:
        return '7:30 - 9:30 PM';
    }
  }

  static MealSlot? fromKey(String key) {
    for (final s in MealSlot.values) {
      if (s.key == key) return s;
    }
    return null;
  }
}

/// The ordered meal slots served for a given meals-per-day count (3 or 4).
///
/// 3 meals → Breakfast, Lunch, Dinner.
/// 4 meals → Breakfast, Lunch, Evening Snacks, Dinner.
List<MealSlot> mealSlotsForCount(int mealsPerDay) {
  return mealsPerDay >= 4
      ? const [
          MealSlot.breakfast,
          MealSlot.lunch,
          MealSlot.snacks,
          MealSlot.dinner,
        ]
      : const [
          MealSlot.breakfast,
          MealSlot.lunch,
          MealSlot.dinner,
        ];
}

/// What is served at one meal slot on one day.
class MealTime {
  final String mainDish;
  final List<String> sideItems;
  final String timeSlot;

  const MealTime({
    required this.mainDish,
    this.sideItems = const [],
    required this.timeSlot,
  });

  bool get isEmpty => mainDish.trim().isEmpty && sideItems.isEmpty;

  MealTime copyWith({
    String? mainDish,
    List<String>? sideItems,
    String? timeSlot,
  }) {
    return MealTime(
      mainDish: mainDish ?? this.mainDish,
      sideItems: sideItems ?? this.sideItems,
      timeSlot: timeSlot ?? this.timeSlot,
    );
  }
}

/// One day within a repeating menu cycle, keyed by [dayNumber] (1-based).
///
/// [meals] holds only the slots this day actually serves; look them up with
/// [mealFor]. The number/order of slots for the plan comes from
/// [mealSlotsForCount].
class MealEntity {
  final String id;
  final String pgId;
  final int dayNumber; // 1-based within the cycle (1..cycleWeeks * 7)
  final Map<MealSlot, MealTime> meals;
  final DateTime lastUpdated;
  final String updatedBy;

  const MealEntity({
    required this.id,
    required this.pgId,
    required this.dayNumber,
    this.meals = const {},
    required this.lastUpdated,
    required this.updatedBy,
  });

  MealTime? mealFor(MealSlot slot) => meals[slot];

  /// The week (1-based) this day falls in within the cycle.
  int get weekNumber => ((dayNumber - 1) ~/ 7) + 1;

  MealEntity copyWith({
    Map<MealSlot, MealTime>? meals,
    DateTime? lastUpdated,
    String? updatedBy,
  }) {
    return MealEntity(
      id: id,
      pgId: pgId,
      dayNumber: dayNumber,
      meals: meals ?? this.meals,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      updatedBy: updatedBy ?? this.updatedBy,
    );
  }
}
