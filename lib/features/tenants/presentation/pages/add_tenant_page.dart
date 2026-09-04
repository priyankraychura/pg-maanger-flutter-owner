import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

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

/// Form screen for adding a new tenant.
///
/// Collects the tenant's personal details, identity/KYC information (including
/// a passport photo and Aadhaar card upload), residential address, and a local
/// emergency contact. Opened from the FAB on the Tenants tab.
class AddTenantPage extends StatefulWidget {
  const AddTenantPage({super.key});

  @override
  State<AddTenantPage> createState() => _AddTenantPageState();
}

class _AddTenantPageState extends State<AddTenantPage> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();

  // ─── Personal details ──────────────────────────────
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  // ─── Identity / KYC ────────────────────────────────
  final _aadhaarController = TextEditingController();

  // ─── Address ───────────────────────────────────────
  final _addressController = TextEditingController();

  // ─── Local contact ─────────────────────────────────
  final _localContactNameController = TextEditingController();
  final _localContactPhoneController = TextEditingController();

  // ─── Optional ──────────────────────────────────────
  final _occupationController = TextEditingController();
  String? _gender;

  // Uploaded files (local paths until a backend is wired up).
  File? _passportPhoto;
  File? _aadhaarDocument;

  static const List<String> _genders = ['Male', 'Female', 'Other'];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _aadhaarController.dispose();
    _addressController.dispose();
    _localContactNameController.dispose();
    _localContactPhoneController.dispose();
    _occupationController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ValueChanged<File> onPicked) async {
    FocusScope.of(context).unfocus();
    final source = await _showSourceSheet();
    if (source == null) return;
    try {
      final picked = await _picker.pickImage(source: source, imageQuality: 80);
      if (picked != null) {
        onPicked(File(picked.path));
      }
    } catch (_) {
      if (!mounted) return;
      context.showSnackBar('Could not pick the image.', isError: true);
    }
  }

  Future<ImageSource?> _showSourceSheet() {
    return showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: context.isDark
          ? AppColors.darkSurface
          : AppColors.lightSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: AppSpacing.md),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: sheetContext.textTertiary.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined,
                  color: AppColors.primaryOrange),
              title: const Text('Take a photo'),
              onTap: () => Navigator.pop(sheetContext, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined,
                  color: AppColors.primaryOrange),
              title: const Text('Choose from gallery'),
              onTap: () => Navigator.pop(sheetContext, ImageSource.gallery),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ),
      ),
    );
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) return;
    if (_passportPhoto == null) {
      context.showSnackBar('Please upload a passport photo.', isError: true);
      return;
    }
    if (_aadhaarDocument == null) {
      context.showSnackBar('Please upload the Aadhaar card.', isError: true);
      return;
    }
    FocusScope.of(context).unfocus();

    // TODO: Wire up to the tenant repository once the backend is available.
    context.showSnackBar('Tenant "${_nameController.text.trim()}" added.');
    if (context.canPop()) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GlassAppBar(
        title: 'Add Tenant',
        subtitle: 'Enter the tenant\'s details',
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
                _buildPhotoPicker(),
                const SizedBox(height: AppSpacing.xl),
                _buildPersonalSection(),
                const SizedBox(height: AppSpacing.lg),
                _buildIdentitySection(),
                const SizedBox(height: AppSpacing.lg),
                _buildAddressSection(),
                const SizedBox(height: AppSpacing.lg),
                _buildLocalContactSection(),
                const SizedBox(height: AppSpacing.xxl),
                GlassButton(
                  label: 'Save Tenant',
                  icon: Icons.check_rounded,
                  onPressed: _handleSubmit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── Passport photo (circular avatar picker) ───────
  Widget _buildPhotoPicker() {
    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              _pickImage((f) => setState(() => _passportPhoto = f));
            },
            child: Stack(
              children: [
                Container(
                  width: 108,
                  height: 108,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryOrange.withValues(alpha: 0.12),
                    border: Border.all(
                      color: AppColors.primaryOrange.withValues(alpha: 0.4),
                      width: 1.5,
                    ),
                    image: _passportPhoto != null
                        ? DecorationImage(
                            image: FileImage(_passportPhoto!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: _passportPhoto == null
                      ? const Icon(
                          Icons.person_outline_rounded,
                          size: 48,
                          color: AppColors.primaryOrange,
                        )
                      : null,
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.primaryOrange,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: context.isDark
                            ? AppColors.darkBackground
                            : AppColors.lightBackground,
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.camera_alt_rounded,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Passport Photo',
            style: AppTextStyles.bodySmall.copyWith(
              color: context.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Personal details ──────────────────────────────
  Widget _buildPersonalSection() {
    return _section(
      title: 'Personal Details',
      icon: Icons.person_outline_rounded,
      children: [
        GlassTextField(
          controller: _nameController,
          label: 'Full Name',
          hint: 'Enter tenant\'s full name',
          prefixIcon: Icons.badge_outlined,
          textInputAction: TextInputAction.next,
          validator: Validators.name,
        ),
        const SizedBox(height: AppSpacing.lg),
        GlassTextField(
          controller: _phoneController,
          label: 'Phone Number',
          hint: '10-digit mobile number',
          prefixIcon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          validator: Validators.phone,
        ),
        const SizedBox(height: AppSpacing.lg),
        GlassTextField(
          controller: _emailController,
          label: 'Email',
          hint: 'Enter email address',
          prefixIcon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          validator: Validators.email,
        ),
        const SizedBox(height: AppSpacing.lg),
        GlassDropdown<String>(
          label: 'Gender (optional)',
          value: _gender,
          hint: 'Select gender',
          prefixIcon: Icons.wc_outlined,
          items: _genders
              .map((g) => DropdownMenuItem(value: g, child: Text(g)))
              .toList(),
          onChanged: (v) => setState(() => _gender = v),
        ),
        const SizedBox(height: AppSpacing.lg),
        GlassTextField(
          controller: _occupationController,
          label: 'Occupation (optional)',
          hint: 'e.g. Student, Software Engineer',
          prefixIcon: Icons.work_outline_rounded,
          textInputAction: TextInputAction.next,
        ),
      ],
    );
  }

  // ─── Identity / KYC ────────────────────────────────
  Widget _buildIdentitySection() {
    return _section(
      title: 'Identity & Documents',
      icon: Icons.verified_user_outlined,
      children: [
        GlassTextField(
          controller: _aadhaarController,
          label: 'Aadhaar Card Number',
          hint: '12-digit Aadhaar number',
          prefixIcon: Icons.credit_card_outlined,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          validator: (v) {
            if (v == null || v.trim().isEmpty) {
              return 'Aadhaar number is required';
            }
            final cleaned = v.replaceAll(RegExp(r'\D'), '');
            if (cleaned.length != 12) {
              return 'Enter a valid 12-digit Aadhaar number';
            }
            return null;
          },
        ),
        const SizedBox(height: AppSpacing.lg),
        _buildDocumentUpload(
          label: 'Aadhaar Card Upload',
          hint: 'Upload a photo of the Aadhaar card',
          file: _aadhaarDocument,
          onTap: () => _pickImage((f) => setState(() => _aadhaarDocument = f)),
          onRemove: () => setState(() => _aadhaarDocument = null),
        ),
      ],
    );
  }

  // ─── Address ───────────────────────────────────────
  Widget _buildAddressSection() {
    return _section(
      title: 'Residential Address',
      icon: Icons.home_outlined,
      children: [
        GlassTextField(
          controller: _addressController,
          label: 'Permanent Address',
          hint: 'House no., street, city, state, pincode',
          prefixIcon: Icons.location_on_outlined,
          maxLines: 3,
          textInputAction: TextInputAction.newline,
          validator: (v) => Validators.required(v, 'Address'),
        ),
      ],
    );
  }

  // ─── Local contact ─────────────────────────────────
  Widget _buildLocalContactSection() {
    return _section(
      title: 'Local / Emergency Contact',
      icon: Icons.contact_phone_outlined,
      children: [
        GlassTextField(
          controller: _localContactNameController,
          label: 'Contact Name',
          hint: 'Parent / guardian / relative',
          prefixIcon: Icons.person_pin_outlined,
          textInputAction: TextInputAction.next,
          validator: (v) => Validators.required(v, 'Contact name'),
        ),
        const SizedBox(height: AppSpacing.lg),
        GlassTextField(
          controller: _localContactPhoneController,
          label: 'Contact Number',
          hint: '10-digit mobile number',
          prefixIcon: Icons.phone_in_talk_outlined,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.done,
          validator: Validators.phone,
        ),
      ],
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

  // ─── Reusable document upload tile ─────────────────
  Widget _buildDocumentUpload({
    required String label,
    required String hint,
    required File? file,
    required VoidCallback onTap,
    required VoidCallback onRemove,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.inputLabel.copyWith(color: context.textSecondary),
        ),
        const SizedBox(height: AppSpacing.sm),
        GestureDetector(
          onTap: () {
            HapticFeedback.selectionClick();
            onTap();
          },
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.primaryOrange.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              border: Border.all(
                color: AppColors.primaryOrange.withValues(alpha: 0.35),
                width: 1,
              ),
            ),
            child: file == null
                ? Row(
                    children: [
                      const Icon(Icons.upload_file_rounded,
                          color: AppColors.primaryOrange),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Text(
                          hint,
                          style: AppTextStyles.bodySmall
                              .copyWith(color: context.textSecondary),
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      ClipRRect(
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusMd),
                        child: Image.file(
                          file,
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Text(
                          'Document uploaded',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: context.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, size: 20),
                        color: AppColors.error,
                        onPressed: onRemove,
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}
