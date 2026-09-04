import '../entities/wifi_entity.dart';

abstract class WifiRepository {
  Future<List<WifiEntity>> getWifiNetworks(String pgId);
  Future<WifiEntity> createWifi({required String pgId, required String networkName, required String password, String? floor, String? zone});
  Future<WifiEntity> updateWifi(String id, {String? networkName, String? password, String? floor, String? zone});
  Future<void> deleteWifi(String id);
}
