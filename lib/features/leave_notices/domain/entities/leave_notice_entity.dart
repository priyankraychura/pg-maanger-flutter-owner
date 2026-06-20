/// Leave notice entity representing a tenant's request to move out.
class LeaveNoticeEntity {
  final String id;
  final String pgId;
  final String tenantId;
  final String tenantName;
  final String roomNumber;
  final DateTime requestDate;
  final DateTime moveOutDate;
  final String reason;
  final LeaveNoticeStatus status;
  final String? ownerRemarks;

  const LeaveNoticeEntity({
    required this.id,
    required this.pgId,
    required this.tenantId,
    required this.tenantName,
    required this.roomNumber,
    required this.requestDate,
    required this.moveOutDate,
    required this.reason,
    required this.status,
    this.ownerRemarks,
  });
}

enum LeaveNoticeStatus { pending, approved, rejected }

extension LeaveNoticeStatusExtension on LeaveNoticeStatus {
  String get label {
    switch (this) {
      case LeaveNoticeStatus.pending: return 'Pending';
      case LeaveNoticeStatus.approved: return 'Approved';
      case LeaveNoticeStatus.rejected: return 'Rejected';
    }
  }
}
