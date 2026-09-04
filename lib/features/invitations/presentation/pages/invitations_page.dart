import 'package:flutter/material.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/glass_app_bar.dart';

class InvitationsPage extends StatelessWidget {
  const InvitationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GlassAppBar(
        title: 'Invitations',
        showBackButton: true,
      ),
      body: EmptyState(
        icon: Icons.person_add_disabled_rounded,
        title: 'No Pending Invitations',
        subtitle: 'You have no pending invitations to display.',
        actionLabel: 'Send Invitation',
        actionIcon: Icons.add,
        primaryAction: true,
        onAction: () {},
      ),
    );
  }
}
