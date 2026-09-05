import '../../features/leave_notices/domain/entities/leave_notice_entity.dart';
import '../../features/tenants/domain/entities/tenant_entity.dart';
import './tenants_table.dart';

/// Canonical leave-notice record. Tenant name & room number are derived from
/// the `tenants` table when building items.
class _LeaveNoticeSeed {
  final String id;
  final String pgId;
  final String tenantId;
  final DateTime requestDate;
  final DateTime moveOutDate;
  final String reason;
  final LeaveNoticeStatus status;
  final String? ownerRemarks;
  const _LeaveNoticeSeed({required this.id, required this.pgId, required this.tenantId, required this.requestDate, required this.moveOutDate, required this.reason, required this.status, this.ownerRemarks});
}

List<_LeaveNoticeSeed> _leaveNoticeSeeds() => [
      _LeaveNoticeSeed(id: 'ln1', pgId: 'pg_001', tenantId: 't3', requestDate: DateTime.now().subtract(const Duration(days: 2)), moveOutDate: DateTime.now().add(const Duration(days: 28)), reason: 'Job transfer to another city', status: LeaveNoticeStatus.pending),
      _LeaveNoticeSeed(id: 'ln2', pgId: 'pg_001', tenantId: 't1', requestDate: DateTime.now().subtract(const Duration(days: 45)), moveOutDate: DateTime.now().subtract(const Duration(days: 15)), reason: 'Found a flat', status: LeaveNoticeStatus.approved, ownerRemarks: 'Clearance done.'),
    ];

/// `leaveNotices` table — move-out requests with name & room derived from [tenants].
List<LeaveNoticeEntity> seedLeaveNotices({required List<TenantEntity> tenants}) {
  return _leaveNoticeSeeds().map((l) {
    final tenant = tenants.byId(l.tenantId);
    return LeaveNoticeEntity(
      id: l.id,
      pgId: l.pgId,
      tenantId: l.tenantId,
      tenantName: tenant.name,
      roomNumber: tenant.roomNumber ?? '',
      requestDate: l.requestDate,
      moveOutDate: l.moveOutDate,
      reason: l.reason,
      status: l.status,
      ownerRemarks: l.ownerRemarks,
    );
  }).toList();
}
