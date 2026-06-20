import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/glass_button.dart';
import '../../../../core/widgets/glass_text_field.dart';
import '../../../../core/widgets/gradient_background.dart';
import '../../../../core/utils/validators.dart';
import '../providers/auth_provider.dart';

/// Login page for PG Owner app.
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordFocus = FocusNode();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    await ref.read(authProvider.notifier).login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (mounted) {
      final authState = ref.read(authProvider);
      if (authState.hasValue && authState.value != null) {
        context.go('/dashboard');
      }
    }
  }

  Future<void> _handleDevLogin() async {
    await ref.read(authProvider.notifier).devLogin();
    if (mounted) {
      final authState = ref.read(authProvider);
      if (authState.hasValue && authState.value != null) {
        context.go('/dashboard');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isLoading = authState.isLoading;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.screenPaddingLarge),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Logo / Title
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        decoration: BoxDecoration(
                          color: AppColors.primaryOrange.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.admin_panel_settings_rounded,
                          size: 48,
                          color: AppColors.primaryOrange,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    Center(
                      child: Text(
                        'PG Manager',
                        style: AppTextStyles.display.copyWith(
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Center(
                      child: Text(
                        'Owner Portal',
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.primaryOrange,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.huge),

                    // Email Field
                    GlassTextField(
                      controller: _emailController,
                      label: 'Email',
                      hint: 'Enter your email',
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: Validators.email,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(_passwordFocus),
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // Password Field
                    GlassTextField(
                      controller: _passwordController,
                      label: 'Password',
                      hint: 'Enter your password',
                      prefixIcon: Icons.lock_outline_rounded,
                      obscureText: _obscurePassword,
                      focusNode: _passwordFocus,
                      textInputAction: TextInputAction.done,
                      validator: Validators.password,
                      onFieldSubmitted: (_) => _handleLogin(),
                      suffixIcon: GestureDetector(
                        onTap: () =>
                            setState(() => _obscurePassword = !_obscurePassword),
                        child: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: AppSpacing.iconMd,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Forgot Password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => context.push('/forgot-password'),
                        child: const Text('Forgot Password?'),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),

                    // Login Button
                    GlassButton(
                      label: 'Login',
                      onPressed: isLoading ? null : _handleLogin,
                      isLoading: isLoading,
                    ),

                    // Error Message
                    if (authState.hasError) ...[
                      const SizedBox(height: AppSpacing.md),
                      Center(
                        child: Text(
                          'Invalid credentials. Please try again.',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.error,
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: AppSpacing.xl),

                    // Dev Login
                    Center(
                      child: TextButton.icon(
                        onPressed: isLoading ? null : _handleDevLogin,
                        icon: const Icon(Icons.developer_mode_rounded, size: 18),
                        label: const Text('Dev Login'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
