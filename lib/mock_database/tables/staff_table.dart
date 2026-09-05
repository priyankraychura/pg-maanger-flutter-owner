import '../../core/rbac/app_module.dart';
import '../../core/rbac/permission_level.dart';
import '../../core/rbac/role_permissions.dart';
import '../../features/auth/domain/entities/user_role.dart';
import '../../features/roles/domain/entities/staff_entity.dart';

/// `staff` table — manager/helper/admin accounts and the PGs & per-module
/// permissions they can access.
///
/// Sign in with any of these emails (any password) to experience the app as
/// that staff member — the mock auth resolves the principal from this table.
List<StaffEntity> seedStaff() => [
      // A manager with the default manager template, fine-tuned so payments is
      // view-only (shows that per-staff overrides work).
      StaffEntity(
        id: 's1',
        name: 'Ravi Kumar',
        email: 'ravi.manager@pgmanager.com',
        phone: '9876543250',
        role: UserRole.manager,
        assignedPgIds: const ['pg_001'],
        permissions: {
          ...defaultPermissionsFor(UserRole.manager),
          AppModule.payments: PermissionLevel.view,
        },
        joinDate: DateTime(2024, 6, 1),
        status: StaffStatus.active,
      ),
      // A helper on the default helper template (mostly view-only).
      StaffEntity(
        id: 's2',
        name: 'Suresh Helper',
        email: 'suresh@pgmanager.com',
        phone: '9876543251',
        role: UserRole.helper,
        assignedPgIds: const ['pg_001', 'pg_002'],
        permissions: defaultPermissionsFor(UserRole.helper),
        joinDate: DateTime(2024, 8, 15),
        status: StaffStatus.active,
      ),
    ];
