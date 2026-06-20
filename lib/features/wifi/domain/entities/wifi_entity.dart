/// WiFi network entity.
class WifiEntity {
  final String id;
  final String pgId;
  final String networkName;
  final String password;
  final String? floor;
  final String? zone;
  final DateTime lastUpdated;
  final String updatedBy;

  const WifiEntity({
    required this.id,
    required this.pgId,
    required this.networkName,
    required this.password,
    this.floor,
    this.zone,
    required this.lastUpdated,
    required this.updatedBy,
  });
}
