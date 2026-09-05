import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/network/api_exceptions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/glass_app_bar.dart';
import '../../../../core/widgets/glass_button.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/glass_text_field.dart';
import '../../../../core/widgets/gradient_background.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

/// Profile screen for the signed-in account.
///
/// Reached from the name card on the Settings ("More") tab. Lets the user edit
/// their personal details and change their password by confirming the current
/// one. The two concerns are independent forms so each validates and saves on
/// its own.
class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  // ─── Personal details ──────────────────────────────
  final _detailsFormKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  bool _savingDetails = false;

  // ─── Change password ───────────────────────────────
  final _passwordFormKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _changingPassword = false;

  @override
  void initState() {
    super.initState();
    final owner = ref.read(currentOwnerProvider);
    _nameController = TextEditingController(text: owner?.name ?? '');
    _emailController = TextEditingController(text: owner?.email ?? '');
    _phoneController = TextEditingController(text: owner?.phone ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _saveDetails() async {
    if (!_detailsFormKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    setState(() => _savingDetails = true);
    try {
      await ref.read(authProvider.notifier).updateProfile(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            phone: _phoneController.text.trim(),
          );
      if (!mounted) return;
      context.showSnackBar('Profile updated.');
    } catch (_) {
      if (!mounted) return;
      context.showSnackBar(
        'Could not update your profile. Please try again.',
        isError: true,
      );
    } finally {
      if (mounted) setState(() => _savingDetails = false);
    }
  }

  Future<void> _changePassword() async {
    if (!_passwordFormKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    setState(() => _changingPassword = true);
    try {
      await ref.read(authProvider.notifier).changePassword(
            currentPassword: _currentPasswordController.text,
            newPassword: _newPasswordController.text,
          );
      if (!mounted) return;
      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
      _passwordFormKey.currentState!.reset();
      context.showSnackBar('Password changed.');
    } on ApiException catch (e) {
      if (!mounted) return;
      context.showSnackBar(e.message, isError: true);
    } catch (_) {
      if (!mounted) return;
      context.showSnackBar(
        'Could not change your password. Please try again.',
        isError: true,
      );
    } finally {
      if (mounted) setState(() => _changingPassword = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final owner = ref.watch(currentOwnerProvider);

    return Scaffold(
      appBar: const GlassAppBar(
        title: 'My Profile',
        subtitle: 'Manage your account details',
        showBackButton: true,
      ),
      body: GradientBackground(
        child: SafeArea(
          top: false,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenPadding,
              AppSpacing.lg,
              AppSpacing.screenPadding,
              AppSpacing.xxl,
            ),
            children: [
              _buildAvatar(owner?.name ?? 'Owner'),
              const SizedBox(height: AppSpacing.lg),
              _buildDetailsSection(),
              const SizedBox(height: AppSpacing.lg),
              _buildPasswordSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(String name) {
    return Center(
      child: CircleAvatar(
        radius: 40,
        backgroundColor: AppColors.primaryOrange.withValues(alpha: 0.15),
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : 'O',
          style: AppTextStyles.display.copyWith(
            color: AppColors.primaryOrange,
          ),
        ),
      ),
    );
  }

  // ─── Personal details ──────────────────────────────
  Widget _buildDetailsSection() {
    return Form(
      key: _detailsFormKey,
      child: _section(
        title: 'Personal Details',
        icon: Icons.person_outline_rounded,
        children: [
          GlassTextField(
            controller: _nameController,
            label: 'Full Name',
            hint: 'Your name',
            prefixIcon: Icons.badge_outlined,
            textInputAction: TextInputAction.next,
            validator: Validators.name,
          ),
          const SizedBox(height: AppSpacing.lg),
          GlassTextField(
            controller: _emailController,
            label: 'Email',
            hint: 'name@example.com',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: Validators.email,
          ),
          const SizedBox(height: AppSpacing.lg),
          GlassTextField(
            controller: _phoneController,
            label: 'Phone',
            hint: '10-digit mobile number',
            prefixIcon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.done,
            validator: Validators.phone,
          ),
          const SizedBox(height: AppSpacing.xl),
          GlassButton(
            label: 'Save Changes',
            icon: Icons.check_rounded,
            isLoading: _savingDetails,
            onPressed: _savingDetails ? null : _saveDetails,
          ),
        ],
      ),
    );
  }

  // ─── Change password ───────────────────────────────
  Widget _buildPasswordSection() {
    return Form(
      key: _passwordFormKey,
      child: _section(
        title: 'Change Password',
        icon: Icons.lock_outline_rounded,
        children: [
          Text(
            'Enter your current password to set a new one.',
            style: AppTextStyles.caption.copyWith(color: context.textSecondary),
          ),
          const SizedBox(height: AppSpacing.lg),
          GlassTextField(
            controller: _currentPasswordController,
            label: 'Current Password',
            hint: 'Enter current password',
            prefixIcon: Icons.lock_outline_rounded,
            obscureText: _obscureCurrent,
            textInputAction: TextInputAction.next,
            validator: (v) => Validators.required(v, 'Current password'),
            suffixIcon: _visibilityToggle(
              obscured: _obscureCurrent,
              onTap: () => setState(() => _obscureCurrent = !_obscureCurrent),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          GlassTextField(
            controller: _newPasswordController,
            label: 'New Password',
            hint: 'Enter new password',
            prefixIcon: Icons.lock_reset_rounded,
            obscureText: _obscureNew,
            textInputAction: TextInputAction.next,
            validator: (v) {
              final base = Validators.password(v);
              if (base != null) return base;
              if (v == _currentPasswordController.text) {
                return 'New password must differ from the current one';
              }
              return null;
            },
            suffixIcon: _visibilityToggle(
              obscured: _obscureNew,
              onTap: () => setState(() => _obscureNew = !_obscureNew),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          GlassTextField(
            controller: _confirmPasswordController,
            label: 'Confirm New Password',
            hint: 'Re-enter new password',
            prefixIcon: Icons.lock_outline_rounded,
            obscureText: _obscureConfirm,
            textInputAction: TextInputAction.done,
            validator: (v) => Validators.confirmPassword(
              v,
              _newPasswordController.text,
            ),
            suffixIcon: _visibilityToggle(
              obscured: _obscureConfirm,
              onTap: () => setState(() => _obscureConfirm = !_obscureConfirm),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          GlassButton(
            label: 'Update Password',
            icon: Icons.shield_outlined,
            isLoading: _changingPassword,
            onPressed: _changingPassword ? null : _changePassword,
          ),
        ],
      ),
    );
  }

  Widget _visibilityToggle({
    required bool obscured,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        obscured ? Icons.visibility_off_outlined : Icons.visibility_outlined,
        size: AppSpacing.iconMd,
      ),
    );
  }

  // ─── Reusable section card ─────────────────────────
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
