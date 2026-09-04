import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/dashboard_entity.dart';
import '../../domain/repositories/dashboard_repository.dart';

class DashboardMockDatasource implements DashboardRepository {
  @override
  Future<OwnerDashboardEntity> getDashboardData(String pgId) async {
    await Future.delayed(
      const Duration(milliseconds: AppConstants.mockApiDelay),
    );

    if (pgId == 'pg_001') {
      return OwnerDashboardEntity(
        totalPGs: 2,
        totalRooms: 20,
        totalBeds: 45,
        occupiedBeds: 38,
        availableBeds: 7,
        totalTenants: 38,
        pendingApprovals: 3,
        activeComplaints: 5,
        pendingPayments: 8,
        totalRevenue: 323000,
        collectionRate: 78.9,
        recentActivity: [
          ActivityItem(
            id: 'a1',
            title: 'New Tenant Application',
            description: 'Rahul Verma applied for Room A-301',
            type: ActivityType.tenantApproval,
            timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
          ),
          ActivityItem(
            id: 'a2',
            title: 'Payment Received',
            description: 'Ankit Kumar paid ₹8,500 for July',
            type: ActivityType.paymentReceived,
            timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          ),
          ActivityItem(
            id: 'a3',
            title: 'Complaint Raised',
            description: 'WiFi not working in Block B',
            type: ActivityType.complaintRaised,
            timestamp: DateTime.now().subtract(const Duration(hours: 5)),
          ),
          ActivityItem(
            id: 'a4',
            title: 'Leave Notice',
            description: 'Sneha Gupta submitted leave notice for Aug 1',
            type: ActivityType.leaveNotice,
            timestamp: DateTime.now().subtract(const Duration(hours: 8)),
          ),
          ActivityItem(
            id: 'a5',
            title: 'Tenant Joined',
            description: 'Priya Mehta moved into Room B-102',
            type: ActivityType.tenantJoined,
            timestamp: DateTime.now().subtract(const Duration(days: 1)),
          ),
        ],
      );
    }

    return OwnerDashboardEntity(
      totalPGs: 2,
      totalRooms: 12,
      totalBeds: 30,
      occupiedBeds: 22,
      availableBeds: 8,
      totalTenants: 22,
      pendingApprovals: 1,
      activeComplaints: 2,
      pendingPayments: 4,
      totalRevenue: 187000,
      collectionRate: 85.2,
      recentActivity: [
        ActivityItem(
          id: 'b1',
          title: 'Payment Received',
          description: 'Vikram Singh paid ₹7,000 for July',
          type: ActivityType.paymentReceived,
          timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        ),
        ActivityItem(
          id: 'b2',
          title: 'Notice Issued',
          description: 'Water tank cleaning on June 25',
          type: ActivityType.noticeIssued,
          timestamp: DateTime.now().subtract(const Duration(hours: 6)),
        ),
      ],
    );
  }
}
