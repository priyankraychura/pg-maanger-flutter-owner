import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/rbac/app_module.dart';
import '../../../../core/rbac/permission_level.dart';
import '../../../../injection/service_locator.dart';
import '../../../auth/domain/entities/user_role.dart';
import '../../domain/entities/staff_entity.dart';
import '../../domain/repositories/role_repository.dart';

/// The list of staff members. Not scoped to the selected PG so the owner can
/// manage everyone from one screen.
final staffListProvider =
    FutureProvider.autoDispose<List<StaffEntity>>((ref) async {
  return getIt<RoleRepository>().getStaff(null);
});

/// Exposes invite / update / remove actions for staff. After each write the
/// [staffListProvider] is invalidated so the list reflects the change.
final staffControllerProvider = Provider<StaffController>((ref) {
  return StaffController(ref);
});

class StaffController {
  StaffController(this._ref);

  final Ref _ref;
  RoleRepository get _repository => getIt<RoleRepository>();

  Future<StaffEntity> invite({
    required String name,
    required String email,
    required String phone,
    required UserRole role,
    required List<String> assignedPgIds,
    required Map<AppModule, PermissionLevel> permissions,
  }) async {
    final staff = await _repository.inviteStaff(
      name: name,
      email: email,
      phone: phone,
      role: role,
      assignedPgIds: assignedPgIds,
      permissions: permissions,
    );
    _ref.invalidate(staffListProvider);
    return staff;
  }

  Future<StaffEntity> update(
    String id, {
    String? name,
    String? phone,
    UserRole? role,
    List<String>? assignedPgIds,
    Map<AppModule, PermissionLevel>? permissions,
    StaffStatus? status,
  }) async {
    final staff = await _repository.updateStaffRole(
      id,
      name: name,
      phone: phone,
      role: role,
      assignedPgIds: assignedPgIds,
      permissions: permissions,
      status: status,
    );
    _ref.invalidate(staffListProvider);
    return staff;
  }

  Future<void> remove(String id) async {
    await _repository.removeStaff(id);
    _ref.invalidate(staffListProvider);
  }
}
