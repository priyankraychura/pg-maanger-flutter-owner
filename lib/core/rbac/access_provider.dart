import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/presentation/providers/auth_provider.dart';
import 'access_policy.dart';

/// The access policy for the currently signed-in principal.
///
/// Every widget that gates content on permissions reads this — it is the one
/// place role/permission data is turned into an [AccessPolicy]. When no one is
/// signed in it yields [AccessPolicy.none] (grants nothing).
final accessPolicyProvider = Provider<AccessPolicy>((ref) {
  final owner = ref.watch(currentOwnerProvider);
  if (owner == null) return const AccessPolicy.none();
  return AccessPolicy(
    role: owner.role,
    isSuperAdmin: owner.isSuperAdmin,
    permissions: owner.permissions,
  );
});
