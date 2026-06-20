import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Glassmorphic bottom navigation bar with animated indicator.
class GlassBottomNav extends ConsumerWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<GlassBottomNavItem> items;

  const GlassBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color navBgColor = isDark
        ? AppColors.darkSurface.withValues(alpha: 0.95)
        : AppColors.lightSurface.withValues(alpha: 0.95);
    final Color navBorderColor = isDark
        ? AppColors.darkGlassBorder.withValues(alpha: 0.2)
        : AppColors.lightGlassBorder.withValues(alpha: 0.3);

    Widget navWidget = Container(
      height: 68,
      decoration: BoxDecoration(
        color: navBgColor,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: navBorderColor,
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isSelected = index == currentIndex;

          return _NavItem(
            item: item,
            isSelected: isSelected,
            isDark: isDark,
            onTap: () => onTap(index),
          );
        }).toList(),
      ),
    );

    return SafeArea(
      top: false,
      left: false,
      right: false,
      child: Container(
        margin: const EdgeInsets.fromLTRB(18, 0, 18, 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.08),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: navWidget,
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final GlassBottomNavItem item;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const _NavItem({
    required this.item,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = AppColors.primaryOrange;
    final inactiveColor = isDark
        ? AppColors.darkTextTertiary
        : AppColors.lightTextTertiary;

    return InkResponse(
      onTap: onTap,
      radius: 28,
      highlightColor: Colors.transparent,
      splashColor: activeColor.withValues(alpha: 0.15),
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? activeColor.withValues(alpha: 0.12)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(AppSpacing.radiusRound),
              ),
              child: Icon(
                isSelected ? item.activeIcon : item.icon,
                size: 24,
                color: isSelected ? activeColor : inactiveColor,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              item.label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? activeColor : inactiveColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Data class for bottom navigation items.
class GlassBottomNavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const GlassBottomNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}
