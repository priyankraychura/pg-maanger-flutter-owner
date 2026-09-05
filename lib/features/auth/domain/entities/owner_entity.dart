import '../../../../core/rbac/app_module.dart';
import '../../../../core/rbac/permission_level.dart';
import 'user_role.dart';

/// Owner/staff principal — the currently signed-in account. Pure domain object
/// with no serialization logic.
///
/// A single [OwnerEntity] represents whoever is signed in, whether that is the
/// account owner (the super admin) or an invited staff member. Access control
/// is driven by [role], [isSuperAdmin] and the per-module [permissions] map.
class OwnerEntity {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? profileImageUrl;
  final UserRole role;

  /// True only for the account owner — an admin whose access no other admin may
  /// modify. See `AccessPolicy`.
  final bool isSuperAdmin;

  final List<String> assignedPgIds;

  /// Per-module access levels. For the owner/admins this is effectively
  /// full access; for managers/helpers it governs what they can see and edit.
  final Map<AppModule, PermissionLevel> permissions;

  final DateTime? joinDate;

  const OwnerEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.profileImageUrl,
    required this.role,
    this.isSuperAdmin = false,
    this.assignedPgIds = const [],
    this.permissions = const {},
    this.joinDate,
  });

  OwnerEntity copyWith({
    String? name,
    String? email,
    String? phone,
    String? profileImageUrl,
    UserRole? role,
    bool? isSuperAdmin,
    List<String>? assignedPgIds,
    Map<AppModule, PermissionLevel>? permissions,
    DateTime? joinDate,
  }) {
    return OwnerEntity(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      role: role ?? this.role,
      isSuperAdmin: isSuperAdmin ?? this.isSuperAdmin,
      assignedPgIds: assignedPgIds ?? this.assignedPgIds,
      permissions: permissions ?? this.permissions,
      joinDate: joinDate ?? this.joinDate,
    );
  }
}
