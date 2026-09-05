import '../../features/wifi/domain/entities/wifi_entity.dart';
import './owners_table.dart';

/// `wifi` table — WiFi networks configured per PG / floor.
List<WifiEntity> seedWifi() => [
      WifiEntity(id: 'w1', pgId: 'pg_001', networkName: 'Sunshine_Floor1', password: 'sunshine@123', floor: '1st Floor', lastUpdated: DateTime.now().subtract(const Duration(days: 10)), updatedBy: kPrimaryOwnerId),
      WifiEntity(id: 'w2', pgId: 'pg_001', networkName: 'Sunshine_Floor2', password: 'sunshine@456', floor: '2nd Floor', lastUpdated: DateTime.now().subtract(const Duration(days: 10)), updatedBy: kPrimaryOwnerId),
    ];
