import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import '../../../../core/widgets/glass_text_field.dart';
import '../../../../core/widgets/gradient_background.dart';
import '../../domain/repositories/auth_repository.dart' show RegistrationData;
import '../providers/auth_provider.dart';

/// Two-step owner registration wizard.
///
/// Step 1 collects the owner's account details; step 2 collects the details of
/// their first PG property. On submit both are sent to the auth repository,
/// which creates the account and signs the owner in.
class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage>
    with SingleTickerProviderStateMixin {
  // Separate form keys so each step validates independently.
  final _accountFormKey = GlobalKey<FormState>();
  final _pgFormKey = GlobalKey<FormState>();

  // ─── Step 1: Owner account ─────────────────────────
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // ─── Step 2: First PG property ─────────────────────
  final _pgNameController = TextEditingController();
  final _pgAddressController = TextEditingController();
  final _pgCityController = TextEditingController();
  final _pgPhoneController = TextEditingController();
  final _pgEmailController = TextEditingController();
  final _floorsController = TextEditingController();
  final _roomsController = TextEditingController();
  final _bedsController = TextEditingController();

  static const List<String> _availableAmenities = [
    'WiFi', 'Food / Mess', 'Laundry', 'Parking', 'AC',
    'Power Backup', 'Housekeeping', 'CCTV', 'Hot Water', 'Gym',
  ];
  final Set<String> _selectedAmenities = {};

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _acceptedTerms = false;
  int _currentStep = 0;

  late final AnimationController _entranceController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _entranceController, curve: Curves.easeOutCubic),
    );
    _entranceController.forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _pgNameController.dispose();
    _pgAddressController.dispose();
    _pgCityController.dispose();
    _pgPhoneController.dispose();
    _pgEmailController.dispose();
    _floorsController.dispose();
    _roomsController.dispose();
    _bedsController.dispose();
    super.dispose();
  }

  void _goToPgStep() {
    if (!_accountFormKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    // Prefill PG contact fields from the owner's details for convenience.
    if (_pgPhoneController.text.isEmpty) {
      _pgPhoneController.text = _phoneController.text.trim();
    }
    if (_pgEmailController.text.isEmpty) {
      _pgEmailController.text = _emailController.text.trim();
    }
    setState(() => _currentStep = 1);
    _entranceController
      ..reset()
      ..forward();
  }

  void _backToAccountStep() {
    FocusScope.of(context).unfocus();
    setState(() => _currentStep = 0);
    _entranceController
      ..reset()
      ..forward();
  }

  Future<void> _handleSubmit() async {
    if (!_pgFormKey.currentState!.validate()) return;
    if (!_acceptedTerms) {
      context.showSnackBar(
        'Please accept the Terms & Conditions to continue.',
        isError: true,
      );
      return;
    }
    FocusScope.of(context).unfocus();

    final data = RegistrationData(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      password: _passwordController.text,
      pgName: _pgNameController.text.trim(),
      pgAddress: _pgAddressController.text.trim(),
      pgCity: _pgCityController.text.trim(),
      pgContactPhone: _pgPhoneController.text.trim(),
      pgContactEmail: _pgEmailController.text.trim(),
      totalFloors: int.tryParse(_floorsController.text.trim()) ?? 0,
      totalRooms: int.tryParse(_roomsController.text.trim()) ?? 0,
      totalBeds: int.tryParse(_bedsController.text.trim()) ?? 0,
      amenities: _selectedAmenities.toList(),
    );

    await ref.read(authProvider.notifier).register(data);

    if (!mounted) return;
    final authState = ref.read(authProvider);
    if (authState.hasValue && authState.value != null) {
      context.go('/dashboard');
    } else if (authState.hasError) {
      context.showSnackBar(
        'Registration failed. Please try again.',
        isError: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isLoading = authState.isLoading;

    return Scaffold(
      appBar: GlassAppBar(
        title: 'Create Account',
        showBackButton: true,
        onBackPressed: _currentStep == 1 ? _backToAccountStep : null,
      ),
      body: GradientBackground(
        animate: true,
        child: SafeArea(
          top: false,
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.screenPaddingLarge),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildStepIndicator(),
                    const SizedBox(height: AppSpacing.xl),
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: _currentStep == 0
                            ? _buildAccountStep(isLoading)
                            : _buildPgStep(isLoading),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    _buildLoginLink(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Two-node progress header showing which step is active.
  Widget _buildStepIndicator() {
    return Row(
      children: [
        _buildStepNode(1, 'Account', _currentStep >= 0),
        Expanded(
          child: Container(
            height: 2,
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            color: _currentStep >= 1
                ? AppColors.primaryOrange
                : context.textTertiary.withValues(alpha: 0.3),
          ),
        ),
        _buildStepNode(2, 'PG Details', _currentStep >= 1),
      ],
    );
  }

  Widget _buildStepNode(int number, String label, bool active) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            gradient: active ? AppColors.primaryGradient : null,
            color: active ? null : context.textTertiary.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            '$number',
            style: AppTextStyles.caption.copyWith(
              color: active ? Colors.white : context.textTertiary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: active ? context.textPrimary : context.textTertiary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // ─── Step 1 ─────────────────────────────────────────
  Widget _buildAccountStep(bool isLoading) {
    return GlassCard(
      animate: false,
      padding: const EdgeInsets.all(AppSpacing.xxl),
      margin: EdgeInsets.zero,
      child: Form(
        key: _accountFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _sectionTitle('Your details'),
            const SizedBox(height: AppSpacing.lg),
            GlassTextField(
              controller: _nameController,
              label: 'Full Name',
              hint: 'Enter your full name',
              prefixIcon: Icons.person_outline_rounded,
              textInputAction: TextInputAction.next,
              validator: Validators.name,
            ),
            const SizedBox(height: AppSpacing.lg),
            GlassTextField(
              controller: _emailController,
              label: 'Email',
              hint: 'Enter your email',
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
              textInputAction: TextInputAction.next,
              validator: Validators.phone,
            ),
            const SizedBox(height: AppSpacing.lg),
            GlassTextField(
              controller: _passwordController,
              label: 'Password',
              hint: 'Create a password',
              prefixIcon: Icons.lock_outline_rounded,
              obscureText: _obscurePassword,
              textInputAction: TextInputAction.next,
              validator: Validators.password,
              suffixIcon: _buildObscureToggle(
                _obscurePassword,
                () => setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            GlassTextField(
              controller: _confirmPasswordController,
              label: 'Confirm Password',
              hint: 'Re-enter your password',
              prefixIcon: Icons.lock_outline_rounded,
              obscureText: _obscureConfirm,
              textInputAction: TextInputAction.done,
              validator: (v) =>
                  Validators.confirmPassword(v, _passwordController.text),
              suffixIcon: _buildObscureToggle(
                _obscureConfirm,
                () => setState(() => _obscureConfirm = !_obscureConfirm),
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            GlassButton(
              label: 'Continue',
              icon: Icons.arrow_forward_rounded,
              onPressed: isLoading ? null : _goToPgStep,
            ),
          ],
        ),
      ),
    );
  }

  // ─── Step 2 ─────────────────────────────────────────
  Widget _buildPgStep(bool isLoading) {
    return GlassCard(
      animate: false,
      padding: const EdgeInsets.all(AppSpacing.xxl),
      margin: EdgeInsets.zero,
      child: Form(
        key: _pgFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _sectionTitle('Your first PG property'),
            const SizedBox(height: AppSpacing.lg),
            GlassTextField(
              controller: _pgNameController,
              label: 'PG Name',
              hint: 'e.g. Sunrise Residency',
              prefixIcon: Icons.apartment_rounded,
              textInputAction: TextInputAction.next,
              validator: (v) => Validators.required(v, 'PG name'),
            ),
            const SizedBox(height: AppSpacing.lg),
            GlassTextField(
              controller: _pgAddressController,
              label: 'Address',
              hint: 'Street, area, landmark',
              prefixIcon: Icons.location_on_outlined,
              maxLines: 2,
              textInputAction: TextInputAction.next,
              validator: (v) => Validators.required(v, 'Address'),
            ),
            const SizedBox(height: AppSpacing.lg),
            GlassTextField(
              controller: _pgCityController,
              label: 'City',
              hint: 'Enter city',
              prefixIcon: Icons.location_city_rounded,
              textInputAction: TextInputAction.next,
              validator: (v) => Validators.required(v, 'City'),
            ),
            const SizedBox(height: AppSpacing.lg),
            GlassTextField(
              controller: _pgPhoneController,
              label: 'Contact Phone',
              hint: '10-digit number',
              prefixIcon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              validator: Validators.phone,
            ),
            const SizedBox(height: AppSpacing.lg),
            GlassTextField(
              controller: _pgEmailController,
              label: 'Contact Email',
              hint: 'Enter contact email',
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: Validators.email,
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: GlassTextField(
                    controller: _floorsController,
                    label: 'Floors',
                    hint: '0',
                    prefixIcon: Icons.layers_outlined,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    validator: (v) => _positiveInt(v, 'Floors'),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: GlassTextField(
                    controller: _roomsController,
                    label: 'Rooms',
                    hint: '0',
                    prefixIcon: Icons.meeting_room_outlined,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    validator: (v) => _positiveInt(v, 'Rooms'),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: GlassTextField(
                    controller: _bedsController,
                    label: 'Beds',
                    hint: '0',
                    prefixIcon: Icons.bed_outlined,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    validator: (v) => _positiveInt(v, 'Beds'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            _buildAmenities(),
            const SizedBox(height: AppSpacing.xl),
            _buildTermsCheckbox(),
            const SizedBox(height: AppSpacing.xxl),
            GlassButton(
              label: 'Create Account',
              icon: Icons.check_rounded,
              isLoading: isLoading,
              onPressed: isLoading ? null : _handleSubmit,
            ),
            const SizedBox(height: AppSpacing.md),
            GlassButton.outlined(
              label: 'Back',
              icon: Icons.arrow_back_rounded,
              onPressed: isLoading ? null : _backToAccountStep,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmenities() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Amenities (optional)',
          style: AppTextStyles.inputLabel.copyWith(color: context.textSecondary),
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: _availableAmenities.map((amenity) {
            final selected = _selectedAmenities.contains(amenity);
            return GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                setState(() {
                  if (selected) {
                    _selectedAmenities.remove(amenity);
                  } else {
                    _selectedAmenities.add(amenity);
                  }
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  gradient: selected ? AppColors.primaryGradient : null,
                  color: selected
                      ? null
                      : context.textTertiary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  border: Border.all(
                    color: selected
                        ? Colors.transparent
                        : context.textTertiary.withValues(alpha: 0.25),
                  ),
                ),
                child: Text(
                  amenity,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: selected ? Colors.white : context.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTermsCheckbox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: _acceptedTerms,
            onChanged: (v) => setState(() => _acceptedTerms = v ?? false),
            activeColor: AppColors.primaryOrange,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text.rich(
              TextSpan(
                style: AppTextStyles.bodySmall.copyWith(
                  color: context.textSecondary,
                ),
                children: const [
                  TextSpan(text: 'I agree to the '),
                  TextSpan(
                    text: 'Terms & Conditions',
                    style: TextStyle(
                      color: AppColors.primaryOrange,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(text: ' and '),
                  TextSpan(
                    text: 'Privacy Policy',
                    style: TextStyle(
                      color: AppColors.primaryOrange,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(text: '.'),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account?',
          style: AppTextStyles.body.copyWith(color: context.textSecondary),
        ),
        TextButton(
          onPressed: () => context.go('/login'),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text('Sign in'),
        ),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.h3.copyWith(
        color: context.textPrimary,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildObscureToggle(bool obscured, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        obscured
            ? Icons.visibility_off_outlined
            : Icons.visibility_outlined,
        size: AppSpacing.iconMd,
      ),
    );
  }

  String? _positiveInt(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'Required';
    }
    final parsed = int.tryParse(value.trim());
    if (parsed == null || parsed < 0) {
      return 'Invalid';
    }
    return null;
  }
}
