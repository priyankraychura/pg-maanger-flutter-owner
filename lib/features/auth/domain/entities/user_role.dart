/// User role enum defining access levels.
enum UserRole { admin, manager, helper }

/// Extension providing granular permission checks per role.
/// Admin can invite any role and select which modules they can access.
extension UserRolePermissions on UserRole {
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

  bool get canManagePGs {
    switch (this) {
      case UserRole.admin:
        return true;
      case UserRole.manager:
      case UserRole.helper:
        return false;
    }
  }

  bool get canManageRooms {
    switch (this) {
      case UserRole.admin:
      case UserRole.manager:
        return true;
      case UserRole.helper:
        return false;
    }
  }

  bool get canManageTenants {
    switch (this) {
      case UserRole.admin:
      case UserRole.manager:
        return true;
      case UserRole.helper:
        return false;
    }
  }

  bool get canManagePayments {
    switch (this) {
      case UserRole.admin:
      case UserRole.manager:
        return true;
      case UserRole.helper:
        return false;
    }
  }

  bool get canRespondComplaints {
    switch (this) {
      case UserRole.admin:
      case UserRole.manager:
        return true;
      case UserRole.helper:
        return false;
    }
  }

  bool get canIssueNotices {
    switch (this) {
      case UserRole.admin:
      case UserRole.manager:
        return true;
      case UserRole.helper:
        return false;
    }
  }

  bool get canEditMenu {
    switch (this) {
      case UserRole.admin:
      case UserRole.manager:
        return true;
      case UserRole.helper:
        return false;
    }
  }

  bool get canInviteTenants {
    switch (this) {
      case UserRole.admin:
      case UserRole.manager:
        return true;
      case UserRole.helper:
        return false;
    }
  }

  bool get canManageStaff {
    switch (this) {
      case UserRole.admin:
        return true;
      case UserRole.manager:
      case UserRole.helper:
        return false;
    }
  }

  bool get canManageWifi {
    switch (this) {
      case UserRole.admin:
      case UserRole.manager:
        return true;
      case UserRole.helper:
        return false;
    }
  }
}
