import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../injection/service_locator.dart';
import '../../../auth/domain/entities/user_role.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/pg_entity.dart';
import '../../domain/repositories/pg_repository.dart';

/// Provider for the full list of PGs (every property in the system).
///
/// Use this only on owner/admin-only screens. For anything a staff member can
/// see, use [accessiblePgListProvider] so they never see PGs they aren't
/// assigned to.
final pgListProvider = FutureProvider.autoDispose<List<PgEntity>>((ref) async {
  final repository = getIt<PgRepository>();
  return repository.getPGs();
});

/// The PGs the signed-in principal is allowed to see.
///
/// The owner (super admin) and admins manage every PG; managers/helpers only
/// see the PGs assigned to them (`OwnerEntity.assignedPgIds`).
final accessiblePgListProvider =
    FutureProvider.autoDispose<List<PgEntity>>((ref) async {
  final pgs = await ref.watch(pgListProvider.future);
  final owner = ref.watch(currentOwnerProvider);
  if (owner == null) return const [];
  if (owner.isSuperAdmin || owner.role == UserRole.admin) return pgs;
  final assigned = owner.assignedPgIds.toSet();
  return pgs.where((p) => assigned.contains(p.id)).toList(growable: false);
});

/// Exposes create / update actions for PG properties.
///
/// After a successful write the [pgListProvider] is invalidated so every
/// listener — the Manage PGs screen and the dashboard PG switcher — reflects
/// the change immediately.
final pgControllerProvider = Provider<PgController>((ref) {
  return PgController(ref);
});

class PgController {
  PgController(this._ref);

  final Ref _ref;
  PgRepository get _repository => getIt<PgRepository>();

  Future<PgEntity> createPg({
    required String name,
    required String address,
    required String city,
    required int totalFloors,
    required String contactPhone,
    required String contactEmail,
    List<String> amenities = const [],
  }) async {
    final pg = await _repository.createPg(
      name: name,
      address: address,
      city: city,
      totalFloors: totalFloors,
      contactPhone: contactPhone,
      contactEmail: contactEmail,
      amenities: amenities,
    );
    _ref.invalidate(pgListProvider);
    return pg;
  }

  Future<PgEntity> updatePg(
    String id, {
    String? name,
    String? address,
    String? city,
    int? totalFloors,
    String? contactPhone,
    String? contactEmail,
    List<String>? amenities,
    bool? isActive,
  }) async {
    final pg = await _repository.updatePg(
      id,
      name: name,
      address: address,
      city: city,
      totalFloors: totalFloors,
      contactPhone: contactPhone,
      contactEmail: contactEmail,
      amenities: amenities,
      isActive: isActive,
    );
    _ref.invalidate(pgListProvider);
    return pg;
  }
}
