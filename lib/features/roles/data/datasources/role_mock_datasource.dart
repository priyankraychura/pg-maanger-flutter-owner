import '../../../../core/constants/app_constants.dart';
import '../../../auth/domain/entities/user_role.dart';
import '../../domain/entities/staff_entity.dart';
import '../../domain/repositories/role_repository.dart';

class RoleMockDatasource implements RoleRepository {
  @override
  Future<List<StaffEntity>> getStaff(String? pgId) async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay));
    if (pgId == null) return List.unmodifiable(_mockStaff);
    return _mockStaff.where((s) => s.assignedPgIds.contains(pgId)).toList();
  }

  @override
  Future<StaffEntity> inviteStaff({required String name, required String email, required String phone, required UserRole role, required List<String> assignedPgIds, required List<String> accessibleModules}) async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay));
    final s = StaffEntity(id: 's_${DateTime.now().millisecondsSinceEpoch}', name: name, email: email, phone: phone, role: role, assignedPgIds: assignedPgIds, accessibleModules: accessibleModules, joinDate: DateTime.now(), status: StaffStatus.pendingInvite);
    _mockStaff.add(s);
    return s;
  }

  @override
  Future<StaffEntity> updateStaffRole(String id, {UserRole? role, List<String>? assignedPgIds, List<String>? accessibleModules, StaffStatus? status}) async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay));
    final index = _mockStaff.indexWhere((s) => s.id == id);
    final s = _mockStaff[index];
    final updated = StaffEntity(id: s.id, name: s.name, email: s.email, phone: s.phone, role: role ?? s.role, assignedPgIds: assignedPgIds ?? s.assignedPgIds, accessibleModules: accessibleModules ?? s.accessibleModules, joinDate: s.joinDate, status: status ?? s.status);
    _mockStaff[index] = updated;
    return updated;
  }

  @override
  Future<void> removeStaff(String id) async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay));
    _mockStaff.removeWhere((s) => s.id == id);
  }

  static final _mockStaff = <StaffEntity>[
    StaffEntity(id: 's1', name: 'Ravi Kumar', email: 'ravi.manager@pgmanager.com', phone: '9876543250', role: UserRole.manager, assignedPgIds: ['pg_001'], accessibleModules: ['dashboard', 'rooms', 'tenants', 'payments', 'complaints'], joinDate: DateTime(2024, 6, 1), status: StaffStatus.active),
    StaffEntity(id: 's2', name: 'Suresh Helper', email: 'suresh@pgmanager.com', phone: '9876543251', role: UserRole.helper, assignedPgIds: ['pg_001', 'pg_002'], accessibleModules: ['dashboard', 'rooms', 'complaints'], joinDate: DateTime(2024, 8, 15), status: StaffStatus.active),
  ];
}
