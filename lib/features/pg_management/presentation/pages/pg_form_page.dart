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
import '../../domain/entities/pg_entity.dart';
import '../providers/pg_provider.dart';

/// Add or edit a PG property.
///
/// When [pg] is null the screen creates a new property; otherwise it edits the
/// supplied one. Saving invalidates the shared PG list so the change is
/// reflected on the dashboard switcher and the Manage PGs screen.
class PgFormPage extends ConsumerStatefulWidget {
  final PgEntity? pg;

  const PgFormPage({super.key, this.pg});

  bool get isEditing => pg != null;

  @override
  ConsumerState<PgFormPage> createState() => _PgFormPageState();
}

class _PgFormPageState extends ConsumerState<PgFormPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _addressController;
  late final TextEditingController _cityController;
  late final TextEditingController _floorsController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;

  static const List<String> _availableAmenities = [
    'WiFi', 'Food / Mess', 'Laundry', 'Parking', 'AC',
    'Power Backup', 'Housekeeping', 'CCTV', 'Hot Water', 'Gym',
  ];
  late final Set<String> _selectedAmenities;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final pg = widget.pg;
    _nameController = TextEditingController(text: pg?.name ?? '');
    _addressController = TextEditingController(text: pg?.address ?? '');
    _cityController = TextEditingController(text: pg?.city ?? '');
    _floorsController = TextEditingController(
      text: pg != null && pg.totalFloors > 0 ? '${pg.totalFloors}' : '',
    );
    _phoneController = TextEditingController(text: pg?.contactPhone ?? '');
    _emailController = TextEditingController(text: pg?.contactEmail ?? '');
    _selectedAmenities = {...?pg?.amenities};
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _floorsController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    setState(() => _isSaving = true);

    final controller = ref.read(pgControllerProvider);
    final name = _nameController.text.trim();
    final address = _addressController.text.trim();
    final city = _cityController.text.trim();
    final floors = int.tryParse(_floorsController.text.trim()) ?? 0;
    final phone = _phoneController.text.trim();
    final email = _emailController.text.trim();
    final amenities = _selectedAmenities.toList();

    try {
      if (widget.isEditing) {
        await controller.updatePg(
          widget.pg!.id,
          name: name,
          address: address,
          city: city,
          totalFloors: floors,
          contactPhone: phone,
          contactEmail: email,
          amenities: amenities,
        );
      } else {
        await controller.createPg(
          name: name,
          address: address,
          city: city,
          totalFloors: floors,
          contactPhone: phone,
          contactEmail: email,
          amenities: amenities,
        );
      }

      if (!mounted) return;
      context.showSnackBar(
        widget.isEditing ? 'PG details updated.' : 'New PG added.',
      );
      context.pop();
    } catch (_) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      context.showSnackBar(
        'Could not save the PG. Please try again.',
        isError: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlassAppBar(
        title: widget.isEditing ? 'Edit PG' : 'Add New PG',
        subtitle: widget.isEditing
            ? 'Update your property details'
            : 'Register a new property',
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
                _buildDetailsSection(),
                const SizedBox(height: AppSpacing.lg),
                _buildContactSection(),
                const SizedBox(height: AppSpacing.lg),
                _buildAmenitiesSection(),
                const SizedBox(height: AppSpacing.xxl),
                GlassButton(
                  label: widget.isEditing ? 'Save Changes' : 'Add PG',
                  icon: Icons.check_rounded,
                  isLoading: _isSaving,
                  onPressed: _isSaving ? null : _handleSubmit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── Property details ──────────────────────────────
  Widget _buildDetailsSection() {
    return _section(
      title: 'Property Details',
      icon: Icons.apartment_rounded,
      children: [
        GlassTextField(
          controller: _nameController,
          label: 'PG Name',
          hint: 'e.g. Sunshine PG Residency',
          prefixIcon: Icons.business_rounded,
          textInputAction: TextInputAction.next,
          validator: (v) => Validators.required(v, 'PG name'),
        ),
        const SizedBox(height: AppSpacing.lg),
        GlassTextField(
          controller: _addressController,
          label: 'Address',
          hint: 'Street, area, landmark',
          prefixIcon: Icons.location_on_outlined,
          textInputAction: TextInputAction.next,
          validator: (v) => Validators.required(v, 'Address'),
        ),
        const SizedBox(height: AppSpacing.lg),
        GlassTextField(
          controller: _cityController,
          label: 'City',
          hint: 'e.g. Bangalore',
          prefixIcon: Icons.location_city_rounded,
          textInputAction: TextInputAction.next,
          validator: (v) => Validators.required(v, 'City'),
        ),
        const SizedBox(height: AppSpacing.lg),
        GlassTextField(
          controller: _floorsController,
          label: 'Total Floors',
          hint: 'Number of floors',
          prefixIcon: Icons.stairs_outlined,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          validator: (v) {
            final floors = int.tryParse((v ?? '').trim());
            if (floors == null || floors <= 0) {
              return 'Enter a valid number of floors';
            }
            return null;
          },
        ),
      ],
    );
  }

  // ─── Contact details ───────────────────────────────
  Widget _buildContactSection() {
    return _section(
      title: 'Contact Details',
      icon: Icons.contact_phone_outlined,
      children: [
        GlassTextField(
          controller: _phoneController,
          label: 'Contact Phone',
          hint: '10-digit mobile number',
          prefixIcon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          validator: Validators.phone,
        ),
        const SizedBox(height: AppSpacing.lg),
        GlassTextField(
          controller: _emailController,
          label: 'Contact Email',
          hint: 'name@example.com',
          prefixIcon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          validator: Validators.email,
        ),
      ],
    );
  }

  // ─── Amenities ─────────────────────────────────────
  Widget _buildAmenitiesSection() {
    return _section(
      title: 'Amenities',
      icon: Icons.checklist_rounded,
      children: [
        Text(
          'Select the facilities available at this PG',
          style: AppTextStyles.caption.copyWith(color: context.textSecondary),
        ),
        const SizedBox(height: AppSpacing.md),
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
