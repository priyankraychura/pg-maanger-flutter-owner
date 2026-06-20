import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../injection/service_locator.dart';
import '../../domain/entities/owner_entity.dart';
import '../../domain/repositories/auth_repository.dart';

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
