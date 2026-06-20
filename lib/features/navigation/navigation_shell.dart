import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/glass_bottom_nav.dart';
import '../../core/widgets/gradient_background.dart';

/// Main navigation shell with glassmorphic bottom nav.
/// Wraps the 5 main tabs: Dashboard, Rooms, Tenants, Payments, More.
class NavigationShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const NavigationShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: GradientBackground(
        child: navigationShell,
      ),
      bottomNavigationBar: GlassBottomNav(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        items: const [
          GlassBottomNavItem(
            icon: Icons.dashboard_outlined,
            activeIcon: Icons.dashboard_rounded,
            label: 'Dashboard',
          ),
          GlassBottomNavItem(
            icon: Icons.meeting_room_outlined,
            activeIcon: Icons.meeting_room_rounded,
            label: 'Rooms',
          ),
          GlassBottomNavItem(
            icon: Icons.people_outline_rounded,
            activeIcon: Icons.people_rounded,
            label: 'Tenants',
          ),
          GlassBottomNavItem(
            icon: Icons.account_balance_wallet_outlined,
            activeIcon: Icons.account_balance_wallet_rounded,
            label: 'Payments',
          ),
          GlassBottomNavItem(
            icon: Icons.more_horiz_rounded,
            activeIcon: Icons.more_horiz_rounded,
            label: 'More',
          ),
        ],
      ),
    );
  }
}
