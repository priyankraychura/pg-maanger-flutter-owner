import '../entities/owner_entity.dart';

abstract class AuthRepository {
  Future<OwnerEntity> login({required String email, required String password});
  Future<void> forgotPassword({required String email});
  Future<void> resetPassword({required String email, required String newPassword});
  Future<void> logout();
}
