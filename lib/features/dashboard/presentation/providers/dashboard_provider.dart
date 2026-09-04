import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/pg_selection_provider.dart';
import '../../../../injection/service_locator.dart';
import '../../domain/entities/dashboard_entity.dart';
import '../../domain/repositories/dashboard_repository.dart';

/// Dashboard provider — re-fetches when selected PG changes.
final dashboardProvider =
    FutureProvider.autoDispose<OwnerDashboardEntity>((ref) async {
  final pgId = ref.watch(pgSelectionProvider);
  if (pgId == null) {
    throw Exception('No PG selected');
  }
  final repository = getIt<DashboardRepository>();
  return repository.getDashboardData(pgId);
});
