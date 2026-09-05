import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/glass_app_bar.dart';
import '../../../../core/widgets/glass_button.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/glass_text_field.dart';
import '../../../../core/widgets/gradient_background.dart';

/// A single frequently-asked question and its answer.
class _Faq {
  final String question;
  final String answer;

  const _Faq(this.question, this.answer);
}

/// Help & Support screen.
///
/// Lets an owner send the support team a message and browse answers to the
/// most common questions in an expandable FAQ accordion. Opened from the
/// "Help & Support" entry on the More/Settings tab.
class HelpSupportPage extends StatefulWidget {
  const HelpSupportPage({super.key});

  @override
  State<HelpSupportPage> createState() => _HelpSupportPageState();
}

class _HelpSupportPageState extends State<HelpSupportPage> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  // Tracks which FAQ tile is currently expanded (single-open accordion).
  int? _expandedIndex;

  static const List<_Faq> _faqs = [
    _Faq(
      'How do I add a new tenant?',
      'Go to the Tenants tab and tap the + button. Fill in the tenant\'s '
          'details, upload their documents, and save. The tenant will appear '
          'in your list right away.',
    ),
    _Faq(
      'How do I record a rent payment?',
      'Open the Payments tab, select the tenant, and tap "Record Payment". '
          'Enter the amount and payment date, then confirm to update their '
          'dues automatically.',
    ),
    _Faq(
      'How do I invite staff members?',
      'From the More tab, open Staff Management and tap "Invite". Choose a '
          'role, enter their details, and share the generated invite link. '
          'Their access is limited to the permissions of the role you pick.',
    ),
    _Faq(
      'Can I manage more than one PG?',
      'Yes. Use Manage PGs under the More tab to add multiple properties. '
          'Switch between them anytime using the PG selector at the top of '
          'the dashboard.',
    ),
    _Faq(
      'How is my data kept secure?',
      'All data is stored securely and access is controlled by roles and '
          'permissions. Only people you invite, with the roles you assign, '
          'can see or change your PG information.',
    ),
  ];

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    // TODO: Wire up to the support ticket endpoint once the backend is ready.
    context.showSnackBar('Thanks! Our support team will get back to you soon.');
    _formKey.currentState!.reset();
    _subjectController.clear();
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GlassAppBar(
        title: 'Help & Support',
        subtitle: 'We\'re here to help',
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
                _buildContactForm(),
                const SizedBox(height: AppSpacing.xl),
                _buildFaqSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── Contact form ──────────────────────────────────
  Widget _buildContactForm() {
    return GlassCard(
      animate: false,
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.support_agent_rounded,
                size: AppSpacing.iconMd,
                color: AppColors.primaryOrange,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Contact Us',
                style: AppTextStyles.h3.copyWith(
                  color: context.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Send us a message and we\'ll respond as soon as we can.',
            style: AppTextStyles.bodySmall.copyWith(
              color: context.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          GlassTextField(
            controller: _subjectController,
            label: 'Subject',
            hint: 'What do you need help with?',
            prefixIcon: Icons.subject_rounded,
            textInputAction: TextInputAction.next,
            validator: (v) => Validators.required(v, 'Subject'),
          ),
          const SizedBox(height: AppSpacing.lg),
          GlassTextField(
            controller: _messageController,
            label: 'Message',
            hint: 'Describe your issue or question',
            prefixIcon: Icons.message_outlined,
            maxLines: 4,
            textInputAction: TextInputAction.newline,
            validator: (v) => Validators.required(v, 'Message'),
          ),
          const SizedBox(height: AppSpacing.xl),
          GlassButton(
            label: 'Send Message',
            icon: Icons.send_rounded,
            onPressed: _handleSubmit,
          ),
        ],
      ),
    );
  }

  // ─── FAQ accordion ─────────────────────────────────
  Widget _buildFaqSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: AppSpacing.xs,
            bottom: AppSpacing.md,
          ),
          child: Row(
            children: [
              const Icon(
                Icons.help_outline_rounded,
                size: AppSpacing.iconMd,
                color: AppColors.primaryOrange,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Frequently Asked Questions',
                style: AppTextStyles.h3.copyWith(
                  color: context.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        for (int i = 0; i < _faqs.length; i++) _buildFaqTile(_faqs[i], i),
      ],
    );
  }

  Widget _buildFaqTile(_Faq faq, int index) {
    final isExpanded = _expandedIndex == index;

    return GlassCard(
      animate: false,
      padding: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      // ExpansionTile's inner ListTile needs a Material ancestor to paint its
      // ink; GlassCard doesn't provide one, so supply a transparent Material.
      child: Material(
        type: MaterialType.transparency,
        child: Theme(
          // Strip the default ExpansionTile dividers so it blends with the card.
          data: Theme.of(context).copyWith(
            dividerColor: Colors.transparent,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: ExpansionTile(
            initiallyExpanded: isExpanded,
            onExpansionChanged: (expanded) {
              setState(() => _expandedIndex = expanded ? index : null);
            },
            tilePadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.xs,
            ),
            childrenPadding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              0,
              AppSpacing.lg,
              AppSpacing.lg,
            ),
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            iconColor: AppColors.primaryOrange,
            collapsedIconColor: context.textSecondary,
            title: Text(
              faq.question,
              style: AppTextStyles.body.copyWith(
                color: context.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            children: [
              Text(
                faq.answer,
                style: AppTextStyles.bodySmall.copyWith(
                  color: context.textSecondary,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
