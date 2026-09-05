import '../../../../core/rbac/app_module.dart';
import '../../../../core/rbac/permission_level.dart';
import '../../../auth/domain/entities/user_role.dart';

/// Staff record for role management — a manager/helper/admin the owner has
/// invited, and the PGs & per-module permissions granted to them.
class StaffEntity {
  final String id;
  final String name;
  final String email;
  final String phone;
  final UserRole role;

  /// True only for the account owner. The owner is not normally listed as a
  /// staff record, but the flag guards against anyone editing the super admin.
  final bool isSuperAdmin;

  final List<String> assignedPgIds;

  /// Per-module access levels granted to this staff member.
  final Map<AppModule, PermissionLevel> permissions;

  final DateTime joinDate;
  final StaffStatus status;

  const StaffEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    this.isSuperAdmin = false,
    required this.assignedPgIds,
    this.permissions = const {},
    required this.joinDate,
    required this.status,
  });
}

enum StaffStatus { active, inactive, pendingInvite }

extension StaffStatusExtension on StaffStatus {
  String get label {
    switch (this) {
      case StaffStatus.active:
        return 'Active';
      case StaffStatus.inactive:
        return 'Inactive';
      case StaffStatus.pendingInvite:
        return 'Invited';
    }
  }
}
