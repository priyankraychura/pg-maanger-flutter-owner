import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/glass_app_bar.dart';
import '../../../../core/widgets/glass_button.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/glass_text_field.dart';
import '../../../../core/widgets/gradient_background.dart';

/// A student that can be assigned to a room from the add-room screen.
class AddRoomStudent {
  final String id;
  final String name;

  const AddRoomStudent({required this.id, required this.name});
}

/// Arguments passed to [AddRoomPage] via the router's `extra`.
class AddRoomArgs {
  /// Students not currently assigned to any room.
  final List<AddRoomStudent> unassignedStudents;

  /// Existing room names, used to reject duplicates.
  final List<String> existingRoomNames;

  const AddRoomArgs({
    required this.unassignedStudents,
    required this.existingRoomNames,
  });
}

/// Result returned to the Rooms tab when a room is saved.
class AddRoomResult {
  final String name;
  final int capacity;
  final List<String> selectedStudentIds;

  const AddRoomResult({
    required this.name,
    required this.capacity,
    required this.selectedStudentIds,
  });
}

/// Form screen for adding a new room and assigning unassigned students to it.
///
/// Opened from the FAB on the Rooms tab. Returns an [AddRoomResult] via
/// `context.pop` when the room is saved.
class AddRoomPage extends StatefulWidget {
  final AddRoomArgs args;

  const AddRoomPage({super.key, required this.args});

  @override
  State<AddRoomPage> createState() => _AddRoomPageState();
}

class _AddRoomPageState extends State<AddRoomPage> {
  final _nameController = TextEditingController();
  final _capacityController = TextEditingController();
  final _selectedIds = <String>{};

  List<AddRoomStudent> get _available => widget.args.unassignedStudents;

  int? get _capacity => int.tryParse(_capacityController.text.trim());

  @override
  void dispose() {
    _nameController.dispose();
    _capacityController.dispose();
    super.dispose();
  }

  void _onCapacityChanged(String _) {
    // Trim the selection if the capacity was reduced below it.
    final capacity = _capacity;
    if (capacity != null) {
      while (_selectedIds.length > capacity) {
        _selectedIds.remove(_selectedIds.last);
      }
    }
    setState(() {});
  }

  void _handleSubmit() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      context.showSnackBar('Enter a room name.', isError: true);
      return;
    }
    final exists = widget.args.existingRoomNames
        .any((n) => n.toLowerCase() == name.toLowerCase());
    if (exists) {
      context.showSnackBar('A room "$name" already exists.', isError: true);
      return;
    }
    final capacity = _capacity;
    if (capacity == null || capacity <= 0) {
      context.showSnackBar('Enter a valid capacity.', isError: true);
      return;
    }
    if (_selectedIds.length > capacity) {
      context.showSnackBar(
        'Selected students exceed the room capacity.',
        isError: true,
      );
      return;
    }

    FocusScope.of(context).unfocus();
    Navigator.of(context).pop(
      AddRoomResult(
        name: name,
        capacity: capacity,
        selectedStudentIds: _selectedIds.toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GlassAppBar(
        title: 'Add Room',
        subtitle: 'Create a room and assign students',
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
              _buildDetailsSection(),
              const SizedBox(height: AppSpacing.lg),
              _buildAssignSection(),
              const SizedBox(height: AppSpacing.xxl),
              GlassButton(
                label: 'Save Room',
                icon: Icons.check_rounded,
                onPressed: _handleSubmit,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Room details ──────────────────────────────────
  Widget _buildDetailsSection() {
    return _section(
      title: 'Room Details',
      icon: Icons.meeting_room_outlined,
      children: [
        GlassTextField(
          controller: _nameController,
          label: 'Room Name / Number',
          hint: 'e.g. 104 or A-101',
          prefixIcon: Icons.meeting_room_outlined,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: AppSpacing.lg),
        GlassTextField(
          controller: _capacityController,
          label: 'Total Capacity',
          hint: 'Number of beds',
          prefixIcon: Icons.people_outline_rounded,
          keyboardType: TextInputType.number,
          onChanged: _onCapacityChanged,
        ),
      ],
    );
  }

  // ─── Assign students ───────────────────────────────
  Widget _buildAssignSection() {
    final capacity = _capacity;

    return _section(
      title: 'Assign Students',
      icon: Icons.group_add_outlined,
      trailing: capacity != null && capacity > 0
          ? Text(
              '${_selectedIds.length}/$capacity',
              style: AppTextStyles.caption.copyWith(
                color: context.textSecondary,
              ),
            )
          : null,
      children: [
        Text(
          'Students not currently assigned to a room',
          style: AppTextStyles.caption.copyWith(
            color: context.textSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        if (_available.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
            child: Text(
              'No unassigned students available.',
              style: AppTextStyles.bodySmall.copyWith(
                color: context.textSecondary,
              ),
            ),
          )
        else
          ..._available.map(_buildStudentTile),
      ],
    );
  }

  Widget _buildStudentTile(AddRoomStudent student) {
    final capacity = _capacity;
    final selected = _selectedIds.contains(student.id);
    final atCapacity =
        capacity != null && _selectedIds.length >= capacity && !selected;

    return CheckboxListTile(
      value: selected,
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
      activeColor: AppColors.primaryOrange,
      title: Text(
        student.name,
        style: AppTextStyles.body.copyWith(
          color: atCapacity ? context.textTertiary : context.textPrimary,
        ),
      ),
      onChanged: atCapacity
          ? null
          : (checked) {
              setState(() {
                if (checked == true) {
                  _selectedIds.add(student.id);
                } else {
                  _selectedIds.remove(student.id);
                }
              });
            },
    );
  }

  // ─── Reusable section card ─────────────────────────
  Widget _section({
    required String title,
    required IconData icon,
    required List<Widget> children,
    Widget? trailing,
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
              if (trailing != null) ...[
                const Spacer(),
                trailing,
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          ...children,
        ],
      ),
    );
  }
}
