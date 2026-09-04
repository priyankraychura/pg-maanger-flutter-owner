/// Owner dashboard aggregate entity.
class OwnerDashboardEntity {
  final int totalPGs;
  final int totalRooms;
  final int totalBeds;
  final int occupiedBeds;
  final int availableBeds;
  final int totalTenants;
  final int pendingApprovals;
  final int activeComplaints;
  final int pendingPayments;
  final double totalRevenue;
  final double collectionRate;
  final List<ActivityItem> recentActivity;

  const OwnerDashboardEntity({
    required this.totalPGs,
    required this.totalRooms,
    required this.totalBeds,
    required this.occupiedBeds,
    required this.availableBeds,
    required this.totalTenants,
    this.pendingApprovals = 0,
    this.activeComplaints = 0,
    this.pendingPayments = 0,
    this.totalRevenue = 0,
    this.collectionRate = 0,
    this.recentActivity = const [],
  });
}

class ActivityItem {
  final String id;
  final String title;
  final String description;
  final ActivityType type;
  final DateTime timestamp;

  const ActivityItem({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.timestamp,
  });
}

enum ActivityType {
  tenantJoined,
  complaintRaised,
  paymentReceived,
  leaveNotice,
  tenantApproval,
  noticeIssued,
}
