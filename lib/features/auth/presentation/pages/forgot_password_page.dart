import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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

/// Forgot-password flow: collect the account email and confirm that a reset
/// link has been sent. (Mock — no backend wired up yet.)
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _sent = false;

  late final AnimationController _entranceController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _entranceController, curve: Curves.easeOutCubic),
    );
    _entranceController.forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    setState(() => _isLoading = true);
    // Simulate a network request.
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _sent = true;
    });
    // Replay the entrance animation for the success state.
    _entranceController
      ..reset()
      ..forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GlassAppBar(
        title: 'Forgot Password',
        showBackButton: true,
      ),
      body: GradientBackground(
        animate: true,
        child: SafeArea(
          top: false,
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.screenPaddingLarge),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: _sent
                        ? _buildSuccess(context)
                        : _buildForm(context),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Gradient badge used in both the form and success headers.
  Widget _buildBadge({
    required IconData icon,
    required Gradient gradient,
    required Color glowColor,
  }) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        boxShadow: [
          BoxShadow(
            color: glowColor.withValues(alpha: 0.35),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Icon(icon, size: 42, color: Colors.white),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: _buildBadge(
            icon: Icons.lock_reset_rounded,
            gradient: AppColors.primaryGradient,
            glowColor: AppColors.primaryOrange,
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        Text(
          'Reset your password',
          textAlign: TextAlign.center,
          style: AppTextStyles.display.copyWith(color: context.textPrimary),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Enter the email linked to your account and we\'ll send you a link '
          'to reset your password.',
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyLarge.copyWith(color: context.textSecondary),
        ),
        const SizedBox(height: AppSpacing.xxxl),
        GlassCard(
          animate: false,
          padding: const EdgeInsets.all(AppSpacing.xxl),
          margin: EdgeInsets.zero,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GlassTextField(
                  controller: _emailController,
                  label: 'Email',
                  hint: 'Enter your email',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  validator: Validators.email,
                  onFieldSubmitted: (_) => _handleSubmit(),
                ),
                const SizedBox(height: AppSpacing.xxl),
                GlassButton(
                  label: 'Send Reset Link',
                  icon: Icons.send_rounded,
                  isLoading: _isLoading,
                  onPressed: _isLoading ? null : _handleSubmit,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSuccess(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: _buildBadge(
            icon: Icons.mark_email_read_rounded,
            gradient: const LinearGradient(
              colors: [AppColors.success, Color(0xFF059669)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            glowColor: AppColors.success,
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        Text(
          'Check your email',
          style: AppTextStyles.display.copyWith(color: context.textPrimary),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'If an account exists for ${_emailController.text.trim()}, '
          'you\'ll receive a password reset link shortly.',
          style: AppTextStyles.bodyLarge.copyWith(color: context.textSecondary),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xxxl),
        GlassCard(
          animate: false,
          padding: const EdgeInsets.all(AppSpacing.xxl),
          margin: EdgeInsets.zero,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GlassButton(
                label: 'Back to Login',
                icon: Icons.arrow_back_rounded,
                onPressed: () => context.pop(),
              ),
              const SizedBox(height: AppSpacing.md),
              TextButton.icon(
                onPressed: _isLoading ? null : _handleSubmit,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Resend link'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
