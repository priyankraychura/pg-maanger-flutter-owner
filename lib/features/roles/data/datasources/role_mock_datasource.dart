import '../../../../core/constants/app_constants.dart';
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
  Future<StaffEntity> inviteStaff({required String name, required String email, required String phone, required UserRole role, required List<String> assignedPgIds, required List<String> accessibleModules}) async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay));
    final s = StaffEntity(id: 's_${DateTime.now().millisecondsSinceEpoch}', name: name, email: email, phone: phone, role: role, assignedPgIds: assignedPgIds, accessibleModules: accessibleModules, joinDate: DateTime.now(), status: StaffStatus.pendingInvite);
    _staff.add(s);
    return s;
  }

  @override
  Future<StaffEntity> updateStaffRole(String id, {UserRole? role, List<String>? assignedPgIds, List<String>? accessibleModules, StaffStatus? status}) async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay));
    final index = _staff.indexWhere((s) => s.id == id);
    final s = _staff[index];
    final updated = StaffEntity(id: s.id, name: s.name, email: s.email, phone: s.phone, role: role ?? s.role, assignedPgIds: assignedPgIds ?? s.assignedPgIds, accessibleModules: accessibleModules ?? s.accessibleModules, joinDate: s.joinDate, status: status ?? s.status);
    _staff[index] = updated;
    return updated;
  }

  @override
  Future<void> removeStaff(String id) async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay));
    _staff.removeWhere((s) => s.id == id);
  }
}
