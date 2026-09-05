import '../../../../core/constants/app_constants.dart';
import '../../../../mock_database/mock_database.dart';
import '../../../../mock_database/tables/owners_table.dart';
import '../../domain/entities/wifi_entity.dart';
import '../../domain/repositories/wifi_repository.dart';

class WifiMockDatasource implements WifiRepository {
  List<WifiEntity> get _wifi => MockDatabase.instance.wifi;

  @override
  Future<List<WifiEntity>> getWifiNetworks(String pgId) async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay));
    return _wifi.where((w) => w.pgId == pgId).toList();
  }

  @override
  Future<WifiEntity> createWifi({required String pgId, required String networkName, required String password, String? floor, String? zone}) async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay));
    final w = WifiEntity(id: 'w_${DateTime.now().millisecondsSinceEpoch}', pgId: pgId, networkName: networkName, password: password, floor: floor, zone: zone, lastUpdated: DateTime.now(), updatedBy: kPrimaryOwnerId);
    _wifi.add(w);
    return w;
  }

  @override
  Future<WifiEntity> updateWifi(String id, {String? networkName, String? password, String? floor, String? zone}) async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay));
    final index = _wifi.indexWhere((w) => w.id == id);
    final w = _wifi[index];
    final updated = WifiEntity(id: w.id, pgId: w.pgId, networkName: networkName ?? w.networkName, password: password ?? w.password, floor: floor ?? w.floor, zone: zone ?? w.zone, lastUpdated: DateTime.now(), updatedBy: kPrimaryOwnerId);
    _wifi[index] = updated;
    return updated;
  }

  @override
  Future<void> deleteWifi(String id) async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay));
    _wifi.removeWhere((w) => w.id == id);
  }
}
