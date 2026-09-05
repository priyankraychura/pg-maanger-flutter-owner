import '../../features/rooms/domain/entities/room_entity.dart';
import '../../features/tenants/domain/entities/tenant_entity.dart';
import './beds_table.dart';

/// Canonical tenant identity — the single source of truth for a tenant's
/// personal details. Room/bed assignment is NOT stored here; it is derived
/// from the `beds` table so occupancy lives in exactly one place.
class _TenantSeed {
  final String id;
  final String pgId;
  final String name;
  final String email;
  final String phone;
  final DateTime joinDate;
  final TenantStatus status;
  final String? kycStatus;
  final String? emergencyContact;
  final String? emergencyContactName;
  final String? occupation;
  final String? idProofType;
  final String? idProofNumber;

  const _TenantSeed({
    required this.id,
    required this.pgId,
    required this.name,
    required this.email,
    required this.phone,
    required this.joinDate,
    required this.status,
    this.kycStatus,
    this.emergencyContact,
    this.emergencyContactName,
    this.occupation,
    this.idProofType,
    this.idProofNumber,
  });
}

List<_TenantSeed> _tenantSeeds() => [
      _TenantSeed(id: 't1', pgId: 'pg_001', name: 'Ankit Kumar', email: 'ankit@example.com', phone: '9876543201', joinDate: DateTime(2025, 1, 10), status: TenantStatus.active, kycStatus: 'Verified', emergencyContact: '9876543299', emergencyContactName: 'Raj Kumar', occupation: 'Software Engineer', idProofType: 'Aadhar', idProofNumber: '1234 5678 9012'),
      _TenantSeed(id: 't2', pgId: 'pg_001', name: 'Rahul Singh', email: 'rahul@example.com', phone: '9876543202', joinDate: DateTime(2025, 2, 15), status: TenantStatus.active),
      _TenantSeed(id: 't3', pgId: 'pg_001', name: 'Sneha Gupta', email: 'sneha@example.com', phone: '9876543203', joinDate: DateTime(2025, 5, 20), status: TenantStatus.active),
      _TenantSeed(id: 't4', pgId: 'pg_001', name: 'Priya Mehta', email: 'priya@example.com', phone: '9876543204', joinDate: DateTime(2026, 6, 15), status: TenantStatus.pending),
      _TenantSeed(id: 't5', pgId: 'pg_001', name: 'Vikram Singh', email: 'vikram@example.com', phone: '9876543205', joinDate: DateTime(2024, 11, 5), status: TenantStatus.active),
      _TenantSeed(id: 't6', pgId: 'pg_001', name: 'Amit Patel', email: 'amit@example.com', phone: '9876543206', joinDate: DateTime(2026, 1, 12), status: TenantStatus.active),
      _TenantSeed(id: 't7', pgId: 'pg_001', name: 'Deepak Sharma', email: 'deepak@example.com', phone: '9876543207', joinDate: DateTime.now().subtract(const Duration(days: 2)), status: TenantStatus.pending),
    ];

/// Tenant id → name map, used by other tables (beds, payments, …) so a
/// tenant's name is defined once, here.
Map<String, String> seedTenantNames() => {
      for (final t in _tenantSeeds()) t.id: t.name,
    };

/// Convenience lookup so dependent tables (payments, complaints, leave
/// notices) can derive a tenant's name and current room without retyping them.
extension TenantTableLookup on List<TenantEntity> {
  TenantEntity byId(String id) => firstWhere((t) => t.id == id);
}

/// `tenants` table — full tenant items. Room number / bed number / assignment
/// are derived from the [rooms] and `beds` tables rather than duplicated.
List<TenantEntity> seedTenants({required List<RoomEntity> rooms}) {
  return _tenantSeeds().map((t) {
    final assignment = bedAssignmentForTenant(t.id);
    final roomNumber = assignment == null
        ? null
        : rooms.firstWhere((r) => r.id == assignment.roomId).roomNumber;
    return TenantEntity(
      id: t.id,
      pgId: t.pgId,
      name: t.name,
      email: t.email,
      phone: t.phone,
      roomId: assignment?.roomId,
      bedId: assignment?.bedId,
      roomNumber: roomNumber,
      bedNumber: assignment?.bedNumber,
      joinDate: t.joinDate,
      status: t.status,
      kycStatus: t.kycStatus,
      emergencyContact: t.emergencyContact,
      emergencyContactName: t.emergencyContactName,
      occupation: t.occupation,
      idProofType: t.idProofType,
      idProofNumber: t.idProofNumber,
    );
  }).toList();
}
