/// PG property entity.
class PgEntity {
  final String id;
  final String name;
  final String address;
  final String city;
  final int totalFloors;
  final int totalRooms;
  final int totalBeds;
  final int occupiedBeds;
  final List<String> amenities;
  final String contactPhone;
  final String contactEmail;
  final DateTime createdAt;
  final bool isActive;

  const PgEntity({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.totalFloors,
    required this.totalRooms,
    required this.totalBeds,
    required this.occupiedBeds,
    this.amenities = const [],
    required this.contactPhone,
    required this.contactEmail,
    required this.createdAt,
    this.isActive = true,
  });

  int get availableBeds => totalBeds - occupiedBeds;

  double get occupancyRate =>
      totalBeds > 0 ? (occupiedBeds / totalBeds) * 100 : 0;

  PgEntity copyWith({
    String? name,
    String? address,
    String? city,
    int? totalFloors,
    int? totalRooms,
    int? totalBeds,
    int? occupiedBeds,
    List<String>? amenities,
    String? contactPhone,
    String? contactEmail,
    bool? isActive,
  }) {
    return PgEntity(
      id: id,
      name: name ?? this.name,
      address: address ?? this.address,
      city: city ?? this.city,
      totalFloors: totalFloors ?? this.totalFloors,
      totalRooms: totalRooms ?? this.totalRooms,
      totalBeds: totalBeds ?? this.totalBeds,
      occupiedBeds: occupiedBeds ?? this.occupiedBeds,
      amenities: amenities ?? this.amenities,
      contactPhone: contactPhone ?? this.contactPhone,
      contactEmail: contactEmail ?? this.contactEmail,
      createdAt: createdAt,
      isActive: isActive ?? this.isActive,
    );
  }
}
