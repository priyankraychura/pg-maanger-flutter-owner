import '../../../auth/domain/entities/user_role.dart';

/// Staff entity for role management.
class StaffEntity {
  final String id;
  final String name;
  final String email;
  final String phone;
  final UserRole role;
  final List<String> assignedPgIds;
  final List<String> accessibleModules;
  final DateTime joinDate;
  final StaffStatus status;

  const StaffEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.assignedPgIds,
    this.accessibleModules = const [],
    required this.joinDate,
    required this.status,
  });
}

enum StaffStatus { active, inactive, pendingInvite }

extension StaffStatusExtension on StaffStatus {
  String get label {
    switch (this) {
      case StaffStatus.active: return 'Active';
      case StaffStatus.inactive: return 'Inactive';
      case StaffStatus.pendingInvite: return 'Invited';
    }
  }
}
