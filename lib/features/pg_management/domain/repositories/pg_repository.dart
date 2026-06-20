import '../entities/pg_entity.dart';

abstract class PgRepository {
  Future<List<PgEntity>> getPGs();
  Future<PgEntity> getPgById(String id);
  Future<PgEntity> createPg({
    required String name,
    required String address,
    required String city,
    required int totalFloors,
    required String contactPhone,
    required String contactEmail,
    List<String> amenities,
  });
  Future<PgEntity> updatePg(String id, {
    String? name,
    String? address,
    String? city,
    int? totalFloors,
    String? contactPhone,
    String? contactEmail,
    List<String>? amenities,
    bool? isActive,
  });
  Future<void> deletePg(String id);
}
