import '../../core/rbac/role_permissions.dart';
import '../../features/auth/domain/entities/owner_entity.dart';
import '../../features/auth/domain/entities/user_role.dart';

/// Id of the primary owner account. Used as the `createdBy` / `updatedBy`
/// foreign key on records seeded by the owner (notices, wifi, menu, …) so the
/// value lives in one place.
const String kPrimaryOwnerId = 'owner_001';

/// `owners` table — the account records that can sign in to the owner app.
List<OwnerEntity> seedOwners() => [
      OwnerEntity(
        id: kPrimaryOwnerId,
        name: 'Priyank Sharma',
        email: 'priyank@pgmanager.com',
        phone: '9876543210',
        role: UserRole.admin,
        isSuperAdmin: true,
        assignedPgIds: const ['pg_001', 'pg_002'],
        permissions: defaultPermissionsFor(UserRole.admin),
        joinDate: DateTime(2024, 3, 15),
      ),
    ];
