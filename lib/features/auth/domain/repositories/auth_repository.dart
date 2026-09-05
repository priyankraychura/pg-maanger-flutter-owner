import '../entities/owner_entity.dart';

abstract class AuthRepository {
  Future<OwnerEntity> login({required String email, required String password});

  /// Register a new owner along with their first PG property.
  Future<OwnerEntity> register(RegistrationData data);

  Future<void> forgotPassword({required String email});
  Future<void> resetPassword({required String email, required String newPassword});

  /// Update the signed-in account's personal details.
  Future<OwnerEntity> updateProfile({
    required OwnerEntity current,
    required String name,
    required String email,
    required String phone,
  });

  /// Change the signed-in account's password.
  ///
  /// Verifies [currentPassword] against the account identified by [email] and
  /// throws when it does not match; otherwise the password is updated.
  Future<void> changePassword({
    required String email,
    required String currentPassword,
    required String newPassword,
  });

  Future<void> logout();
}

/// Payload collected by the owner registration flow.
///
/// Groups the owner's personal account details together with the details of
/// the first PG property they set up during sign-up.
class RegistrationData {
  // ─── Owner account ───────────────────────────────
  final String name;
  final String email;
  final String phone;
  final String password;

  // ─── First PG property ───────────────────────────
  final String pgName;
  final String pgAddress;
  final String pgCity;
  final String pgContactPhone;
  final String pgContactEmail;
  final int totalFloors;
  final int totalRooms;
  final int totalBeds;
  final List<String> amenities;

  const RegistrationData({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.pgName,
    required this.pgAddress,
    required this.pgCity,
    required this.pgContactPhone,
    required this.pgContactEmail,
    required this.totalFloors,
    required this.totalRooms,
    required this.totalBeds,
    this.amenities = const [],
  });
}
