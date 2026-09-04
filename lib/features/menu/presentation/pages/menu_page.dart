import 'package:flutter/material.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/glass_app_bar.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GlassAppBar(
        title: 'Mess Menu',
        showBackButton: true,
      ),
      body: EmptyState(
        icon: Icons.restaurant_menu_rounded,
        title: 'No Menu Configured',
        subtitle: 'You have not set up a mess menu yet.',
        actionLabel: 'Create Menu',
        actionIcon: Icons.add_rounded,
        primaryAction: true,
        onAction: () {},
      ),
    );
  }
}
