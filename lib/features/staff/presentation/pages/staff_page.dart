import 'package:flutter/material.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/glass_app_bar.dart';

class StaffPage extends StatelessWidget {
  const StaffPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GlassAppBar(
        title: 'Staff Management',
        showBackButton: true,
      ),
      body: EmptyState(
        icon: Icons.badge_rounded,
        title: 'No Staff Added',
        subtitle: 'Manage your managers and staff here.',
        actionLabel: 'Add Staff',
        actionIcon: Icons.person_add_rounded,
        primaryAction: true,
        onAction: () {},
      ),
    );
  }
}
