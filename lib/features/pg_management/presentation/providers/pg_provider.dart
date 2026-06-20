import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../injection/service_locator.dart';
import '../../domain/entities/pg_entity.dart';
import '../../domain/repositories/pg_repository.dart';

/// Provider for the list of PGs.
final pgListProvider = FutureProvider.autoDispose<List<PgEntity>>((ref) async {
  final repository = getIt<PgRepository>();
  return repository.getPGs();
});
