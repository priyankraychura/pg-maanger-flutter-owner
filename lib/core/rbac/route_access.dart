import 'app_module.dart';

/// Maps an app route path to the [AppModule] a user must be able to view in
/// order to open it. Returns `null` for routes that are not permission-gated
/// (auth pages, dashboard/settings which are always available).
///
/// This is the enforcement backbone: the router consults it on every navigation
/// so a module a user cannot view is unreachable even via a deep link or an
/// entry point that failed to hide itself.
AppModule? requiredModuleForPath(String path) {
  // Normalize: compare on the leading segment(s).
  bool isUnder(String prefix) => path == prefix || path.startsWith('$prefix/');

  if (isUnder('/rooms')) return AppModule.rooms;
  if (isUnder('/tenants')) return AppModule.tenants;
  if (isUnder('/payments')) return AppModule.payments;
  if (isUnder('/complaints')) return AppModule.complaints;
  if (isUnder('/notices')) return AppModule.notices;
  if (isUnder('/menu')) return AppModule.menu;
  if (isUnder('/invitations')) return AppModule.invitations;
  if (isUnder('/staff')) return AppModule.staff;
  if (isUnder('/pg-management')) return AppModule.pgManagement;

  // Not gated: /login, /register, /forgot-password, /dashboard,
  // /settings, /recent-activity.
  return null;
}
