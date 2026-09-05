import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/rbac/access_provider.dart';
import '../../../../core/rbac/app_module.dart';
import '../../../../core/rbac/permission_level.dart';
import '../../../../core/rbac/role_permissions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/clipboard_helper.dart';
import '../../../../core/utils/invite_link_builder.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/glass_app_bar.dart';
import '../../../../core/widgets/glass_button.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/glass_dropdown.dart';
import '../../../../core/widgets/glass_text_field.dart';
import '../../../auth/domain/entities/user_role.dart';
import '../../../pg_management/domain/entities/pg_entity.dart';
import '../../../pg_management/presentation/providers/pg_provider.dart';
import '../../domain/entities/staff_entity.dart';
import '../providers/staff_provider.dart';

/// Add or edit a staff member: identity, role, assigned PGs and the per-module
/// View/Edit permission matrix. Saving a new staff produces a 24h invite link.
class StaffFormPage extends ConsumerStatefulWidget {
  final StaffEntity? staff;
  const StaffFormPage({super.key, this.staff});

  bool get isEditing => staff != null;

  @override
  ConsumerState<StaffFormPage> createState() => _StaffFormPageState();
}

class _StaffFormPageState extends ConsumerState<StaffFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _email;
  late final TextEditingController _phone;

  late UserRole _role;
  late Set<String> _pgIds;
  late Map<AppModule, PermissionLevel> _permissions;
  bool _customized = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final s = widget.staff;
    _name = TextEditingController(text: s?.name ?? '');
    _email = TextEditingController(text: s?.email ?? '');
    _phone = TextEditingController(text: s?.phone ?? '');
    _role = s?.role ?? UserRole.manager;
    _pgIds = {...?s?.assignedPgIds};
    _permissions = {
      for (final m in AppModule.values)
        m: s?.permissions[m] ?? defaultPermissionsFor(_role)[m]!,
    };
    _customized = s != null;
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    super.dispose();
  }

  void _onRoleChanged(UserRole role) {
    setState(() {
      _role = role;
      // Re-seed permissions from the new role's template.
      _permissions = {...defaultPermissionsFor(role)};
      _customized = false;
    });
  }

  void _setPermission(AppModule module, PermissionLevel level) {
    setState(() {
      _permissions[module] = level;
      _customized = true;
    });
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_pgIds.isEmpty) {
      context.showSnackBar('Assign at least one PG', isError: true);
      return;
    }

    setState(() => _saving = true);
    final controller = ref.read(staffControllerProvider);
    try {
      if (widget.isEditing) {
        await controller.update(
          widget.staff!.id,
          name: _name.text.trim(),
          phone: _phone.text.trim(),
          role: _role,
          assignedPgIds: _pgIds.toList(),
          permissions: _permissions,
        );
        if (!mounted) return;
        context.showSnackBar('Staff updated');
        context.pop();
      } else {
        final staff = await controller.invite(
          name: _name.text.trim(),
          email: _email.text.trim(),
          phone: _phone.text.trim(),
          role: _role,
          assignedPgIds: _pgIds.toList(),
          permissions: _permissions,
        );
        if (!mounted) return;
        final link = InviteLinkBuilder.buildStaffInviteLink(
          staffId: staff.id,
          name: staff.name,
          email: staff.email,
          phone: staff.phone,
          role: staff.role,
          pgIds: staff.assignedPgIds,
          permissions: staff.permissions,
        );
        await _showInviteDialog(link);
        if (mounted) context.pop();
      }
    } catch (e) {
      if (mounted) context.showSnackBar('Something went wrong: $e', isError: true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _showInviteDialog(String link) {
    return showDialog<void>(
      context: context,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return Dialog(
          backgroundColor:
              isDark ? AppColors.darkSurface : AppColors.lightSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.link_rounded,
                      color: AppColors.success, size: AppSpacing.iconXl),
                ),
                const SizedBox(height: AppSpacing.xl),
                Text('Invite link ready',
                    style: AppTextStyles.h2.copyWith(color: ctx.textPrimary)),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Share this link with ${_name.text.trim()}. It lets them set a '
                  'password and sign in, and expires in 24 hours.',
                  style:
                      AppTextStyles.body.copyWith(color: ctx.textSecondary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.lg),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: ctx.isDark
                        ? Colors.white.withValues(alpha: 0.05)
                        : Colors.black.withValues(alpha: 0.04),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                  child: Text(
                    link,
                    style: AppTextStyles.caption
                        .copyWith(color: ctx.textSecondary),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                Row(
                  children: [
                    Expanded(
                      child: GlassButton.outlined(
                        label: 'Done',
                        onPressed: () => Navigator.of(ctx).pop(),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: GlassButton(
                        label: 'Copy link',
                        icon: Icons.copy_rounded,
                        onPressed: () async {
                          await ClipboardHelper.copy(ctx, link,
                              message: 'Invite link copied');
                          if (ctx.mounted) Navigator.of(ctx).pop();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final pgsAsync = ref.watch(pgListProvider);
    // Only the modules the current principal may themselves edit can be granted
    // to others — you cannot delegate access you don't have.
    final access = ref.watch(accessPolicyProvider);

    return Scaffold(
      appBar: GlassAppBar(
        title: widget.isEditing ? 'Edit Staff' : 'Add Staff',
        subtitle: widget.isEditing ? _email.text : 'Invite a manager or helper',
        showBackButton: true,
      ),
      body: SafeArea(
        top: false,
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.screenPadding,
              AppSpacing.lg,
              AppSpacing.screenPadding,
              AppSpacing.xxl + context.bottomPadding,
            ),
            children: [
              GlassTextField(
                controller: _name,
                label: 'Full name',
                hint: 'e.g. Ravi Kumar',
                prefixIcon: Icons.person_outline_rounded,
                validator: Validators.name,
              ),
              const SizedBox(height: AppSpacing.lg),
              GlassTextField(
                controller: _email,
                label: 'Email',
                hint: 'name@example.com',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                readOnly: widget.isEditing,
                enabled: !widget.isEditing,
                validator: Validators.email,
              ),
              const SizedBox(height: AppSpacing.lg),
              GlassTextField(
                controller: _phone,
                label: 'Phone number',
                hint: '10-digit mobile number',
                prefixIcon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                validator: Validators.phone,
              ),
              const SizedBox(height: AppSpacing.lg),
              GlassDropdown<UserRole>(
                label: 'Role',
                value: _role,
                prefixIcon: Icons.shield_outlined,
                items: UserRole.values
                    .map((r) => DropdownMenuItem(
                          value: r,
                          child: Text(r.displayName),
                        ))
                    .toList(),
                onChanged: (r) => r != null ? _onRoleChanged(r) : null,
              ),
              const SizedBox(height: AppSpacing.xl),

              // Assigned PGs
              Text('Assigned PGs',
                  style: AppTextStyles.inputLabel
                      .copyWith(color: context.textSecondary)),
              const SizedBox(height: AppSpacing.sm),
              pgsAsync.when(
                loading: () => const Padding(
                  padding: EdgeInsets.all(AppSpacing.md),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, _) => Text('Could not load PGs: $e',
                    style: AppTextStyles.caption
                        .copyWith(color: AppColors.error)),
                data: (pgs) => _PgSelector(
                  pgs: pgs,
                  selected: _pgIds,
                  onToggle: (id) => setState(() {
                    _pgIds.contains(id) ? _pgIds.remove(id) : _pgIds.add(id);
                  }),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Permission matrix
              Row(
                children: [
                  Text('Permissions',
                      style: AppTextStyles.inputLabel
                          .copyWith(color: context.textSecondary)),
                  const SizedBox(width: AppSpacing.sm),
                  if (_customized)
                    Text('• customized',
                        style: AppTextStyles.caption
                            .copyWith(color: AppColors.primaryOrange)),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => _onRoleChanged(_role),
                    child: Text('Reset to ${_role.displayName} default',
                        style: AppTextStyles.caption
                            .copyWith(color: AppColors.primaryOrange)),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              GlassCard(
                margin: EdgeInsets.zero,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                child: Column(
                  children: [
                    for (final module in kAssignableModules)
                      _PermissionRow(
                        module: module,
                        level: _permissions[module] ?? PermissionLevel.none,
                        // Can't grant access to a module you can't edit yourself.
                        enabled: access.canEdit(module),
                        onChanged: (lvl) => _setPermission(module, lvl),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              GlassButton(
                label: widget.isEditing ? 'Save changes' : 'Create invite link',
                icon: widget.isEditing
                    ? Icons.save_rounded
                    : Icons.link_rounded,
                isLoading: _saving,
                onPressed: _saving ? null : _save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PgSelector extends StatelessWidget {
  final List<PgEntity> pgs;
  final Set<String> selected;
  final ValueChanged<String> onToggle;

  const _PgSelector({
    required this.pgs,
    required this.selected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    if (pgs.isEmpty) {
      return Text('No PGs available',
          style: AppTextStyles.caption.copyWith(color: context.textTertiary));
    }
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: pgs.map((pg) {
        final isSelected = selected.contains(pg.id);
        return GestureDetector(
          onTap: () => onToggle(pg.id),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primaryOrange.withValues(alpha: 0.15)
                  : (context.isDark
                      ? Colors.white.withValues(alpha: 0.05)
                      : Colors.black.withValues(alpha: 0.04)),
              borderRadius: BorderRadius.circular(AppSpacing.radiusRound),
              border: Border.all(
                color: isSelected
                    ? AppColors.primaryOrange
                    : Colors.transparent,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isSelected
                      ? Icons.check_circle_rounded
                      : Icons.circle_outlined,
                  size: 16,
                  color: isSelected
                      ? AppColors.primaryOrange
                      : context.textTertiary,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  pg.name,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isSelected
                        ? AppColors.primaryOrange
                        : context.textPrimary,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _PermissionRow extends StatelessWidget {
  final AppModule module;
  final PermissionLevel level;
  final bool enabled;
  final ValueChanged<PermissionLevel> onChanged;

  const _PermissionRow({
    required this.module,
    required this.level,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1 : 0.4,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          children: [
            Icon(module.icon, size: 18, color: context.textSecondary),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                module.displayName,
                style: AppTextStyles.bodySmall
                    .copyWith(color: context.textPrimary),
              ),
            ),
            _LevelSelector(
              level: level,
              onChanged: enabled ? onChanged : null,
            ),
          ],
        ),
      ),
    );
  }
}

/// Compact None / View / Edit segmented control.
class _LevelSelector extends StatelessWidget {
  final PermissionLevel level;
  final ValueChanged<PermissionLevel>? onChanged;

  const _LevelSelector({required this.level, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.isDark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.black.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(AppSpacing.radiusRound),
      ),
      padding: const EdgeInsets.all(2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: PermissionLevel.values.map((lvl) {
          final active = lvl == level;
          return GestureDetector(
            onTap: onChanged == null ? null : () => onChanged!(lvl),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xxs,
              ),
              decoration: BoxDecoration(
                color: active ? AppColors.primaryOrange : Colors.transparent,
                borderRadius: BorderRadius.circular(AppSpacing.radiusRound),
              ),
              child: Text(
                _short(lvl),
                style: AppTextStyles.caption.copyWith(
                  color: active ? Colors.white : context.textTertiary,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _short(PermissionLevel lvl) {
    switch (lvl) {
      case PermissionLevel.none:
        return 'None';
      case PermissionLevel.view:
        return 'View';
      case PermissionLevel.edit:
        return 'Edit';
    }
  }
}
