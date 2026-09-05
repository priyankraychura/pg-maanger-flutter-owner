import '../../../../core/rbac/app_module.dart';
import '../../../../core/rbac/permission_level.dart';
import '../../../auth/domain/entities/user_role.dart';
import '../entities/staff_entity.dart';

abstract class RoleRepository {
  Future<List<StaffEntity>> getStaff(String? pgId);
  Future<StaffEntity> inviteStaff({
    required String name,
    required String email,
    required String phone,
    required UserRole role,
    required List<String> assignedPgIds,
    required Map<AppModule, PermissionLevel> permissions,
  });
  Future<StaffEntity> updateStaffRole(
    String id, {
    String? name,
    String? phone,
    UserRole? role,
    List<String>? assignedPgIds,
    Map<AppModule, PermissionLevel>? permissions,
    StaffStatus? status,
  });
  Future<void> removeStaff(String id);
}
