import '../entities/tenant_entity.dart';

abstract class TenantRepository {
  Future<List<TenantEntity>> getTenants(String pgId);
  Future<TenantEntity> getTenantById(String id);
  Future<TenantEntity> approveTenant(String id);
  Future<void> rejectTenant(String id, String reason);
  Future<TenantEntity> updateTenant(String id, {
    String? roomId,
    String? bedId,
    String? roomNumber,
    String? bedNumber,
    TenantStatus? status,
    DateTime? moveOutDate,
  });
  Future<void> removeTenant(String id);
  Future<List<TenantEntity>> getPendingApprovals(String pgId);
}
