import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/room_entity.dart';
import '../../domain/repositories/room_repository.dart';

class RoomMockDatasource implements RoomRepository {
  @override
  Future<List<RoomEntity>> getRooms(String pgId) async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay));
    return _mockRooms.where((r) => r.pgId == pgId).toList();
  }

  @override
  Future<RoomEntity> getRoomById(String roomId) async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay ~/ 2));
    return _mockRooms.firstWhere((r) => r.id == roomId);
  }

  @override
  Future<RoomEntity> createRoom({required String pgId, required String roomNumber, required int floor, required RoomType roomType, required int totalBeds, required double monthlyRent, List<String> amenities = const []}) async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay));
    return RoomEntity(id: 'room_${DateTime.now().millisecondsSinceEpoch}', pgId: pgId, roomNumber: roomNumber, floor: floor, roomType: roomType, totalBeds: totalBeds, occupiedBeds: 0, monthlyRent: monthlyRent, amenities: amenities, status: RoomStatus.available);
  }

  @override
  Future<RoomEntity> updateRoom(String id, {String? roomNumber, int? floor, RoomType? roomType, int? totalBeds, double? monthlyRent, List<String>? amenities}) async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay));
    return _mockRooms.firstWhere((r) => r.id == id);
  }

  @override
  Future<void> deleteRoom(String id) async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay));
  }

  @override
  Future<List<BedEntity>> getBeds(String roomId) async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay ~/ 2));
    return _mockBeds.where((b) => b.roomId == roomId).toList();
  }

  @override
  Future<BedEntity> updateBedStatus(String bedId, BedStatus status) async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay));
    return _mockBeds.firstWhere((b) => b.id == bedId);
  }

  static final _mockRooms = <RoomEntity>[
    const RoomEntity(id: 'r1', pgId: 'pg_001', roomNumber: 'A-101', floor: 1, roomType: RoomType.double_, totalBeds: 2, occupiedBeds: 2, monthlyRent: 8500, status: RoomStatus.full),
    const RoomEntity(id: 'r2', pgId: 'pg_001', roomNumber: 'A-102', floor: 1, roomType: RoomType.triple, totalBeds: 3, occupiedBeds: 2, monthlyRent: 7500, status: RoomStatus.available),
    const RoomEntity(id: 'r3', pgId: 'pg_001', roomNumber: 'A-201', floor: 2, roomType: RoomType.single, totalBeds: 1, occupiedBeds: 1, monthlyRent: 12000, status: RoomStatus.full),
    const RoomEntity(id: 'r4', pgId: 'pg_001', roomNumber: 'A-202', floor: 2, roomType: RoomType.double_, totalBeds: 2, occupiedBeds: 1, monthlyRent: 8500, status: RoomStatus.available),
    const RoomEntity(id: 'r5', pgId: 'pg_001', roomNumber: 'B-101', floor: 1, roomType: RoomType.dormitory, totalBeds: 6, occupiedBeds: 5, monthlyRent: 5500, status: RoomStatus.available),
    const RoomEntity(id: 'r6', pgId: 'pg_001', roomNumber: 'B-201', floor: 2, roomType: RoomType.triple, totalBeds: 3, occupiedBeds: 0, monthlyRent: 7500, status: RoomStatus.maintenance),
    const RoomEntity(id: 'r7', pgId: 'pg_002', roomNumber: 'G-101', floor: 1, roomType: RoomType.double_, totalBeds: 2, occupiedBeds: 2, monthlyRent: 7000, status: RoomStatus.full),
    const RoomEntity(id: 'r8', pgId: 'pg_002', roomNumber: 'G-102', floor: 1, roomType: RoomType.triple, totalBeds: 3, occupiedBeds: 1, monthlyRent: 6000, status: RoomStatus.available),
  ];

  static const _mockBeds = <BedEntity>[
    BedEntity(id: 'b1', roomId: 'r1', bedNumber: 'Bed 1', status: BedStatus.occupied, tenantId: 't1', tenantName: 'Ankit Kumar'),
    BedEntity(id: 'b2', roomId: 'r1', bedNumber: 'Bed 2', status: BedStatus.occupied, tenantId: 't2', tenantName: 'Rahul Singh'),
    BedEntity(id: 'b3', roomId: 'r2', bedNumber: 'Bed 1', status: BedStatus.occupied, tenantId: 't3', tenantName: 'Sneha Gupta'),
    BedEntity(id: 'b4', roomId: 'r2', bedNumber: 'Bed 2', status: BedStatus.occupied, tenantId: 't4', tenantName: 'Priya Mehta'),
    BedEntity(id: 'b5', roomId: 'r2', bedNumber: 'Bed 3', status: BedStatus.available),
    BedEntity(id: 'b6', roomId: 'r5', bedNumber: 'Bed 1', status: BedStatus.occupied, tenantId: 't5', tenantName: 'Vikram Singh'),
    BedEntity(id: 'b7', roomId: 'r5', bedNumber: 'Bed 2', status: BedStatus.occupied, tenantId: 't6', tenantName: 'Amit Patel'),
    BedEntity(id: 'b8', roomId: 'r5', bedNumber: 'Bed 3', status: BedStatus.available),
  ];
}
