import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/complaint_entity.dart';
import '../../domain/repositories/complaints_repository.dart';

class ComplaintsMockDatasource implements ComplaintsRepository {
  @override
  Future<List<ComplaintEntity>> getComplaints(String pgId, {ComplaintStatus? status}) async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay));
    return _mockComplaints.where((c) {
      if (c.pgId != pgId) return false;
      if (status != null && c.status != status) return false;
      return true;
    }).toList();
  }

  @override
  Future<ComplaintEntity> respondToComplaint(String id, {String? reply, ComplaintStatus? status, String? assignedTo}) async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay));
    final index = _mockComplaints.indexWhere((c) => c.id == id);
    final c = _mockComplaints[index];
    final updated = ComplaintEntity(
      id: c.id, pgId: c.pgId, tenantId: c.tenantId, tenantName: c.tenantName, roomNumber: c.roomNumber, category: c.category, title: c.title, description: c.description, imageUrl: c.imageUrl, status: status ?? c.status, createdAt: c.createdAt, resolvedAt: status == ComplaintStatus.resolved ? DateTime.now() : c.resolvedAt, ownerReply: reply ?? c.ownerReply, assignedTo: assignedTo ?? c.assignedTo,
    );
    _mockComplaints[index] = updated;
    return updated;
  }

  @override
  Future<ComplaintEntity> assignComplaint(String id, String assigneeId) async {
    return respondToComplaint(id, assignedTo: assigneeId, status: ComplaintStatus.inProgress);
  }

  static final _mockComplaints = <ComplaintEntity>[
    ComplaintEntity(id: 'c1', pgId: 'pg_001', tenantId: 't1', tenantName: 'Ankit Kumar', roomNumber: 'A-101', category: 'Electrical', title: 'Fan not working', description: 'The ceiling fan is making a lot of noise and rotating very slowly.', status: ComplaintStatus.pending, createdAt: DateTime.now().subtract(const Duration(hours: 5))),
    ComplaintEntity(id: 'c2', pgId: 'pg_001', tenantId: 't2', tenantName: 'Rahul Singh', roomNumber: 'A-101', category: 'Plumbing', title: 'Leaking tap', description: 'Bathroom tap is leaking continuously.', status: ComplaintStatus.inProgress, createdAt: DateTime.now().subtract(const Duration(days: 1)), assignedTo: 'Plumber John'),
    ComplaintEntity(id: 'c3', pgId: 'pg_001', tenantId: 't3', tenantName: 'Sneha Gupta', roomNumber: 'A-102', category: 'WiFi', title: 'Slow internet', description: 'WiFi speed is very slow since yesterday.', status: ComplaintStatus.resolved, createdAt: DateTime.now().subtract(const Duration(days: 3)), resolvedAt: DateTime.now().subtract(const Duration(days: 2)), ownerReply: 'We have upgraded the plan.'),
  ];
}
