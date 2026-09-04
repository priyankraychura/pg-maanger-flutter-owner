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
    required List<String> accessibleModules,
  });
  Future<StaffEntity> updateStaffRole(String id, {UserRole? role, List<String>? assignedPgIds, List<String>? accessibleModules, StaffStatus? status});
  Future<void> removeStaff(String id);
}
