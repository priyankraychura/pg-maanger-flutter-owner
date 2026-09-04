import 'user_role.dart';

/// Owner/staff entity — pure domain object with no serialization logic.
class OwnerEntity {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? profileImageUrl;
  final UserRole role;
  final List<String> assignedPgIds;
  final List<String> accessibleModules;
  final DateTime? joinDate;

  const OwnerEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.profileImageUrl,
    required this.role,
    this.assignedPgIds = const [],
    this.accessibleModules = const [],
    this.joinDate,
  });

  OwnerEntity copyWith({
    String? name,
    String? email,
    String? phone,
    String? profileImageUrl,
    UserRole? role,
    List<String>? assignedPgIds,
    List<String>? accessibleModules,
    DateTime? joinDate,
  }) {
    return OwnerEntity(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      role: role ?? this.role,
      assignedPgIds: assignedPgIds ?? this.assignedPgIds,
      accessibleModules: accessibleModules ?? this.accessibleModules,
      joinDate: joinDate ?? this.joinDate,
    );
  }
}
