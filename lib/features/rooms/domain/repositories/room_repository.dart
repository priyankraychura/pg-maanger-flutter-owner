import '../entities/room_entity.dart';

abstract class RoomRepository {
  Future<List<RoomEntity>> getRooms(String pgId);
  Future<RoomEntity> getRoomById(String roomId);
  Future<RoomEntity> createRoom({
    required String pgId,
    required String roomNumber,
    required int floor,
    required RoomType roomType,
    required int totalBeds,
    required double monthlyRent,
    List<String> amenities,
  });
  Future<RoomEntity> updateRoom(String id, {String? roomNumber, int? floor, RoomType? roomType, int? totalBeds, double? monthlyRent, List<String>? amenities});
  Future<void> deleteRoom(String id);
  Future<List<BedEntity>> getBeds(String roomId);
  Future<BedEntity> updateBedStatus(String bedId, BedStatus status);
}
