import '../entities/complaint_entity.dart';

abstract class ComplaintsRepository {
  Future<List<ComplaintEntity>> getComplaints(String pgId, {ComplaintStatus? status});
  Future<ComplaintEntity> respondToComplaint(String id, {String? reply, ComplaintStatus? status, String? assignedTo});
  Future<ComplaintEntity> assignComplaint(String id, String assigneeId);
}
