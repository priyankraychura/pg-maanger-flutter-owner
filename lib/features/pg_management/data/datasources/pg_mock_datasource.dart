import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/pg_entity.dart';
import '../../domain/repositories/pg_repository.dart';

class PgMockDatasource implements PgRepository {
  final List<PgEntity> _pgs = [
    PgEntity(
      id: 'pg_001',
      name: 'Sunshine PG Residency',
      address: '42, MG Road, Koramangala',
      city: 'Bangalore',
      totalFloors: 4,
      totalRooms: 20,
      totalBeds: 45,
      occupiedBeds: 38,
      amenities: ['WiFi', 'Laundry', 'Parking', 'Gym', 'CCTV', 'Power Backup'],
      contactPhone: '9876543210',
      contactEmail: 'sunshine@pgmanager.com',
      createdAt: DateTime(2023, 6, 1),
    ),
    PgEntity(
      id: 'pg_002',
      name: 'Green Valley PG',
      address: '15, HSR Layout, Sector 7',
      city: 'Bangalore',
      totalFloors: 3,
      totalRooms: 12,
      totalBeds: 30,
      occupiedBeds: 22,
      amenities: ['WiFi', 'Laundry', 'CCTV', 'Power Backup', 'Water Purifier'],
      contactPhone: '9876543211',
      contactEmail: 'greenvalley@pgmanager.com',
      createdAt: DateTime(2024, 1, 15),
    ),
  ];

  @override
  Future<List<PgEntity>> getPGs() async {
    await Future.delayed(
      const Duration(milliseconds: AppConstants.mockApiDelay),
    );
    return List.unmodifiable(_pgs);
  }

  @override
  Future<PgEntity> getPgById(String id) async {
    await Future.delayed(
      const Duration(milliseconds: AppConstants.mockApiDelay ~/ 2),
    );
    return _pgs.firstWhere((pg) => pg.id == id);
  }

  @override
  Future<PgEntity> createPg({
    required String name,
    required String address,
    required String city,
    required int totalFloors,
    required String contactPhone,
    required String contactEmail,
    List<String> amenities = const [],
  }) async {
    await Future.delayed(
      const Duration(milliseconds: AppConstants.mockApiDelay),
    );
    final pg = PgEntity(
      id: 'pg_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      address: address,
      city: city,
      totalFloors: totalFloors,
      totalRooms: 0,
      totalBeds: 0,
      occupiedBeds: 0,
      amenities: amenities,
      contactPhone: contactPhone,
      contactEmail: contactEmail,
      createdAt: DateTime.now(),
    );
    _pgs.add(pg);
    return pg;
  }

  @override
  Future<PgEntity> updatePg(String id, {
    String? name,
    String? address,
    String? city,
    int? totalFloors,
    String? contactPhone,
    String? contactEmail,
    List<String>? amenities,
    bool? isActive,
  }) async {
    await Future.delayed(
      const Duration(milliseconds: AppConstants.mockApiDelay),
    );
    final index = _pgs.indexWhere((pg) => pg.id == id);
    final updated = _pgs[index].copyWith(
      name: name,
      address: address,
      city: city,
      totalFloors: totalFloors,
      contactPhone: contactPhone,
      contactEmail: contactEmail,
      amenities: amenities,
      isActive: isActive,
    );
    _pgs[index] = updated;
    return updated;
  }

  @override
  Future<void> deletePg(String id) async {
    await Future.delayed(
      const Duration(milliseconds: AppConstants.mockApiDelay),
    );
    _pgs.removeWhere((pg) => pg.id == id);
  }
}
