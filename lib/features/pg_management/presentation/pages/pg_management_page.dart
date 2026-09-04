import 'package:flutter/material.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/glass_app_bar.dart';

class PgManagementPage extends StatelessWidget {
  const PgManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GlassAppBar(
        title: 'Manage PGs',
        showBackButton: true,
      ),
      body: EmptyState(
        icon: Icons.business_rounded,
        title: 'Manage Properties',
        subtitle: 'Add, edit or remove PG branches.',
        actionLabel: 'Add New PG',
        actionIcon: Icons.add_home_work_rounded,
        primaryAction: true,
        onAction: () {},
      ),
    );
  }
}
