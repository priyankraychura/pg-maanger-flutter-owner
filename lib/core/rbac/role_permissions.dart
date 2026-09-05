import '../../features/auth/domain/entities/user_role.dart';
import 'app_module.dart';
import 'permission_level.dart';

/// The default per-module permission template for a [role].
///
/// This is the starting point shown in the staff invite editor when a role is
/// picked; the owner can then fine-tune individual modules before sending the
/// invite. It is also used to seed accounts.
///
/// [AppModule.dashboard] and [AppModule.settings] are always at least [view]
/// for any signed-in user, so they are included here as [view]/[edit] but never
/// dropped to [none].
Map<AppModule, PermissionLevel> defaultPermissionsFor(UserRole role) {
  switch (role) {
    case UserRole.admin:
      // Full access to every module.
      return {
        for (final m in AppModule.values) m: PermissionLevel.edit,
      };
    case UserRole.manager:
      return _withBase({
        AppModule.rooms: PermissionLevel.edit,
        AppModule.tenants: PermissionLevel.edit,
        AppModule.payments: PermissionLevel.edit,
        AppModule.complaints: PermissionLevel.edit,
        AppModule.notices: PermissionLevel.edit,
        AppModule.menu: PermissionLevel.edit,
        AppModule.wifi: PermissionLevel.edit,
        AppModule.leaveNotices: PermissionLevel.edit,
        AppModule.invitations: PermissionLevel.edit,
        AppModule.staff: PermissionLevel.none,
        AppModule.pgManagement: PermissionLevel.none,
      });
    case UserRole.helper:
      return _withBase({
        AppModule.rooms: PermissionLevel.view,
        AppModule.tenants: PermissionLevel.none,
        AppModule.payments: PermissionLevel.none,
        AppModule.complaints: PermissionLevel.view,
        AppModule.notices: PermissionLevel.view,
        AppModule.menu: PermissionLevel.view,
        AppModule.wifi: PermissionLevel.view,
        AppModule.leaveNotices: PermissionLevel.none,
        AppModule.invitations: PermissionLevel.none,
        AppModule.staff: PermissionLevel.none,
        AppModule.pgManagement: PermissionLevel.none,
      });
  }
}

/// Fills in the always-available base modules, then overlays [overrides].
Map<AppModule, PermissionLevel> _withBase(
  Map<AppModule, PermissionLevel> overrides,
) {
  return {
    for (final m in AppModule.values) m: PermissionLevel.none,
    AppModule.dashboard: PermissionLevel.view,
    AppModule.settings: PermissionLevel.view,
    ...overrides,
  };
}
