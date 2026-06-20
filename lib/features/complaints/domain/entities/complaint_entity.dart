/// Complaint entity representing tenant issues.
class ComplaintEntity {
  final String id;
  final String pgId;
  final String tenantId;
  final String tenantName;
  final String roomNumber;
  final String category;
  final String title;
  final String description;
  final String? imageUrl;
  final ComplaintStatus status;
  final DateTime createdAt;
  final DateTime? resolvedAt;
  final String? ownerReply;
  final String? assignedTo;

  const ComplaintEntity({
    required this.id,
    required this.pgId,
    required this.tenantId,
    required this.tenantName,
    required this.roomNumber,
    required this.category,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.status,
    required this.createdAt,
    this.resolvedAt,
    this.ownerReply,
    this.assignedTo,
  });
}

enum ComplaintStatus { pending, inProgress, resolved }

extension ComplaintStatusExtension on ComplaintStatus {
  String get label {
    switch (this) {
      case ComplaintStatus.pending: return 'Pending';
      case ComplaintStatus.inProgress: return 'In Progress';
      case ComplaintStatus.resolved: return 'Resolved';
    }
  }
}
