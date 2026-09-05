import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/glass_app_bar.dart';
import '../../../../core/widgets/glass_button.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/glass_dropdown.dart';
import '../../../../core/widgets/glass_text_field.dart';
import '../../../../core/widgets/gradient_background.dart';
import '../../domain/entities/notice_entity.dart';
import '../providers/notice_provider.dart';

/// Full-screen form for issuing a new notice.
///
/// Collects a title, category, and description, then publishes the notice to
/// the currently selected PG. Opened from the Notices screen.
class CreateNoticePage extends ConsumerStatefulWidget {
  const CreateNoticePage({super.key});

  @override
  ConsumerState<CreateNoticePage> createState() => _CreateNoticePageState();
}

class _CreateNoticePageState extends ConsumerState<CreateNoticePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  NoticeCategory _category = NoticeCategory.general;
  NoticePriority _priority = NoticePriority.medium;
  bool _submitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    setState(() => _submitting = true);
    try {
      await createNotice(
        ref,
        title: _titleController.text.trim(),
        category: _category,
        description: _descriptionController.text.trim(),
        priority: _priority,
      );
      if (!mounted) return;
      context.showSnackBar('Notice published');
      if (context.canPop()) context.pop();
    } catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      context.showSnackBar('Could not publish notice: $e', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GlassAppBar(
        title: 'Issue Notice',
        subtitle: 'Broadcast an announcement to your PG',
        showBackButton: true,
      ),
      body: GradientBackground(
        child: SafeArea(
          top: false,
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenPadding,
                AppSpacing.lg,
                AppSpacing.screenPadding,
                AppSpacing.xxl,
              ),
              children: [
                _section(
                  title: 'Notice Details',
                  icon: Icons.campaign_outlined,
                  children: [
                    GlassTextField(
                      controller: _titleController,
                      label: 'Title',
                      hint: 'e.g. Water supply disruption',
                      prefixIcon: Icons.title_rounded,
                      textInputAction: TextInputAction.next,
                      validator: (v) => Validators.required(v, 'Title'),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    GlassDropdown<NoticeCategory>(
                      label: 'Category',
                      value: _category,
                      prefixIcon: Icons.category_rounded,
                      items: NoticeCategory.values
                          .map((c) => DropdownMenuItem(
                                value: c,
                                child: Text(c.label),
                              ))
                          .toList(),
                      onChanged: (v) {
                        if (v != null) setState(() => _category = v);
                      },
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    GlassDropdown<NoticePriority>(
                      label: 'Priority',
                      value: _priority,
                      prefixIcon: Icons.flag_outlined,
                      items: NoticePriority.values
                          .map((p) => DropdownMenuItem(
                                value: p,
                                child: Text(_priorityLabel(p)),
                              ))
                          .toList(),
                      onChanged: (v) {
                        if (v != null) setState(() => _priority = v);
                      },
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    GlassTextField(
                      controller: _descriptionController,
                      label: 'Description',
                      hint: 'Write the notice details...',
                      prefixIcon: Icons.notes_rounded,
                      maxLines: 5,
                      textInputAction: TextInputAction.newline,
                      validator: (v) => Validators.required(v, 'Description'),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xxl),
                GlassButton(
                  label: 'Publish Notice',
                  icon: Icons.send_rounded,
                  isLoading: _submitting,
                  onPressed: _handleSubmit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _priorityLabel(NoticePriority priority) {
    switch (priority) {
      case NoticePriority.low:
        return 'Low';
      case NoticePriority.medium:
        return 'Medium';
      case NoticePriority.high:
        return 'High';
      case NoticePriority.urgent:
        return 'Urgent';
    }
  }

  Widget _section({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return GlassCard(
      animate: false,
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(icon, size: AppSpacing.iconMd, color: AppColors.primaryOrange),
              const SizedBox(width: AppSpacing.sm),
              Text(
                title,
                style: AppTextStyles.h3.copyWith(
                  color: context.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          ...children,
        ],
      ),
    );
  }
}
