import '../../../../core/constants/app_constants.dart';
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

    return OwnerEntity(
      id: 'owner_001',
      name: 'Priyank Sharma',
      email: email,
      phone: '9876543210',
      role: UserRole.admin,
      assignedPgIds: ['pg_001', 'pg_002'],
      accessibleModules: [
        'dashboard', 'rooms', 'tenants', 'payments',
        'complaints', 'notices', 'menu', 'wifi',
        'leave_notices', 'invitations', 'roles', 'settings',
      ],
      joinDate: DateTime(2024, 3, 15),
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
