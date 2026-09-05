import '../../../../core/constants/app_constants.dart';
import '../../../../mock_database/mock_database.dart';
import '../../domain/entities/complaint_entity.dart';
import '../../domain/repositories/complaints_repository.dart';

class ComplaintsMockDatasource implements ComplaintsRepository {
  List<ComplaintEntity> get _complaints => MockDatabase.instance.complaints;

  @override
  Future<List<ComplaintEntity>> getComplaints(String pgId, {ComplaintStatus? status}) async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay));
    return _complaints.where((c) {
      if (c.pgId != pgId) return false;
      if (status != null && c.status != status) return false;
      return true;
    }).toList();
  }

  @override
  Future<ComplaintEntity> respondToComplaint(String id, {String? reply, ComplaintStatus? status, String? assignedTo}) async {
    await Future.delayed(const Duration(milliseconds: AppConstants.mockApiDelay));
    final index = _complaints.indexWhere((c) => c.id == id);
    final c = _complaints[index];
    final updated = ComplaintEntity(
      id: c.id, pgId: c.pgId, tenantId: c.tenantId, tenantName: c.tenantName, roomNumber: c.roomNumber, category: c.category, title: c.title, description: c.description, imageUrl: c.imageUrl, status: status ?? c.status, createdAt: c.createdAt, resolvedAt: status == ComplaintStatus.resolved ? DateTime.now() : c.resolvedAt, ownerReply: reply ?? c.ownerReply, assignedTo: assignedTo ?? c.assignedTo,
    );
    _complaints[index] = updated;
    return updated;
  }

  @override
  Future<ComplaintEntity> assignComplaint(String id, String assigneeId) async {
    return respondToComplaint(id, assignedTo: assigneeId, status: ComplaintStatus.inProgress);
  }
}
