import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/pg_selection_provider.dart';
import '../../../../injection/service_locator.dart';
import '../../domain/entities/complaint_entity.dart';
import '../../domain/repositories/complaints_repository.dart';

/// Complaints for the currently selected PG — re-fetches when the selection
/// changes.
final complaintsProvider =
    FutureProvider.autoDispose<List<ComplaintEntity>>((ref) async {
  final pgId = ref.watch(pgSelectionProvider);
  if (pgId == null) {
    throw Exception('No PG selected');
  }
  final repository = getIt<ComplaintsRepository>();
  return repository.getComplaints(pgId);
});

/// Updates a complaint's status, then refreshes [complaintsProvider].
Future<void> updateComplaintStatus(
  WidgetRef ref,
  String id,
  ComplaintStatus status,
) async {
  await getIt<ComplaintsRepository>().respondToComplaint(id, status: status);
  ref.invalidate(complaintsProvider);
}
