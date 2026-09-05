import '../../features/rooms/domain/entities/room_entity.dart';

/// `rooms` table — canonical source of truth for room numbers, rent and layout.
List<RoomEntity> seedRooms() => const [
      RoomEntity(id: 'r1', pgId: 'pg_001', roomNumber: 'A-101', floor: 1, roomType: RoomType.double_, totalBeds: 2, occupiedBeds: 2, monthlyRent: 8500, status: RoomStatus.full),
      RoomEntity(id: 'r2', pgId: 'pg_001', roomNumber: 'A-102', floor: 1, roomType: RoomType.triple, totalBeds: 3, occupiedBeds: 2, monthlyRent: 7500, status: RoomStatus.available),
      RoomEntity(id: 'r3', pgId: 'pg_001', roomNumber: 'A-201', floor: 2, roomType: RoomType.single, totalBeds: 1, occupiedBeds: 1, monthlyRent: 12000, status: RoomStatus.full),
      RoomEntity(id: 'r4', pgId: 'pg_001', roomNumber: 'A-202', floor: 2, roomType: RoomType.double_, totalBeds: 2, occupiedBeds: 1, monthlyRent: 8500, status: RoomStatus.available),
      RoomEntity(id: 'r5', pgId: 'pg_001', roomNumber: 'B-101', floor: 1, roomType: RoomType.dormitory, totalBeds: 6, occupiedBeds: 5, monthlyRent: 5500, status: RoomStatus.available),
      RoomEntity(id: 'r6', pgId: 'pg_001', roomNumber: 'B-201', floor: 2, roomType: RoomType.triple, totalBeds: 3, occupiedBeds: 0, monthlyRent: 7500, status: RoomStatus.maintenance),
      RoomEntity(id: 'r7', pgId: 'pg_002', roomNumber: 'G-101', floor: 1, roomType: RoomType.double_, totalBeds: 2, occupiedBeds: 2, monthlyRent: 7000, status: RoomStatus.full),
      RoomEntity(id: 'r8', pgId: 'pg_002', roomNumber: 'G-102', floor: 1, roomType: RoomType.triple, totalBeds: 3, occupiedBeds: 1, monthlyRent: 6000, status: RoomStatus.available),
    ];
