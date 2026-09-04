import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/glass_app_bar.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/status_badge.dart';

class PaymentsPage extends StatelessWidget {
  const PaymentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Mock Data
    final payments = [
      {'name': 'Rahul Kumar', 'amount': '₹8,500', 'date': 'Today', 'status': 'Paid'},
      {'name': 'Amit Singh', 'amount': '₹12,000', 'date': 'Yesterday', 'status': 'Pending'},
      {'name': 'Priya Sharma', 'amount': '₹9,000', 'date': '05 Jun', 'status': 'Overdue'},
      {'name': 'Vikram Gupta', 'amount': '₹8,500', 'date': '03 Jun', 'status': 'Paid'},
      {'name': 'Neha Patel', 'amount': '₹15,000', 'date': '01 Jun', 'status': 'Paid'},
    ];

    return Scaffold(
      appBar: const GlassAppBar(
        title: 'Payments',
        showBackButton: false,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              child: GlassCard(
                onTap: () {},
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Collection (This Month)',
                      style: AppTextStyles.body.copyWith(
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      '₹1,45,000',
                      style: AppTextStyles.display.copyWith(
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        fontSize: 32,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Pending', style: AppTextStyles.caption),
                            Text('₹24,000', style: AppTextStyles.bodyLarge.copyWith(color: AppColors.warning)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('Overdue', style: AppTextStyles.caption),
                            Text('₹9,000', style: AppTextStyles.bodyLarge.copyWith(color: AppColors.error)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final payment = payments[index];
                  final isPaid = payment['status'] == 'Paid';
                  final isPending = payment['status'] == 'Pending';

                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: GlassCard(
                      onTap: () {},
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            decoration: BoxDecoration(
                              color: (isPaid ? AppColors.success : (isPending ? AppColors.warning : AppColors.error)).withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isPaid ? Icons.check_circle_rounded : (isPending ? Icons.pending_actions_rounded : Icons.error_rounded),
                              color: isPaid ? AppColors.success : (isPending ? AppColors.warning : AppColors.error),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.lg),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  payment['name']!,
                                  style: AppTextStyles.bodyLarge.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.xxs),
                                Text(
                                  payment['date']!,
                                  style: AppTextStyles.caption.copyWith(
                                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                payment['amount']!,
                                style: AppTextStyles.h2.copyWith(
                                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              StatusBadge(
                                label: payment['status']!,
                                type: isPaid ? StatusType.success : (isPending ? StatusType.warning : StatusType.error),
                                small: true,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
                childCount: payments.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
