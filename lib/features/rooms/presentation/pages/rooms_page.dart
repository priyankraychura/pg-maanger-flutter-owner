import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/glass_app_bar.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/status_badge.dart';
import 'add_room_page.dart';

/// A student who can be assigned to a room.
class _Student {
  final String id;
  final String name;
  String? roomNumber;

  _Student({required this.id, required this.name, this.roomNumber});

  bool get isUnassigned => roomNumber == null;
}

/// A PG room with a capacity and the students assigned to it.
class _Room {
  final String number;
  final int capacity;
  final List<String> studentIds;

  _Room({required this.number, required this.capacity, List<String>? studentIds})
      : studentIds = studentIds ?? [];

  int get occupied => studentIds.length;

  String get typeLabel {
    switch (capacity) {
      case 1:
        return 'Single';
      default:
        return '$capacity Sharing';
    }
  }

  String get statusLabel {
    if (occupied == 0) return 'Available';
    if (occupied >= capacity) return 'Full';
    return 'Partial';
  }
}

class RoomsPage extends StatefulWidget {
  const RoomsPage({super.key});

  @override
  State<RoomsPage> createState() => _RoomsPageState();
}

class _RoomsPageState extends State<RoomsPage> {
  // ─── Mock data ─────────────────────────────────────
  final List<_Student> _students = [
    _Student(id: 's1', name: 'Ankit Kumar', roomNumber: '101'),
    _Student(id: 's2', name: 'Rahul Singh', roomNumber: '101'),
    _Student(id: 's3', name: 'Sneha Gupta', roomNumber: '103'),
    _Student(id: 's4', name: 'Priya Mehta', roomNumber: '103'),
    _Student(id: 's5', name: 'Vikram Singh', roomNumber: '201'),
    _Student(id: 's6', name: 'Amit Patel'),
    _Student(id: 's7', name: 'Deepak Sharma'),
    _Student(id: 's8', name: 'Rohit Verma'),
    _Student(id: 's9', name: 'Karan Malhotra'),
  ];

  late final List<_Room> _rooms = [
    _Room(number: '101', capacity: 2, studentIds: ['s1', 's2']),
    _Room(number: '102', capacity: 1),
    _Room(number: '103', capacity: 3, studentIds: ['s3', 's4']),
    _Room(number: '201', capacity: 1, studentIds: ['s5']),
    _Room(number: '202', capacity: 2),
    _Room(number: '203', capacity: 3),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Scaffold(
      appBar: const GlassAppBar(
        title: 'Manage Rooms',
        showBackButton: false,
      ),
      body: ListView.builder(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.screenPadding,
          AppSpacing.screenPadding,
          AppSpacing.screenPadding,
          context.bottomNavInset,
        ),
        itemCount: _rooms.length,
        itemBuilder: (context, index) {
          final room = _rooms[index];
          final status = room.statusLabel;
          final isAvailable = status == 'Available';
          final isPartial = status == 'Partial';

          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: GlassCard(
              onTap: () {},
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primaryOrange.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    ),
                    child: const Icon(
                      Icons.meeting_room_rounded,
                      color: AppColors.primaryOrange,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Room ${room.number}',
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xxs),
                        Text(
                          '${room.typeLabel} • ${room.occupied}/${room.capacity}',
                          style: AppTextStyles.caption.copyWith(
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  StatusBadge(
                    label: status,
                    type: isAvailable
                        ? StatusType.success
                        : isPartial
                            ? StatusType.warning
                            : StatusType.error,
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: context.fabBottomInset),
        child: FloatingActionButton(
          onPressed: _openAddRoom,
          backgroundColor: AppColors.primaryOrange,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  // ─── Add room ──────────────────────────────────────
  Future<void> _openAddRoom() async {
    // Students who aren't assigned to any room yet.
    final unassigned = _students
        .where((s) => s.isUnassigned)
        .map((s) => AddRoomStudent(id: s.id, name: s.name))
        .toList();

    final result = await context.push<AddRoomResult>(
      '/rooms/add',
      extra: AddRoomArgs(
        unassignedStudents: unassigned,
        existingRoomNames: _rooms.map((r) => r.number).toList(),
      ),
    );

    if (result == null || !mounted) return;

    setState(() {
      _rooms.add(_Room(
        number: result.name,
        capacity: result.capacity,
        studentIds: result.selectedStudentIds,
      ));
      for (final student in _students) {
        if (result.selectedStudentIds.contains(student.id)) {
          student.roomNumber = result.name;
        }
      }
    });

    context.showSnackBar('Room "${result.name}" added.');
  }
}
