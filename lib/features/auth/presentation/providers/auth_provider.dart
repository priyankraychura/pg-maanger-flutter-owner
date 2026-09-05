import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../injection/service_locator.dart';
import '../../domain/entities/owner_entity.dart';
import '../../domain/repositories/auth_repository.dart' show AuthRepository, RegistrationData;

/// Auth state: null = not authenticated, OwnerEntity = authenticated.
class AuthNotifier extends StateNotifier<AsyncValue<OwnerEntity?>> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(const AsyncValue.data(null));

  Future<void> login({required String email, required String password}) async {
    state = const AsyncValue.loading();
    try {
      final owner = await _repository.login(email: email, password: password);
      state = AsyncValue.data(owner);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Register a new owner + their first PG, then sign them in.
  Future<void> register(RegistrationData data) async {
    state = const AsyncValue.loading();
    try {
      final owner = await _repository.register(data);
      state = AsyncValue.data(owner);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Dev login — bypass authentication for development.
  Future<void> devLogin() async {
    state = const AsyncValue.loading();
    try {
      final owner = await _repository.login(
        email: 'dev@pgmanager.com',
        password: 'Dev@1234',
      );
      state = AsyncValue.data(owner);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Update the signed-in owner's personal details.
  ///
  /// Keeps the current [OwnerEntity] in state throughout (never flips to
  /// loading) so route guards watching the auth state don't briefly see a
  /// signed-out user. Throws on failure for the caller to surface.
  Future<void> updateProfile({
    required String name,
    required String email,
    required String phone,
  }) async {
    final current = state.valueOrNull;
    if (current == null) return;

    final updated = await _repository.updateProfile(
      current: current,
      name: name,
      email: email,
      phone: phone,
    );
    state = AsyncValue.data(updated);
  }

  /// Change the signed-in owner's password after verifying the current one.
  ///
  /// Throws (e.g. when the current password is wrong) for the caller to handle;
  /// the auth state is left untouched.
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final current = state.valueOrNull;
    if (current == null) return;

    await _repository.changePassword(
      email: current.email,
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }

  Future<void> logout() async {
    await _repository.logout();
    state = const AsyncValue.data(null);
  }
}

final authProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<OwnerEntity?>>((ref) {
  return AuthNotifier(getIt<AuthRepository>());
});

/// Convenience provider for the current owner (non-null when authenticated).
final currentOwnerProvider = Provider<OwnerEntity?>((ref) {
  return ref.watch(authProvider).valueOrNull;
});
