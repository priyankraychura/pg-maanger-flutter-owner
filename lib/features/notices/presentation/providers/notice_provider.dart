import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/pg_selection_provider.dart';
import '../../../../injection/service_locator.dart';
import '../../domain/entities/notice_entity.dart';
import '../../domain/repositories/notice_repository.dart';

/// Notices for the currently selected PG — re-fetches when the selection changes.
final noticesProvider =
    FutureProvider.autoDispose<List<NoticeEntity>>((ref) async {
  final pgId = ref.watch(pgSelectionProvider);
  if (pgId == null) {
    throw Exception('No PG selected');
  }
  final repository = getIt<NoticeRepository>();
  return repository.getNotices(pgId);
});

/// Creates a notice for the selected PG, then refreshes [noticesProvider].
Future<void> createNotice(
  WidgetRef ref, {
  required String title,
  required NoticeCategory category,
  required String description,
  NoticePriority priority = NoticePriority.medium,
}) async {
  final pgId = ref.read(pgSelectionProvider);
  if (pgId == null) throw Exception('No PG selected');
  await getIt<NoticeRepository>().createNotice(
    pgId: pgId,
    title: title,
    category: category.key,
    description: description,
    priority: priority,
  );
  ref.invalidate(noticesProvider);
}
