/// Room entity for PG rooms.
class RoomEntity {
  final String id;
  final String pgId;
  final String roomNumber;
  final int floor;
  final RoomType roomType;
  final int totalBeds;
  final int occupiedBeds;
  final double monthlyRent;
  final List<String> amenities;
  final RoomStatus status;

  const RoomEntity({
    required this.id,
    required this.pgId,
    required this.roomNumber,
    required this.floor,
    required this.roomType,
    required this.totalBeds,
    required this.occupiedBeds,
    required this.monthlyRent,
    this.amenities = const [],
    required this.status,
  });

  int get availableBeds => totalBeds - occupiedBeds;
  bool get isFull => occupiedBeds >= totalBeds;
}

enum RoomType { single, double_, triple, dormitory }

extension RoomTypeLabel on RoomType {
  String get label {
    switch (this) {
      case RoomType.single: return 'Single';
      case RoomType.double_: return 'Double';
      case RoomType.triple: return 'Triple';
      case RoomType.dormitory: return 'Dormitory';
    }
  }
}

enum RoomStatus { available, full, maintenance }

/// Bed entity for individual beds within a room.
class BedEntity {
  final String id;
  final String roomId;
  final String bedNumber;
  final BedStatus status;
  final String? tenantId;
  final String? tenantName;

  const BedEntity({
    required this.id,
    required this.roomId,
    required this.bedNumber,
    required this.status,
    this.tenantId,
    this.tenantName,
  });
}

enum BedStatus { available, occupied, reserved }
