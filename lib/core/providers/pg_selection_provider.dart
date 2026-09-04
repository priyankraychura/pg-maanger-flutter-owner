import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Holds the currently selected PG ID.
/// All feature providers depend on this to scope data to the active PG.
class PgSelectionNotifier extends StateNotifier<String?> {
  PgSelectionNotifier() : super(null);

  void selectPg(String pgId) => state = pgId;
  void clear() => state = null;
}

final pgSelectionProvider =
    StateNotifierProvider<PgSelectionNotifier, String?>((ref) {
  return PgSelectionNotifier();
});
