import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/tenant_entity.dart';
import '../../domain/repositories/tenant_repository.dart';

class TenantMockDatasource implements TenantRepository {
  @override
  Future<List<TenantEntity>> getTenants(String pgId) async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay));
    return _mockTenants.where((t) => t.pgId == pgId).toList();
  }

  @override
  Future<TenantEntity> getTenantById(String id) async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay ~/ 2));
    return _mockTenants.firstWhere((t) => t.id == id);
  }

  @override
  Future<TenantEntity> approveTenant(String id) async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay));
    return _mockTenants.firstWhere((t) => t.id == id);
  }

  @override
  Future<void> rejectTenant(String id, String reason) async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay));
  }

  @override
  Future<TenantEntity> updateTenant(String id, {String? roomId, String? bedId, String? roomNumber, String? bedNumber, TenantStatus? status, DateTime? moveOutDate}) async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay));
    return _mockTenants.firstWhere((t) => t.id == id);
  }

  @override
  Future<void> removeTenant(String id) async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay));
  }

  @override
  Future<List<TenantEntity>> getPendingApprovals(String pgId) async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay));
    return _mockTenants.where((t) => t.pgId == pgId && t.status == TenantStatus.pending).toList();
  }

  static final _mockTenants = <TenantEntity>[
    TenantEntity(id: 't1', pgId: 'pg_001', name: 'Ankit Kumar', email: 'ankit@example.com', phone: '9876543201', roomId: 'r1', roomNumber: 'A-101', bedId: 'b1', bedNumber: 'Bed 1', joinDate: DateTime(2025, 1, 10), status: TenantStatus.active, kycStatus: 'Verified', emergencyContact: '9876543299', emergencyContactName: 'Raj Kumar', occupation: 'Software Engineer', idProofType: 'Aadhar', idProofNumber: '1234 5678 9012'),
    TenantEntity(id: 't2', pgId: 'pg_001', name: 'Rahul Singh', email: 'rahul@example.com', phone: '9876543202', roomId: 'r1', roomNumber: 'A-101', bedId: 'b2', bedNumber: 'Bed 2', joinDate: DateTime(2025, 2, 15), status: TenantStatus.active),
    TenantEntity(id: 't3', pgId: 'pg_001', name: 'Sneha Gupta', email: 'sneha@example.com', phone: '9876543203', roomId: 'r2', roomNumber: 'A-102', bedId: 'b3', bedNumber: 'Bed 1', joinDate: DateTime(2025, 5, 20), status: TenantStatus.active),
    TenantEntity(id: 't4', pgId: 'pg_001', name: 'Priya Mehta', email: 'priya@example.com', phone: '9876543204', roomId: 'r2', roomNumber: 'A-102', bedId: 'b4', bedNumber: 'Bed 2', joinDate: DateTime(2026, 6, 15), status: TenantStatus.pending),
    TenantEntity(id: 't5', pgId: 'pg_001', name: 'Vikram Singh', email: 'vikram@example.com', phone: '9876543205', roomId: 'r5', roomNumber: 'B-101', bedId: 'b6', bedNumber: 'Bed 1', joinDate: DateTime(2024, 11, 5), status: TenantStatus.active),
    TenantEntity(id: 't6', pgId: 'pg_001', name: 'Amit Patel', email: 'amit@example.com', phone: '9876543206', roomId: 'r5', roomNumber: 'B-101', bedId: 'b7', bedNumber: 'Bed 2', joinDate: DateTime(2026, 1, 12), status: TenantStatus.active),
    TenantEntity(id: 't7', pgId: 'pg_001', name: 'Deepak Sharma', email: 'deepak@example.com', phone: '9876543207', joinDate: DateTime.now().subtract(const Duration(days: 2)), status: TenantStatus.pending),
  ];
}
