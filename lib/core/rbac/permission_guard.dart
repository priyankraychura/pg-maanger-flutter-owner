import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/empty_state.dart';
import 'access_provider.dart';
import 'app_module.dart';

/// Renders [child] only when the current principal can view [module];
/// otherwise shows an access-denied placeholder.
///
/// Use this to wrap the body of a page whose whole content is scoped to one
/// module (e.g. Tenants, Payments), so a staff member without access sees a
/// clear message instead of data.
class PermissionGuard extends ConsumerWidget {
  final AppModule module;
  final Widget child;

  /// Optional builder used instead of the default access-denied state.
  final WidgetBuilder? denied;

  const PermissionGuard({
    super.key,
    required this.module,
    required this.child,
    this.denied,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canView = ref.watch(accessPolicyProvider).canView(module);
    if (canView) return child;
    if (denied != null) return denied!(context);
    return const AccessDeniedState();
  }
}

/// Standard "you don't have access" placeholder, built on [EmptyState].
class AccessDeniedState extends StatelessWidget {
  final String? message;

  const AccessDeniedState({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.lock_outline_rounded,
      title: 'No access',
      subtitle: message ??
          'You don\'t have permission to view this section. Ask the PG owner if '
              'you need access.',
    );
  }
}
