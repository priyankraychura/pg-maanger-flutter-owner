import '../../../../core/constants/app_constants.dart';
import '../../../../mock_database/mock_database.dart';
import '../../../../mock_database/tables/owners_table.dart';
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

    // Sign the primary owner in, echoing back the email that was entered.
    return MockDatabase.instance.owners.first.copyWith(email: email);
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
      assignedPgIds: const ['pg_new_001'],
      accessibleModules: kDefaultOwnerModules,
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
