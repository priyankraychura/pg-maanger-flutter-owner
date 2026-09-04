import '../entities/dashboard_entity.dart';

abstract class DashboardRepository {
  Future<OwnerDashboardEntity> getDashboardData(String pgId);
}
