import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/wifi_entity.dart';
import '../../domain/repositories/wifi_repository.dart';

class WifiMockDatasource implements WifiRepository {
  @override
  Future<List<WifiEntity>> getWifiNetworks(String pgId) async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay));
    return _mockWifi.where((w) => w.pgId == pgId).toList();
  }

  @override
  Future<WifiEntity> createWifi({required String pgId, required String networkName, required String password, String? floor, String? zone}) async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay));
    final w = WifiEntity(id: 'w_${DateTime.now().millisecondsSinceEpoch}', pgId: pgId, networkName: networkName, password: password, floor: floor, zone: zone, lastUpdated: DateTime.now(), updatedBy: 'owner_001');
    _mockWifi.add(w);
    return w;
  }

  @override
  Future<WifiEntity> updateWifi(String id, {String? networkName, String? password, String? floor, String? zone}) async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay));
    final index = _mockWifi.indexWhere((w) => w.id == id);
    final w = _mockWifi[index];
    final updated = WifiEntity(id: w.id, pgId: w.pgId, networkName: networkName ?? w.networkName, password: password ?? w.password, floor: floor ?? w.floor, zone: zone ?? w.zone, lastUpdated: DateTime.now(), updatedBy: 'owner_001');
    _mockWifi[index] = updated;
    return updated;
  }

  @override
  Future<void> deleteWifi(String id) async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay));
    _mockWifi.removeWhere((w) => w.id == id);
  }

  static final _mockWifi = <WifiEntity>[
    WifiEntity(id: 'w1', pgId: 'pg_001', networkName: 'Sunshine_Floor1', password: 'sunshine@123', floor: '1st Floor', lastUpdated: DateTime.now().subtract(const Duration(days: 10)), updatedBy: 'owner_001'),
    WifiEntity(id: 'w2', pgId: 'pg_001', networkName: 'Sunshine_Floor2', password: 'sunshine@456', floor: '2nd Floor', lastUpdated: DateTime.now().subtract(const Duration(days: 10)), updatedBy: 'owner_001'),
  ];
}
