import '../../../../core/constants/app_constants.dart';
import '../../../../core/rbac/app_module.dart';
import '../../../../core/rbac/permission_level.dart';
import '../../../../mock_database/mock_database.dart';
import '../../../auth/domain/entities/user_role.dart';
import '../../domain/entities/staff_entity.dart';
import '../../domain/repositories/role_repository.dart';

class RoleMockDatasource implements RoleRepository {
  List<StaffEntity> get _staff => MockDatabase.instance.staff;

  @override
  Future<List<StaffEntity>> getStaff(String? pgId) async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay));
    if (pgId == null) return List.unmodifiable(_staff);
    return _staff.where((s) => s.assignedPgIds.contains(pgId)).toList();
  }

  @override
  Future<StaffEntity> inviteStaff({
    required String name,
    required String email,
    required String phone,
    required UserRole role,
    required List<String> assignedPgIds,
    required Map<AppModule, PermissionLevel> permissions,
  }) async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay));
    final s = StaffEntity(
      id: 's_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      phone: phone,
      role: role,
      assignedPgIds: assignedPgIds,
      permissions: permissions,
      joinDate: DateTime.now(),
      status: StaffStatus.pendingInvite,
    );
    _staff.add(s);
    return s;
  }

  @override
  Future<StaffEntity> updateStaffRole(
    String id, {
    String? name,
    String? phone,
    UserRole? role,
    List<String>? assignedPgIds,
    Map<AppModule, PermissionLevel>? permissions,
    StaffStatus? status,
  }) async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay));
    final index = _staff.indexWhere((s) => s.id == id);
    final s = _staff[index];
    final updated = StaffEntity(
      id: s.id,
      name: name ?? s.name,
      email: s.email,
      phone: phone ?? s.phone,
      role: role ?? s.role,
      isSuperAdmin: s.isSuperAdmin,
      assignedPgIds: assignedPgIds ?? s.assignedPgIds,
      permissions: permissions ?? s.permissions,
      joinDate: s.joinDate,
      status: status ?? s.status,
    );
    _staff[index] = updated;
    return updated;
  }

  @override
  Future<void> removeStaff(String id) async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay));
    _staff.removeWhere((s) => s.id == id);
  }
}
