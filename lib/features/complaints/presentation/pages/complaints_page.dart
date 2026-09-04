import 'package:flutter/material.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/glass_app_bar.dart';

class ComplaintsPage extends StatelessWidget {
  const ComplaintsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: GlassAppBar(
        title: 'Complaints',
        showBackButton: true,
      ),
      body: EmptyState(
        icon: Icons.report_gmailerrorred_rounded,
        title: 'No Complaints Found',
        subtitle: 'All tenant complaints have been resolved.',
      ),
    );
  }
}
