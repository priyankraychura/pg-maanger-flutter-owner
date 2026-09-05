import '../../features/auth/domain/entities/user_role.dart';
import 'app_module.dart';
import 'permission_level.dart';

/// Central authority for "is this principal allowed to …" questions.
///
/// This is the single source of truth for access control across the app. UI
/// widgets never inspect a role directly — they ask an [AccessPolicy] whether
/// the current user can view or edit a given [AppModule].
///
/// Precedence rules:
///  * A **super admin** (the account owner) has full access to everything and
///    can never be restricted.
///  * A plain **admin** also has full access — an admin is "same as the owner"
///    except they cannot modify the super admin's account (see
///    [canManageStaffMember]).
///  * Managers and helpers are governed entirely by their [permissions] map.
class AccessPolicy {
  final UserRole role;
  final bool isSuperAdmin;
  final Map<AppModule, PermissionLevel> permissions;

  const AccessPolicy({
    required this.role,
    required this.isSuperAdmin,
    required this.permissions,
  });

  /// A policy that grants nothing — used when no one is signed in.
  const AccessPolicy.none()
      : role = UserRole.helper,
        isSuperAdmin = false,
        permissions = const {};

  bool get _hasFullAccess => isSuperAdmin || role == UserRole.admin;

  PermissionLevel levelFor(AppModule module) {
    if (_hasFullAccess) return PermissionLevel.edit;
    // Dashboard and settings are always at least viewable for a signed-in user.
    if (module == AppModule.dashboard || module == AppModule.settings) {
      final level = permissions[module] ?? PermissionLevel.view;
      return level.index >= PermissionLevel.view.index
          ? level
          : PermissionLevel.view;
    }
    return permissions[module] ?? PermissionLevel.none;
  }

  bool canView(AppModule module) => levelFor(module).canView;

  bool canEdit(AppModule module) => levelFor(module).canEdit;

  /// Modules this principal can at least view, in enum order.
  List<AppModule> get visibleModules =>
      AppModule.values.where(canView).toList(growable: false);

  /// Whether this principal may edit the account of another staff member.
  ///
  /// Enforces two rules:
  ///  * You must have edit access to the staff module.
  ///  * No one may modify the **super admin** (owner) — not even another admin.
  bool canManageStaffMember({required bool targetIsSuperAdmin}) {
    if (targetIsSuperAdmin) return false;
    return canEdit(AppModule.staff);
  }
}
