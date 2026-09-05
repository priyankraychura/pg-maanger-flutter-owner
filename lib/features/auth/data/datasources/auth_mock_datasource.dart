import '../../../../core/constants/app_constants.dart';
import '../../../../core/rbac/role_permissions.dart';
import '../../../../mock_database/mock_database.dart';
import '../../../roles/domain/entities/staff_entity.dart';
import '../../domain/entities/owner_entity.dart';
import '../../domain/entities/user_role.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthMockDatasource implements AuthRepository {
  @override
  Future<OwnerEntity> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(
      const Duration(milliseconds: AppConstants.mockApiDelay),
    );

    final normalized = email.trim().toLowerCase();

    // If the email matches an active staff member, sign in as that staff so
    // their role/permissions drive what the app shows. Otherwise fall back to
    // the primary owner (super admin).
    final staff = MockDatabase.instance.staff.where(
      (s) =>
          s.email.toLowerCase() == normalized &&
          s.status == StaffStatus.active,
    );
    if (staff.isNotEmpty) {
      return _principalFromStaff(staff.first);
    }

    // Sign the primary owner in, echoing back the email that was entered.
    return MockDatabase.instance.owners.first.copyWith(email: email);
  }

  OwnerEntity _principalFromStaff(StaffEntity s) {
    return OwnerEntity(
      id: s.id,
      name: s.name,
      email: s.email,
      phone: s.phone,
      role: s.role,
      isSuperAdmin: false,
      assignedPgIds: s.assignedPgIds,
      permissions: s.permissions,
      joinDate: s.joinDate,
    );
  }

  @override
  Future<OwnerEntity> register(RegistrationData data) async {
    await Future.delayed(
      const Duration(milliseconds: AppConstants.mockApiDelay),
    );

    return OwnerEntity(
      id: 'owner_${DateTime.now().millisecondsSinceEpoch}',
      name: data.name,
      email: data.email,
      phone: data.phone,
      role: UserRole.admin,
      isSuperAdmin: true,
      assignedPgIds: const ['pg_new_001'],
      permissions: defaultPermissionsFor(UserRole.admin),
      joinDate: DateTime.now(),
    );
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    await Future.delayed(
      const Duration(milliseconds: AppConstants.mockApiDelay),
    );
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    await Future.delayed(
      const Duration(milliseconds: AppConstants.mockApiDelay),
    );
  }

  @override
  Future<void> logout() async {
    await Future.delayed(
      const Duration(milliseconds: AppConstants.mockApiDelay ~/ 2),
    );
  }
}
