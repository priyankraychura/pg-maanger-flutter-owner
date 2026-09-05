import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/rbac/access_provider.dart';
import '../../core/rbac/app_module.dart';
import '../../core/widgets/glass_bottom_nav.dart';
import '../../core/widgets/gradient_background.dart';

/// One entry in the bottom navigation, tied to the shell branch it selects and
/// the module a user must be able to view for the tab to appear.
class _NavBranch {
  final int branchIndex;
  final AppModule module;
  final GlassBottomNavItem item;
  const _NavBranch(this.branchIndex, this.module, this.item);
}

/// Main navigation shell with glassmorphic bottom nav.
///
/// The five branches are fixed (Dashboard, Rooms, Tenants, Payments, More), but
/// only the tabs the signed-in user can view are shown — a restricted user
/// never sees a tab for a module they lack access to. Dashboard and More
/// (Settings) are always available.
class NavigationShell extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const NavigationShell({super.key, required this.navigationShell});

  static const List<_NavBranch> _allBranches = [
    _NavBranch(
      0,
      AppModule.dashboard,
      GlassBottomNavItem(
        icon: Icons.dashboard_outlined,
        activeIcon: Icons.dashboard_rounded,
        label: 'Dashboard',
      ),
    ),
    _NavBranch(
      1,
      AppModule.rooms,
      GlassBottomNavItem(
        icon: Icons.meeting_room_outlined,
        activeIcon: Icons.meeting_room_rounded,
        label: 'Rooms',
      ),
    ),
    _NavBranch(
      2,
      AppModule.tenants,
      GlassBottomNavItem(
        icon: Icons.people_outline_rounded,
        activeIcon: Icons.people_rounded,
        label: 'Tenants',
      ),
    ),
    _NavBranch(
      3,
      AppModule.payments,
      GlassBottomNavItem(
        icon: Icons.account_balance_wallet_outlined,
        activeIcon: Icons.account_balance_wallet_rounded,
        label: 'Payments',
      ),
    ),
    _NavBranch(
      4,
      AppModule.settings,
      GlassBottomNavItem(
        icon: Icons.more_horiz_rounded,
        activeIcon: Icons.more_horiz_rounded,
        label: 'More',
      ),
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final access = ref.watch(accessPolicyProvider);
    final visible = _allBranches
        .where((b) => access.canView(b.module))
        .toList(growable: false);

    // Map the active shell branch to its position in the visible tab list.
    var currentVisibleIndex = visible
        .indexWhere((b) => b.branchIndex == navigationShell.currentIndex);
    if (currentVisibleIndex < 0) currentVisibleIndex = 0;

    return Scaffold(
      extendBody: true,
      body: GradientBackground(
        child: navigationShell,
      ),
      bottomNavigationBar: GlassBottomNav(
        currentIndex: currentVisibleIndex,
        onTap: (visibleIndex) {
          final branch = visible[visibleIndex].branchIndex;
          navigationShell.goBranch(
            branch,
            initialLocation: branch == navigationShell.currentIndex,
          );
        },
        items: visible.map((b) => b.item).toList(growable: false),
      ),
    );
  }
}
