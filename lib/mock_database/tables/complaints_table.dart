import '../../features/complaints/domain/entities/complaint_entity.dart';
import '../../features/tenants/domain/entities/tenant_entity.dart';
import './tenants_table.dart';

/// Canonical complaint record. Tenant name & room number are derived from the
/// `tenants` table when building items.
class _ComplaintSeed {
  final String id;
  final String pgId;
  final String tenantId;
  final String category;
  final String title;
  final String description;
  final ComplaintStatus status;
  final DateTime createdAt;
  final DateTime? resolvedAt;
  final String? ownerReply;
  final String? assignedTo;
  const _ComplaintSeed({required this.id, required this.pgId, required this.tenantId, required this.category, required this.title, required this.description, required this.status, required this.createdAt, this.resolvedAt, this.ownerReply, this.assignedTo});
}

List<_ComplaintSeed> _complaintSeeds() => [
      _ComplaintSeed(id: 'c1', pgId: 'pg_001', tenantId: 't1', category: 'Electrical', title: 'Fan not working', description: 'The ceiling fan is making a lot of noise and rotating very slowly.', status: ComplaintStatus.pending, createdAt: DateTime.now().subtract(const Duration(hours: 5))),
      _ComplaintSeed(id: 'c2', pgId: 'pg_001', tenantId: 't2', category: 'Plumbing', title: 'Leaking tap', description: 'Bathroom tap is leaking continuously.', status: ComplaintStatus.inProgress, createdAt: DateTime.now().subtract(const Duration(days: 1)), assignedTo: 'Plumber John'),
      _ComplaintSeed(id: 'c3', pgId: 'pg_001', tenantId: 't3', category: 'WiFi', title: 'Slow internet', description: 'WiFi speed is very slow since yesterday.', status: ComplaintStatus.resolved, createdAt: DateTime.now().subtract(const Duration(days: 3)), resolvedAt: DateTime.now().subtract(const Duration(days: 2)), ownerReply: 'We have upgraded the plan.'),
    ];

/// `complaints` table — tenant issues with name & room derived from [tenants].
List<ComplaintEntity> seedComplaints({required List<TenantEntity> tenants}) {
  return _complaintSeeds().map((c) {
    final tenant = tenants.byId(c.tenantId);
    return ComplaintEntity(
      id: c.id,
      pgId: c.pgId,
      tenantId: c.tenantId,
      tenantName: tenant.name,
      roomNumber: tenant.roomNumber ?? '',
      category: c.category,
      title: c.title,
      description: c.description,
      status: c.status,
      createdAt: c.createdAt,
      resolvedAt: c.resolvedAt,
      ownerReply: c.ownerReply,
      assignedTo: c.assignedTo,
    );
  }).toList();
}
