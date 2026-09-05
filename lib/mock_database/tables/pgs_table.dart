import '../../features/pg_management/domain/entities/pg_entity.dart';

/// `pgs` table — the PG properties owned/managed in the app.
List<PgEntity> seedPgs() => [
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
        amenities: [
          'WiFi',
          'Laundry',
          'CCTV',
          'Power Backup',
          'Water Purifier',
        ],
        contactPhone: '9876543211',
        contactEmail: 'greenvalley@pgmanager.com',
        createdAt: DateTime(2024, 1, 15),
      ),
    ];
