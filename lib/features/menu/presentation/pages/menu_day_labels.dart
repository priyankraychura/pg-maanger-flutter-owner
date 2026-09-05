import '../../../../core/extensions/date_extensions.dart';
import '../../domain/entities/menu_plan_entity.dart';

/// A human-friendly title/subtitle for a cycle day, shared by the menu list
/// and the day editor so both read the same way.
class DayLabel {
  final String title;
  final String subtitle;
  final String weekday;

  const DayLabel({
    required this.title,
    required this.subtitle,
    required this.weekday,
  });
}

DayLabel dayLabel(MenuPlanEntity plan, int dayNumber) {
  // The weekday repeats every cycle, so it is fixed by the offset from the
  // start date.
  final date = DateTime(
    plan.startDate.year,
    plan.startDate.month,
    plan.startDate.day,
  ).add(Duration(days: dayNumber - 1));
  final weekday = date.dayName;
  final weekNumber = ((dayNumber - 1) ~/ 7) + 1;

  if (plan.cycleWeeks > 1) {
    return DayLabel(
      title: 'Week $weekNumber · $weekday',
      subtitle: 'Day $dayNumber of ${plan.totalDays}-day cycle',
      weekday: weekday,
    );
  }
  return DayLabel(
    title: weekday,
    subtitle: 'Day $dayNumber of ${plan.totalDays}-day cycle',
    weekday: weekday,
  );
}
