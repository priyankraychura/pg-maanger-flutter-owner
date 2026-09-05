import '../../../../core/constants/app_constants.dart';
import '../../../../mock_database/mock_database.dart';
import '../../domain/entities/room_entity.dart';
import '../../domain/repositories/room_repository.dart';

class RoomMockDatasource implements RoomRepository {
  List<RoomEntity> get _rooms => MockDatabase.instance.rooms;
  List<BedEntity> get _beds => MockDatabase.instance.beds;

  @override
  Future<List<RoomEntity>> getRooms(String pgId) async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay));
    return _rooms.where((r) => r.pgId == pgId).toList();
  }

  @override
  Future<RoomEntity> getRoomById(String roomId) async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay ~/ 2));
    return _rooms.firstWhere((r) => r.id == roomId);
  }

  @override
  Future<RoomEntity> createRoom({required String pgId, required String roomNumber, required int floor, required RoomType roomType, required int totalBeds, required double monthlyRent, List<String> amenities = const []}) async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay));
    return RoomEntity(id: 'room_${DateTime.now().millisecondsSinceEpoch}', pgId: pgId, roomNumber: roomNumber, floor: floor, roomType: roomType, totalBeds: totalBeds, occupiedBeds: 0, monthlyRent: monthlyRent, amenities: amenities, status: RoomStatus.available);
  }

  @override
  Future<RoomEntity> updateRoom(String id, {String? roomNumber, int? floor, RoomType? roomType, int? totalBeds, double? monthlyRent, List<String>? amenities}) async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay));
    return _rooms.firstWhere((r) => r.id == id);
  }

  @override
  Future<void> deleteRoom(String id) async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay));
  }

  @override
  Future<List<BedEntity>> getBeds(String roomId) async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay ~/ 2));
    return _beds.where((b) => b.roomId == roomId).toList();
  }

  @override
  Future<BedEntity> updateBedStatus(String bedId, BedStatus status) async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay));
    return _beds.firstWhere((b) => b.id == bedId);
  }
}
