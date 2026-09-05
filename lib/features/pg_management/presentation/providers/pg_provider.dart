import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../injection/service_locator.dart';
import '../../domain/entities/pg_entity.dart';
import '../../domain/repositories/pg_repository.dart';

/// Provider for the list of PGs.
final pgListProvider = FutureProvider.autoDispose<List<PgEntity>>((ref) async {
  final repository = getIt<PgRepository>();
  return repository.getPGs();
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
