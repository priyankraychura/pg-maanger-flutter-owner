import 'package:flutter/material.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/glass_app_bar.dart';

class NoticesPage extends StatelessWidget {
  const NoticesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GlassAppBar(
        title: 'Notices',
        showBackButton: true,
      ),
      body: EmptyState(
        icon: Icons.campaign_outlined,
        title: 'No Notices Found',
        subtitle: 'There are no active broadcast notices.',
        actionLabel: 'Issue New Notice',
        actionIcon: Icons.add_alert_rounded,
        primaryAction: true,
        onAction: () {},
      ),
    );
  }
}
