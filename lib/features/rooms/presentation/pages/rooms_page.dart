import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/glass_app_bar.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/status_badge.dart';

class RoomsPage extends StatelessWidget {
  const RoomsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Mock Data
    final rooms = [
      {'number': '101', 'type': '2 Sharing', 'status': 'Full', 'occupancy': '2/2'},
      {'number': '102', 'type': 'Single', 'status': 'Available', 'occupancy': '0/1'},
      {'number': '103', 'type': '3 Sharing', 'status': 'Partial', 'occupancy': '2/3'},
      {'number': '201', 'type': 'Single', 'status': 'Full', 'occupancy': '1/1'},
      {'number': '202', 'type': '2 Sharing', 'status': 'Available', 'occupancy': '0/2'},
      {'number': '203', 'type': '3 Sharing', 'status': 'Full', 'occupancy': '3/3'},
    ];

    return Scaffold(
      appBar: const GlassAppBar(
        title: 'Manage Rooms',
        showBackButton: false,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        itemCount: rooms.length,
        itemBuilder: (context, index) {
          final room = rooms[index];
          final isAvailable = room['status'] == 'Available';
          final isPartial = room['status'] == 'Partial';
          
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
                          'Room ${room['number']}',
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xxs),
                        Text(
                          '${room['type']} • ${room['occupancy']}',
                          style: AppTextStyles.caption.copyWith(
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  StatusBadge(
                    label: room['status']!,
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
        padding: const EdgeInsets.only(bottom: 80.0),
        child: FloatingActionButton(
          onPressed: () {},
          backgroundColor: AppColors.primaryOrange,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}
