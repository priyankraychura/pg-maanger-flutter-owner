import '../../../../core/constants/app_constants.dart';
import '../../../../mock_database/tables/dashboard_snapshots_table.dart';
import '../../domain/entities/dashboard_entity.dart';
import '../../domain/repositories/dashboard_repository.dart';

class DashboardMockDatasource implements DashboardRepository {
  @override
  Future<OwnerDashboardEntity> getDashboardData(String pgId) async {
    await Future.delayed(
      const Duration(milliseconds: AppConstants.mockApiDelay),
    );
    return buildDashboardSnapshot(pgId);
  }
}
