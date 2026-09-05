/// User role enum defining the kind of account.
///
/// Owner accounts use [admin] together with a super-admin flag on the principal
/// (see `OwnerEntity.isSuperAdmin`). These three roles are the ones that can be
/// invited. Actual access is decided centrally by `AccessPolicy`, not by the
/// role alone.
enum UserRole { admin, manager, helper }

extension UserRoleInfo on UserRole {
  String get displayName {
    switch (this) {
      case UserRole.admin:
        return 'Admin';
      case UserRole.manager:
        return 'Manager';
      case UserRole.helper:
        return 'Helper';
    }
  }

  String get key {
    switch (this) {
      case UserRole.admin:
        return 'admin';
      case UserRole.manager:
        return 'manager';
      case UserRole.helper:
        return 'helper';
    }
  }

  static UserRole fromKey(String? key) {
    switch (key) {
      case 'admin':
        return UserRole.admin;
      case 'helper':
        return UserRole.helper;
      default:
        return UserRole.manager;
    }
  }
}
