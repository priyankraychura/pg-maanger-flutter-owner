import 'package:flutter/material.dart';

/// The set of feature areas access can be granted on.
///
/// [key] is the stable string id used when serializing permissions into invite
/// tokens and mock records — never rename an existing key without migrating the
/// data that references it.
enum AppModule {
  dashboard,
  rooms,
  tenants,
  payments,
  complaints,
  notices,
  menu,
  wifi,
  leaveNotices,
  invitations,
  staff,
  pgManagement,
  settings,
}

extension AppModuleInfo on AppModule {
  String get key {
    switch (this) {
      case AppModule.dashboard:
        return 'dashboard';
      case AppModule.rooms:
        return 'rooms';
      case AppModule.tenants:
        return 'tenants';
      case AppModule.payments:
        return 'payments';
      case AppModule.complaints:
        return 'complaints';
      case AppModule.notices:
        return 'notices';
      case AppModule.menu:
        return 'menu';
      case AppModule.wifi:
        return 'wifi';
      case AppModule.leaveNotices:
        return 'leave_notices';
      case AppModule.invitations:
        return 'invitations';
      case AppModule.staff:
        return 'staff';
      case AppModule.pgManagement:
        return 'pg_management';
      case AppModule.settings:
        return 'settings';
    }
  }

  String get displayName {
    switch (this) {
      case AppModule.dashboard:
        return 'Dashboard';
      case AppModule.rooms:
        return 'Rooms';
      case AppModule.tenants:
        return 'Tenants';
      case AppModule.payments:
        return 'Payments';
      case AppModule.complaints:
        return 'Complaints';
      case AppModule.notices:
        return 'Notices';
      case AppModule.menu:
        return 'Menu';
      case AppModule.wifi:
        return 'WiFi';
      case AppModule.leaveNotices:
        return 'Leave Notices';
      case AppModule.invitations:
        return 'Invitations';
      case AppModule.staff:
        return 'Staff Management';
      case AppModule.pgManagement:
        return 'Manage PGs';
      case AppModule.settings:
        return 'Settings';
    }
  }

  IconData get icon {
    switch (this) {
      case AppModule.dashboard:
        return Icons.dashboard_rounded;
      case AppModule.rooms:
        return Icons.meeting_room_rounded;
      case AppModule.tenants:
        return Icons.people_rounded;
      case AppModule.payments:
        return Icons.account_balance_wallet_rounded;
      case AppModule.complaints:
        return Icons.report_problem_rounded;
      case AppModule.notices:
        return Icons.campaign_rounded;
      case AppModule.menu:
        return Icons.restaurant_menu_rounded;
      case AppModule.wifi:
        return Icons.wifi_rounded;
      case AppModule.leaveNotices:
        return Icons.event_busy_rounded;
      case AppModule.invitations:
        return Icons.person_add_alt_1_rounded;
      case AppModule.staff:
        return Icons.badge_rounded;
      case AppModule.pgManagement:
        return Icons.apartment_rounded;
      case AppModule.settings:
        return Icons.settings_rounded;
    }
  }

  static AppModule? fromKey(String key) {
    for (final m in AppModule.values) {
      if (m.key == key) return m;
    }
    return null;
  }
}

/// Modules a staff member can be assigned permissions on in the invite editor.
/// Excludes [AppModule.dashboard] and [AppModule.settings], which are always
/// available to any signed-in user.
const List<AppModule> kAssignableModules = [
  AppModule.rooms,
  AppModule.tenants,
  AppModule.payments,
  AppModule.complaints,
  AppModule.notices,
  AppModule.menu,
  AppModule.wifi,
  AppModule.leaveNotices,
  AppModule.invitations,
  AppModule.staff,
  AppModule.pgManagement,
];
