import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/glass_app_bar.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/status_badge.dart';

class TenantsPage extends StatelessWidget {
  const TenantsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Mock Data
    final tenants = [
      {'name': 'Rahul Kumar', 'room': '101', 'status': 'Active', 'rentStatus': 'Paid'},
      {'name': 'Amit Singh', 'room': '102', 'status': 'Active', 'rentStatus': 'Pending'},
      {'name': 'Priya Sharma', 'room': '201', 'status': 'Notice', 'rentStatus': 'Paid'},
      {'name': 'Vikram Gupta', 'room': '103', 'status': 'Active', 'rentStatus': 'Overdue'},
      {'name': 'Neha Patel', 'room': '203', 'status': 'Active', 'rentStatus': 'Paid'},
    ];

    return Scaffold(
      appBar: const GlassAppBar(
        title: 'Tenants',
        showBackButton: false,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        itemCount: tenants.length,
        itemBuilder: (context, index) {
          final tenant = tenants[index];
          final rentStatus = tenant['rentStatus'];

          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: GlassCard(
              onTap: () {},
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.primaryOrange.withValues(alpha: 0.15),
                    child: Text(
                      tenant['name']![0],
                      style: AppTextStyles.h2.copyWith(color: AppColors.primaryOrange),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tenant['name']!,
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xxs),
                        Text(
                          'Room ${tenant['room']}',
                          style: AppTextStyles.caption.copyWith(
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      StatusBadge(
                        label: tenant['status']!,
                        type: tenant['status'] == 'Active' ? StatusType.success : StatusType.warning,
                        small: true,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        rentStatus!,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: rentStatus == 'Paid' ? AppColors.success : (rentStatus == 'Pending' ? AppColors.warning : AppColors.error),
                        ),
                      ),
                    ],
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
          child: const Icon(Icons.person_add_alt_1_rounded, color: Colors.white),
        ),
      ),
    );
  }
}
