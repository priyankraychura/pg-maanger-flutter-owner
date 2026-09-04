import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/glass_app_bar.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/recent_activity_tile.dart';
import '../../../../core/widgets/common_loader.dart';

class RecentActivityPage extends ConsumerWidget {
  const RecentActivityPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(dashboardProvider);

    return Scaffold(
      appBar: const GlassAppBar(
        title: 'Recent Activity',
        showBackButton: true,
      ),
      body: dashboardAsync.when(
        loading: () => const CommonLoader(),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (data) {
          if (data.recentActivity.isEmpty) {
            return const EmptyState(
              icon: Icons.history_rounded,
              title: 'No Recent Activity',
              subtitle: 'Activity from your PG will show up here.',
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            itemCount: data.recentActivity.length,
            itemBuilder: (context, index) {
              return RecentActivityTile(activity: data.recentActivity[index]);
            },
          );
        },
      ),
    );
  }
}
