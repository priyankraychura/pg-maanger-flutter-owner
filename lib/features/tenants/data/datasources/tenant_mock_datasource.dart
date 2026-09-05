import '../../../../core/constants/app_constants.dart';
import '../../../../mock_database/mock_database.dart';
import '../../domain/entities/tenant_entity.dart';
import '../../domain/repositories/tenant_repository.dart';

class TenantMockDatasource implements TenantRepository {
  List<TenantEntity> get _tenants => MockDatabase.instance.tenants;

  @override
  Future<List<TenantEntity>> getTenants(String pgId) async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay));
    return _tenants.where((t) => t.pgId == pgId).toList();
  }

  @override
  Future<TenantEntity> getTenantById(String id) async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay ~/ 2));
    return _tenants.firstWhere((t) => t.id == id);
  }

  @override
  Future<TenantEntity> approveTenant(String id) async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay));
    return _tenants.firstWhere((t) => t.id == id);
  }

  @override
  Future<void> rejectTenant(String id, String reason) async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay));
  }

  @override
  Future<TenantEntity> updateTenant(String id, {String? roomId, String? bedId, String? roomNumber, String? bedNumber, TenantStatus? status, DateTime? moveOutDate}) async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay));
    return _tenants.firstWhere((t) => t.id == id);
  }

  @override
  Future<void> removeTenant(String id) async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay));
  }

  @override
  Future<List<TenantEntity>> getPendingApprovals(String pgId) async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay));
    return _tenants.where((t) => t.pgId == pgId && t.status == TenantStatus.pending).toList();
  }
}
